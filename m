From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: [PATCH] aic79xx small cleanup
Date: Mon,  3 Apr 2006 10:55:40 +0200
Message-ID: <IX524S$E0404CF22EDCC10DBB87C2C3B254AA8E@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_=__=_XaM3_.1144054540.2A.511583.42.23918.52.42.007.2712"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:38607 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1751576AbWDCI4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 04:56:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


--_=__=_XaM3_.1144054540.2A.511583.42.23918.52.42.007.2712
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

[PATCH] aic79xx small cleanup

After Hannes Reinecke update to the aic79xx bus reset handling,
we could now remove ahd_freeze/release_simq like in the aic7xxx
driver.

Signed-off-by: Emmanuel Fust=E9 <emmanuel.fuste@laposte.net>

---
=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net =
; =0A3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)=0A=
=0A

--_=__=_XaM3_.1144054540.2A.511583.42.23918.52.42.007.2712
Content-Type: text/x-patch;
	name="=?iso-8859-1?Q?NEW-aic79xx-cleanup.patch?="
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="=?iso-8859-1?Q?NEW-aic79xx-cleanup.patch?="

[PATCH] aic79xx small cleanup=0A=0AAfter Hannes Reinecke update to the ai=
c79xx bus reset handling,=0Awe could now remove ahd_freeze/release_simq l=
ike in the aic7xxx=0Adriver.=0A=0ASigned-off-by: Emmanuel Fuste <emmanuel=
.fuste@laposte.net>=0A=0A=0A--- linux-source-2.6.16-orig1/drivers/scsi/ai=
c7xxx/aic79xx_osm.c	2006-04-03 10:24:00.000000000 +0200=0A+++ linux-sourc=
e-2.6.16/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-04-03 10:43:34.000000000=
 +0200=0A@@ -1225,9 +1225,9 @@ ahd_linux_initialize_scsi_bus(struct ahd=0A=
 	ahd_unlock(ahd, &s);=0A 	/* Give the bus some time to recover */=0A 	if=
 ((ahd->flags & AHD_RESET_BUS_A) !=3D 0) {=0A-		ahd_freeze_simq(ahd);=0A+=
		scsi_block_requests(ahd->platform_data->host);=0A 		msleep(AIC79XX_RESE=
T_DELAY);=0A-		ahd_release_simq(ahd);=0A+		scsi_unblock_requests(ahd->pla=
tform_data->host);=0A 	}=0A }=0A =0A@@ -2081,18 +2081,6 @@ ahd_linux_queu=
e_cmd_complete(struct ahd_=0A 	cmd->scsi_done(cmd);=0A }=0A =0A-void=0A-a=
hd_freeze_simq(struct ahd_softc *ahd)=0A-{=0A-	scsi_block_requests(ahd->p=
latform_data->host);=0A-}=0A-=0A-void=0A-ahd_release_simq(struct ahd_soft=
c *ahd)=0A-{=0A-	scsi_unblock_requests(ahd->platform_data->host);=0A-}=0A=
-=0A static int=0A ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)=0A {=0A=
--- linux-source-2.6.16-orig1/drivers/scsi/aic7xxx/aic79xx_osm.h	2006-04-=
03 10:24:00.000000000 +0200=0A+++ linux-source-2.6.16/drivers/scsi/aic7xx=
x/aic79xx_osm.h	2006-04-03 10:41:45.000000000 +0200=0A@@ -853,8 +853,6 @@=
 int	ahd_platform_alloc(struct ahd_softc =0A void	ahd_platform_free(struc=
t ahd_softc *ahd);=0A void	ahd_platform_init(struct ahd_softc *ahd);=0A v=
oid	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);=0A-=
void	ahd_freeze_simq(struct ahd_softc *ahd);=0A-void	ahd_release_simq(str=
uct ahd_softc *ahd);=0A =0A static __inline void=0A ahd_freeze_scb(struct=
 scb *scb)=0A

--_=__=_XaM3_.1144054540.2A.511583.42.23918.52.42.007.2712--

