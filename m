From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Re: kernel addresses
Date: Mon, 28 Oct 2002 15:54:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028235433.90095.qmail@web80309.mail.yahoo.com>
References: <1035847574.3550.109.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1035847574.3550.109.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

Alan
Can vmalloced memory be used for DMA? an API will be
needed to get the physical address and sizes of the
segments of the buffer. Looks like virt_to_phys and
phys_to_virt work only on kernel "logical" addresses,
i.e. a constant offset difference. So is there any API
to get the physical addresses of the vmalloced
buffers?
( I havent dug into the DMA API in great detail, so
pardon me if that is exactly what it does)Also, Im
still not sure why we even need kernel logical
addresses separate from kernel "virtual" address? Why
not have just a single kernel virtual address?

Also, I still dont understand what is "low memory" and
"high memory". Why/how dont the older kernels support
high memory? 
 
Sorry if Im bothering you too much with these newbie
questions!

Thanks a lot!
Mark

--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> kmalloc memory comes out of the pool requested 
> GFP_DMA selects the ISA
> space, GFP_HIGH allows all 36bits (if I remember
> rightly). vmalloc comes
> from the whole of memory space.
> 
> the highmem I/O stuff is a 2.4 patch some people use
> so that DMA aware
> drivers that support the full 32bit DMA range can
> avoid bounce buffers. 
> 
> This comes from a 2.4 transition thing. Older
> drivers assume memory they
> access is always mapped (eg when doing PIO) so the
> scsi code makes sure
> this is true. The bounce patch lets drivers that
> don't do PIO avoid
> this.
> 
> 2.5 does the job properly instead as part of the
> block rewrite
> 


__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
