From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Fri, 6 Jul 2012 00:00:45 +0300
Message-ID: <20120705210044.GI31257@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com>
	<4FF5A57F.2000504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4FF5A57F.2000504@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2012 at 04:32:31PM +0200, Paolo Bonzini wrote:
> Il 05/07/2012 15:53, Michael S. Tsirkin ha scritto:
> > On Thu, Jul 05, 2012 at 12:22:33PM +0200, Paolo Bonzini wrote:
> >> Il 05/07/2012 03:52, Nicholas A. Bellinger ha scritto:
> >>>
> >>> fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> >>> ------------------------------------------------------------------------------------
> >>> 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> >>> 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K
> >>
> >> This is impressive, but I think it's still not enough to justify the
> >> inclusion of tcm_vhost.  In my opinion, vhost-blk/vhost-scsi are mostly
> >> worthwhile as drivers for improvements to QEMU performance.  We want to
> >> add more fast paths to QEMU that let us move SCSI and virtio processing
> >> to separate threads, we have proof of concepts that this can be done,
> >> and we can use vhost-blk/vhost-scsi to find bottlenecks more effectively.
> > 
> > A general rant below:
> > 
> > OTOH if it works, and adds value, we really should consider including code.
> > To me, it does not make sense to reject code just because in theory
> > someone could write even better code.
> 
> It's not about writing better code.  It's about having two completely
> separate SCSI/block layers with completely different feature sets.

You mean qemu one versus kernel one? Both exist anyway :)

> > Code walks. Time to marker matters too.
> > Yes I realize more options increases support. But downstreams can make
> > their own decisions on whether to support some configurations:
> > add a configure option to disable it and that's enough.
> > 
> >> In fact, virtio-scsi-qemu and virtio-scsi-vhost are effectively two
> >> completely different devices that happen to speak the same SCSI
> >> transport.  Not only virtio-scsi-vhost must be configured outside QEMU
> > 
> > configuration outside QEMU is OK I think - real users use
> > management anyway. But maybe we can have helper scripts
> > like we have for tun?
> 
> We could add hooks for vhost-scsi in the SCSI devices and let them
> configure themselves.  I'm not sure it is a good idea.

This is exactly what virtio-net does.

> >> and doesn't support -device;
> > 
> > This needs to be fixed I think.
> 
> To be clear, it supports -device for the virtio-scsi HBA itself; it
> doesn't support using -drive/-device to set up the disks hanging off it.

Fixable, isn't it?

> >> it (obviously) presents different
> >> inquiry/vpd/mode data than virtio-scsi-qemu,
> > 
> > Why is this obvious and can't be fixed? Userspace virtio-scsi
> > is pretty flexible - can't it supply matching inquiry/vpd/mode data
> > so that switching is transparent to the guest?
> 
> It cannot support anyway the whole feature set unless you want to port
> thousands of lines from the kernel to QEMU (well, perhaps we'll get
> there but it's far.  And dually, the in-kernel target of course does not
> support qcow2 and friends though perhaps you could imagine some hack
> based on NBD.
> 
> Paolo

Exactly. Kernel also gains functionality all the time.

-- 
MST
