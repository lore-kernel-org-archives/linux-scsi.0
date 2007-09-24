From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_transport_spi: fix domain validation failure from
	incorrect width setting
Date: Mon, 24 Sep 2007 08:50:34 -0500
Message-ID: <1190641834.3355.2.camel@localhost.localdomain>
References: <1190468409.3347.3.camel@localhost.localdomain>
	 <20070924121004.GR1606@loop.mdy.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52749 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757AbXIXNum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 09:50:42 -0400
In-Reply-To: <20070924121004.GR1606@loop.mdy.univie.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Boresch <stefan@mdy.univie.ac.at>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2007-09-24 at 14:10 +0200, Stefan Boresch wrote:
> Dear James!
> 
> Sorry for replying so late!
> 
> On Sat, Sep 22, 2007 at 08:40:09AM -0500, James Bottomley wrote:
> > The previous patch was a bit non-standard because it actually adjusted
> > the user setting max_width.  This would mean that if the user replaced
> > the cable and then re-ran domain validation, it still wouldn't try wide
> > transfers, which is wrong.
> > 
> > The attached patch fixes the problem by physically nailing the wide
> > setting to what it deduces it should be for the whole of Domain
> > Validation.
> > 
> > James
> > 
> > diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> [snip]
> 
> A self-compiled kernel based on the Ubuntu "gutsy" kernel sources
> (linux-source-2.6.22_2.6.22-12.36_all.deb, for whatever that is worth) boots
> successfully, after applying your patch (which applied cleanly)
> 
> Thanks so much for your help,

You're very welcome.

> Stefan Boresch
> 
> PS: BTW, your original post (diagnosis of hardware issues) has also
> convinced my vendor to do some work to honor his warranty. So, my next
> job is to dig into the big box which just arrived by fed-ex containing
> all possible replacements (including a new motherboard ..). Maybe,
> I'll eventually get U320 running on this machine ;-)

OK ... I'd replace the cable first ... and check for bent pins in the
connector.  What Domain Validation is saying is that there's something
wrong with the upper 8 bits of the wide bus.  Those are the last few
wires on the 68 wire ribbon cable (wire one is usually marked in a
different colour).

James


