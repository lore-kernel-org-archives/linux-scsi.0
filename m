From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Conversion of old Amiga NCR53C9x drivers to esp_scsi
Date: Mon, 24 Nov 2008 17:00:42 -0600
Message-ID: <1227567642.3568.5.camel@localhost.localdomain>
References: <1227560510.15190.18.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1227560510.15190.18.camel@kars.perseus.home>
Sender: linux-m68k-owner@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Linux/m68k kernel mailing list <linux-m68k@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-11-24 at 22:01 +0100, Kars de Jong wrote:
> Hello everyone,
> 
> 
> After an initial failure in February this year I have now gotten my
> Blizzard SCSI Kit IV to work with the esp_scsi core.
> 
> It turns out the DMA engine doesn't like a transfer size of only 2 bytes
> (at least not when receiving). The bytes were in the FSC FIFO, but
> didn't get transferred to DRAM and the final interrupt didn't occur so
> the driver got stuck.

Oh, that's a known problem with some NCR chips.  The way the manual
recommends handling it as a PIO transaction to empty the DMA engine.
Checking whether this condition occurs can be tricky, though.

> The old driver used to do such small transfers using PIO, so that is
> what I do now in the glue driver.
> 
> What is the way to go? Revive the glue named drivers/scsi/blz1230.c?
> Or should it be renamed?

What I did when converting the 53c700 and 710 based drivers to the
generic core was simply to keep the old name and gut the innards of the
driver.  Whichever way you want to do it will be fine, though.

> Some of the other drivers may be a little more problematic because they
> had more driver operations which are not present in the esp_scsi DMA
> abstraction.

Any changes you need to make in the generic to support these, just post
here for review as a separate patch (and CC the esp_scsi maintainer:
Dave Miller).

James


