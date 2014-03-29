From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 44/55] scsi: Mark function as static in scsi/libiscsi.c
Date: Sun, 30 Mar 2014 00:07:52 +0530
Message-ID: <eee20bd6ca50408da98bda77cf40180ba084c3e7.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark function as static in libiscsi.c because it is not used outside
this file. Also, unexport the function because it is used only in this
file.

This eliminates the following warning in libiscsi.c:
drivers/scsi/libiscsi.c:2386:5: warning: no previous prototype for =E2=80=
=98iscsi_eh_target_reset=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/libiscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4046241..3afc7b6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2383,7 +2383,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_=
cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2455,7 +2455,6 @@ done:
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
=20
 /**
  * iscsi_eh_recover_target - reset target and possibly the session
--=20
1.7.9.5
