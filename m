From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: kernel addresses
Date: 29 Oct 2002 00:22:34 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035850954.3551.115.camel@irongate.swansea.linux.org.uk>
References: <20021028235433.90095.qmail@web80309.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021028235433.90095.qmail@web80309.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2002-10-28 at 23:54, Mark Lobo wrote:
> Can vmalloced memory be used for DMA? an API will be

Simple answer is no. There are ways to do it but they are not nice
and shouldn't ever be needed. A couple of video capture drivers do
it because they need large internal buffers.

> Also, I still dont understand what is "low memory" and
> "high memory". Why/how dont the older kernels support
> high memory? 

Low/high is ambiguous so Im not actually sure. We have the following
limits

16Mb			DMA region 		(GFP_DMA)
900Mb (approximately)	Directly kernel mapped memory  (kmalloc/kernel
			page tables/pci mappings/vmalloc space etc)
4Gb			32bit PCI DMA limit
64Gb			Xeon memory limit

(We can't actually reach the 64Gb for other reasons)


Memory below the 900Mb boundary is directly accessible to the kernel,
memory above that is only mapped on demand. This is done because the
actual memory map looks like

--- 0 ----

Current user space application

---- 0xC0000000 ----

Kernel map to physical 0-> 900Mb

----- ?????? -----

vmalloc/ioremap space

---- 0xFFFFFFFF ----


Not having the user application memory mapped would require page table
changes whenever we make a system call - which is expensive. 


