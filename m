From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Add missing ->vport_slock while calling
 qlt_update_vp_map
Date: Wed, 10 Oct 2012 00:38:16 -0500
Message-ID: <CC9B0787.EE54%saurav.kashyap@qlogic.com>
References: <1349809931-9079-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349809931-9079-1-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>


>From: Nicholas Bellinger <nab@linux-iscsi.org>
>
>All other callers of qlt_update_vp_map() already hold ->vport_slock
>while updating the vp target map, so go ahead and add the missing
>->vport_slock within qla24xx_disable_vp() code.
>
>Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
>Cc: Chad Dupuis <chad.dupuis@qlogic.com>
>Cc: Arun Easi <arun.easi@qlogic.com>
>Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
>Cc: Jiri Kosina <jkosina@suse.cz>
>Cc: Roland Dreier <roland@purestorage.com>
>Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>---
> drivers/scsi/qla2xxx/qla_mid.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_mid.c
>b/drivers/scsi/qla2xxx/qla_mid.c
>index 3e8b324..c7eb3bb 100644
>--- a/drivers/scsi/qla2xxx/qla_mid.c
>+++ b/drivers/scsi/qla2xxx/qla_mid.c
>@@ -149,6 +149,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
> int
> qla24xx_disable_vp(scsi_qla_host_t *vha)
> {
>+      unsigned long flags;
>       int ret;
>
>       ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
>@@ -156,7 +157,9 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
>       atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
>
>       /* Remove port id from vp target map */
>+      spin_lock_irqsave(&vha->hw->vport_slock, flags);
>       qlt_update_vp_map(vha, RESET_AL_PA);
>+      spin_unlock_irqrestore(&vha->hw->vport_slock, flags);
>
>       qla2x00_mark_vp_devices_dead(vha);
>       atomic_set(&vha->vp_state, VP_FAILED);
>--
>1.7.2.5
>
>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
