Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAD9C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42BD208FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:29:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Y9N0HEjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgIHQKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 12:10:25 -0400
Received: from mout.gmx.net ([212.227.15.15]:46129 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731391AbgIHQJp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599581381;
        bh=tkT6oWoTKFu7v4ssWMOYmbprRPCJOoKLlg1czbQNknI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Y9N0HEjjwOTCm0Plv4TwBuxzSPSgxazaxuj78yFj08KgLYMYBWEfL218yWwrbqKa8
         pr94kjujE46zG0dT8If/pScgYvooRwEyhx+R2LdHwekXeES0iuRN54ajjjZzg38mov
         6sIEnyJoUvcxHbDXclpZb0+HvasmfzKgW/wOzDSE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([84.179.245.142]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4zAs-1kexBd1VUi-010qXC; Tue, 08
 Sep 2020 14:02:33 +0200
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Thomas Schmitt <scdbackup@gmx.net>
Subject: [PATCH 1/2] cdrom: delegate automatic CD tray loading to callers of cdrom_open()
Date:   Tue,  8 Sep 2020 14:02:06 +0200
Message-Id: <20200908120207.5014-2-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908120207.5014-1-scdbackup@gmx.net>
References: <20200908120207.5014-1-scdbackup@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DlgdCJIDDQs/lxj1Hrpb5RPkLlSAeZSEFVZmZO2myxzVV72KEBF
 P19RoJnIWesn6mcBILSBmji1Q0eTX9TuZFTH2+epRPy7HMw0qAkhSZzNChNiQJytSsO12XD
 njvVqpf3X732RiQIACQGn6IexUWeKkKCaXnO/gDdIpc/fFQBqzhkK79cMyAavr/xZTsBqea
 F3IVshBjg0pSZuJbi7n0w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:U+o/rzYkQ/4=:BqZIN/64NYTADpdKNDX4nN
 nF7nViMstRNALr6WbFpnwHSfZZe4vdzkYctMkpUD7O82y77GmkrvOp3c/elZNyR00EEZ70p9x
 SHGo2rqfBfzBKN3x0GS5KlxCozkhulVAAQRoW1Do0UXxxMyT+uj76OJbZ3K2j5oTtYrjiKG5d
 kwEr3YCSiHx8o03t6Uj6WHzH1B2XcPIX081LR+bhh5yyt+X3zKrPVAMyV8B1hgkG9schqDPVG
 vGXH+yYo59RDPofVhlZCBOGoHmFyxBNzDvPZ/nynmvNh9GoF3XFYGCdLHxBcl3Uj8Vl6PCday
 YV5L6L/k7RKWWQUuPLPE4rVZBVzMs96DlZo0vBddZHVDYXqcsIhRLKssnvddo/SL+/JTlQrKd
 bUucvGOhYk6vt7im8FyyOLyCTCR1IGewHglnlaWjMASg1KTX4EtgygnhigDH5SsauF66itMtI
 /RCHpTZnhnOYLexjrOBThWQ7rP3sGqpZQHjPhAUMFAbvwXf0z3LMoZvJzk3vLqIhCPN+xivEk
 ckDEY65hxPebuIIcBaxF4+SLoI5+eAbjlzGdZeo1D5yL6XJZ2oTQZTMGH89dzUOcT3IXAVO9f
 DbEs4wNyVZoqiEzHDAJEjvWqu3ayCQ6TZJtgfD2A6Sj7oZBySmM3UpQZahTO3qVdrhhXg7ygh
 EBdj4d2gsxf6dj441IH6/n2zU9DUU+Cr8NhSHQMvzUx2I2sxsddpux/a6YVTKgKYSsRbNB4Qf
 UCG6Gpa8DKJg08YuMCf9lQwecOFmjDukLW5stvf2pYiJwS7dPOOkc1rtNKCkfSmGv7RBCTy9C
 KG5Ml1l+fXHJgd4zWjuTJDRVO3tfui4dGhvtrRqmKTkv80gyu5e2sWxYeq2xgtRVzuBDAnPwJ
 tO2UGWqCFJW2UC889fKcxgvzgaP/3Lm9fXDC+SzX5WrBRmmV29mL6k+g9XMcOGhoLKB1bMALF
 8RTKUwYprVRDmcl2cQ1uaS7Omg9CARZTku1Kc7zUSQx1pEgVD/PVEQ1jJ8Zu2f7OWKdUdA+I7
 M4dXw9fmiWRkbbzGlN4hJgnvET3ooAwDHS8qTzinYNZyYLXzIHkFJuKXJ4pxubEvfNDaDu5hG
 +FtoWex8hRj0uvBZ7gTALFjVdfaCrK+77fFhHPLP03eAWVLp2mzNTzl0nBu0dEgExim+dxmLl
 yYzECSDL6TuV9uB53x3l61OIhj1jQIozzV/yHtoTo7ggzkzQrzKIh7iDRGmdxCZ2Dogi89odm
 OI0T6P7Z0Cju5vAwcFCbApFSzChkvDhLde1VbSA==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If
  open("/dev/sr0", O_RDONLY);
pulls in the tray of an optical drive, it immediately returns -1 with
errno ENOMEDIUM or the first read(2) fails with EIO. Later, when the drive
has stopped blinking, another open() yields success and read() works.
This affects not only userland reading of the device file but also
mounting the device.

Since commit 210ba1d1724f ("[SCSI] sr: update to follow tray status
correctly") of january 2008 the necessary waiting loop after emitting the
tray loading command is not performed, because sr_do_ioctl() is not called
any more.
Commit 2bbea6e11735 ("cdrom: do not call check_disk_change() inside
cdrom_open()") of march 2008 moved medium assessment out of cdrom_open()
and thus inevitable before automatic tray loading.

Factor out a new function cdrom_handle_open_tray() in cdrom.c from
open_for_data() and export it, so that callers of cdrom_open() can call
it before their call of check_disk_change(). It decides whether it can and
should load the tray. If so, it emits the tray loading command and waits
for the drive to make its decision.

Replace automatic tray loading in cdrom_open() by a mere check whether the
drive reports a usable medium in a loaded tray.
Unaware callers of cdrom_open() will not cause automatic tray loading
any more, but rather will reliably see -ENOMEDIUM if the tray is open.

Signed-off-by: Thomas Schmitt <scdbackup@gmx.net>
=2D--
 drivers/cdrom/cdrom.c | 165 +++++++++++++++++++++++++++++++-----------
 include/linux/cdrom.h |   3 +
 2 files changed, 124 insertions(+), 44 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 0c271b9e3c5b..d8d82623ed3e 100644
=2D-- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -286,6 +286,18 @@
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_request.h>

+/*
+ * For the wait-and-retry loop after possibly having loaded the drive tra=
y.
+ * 10 retries in 20 seconds are hardcoded in sr_do_ioctl() which was used
+ * up to 2008.
+ * But time spans up to 25 seconds were measured by libburn on
+ * drives connected via SATA or USB-SATA bridges.
+ * So 20 retries * 2000 ms =3D 40 seconds seems more appropriate.
+ */
+#define CD_OPEN_MEDIUM_RETRY_MAX 20
+#define CD_OPEN_MEDIUM_RETRY_MSLEEP 2000
+#include <linux/delay.h>
+
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
 /* default compatibility mode */
@@ -1040,6 +1052,106 @@ static void cdrom_count_tracks(struct cdrom_device=
_info *cdi, tracktype *tracks)
 	       tracks->cdi, tracks->xa);
 }

+static
+int wait_for_medium_decision(struct cdrom_device_info *cdi)
+{
+	int retry =3D 0, ret;
+	const struct cdrom_device_ops *cdo =3D cdi->ops;
+
+	/* Wait until the intermediate drive status CDS_DRIVE_NOT_READY ends */
+	while (1) {
+		ret =3D cdo->drive_status(cdi, CDSL_CURRENT);
+		if (ret =3D=3D CDS_DRIVE_NOT_READY &&
+		    retry++ < CD_OPEN_MEDIUM_RETRY_MAX)
+			msleep(CD_OPEN_MEDIUM_RETRY_MSLEEP);
+		else
+			break;
+	}
+	if (ret !=3D CDS_DISC_OK)
+		return ret;
+	/*
+	 * It is hard to test whether very recent readiness can cause race
+	 * conditions with media change events. So wait a while to never
+	 * undercut the average delay between actual readiness and detection
+	 * which was tested without this additional msleep().
+	 */
+	msleep(CD_OPEN_MEDIUM_RETRY_MSLEEP / 2);
+
+	return CDS_DISC_OK;
+}
+
+/*
+ * To be called by expectant callers of cdrom_open(), before they call
+ * check_disk_change() and then cdrom_open().
+ *
+ * If the mode is right, the drive capable, the tray out, and autoclose
+ * enabled, try to move in the tray and wait for the drive's decision abo=
ut
+ * the medium.
+ * Return 0 if cdrom_open() would not want to know the tray status, or th=
e
+ * drive cannot report its tray status at all, or the decision is CDS_DIS=
C_OK.
+ * Else return a negative error number.
+ * Input parameter mode decides whether cdrom_open() will want to know or
+ * change the tray status at all.
+ * Input parameter leave_open =3D=3D 1 suppresses the try to close, and r=
ather just
+ * assesses the situation. Submit mode =3D=3D 0 to not hamper assessment.
+ */
+int cdrom_handle_open_tray(struct cdrom_device_info *cdi, fmode_t mode,
+			   int leave_open)
+{
+	int ret;
+	const struct cdrom_device_ops *cdo =3D cdi->ops;
+
+	if ((mode & FMODE_NDELAY) && (cdi->options & CDO_USE_FFLAGS))
+		return 0;
+	if (!cdo->drive_status)
+		return 0;
+
+	ret =3D cdo->drive_status(cdi, CDSL_CURRENT);
+	cd_dbg(CD_OPEN, "drive_status=3D%d\n", ret);
+	if (ret !=3D CDS_TRAY_OPEN)
+		goto assess_and_return;
+
+	cd_dbg(CD_OPEN, "the tray is open...\n");
+	if (leave_open)
+		return -ENOMEDIUM;
+	/* can/may i close it? */
+	if (CDROM_CAN(CDC_CLOSE_TRAY) && cdi->options & CDO_AUTO_CLOSE) {
+		cd_dbg(CD_OPEN, "trying to close the tray\n");
+		ret =3D cdo->tray_move(cdi, 0);
+		if (ret) {
+			cd_dbg(CD_OPEN,
+			       "bummer. tried to close the tray but failed.\n");
+			/* Ignore the error from the low
+			 * level driver.  We don't care why it
+			 * couldn't close the tray.  We only care
+			 * that there is no disc in the drive,
+			 * since that is the _REAL_ problem here.
+			 */
+			return -ENOMEDIUM;
+		}
+	} else {
+		if (!CDROM_CAN(CDC_CLOSE_TRAY))
+			cd_dbg(CD_OPEN,
+			       "bummer. this drive can't close the tray.\n");
+		return -ENOMEDIUM;
+	}
+
+	ret =3D wait_for_medium_decision(cdi);
+	if (ret =3D=3D CDS_NO_DISC || ret =3D=3D CDS_TRAY_OPEN) {
+		cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
+		cd_dbg(CD_OPEN, "tray might not contain a medium\n");
+		return -ENOMEDIUM;
+	}
+	cd_dbg(CD_OPEN, "the tray is now closed\n");
+
+assess_and_return:
+	ret =3D cdo->drive_status(cdi, CDSL_CURRENT);
+	if (ret !=3D CDS_DISC_OK)
+		return -ENOMEDIUM;
+	return 0;
+}
+EXPORT_SYMBOL(cdrom_handle_open_tray);
+
 static
 int open_for_data(struct cdrom_device_info *cdi)
 {
@@ -1047,50 +1159,15 @@ int open_for_data(struct cdrom_device_info *cdi)
 	const struct cdrom_device_ops *cdo =3D cdi->ops;
 	tracktype tracks;
 	cd_dbg(CD_OPEN, "entering open_for_data\n");
-	/* Check if the driver can report drive status.  If it can, we
-	   can do clever things.  If it can't, well, we at least tried! */
-	if (cdo->drive_status !=3D NULL) {
-		ret =3D cdo->drive_status(cdi, CDSL_CURRENT);
-		cd_dbg(CD_OPEN, "drive_status=3D%d\n", ret);
-		if (ret =3D=3D CDS_TRAY_OPEN) {
-			cd_dbg(CD_OPEN, "the tray is open...\n");
-			/* can/may i close it? */
-			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
-			    cdi->options & CDO_AUTO_CLOSE) {
-				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret=3Dcdo->tray_move(cdi,0);
-				if (ret) {
-					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
-					/* Ignore the error from the low
-					level driver.  We don't care why it
-					couldn't close the tray.  We only care
-					that there is no disc in the drive,
-					since that is the _REAL_ problem here.*/
-					ret=3D-ENOMEDIUM;
-					goto clean_up_and_return;
-				}
-			} else {
-				cd_dbg(CD_OPEN, "bummer. this drive can't close the tray.\n");
-				ret=3D-ENOMEDIUM;
-				goto clean_up_and_return;
-			}
-			/* Ok, the door should be closed now.. Check again */
-			ret =3D cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret =3D=3D CDS_NO_DISC) || (ret=3D=3DCDS_TRAY_OPEN)) {
-				cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
-				cd_dbg(CD_OPEN, "tray might not contain a medium\n");
-				ret=3D-ENOMEDIUM;
-				goto clean_up_and_return;
-			}
-			cd_dbg(CD_OPEN, "the tray is now closed\n");
-		}
-		/* the door should be closed now, check for the disc */
-		ret =3D cdo->drive_status(cdi, CDSL_CURRENT);
-		if (ret!=3DCDS_DISC_OK) {
-			ret =3D -ENOMEDIUM;
-			goto clean_up_and_return;
-		}
-	}
+
+	/*
+	 * Check for open tray, but do not close it. The caller should
+	 * have cared to call cdrom_handle_open_tray(,,0) in advance.
+	 */
+	ret =3D cdrom_handle_open_tray(cdi, (fmode_t)0, 1);
+	if (ret)
+		goto clean_up_and_return;
+
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error =3D=3D CDS_NO_DISC) {
 		cd_dbg(CD_OPEN, "bummer. no disc.\n");
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index f48d0a31deae..cf2b5fc9c6fd 100644
=2D-- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -98,6 +98,9 @@ int cdrom_multisession(struct cdrom_device_info *cdi,
 int cdrom_read_tocentry(struct cdrom_device_info *cdi,
 		struct cdrom_tocentry *entry);

+int cdrom_handle_open_tray(struct cdrom_device_info *cdi, fmode_t mode,
+			   int leave_open);
+
 /* the general block_device operations structure: */
 extern int cdrom_open(struct cdrom_device_info *cdi, struct block_device =
*bdev,
 			fmode_t mode);
=2D-
2.20.1

