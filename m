From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/7] megaraid_sas : Jbod sequence number support
Date: Tue, 11 Aug 2015 21:29:13 -0400
Message-ID: <yq1h9o5e1li.fsf@sermon.lab.mkp.net>
References: <201508071230.t77CTw3x021043@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbbHLB35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 21:29:57 -0400
In-Reply-To: <201508071230.t77CTw3x021043@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Fri, 7 Aug 2015 17:53:42 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com


Sumit,

@@ -973,7 +973,12 @@ struct megasas_ctrl_info {
 
 	struct {
 #if defined(__BIG_ENDIAN_BITFIELD)
-		u32     reserved:12;
+		u32     reserved:7;
+		u32     useSeqNumJbodFP:1;
+		u32     supportExtendedSSCSize:1;
+		u32     supportDiskCacheSettingForSysPDs:1;
+		u32     supportCPLDUpdate:1;
+		u32     supportTTYLogCompression:1;
 		u32     discardCacheDuringLDDelete:1;
 		u32     supportSecurityonJBOD:1;
 		u32     supportCacheBypassModes:1;
@@ -1013,7 +1018,12 @@ struct megasas_ctrl_info {
 		u32     supportCacheBypassModes:1;
 		u32     supportSecurityonJBOD:1;
 		u32     discardCacheDuringLDDelete:1;
-		u32     reserved:12;
+		u32     supportTTYLogCompression:1;
+		u32     supportCPLDUpdate:1;
+		u32     supportDiskCacheSettingForSysPDs:1;
+		u32     supportExtendedSSCSize:1;
+		u32     useSeqNumJbodFP:1;
+		u32     reserved:7;
 #endif
 	} adapterOperations3;
 
Looks like most of these new flags should be in a separate patch.

@@ -4482,6 +4506,62 @@ megasas_destroy_irqs(struct megasas_instance *instance) {
 }
 
 /**
+ * megasas_setup_jbod_map -	setup jbod map for FP seq_number.
+ * @instance:				Adapter soft state
+ * @is_probe:				Driver probe check
+ *
+ * Return 0 on success.
+ */
+void
+megasas_setup_jbod_map(struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion = instance->ctrl_context;
+	u32 pd_seq_map_sz;
+
+	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+		(sizeof(struct MR_PD_CFG_SEQ) * (MAX_PHYSICAL_DEVICES - 1));

Why -1 here? Presumably MAX_PHYSICAL_DEVICES is a count, not an index.

+
+	if (reset_devices || !fusion ||
+		!instance->ctrl_info->adapterOperations3.useSeqNumJbodFP) {
+		dev_info(&instance->pdev->dev,
+			"Jbod map is not supported %s %d\n",
+			__func__, __LINE__);
+		instance->use_seqnum_jbod_fp = 0;

Nitpick: It's a bool so use false. Occurs throughout the patch.

+		return;
+	}
+
+	if (fusion->pd_seq_sync[0])
+		goto skip_alloc;
+
+	for (i = 0; i < 2; i++) {

Magic number. See comment below.

@@ -5510,10 +5594,16 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 
 	if (instance->aen_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-			instance->aen_cmd, 30);
+			instance->aen_cmd,
+			MEGASAS_BLOCKED_CMD_TIMEOUT);
 	if (instance->map_update_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-			instance->map_update_cmd, 30);
+			instance->map_update_cmd,
+			MEGASAS_BLOCKED_CMD_TIMEOUT);
+	if (instance->jbod_seq_cmd)
+		megasas_issue_blocked_abort_cmd(instance,
+			instance->jbod_seq_cmd,
+			MEGASAS_BLOCKED_CMD_TIMEOUT);
 	dcmd = &cmd->frame->dcmd;

Nice cleanup but ideally those non-jbod timeouts would have been in a
separate patch. Please make sure your patches only do what they purport
to do.

 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
@@ -5648,6 +5738,7 @@ megasas_resume(struct pci_dev *pdev)
 		}
 		if (!megasas_get_map_info(instance))
 			megasas_sync_map_info(instance);
+
 	}
 	break;
 	default:

Whitespace snafu.

@@ -5781,6 +5874,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	case PCI_DEVICE_ID_LSI_INVADER:
 	case PCI_DEVICE_ID_LSI_FURY:
 		megasas_release_fusion(instance);
+			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+				(sizeof(struct MR_PD_CFG_SEQ) *
+					(MAX_PHYSICAL_DEVICES - 1));
 		for (i = 0; i < 2 ; i++) {
 			if (fusion->ld_map[i])
 				dma_free_coherent(&instance->pdev->dev,

Minus one again.

+	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id & 1)];
+	pd_seq_h = fusion->pd_seq_phys[(instance->pd_seq_map_id & 1)];
+	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+			(sizeof(struct MR_PD_CFG_SEQ) *
+			(MAX_PHYSICAL_DEVICES - 1));

Patch description could do with a description of the data structures you
set up.


+		/*Want to send all IO via FW path*/

Comment needs spaces.

@@ -828,6 +844,8 @@ struct fusion_context {
 	u32 current_map_sz;
 	u32 drv_map_sz;
 	u32 drv_map_pages;
+	struct MR_PD_CFG_SEQ_NUM_SYNC	*pd_seq_sync[2];
+	dma_addr_t pd_seq_phys[2];

Please define a suitable constant for 2 and use it in the code.

-- 
Martin K. Petersen	Oracle Linux Engineering
