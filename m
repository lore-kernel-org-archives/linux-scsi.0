From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/07] aic79xx: Avoid renegotiation on inquiry
Date: Wed, 08 Mar 2006 13:00:07 +0100
Message-ID: <440EC747.9060502@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050403060700030508090703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:18406 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751751AbWCHMAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 07:00:07 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id B5CD31D853
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 13:00:06 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050403060700030508090703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Because of some quirk in the SCSI spec the aic79xx driver chose to
force a renegotiation when sending an inquiry. This should better
be handled by the upper layers if required at all.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050403060700030508090703
Content-Type: text/plain;
 name="07-aic79xx-avoid-renegotiation-on-inquiry.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07-aic79xx-avoid-renegotiation-on-inquiry.txt"

[PATCH 07/07] aic79xx: Avoid renegotiation on inquiry

Because of some quirk in the SCSI spec the aic79xx driver chose to
force a renegotiation when sending an inquiry. This should better
be handled by the upper layers if required at all.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

856120bb85cf6555ef268d62fcbc0fb404d7b06e
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 7b9dbef..c97ef05 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1526,30 +1526,6 @@ ahd_linux_run_command(struct ahd_softc *
 	if ((tstate->auto_negotiate & mask) != 0) {
 		scb->flags |= SCB_AUTO_NEGOTIATE;
 		scb->hscb->control |= MK_MESSAGE;
-		} else if (cmd->cmnd[0] == INQUIRY
-			&& (tinfo->curr.offset != 0
-			 || tinfo->curr.width != MSG_EXT_WDTR_BUS_8_BIT
-			 || tinfo->curr.ppr_options != 0)
-			&& (tinfo->curr.ppr_options & MSG_EXT_PPR_IU_REQ)==0) {
-			/*
-			 * The SCSI spec requires inquiry
-			 * commands to complete without
-			 * reporting unit attention conditions.
-			 * Because of this, an inquiry command
-			 * that occurs just after a device is
-			 * reset will result in a data phase
-			 * with mismatched negotiated rates.
-			 * The core already forces a renegotiation
-			 * for reset events that are visible to
-			 * our controller or that we initiate,
-			 * but a third party device reset or a
-			 * hot-plug insertion can still cause this
-			 * issue.  Therefore, we force a re-negotiation
-			 * for every inquiry command unless we
-			 * are async.
-			 */
-			scb->flags |= SCB_NEGOTIATE;
-			scb->hscb->control |= MK_MESSAGE;
 	}
 
 	if ((dev->flags & (AHD_DEV_Q_TAGGED|AHD_DEV_Q_BASIC)) != 0) {
-- 
1.1.3

--------------050403060700030508090703--
