From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH v2] qla2xxx: Fix for locking issue between driver ISR
 and mailbox routines
Date: Wed, 24 Apr 2013 06:03:36 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D35330BDE@avmb2.qlogic.org>
References: <1366737197-45460-1-git-send-email-gurinder.shergill@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:37220
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab3DXGDm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 02:03:42 -0400
In-Reply-To: <1366737197-45460-1-git-send-email-gurinder.shergill@hp.com>
Content-Language: en-US
Content-ID: <601ACCE85F3E274BB3869BC432C4447E@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "gurinder.shergill@hp.com" <gurinder.shergill@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>


Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav

>The driver uses ha->mbx_cmd_flags variable to pass information between
>its ISR and mailbox routines, however, it does so without the protection
>of
>any locks.  Under certain conditions, this can lead to multiple mailbox
>command completions being signaled, which, in turn, leads to a false
>mailbox timeout error for the subsequently issued mailbox command.
>
>The issue occurs frequently but intermittenly with the Qlogic 8GFC mezz
>card during card initialization, resulting in card initialization failure.
>
>Signed-off-by: Gurinder (Sunny) Shergill <gurinder.shergill@hp.com>
>---
> drivers/scsi/qla2xxx/qla_inline.h | 11 +++++++++++
> drivers/scsi/qla2xxx/qla_isr.c    | 27 ++++-----------------------
> drivers/scsi/qla2xxx/qla_mbx.c    |  2 --
> drivers/scsi/qla2xxx/qla_mr.c     | 10 ++--------
> drivers/scsi/qla2xxx/qla_nx.c     | 26 ++++++++++----------------
> 5 files changed, 27 insertions(+), 49 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_inline.h
>b/drivers/scsi/qla2xxx/qla_inline.h
>index 98ab921..0a5c895 100644
>--- a/drivers/scsi/qla2xxx/qla_inline.h
>+++ b/drivers/scsi/qla2xxx/qla_inline.h
>@@ -278,3 +278,14 @@ qla2x00_do_host_ramp_up(scsi_qla_host_t *vha)
>
>       set_bit(HOST_RAMP_UP_QUEUE_DEPTH, &vha->dpc_flags);
> }
>+
>+static inline void
>+qla2x00_handle_mbx_completion(struct qla_hw_data *ha, int status)
>+{
>+      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>+          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>+              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>+              clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
>+              complete(&ha->mbx_intr_comp);
>+      }
>+}
>diff --git a/drivers/scsi/qla2xxx/qla_isr.c
>b/drivers/scsi/qla2xxx/qla_isr.c
>index 259d920..d2a4c75 100644
>--- a/drivers/scsi/qla2xxx/qla_isr.c
>+++ b/drivers/scsi/qla2xxx/qla_isr.c
>@@ -104,14 +104,9 @@ qla2100_intr_handler(int irq, void *dev_id)
>                       RD_REG_WORD(&reg->hccr);
>               }
>       }
>+      qla2x00_handle_mbx_completion(ha, status);
>       spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-              complete(&ha->mbx_intr_comp);
>-      }
>-
>       return (IRQ_HANDLED);
> }
>
>@@ -221,14 +216,9 @@ qla2300_intr_handler(int irq, void *dev_id)
>               WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
>               RD_REG_WORD_RELAXED(&reg->hccr);
>       }
>+      qla2x00_handle_mbx_completion(ha, status);
>       spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-              complete(&ha->mbx_intr_comp);
>-      }
>-
>       return (IRQ_HANDLED);
> }
>
>@@ -2613,14 +2603,9 @@ qla24xx_intr_handler(int irq, void *dev_id)
>               if (unlikely(IS_QLA83XX(ha) && (ha->pdev->revision == 1)))
>                       ndelay(3500);
>       }
>+      qla2x00_handle_mbx_completion(ha, status);
>       spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-              complete(&ha->mbx_intr_comp);
>-      }
>-
>       return IRQ_HANDLED;
> }
>
>@@ -2763,13 +2748,9 @@ qla24xx_msix_default(int irq, void *dev_id)
>               }
>               WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
>       } while (0);
>+      qla2x00_handle_mbx_completion(ha, status);
>       spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-              complete(&ha->mbx_intr_comp);
>-      }
>       return IRQ_HANDLED;
> }
>
>diff --git a/drivers/scsi/qla2xxx/qla_mbx.c
>b/drivers/scsi/qla2xxx/qla_mbx.c
>index 9e5d89d..3587ec2 100644
>--- a/drivers/scsi/qla2xxx/qla_mbx.c
>+++ b/drivers/scsi/qla2xxx/qla_mbx.c
>@@ -179,8 +179,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha,
>mbx_cmd_t *mcp)
>
>               wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
>
>-              clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
>-
>       } else {
>               ql_dbg(ql_dbg_mbx, vha, 0x1011,
>                   "Cmd=%x Polling Mode.\n", command);
>diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
>index 729b743..5483da8 100644
>--- a/drivers/scsi/qla2xxx/qla_mr.c
>+++ b/drivers/scsi/qla2xxx/qla_mr.c
>@@ -148,9 +148,6 @@ qlafx00_mailbox_command(scsi_qla_host_t *vha, struct
>mbx_cmd_32 *mcp)
>               spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>               wait_for_completion_timeout(&ha->mbx_intr_comp, mcp->tov * HZ);
>-
>-              clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
>-
>       } else {
>               ql_dbg(ql_dbg_mbx, vha, 0x112c,
>                   "Cmd=%x Polling Mode.\n", command);
>@@ -2934,13 +2931,10 @@ qlafx00_intr_handler(int irq, void *dev_id)
>               QLAFX00_CLR_INTR_REG(ha, clr_intr);
>               QLAFX00_RD_INTR_REG(ha);
>       }
>+
>+      qla2x00_handle_mbx_completion(ha, status);
>       spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-              complete(&ha->mbx_intr_comp);
>-      }
>       return IRQ_HANDLED;
> }
>
>diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
>index 10754f51..cce0cd0 100644
>--- a/drivers/scsi/qla2xxx/qla_nx.c
>+++ b/drivers/scsi/qla2xxx/qla_nx.c
>@@ -2074,9 +2074,6 @@ qla82xx_intr_handler(int irq, void *dev_id)
>               }
>               WRT_REG_DWORD(&reg->host_int, 0);
>       }
>-      spin_unlock_irqrestore(&ha->hardware_lock, flags);
>-      if (!ha->flags.msi_enabled)
>-              qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
>
> #ifdef QL_DEBUG_LEVEL_17
>       if (!irq && ha->flags.eeh_busy)
>@@ -2085,11 +2082,12 @@ qla82xx_intr_handler(int irq, void *dev_id)
>                   status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
> #endif
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-          (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-              set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-              complete(&ha->mbx_intr_comp);
>-      }
>+      qla2x00_handle_mbx_completion(ha, status);
>+      spin_unlock_irqrestore(&ha->hardware_lock, flags);
>+
>+      if (!ha->flags.msi_enabled)
>+              qla82xx_wr_32(ha, ha->nx_legacy_intr.tgt_mask_reg, 0xfbff);
>+
>       return IRQ_HANDLED;
> }
>
>@@ -2149,8 +2147,6 @@ qla82xx_msix_default(int irq, void *dev_id)
>               WRT_REG_DWORD(&reg->host_int, 0);
>       } while (0);
>
>-      spin_unlock_irqrestore(&ha->hardware_lock, flags);
>-
> #ifdef QL_DEBUG_LEVEL_17
>       if (!irq && ha->flags.eeh_busy)
>               ql_log(ql_log_warn, vha, 0x5044,
>@@ -2158,11 +2154,9 @@ qla82xx_msix_default(int irq, void *dev_id)
>                   status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
> #endif
>
>-      if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
>-              (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
>-                      set_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>-                      complete(&ha->mbx_intr_comp);
>-      }
>+      qla2x00_handle_mbx_completion(ha, status);
>+      spin_unlock_irqrestore(&ha->hardware_lock, flags);
>+
>       return IRQ_HANDLED;
> }
>
>@@ -3345,7 +3339,7 @@ void qla82xx_clear_pending_mbx(scsi_qla_host_t *vha)
>               ha->flags.mbox_busy = 0;
>               ql_log(ql_log_warn, vha, 0x6010,
>                   "Doing premature completion of mbx command.\n");
>-              if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
>+              if (test_and_clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags))
>                       complete(&ha->mbx_intr_comp);
>       }
> }
>--
>1.7.11.7
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

