From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Re: Bounce buffer usage
Date: Fri, 1 Nov 2002 10:55:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101185510.10154.qmail@web80305.mail.yahoo.com>
References: <20021101074843.GF807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021101074843.GF807@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org


> Not so true anymore in 2.4.20-pre (and hasn't been
> true in 2.5 since
> 2.5.1). If you set host highmem_io flag,> 

So if I do set this flag in the host template, do I
need the bounce buffer patch also that is floating
around? Or is it just enough to set that flag and use
the DMA API? Im using 2.4.18.

 it will be
> happy to pass you
> pages that have no kernel virtual mapping.

Pages that have no kernel virtual mapping? Do u mean
pages with no kernel "logical" mapping? We finally
need a kernel mapping, dont we? say if it is data in a
single page ( no scatter gather ), what kind of
address is passed down to the driver? Is it the pure
user address that is just passed down, and the DMA API
then gives the kernel address? cause we do need to do
a virt_to_page in this case before we can use the DMA
API, so what kind of virtual address is passed down to
the initiator?

>If the
> buffer sent down resides at a higher address than
> what the adapter can
> handle, then it is bounced. This may not necessarily
> have anything to do
> with kernel virtual mapping or not.

But if a buffer resides in high memory, and has no
kernel logical mapping, doesnt it mean that bounce
buffers will be used, especially in 2.4.18, without
the highmem_io bit set?


Thanks a lot!
Mark


__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
