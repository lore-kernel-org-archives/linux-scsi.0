From: Shivaram Upadhyayula <shivaram.u@quadstor.com>
Subject: [PATCH] qla2xxx: Fix schedule_delayed_work() timeout calculations
Date: Tue, 10 Dec 2013 16:06:40 +0530
Message-ID: <CAN-_EfwQc=L6nQy2+eSuBhjMkPB0Z_0e6Uc-k5D51GY6Mj9aDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

The following patch is a fix for the timeout/delay passed to
scheduled_delayed_work.

Regards,
Shivaram U

commit 1e0ea25bb6c834c1f4b2485f49d36a6c314cb7a4
Author: Shivaram U <shivaram.u@quadstor.com>
Date:   Tue Dec 10 15:38:14 2013 +0530

    Fix schedule_delayed_work() timeout calculations

    Signed-off-by: Shivaram U <shivaram.u@quadstor.com>

diff --git a/drivers/scsi/qla2xxx/qla_target.c
b/drivers/scsi/qla2xxx/qla_target.c
index 5964800..3bb0a1d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -471,7 +471,7 @@ static void qlt_schedule_sess_for_deletion(struct
qla_tgt_sess *sess,
 		schedule_delayed_work(&tgt->sess_del_work, 0);
 	else
 		schedule_delayed_work(&tgt->sess_del_work,
-		    jiffies - sess->expires);
+		    sess->expires - jiffies);
 }

 /* ha->hardware_lock supposed to be held on entry */
@@ -550,13 +550,14 @@ static void qlt_del_sess_work_fn(struct
delayed_work *work)
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess;
-	unsigned long flags;
+	unsigned long flags, elapsed;

 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while (!list_empty(&tgt->del_sess_list)) {
 		sess = list_entry(tgt->del_sess_list.next, typeof(*sess),
 		    del_list_entry);
-		if (time_after_eq(jiffies, sess->expires)) {
+		elapsed = jiffies;
+		if (time_after_eq(elapsed, sess->expires)) {
 			qlt_undelete_sess(sess);

 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
@@ -566,7 +567,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 			ha->tgt.tgt_ops->put_sess(sess);
 		} else {
 			schedule_delayed_work(&tgt->sess_del_work,
-			    jiffies - sess->expires);
+			    sess->expires - elapsed);
 			break;
 		}
 	}

-- 
QUADStor Open Source Storage Virtualization : Thin Provisioning, Data
Deduplication, VAAI, High Availability, Virtual Tape Library
http://www.quadstor.com
