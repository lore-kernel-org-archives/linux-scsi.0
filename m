From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Problem Adding Transport Class support to fusion
Date: Tue, 31 May 2005 10:25:35 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C028C57FA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49593 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261951AbVEaQZr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 12:25:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I suspect your using dated firmware. Try /proc/mpt/summary,
and check FwRev.

The "Headers: 0" is SPI Device Page 0, which is returning
the negotiated parameters.  

With my card, I have newer mpi version 4 for "Headers: 0",
your on version 0, which is strange.

Here is what I get.
> mptbase: ioc1: Headers: 0: version 4 length 3
> mptbase: ioc1: Headers: 1: version 5 length 4

Also, have you remembered our cards support RAID?  We kick
of DV when a drive is replaced failed drive in a mirror. That
is kicked off when fw sends ASYC event saying that the
driver must to DV on that hidden phys disk.

FYI - I'm getting ready to post SAS support for split drivers design.  
I prefer that we push out generic DV support after we get the 
SAS updates in, and some other bits of FC transport support 
that have been waiting in the wings for several months.

Eric Moore
LSI Logic

On Monday, May 30, 2005 3:56 PM, James Bottomley wrote:
> 
> I thought I'd look into this, since it seems to be relatively simple:
> you get the parameters from the device config page0 and set them via
> device config page1 as I read the driver.
> 
> However, this appears to be where my fusion card runs into difficulty.
> Debugging the header setup I get this:
> 
> mptbase: ioc1: Headers: 0: version 0 length 0
> mptbase: ioc1: Headers: 1: version 3 length 4
> 
> The driver seems to think this is valid, but if it occurs, there's no
> way to get the parameters or run domain validation.  Is this correct?
> There are classes of fusion card for which we simply cannot obtain
> transport data? 
> 
> Or is there a work around that's not coded into the driver?
> 
> James
> 
> 
