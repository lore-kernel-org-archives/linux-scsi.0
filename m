From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Re: kernel addresses
Date: Mon, 28 Oct 2002 16:36:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021029003600.3022.qmail@web80310.mail.yahoo.com>
References: <1035850954.3551.115.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1035850954.3551.115.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

Alan,
So in that case, what exactly happens say when a user
app allocated a buffer for a write to a disk, and
passes it down to the top level driver. When he
mallocs that buffer, his address will be a user
address. And when it comes down to the initiator
driver it has to be a kernel address.  So when you say

" Not having the user application memory mapped would
require page table changes whenever we make a system
call - which is expensive.", does it mean all user
space addresses are permanently mapped to a kernel
address ( ioremapped )? If yes, how can that work,
because the mapping between the user virtual address
and the physical pages will be different at all times?
So how can we avoid building page tables again to get
a kernel view of the same memory?

Also, Im using a 2.4 kernel. So does this statement
still apply:
"When DMA I/O is performed to or from high memory, an
area is allocated in low memory known as a bounce
buffer. When data travels between a device and high
memory, it is first copied through the bounce buffer."
So if low memory is memory that can be addresses
directl y by the kernel, and high memory is say a user
allocated buffer (?), do I still have to do what the
patch wants me to do? When does he mid layer decide in
this case to allocate a bounce buffer? In this case is
the "low" and "high" limit the ISA limit that the
driver indicates in the host template structure while
initialization?

Thanks!
Mark

--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 2002-10-28 at 23:54, Mark Lobo wrote:
> > Can vmalloced memory be used for DMA? an API will
> be
> 
> Simple answer is no. There are ways to do it but
> they are not nice
> and shouldn't ever be needed. A couple of video
> capture drivers do
> it because they need large internal buffers.
> 
> > Also, I still dont understand what is "low memory"
> and
> > "high memory". Why/how dont the older kernels
> support
> > high memory? 
> 
> Low/high is ambiguous so Im not actually sure. We
> have the following
> limits
> 
> 16Mb			DMA region 		(GFP_DMA)
> 900Mb (approximately)	Directly kernel mapped memory 
> (kmalloc/kernel
> 			page tables/pci mappings/vmalloc space etc)
> 4Gb			32bit PCI DMA limit
> 64Gb			Xeon memory limit
> 
> (We can't actually reach the 64Gb for other reasons)
> 
> 
> Memory below the 900Mb boundary is directly
> accessible to the kernel,
> memory above that is only mapped on demand. This is
> done because the
> actual memory map looks like
> 
> --- 0 ----
> 
> Current user space application
> 
> ---- 0xC0000000 ----
> 
> Kernel map to physical 0-> 900Mb
> 
> ----- ?????? -----
> 
> vmalloc/ioremap space
> 
> ---- 0xFFFFFFFF ----
> 
> 
> Not having the user application memory mapped would
> require page table
> changes whenever we make a system call - which is
> expensive. 
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
