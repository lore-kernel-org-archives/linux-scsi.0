From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch 0/2] Update aic79xx
Date: Mon, 25 Jul 2005 10:07:25 +0200
Message-ID: <42E49DBD.2010708@suse.de>
References: <42E10572.6030105@suse.de> <1122048829.5128.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000201090202090600050407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40638 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261804AbVGYIHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 04:07:43 -0400
In-Reply-To: <1122048829.5128.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

This is a multi-part message in MIME format.
--------------000201090202090600050407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

James Bottomley wrote:
> On Fri, 2005-07-22 at 16:40 +0200, Hannes Reinecke wrote:
>>I've finished the update of aic79xx to make use of the
>>scsi_transport_spi infrastructure.
>>The first patch is actually jgarzik's one, with some additions to make
>>it work :-)
>>The second patch is the integration proper. patch made a mess of it,
>>however, so better to compare the files by hand ...
>>
>>Hope it finds your blessing.
>>Comments etc welcome.
>=20
> This looks very good, thank you for doing it!
>=20
>>target27:0:10: FAST-160 WIDE SCSI 320.0 MB/s ST IU (6.25 ns, offset 127=
)
>=20
> There is a slight problem here:  ST IU isn't a legal SCSI setting (DT i=
s
> a requirement for IU), so there's something slightly wrong in the
> parameter setting somewhere.  I'll take a look through the code and see=

> if I can spot it (probably post OLS).
>=20
You are, again, correct.
The implied flags setting from SPI-3 is not taken into account.
The applied patch (relative to the other two I've already sent) fixes thi=
s.

But this is not the root problem.

 target5:0:10: FAST-160 WIDE SCSI 320.0 MB/s ST IU (6.25 ns, offset 127)
scsi5: target 10 synchronous with period =3D 0x8, offset =3D
0x7f(RDSTRM|DT|IU|QAS)

So, the ppr_options (which have generated the second line) are set ok,
but they somehow haven't been transferred into the scsi_transport attribu=
te.

It appears that the fallback sequence doesn't quite work.

But that'll warrant a new mail.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------000201090202090600050407
Content-Type: text/plain;
 name="aic79xx-correct-negotiation-flags"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-correct-negotiation-flags"

--- linux-2.6.12/drivers/scsi/aic7xxx/aic79xx_osm.c.jejb	2005-07-25 09:21:41.000000000 +0200
+++ linux-2.6.12/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-07-25 09:22:37.000000000 +0200
@@ -2343,6 +2343,7 @@ static void ahd_linux_set_period(struct 
 				      shost->this_id, starget->id, &tstate);
 	struct ahd_devinfo devinfo;
 	unsigned int ppr_options = tinfo->goal.ppr_options;
+	unsigned int dt;
 	unsigned long flags;
 	unsigned long offset = tinfo->goal.offset;
 
@@ -2357,6 +2358,8 @@ static void ahd_linux_set_period(struct 
 			ppr_options |= MSG_EXT_PPR_IU_REQ;
 	}
 
+	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 
@@ -2366,7 +2369,8 @@ static void ahd_linux_set_period(struct 
 			ppr_options &= MSG_EXT_PPR_QAS_REQ;
 	}
 
-	ahd_find_syncrate(ahd, &period, &ppr_options, AHD_SYNCRATE_MAX);
+	ahd_find_syncrate(ahd, &period, &ppr_options,
+			  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset,
 			 ppr_options, AHD_TRANS_GOAL, FALSE);
@@ -2385,6 +2389,7 @@ static void ahd_linux_set_offset(struct 
 	struct ahd_devinfo devinfo;
 	unsigned int ppr_options = 0;
 	unsigned int period = 0;
+	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 	unsigned long flags;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
@@ -2392,7 +2397,8 @@ static void ahd_linux_set_offset(struct 
 	if (offset != 0) {
 		period = tinfo->goal.period;
 		ppr_options = tinfo->goal.ppr_options;
-		ahd_find_syncrate(ahd, &period, &ppr_options, AHD_SYNCRATE_MAX);
+		ahd_find_syncrate(ahd, &period, &ppr_options, 
+				  dt ? AHD_SYNCRATE_MAX : AHD_SYNCRATE_ULTRA2);
 	}
 	ahd_lock(ahd, &flags);
 	ahd_set_syncrate(ahd, &devinfo, period, offset, ppr_options,
@@ -2419,9 +2425,13 @@ static void ahd_linux_set_dt(struct scsi
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
 		if (period > 9)
 			period = 9; /* at least 12.5ns for DT */
-	} else if (period <= 9)
-		period = 10; /* If resetting DT, period must be >= 25ns */
-
+	} else {
+		if (period <= 9)
+			period = 10; /* If resetting DT, period must be >= 25ns */
+		/* QAS and IU are invalid without DT set */
+		ppr_options &= ~MSG_EXT_PPR_IU_REQ;
+		ppr_options &= ~MSG_EXT_PPR_QAS_REQ;
+	}
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
 	ahd_find_syncrate(ahd, &period, &ppr_options,
@@ -2445,11 +2455,17 @@ static void ahd_linux_set_qas(struct scs
 	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_QAS_REQ;
 	unsigned int period = tinfo->goal.period;
-	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned int dt;
 	unsigned long flags;
 
-	if (qas)
-		ppr_options |= MSG_EXT_PPR_QAS_REQ;
+	if (qas) {
+		/* QAS requires IU and DT to be set */
+		ppr_options |= MSG_EXT_PPR_QAS_REQ; 
+		ppr_options |= MSG_EXT_PPR_IU_REQ;
+		ppr_options |= MSG_EXT_PPR_DT_REQ;
+	}
+
+	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
@@ -2474,11 +2490,17 @@ static void ahd_linux_set_iu(struct scsi
 	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_IU_REQ;
 	unsigned int period = tinfo->goal.period;
-	unsigned int dt = ppr_options & MSG_EXT_PPR_DT_REQ;
+	unsigned int dt;
 	unsigned long flags;
 
-	if (iu)
+	if (iu) {
 		ppr_options |= MSG_EXT_PPR_IU_REQ;
+		ppr_options |= MSG_EXT_PPR_DT_REQ; /* IU requires DT */
+	} else {
+		ppr_options &= ~MSG_EXT_PPR_QAS_REQ; /* No QAS without IU */
+	}
+
+	dt = ppr_options & MSG_EXT_PPR_DT_REQ;
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);

--------------000201090202090600050407--
