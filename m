From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: kernel addresses
Date: 29 Oct 2002 01:07:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035853629.1945.121.camel@irongate.swansea.linux.org.uk>
References: <20021029003600.3022.qmail@web80310.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021029003600.3022.qmail@web80310.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2002-10-29 at 00:36, Mark Lobo wrote:
> So in that case, what exactly happens say when a user
> app allocated a buffer for a write to a disk, and
> passes it down to the top level driver. When he
> mallocs that buffer, his address will be a user
> address. And when it comes down to the initiator
> driver it has to be a kernel address.  So when you say

It might be a mapped user buffer, it might be kernel allocated, you
don't know, you can't tell, you don't need to tell. You get given a
valid kernel address.

> Also, Im using a 2.4 kernel. So does this statement
> still apply:
> "When DMA I/O is performed to or from high memory, an
> area is allocated in low memory known as a bounce
> buffer. When data travels between a device and high
> memory, it is first copied through the bounce buffer."
> So if low memory is memory that can be addresses
> directl y by the kernel, and high memory is say a user
> allocated buffer (?), do I still have to do what the
> patch wants me to do? When does he mid layer decide in
> this case to allocate a bounce buffer? In this case is
> the "low" and "high" limit the ISA limit that the
> driver indicates in the host template structure while
> initialization?

The ISA limit if the template says unchecked_isa_dma: 1, otherwise the
low memory limit. On 2.5 its done by the pci limits and instead of an
address you get passed a 32bit page number and offset (so you can do
64bit DMA sanely)


