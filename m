From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Wed, 7 Jun 2006 23:28:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606072312410.9588@poirot.grange>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange> <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:14798 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932427AbWFGV2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2006 17:28:13 -0400
In-Reply-To: <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <leva@hotmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 7 Jun 2006, Lev A. Melnikovsky wrote:

> No. It has only one SCSI connector and this is why I assumed that I shouldn't
> care about terminators.

Ok, let's assume for now it knows what to do...

Now, below is a patch... That's about all I can say about it:-) The 
reselect routine didn't seem right to me, specifically, it checks for "no 
active request-block or active request-block is not disconnected" and then 
sends an abort to the device, but if there was indeed an active srb, it 
gets lost, AFAICS. FWIW, tmscsim does the same... The patch below tries to 
complete the command before dropping it on the floor... Any reviews 
appreciated.

And there's one more page_address there in dc395x...

Warning, Lev - this patch may explode your scanner, or upload your bank 
account info to p2p servers, or send your gpg keys to microsoft, or... 
You've been warned:-) You might want to wait for some comments to the 
patch...

Thanks
Guennadi
---
Guennadi Liakhovetski

Return the active request for retry to the upper layer in case of 
"reselect without disconnect" instead of just losing it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u -p a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	30 Mar 2006 19:19:15 -0000
+++ b/drivers/scsi/dc395x.c	7 Jun 2006 21:07:34 -0000
@@ -3198,9 +3198,13 @@ static void reselect(struct AdapterCtlBl
 			/*
 			 * abort command
 			 */
-			dprintkl(KERN_DEBUG,
-				"reselect: w/o disconnected cmds <%02i-%i>\n",
-				dcb->target_id, dcb->target_lun);
+			dprintkl(KERN_WARNING,
+				"reselect: w/o disconnected cmds <%02i-%i> with%s active srb\n",
+				dcb->target_id, dcb->target_lun, srb ? "" : "out");
+			if (srb) {
+				SET_RES_DID(srb->cmd->result, DID_SOFT_ERROR);
+				srb_done(acb, dcb, srb);
+			}
 			srb = acb->tmp_srb;
 			srb->state = SRB_UNEXPECT_RESEL;
 			dcb->active_srb = srb;
