From: Michael Schmitz <schmitz@mail.biophys.uni-duesseldorf.de>
Subject: Re: [PATCH] scsi_lib.c: avoid max_hw_segments warning
Date: Mon, 11 Dec 2006 18:18:40 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0612111812470.30815@xplor.biophys.uni-duesseldorf.de>
References: <Pine.LNX.4.64.0612081206300.21386@halbrend.uninett.no>
 <Pine.LNX.4.58.0612081356540.6702@xplor.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.62.0612081433590.17313@pademelon.sonytel.be>
 <Pine.LNX.4.58.0612081601080.7221@xplor.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.58.0612111351020.29925@xplor.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.62.0612111414140.1150@pademelon.sonytel.be>
 <Pine.LNX.4.58.0612111704370.30544@xplor.biophys.uni-duesseldorf.de>
 <1165854226.2791.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:43252 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760368AbWLKRSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 12:18:51 -0500
In-Reply-To: <1165854226.2791.4.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Michael Schmitz <schmitz@mail.biophys.uni-duesseldorf.de>, jejb@steeleye.com, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org

> > as per request by Geert Uytterhoeven: the patch below avoids a warning in
> > blk_queue_max_hw_segments(), caused by a SCSI host adapter using SG_NONE.
> > Please apply.
>
> Actually, isn't the correct fix to change SG_NONE to 1?
>
> We're deprecating the non-sg paths, however use_sg == 1 is equivalent to
> use_sg==0, you just set it up differently.

I don't know how it's handled in the current code. The Atari driver
carries a big fat warning from the original author that the Falcon (my
test box) cannot do scatter-gather at all, due to problems with DMA setup.

If sg_tablesize==1 is equivalent to not using scatter-gather, I can try
settin 1 there (but why isn't SG_NONE defined as 1, then?)

	Michael
