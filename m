From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 5 Jul 2012 17:40:01 +0300
Message-ID: <20120705144001.GB31257@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com>
	<4FF59F6B.2000101@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4FF59F6B.2000101@us.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2012 at 09:06:35AM -0500, Anthony Liguori wrote:
> On 07/05/2012 08:53 AM, Michael S. Tsirkin wrote:
> >On Thu, Jul 05, 2012 at 12:22:33PM +0200, Paolo Bonzini wrote:
> >>Il 05/07/2012 03:52, Nicholas A. Bellinger ha scritto:
> >>>
> >>>fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> >>>------------------------------------------------------------------------------------
> >>>25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> >>>75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K
> >>
> >>This is impressive, but I think it's still not enough to justify the
> >>inclusion of tcm_vhost.
> 
> We have demonstrated better results at much higher IOP rates with
> virtio-blk in userspace so while these results are nice, there's no
> reason to believe we can't do this in userspace.
> 
> >>In my opinion, vhost-blk/vhost-scsi are mostly
> >>worthwhile as drivers for improvements to QEMU performance.  We want to
> >>add more fast paths to QEMU that let us move SCSI and virtio processing
> >>to separate threads, we have proof of concepts that this can be done,
> >>and we can use vhost-blk/vhost-scsi to find bottlenecks more effectively.
> >
> >A general rant below:
> >
> >OTOH if it works, and adds value, we really should consider including code.
> 
> Users want something that has lots of features and performs really,
> really well.  They want everything.
> 
> Having one device type that is "fast" but has no features and
> another that is "not fast" but has a lot of features forces the user
> to make a bad choice.  No one wins in the end.
>
> virtio-scsi is brand new.  It's not as if we've had any significant
> time to make virtio-scsi-qemu faster.  In fact, tcm_vhost existed
> before virtio-scsi-qemu did if I understand correctly.

Can't same can be said about virtio scsi - it seems to be
slower so we force a bad choice between blk and scsi at the user?

> 
> >To me, it does not make sense to reject code just because in theory
> >someone could write even better code.
> 
> There is no theory.  We have proof points with virtio-blk.
> 
> >Code walks. Time to marker matters too.
> 
> But guest/user facing decisions cannot be easily unmade and making
> the wrong technical choices because of premature concerns of "time
> to market" just result in a long term mess.
> 
> There is no technical reason why tcm_vhost is going to be faster
> than doing it in userspace.

But doing what in userspace exactly?

> We can demonstrate this with
> virtio-blk.  This isn't a theoretical argument.
>
> >Yes I realize more options increases support. But downstreams can make
> >their own decisions on whether to support some configurations:
> >add a configure option to disable it and that's enough.
> >
> >>In fact, virtio-scsi-qemu and virtio-scsi-vhost are effectively two
> >>completely different devices that happen to speak the same SCSI
> >>transport.  Not only virtio-scsi-vhost must be configured outside QEMU
> >
> >configuration outside QEMU is OK I think - real users use
> >management anyway. But maybe we can have helper scripts
> >like we have for tun?
> 
> Asking a user to write a helper script is pretty awful...

A developer can write a helper. A user should just use management.

> >
> >>and doesn't support -device;
> >
> >This needs to be fixed I think.
> >
> >>it (obviously) presents different
> >>inquiry/vpd/mode data than virtio-scsi-qemu,
> >
> >Why is this obvious and can't be fixed?
> 
> It's an entirely different emulation path.  It's not a simple packet
> protocol like virtio-net.  It's a complex command protocol where the
> backend maintains a very large amount of state.
>
> >Userspace virtio-scsi
> >is pretty flexible - can't it supply matching inquiry/vpd/mode data
> >so that switching is transparent to the guest?
> 
> Basically, the issue is that the kernel has more complete SCSI
> emulation that QEMU does right now.
> 
> There are lots of ways to try to solve this--like try to reuse the
> kernel code in userspace or just improving the userspace code.  If
> we were able to make the two paths identical, then I strongly
> suspect there'd be no point in having tcm_vhost anyway.
>
> Regards,
> 
> Anthony Liguori

However, a question we should ask ourselves is whether this will happen
in practice, and when.

I have no idea, I am just asking questions.

-- 
MST
