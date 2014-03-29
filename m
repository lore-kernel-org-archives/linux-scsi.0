From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 49/55] scsi: Move prototype declaration to header file
 scsi_priv.h from scsi_scan.c
Date: Sun, 30 Mar 2014 00:15:24 +0530
Message-ID: <6ede28b6caf5d10936d9ea6c7f18d7143406d783.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Move prototype declarations of functions to header file scsi_priv.h fro=
m
scsi_scan.c because they are used by more than one file.

This eliminates the following warnings in scsi_lib.c:
drivers/scsi/scsi_lib.c:466:6: warning: no previous prototype for =E2=80=
=98scsi_requeue_run_queue=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/scsi_lib.c:2266:6: warning: no previous prototype for =E2=80=
=98scsi_evt_thread=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_priv.h |    2 ++
 drivers/scsi/scsi_scan.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a59..3fd3b6f 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,6 +84,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+void scsi_requeue_run_queue(struct work_struct *work);
+void scsi_evt_thread(struct work_struct *work);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..3a67307 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -229,8 +229,6 @@ static struct scsi_device *scsi_alloc_sdev(struct s=
csi_target *starget,
 	struct scsi_device *sdev;
 	int display_failure_msg =3D 1, ret;
 	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
-	extern void scsi_evt_thread(struct work_struct *work);
-	extern void scsi_requeue_run_queue(struct work_struct *work);
=20
 	sdev =3D kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
--=20
1.7.9.5
