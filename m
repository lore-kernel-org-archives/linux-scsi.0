From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: Fix v4.19-rc active I/O shutdown deadlock
Date: Tue, 09 Oct 2018 21:20:06 -0700
Message-ID: <1539145206.6124.15.camel@haakon3.daterainc.com>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-mAJjcxyyMXpcSErrgYWS"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--=-mAJjcxyyMXpcSErrgYWS
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On Wed, 2018-10-10 at 03:23 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi MNC, MKP & Co,
> 
> While testing v4.19-rc recently with simple backend I/O error injection
> (via delayed BIO completion), I was able to trigger an end-less loop
> deadlock with recent changes in commit 00d909a107:
> 
>   Author: Bart Van Assche <bart.vanassche@wdc.com>
>   Date:   Fri Jun 22 14:52:53 2018 -0700
> 
>       scsi: target: Make the session shutdown code also wait for commands that are being aborted
> 
> It comes down to an incorrect assumption wrt signals during session
> shutdown plus active I/O quiesce, which triggers an endless loop
> immediately during session shutdown as se_session->sess_list_wq
> waits for outstanding backend I/O to complete.
> 
> The easiest reproduction is with iser-target or simulation with plain
> old iscsi-target/TCP ports. 

For reference, attached are two debug patches and instructions to
trigger the end-less loop deadlock regression on v4.19-rc.

1) Simulate iscsi-target via iscsit_transport->iscsi_wait_conn()

This makes iscsi-target/TCP follow isert_wait_conn() code, and uses
iscsit_transport->iscsi_wait_conn() during active I/O shutdown to invoke
target_wait_for_sess_cmds() with signals pending per existing
iser-target session shutdown logic.

Useful to trigger in a VM, without a RDMA capable NIC.

2) Simulate IBLOCK WRITE delayed completion by 60 seconds

MNC likes to use scsi_debug for this, but I use BRD to add an arbitrary
completion delay.

-----------------------------------------------------------------------

So once an /sys/kernel/config/target/core/$IBLOCK_HBA/$IBLOCK_DEV/ has
been created + exported via /sys/kernel/config/target/iscsi/$IQN/$TPGT/,
issue a single block WRITE.

Once WRITE completion is delayed by IBLOCK, go ahead and send a 'kill
-SIGINT $PID' to iscsi_trx kthread to trigger usual iscsi/iser session
shutdown + reconnect for the connection with the outstanding delayed
I/O.

Once target_wait_for_sess_cmds() is called with signals pending, it will
immediately kill the machine.

--=-mAJjcxyyMXpcSErrgYWS
Content-Disposition: attachment;
	filename*0=0001-iscsi-target-Add-iscsit_wait_conn-simulation-for-tes.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-iscsi-target-Add-iscsit_wait_conn-simulation-for-tes.patch";
	charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

>From 9b1d23148994edb0969a5efd3a131122ad25e39d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 9 Oct 2018 01:57:53 -0700
Subject: [PATCH 1/2] iscsi-target: Add iscsit_wait_conn() simulation for
 testing

Simulate sess_tearing_down put in iscsit_queue_rsp following how
iser-target isert_put_cmd() works.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cc756a1..b05d8af 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -485,6 +485,22 @@ int iscsit_del_np(struct iscsi_np *np)
 
 int iscsit_queue_rsp(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
+	if (conn && conn->sess && conn->sess->se_sess) {
+		struct se_session *se_sess = conn->sess->se_sess;
+
+		if (se_sess->sess_tearing_down) {
+			printk("Got iscsit_queue_rsp sess_tearing_down !!!!!!\n");
+
+			spin_lock_bh(&conn->cmd_lock);
+			if (!list_empty(&cmd->i_conn_node))
+				list_del_init(&cmd->i_conn_node);
+			spin_unlock_bh(&conn->cmd_lock);
+
+			transport_generic_free_cmd(&cmd->se_cmd, 0);
+			return 0;
+		}
+	}
+
 	return iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
 }
 EXPORT_SYMBOL(iscsit_queue_rsp);
@@ -667,6 +683,16 @@ static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
 	return TARGET_PROT_NORMAL;
 }
 
+static void iscsit_wait_conn(struct iscsi_conn *conn)
+{
+        if (conn->sess) {
+                target_sess_cmd_list_set_waiting(conn->sess->se_sess);
+                printk("se_sess: %p before target_wait_for_sess_cmds\n", conn->sess->se_sess);
+                target_wait_for_sess_cmds(conn->sess->se_sess);
+                printk("se_sess: %p after target_wait_for_sess_cmds\n", conn->sess->se_sess);
+        }
+}
+
 static struct iscsit_transport iscsi_target_transport = {
 	.name			= "iSCSI/TCP",
 	.transport_type		= ISCSI_TCP,
@@ -686,6 +712,7 @@ static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
 	.iscsit_xmit_pdu	= iscsit_xmit_pdu,
 	.iscsit_get_rx_pdu	= iscsit_get_rx_pdu,
 	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
+	.iscsit_wait_conn	= iscsit_wait_conn,
 };
 
 static int __init iscsi_target_init_module(void)
-- 
1.9.1


--=-mAJjcxyyMXpcSErrgYWS
Content-Disposition: attachment;
	filename*0=0002-target-iblock-Delayed-bios-for-active-I-O-shutdown-t.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0002-target-iblock-Delayed-bios-for-active-I-O-shutdown-t.patch";
	charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

>From dc01432e1d561a4d20b20fe868fc8df22fcc4601 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 9 Feb 2017 20:56:01 -0800
Subject: [PATCH 2/2] target/iblock: Delayed bios for active I/O shutdown
 testing

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c | 21 +++++++++++++++++++++
 drivers/target/target_core_iblock.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ce1321a..deef231 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -297,6 +297,19 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	kfree(ibr);
 }
 
+static void iblock_delayed_work(struct work_struct *work)
+{
+	struct iblock_req *ibr = container_of(work,
+		struct iblock_req, delayed_work.work);
+	struct bio *bio = ibr->bio;
+	struct se_cmd *cmd = bio->bi_private;
+
+	printk("iblock_delayed_work: cmd: %p\n", cmd);
+
+	bio_put(bio);
+	iblock_complete_cmd(cmd);
+}
+
 static void iblock_bio_done(struct bio *bio)
 {
 	struct se_cmd *cmd = bio->bi_private;
@@ -311,6 +324,14 @@ static void iblock_bio_done(struct bio *bio)
 		smp_mb__after_atomic();
 	}
 
+	if (cmd->data_direction == DMA_TO_DEVICE) {
+		ibr->bio = bio;
+		INIT_DELAYED_WORK(&ibr->delayed_work, iblock_delayed_work);
+		schedule_delayed_work(&ibr->delayed_work, 60 * HZ);
+		printk("Queued ibr->delayed_work ! :-)\n");
+		return;
+	}
+
 	bio_put(bio);
 
 	iblock_complete_cmd(cmd);
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 9cc3843..122b415 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -14,6 +14,8 @@
 struct iblock_req {
 	refcount_t pending;
 	atomic_t ib_bio_err_cnt;
+	struct delayed_work delayed_work;
+	struct bio *bio;
 } ____cacheline_aligned;
 
 #define IBDF_HAS_UDEV_PATH		0x01
-- 
1.9.1


--=-mAJjcxyyMXpcSErrgYWS--
