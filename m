From: Michael Schmitz <schmitz@mail.biophys.uni-duesseldorf.de>
Subject: [PATCH] scsi_lib.c: avoid max_hw_segments warning
Date: Mon, 11 Dec 2006 17:09:26 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0612111704370.30544@xplor.biophys.uni-duesseldorf.de>
References: <Pine.LNX.4.64.0612081206300.21386@halbrend.uninett.no>
 <Pine.LNX.4.58.0612081356540.6702@xplor.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.62.0612081433590.17313@pademelon.sonytel.be>
 <Pine.LNX.4.58.0612081601080.7221@xplor.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.58.0612111351020.29925@xplor.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.62.0612111414140.1150@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:42560 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936951AbWLKQJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 11:09:37 -0500
In-Reply-To: <Pine.LNX.4.62.0612111414140.1150@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Michael Schmitz <schmitz@mail.biophys.uni-duesseldorf.de>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org

Hi,

as per request by Geert Uytterhoeven: the patch below avoids a warning in
blk_queue_max_hw_segments(), caused by a SCSI host adapter using SG_NONE.
Please apply.

> > The second item concerns a warning given for each SCSI target scanned on
> > the Falcon, where sg_tablesize is set to SG_NONE (aka zero). The
> > blk_queue_max_hw_segments() call should set a minimum size of one
> > regardless of the sg_tablesize value (blk_queue_max_hw_segments() corrects
> > this and gives a warning).
> >
> > This one should go directly upstream, I think.
>
> Then please ask/tell linux-scsi and jejb.

--- drivers/scsi/scsi_lib.c.ms-maxhwseg.org	2006-12-09 16:49:29.000000000 +0100
+++ drivers/scsi/scsi_lib.c	2006-12-09 16:49:29.000000000 +0100
@@ -1559,7 +1559,7 @@

 	blk_queue_prep_rq(q, scsi_prep_fn);

-	blk_queue_max_hw_segments(q, shost->sg_tablesize);
+	blk_queue_max_hw_segments(q, (shost->sg_tablesize ? shost->sg_tablesize : 1));
 	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));

Signed-Off-By: <schmitz@debian.org>

Please CC: me on followup, as I'm not subscribed to linux-scsi.

	Michael
