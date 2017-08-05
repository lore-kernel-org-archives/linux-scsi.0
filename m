From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Sat, 5 Aug 2017 10:27:04 +0100
Message-ID: <20170805092704.GD20914@redhat.com>
References: <20170804210035.GA10017@redhat.com>
 <20170805084436.GA14264@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170805084436.GA14264@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 05, 2017 at 10:44:36AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 04, 2017 at 10:00:47PM +0100, Richard W.M. Jones wrote:
> > I read your slides about scsi-mq and it seems like a significant
> > benefit to large machines, but could the out of the box defaults be
> > made more friendly for small memory machines?
> 
> The default inumber of queues and queue depth and thus memory usage is
> set by the LLDD.
> 
> Try to reduce the can_queue value in virtio_scsi and/or make sure
> you use the single queue variant in your VM (which should be tunable
> in qemu).

Thanks, this is interesting.

Virtio-scsi seems to have a few settable parameters that might be
related to this:

  DEFINE_PROP_UINT32("num_queues", VirtIOSCSI, parent_obj.conf.num_queues, 1),
  DEFINE_PROP_UINT32("max_sectors", VirtIOSCSI, parent_obj.conf.max_sectors,
                                                0xFFFF),
  DEFINE_PROP_UINT32("cmd_per_lun", VirtIOSCSI, parent_obj.conf.cmd_per_lun,
                                                128),

Unfortunately (assuming I'm setting them right - see below), none of
them have any effect on the number of disks that I can add to the VM.

I am testing them by placing them in the ‘-device virtio-scsi-pci’
parameter, ie. as a property of the controller, not a property of the
LUN, eg:

    -device virtio-scsi-pci,cmd_per_lun=32,id=scsi \
    -drive file=/home/rjones/d/libguestfs/tmp/libguestfshXImTv/scratch.1,cache=unsafe,format=raw,id=hd0,if=none \
    -device scsi-hd,drive=hd0 \

The debugging output is a bit too large to attach to this email, but I
have placed it at the link below.  It contains (if you scroll down a
bit) the full qemu command line and full kernel output.

  http://oirase.annexia.org/tmp/bz1478201-log.txt

I can add some extra debugging into the kernel if you like.  Just
point me to the right place.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html
