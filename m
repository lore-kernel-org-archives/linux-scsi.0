From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/5] mptfusion: Added sysfs expander manufacture information at the time of expander add.
Date: Wed, 16 Dec 2009 19:01:58 +0530
Message-ID: <20091216133150.GO31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:46972 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933182AbZLPN70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:59:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added new function mptsas_exp_manufacture_info, which will
obtain the REPORT_MANUFACTURING, and fill the details into the
sas_expander_device object when the expander port is created.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 83873e3..1b7f550 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2686,6 +2686,187 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	return error;
 }
 
+struct rep_manu_request{
+	u8 smp_frame_type;
+	u8 function;
+	u8 reserved;
+	u8 request_length;
+};
+
+struct rep_manu_reply{
+	u8 smp_frame_type; /* 0x41 */
+	u8 function; /* 0x01 */
+	u8 function_result;
+	u8 response_length;
+	u16 expander_change_count;
+	u8 reserved0[2];
+	u8 sas_format:1;
+	u8 reserved1:7;
+	u8 reserved2[3];
+	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
+	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
+	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
+	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+	u16 component_id;
+	u8 component_revision_id;
+	u8 reserved3;
+	u8 vendor_specific[8];
+};
+
+/**
+  * mptsas_exp_repmanufacture_info -
+  * @ioc: per adapter object
+  * @sas_address: expander sas address
+  * @edev: the sas_expander_device object
+  *
+  * Fills in the sas_expander_device object when SMP port is created.
+  *
+  * Returns 0 for success, non-zero for failure.
+  */
+static int
+mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
+	u64 sas_address, struct sas_expander_device *edev)
+{
+	MPT_FRAME_HDR *mf;
+	SmpPassthroughRequest_t *smpreq;
+	SmpPassthroughReply_t *smprep;
+	struct rep_manu_reply *manufacture_reply;
+	struct rep_manu_request *manufacture_request;
+	int ret;
+	int flagsLength;
+	unsigned long timeleft;
+	char *psge;
+	unsigned long flags;
+	void *data_out = NULL;
+	dma_addr_t data_out_dma = 0;
+	u32 sz;
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		printk(MYIOC_s_INFO_FMT "%s: host reset in progress!\n",
+			__func__, ioc->name);
+		return -EFAULT;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+	ret = mutex_lock_interruptible(&ioc->sas_mgmt.mutex);
+	if (ret)
+		goto out;
+
+	mf = mpt_get_msg_frame(mptsasMgmtCtx, ioc);
+	if (!mf) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	smpreq = (SmpPassthroughRequest_t *)mf;
+	memset(smpreq, 0, sizeof(*smpreq));
+
+	sz = sizeof(struct rep_manu_request) + sizeof(struct rep_manu_reply);
+
+	data_out = pci_alloc_consistent(ioc->pcidev, sz, &data_out_dma);
+	if (!data_out) {
+		printk(KERN_ERR "Memory allocation failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		ret = -ENOMEM;
+		goto put_mf;
+	}
+
+	manufacture_request = data_out;
+	manufacture_request->smp_frame_type = 0x40;
+	manufacture_request->function = 1;
+	manufacture_request->reserved = 0;
+	manufacture_request->request_length = 0;
+
+	smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;
+	smpreq->PhysicalPort = 0xFF;
+	*((u64 *)&smpreq->SASAddress) = cpu_to_le64(sas_address);
+	smpreq->RequestDataLength = sizeof(struct rep_manu_request);
+
+	psge = (char *)
+		(((int *) mf) + (offsetof(SmpPassthroughRequest_t, SGL) / 4));
+
+	flagsLength = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+		MPI_SGE_FLAGS_SYSTEM_ADDRESS |
+		MPI_SGE_FLAGS_HOST_TO_IOC |
+		MPI_SGE_FLAGS_END_OF_BUFFER;
+	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
+	flagsLength |= sizeof(struct rep_manu_request);
+
+	ioc->add_sge(psge, flagsLength, data_out_dma);
+	psge += ioc->SGE_size;
+
+	flagsLength = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+		MPI_SGE_FLAGS_SYSTEM_ADDRESS |
+		MPI_SGE_FLAGS_IOC_TO_HOST |
+		MPI_SGE_FLAGS_END_OF_BUFFER;
+	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
+	flagsLength |= sizeof(struct rep_manu_reply);
+	ioc->add_sge(psge, flagsLength, data_out_dma +
+	sizeof(struct rep_manu_request));
+
+	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
+	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
+
+	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
+	if (!(ioc->sas_mgmt.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
+		ret = -ETIME;
+		mpt_free_msg_frame(ioc, mf);
+		mf = NULL;
+		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
+			goto out_free;
+		if (!timeleft)
+			mpt_HardResetHandler(ioc, CAN_SLEEP);
+		goto out_free;
+	}
+
+	mf = NULL;
+
+	if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_RF_VALID) {
+		u8 *tmp;
+
+	smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
+	if (le16_to_cpu(smprep->ResponseDataLength) !=
+		sizeof(struct rep_manu_reply))
+			goto out_free;
+
+	manufacture_reply = data_out + sizeof(struct rep_manu_request);
+	strncpy(edev->vendor_id, manufacture_reply->vendor_id,
+		SAS_EXPANDER_VENDOR_ID_LEN);
+	strncpy(edev->product_id, manufacture_reply->product_id,
+		SAS_EXPANDER_PRODUCT_ID_LEN);
+	strncpy(edev->product_rev, manufacture_reply->product_rev,
+		SAS_EXPANDER_PRODUCT_REV_LEN);
+	edev->level = manufacture_reply->sas_format;
+	if (manufacture_reply->sas_format) {
+		strncpy(edev->component_vendor_id,
+			manufacture_reply->component_vendor_id,
+				SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+		tmp = (u8 *)&manufacture_reply->component_id;
+		edev->component_id = tmp[0] << 8 | tmp[1];
+		edev->component_revision_id =
+			manufacture_reply->component_revision_id;
+		}
+	} else {
+		printk(MYIOC_s_ERR_FMT
+			"%s: smp passthru reply failed to be returned\n",
+			ioc->name, __func__);
+		ret = -ENXIO;
+	}
+out_free:
+	if (data_out_dma)
+		pci_free_consistent(ioc->pcidev, sz, data_out, data_out_dma);
+put_mf:
+	if (mf)
+		mpt_free_msg_frame(ioc, mf);
+out_unlock:
+	CLEAR_MGMT_STATUS(ioc->sas_mgmt.status)
+	mutex_unlock(&ioc->sas_mgmt.mutex);
+out:
+	return ret;
+ }
+
 static void
 mptsas_parse_device_info(struct sas_identify *identify,
 		struct mptsas_devinfo *device_info)
@@ -2967,6 +3148,11 @@ static int mptsas_probe_one_phy(struct device *dev,
 			goto out;
 		}
 		mptsas_set_rphy(ioc, phy_info, rphy);
+		if (identify.device_type == SAS_EDGE_EXPANDER_DEVICE ||
+			identify.device_type == SAS_FANOUT_EXPANDER_DEVICE)
+				mptsas_exp_repmanufacture_info(ioc,
+					identify.sas_address,
+					rphy_to_expander_device(rphy));
 	}
 
  out:
