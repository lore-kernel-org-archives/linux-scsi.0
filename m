From: Jens Axboe <axboe@suse.de>
Subject: Re: Bounce buffer usage
Date: Fri, 1 Nov 2002 08:48:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101074843.GF807@suse.de>
References: <3DBF3E43.2000503@torque.net> <20021101001632.48278.qmail@web80301.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021101001632.48278.qmail@web80301.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 31 2002, Mark Lobo wrote:
> Guys,
> Simple question on bounce buffer usage.
> As of my understanding right now, a bounce buffer will
> not be used if 
> 1) We say we dont support over a fixed number of
> address bits, for example, ISA devices.

Correct, if unchecked_isa_dma is set for instance.

> 2) If the address of the buffer is not in a space
> directly addressable by the kernel ( not in kernel
> logical address space )

Not so true anymore in 2.4.20-pre (and hasn't been true in 2.5 since
2.5.1). If you set host highmem_io flag, it will be happy to pass you
pages that have no kernel virtual mapping.

> Now my question is: what happens in the case where an
> application sends an IO down? are bounce buffers used
> in that case? I guess I am still confused on kernel

You just outlined the bounce scenarious above yourself :-). If the
buffer sent down resides at a higher address than what the adapter can
handle, then it is bounced. This may not necessarily have anything to do
with kernel virtual mapping or not.

> virtual v/s kernel logical addresses. As I understand,
> a kernel logical address is one that is directly
> addressable by the kernel, and is limited to 1GB. So

For the standard kernels split, you are looking at 896MiB of memory. So
a little under a gig.

> if we have a system with 2GB, does it mean some of the
> physical memory ( probably 1GB )  has a kernel logical
> address assigned to it permanently and the other 1GB
> does not, which means if a user happens to get a page
> in that space, there will be no logical address ( and
> therefore bounce buffers WILL be used? ).
> Or is any user address not mapped in the kernel
> "logical" space at all? 

Yes this is what happens per default, in 2.4.19 and below. As mentioned
above, in 2.4.20 the virtual mapping of the page has nothing to do with
the ability to read/write to it. It requires a driver that uses the pci
dma api properly - if it does, it can set host_template->highmem_io to
tell the kernel it doesnt need to have anything below 4GB bounced (or
64GB, or more, depends on the pci device).

-- 
Jens Axboe

