From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_lib.c: avoid max_hw_segments warning
Date: Mon, 11 Dec 2006 11:40:30 -0600
Message-ID: <1165858830.2791.10.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0612081206300.21386@halbrend.uninett.no>
	 <Pine.LNX.4.58.0612081356540.6702@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.62.0612081433590.17313@pademelon.sonytel.be>
	 <Pine.LNX.4.58.0612081601080.7221@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.58.0612111351020.29925@xplor.biophys.uni-duesseldorf.de>
	 <Pine.LNX.4.62.0612111414140.1150@pademelon.sonytel.be>
	 <Pine.LNX.4.58.0612111704370.30544@xplor.biophys.uni-duesseldorf.de>
	 <1165854226.2791.4.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.58.0612111812470.30815@xplor.biophys.uni-duesseldorf.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51498 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763000AbWLKRkj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Dec 2006 12:40:39 -0500
In-Reply-To: <Pine.LNX.4.58.0612111812470.30815@xplor.biophys.uni-duesseldorf.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org

On Mon, 2006-12-11 at 18:18 +0100, Michael Schmitz wrote:
> > Actually, isn't the correct fix to change SG_NONE to 1?
> >
> > We're deprecating the non-sg paths, however use_sg == 1 is equivalent to
> > use_sg==0, you just set it up differently.
> 
> I don't know how it's handled in the current code. The Atari driver
> carries a big fat warning from the original author that the Falcon (my
> test box) cannot do scatter-gather at all, due to problems with DMA setup.
> 
> If sg_tablesize==1 is equivalent to not using scatter-gather, I can try
> settin 1 there (but why isn't SG_NONE defined as 1, then?)

Originally all drivers had a SG vs non-SG path through the queuecommand
function.  However, we're eliminating the non-SG path currently.
However, if you only ever have one SG segment, that's functionally
equivalent to the non-SG path (however, the setup would be different) so
I think it's correct for SG_NONE to become 1 when this happens.

James


