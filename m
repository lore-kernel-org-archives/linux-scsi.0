From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Fri, 06 Jul 2012 07:39:43 +0200
Message-ID: <4FF67A1F.5080507@redhat.com>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com>
	<1341545893.23954.325.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1341545893.23954.325.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Il 06/07/2012 05:38, Nicholas A. Bellinger ha scritto:
> So I imagine that setting inquiry/vpd/mode via configfs attribs to match
> whatever the guest wants to see (or expects to see) can be enabled
> via /sys/kernel/config/target/core/$HBA/$DEV/[wwn,attrib]/ easily to
> whatever is required.
> 
> However, beyond basic SCSI WWN related bits, I would avoid trying to
> match complex SCSI target state between the in-kernel patch and QEMU
> SCSI.

Agreed.  It should just be the bare minimum to make stable /dev/disk
paths, well, stable between the two backends.

>>> so that it is not possible to migrate one to the other.
>>
>> Migration between different backend types does not seem all that useful.
>> The general rule is you need identical flags on both sides to allow
>> migration, and it is not clear how valuable it is to relax this
>> somewhat.
> 
> I really need to learn more about how QEMU Live migration works wrt to
> storage before saying how this may (or may not) work.

vhost-scsi live migration should be easy to fix.  You need some ioctl or
eventfd mechanism to communicate to userspace that there is no pending
I/O, but you need that anyway also for other operations (as simple as
stopping the VM: QEMU guarantees that the "stop" monitor command returns
only when there is no outstanding I/O).

What worries me most is: 1) the amount of functionality that is lost
with vhost-scsi, especially the new live operations that we're adding to
QEMU; 2) whether any hook we introduce in the QEMU block layer will
cause problems down the road when we set to fix the existing
virtio-blk/virtio-scsi-qemu performance problems.  This is the reason
why I'm reluctant to merge the QEMU bits.  The kernel bits are
self-contained and are much less problematic.

It may well be that _the same_ (or very similar) hooks will be needed by
both tcm_vhost and high-performance userspace virtio backends.  This
would of course remove the objection.

Paolo
