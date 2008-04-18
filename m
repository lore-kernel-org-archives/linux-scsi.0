From: akpm@linux-foundation.org
Subject: [patch 06/10] fusion: replace remaining __FUNCTION__ occurrences
Date: Fri, 18 Apr 2008 13:57:24 -0700
Message-ID: <200804182057.m3IKvOKl015380@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762376AbYDRU55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Apr 2008 16:57:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com, Eric.Moore@lsil.com

From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c  |   18 ++++-----
 drivers/message/fusion/mptctl.c   |    4 +-
 drivers/message/fusion/mptfc.c    |    8 ++--
 drivers/message/fusion/mptlan.c   |   26 ++++++-------
 drivers/message/fusion/mptsas.c   |   54 ++++++++++++++--------------
 drivers/message/fusion/mptscsih.c |    4 +-
 6 files changed, 57 insertions(+), 57 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~fusion-replace-remaining-__function__-occurrences drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~fusion-replace-remaining-__function__-occurrences
+++ a/drivers/message/fusion/mptbase.c
@@ -307,7 +307,7 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
 		MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
-				__FUNCTION__, ioc->name, cb_idx);
+				__func__, ioc->name, cb_idx);
 		goto out;
 	}
 
@@ -371,7 +371,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 	if (!cb_idx || cb_idx >= MPT_MAX_PROTOCOL_DRIVERS ||
 		MptCallbacks[cb_idx] == NULL) {
 		printk(MYIOC_s_WARN_FMT "%s: Invalid cb_idx (%d)!\n",
-				__FUNCTION__, ioc->name, cb_idx);
+				__func__, ioc->name, cb_idx);
 		freeme = 0;
 		goto out;
 	}
@@ -2342,7 +2342,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->cached_fw != NULL) {
 		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: Pushing FW onto "
-		    "adapter\n", __FUNCTION__, ioc->name));
+		    "adapter\n", __func__, ioc->name));
 		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)
 		    ioc->cached_fw, CAN_SLEEP)) < 0) {
 			printk(MYIOC_s_WARN_FMT
@@ -3601,7 +3601,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 
 	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
 		drsprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
-			"address=%p\n",  ioc->name, __FUNCTION__,
+			"address=%p\n",  ioc->name, __func__,
 			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
 		CHIPREG_WRITE32(&ioc->chip->Reset_1078, 0x07);
 		if (sleepFlag == CAN_SLEEP)
@@ -4650,12 +4650,12 @@ mptbase_sas_persist_operation(MPT_ADAPTE
 		break;
 	}
 
-	printk("%s: persist_opcode=%x\n",__FUNCTION__, persist_opcode);
+	printk("%s: persist_opcode=%x\n",__func__, persist_opcode);
 
 	/* Get a MF for this command.
 	 */
 	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
-		printk("%s: no msg frames!\n",__FUNCTION__);
+		printk("%s: no msg frames!\n",__func__);
 		return -1;
         }
 
@@ -4679,13 +4679,13 @@ mptbase_sas_persist_operation(MPT_ADAPTE
 	    (SasIoUnitControlReply_t *)ioc->persist_reply_frame;
 	if (le16_to_cpu(sasIoUnitCntrReply->IOCStatus) != MPI_IOCSTATUS_SUCCESS) {
 		printk("%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
-		    __FUNCTION__,
+		    __func__,
 		    sasIoUnitCntrReply->IOCStatus,
 		    sasIoUnitCntrReply->IOCLogInfo);
 		return -1;
 	}
 
-	printk("%s: success\n",__FUNCTION__);
+	printk("%s: success\n",__func__);
 	return 0;
 }
 
@@ -5692,7 +5692,7 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
 
 	if ((pAck = (EventAck_t *) mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
-		    ioc->name,__FUNCTION__));
+		    ioc->name,__func__));
 		return -1;
 	}
 
diff -puN drivers/message/fusion/mptctl.c~fusion-replace-remaining-__function__-occurrences drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~fusion-replace-remaining-__function__-occurrences
+++ a/drivers/message/fusion/mptctl.c
@@ -505,7 +505,7 @@ mptctl_event_process(MPT_ADAPTER *ioc, E
 	event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s() called\n",
-	    ioc->name, __FUNCTION__));
+	    ioc->name, __func__));
 	if(async_queue == NULL)
 		return 1;
 
@@ -2478,7 +2478,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	 */
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames!!\n",
-		    ioc->name,__FUNCTION__));
+		    ioc->name,__func__));
 		goto out;
 	}
 
diff -puN drivers/message/fusion/mptfc.c~fusion-replace-remaining-__function__-occurrences drivers/message/fusion/mptfc.c
--- a/drivers/message/fusion/mptfc.c~fusion-replace-remaining-__function__-occurrences
+++ a/drivers/message/fusion/mptfc.c
@@ -231,28 +231,28 @@ static int
 mptfc_abort(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __func__);
 }
 
 static int
 mptfc_dev_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __func__);
 }
 
 static int
 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __func__);
 }
 
 static int
 mptfc_host_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_host_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_host_reset, __func__);
 }
 
 static void
diff -puN drivers/message/fusion/mptlan.c~fusion-replace-remaining-__function__-occurrences drivers/message/fusion/mptlan.c
--- a/drivers/message/fusion/mptlan.c~fusion-replace-remaining-__function__-occurrences
+++ a/drivers/message/fusion/mptlan.c
@@ -610,7 +610,7 @@ mpt_lan_send_turbo(struct net_device *de
 
 	dioprintk((KERN_INFO MYNAM ": %s/%s: @%s, skb %p sent.\n",
 			IOC_AND_NETDEV_NAMES_s_s(dev),
-			__FUNCTION__, sent));
+			__func__, sent));
 
 	priv->SendCtl[ctx].skb = NULL;
 	pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
@@ -676,7 +676,7 @@ mpt_lan_send_reply(struct net_device *de
 
 		dioprintk((KERN_INFO MYNAM ": %s/%s: @%s, skb %p sent.\n",
 				IOC_AND_NETDEV_NAMES_s_s(dev),
-				__FUNCTION__, sent));
+				__func__, sent));
 
 		priv->SendCtl[ctx].skb = NULL;
 		pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
@@ -715,7 +715,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, s
 	u16 cur_naa = 0x1000;
 
 	dioprintk((KERN_INFO MYNAM ": %s called, skb_addr = %p\n",
-			__FUNCTION__, skb));
+			__func__, skb));
 
 	spin_lock_irqsave(&priv->txfidx_lock, flags);
 	if (priv->mpt_txfidx_tail < 0) {
@@ -723,7 +723,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, s
 		spin_unlock_irqrestore(&priv->txfidx_lock, flags);
 
 		printk (KERN_ERR "%s: no tx context available: %u\n",
-			__FUNCTION__, priv->mpt_txfidx_tail);
+			__func__, priv->mpt_txfidx_tail);
 		return 1;
 	}
 
@@ -733,7 +733,7 @@ mpt_lan_sdu_send (struct sk_buff *skb, s
 		spin_unlock_irqrestore(&priv->txfidx_lock, flags);
 
 		printk (KERN_ERR "%s: Unable to alloc request frame\n",
-			__FUNCTION__);
+			__func__);
 		return 1;
 	}
 
@@ -1208,7 +1208,7 @@ mpt_lan_post_receive_buckets(struct mpt_
 
 	dioprintk((KERN_INFO MYNAM ": %s/%s: @%s, Start_buckets = %u, buckets_out = %u\n",
 			IOC_AND_NETDEV_NAMES_s_s(dev),
-			__FUNCTION__, buckets, curr));
+			__func__, buckets, curr));
 
 	max = (mpt_dev->req_sz - MPT_LAN_RECEIVE_POST_REQUEST_SIZE) /
 			(MPT_LAN_TRANSACTION32_SIZE + sizeof(SGESimple64_t));
@@ -1217,9 +1217,9 @@ mpt_lan_post_receive_buckets(struct mpt_
 		mf = mpt_get_msg_frame(LanCtx, mpt_dev);
 		if (mf == NULL) {
 			printk (KERN_ERR "%s: Unable to alloc request frame\n",
-				__FUNCTION__);
+				__func__);
 			dioprintk((KERN_ERR "%s: %u buckets remaining\n",
-				 __FUNCTION__, buckets));
+				 __func__, buckets));
 			goto out;
 		}
 		pRecvReq = (LANReceivePostRequest_t *) mf;
@@ -1244,7 +1244,7 @@ mpt_lan_post_receive_buckets(struct mpt_
 			spin_lock_irqsave(&priv->rxfidx_lock, flags);
 			if (priv->mpt_rxfidx_tail < 0) {
 				printk (KERN_ERR "%s: Can't alloc context\n",
-					__FUNCTION__);
+					__func__);
 				spin_unlock_irqrestore(&priv->rxfidx_lock,
 						       flags);
 				break;
@@ -1267,7 +1267,7 @@ mpt_lan_post_receive_buckets(struct mpt_
 				if (skb == NULL) {
 					printk (KERN_WARNING
 						MYNAM "/%s: Can't alloc skb\n",
-						__FUNCTION__);
+						__func__);
 					priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
 					spin_unlock_irqrestore(&priv->rxfidx_lock, flags);
 					break;
@@ -1305,7 +1305,7 @@ mpt_lan_post_receive_buckets(struct mpt_
 
 		if (pSimple == NULL) {
 /**/			printk (KERN_WARNING MYNAM "/%s: No buckets posted\n",
-/**/				__FUNCTION__);
+/**/				__func__);
 			mpt_free_msg_frame(mpt_dev, mf);
 			goto out;
 		}
@@ -1329,9 +1329,9 @@ mpt_lan_post_receive_buckets(struct mpt_
 
 out:
 	dioprintk((KERN_INFO MYNAM "/%s: End_buckets = %u, priv->buckets_out = %u\n",
-		  __FUNCTION__, buckets, atomic_read(&priv->buckets_out)));
+		  __func__, buckets, atomic_read(&priv->buckets_out)));
 	dioprintk((KERN_INFO MYNAM "/%s: Posted %u buckets and received %u back\n",
-	__FUNCTION__, priv->total_posted, priv->total_received));
+	__func__, priv->total_posted, priv->total_received));
 
 	clear_bit(0, &priv->post_buckets_active);
 }
diff -puN drivers/message/fusion/mptsas.c~fusion-replace-remaining-__function__-occurrences drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c~fusion-replace-remaining-__function__-occurrences
+++ a/drivers/message/fusion/mptsas.c
@@ -300,7 +300,7 @@ mptsas_port_delete(MPT_ADAPTER *ioc, str
 	phy_info = port_info->phy_info;
 
 	dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: [%p]: num_phys=%02d "
-	    "bitmask=0x%016llX\n", ioc->name, __FUNCTION__, port_details,
+	    "bitmask=0x%016llX\n", ioc->name, __func__, port_details,
 	    port_details->num_phys, (unsigned long long)
 	    port_details->phy_bitmask));
 
@@ -411,7 +411,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 		 */
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: [%p]: deleting phy = %d\n",
-		    ioc->name, __FUNCTION__, port_details, i));
+		    ioc->name, __func__, port_details, i));
 		port_details->num_phys--;
 		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
@@ -497,7 +497,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc
 			continue;
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "%s: [%p]: phy_id=%02d num_phys=%02d "
-		    "bitmask=0x%016llX\n", ioc->name, __FUNCTION__,
+		    "bitmask=0x%016llX\n", ioc->name, __func__,
 		    port_details, i, port_details->num_phys,
 		    (unsigned long long)port_details->phy_bitmask));
 		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tport = %p rphy=%p\n",
@@ -553,7 +553,7 @@ mptsas_target_reset(MPT_ADAPTER *ioc, u8
 
 	if ((mf = mpt_get_msg_frame(ioc->TaskCtx, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, no msg frames @%d!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
+		    ioc->name,__func__, __LINE__));
 		return 0;
 	}
 
@@ -606,7 +606,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *i
 	    GFP_ATOMIC);
 	if (!target_reset_list) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
+		    ioc->name,__func__, __LINE__));
 		return;
 	}
 
@@ -673,7 +673,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *i
 	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 	if (!ev) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s, failed to allocate mem @%d..!!\n",
-		    ioc->name,__FUNCTION__, __LINE__));
+		    ioc->name,__func__, __LINE__));
 		return;
 	}
 
@@ -1183,7 +1183,7 @@ static int mptsas_phy_reset(struct sas_p
 	reply = (SasIoUnitControlReply_t *)ioc->sas_mgmt.reply;
 	if (reply->IOCStatus != MPI_IOCSTATUS_SUCCESS) {
 		printk(MYIOC_s_INFO_FMT "%s: IOCStatus=0x%X IOCLogInfo=0x%X\n",
-		    ioc->name, __FUNCTION__, reply->IOCStatus, reply->IOCLogInfo);
+		    ioc->name, __func__, reply->IOCStatus, reply->IOCLogInfo);
 		error = -ENXIO;
 		goto out_unlock;
 	}
@@ -1270,14 +1270,14 @@ static int mptsas_smp_handler(struct Scs
 
 	if (!rsp) {
 		printk(MYIOC_s_ERR_FMT "%s: the smp response space is missing\n",
-		    ioc->name, __FUNCTION__);
+		    ioc->name, __func__);
 		return -EINVAL;
 	}
 
 	/* do we need to support multiple segments? */
 	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
 		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-		    ioc->name, __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		    ioc->name, __func__, req->bio->bi_vcnt, req->data_len,
 		    rsp->bio->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
@@ -1343,7 +1343,7 @@ static int mptsas_smp_handler(struct Scs
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
 	if (!timeleft) {
-		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __FUNCTION__);
+		printk(MYIOC_s_ERR_FMT "%s: smp timeout!\n", ioc->name, __func__);
 		/* On timeout reset the board */
 		mpt_HardResetHandler(ioc, CAN_SLEEP);
 		ret = -ETIMEDOUT;
@@ -1361,7 +1361,7 @@ static int mptsas_smp_handler(struct Scs
 		rsp->data_len -= smprep->ResponseDataLength;
 	} else {
 		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
-		    ioc->name, __FUNCTION__);
+		    ioc->name, __func__);
 		ret = -ENXIO;
 	}
 unmap:
@@ -2006,7 +2006,7 @@ static int mptsas_probe_one_phy(struct d
 			if (error) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 				goto out;
 			}
 			mptsas_set_port(ioc, phy_info, port);
@@ -2076,7 +2076,7 @@ static int mptsas_probe_one_phy(struct d
 		if (!rphy) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-				__FUNCTION__, __LINE__));
+				__func__, __LINE__));
 			goto out;
 		}
 
@@ -2085,7 +2085,7 @@ static int mptsas_probe_one_phy(struct d
 		if (error) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-				__FUNCTION__, __LINE__));
+				__func__, __LINE__));
 			sas_rphy_free(rphy);
 			goto out;
 		}
@@ -2613,7 +2613,7 @@ mptsas_hotplug_work(struct work_struct *
 				    (ev->channel << 8) + ev->id)) {
 					dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-						__FUNCTION__, __LINE__));
+						__func__, __LINE__));
 					break;
 				}
 				phy_info = mptsas_find_phyinfo_by_sas_address(
@@ -2633,20 +2633,20 @@ mptsas_hotplug_work(struct work_struct *
 		if (!phy_info){
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-				__FUNCTION__, __LINE__));
+				__func__, __LINE__));
 			break;
 		}
 		if (!phy_info->port_details) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 		rphy = mptsas_get_rphy(phy_info);
 		if (!rphy) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 
@@ -2654,7 +2654,7 @@ mptsas_hotplug_work(struct work_struct *
 		if (!port) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 
@@ -2665,7 +2665,7 @@ mptsas_hotplug_work(struct work_struct *
 			if (!vtarget) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 				break;
 			}
 
@@ -2720,7 +2720,7 @@ mptsas_hotplug_work(struct work_struct *
 			(ev->channel << 8) + ev->id)) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 					"%s: exit at line=%d\n", ioc->name,
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 			break;
 		}
 
@@ -2732,7 +2732,7 @@ mptsas_hotplug_work(struct work_struct *
 		if (!phy_info || !phy_info->port_details) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 
@@ -2744,7 +2744,7 @@ mptsas_hotplug_work(struct work_struct *
 			if (!vtarget) {
 				dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				    "%s: exit at line=%d\n", ioc->name,
-				    __FUNCTION__, __LINE__));
+				    __func__, __LINE__));
 				break;
 			}
 			/*
@@ -2767,7 +2767,7 @@ mptsas_hotplug_work(struct work_struct *
 		if (mptsas_get_rphy(phy_info)) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			if (ev->channel) printk("%d\n", __LINE__);
 			break;
 		}
@@ -2776,7 +2776,7 @@ mptsas_hotplug_work(struct work_struct *
 		if (!port) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break;
 		}
 		memcpy(&phy_info->attached, &sas_device,
@@ -2801,7 +2801,7 @@ mptsas_hotplug_work(struct work_struct *
 		if (!rphy) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			break; /* non-fatal: an rphy can be added later */
 		}
 
@@ -2809,7 +2809,7 @@ mptsas_hotplug_work(struct work_struct *
 		if (sas_rphy_add(rphy)) {
 			dfailprintk(ioc, printk(MYIOC_s_ERR_FMT
 				"%s: exit at line=%d\n", ioc->name,
-			       	__FUNCTION__, __LINE__));
+			       	__func__, __LINE__));
 			sas_rphy_free(rphy);
 			break;
 		}
diff -puN drivers/message/fusion/mptscsih.c~fusion-replace-remaining-__function__-occurrences drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fusion-replace-remaining-__function__-occurrences
+++ a/drivers/message/fusion/mptscsih.c
@@ -461,7 +461,7 @@ mptscsih_issue_sep_command(MPT_ADAPTER *
 
 	if ((mf = mpt_get_msg_frame(ioc->InternalCtx, ioc)) == NULL) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: no msg frames!!\n",
-		    ioc->name,__FUNCTION__));
+		    ioc->name,__func__));
 		return;
 	}
 
@@ -2187,7 +2187,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 				(ioc->debug_level & MPT_DEBUG_TM ))
 		printk("%s: ha=%d [%d:%d:0] task_type=0x%02X "
 			"iocstatus=0x%04X\n\tloginfo=0x%08X response_code=0x%02X "
-			"term_cmnds=%d\n", __FUNCTION__, ioc->id, pScsiTmReply->Bus,
+			"term_cmnds=%d\n", __func__, ioc->id, pScsiTmReply->Bus,
 			 pScsiTmReply->TargetID, pScsiTmReq->TaskType,
 			le16_to_cpu(pScsiTmReply->IOCStatus),
 			le32_to_cpu(pScsiTmReply->IOCLogInfo),pScsiTmReply->ResponseCode,
_
