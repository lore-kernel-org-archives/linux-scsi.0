From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: kernel addresses
Date: 28 Oct 2002 22:26:27 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035843987.1965.75.camel@irongate.swansea.linux.org.uk>
References: <20021028212220.80695.qmail@web80312.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021028212220.80695.qmail@web80312.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2002-10-28 at 21:22, Mark Lobo wrote:
> Had a couple of simple questions.
> 1) What exactly is the difference between Kernel
> logical and kernel virtual addresses? is the kernel
> logical address the address space of the kernel? 
> Seems like kernel logical address have a constant
> offset from the physical address, and kernel virtual
> addresses dont. Its slightly confusing on why have
> these two separate terms at all? a kmalloced buffer
> gives a logical address, but a vmalloced gives a
> kernel virtual address. This kind of terminology
> confused me!

[Intel]
The kernel is mapped at 0xC0000000. It occupies a physically contiguous 
space somewhere aroud 0x100000. Memory you alloc with kmalloc comes out
of that mapping and is physically linear. So an 8K block consists of two
physically adjacent pages. Vmalloc allocates stuff by grabbing random
pages, mapping them again into the memory map and giving you something
which is seen as one linear range by virtual address but in fact
consists of multiple randomly distributed physical pages.

[General Purpose Answer]
You don't need to care. Anything you are using for DMA should go via the
PCI mapping API (see Documentation/DMA*). That will hand you back both
virtual addresses and DMA addresses.

> 2) If a SCSI command is passed by a user level app, is
> there a buffer copy involved before it gets to the
> scsi initiator? I saw something about bounce buffers,
> but wasnt quite sure what it meant. So what are bounce
> buffers used for? 
> Does the original buffer allocated by the user get
> mapped into a kernel virtual ( or logical???) address,
> locked down and passed down the stack? 

By the time it hits your SCSI driver it is locked into memory. Where it
came from you don't know and don't need to know. It may be locked user
memory it may be kernel space.

We use bounce buffers when something is at an address the card thinks it
cannot reach. Eg above 16Mb for ISA or above 4Gb for non DAC PCI cards

