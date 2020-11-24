Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B6DC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A12520857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgKXD4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:56:36 -0500
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:49676 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727041AbgKXD4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 22:56:34 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id B92CF182CED2A;
        Tue, 24 Nov 2020 03:56:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: shade32_210cbab2736b
X-Filterd-Recvd-Size: 47151
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Tue, 24 Nov 2020 03:56:29 +0000 (UTC)
Message-ID: <4761b2dd93acc89b748916399b94489549fce2f5.camel@perches.com>
Subject: Re: [PATCH] scsi: fnic: Change shost_printk to FNIC_MAIN_DBG
From:   Joe Perches <joe@perches.com>
To:     "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>
Cc:     "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Mon, 23 Nov 2020 19:56:28 -0800
In-Reply-To: <E34F9542-55FC-41EA-B757-9BBDCD6331C0@cisco.com>
References: <20201121013739.18701-1-kartilak@cisco.com>
         <E34F9542-55FC-41EA-B757-9BBDCD6331C0@cisco.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-11-24 at 01:14 +0000, Arulprabhu Ponnusamy (arulponn)
wrote:
> Looks good.

I'm not sure why this look good.  It looks very odd to me.

> ﻿On 11/20/20, 5:38 PM, "Karan Tilak Kumar" <kartilak@cisco.com> wrote:
> 
>     Replacing shost_printk with FNIC_MAIN_DBG so that
>     these log messages are controlled by fnic_log_level
>     flag in fnic_handle_link.
[]
>     diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
[]
>     @@ -39,7 +39,7 @@
> 
>      #define DRV_NAME		"fnic"
>      #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
>     -#define DRV_VERSION		"1.6.0.50"
>     +#define DRV_VERSION		"1.6.0.51"

Versions are attached to the kernel version.
The general need for driver specific version information is low.

>      #define PFX			DRV_NAME ": "
>      #define DFX                     DRV_NAME "%d: "
> 
>     diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
>     index 3337d6627baf..e0cee4dcb439 100644
>     --- a/drivers/scsi/fnic/fnic_fcs.c
>     +++ b/drivers/scsi/fnic/fnic_fcs.c
>     @@ -75,7 +75,7 @@ void fnic_handle_link(struct work_struct *work)
>      	atomic64_set(&fnic->fnic_stats.misc_stats.current_port_speed,
>      			new_port_speed);
>      	if (old_port_speed != new_port_speed)
>     -		shost_printk(KERN_INFO, fnic->lport->host,
>     +		FNIC_MAIN_DBG(KERN_INFO, fnic->lport->host,
>      				"Current vnic speed set to :  %llu\n",
>      				new_port_speed);

It's odd to output this at KERN_INFO with call named _DBG

How about converting this and the other logging macros to something
like a style more commonly used in the kernel.

FNIC_<FOO>_DBG(KERN_INFO, host, ...)	-> fnic_info(host, <FOO>, ...)
FNIC_<FOO>_DBG(KERN_DEBUG, host, ...)	-> fnic_dbg(host, <FOO>, ...)
FNIC_MAIN_NOTE(KERN_NOTICE, host, ...)	-> fnic_notice(host, ...)

Perhaps some of these fnic_info uses really should use fnic_dbg.
Not my code, not my choices really, but I do think this is more sensible.
---
 drivers/scsi/fnic/fnic.h      |  36 ++---
 drivers/scsi/fnic/fnic_fcs.c  |  80 +++++------
 drivers/scsi/fnic/fnic_isr.c  |  10 +-
 drivers/scsi/fnic/fnic_main.c | 110 ++++++---------
 drivers/scsi/fnic/fnic_scsi.c | 310 +++++++++++++++++++-----------------------
 5 files changed, 234 insertions(+), 312 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 477513dc23b7..387f3e3c2bff 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -135,32 +135,18 @@ extern unsigned int io_completions;
 #define FNIC_SCSI_LOGGING 0x04
 #define FNIC_ISR_LOGGING 0x08
 
-#define FNIC_CHECK_LOGGING(LEVEL, CMD)				\
-do {								\
-	if (unlikely(fnic_log_level & LEVEL))			\
-		do {						\
-			CMD;					\
-		} while (0);					\
+#define fnic_notice(host, fmt, ...)					\
+	shost_printk(KERN_NOTICE, host, fmt, ##__VA_ARGS__)
+#define fnic_info(host, LEVEL, fmt, ...)				\
+do {									\
+	if (unlikely(fnic_log_level & FNIC_##LEVEL##_LOGGING))		\
+		shost_printk(KERN_INFO, host, fmt, ##__VA_ARGS__);	\
+} while (0)
+#define fnic_dbg(host, LEVEL, fmt, ...)					\
+do {									\
+	if (unlikely(fnic_log_level & FNIC_##LEVEL##_LOGGING))		\
+		shost_printk(KERN_DEBUG, host, fmt, ##__VA_ARGS__);	\
 } while (0)
-
-#define FNIC_MAIN_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_MAIN_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
-
-#define FNIC_FCS_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_FCS_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
-
-#define FNIC_SCSI_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_SCSI_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
-
-#define FNIC_ISR_DBG(kern_level, host, fmt, args...)		\
-	FNIC_CHECK_LOGGING(FNIC_ISR_LOGGING,			\
-			 shost_printk(kern_level, host, fmt, ##args);)
-
-#define FNIC_MAIN_NOTE(kern_level, host, fmt, args...)          \
-	shost_printk(kern_level, host, fmt, ##args)
 
 extern const char *fnic_state_str[];
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index e3384afb7cbd..134204ca71b7 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -73,9 +73,9 @@ void fnic_handle_link(struct work_struct *work)
 	atomic64_set(&fnic->fnic_stats.misc_stats.current_port_speed,
 			new_port_speed);
 	if (old_port_speed != new_port_speed)
-		shost_printk(KERN_INFO, fnic->lport->host,
-				"Current vnic speed set to :  %llu\n",
-				new_port_speed);
+		fnic_info(fnic->lport->host, MAIN,
+			  "Current vnic speed set to :  %llu\n",
+			  new_port_speed);
 
 	switch (vnic_dev_port_speed(fnic->vdev)) {
 	case DCEM_PORTSPEED_10G:
@@ -123,8 +123,7 @@ void fnic_handle_link(struct work_struct *work)
 					"Link Status:UP_DOWN_UP",
 					strlen("Link_Status:UP_DOWN_UP")
 					);
-				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-					     "link down\n");
+				fnic_dbg(fnic->lport->host, FCS, "link down\n");
 				fcoe_ctlr_link_down(&fnic->ctlr);
 				if (fnic->config.flags & VFCF_FIP_CAPABLE) {
 					/* start FCoE VLAN discovery */
@@ -138,8 +137,7 @@ void fnic_handle_link(struct work_struct *work)
 					fnic_fcoe_send_vlan_req(fnic);
 					return;
 				}
-				FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-					     "link up\n");
+				fnic_dbg(fnic->lport->host, FCS, "link up\n");
 				fcoe_ctlr_link_up(&fnic->ctlr);
 			} else {
 				/* UP -> UP */
@@ -162,7 +160,7 @@ void fnic_handle_link(struct work_struct *work)
 			fnic_fcoe_send_vlan_req(fnic);
 			return;
 		}
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link up\n");
+		fnic_dbg(fnic->lport->host, FCS, "link up\n");
 		fnic_fc_trace_set_data(fnic->lport->host->host_no, FNIC_FC_LE,
 			"Link Status: DOWN_UP", strlen("Link Status: DOWN_UP"));
 		fcoe_ctlr_link_up(&fnic->ctlr);
@@ -170,14 +168,14 @@ void fnic_handle_link(struct work_struct *work)
 		/* UP -> DOWN */
 		fnic->lport->host_stats.link_failure_count++;
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "link down\n");
+		fnic_dbg(fnic->lport->host, FCS, "link down\n");
 		fnic_fc_trace_set_data(
 			fnic->lport->host->host_no, FNIC_FC_LE,
 			"Link Status: UP_DOWN",
 			strlen("Link Status: UP_DOWN"));
 		if (fnic->config.flags & VFCF_FIP_CAPABLE) {
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				"deleting fip-timer during link-down\n");
+			fnic_dbg(fnic->lport->host, FCS,
+				 "deleting fip-timer during link-down\n");
 			del_timer_sync(&fnic->fip_timer);
 		}
 		fcoe_ctlr_link_down(&fnic->ctlr);
@@ -279,13 +277,13 @@ void fnic_handle_event(struct work_struct *work)
 			spin_lock_irqsave(&fnic->fnic_lock, flags);
 			break;
 		case FNIC_EVT_START_FCF_DISC:
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				  "Start FCF Discovery\n");
+			fnic_dbg(fnic->lport->host, FCS,
+				 "Start FCF Discovery\n");
 			fnic_fcoe_start_fcf_disc(fnic);
 			break;
 		default:
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				  "Unknown event 0x%x\n", fevt->event);
+			fnic_dbg(fnic->lport->host, FCS, "Unknown event 0x%x\n",
+				 fevt->event);
 			break;
 		}
 		kfree(fevt);
@@ -379,8 +377,7 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 	fnic->set_vlan(fnic, 0);
 
 	if (printk_ratelimit())
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
-			  "Sending VLAN request...\n");
+		fnic_info(fnic->lport->host, FCS, "Sending VLAN request...\n");
 
 	skb = dev_alloc_skb(sizeof(struct fip_vlan));
 	if (!skb)
@@ -432,12 +429,11 @@ static void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct sk_buff *skb)
 	u64 sol_time;
 	unsigned long flags;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
-		  "Received VLAN response...\n");
+	fnic_info(fnic->lport->host, FCS, "Received VLAN response...\n");
 
 	fiph = (struct fip_header *) skb->data;
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
+	fnic_info(fnic->lport->host, FCS,
 		  "Received VLAN response... OP 0x%x SUB_OP 0x%x\n",
 		  ntohs(fiph->fip_op), fiph->fip_subcode);
 
@@ -472,7 +468,7 @@ static void fnic_fcoe_process_vlan_resp(struct fnic *fnic, struct sk_buff *skb)
 	if (list_empty(&fnic->vlans)) {
 		/* retry from timer */
 		atomic64_inc(&fnic_stats->vlan_stats.resp_withno_vlanID);
-		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
+		fnic_info(fnic->lport->host, FCS,
 			  "No VLAN descriptors in FIP VLAN response\n");
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		goto out;
@@ -730,7 +726,7 @@ void fnic_update_mac_locked(struct fnic *fnic, u8 *new)
 		new = ctl;
 	if (ether_addr_equal(data, new))
 		return;
-	FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host, "update_mac %pM\n", new);
+	fnic_dbg(fnic->lport->host, FCS, "update_mac %pM\n", new);
 	if (!is_zero_ether_addr(data) && !ether_addr_equal(data, ctl))
 		vnic_dev_del_addr(fnic->vdev, data);
 	memcpy(data, new, ETH_ALEN);
@@ -772,8 +768,7 @@ void fnic_set_port_id(struct fc_lport *lport, u32 port_id, struct fc_frame *fp)
 	u8 *mac;
 	int ret;
 
-	FNIC_FCS_DBG(KERN_DEBUG, lport->host, "set port_id %x fp %p\n",
-		     port_id, fp);
+	fnic_dbg(lport->host, FCS, "set port_id %x fp %p\n", port_id, fp);
 
 	/*
 	 * If we're clearing the FC_ID, change to use the ctl_src_addr.
@@ -799,10 +794,9 @@ void fnic_set_port_id(struct fc_lport *lport, u32 port_id, struct fc_frame *fp)
 	if (fnic->state == FNIC_IN_ETH_MODE || fnic->state == FNIC_IN_FC_MODE)
 		fnic->state = FNIC_IN_ETH_TRANS_FC_MODE;
 	else {
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-			     "Unexpected fnic state %s while"
-			     " processing flogi resp\n",
-			     fnic_state_to_str(fnic->state));
+		fnic_dbg(fnic->lport->host, FCS,
+			 "Unexpected fnic state %s while processing flogi resp\n",
+			 fnic_state_to_str(fnic->state));
 		spin_unlock_irq(&fnic->fnic_lock);
 		return;
 	}
@@ -879,8 +873,8 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 		skb_trim(skb, bytes_written);
 		if (!fcs_ok) {
 			atomic64_inc(&fnic_stats->misc_stats.frame_errors);
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				     "fcs error.  dropping packet.\n");
+			fnic_dbg(fnic->lport->host, FCS,
+				 "fcs error.  dropping packet.\n");
 			goto drop;
 		}
 		if (fnic_import_rq_eth_pkt(fnic, skb))
@@ -895,12 +889,10 @@ static void fnic_rq_cmpl_frame_recv(struct vnic_rq *rq, struct cq_desc
 
 	if (!fcs_ok || packet_error || !fcoe_fc_crc_ok || fcoe_enc_error) {
 		atomic64_inc(&fnic_stats->misc_stats.frame_errors);
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-			     "fnic rq_cmpl fcoe x%x fcsok x%x"
-			     " pkterr x%x fcoe_fc_crc_ok x%x, fcoe_enc_err"
-			     " x%x\n",
-			     fcoe, fcs_ok, packet_error,
-			     fcoe_fc_crc_ok, fcoe_enc_error);
+		fnic_dbg(fnic->lport->host, FCS,
+			 "fnic rq_cmpl fcoe x%x fcsok x%x pkterr x%x fcoe_fc_crc_ok x%x, fcoe_enc_err x%x\n",
+			 fcoe, fcs_ok, packet_error,
+			 fcoe_fc_crc_ok, fcoe_enc_error);
 		goto drop;
 	}
 
@@ -976,8 +968,8 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 	len = FC_FRAME_HEADROOM + FC_MAX_FRAME + FC_FRAME_TAILROOM;
 	skb = dev_alloc_skb(len);
 	if (!skb) {
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-			     "Unable to allocate RQ sk_buff\n");
+		fnic_dbg(fnic->lport->host, FCS,
+			 "Unable to allocate RQ sk_buff\n");
 		return -ENOMEM;
 	}
 	skb_reset_mac_header(skb);
@@ -1342,8 +1334,8 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		/* no vlans available, try again */
 		if (printk_ratelimit())
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				  "Start VLAN Discovery\n");
+			fnic_dbg(fnic->lport->host, FCS,
+				 "Start VLAN Discovery\n");
 		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
 		return;
 	}
@@ -1354,16 +1346,16 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 		  vlan->vid, vlan->state, vlan->sol_count);
 	switch (vlan->state) {
 	case FIP_VLAN_USED:
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-			  "FIP VLAN is selected for FC transaction\n");
+		fnic_dbg(fnic->lport->host, FCS,
+			 "FIP VLAN is selected for FC transaction\n");
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		break;
 	case FIP_VLAN_FAILED:
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		/* if all vlans are in failed state, restart vlan disc */
 		if (printk_ratelimit())
-			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-				  "Start VLAN Discovery\n");
+			fnic_dbg(fnic->lport->host, FCS,
+				 "Start VLAN Discovery\n");
 		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
 		break;
 	case FIP_VLAN_SENT:
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 2fb2731f50fb..e85fab7452c8 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -263,8 +263,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
 			fnic->intr_count = vecs;
 			fnic->err_intr_offset = FNIC_MSIX_ERR_NOTIFY;
 
-			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
-				     "Using MSI-X Interrupts\n");
+			fnic_dbg(fnic->lport->host, ISR,
+				 "Using MSI-X Interrupts\n");
 			vnic_dev_set_intr_mode(fnic->vdev,
 					       VNIC_DEV_INTR_MODE_MSIX);
 			return 0;
@@ -289,8 +289,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->intr_count = 1;
 		fnic->err_intr_offset = 0;
 
-		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
-			     "Using MSI Interrupts\n");
+		fnic_dbg(fnic->lport->host, ISR, "Using MSI Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_MSI);
 
 		return 0;
@@ -315,8 +314,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 		fnic->cq_count = 3;
 		fnic->intr_count = 3;
 
-		FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
-			     "Using Legacy Interrupts\n");
+		fnic_dbg(fnic->lport->host, ISR, "Using Legacy Interrupts\n");
 		vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
 
 		return 0;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f8a7ef8f6a8..2f7ce533f565 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -220,9 +220,8 @@ static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host,
-			      "fnic: Get vnic stats failed"
-			      " 0x%x", ret);
+		fnic_dbg(fnic->lport->host, MAIN,
+			 "fnic: Get vnic stats failed 0x%x\n", ret);
 		return stats;
 	}
 	vs = fnic->stats;
@@ -248,66 +247,46 @@ static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 void fnic_dump_fchost_stats(struct Scsi_Host *host,
 				struct fc_host_statistics *stats)
 {
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: seconds since last reset = %llu\n",
-			stats->seconds_since_last_reset);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: tx frames		= %llu\n",
-			stats->tx_frames);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: tx words		= %llu\n",
-			stats->tx_words);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: rx frames		= %llu\n",
-			stats->rx_frames);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: rx words		= %llu\n",
-			stats->rx_words);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: lip count		= %llu\n",
-			stats->lip_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: nos count		= %llu\n",
-			stats->nos_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: error frames		= %llu\n",
-			stats->error_frames);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: dumped frames	= %llu\n",
-			stats->dumped_frames);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: link failure count	= %llu\n",
-			stats->link_failure_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: loss of sync count	= %llu\n",
-			stats->loss_of_sync_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: loss of signal count	= %llu\n",
-			stats->loss_of_signal_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: prim seq protocol err count = %llu\n",
-			stats->prim_seq_protocol_err_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: invalid tx word count= %llu\n",
-			stats->invalid_tx_word_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: invalid crc count	= %llu\n",
-			stats->invalid_crc_count);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: fcp input requests	= %llu\n",
-			stats->fcp_input_requests);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: fcp output requests	= %llu\n",
-			stats->fcp_output_requests);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: fcp control requests	= %llu\n",
-			stats->fcp_control_requests);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: fcp input megabytes	= %llu\n",
-			stats->fcp_input_megabytes);
-	FNIC_MAIN_NOTE(KERN_NOTICE, host,
-			"fnic: fcp output megabytes	= %llu\n",
-			stats->fcp_output_megabytes);
+	fnic_notice(host, "fnic: seconds since last reset = %llu\n",
+		    stats->seconds_since_last_reset);
+	fnic_notice(host, "fnic: tx frames		= %llu\n",
+		    stats->tx_frames);
+	fnic_notice(host, "fnic: tx words		= %llu\n",
+		    stats->tx_words);
+	fnic_notice(host, "fnic: rx frames		= %llu\n",
+		    stats->rx_frames);
+	fnic_notice(host, "fnic: rx words		= %llu\n",
+		    stats->rx_words);
+	fnic_notice(host, "fnic: lip count		= %llu\n",
+		    stats->lip_count);
+	fnic_notice(host, "fnic: nos count		= %llu\n",
+		    stats->nos_count);
+	fnic_notice(host, "fnic: error frames		= %llu\n",
+		    stats->error_frames);
+	fnic_notice(host, "fnic: dumped frames	= %llu\n",
+		    stats->dumped_frames);
+	fnic_notice(host, "fnic: link failure count	= %llu\n",
+		    stats->link_failure_count);
+	fnic_notice(host, "fnic: loss of sync count	= %llu\n",
+		    stats->loss_of_sync_count);
+	fnic_notice(host, "fnic: loss of signal count	= %llu\n",
+		    stats->loss_of_signal_count);
+	fnic_notice(host, "fnic: prim seq protocol err count = %llu\n",
+		    stats->prim_seq_protocol_err_count);
+	fnic_notice(host, "fnic: invalid tx word count= %llu\n",
+		    stats->invalid_tx_word_count);
+	fnic_notice(host, "fnic: invalid crc count	= %llu\n",
+		    stats->invalid_crc_count);
+	fnic_notice(host, "fnic: fcp input requests	= %llu\n",
+		    stats->fcp_input_requests);
+	fnic_notice(host, "fnic: fcp output requests	= %llu\n",
+		    stats->fcp_output_requests);
+	fnic_notice(host, "fnic: fcp control requests	= %llu\n",
+		    stats->fcp_control_requests);
+	fnic_notice(host, "fnic: fcp input megabytes	= %llu\n",
+		    stats->fcp_input_megabytes);
+	fnic_notice(host, "fnic: fcp output megabytes	= %llu\n",
+		    stats->fcp_output_megabytes);
 	return;
 }
 
@@ -332,9 +311,8 @@ static void fnic_reset_host_stats(struct Scsi_Host *host)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host,
-				"fnic: Reset vnic stats failed"
-				" 0x%x", ret);
+		fnic_dbg(fnic->lport->host, MAIN,
+			 "fnic: Reset vnic stats failed 0x%x\n", ret);
 		return;
 	}
 	fnic->stats_reset_time = jiffies;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d1f7b84bbfe8..9059d967288d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -240,12 +240,10 @@ int fnic_fw_reset_handler(struct fnic *fnic)
 
 	if (!ret) {
 		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_resets);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Issued fw reset\n");
+		fnic_dbg(fnic->lport->host, SCSI, "Issued fw reset\n");
 	} else {
 		fnic_clear_state_flags(fnic, FNIC_FLAGS_FWRESET);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Failed to issue fw reset\n");
+		fnic_dbg(fnic->lport->host, SCSI, "Failed to issue fw reset\n");
 	}
 
 	return ret;
@@ -288,15 +286,15 @@ int fnic_flogi_reg_handler(struct fnic *fnic, u32 fc_id)
 						fc_id, gw_mac,
 						fnic->data_src_addr,
 						lp->r_a_tov, lp->e_d_tov);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "FLOGI FIP reg issued fcid %x src %pM dest %pM\n",
-			      fc_id, fnic->data_src_addr, gw_mac);
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "FLOGI FIP reg issued fcid %x src %pM dest %pM\n",
+			 fc_id, fnic->data_src_addr, gw_mac);
 	} else {
 		fnic_queue_wq_copy_desc_flogi_reg(wq, SCSI_NO_TAG,
 						  format, fc_id, gw_mac);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "FLOGI reg issued fcid %x map %d dest %pM\n",
-			      fc_id, fnic->ctlr.map_dest, gw_mac);
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "FLOGI reg issued fcid %x map %d dest %pM\n",
+			 fc_id, fnic->ctlr.map_dest, gw_mac);
 	}
 
 	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
@@ -373,8 +371,8 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 
 	if (unlikely(!vnic_wq_copy_desc_avail(wq))) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], intr_flags);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-			  "fnic_queue_wq_copy_desc failure - no descriptors\n");
+		fnic_info(fnic->lport->host, SCSI, "%s - no descriptors\n",
+			  __func__);
 		atomic64_inc(&misc_stats->io_cpwq_alloc_failures);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -445,8 +443,8 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 
 	rport = starget_to_rport(scsi_target(sc->device));
 	if (!rport) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"returning DID_NO_CONNECT for IO as rport is NULL\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "returning DID_NO_CONNECT for IO as rport is NULL\n");
 		sc->result = DID_NO_CONNECT << 16;
 		done(sc);
 		return 0;
@@ -454,8 +452,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"rport is not ready\n");
+		fnic_dbg(fnic->lport->host, SCSI, "rport is not ready\n");
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		sc->result = ret;
 		done(sc);
@@ -464,9 +461,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 
 	rp = rport->dd_data;
 	if (!rp || rp->rp_state == RPORT_ST_DELETE) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"rport 0x%x removed, returning DID_NO_CONNECT\n",
-			rport->port_id);
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "rport 0x%x removed, returning DID_NO_CONNECT\n",
+			 rport->port_id);
 
 		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
 		sc->result = DID_NO_CONNECT<<16;
@@ -475,9 +472,9 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	}
 
 	if (rp->rp_state != RPORT_ST_READY) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
-			rport->port_id, rp->rp_state);
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "rport 0x%x in state 0x%x, returning DID_IMM_RETRY\n",
+			 rport->port_id, rp->rp_state);
 
 		sc->result = DID_IMM_RETRY << 16;
 		done(sc);
@@ -650,15 +647,14 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE) {
 		/* Check status of reset completion */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				      "reset cmpl success\n");
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "reset cmpl success\n");
 			/* Ready to send flogi out */
 			fnic->state = FNIC_IN_ETH_MODE;
 		} else {
-			FNIC_SCSI_DBG(KERN_DEBUG,
-				      fnic->lport->host,
-				      "fnic fw_reset : failed %s\n",
-				      fnic_fcpio_status_to_str(hdr_status));
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "fnic fw_reset : failed %s\n",
+				 fnic_fcpio_status_to_str(hdr_status));
 
 			/*
 			 * Unable to change to eth mode, cannot send out flogi
@@ -671,10 +667,9 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 			ret = -1;
 		}
 	} else {
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
-			      "Unexpected state %s while processing"
-			      " reset cmpl\n", fnic_state_to_str(fnic->state));
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "Unexpected state %s while processing reset cmpl\n",
+			 fnic_state_to_str(fnic->state));
 		atomic64_inc(&reset_stats->fw_reset_failures);
 		ret = -1;
 	}
@@ -725,22 +720,20 @@ static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
 
 		/* Check flogi registration completion status */
 		if (!hdr_status) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				      "flog reg succeeded\n");
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "flog reg succeeded\n");
 			fnic->state = FNIC_IN_FC_MODE;
 		} else {
-			FNIC_SCSI_DBG(KERN_DEBUG,
-				      fnic->lport->host,
-				      "fnic flogi reg :failed %s\n",
-				      fnic_fcpio_status_to_str(hdr_status));
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "fnic flogi reg :failed %s\n",
+				 fnic_fcpio_status_to_str(hdr_status));
 			fnic->state = FNIC_IN_ETH_MODE;
 			ret = -1;
 		}
 	} else {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Unexpected fnic state %s while"
-			      " processing flogi reg completion\n",
-			      fnic_state_to_str(fnic->state));
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "Unexpected fnic state %s while processing flogi reg completion\n",
+			 fnic_state_to_str(fnic->state));
 		ret = -1;
 	}
 
@@ -901,12 +894,9 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		if(FCPIO_ABORTED == hdr_status)
 			CMD_FLAGS(sc) |= FNIC_IO_ABORTED;
 
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-			"icmnd_cmpl abts pending "
-			  "hdr status = %s tag = 0x%x sc = 0x%p "
-			  "scsi_status = %x residual = %d\n",
-			  fnic_fcpio_status_to_str(hdr_status),
-			  id, sc,
+		fnic_info(fnic->lport->host, SCSI,
+			  "icmnd_cmpl abts pending hdr status = %s tag = 0x%x sc = 0x%p scsi_status = %x residual = %d\n",
+			  fnic_fcpio_status_to_str(hdr_status), id, sc,
 			  icmnd_cmpl->scsi_status,
 			  icmnd_cmpl->residual);
 		return;
@@ -1113,9 +1103,9 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 	if ((id & FNIC_TAG_ABORT) && (id & FNIC_TAG_DEV_RST)) {
 		/* Abort and terminate completion of device reset req */
 		/* REVISIT : Add asserts about various flags */
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "dev reset abts cmpl recd. id %x status %s\n",
-			      id, fnic_fcpio_status_to_str(hdr_status));
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "dev reset abts cmpl recd. id %x status %s\n",
+			 id, fnic_fcpio_status_to_str(hdr_status));
 		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 		CMD_ABTS_STATUS(sc) = hdr_status;
 		CMD_FLAGS(sc) |= FNIC_DEV_RST_DONE;
@@ -1135,9 +1125,9 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 					&term_stats->terminate_fw_timeouts);
 			break;
 		case FCPIO_ITMF_REJECTED:
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				"abort reject recd. id %d\n",
-				(int)(id & FNIC_TAG_MASK));
+			fnic_info(fnic->lport->host, SCSI,
+				  "abort reject recd. id %d\n",
+				  (int)(id & FNIC_TAG_MASK));
 			break;
 		case FCPIO_IO_NOT_FOUND:
 			if (CMD_FLAGS(sc) & FNIC_IO_ABTS_ISSUED)
@@ -1170,10 +1160,10 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
 			atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
 
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "abts cmpl recd. id %d status %s\n",
-			      (int)(id & FNIC_TAG_MASK),
-			      fnic_fcpio_status_to_str(hdr_status));
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "abts cmpl recd. id %d status %s\n",
+			 (int)(id & FNIC_TAG_MASK),
+			 fnic_fcpio_status_to_str(hdr_status));
 
 		/*
 		 * If scsi_eh thread is blocked waiting for abts to complete,
@@ -1184,8 +1174,8 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 			complete(io_req->abts_done);
 			spin_unlock_irqrestore(io_lock, flags);
 		} else {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				      "abts cmpl, completing IO\n");
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "abts cmpl, completing IO\n");
 			CMD_SP(sc) = NULL;
 			sc->result = (DID_ERROR << 16);
 
@@ -1226,11 +1216,10 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 				  jiffies_to_msecs(jiffies - start_time),
 				  desc, 0,
 				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"Terminate pending "
-				"dev reset cmpl recd. id %d status %s\n",
-				(int)(id & FNIC_TAG_MASK),
-				fnic_fcpio_status_to_str(hdr_status));
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "Terminate pending dev reset cmpl recd. id %d status %s\n",
+				 (int)(id & FNIC_TAG_MASK),
+				 fnic_fcpio_status_to_str(hdr_status));
 			return;
 		}
 		if (CMD_FLAGS(sc) & FNIC_DEV_RST_TIMED_OUT) {
@@ -1241,19 +1230,18 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 				  jiffies_to_msecs(jiffies - start_time),
 				  desc, 0,
 				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"dev reset cmpl recd after time out. "
-				"id %d status %s\n",
-				(int)(id & FNIC_TAG_MASK),
-				fnic_fcpio_status_to_str(hdr_status));
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "dev reset cmpl recd after time out. id %d status %s\n",
+				 (int)(id & FNIC_TAG_MASK),
+				 fnic_fcpio_status_to_str(hdr_status));
 			return;
 		}
 		CMD_STATE(sc) = FNIC_IOREQ_CMD_COMPLETE;
 		CMD_FLAGS(sc) |= FNIC_DEV_RST_DONE;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "dev reset cmpl recd. id %d status %s\n",
-			      (int)(id & FNIC_TAG_MASK),
-			      fnic_fcpio_status_to_str(hdr_status));
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "dev reset cmpl recd. id %d status %s\n",
+			 (int)(id & FNIC_TAG_MASK),
+			 fnic_fcpio_status_to_str(hdr_status));
 		if (io_req->dr_done)
 			complete(io_req->dr_done);
 		spin_unlock_irqrestore(io_lock, flags);
@@ -1312,9 +1300,9 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev *vdev,
 		break;
 
 	default:
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "firmware completion type %d\n",
-			      desc->hdr.type);
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "firmware completion type %d\n",
+			 desc->hdr.type);
 		break;
 	}
 
@@ -1418,10 +1406,10 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 		mempool_free(io_req, fnic->io_req_pool);
 
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "%s: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
-			      __func__, sc->request->tag, sc,
-			      (jiffies - start_time));
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "%s: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
+			 __func__, sc->request->tag, sc,
+			 (jiffies - start_time));
 
 		if (atomic64_read(&fnic->io_cmpl_skip))
 			atomic64_dec(&fnic->io_cmpl_skip);
@@ -1494,8 +1482,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 
 wq_copy_cleanup_scsi_cmd:
 	sc->result = DID_NO_CONNECT << 16;
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "wq_copy_cleanup_handler:"
-		      " DID_NO_CONNECT\n");
+	fnic_dbg(fnic->lport->host, SCSI, "wq_copy_cleanup_handler: DID_NO_CONNECT\n");
 
 	if (sc->scsi_done) {
 		FNIC_TRACE(fnic_wq_copy_cleanup_handler,
@@ -1536,8 +1523,8 @@ static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 	if (!vnic_wq_copy_desc_avail(wq)) {
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[0], flags);
 		atomic_dec(&fnic->in_flight);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_queue_abort_io_req: failure: no descriptors\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "%s: failure: no descriptors\n", __func__);
 		atomic64_inc(&misc_stats->abts_cpwq_alloc_failures);
 		return 1;
 	}
@@ -1571,10 +1558,8 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 	struct scsi_lun fc_lun;
 	enum fnic_ioreq_state old_ioreq_state;
 
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
-		      "fnic_rport_exch_reset called portid 0x%06x\n",
-		      port_id);
+	fnic_dbg(fnic->lport->host, SCSI, "%s called portid 0x%06x\n",
+		 __func__, port_id);
 
 	if (fnic->in_remove)
 		return;
@@ -1598,9 +1583,9 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
 			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_rport_exch_reset dev rst not pending sc 0x%p\n",
-			sc);
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "%s dev rst not pending sc 0x%p\n",
+				 __func__, sc);
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
@@ -1633,15 +1618,14 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
 			atomic64_inc(&reset_stats->device_reset_terminates);
 			abt_tag = (tag | FNIC_TAG_DEV_RST);
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_rport_exch_reset dev rst sc 0x%p\n",
-			sc);
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "%s dev rst sc 0x%p\n", __func__, sc);
 		}
 
 		BUG_ON(io_req->abts_done);
 
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "fnic_rport_reset_exch: Issuing abts\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "fnic_rport_reset_exch: Issuing abts\n");
 
 		spin_unlock_irqrestore(io_lock, flags);
 
@@ -1712,11 +1696,9 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		return;
 	}
 	fnic = lport_priv(lport);
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host, "fnic_terminate_rport_io called"
-		      " wwpn 0x%llx, wwnn0x%llx, rport 0x%p, portid 0x%06x\n",
-		      rport->port_name, rport->node_name, rport,
-		      rport->port_id);
+	fnic_dbg(fnic->lport->host, SCSI, "%s called wwpn 0x%llx, wwnn0x%llx, rport 0x%p, portid 0x%06x\n",
+		 __func__,
+		 rport->port_name, rport->node_name, rport, rport->port_id);
 
 	if (fnic->in_remove)
 		return;
@@ -1749,9 +1731,9 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
 			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_terminate_rport_io dev rst not pending sc 0x%p\n",
-			sc);
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "%s dev rst not pending sc 0x%p\n",
+				 __func__, sc);
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
@@ -1770,10 +1752,9 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 			fnic_ioreq_state_to_str(CMD_STATE(sc)));
 		}
 		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				  "fnic_terminate_rport_io "
-				  "IO not yet issued %p tag 0x%x flags "
-				  "%x state %d\n",
+			fnic_info(fnic->lport->host, SCSI,
+				  "%s IO not yet issued %p tag 0x%x flags %x state %d\n",
+				  __func__,
 				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
 		}
 		old_ioreq_state = CMD_STATE(sc);
@@ -1782,15 +1763,14 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
 			atomic64_inc(&reset_stats->device_reset_terminates);
 			abt_tag = (tag | FNIC_TAG_DEV_RST);
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_terminate_rport_io dev rst sc 0x%p\n", sc);
+			fnic_dbg(fnic->lport->host, SCSI,
+				 "%s dev rst sc 0x%p\n", __func__, sc);
 		}
 
 		BUG_ON(io_req->abts_done);
 
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
-			      "fnic_terminate_rport_io: Issuing abts\n");
+		fnic_dbg(fnic->lport->host, SCSI, "%s: Issuing abts\n",
+			 __func__);
 
 		spin_unlock_irqrestore(io_lock, flags);
 
@@ -1864,10 +1844,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	rport = starget_to_rport(scsi_target(sc->device));
 	tag = sc->request->tag;
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		fnic->lport->host,
-		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
-		rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
+	fnic_dbg(fnic->lport->host, SCSI,
+		 "Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
+		 rport->port_id, sc->device->lun, tag, CMD_FLAGS(sc));
 
 	CMD_FLAGS(sc) = FNIC_NO_FLAGS;
 
@@ -1919,8 +1898,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	else
 		atomic64_inc(&abts_stats->abort_issued_greater_than_60_sec);
 
-	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-		"CBD Opcode: %02x Abort issued time: %lu msec\n", sc->cmnd[0], abt_issued_time);
+	fnic_info(fnic->lport->host, SCSI,
+		  "CBD Opcode: %02x Abort issued time: %lu msec\n",
+		  sc->cmnd[0], abt_issued_time);
 	/*
 	 * Command is still pending, need to abort it
 	 * If the firmware completes the command after this point,
@@ -2009,8 +1989,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 	if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
 		spin_unlock_irqrestore(io_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"Issuing Host reset due to out of order IO\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "Issuing Host reset due to out of order IO\n");
 
 		ret = FAILED;
 		goto fnic_abort_cmd_end;
@@ -2057,10 +2037,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
 		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Returning from abort cmd type %x %s\n", task_req,
-		      (ret == SUCCESS) ?
-		      "SUCCESS" : "FAILED");
+	fnic_dbg(fnic->lport->host, SCSI,
+		 "Returning from abort cmd type %x %s\n",
+		 task_req, (ret == SUCCESS) ? "SUCCESS" : "FAILED");
 	return ret;
 }
 
@@ -2090,8 +2069,8 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 		free_wq_copy_descs(fnic, wq);
 
 	if (!vnic_wq_copy_desc_avail(wq)) {
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			  "queue_dr_io_req failure - no descriptors\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "queue_dr_io_req failure - no descriptors\n");
 		atomic64_inc(&misc_stats->devrst_cpwq_alloc_failures);
 		ret = -EAGAIN;
 		goto lr_io_req_end;
@@ -2164,9 +2143,8 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		 * Found IO that is still pending with firmware and
 		 * belongs to the LUN that we are resetting
 		 */
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Found IO in %s on lun\n",
-			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
+		fnic_dbg(fnic->lport->host, SCSI, "Found IO in %s on lun\n",
+			 fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
 		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
 			spin_unlock_irqrestore(io_lock, flags);
@@ -2174,9 +2152,9 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		}
 		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
 			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				"%s dev rst not pending sc 0x%p\n", __func__,
-				sc);
+			fnic_info(fnic->lport->host, SCSI,
+				  "%s dev rst not pending sc 0x%p\n",
+				  __func__, sc);
 			spin_unlock_irqrestore(io_lock, flags);
 			continue;
 		}
@@ -2200,7 +2178,7 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 		abt_tag = tag;
 		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
 			abt_tag |= FNIC_TAG_DEV_RST;
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			fnic_info(fnic->lport->host, SCSI,
 				  "%s: dev rst sc 0x%p\n", __func__, sc);
 		}
 
@@ -2356,9 +2334,9 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	atomic64_inc(&reset_stats->device_resets);
 
 	rport = starget_to_rport(scsi_target(sc->device));
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
-		      rport->port_id, sc->device->lun, sc);
+	fnic_dbg(fnic->lport->host, SCSI,
+		 "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
+		 rport->port_id, sc->device->lun, sc);
 
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		goto fnic_device_reset_end;
@@ -2407,7 +2385,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
 	spin_unlock_irqrestore(io_lock, flags);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %x\n", tag);
+	fnic_dbg(fnic->lport->host, SCSI, "TAG %x\n", tag);
 
 	/*
 	 * issue the device reset, if enqueue failed, clean up the ioreq
@@ -2435,8 +2413,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	io_req = (struct fnic_io_req *)CMD_SP(sc);
 	if (!io_req) {
 		spin_unlock_irqrestore(io_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "io_req is null tag 0x%x sc 0x%p\n", tag, sc);
 		goto fnic_device_reset_end;
 	}
 	io_req->dr_done = NULL;
@@ -2449,8 +2427,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	 */
 	if (status == FCPIO_INVALID_CODE) {
 		atomic64_inc(&reset_stats->device_reset_timeouts);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Device reset timed out\n");
+		fnic_dbg(fnic->lport->host, SCSI, "Device reset timed out\n");
 		CMD_FLAGS(sc) |= FNIC_DEV_RST_TIMED_OUT;
 		spin_unlock_irqrestore(io_lock, flags);
 		int_to_scsilun(sc->device->lun, &fc_lun);
@@ -2477,9 +2454,9 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 				CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 				io_req->abts_done = &tm_done;
 				spin_unlock_irqrestore(io_lock, flags);
-				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"Abort and terminate issued on Device reset "
-				"tag 0x%x sc 0x%p\n", tag, sc);
+				fnic_dbg(fnic->lport->host, SCSI,
+					 "Abort and terminate issued on Device reset tag 0x%x sc 0x%p\n",
+					 tag, sc);
 				break;
 			}
 		}
@@ -2503,9 +2480,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	/* Completed, but not successful, clean up the io_req, return fail */
 	if (status != FCPIO_SUCCESS) {
 		spin_lock_irqsave(io_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
-			      "Device reset completed - failed\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "Device reset completed - failed\n");
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		goto fnic_device_reset_clean;
 	}
@@ -2520,9 +2496,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Device reset failed"
-			      " since could not abort all IOs\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "Device reset failed since could not abort all IOs\n");
 		goto fnic_device_reset_clean;
 	}
 
@@ -2558,10 +2533,8 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	if (unlikely(tag_gen_flag))
 		fnic_scsi_host_end_tag(fnic, sc);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Returning from device reset %s\n",
-		      (ret == SUCCESS) ?
-		      "SUCCESS" : "FAILED");
+	fnic_dbg(fnic->lport->host, SCSI, "Returning from device reset %s\n",
+		 (ret == SUCCESS) ? "SUCCESS" : "FAILED");
 
 	if (ret == FAILED)
 		atomic64_inc(&reset_stats->device_reset_failures);
@@ -2581,8 +2554,7 @@ int fnic_reset(struct Scsi_Host *shost)
 	fnic = lport_priv(lp);
 	reset_stats = &fnic->fnic_stats.reset_stats;
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "fnic_reset called\n");
+	fnic_dbg(fnic->lport->host, SCSI, "%s called\n", __func__);
 
 	atomic64_inc(&reset_stats->fnic_resets);
 
@@ -2592,10 +2564,8 @@ int fnic_reset(struct Scsi_Host *shost)
 	 */
 	ret = fc_lport_reset(lp);
 
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "Returning from fnic reset %s\n",
-		      (ret == 0) ?
-		      "SUCCESS" : "FAILED");
+	fnic_dbg(fnic->lport->host, SCSI, "Returning from fnic reset %s\n",
+		 (ret == 0) ? "SUCCESS" : "FAILED");
 
 	if (ret == 0)
 		atomic64_inc(&reset_stats->fnic_reset_completions);
@@ -2628,8 +2598,8 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 		fnic->internal_reset_inprogress = true;
 	} else {
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"host reset in progress skipping another host reset\n");
+		fnic_dbg(fnic->lport->host, SCSI,
+			 "host reset in progress skipping another host reset\n");
 		return SUCCESS;
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2702,10 +2672,9 @@ void fnic_scsi_abort_io(struct fc_lport *lp)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->remove_wait = NULL;
-	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-		      "fnic_scsi_abort_io %s\n",
-		      (fnic->state == FNIC_IN_ETH_MODE) ?
-		      "SUCCESS" : "FAILED");
+	fnic_dbg(fnic->lport->host, SCSI, "%s %s\n",
+		 __func__,
+		 (fnic->state == FNIC_IN_ETH_MODE) ? "SUCCESS" : "FAILED");
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 }
@@ -2818,9 +2787,8 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 		 * Found IO that is still pending with firmware and
 		 * belongs to the LUN that we are resetting
 		 */
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-			      "Found IO in %s on lun\n",
-			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
+		fnic_info(fnic->lport->host, SCSI, "Found IO in %s on lun\n",
+			  fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
 		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
 			ret = 1;

