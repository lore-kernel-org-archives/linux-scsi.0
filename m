From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 8/12] scsi: megaraid_sas - Online Controller Reset (OCR):
 Driver re-issue the pending cmds to FW
Date: Fri, 18 Jun 2010 15:02:14 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09274A2@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D080455A@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D080455A@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT:
After OCR finished, driver need to re-issue the pending cmds to FW again.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   81 ++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 07:51:23.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 07:51:23.000000000 -0400
@@ -2088,7 +2088,86 @@ megasas_complete_cmd(struct megasas_inst
 static inline void
 megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 {
-	return;
+	struct megasas_cmd *cmd;
+	struct list_head clist_local;
+	union megasas_evt_class_locale class_locale;
+	unsigned long flags;
+	u32 seq_num;
+
+	INIT_LIST_HEAD(&clist_local);
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	list_splice_init(&instance->internal_reset_pending_q, &clist_local);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+	while (!list_empty(&clist_local)) {
+		cmd	= list_entry((&clist_local)->next,
+					struct megasas_cmd, list);
+		list_del_init(&cmd->list);
+
+		if (cmd->sync_cmd || cmd->scmd) {
+			printk(KERN_NOTICE "megaraid_sas: command %p, %p:%d"
+				"detected to be pending while HBA reset.\n",
+					cmd, cmd->scmd, cmd->sync_cmd);
+
+			cmd->retry_for_fw_reset++;
+
+			if (cmd->retry_for_fw_reset == 3) {
+				printk(KERN_NOTICE "megaraid_sas: cmd %p, %p:%d"
+					"was tried multiple times during reset."
+					"Shutting down the HBA\n",
+					cmd, cmd->scmd, cmd->sync_cmd);
+				megaraid_sas_kill_hba(instance);
+
+				instance->adprecovery =
+						MEGASAS_HW_CRITICAL_ERROR;
+				return;
+			}
+		}
+
+		if (cmd->sync_cmd == 1) {
+			if (cmd->scmd) {
+				printk(KERN_NOTICE "megaraid_sas: unexpected"
+					"cmd attached to internal command!\n");
+			}
+			printk(KERN_NOTICE "megasas: %p synchronous cmd"
+						"on the internal reset queue,"
+						"issue it again.\n", cmd);
+			cmd->cmd_status = ENODATA;
+			instance->instancet->fire_cmd(instance,
+							cmd->frame_phys_addr ,
+							0, instance->reg_set);
+		} else if (cmd->scmd) {
+			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x],%#lx"
+			"detected on the internal queue, issue again.\n",
+			cmd, cmd->scmd->cmnd[0], cmd->scmd->serial_number);
+
+			atomic_inc(&instance->fw_outstanding);
+			instance->instancet->fire_cmd(instance,
+					cmd->frame_phys_addr,
+					cmd->frame_count-1, instance->reg_set);
+		} else {
+			printk(KERN_NOTICE "megasas: %p unexpected cmd on the"
+				"internal reset defer list while re-issue!!\n",
+				cmd);
+		}
+	}
+
+	if (instance->aen_cmd) {
+		printk(KERN_NOTICE "megaraid_sas: aen_cmd in def process\n");
+		megasas_return_cmd(instance, instance->aen_cmd);
+
+		instance->aen_cmd	= NULL;
+	}
+
+	/*
+	* Initiate AEN (Asynchronous Event Notification)
+	*/
+	seq_num = instance->last_seq_num;
+	class_locale.members.reserved = 0;
+	class_locale.members.locale = MR_EVT_LOCALE_ALL;
+	class_locale.members.class = MR_EVT_CLASS_DEBUG;
+
+	megasas_register_aen(instance, seq_num, class_locale.word);
 }
 
 /**
