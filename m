From: Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 3/3] ibmvscsi: fix tripping of blk_mq_run_hw_queue WARN_ON
Date: Wed,  1 May 2019 19:47:29 -0500
Message-ID: <20190502004729.19962-3-tyreld@linux.ibm.com>
References: <20190502004729.19962-1-tyreld@linux.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190502004729.19962-1-tyreld@linux.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: james.bottomley@hansenpartnership.com
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

After a successful SRP login response we call scsi_unblock_requests() to
kick any pending IO's. The callback to process this SRP response happens in
a tasklet and therefore is in softirq context. The result of such is
that when blk-mq is enabled it is no longer safe to call
scsi_unblock_requests() from this context. The result of duing so
triggers the following WARN_ON splat in dmesg after a host reset or CRQ
reenablement.

WARNING: CPU: 0 PID: 0 at block/blk-mq.c:1375 __blk_mq_run_hw_queue+0x120/0x180
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.0.0-rc8 #4
NIP [c0000000009771e0] __blk_mq_run_hw_queue+0x120/0x180
LR [c000000000977484] __blk_mq_delay_run_hw_queue+0x244/0x250
Call Trace:

__blk_mq_delay_run_hw_queue+0x244/0x250
blk_mq_run_hw_queue+0x8c/0x1c0
blk_mq_run_hw_queues+0x60/0x90
scsi_run_queue+0x1e4/0x3b0
scsi_run_host_queues+0x48/0x80
login_rsp+0xb0/0x100
ibmvscsi_handle_crq+0x30c/0x3e0
ibmvscsi_task+0x54/0xe0
tasklet_action_common.isra.3+0xc4/0x1a0
__do_softirq+0x174/0x3f4
irq_exit+0xf0/0x120
__do_irq+0xb0/0x210
call_do_irq+0x14/0x24
do_IRQ+0x9c/0x130
hardware_interrupt_common+0x14c/0x150

This patch fixes the issue by introducing a new host action for
unblocking the scsi requests in our seperate work thread.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
 drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 683139e6c63f..c1d83eb5c5f7 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1179,7 +1179,8 @@ static void login_rsp(struct srp_event_struct *evt_struct)
 		   be32_to_cpu(evt_struct->xfer_iu->srp.login_rsp.req_lim_delta));
 
 	/* If we had any pending I/Os, kick them */
-	scsi_unblock_requests(hostdata->host);
+	hostdata->action = IBMVSCSI_HOST_ACTION_UNBLOCK;
+	wake_up(&hostdata->work_wait_q);
 }
 
 /**
@@ -2125,6 +2126,7 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	switch (hostdata->action) {
 	case IBMVSCSI_HOST_ACTION_NONE:
+	case IBMVSCSI_HOST_ACTION_UNBLOCK:
 		break;
 	case IBMVSCSI_HOST_ACTION_RESET:
 		rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
@@ -2162,6 +2164,7 @@ static int __ibmvscsi_work_to_do(struct ibmvscsi_host_data *hostdata)
 		return 0;
 	case IBMVSCSI_HOST_ACTION_RESET:
 	case IBMVSCSI_HOST_ACTION_REENABLE:
+	case IBMVSCSI_HOST_ACTION_UNBLOCK:
 	default:
 		break;
 	}
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
index 04bcbc832dc9..d9bf502334ba 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -92,6 +92,7 @@ enum ibmvscsi_host_action {
 	IBMVSCSI_HOST_ACTION_NONE = 0,
 	IBMVSCSI_HOST_ACTION_RESET,
 	IBMVSCSI_HOST_ACTION_REENABLE,
+	IBMVSCSI_HOST_ACTION_UNBLOCK,
 };
 
 /* all driver data associated with a host adapter */
-- 
2.18.1
