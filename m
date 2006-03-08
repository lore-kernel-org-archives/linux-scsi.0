From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/07] aic79xx: Invalid Sequencer interrupt occured
Date: Wed, 08 Mar 2006 12:59:03 +0100
Message-ID: <440EC707.6040109@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050805010101070508080302"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:1181 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751744AbWCHL7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 06:59:04 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 190F4EFD6
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 12:59:03 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050805010101070508080302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On certain systems the driver seems to hit upon some
"scsi0: Invalid Sequencer interrupt occurred." problem and dumps card sta=
te.
According to Adaptec engineers this message is harmless. So as not to
confuse user we can as well disable the internal card state dump and
just print out the message itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050805010101070508080302
Content-Type: text/plain;
 name="05-aic79xx-invalid-sequencer-interrupt.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-aic79xx-invalid-sequencer-interrupt.txt"

[PATCH 05/07] aic79xx: Invalid Sequencer interrupt occured

On certain systems the driver seems to hit upon some
"scsi0: Invalid Sequencer interrupt occurred." problem and dumps card state.
According to Adaptec engineers this message is harmless. So as not to confuse
user we can as well disable the internal card state dump and just print out
the message itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_core.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

f08314910831fee4967af1889ff5583064c96fcd
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index b2bcdd4..326a622 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -978,9 +978,13 @@ ahd_handle_seqint(struct ahd_softc *ahd,
 		break;
 	}
 	case INVALID_SEQINT:
-		printf("%s: Invalid Sequencer interrupt occurred.\n",
+		printf("%s: Invalid Sequencer interrupt occurred, "
+		       "resetting channel.\n",
 		       ahd_name(ahd));
-		ahd_dump_card_state(ahd);
+#ifdef AHD_DEBUG
+		if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
+			ahd_dump_card_state(ahd);
+#endif
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 		break;
 	case STATUS_OVERRUN:
-- 
1.1.3

--------------050805010101070508080302--
