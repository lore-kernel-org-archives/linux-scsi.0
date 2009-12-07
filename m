From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 1/9] pm8001: Fix for sata io circular lock dependency.
Date: Mon, 7 Dec 2009 17:22:36 +0800
Message-ID: <910D88DBC99F4BA2B3FDC50545BE6F52@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001D_01CA7761.DEAA3470"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53045 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZLGJWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:22:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>

This is a multi-part message in MIME format.

------=_NextPart_000_001D_01CA7761.DEAA3470
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

This patch fix for sata IO circular lock dependency. When we call task_done
for SATA IO, we have got pm8001_ha->lock ,and in sas_ata_task_done, it will
get (dev->sata_dev.ap->lock. then cause circular lock dependency .So we
should drop pm8001_ha->lock when we call task_done for SATA task.


Signed-off-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: Lindar Liu <lindar_liu@usish.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |   40
+++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index a3de306..68695b7 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1901,7 +1901,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
-	unsigned long flags;
+	unsigned long flags = 0;
 	u32 param;
 	u32 status;
 	u32 tag;
@@ -2040,7 +2040,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*in order to force CPU ordering*/
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
 			return;
 		}
 		break;
@@ -2058,7 +2060,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
 			return;
 		}
 		break;
@@ -2084,7 +2088,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/* ditto*/
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
 			return;
 		}
 		break;
@@ -2149,7 +2155,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
 			return;
 		}
 		break;
@@ -2171,7 +2179,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
 			return;
 		}
 		break;
@@ -2200,11 +2210,20 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
 			" resp 0x%x stat 0x%x but aborted by upper
layer!\n",
 			t, status, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
+	} else if (t->uldd_task) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		t->task_done(t);
+		spin_lock_irqsave(&pm8001_ha->lock, flags);
+	} else if (!t->uldd_task) {
+		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		mb();/*ditto*/
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		t->task_done(t);
+		spin_lock_irqsave(&pm8001_ha->lock, flags);
 	}
 }
 
@@ -2212,7 +2231,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
void *piomb)
 static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 {
 	struct sas_task *t;
-	unsigned long flags;
+	unsigned long flags = 0;
 	struct task_status_struct *ts;
 	struct pm8001_ccb_info *ccb;
 	struct pm8001_device *pm8001_dev;
@@ -2292,7 +2311,9 @@ static void mpi_sata_event(struct pm8001_hba_info
*pm8001_ha , void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
 			return;
 		}
 		break;
@@ -2401,11 +2422,20 @@ static void mpi_sata_event(struct pm8001_hba_info
*pm8001_ha , void *piomb)
 			" resp 0x%x stat 0x%x but aborted by upper
layer!\n",
 			t, event, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
+	} else if (t->uldd_task) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* in order to force CPU ordering */
+		mb();/* ditto */
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		t->task_done(t);
+		spin_lock_irqsave(&pm8001_ha->lock, flags);
+	} else if (!t->uldd_task) {
+		spin_unlock_irqrestore(&t->task_state_lock, flags);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		mb();/*ditto*/
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		t->task_done(t);
+		spin_lock_irqsave(&pm8001_ha->lock, flags);
 	}
 }
 
-- 
1.6.5.1.1367.gcd48


------=_NextPart_000_001D_01CA7761.DEAA3470
Content-Type: application/octet-stream;
	name="0001-Fix-sata-circular-lock-dependency.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Fix-sata-circular-lock-dependency.patch"

>From 5ed129af3c06470953f2f8126b61af38545db314 Mon Sep 17 00:00:00 2001=0A=
From: Jack Wang <jack_wang@usish.com>=0A=
Date: Wed, 18 Nov 2009 15:19:08 +0800=0A=
Subject: [PATCH 1/9] Fix sata circular lock dependency=0A=
=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
Signed-off-by: Lindar Liu <lindar_liu@usish.com>=0A=
---=0A=
 drivers/scsi/pm8001/pm8001_hwi.c |   40 =
+++++++++++++++++++++++++++++++++----=0A=
 1 files changed, 35 insertions(+), 5 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
index a3de306..68695b7 100644=0A=
--- a/drivers/scsi/pm8001/pm8001_hwi.c=0A=
+++ b/drivers/scsi/pm8001/pm8001_hwi.c=0A=
@@ -1901,7 +1901,7 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 {=0A=
 	struct sas_task *t;=0A=
 	struct pm8001_ccb_info *ccb;=0A=
-	unsigned long flags;=0A=
+	unsigned long flags =3D 0;=0A=
 	u32 param;=0A=
 	u32 status;=0A=
 	u32 tag;=0A=
@@ -2040,7 +2040,9 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			ts->stat =3D SAS_QUEUE_FULL;=0A=
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 			mb();/*in order to force CPU ordering*/=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 			t->task_done(t);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 			return;=0A=
 		}=0A=
 		break;=0A=
@@ -2058,7 +2060,9 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			ts->stat =3D SAS_QUEUE_FULL;=0A=
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 			mb();/*ditto*/=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 			t->task_done(t);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 			return;=0A=
 		}=0A=
 		break;=0A=
@@ -2084,7 +2088,9 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			ts->stat =3D SAS_QUEUE_FULL;=0A=
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 			mb();/* ditto*/=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 			t->task_done(t);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 			return;=0A=
 		}=0A=
 		break;=0A=
@@ -2149,7 +2155,9 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			ts->stat =3D SAS_QUEUE_FULL;=0A=
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 			mb();/*ditto*/=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 			t->task_done(t);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 			return;=0A=
 		}=0A=
 		break;=0A=
@@ -2171,7 +2179,9 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			ts->stat =3D SAS_QUEUE_FULL;=0A=
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 			mb();/*ditto*/=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 			t->task_done(t);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 			return;=0A=
 		}=0A=
 		break;=0A=
@@ -2200,11 +2210,20 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",=0A=
 			t, status, ts->resp, ts->stat));=0A=
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
-	} else {=0A=
+	} else if (t->uldd_task) {=0A=
 		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 		mb();/* ditto */=0A=
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+		t->task_done(t);=0A=
+		spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+	} else if (!t->uldd_task) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/*ditto*/=0A=
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 		t->task_done(t);=0A=
+		spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -2212,7 +2231,7 @@ mpi_sata_completion(struct pm8001_hba_info =
*pm8001_ha, void *piomb)=0A=
 static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void =
*piomb)=0A=
 {=0A=
 	struct sas_task *t;=0A=
-	unsigned long flags;=0A=
+	unsigned long flags =3D 0;=0A=
 	struct task_status_struct *ts;=0A=
 	struct pm8001_ccb_info *ccb;=0A=
 	struct pm8001_device *pm8001_dev;=0A=
@@ -2292,7 +2311,9 @@ static void mpi_sata_event(struct pm8001_hba_info =
*pm8001_ha , void *piomb)=0A=
 			ts->stat =3D SAS_QUEUE_FULL;=0A=
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
 			mb();/*ditto*/=0A=
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 			t->task_done(t);=0A=
+			spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 			return;=0A=
 		}=0A=
 		break;=0A=
@@ -2401,11 +2422,20 @@ static void mpi_sata_event(struct =
pm8001_hba_info *pm8001_ha , void *piomb)=0A=
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",=0A=
 			t, event, ts->resp, ts->stat));=0A=
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
-	} else {=0A=
+	} else if (t->uldd_task) {=0A=
 		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
-		mb();/* in order to force CPU ordering */=0A=
+		mb();/* ditto */=0A=
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
+		t->task_done(t);=0A=
+		spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
+	} else if (!t->uldd_task) {=0A=
+		spin_unlock_irqrestore(&t->task_state_lock, flags);=0A=
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);=0A=
+		mb();/*ditto*/=0A=
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);=0A=
 		t->task_done(t);=0A=
+		spin_lock_irqsave(&pm8001_ha->lock, flags);=0A=
 	}=0A=
 }=0A=
 =0A=
-- =0A=
1.6.5.1.1367.gcd48=0A=
=0A=

------=_NextPart_000_001D_01CA7761.DEAA3470--

