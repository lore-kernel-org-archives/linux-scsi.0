From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: fix the BIOS limits setting routines
Date: Mon, 13 Jun 2005 20:58:56 -0500
Message-ID: <1118714336.5079.84.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:653 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261349AbVFNB7F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 21:59:05 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j5E1x0A13040
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 21:59:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Following the go around over the SONY DVD that needs artificial limits,
this should be the correct code for all cases (minus the debugging
prints).

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -621,20 +621,35 @@ ahc_linux_target_alloc(struct scsi_targe
 	memset(targ, 0, sizeof(*targ));
 
 	if (sc) {
+		int maxsync = AHC_SYNCRATE_DT;
+		int ultra = 0;
+		int flags = sc->device_flags[target_offset];
+
+		if (ahc->flags & AHC_NEWEEPROM_FMT) {
+		    if (flags & CFSYNCHISULTRA)
+			ultra = 1;
+		} else if (flags & CFULTRAEN)
+			ultra = 1;
+		/* AIC nutcase; 10MHz appears as ultra = 1, CFXFER = 0x04
+		 * change it to ultra=0, CFXFER = 0 */
+		if(ultra && (flags & CFXFER) == 0x04) {
+			ultra = 0;
+			flags &= ~CFXFER;
+		}
+	    
 		if ((ahc->features & AHC_ULTRA2) != 0) {
-			scsirate = sc->device_flags[target_offset] & CFXFER;
+			scsirate = (flags & CFXFER) | (ultra ? 0x8 : 0);
 		} else {
-			scsirate = (sc->device_flags[target_offset] & CFXFER) << 4;
-			if (sc->device_flags[target_offset] & CFSYNCH)
-				scsirate |= SOFS;
-		}
-		if (sc->device_flags[target_offset] & CFWIDEB) {
-			scsirate |= WIDEXFER;
-			spi_max_width(starget) = 1;
-		} else
-			spi_max_width(starget) = 0;
+			scsirate = (flags & CFXFER) << 4;
+			maxsync = ultra ? AHC_SYNCRATE_ULTRA : 
+				AHC_SYNCRATE_FAST;
+		}
+		spi_max_width(starget) = (flags & CFWIDEB) ? 1 : 0;
+		if (!(flags & CFSYNCH))
+			spi_max_offset(starget) = 0;
 		spi_min_period(starget) = 
-			ahc_find_period(ahc, scsirate, AHC_SYNCRATE_DT);
+			ahc_find_period(ahc, scsirate, maxsync);
+
 		tinfo = ahc_fetch_transinfo(ahc, channel, ahc->our_id,
 					    starget->id, &tstate);
 	}


