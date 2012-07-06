From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 05 Jul 2012 20:38:13 -0700
Message-ID: <1341545893.23954.325.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF56AE9.9060201@redhat.com>  <20120705135318.GG30572@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120705135318.GG30572@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-05 at 16:53 +0300, Michael S. Tsirkin wrote:
> On Thu, Jul 05, 2012 at 12:22:33PM +0200, Paolo Bonzini wrote:
> > Il 05/07/2012 03:52, Nicholas A. Bellinger ha scritto:
> > > 
> > > fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
> > > ------------------------------------------------------------------------------------
> > > 25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
> > > 75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K
> > 
> > This is impressive, but I think it's still not enough to justify the
> > inclusion of tcm_vhost.  In my opinion, vhost-blk/vhost-scsi are mostly
> > worthwhile as drivers for improvements to QEMU performance.  We want to
> > add more fast paths to QEMU that let us move SCSI and virtio processing
> > to separate threads, we have proof of concepts that this can be done,
> > and we can use vhost-blk/vhost-scsi to find bottlenecks more effectively.
> 
> A general rant below:
> 
> OTOH if it works, and adds value, we really should consider including code.
> To me, it does not make sense to reject code just because in theory
> someone could write even better code. Code walks. Time to marker matters too.
> Yes I realize more options increases support. But downstreams can make
> their own decisions on whether to support some configurations:
> add a configure option to disable it and that's enough.
> 

+1 for mst here.

I think that type of sentiment deserves a toast at KS/LC in August.  ;)

> > In fact, virtio-scsi-qemu and virtio-scsi-vhost are effectively two
> > completely different devices that happen to speak the same SCSI
> > transport.  Not only virtio-scsi-vhost must be configured outside QEMU
> 
> configuration outside QEMU is OK I think - real users use
> management anyway. But maybe we can have helper scripts
> like we have for tun?
> 
> > and doesn't support -device;
> 
> This needs to be fixed I think.
> 
> > it (obviously) presents different
> > inquiry/vpd/mode data than virtio-scsi-qemu,
> 
> Why is this obvious and can't be fixed? Userspace virtio-scsi
> is pretty flexible - can't it supply matching inquiry/vpd/mode data
> so that switching is transparent to the guest?
> 

So I imagine that setting inquiry/vpd/mode via configfs attribs to match
whatever the guest wants to see (or expects to see) can be enabled
via /sys/kernel/config/target/core/$HBA/$DEV/[wwn,attrib]/ easily to
whatever is required.

However, beyond basic SCSI WWN related bits, I would avoid trying to
match complex SCSI target state between the in-kernel patch and QEMU
SCSI.  We've had this topic come up numerous times over the nears for
other fabric modules (namely iscsi-target) and usually it end's up with
a long email thread re-hashing history of failures until Linus starts
yelling at the person who is pushing complex kernel <-> user split.

The part where I start to get nervous is where you get into the cluster
+ multipath features.  We have methods in TCM core that rebuild the
exact state of this bits based upon external file metadata, based upon
the running configfs layout.  This is used by physical node failover +
re-takeover to ensure the SCSI client sees exactly the same SCSI state.

Trying to propagate up this type of complexity is where I think you go
overboard.  KISS and let's let fabric independent configfs (leaning on
vfs) do the hard work for tracking these types of SCSI relationships.

> > so that it is not possible to migrate one to the other.
> 
> Migration between different backend types does not seem all that useful.
> The general rule is you need identical flags on both sides to allow
> migration, and it is not clear how valuable it is to relax this
> somewhat.
> 

I really need to learn more about how QEMU Live migration works wrt to
storage before saying how this may (or may not) work.

We certainly have no problems doing physical machine failover with
target_core_mod for iscsi-target, and ATM I don't see why the QEMU
userspace process driving the real-time configfs configuration of the
storage fabric would not work..

> > I don't think vhost-scsi is particularly useful for virtualization,
> > honestly.  However, if it is useful for development, testing or
> > benchmarking of lio itself (does this make any sense? :)) that could be
> > by itself a good reason to include it.
> > 
> > Paolo
> 
