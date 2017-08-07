From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Increased memory usage with scsi-mq
Date: Mon, 7 Aug 2017 13:27:02 +0100
Message-ID: <20170807122701.GH20914@redhat.com>
References: <20170804210035.GA10017@redhat.com>
 <20170805084436.GA14264@lst.de>
 <20170805092704.GD20914@redhat.com>
 <20170805133954.GA17694@lst.de>
 <20170805155103.GE20914@redhat.com>
 <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b133b97e-9660-ba9b-51de-39fa23fce903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 07, 2017 at 02:11:39PM +0200, Paolo Bonzini wrote:
> You could also add a module parameter to the driver, and set it to 64 on
> the kernel command line (there is an example in
> drivers/scsi/vmw_pvscsi.c of how to do it).

[Proviso: I've not tested the performance of difference values, nor do
I have any particular knowledge in this area]

can_queue is documented as:

         * This determines if we will use a non-interrupt driven
         * or an interrupt driven scheme.  It is set to the maximum number
         * of simultaneous commands a given host adapter will accept.

Wouldn't it be better to make it default to k * number of CPUs for
some small integer k?

I looked at the other scsi drivers and they set it to all kinds of
values.  1, small integers, large integers, configurable values.

Also I noticed this code in virtio_scsi.c:

        cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
        shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);

but setting cmd_per_lun (as a qemu virtio-scsi-pci parameter) didn't
seem to make any difference to memory usage.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
