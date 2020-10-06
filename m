Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797EBC4727D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 09:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21C120853
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 09:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BLwfFik8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJFJnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:43:14 -0400
Received: from mout.gmx.net ([212.227.17.22]:36701 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgJFJnK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Oct 2020 05:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601977379;
        bh=GDqZvLHFHyBlYJw8l9bRGc++uPRpcU3Nor7kkfioIFQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BLwfFik80p5AksROUSKurPLh7IAuAvJ1ZOpl938bd4m0oAhddCOzrcSmBCbVkzsOF
         mMtdkgRoDazuVewKjm2SCLRialE2dkrwd/NHMoeDQf0MOFhakz+TrhNwobmEsEKKoP
         4Iv60QFScDxl9px/kzpWb3ZSfTiCE58+GQvxUF5o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ts7.local ([91.8.173.95]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MfHEJ-1ktGtU0Gkt-00gmR3; Tue, 06
 Oct 2020 11:42:59 +0200
From:   Thomas Schmitt <scdbackup@gmx.net>
To:     linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Thomas Schmitt <scdbackup@gmx.net>
Subject: [PATCH v2 1/2] cdrom: delegate automatic CD tray loading to callers of cdrom_open()
Date:   Tue,  6 Oct 2020 11:40:25 +0200
Message-Id: <20201006094026.1730-2-scdbackup@gmx.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201006094026.1730-1-scdbackup@gmx.net>
References: <20201006094026.1730-1-scdbackup@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vlHcON2E3P4q3nSfVlLS2ubdHMbDBcNtQxLwnpjBPvu1KgfoOpY
 /2IvL0qsLthPXmOnUD+oi0nq0p3s/qJk2wosffB+pjxNO7FZl9SsgqxMZtzjKrdWOM7PvG3
 9awFscxzBlKE0k8gaXBkst37misIjLWDUqTrL8BAZ/HNh6BQdDuoQgtKem7By6mCjmpNxXI
 pyE57Orj/8/zuGbFuglkA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7M6p5R/qggM=:1cGjnQuRlW4kFtIfKci4Wo
 sjxVrK21VrxkvgWCaSTPsytPyo+78R7fjBNQTPhr9ESMJ2A1HOQpvWAxdBJfY0U8D2JmPky7z
 eq09b2Pf2SiXHHPrvfGhS1Y0526LrsftH0ksyTtMsBJ6diHGI79SQYzmi4mqESTkyXfGkJtDj
 VN5BrQGym7hyr8o5zBP7ZrsISVy78XQ3Q1HXI/kehnvw9iyUPzG/kMJob72jANkgm9phf93rb
 qRJ6AfhPE0uLHHuemGDKkDXekUdCzX5DHipl0GPUyRcpwO/95gt4WQy63GSAyhJ88wY09RBD0
 t7cYxszQGDc3XDmy+vDC1ZqX/MevLCtX6qXT+4fjDZCCwGn1b0i1ylnuYXiAMw7S9rppyMEeb
 R5D9OOWnRbcCEgKIe+b3F+feIdERwWU9p9PUNGJ+oSXQCJo+MOuvufch4C/T4DkzFAOyrFNkS
 5bdWCtWpujt02Nv0vfmlPf2if2aZ9jdRoHvlSyM/2iTv/erjk8+bAeQAcxyOW5gJzlzrCA53W
 1U2+G2P/KIjeNkM2MvSf5y2KkGMsu141gBQA1b2nLSC1tvGntk9KLnxPUEUxOW6WyuN9D6XWZ
 cuyHec6iHQKeENadgyv8Oc2as6SVaI0cop7zUPZ4UE9lRswz4axyACW6XaXtbIzKj4l136nj4
 Viwy/bcNIqs+W5EKyIo4pJjiVpkOPZ0Voo3eSBFCZhMHvnLLqD5eclv0GCGq2Uu+wlnlHuIw8
 dRXe/XILLFv9XTk9D/BjWdGnZYl4wayys7PjjcHPJ85RZxfr47lRnx6zzREa+Afz11k6rzdcy
 mt7BiYutZzH1AMHZwWThrMa5pQNFMGgofCjsXcMIvflJ2QdE8qkfaLdugXTwB8Yds6V0t8dA9
 f3ytILr7gm15lQTwGMtjaLa/QJQv7dxLEd2ZyyjtcR5Nap0lgzhBMPcGemCoReb1LyAgBBpR+
 9vrWdyrkmuId9lTUchhdo9bs8seqELv7D8bUaUV6qhBjyRpSKarwV2dkpB6fJh0o1F+o+PVg5
 9R43xAmnJMO0zpOIfVI7zLLpYfnLYZ02yl1tHTbcUb5FsVAGBce/ClFkA03OdzJrFHsmYiSAx
 b1DRN96byjpf1MogtoVjjWKgPjd+nLwFAk+vbzJ5tVFgHPK5+5Ux8rW322oaOUkIjcx9Y6m2M
 ur9KCrPXzhYiUc7ALHtRTWEGVnvzdCOCuqHC42yb9+D1Jb/GKmjWH60CYn6QgnOWgGuasRoT4
 fzXfa8I6JNaTWdF4EvjLhfGwPL9f2DjqlI7wuPA==
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
 drivers/cdrom/cdrom.c | 173 +++++++++++++++++++++++++++++++-----------
 include/linux/cdrom.h |   3 +
 2 files changed, 132 insertions(+), 44 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 0c271b9e3c5b..45bfe76129ef 100644
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
@@ -1040,6 +1052,114 @@ static void cdrom_count_tracks(struct cdrom_device=
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
+ * Input parameter leave_open =3D=3D 1 suppresses the try to close and th=
e waiting
+ * for a decision. It rather just assesses the situation. Submit mode =3D=
=3D 0
+ * to not hamper assessment.
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
+	if (ret =3D=3D CDS_DRIVE_NOT_READY) {
+		/* Probably some other entity is loading the tray */
+		if (leave_open)
+			return -ENOMEDIUM;
+		wait_for_medium_decision(cdi);
+		goto assess_and_return;
+	}
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
@@ -1047,50 +1167,15 @@ int open_for_data(struct cdrom_device_info *cdi)
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

