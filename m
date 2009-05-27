From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 16/22] mpt fusion: RESEND [2.6.30-rc6] Code Cleanup patch
Date: Wed, 27 May 2009 18:12:31 +0530
Message-ID: <20090527124222.GQ20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:47504 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764050AbZE0NDq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 09:03:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Resending patch considering Grants G's code review.

Main goal to submit this patch is code cleaup.
1. Better driver debug prints and code indentation.
2. fault_reset_work_lock is not used anywhere. driver is using taskmgmt_lock
instead of fault_reset_work_lock.
3. setting pci_set_drvdata properly.
4. Ingore config request when IOC is in reset state.( ioc_reset_in_progress
is set). 
5. Init/clear managment frame proprely.(INITIALIZE_MGMT_STATUS and
CLEAR_MGMT_STATUS)

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d67b263..76c34b9 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -207,7 +207,6 @@ static int	procmpt_iocinfo_read(char *buf, char **start, off_t offset,
 #endif
 static void	mpt_get_fw_exp_ver(char *buf, MPT_ADAPTER *ioc);
 
-//int		mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag);
 static int	ProcessEventNotification(MPT_ADAPTER *ioc,
 		EventNotificationReply_t *evReply, int *evHandlers);
 static void	mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf);
@@ -374,11 +373,11 @@ mpt_fault_reset_work(struct work_struct *work)
 		ioc = ioc->alt_ioc;
 
 	/* rearm the timer */
-	spin_lock_irqsave(&ioc->fault_reset_work_lock, flags);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	if (ioc->reset_work_q)
 		queue_delayed_work(ioc->reset_work_q, &ioc->fault_reset_work,
 			msecs_to_jiffies(MPT_POLLING_INTERVAL));
-	spin_unlock_irqrestore(&ioc->fault_reset_work_lock, flags);
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 }
 
 
@@ -972,11 +971,15 @@ mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
 
 	/*  Put Request back on FreeQ!  */
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
-	mf->u.frame.linkage.arg1 = 0xdeadbeaf; /* signature to know if this mf is freed */
+	if (cpu_to_le32(mf->u.frame.linkage.arg1) == 0xdeadbeaf)
+		goto out;
+	/* signature to know if this mf is freed */
+	mf->u.frame.linkage.arg1 = cpu_to_le32(0xdeadbeaf);
 	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
 #ifdef MFCNT
 	ioc->mfcnt--;
 #endif
+ out:
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 }
 
@@ -1731,6 +1734,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ioc->id = mpt_ids++;
 	sprintf(ioc->name, "ioc%d", ioc->id);
+	dinitprintk(ioc, printk(KERN_WARNING MYNAM ": mpt_adapter_install\n"));
 
 	/*
 	 * set initial debug level
@@ -1771,7 +1775,6 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->reply_sz = MPT_REPLY_FRAME_SIZE;
 
 	ioc->pcidev = pdev;
-	spin_lock_init(&ioc->initializing_hba_lock);
 
 	spin_lock_init(&ioc->taskmgmt_lock);
 	mutex_init(&ioc->internal_cmds.mutex);
@@ -1792,6 +1795,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->mfcnt = 0;
 #endif
 
+	ioc->sh = NULL;
 	ioc->cached_fw = NULL;
 
 	/* Initilize SCSI Config Data structure
@@ -1808,9 +1812,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Initialize workqueue */
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
-	spin_lock_init(&ioc->fault_reset_work_lock);
 
-	snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work_q_name),
+	snprintf(ioc->reset_work_q_name, MPT_KOBJ_NAME_LEN,
 		 "mpt_poll_%d", ioc->id);
 	ioc->reset_work_q =
 		create_singlethread_workqueue(ioc->reset_work_q_name);
@@ -1885,11 +1888,14 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	case MPI_MANUFACTPAGE_DEVID_SAS1064:
 	case MPI_MANUFACTPAGE_DEVID_SAS1068:
 		ioc->errata_flag_1064 = 1;
+		ioc->bus_type = SAS;
+		break;
 
 	case MPI_MANUFACTPAGE_DEVID_SAS1064E:
 	case MPI_MANUFACTPAGE_DEVID_SAS1068E:
 	case MPI_MANUFACTPAGE_DEVID_SAS1078:
 		ioc->bus_type = SAS;
+		break;
 	}
 
 
@@ -1933,7 +1939,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	spin_lock_init(&ioc->fw_event_lock);
-	snprintf(ioc->fw_event_q_name, 20, "mpt/%d", ioc->id);
+	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
 	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
 
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
@@ -2008,10 +2014,10 @@ mpt_detach(struct pci_dev *pdev)
 	/*
 	 * Stop polling ioc for fault condition
 	 */
-	spin_lock_irqsave(&ioc->fault_reset_work_lock, flags);
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	wq = ioc->reset_work_q;
 	ioc->reset_work_q = NULL;
-	spin_unlock_irqrestore(&ioc->fault_reset_work_lock, flags);
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 	cancel_delayed_work(&ioc->fault_reset_work);
 	destroy_workqueue(wq);
 
@@ -2234,12 +2240,16 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	ioc->active = 0;
 
 	if (ioc->alt_ioc) {
-		if (ioc->alt_ioc->active)
+		if (ioc->alt_ioc->active ||
+		    reason == MPT_HOSTEVENT_IOC_RECOVER) {
 			reset_alt_ioc_active = 1;
-
-		/* Disable alt-IOC's reply interrupts (and FreeQ) for a bit ... */
-		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, 0xFFFFFFFF);
-		ioc->alt_ioc->active = 0;
+			/* Disable alt-IOC's reply interrupts
+			 *  (and FreeQ) for a bit
+			 **/
+			CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask,
+				0xFFFFFFFF);
+			ioc->alt_ioc->active = 0;
+		}
 	}
 
 	hard = 1;
@@ -2260,9 +2270,11 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			}
 
 		} else {
-			printk(MYIOC_s_WARN_FMT "NOT READY!\n", ioc->name);
+			printk(MYIOC_s_WARN_FMT
+			    "NOT READY WARNING!\n", ioc->name);
 		}
-		return -1;
+		ret = -1;
+		goto out;
 	}
 
 	/* hard_reset_done = 0 if a soft reset was performed
@@ -2272,7 +2284,9 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		if ((rc = MakeIocReady(ioc->alt_ioc, 0, sleepFlag)) == 0)
 			alt_ioc_ready = 1;
 		else
-			printk(MYIOC_s_WARN_FMT "alt_ioc not ready!\n", ioc->alt_ioc->name);
+			printk(MYIOC_s_WARN_FMT
+			    ": alt-ioc Not ready WARNING!\n",
+			    ioc->alt_ioc->name);
 	}
 
 	for (ii=0; ii<5; ii++) {
@@ -2293,7 +2307,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	if (alt_ioc_ready) {
 		if ((rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason)) != 0) {
 			dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-			    "Initial Alt IocFacts failed rc=%x\n", ioc->name, rc));
+			    "Initial Alt IocFacts failed rc=%x\n",
+			    ioc->name, rc));
 			/* Retry - alt IOC was initialized once
 			 */
 			rc = GetIocFacts(ioc->alt_ioc, sleepFlag, reason);
@@ -2337,16 +2352,20 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			    IRQF_SHARED, ioc->name, ioc);
 			if (rc < 0) {
 				printk(MYIOC_s_ERR_FMT "Unable to allocate "
-				    "interrupt %d!\n", ioc->name, ioc->pcidev->irq);
+				    "interrupt %d!\n",
+				    ioc->name, ioc->pcidev->irq);
 				if (ioc->msi_enable)
 					pci_disable_msi(ioc->pcidev);
-				return -EBUSY;
+				ret = -EBUSY;
+				goto out;
 			}
 			irq_allocated = 1;
 			ioc->pci_irq = ioc->pcidev->irq;
 			pci_set_master(ioc->pcidev);		/* ?? */
-			dprintk(ioc, printk(MYIOC_s_INFO_FMT "installed at interrupt "
-			    "%d\n", ioc->name, ioc->pcidev->irq));
+			pci_set_drvdata(ioc->pcidev, ioc);
+			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+			    "installed at interrupt %d\n", ioc->name,
+			    ioc->pcidev->irq));
 		}
 	}
 
@@ -2355,17 +2374,22 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	 * init as upper addresses are needed for init.
 	 * If fails, continue with alt-ioc processing
 	 */
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "PrimeIocFifos\n",
+	    ioc->name));
 	if ((ret == 0) && ((rc = PrimeIocFifos(ioc)) != 0))
 		ret = -3;
 
 	/* May need to check/upload firmware & data here!
 	 * If fails, continue with alt-ioc processing
 	 */
+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "SendIocInit\n",
+	    ioc->name));
 	if ((ret == 0) && ((rc = SendIocInit(ioc, sleepFlag)) != 0))
 		ret = -4;
 // NEW!
 	if (alt_ioc_ready && ((rc = PrimeIocFifos(ioc->alt_ioc)) != 0)) {
-		printk(MYIOC_s_WARN_FMT ": alt_ioc (%d) FIFO mgmt alloc!\n",
+		printk(MYIOC_s_WARN_FMT
+		    ": alt-ioc (%d) FIFO mgmt alloc WARNING!\n",
 		    ioc->alt_ioc->name, rc);
 		alt_ioc_ready = 0;
 		reset_alt_ioc_active = 0;
@@ -2375,8 +2399,9 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		if ((rc = SendIocInit(ioc->alt_ioc, sleepFlag)) != 0) {
 			alt_ioc_ready = 0;
 			reset_alt_ioc_active = 0;
-			printk(MYIOC_s_WARN_FMT "alt_ioc (%d) init failure!\n",
-			    ioc->alt_ioc->name, rc);
+			printk(MYIOC_s_WARN_FMT
+				": alt-ioc: (%d) init failure WARNING!\n",
+					ioc->alt_ioc->name, rc);
 		}
 	}
 
@@ -2457,8 +2482,9 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		mutex_init(&ioc->raid_data.inactive_list_mutex);
 		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
 
-		if (ioc->bus_type == SAS) {
+		switch (ioc->bus_type) {
 
+		case SAS:
 			/* clear persistency table */
 			if(ioc->facts.IOCExceptions &
 			    MPI_IOCFACTS_EXCEPT_PERSISTENT_TABLE_FULL) {
@@ -2472,8 +2498,15 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			 */
 			mpt_findImVolumes(ioc);
 
-		} else if (ioc->bus_type == FC) {
-			if ((ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) &&
+			/* Check, and possibly reset, the coalescing value
+			 */
+			mpt_read_ioc_pg_1(ioc);
+
+			break;
+
+		case FC:
+			if ((ioc->pfacts[0].ProtocolFlags &
+				MPI_PORTFACTS_PROTOCOL_LAN) &&
 			    (ioc->lan_cnfg_page0.Header.PageLength == 0)) {
 				/*
 				 *  Pre-fetch the ports LAN MAC address!
@@ -2482,11 +2515,14 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 				(void) GetLanConfigPages(ioc);
 				a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-				    "LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
-				    ioc->name, a[5], a[4], a[3], a[2], a[1], a[0]));
-
+					"LanAddr = %02X:%02X:%02X"
+					":%02X:%02X:%02X\n",
+					ioc->name, a[5], a[4],
+					a[3], a[2], a[1], a[0]));
 			}
-		} else {
+			break;
+
+		case SPI:
 			/* Get NVRAM and adapter maximums from SPP 0 and 2
 			 */
 			mpt_GetScsiPortSettings(ioc, 0);
@@ -2505,6 +2541,8 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 			mpt_read_ioc_pg_1(ioc);
 
 			mpt_read_ioc_pg_4(ioc);
+
+			break;
 		}
 
 		GetIoUnitPage2(ioc);
@@ -2586,16 +2624,20 @@ mpt_detect_bound_ports(MPT_ADAPTER *ioc, struct pci_dev *pdev)
 		if (_pcidev == peer) {
 			/* Paranoia checks */
 			if (ioc->alt_ioc != NULL) {
-				printk(MYIOC_s_WARN_FMT "Oops, already bound to %s!\n",
-					ioc->name, ioc->alt_ioc->name);
+				printk(MYIOC_s_WARN_FMT
+				    "Oops, already bound (%s <==> %s)!\n",
+				    ioc->name, ioc->name, ioc->alt_ioc->name);
 				break;
 			} else if (ioc_srch->alt_ioc != NULL) {
-				printk(MYIOC_s_WARN_FMT "Oops, already bound to %s!\n",
-					ioc_srch->name, ioc_srch->alt_ioc->name);
+				printk(MYIOC_s_WARN_FMT
+				    "Oops, already bound (%s <==> %s)!\n",
+				    ioc_srch->name, ioc_srch->name,
+				    ioc_srch->alt_ioc->name);
 				break;
 			}
-			dprintk(ioc, printk(MYIOC_s_INFO_FMT "FOUND! binding to %s\n",
-				ioc->name, ioc_srch->name));
+			dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"FOUND! binding %s <==> %s\n",
+				ioc->name, ioc->name, ioc_srch->name));
 			ioc_srch->alt_ioc = ioc;
 			ioc->alt_ioc = ioc_srch;
 		}
@@ -2615,8 +2657,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	int ret;
 
 	if (ioc->cached_fw != NULL) {
-		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: Pushing FW onto "
-		    "adapter\n", __func__, ioc->name));
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"%s: Pushing FW onto adapter\n", __func__, ioc->name));
 		if ((ret = mpt_downloadboot(ioc, (MpiFwHeader_t *)
 		    ioc->cached_fw, CAN_SLEEP)) < 0) {
 			printk(MYIOC_s_WARN_FMT
@@ -2626,10 +2668,13 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 	}
 
 	/* Disable adapter interrupts! */
+	synchronize_irq(ioc->pcidev->irq);
 	CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
 	ioc->active = 0;
+
 	/* Clear any lingering interrupt */
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
+	CHIPREG_READ32(&ioc->chip->IntStatus);
 
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
@@ -2689,19 +2734,22 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		if((ret = mpt_host_page_access_control(ioc,
 		    MPI_DB_HPBAC_FREE_BUFFER, NO_SLEEP)) != 0) {
 			printk(MYIOC_s_ERR_FMT
-			   "host page buffers free failed (%d)!\n",
-			    ioc->name, ret);
+			   ": %s: host page buffers free failed (%d)!\n",
+			    ioc->name, __func__, ret);
 		}
-		dexitprintk(ioc, printk(MYIOC_s_INFO_FMT "HostPageBuffer free  @ %p, sz=%d bytes\n",
-		 	ioc->name, ioc->HostPageBuffer, ioc->HostPageBuffer_sz));
+		dexitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"HostPageBuffer free  @ %p, sz=%d bytes\n",
+			ioc->name, ioc->HostPageBuffer,
+			ioc->HostPageBuffer_sz));
 		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
 		    ioc->HostPageBuffer, ioc->HostPageBuffer_dma);
 		ioc->HostPageBuffer = NULL;
 		ioc->HostPageBuffer_sz = 0;
 		ioc->alloc_total -= ioc->HostPageBuffer_sz;
 	}
-}
 
+	pci_set_drvdata(ioc->pcidev, NULL);
+}
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_adapter_dispose - Free all resources associated with an MPT adapter
@@ -2841,8 +2889,12 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 	}
 
 	/* Is it already READY? */
-	if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_READY)
+	if (!statefault &&
+	    ((ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_READY)) {
+		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
+		    "IOC is in READY state\n", ioc->name));
 		return 0;
+	}
 
 	/*
 	 *	Check to see if IOC is in FAULT state.
@@ -2915,8 +2967,9 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 
 		ii++; cntdn--;
 		if (!cntdn) {
-			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state timeout(%d)!\n",
-					ioc->name, (int)((ii+5)/HZ));
+			printk(MYIOC_s_ERR_FMT
+				"Wait IOC_READY state (0x%x) timeout(%d)!\n",
+				ioc->name, ioc_state, (int)((ii+5)/HZ));
 			return -ETIME;
 		}
 
@@ -2929,9 +2982,8 @@ MakeIocReady(MPT_ADAPTER *ioc, int force, int sleepFlag)
 	}
 
 	if (statefault < 3) {
-		printk(MYIOC_s_INFO_FMT "Recovered from %s\n",
-				ioc->name,
-				statefault==1 ? "stuck handshake" : "IOC FAULT");
+		printk(MYIOC_s_INFO_FMT "Recovered from %s\n", ioc->name,
+			statefault == 1 ? "stuck handshake" : "IOC FAULT");
 	}
 
 	return hard_reset_done;
@@ -2984,8 +3036,9 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 
 	/* IOC *must* NOT be in RESET state! */
 	if (ioc->last_state == MPI_IOC_STATE_RESET) {
-		printk(MYIOC_s_ERR_FMT "Can't get IOCFacts NOT READY! (%08x)\n",
-		    ioc->name, ioc->last_state );
+		printk(KERN_ERR MYNAM
+		    ": ERROR - Can't get IOCFacts, %s NOT READY! (%08x)\n",
+		    ioc->name, ioc->last_state);
 		return -44;
 	}
 
@@ -3047,7 +3100,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 		 *	Old: u16{Major(4),Minor(4),SubMinor(8)}
 		 *	New: u32{Major(8),Minor(8),Unit(8),Dev(8)}
 		 */
-		if (facts->MsgVersion < 0x0102) {
+		if (facts->MsgVersion < MPI_VERSION_01_02) {
 			/*
 			 *	Handle old FC f/w style, convert to new...
 			 */
@@ -3059,9 +3112,11 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 			facts->FWVersion.Word = le32_to_cpu(facts->FWVersion.Word);
 
 		facts->ProductID = le16_to_cpu(facts->ProductID);
+
 		if ((ioc->facts.ProductID & MPI_FW_HEADER_PID_PROD_MASK)
 		    > MPI_FW_HEADER_PID_PROD_TARGET_SCSI)
 			ioc->ir_firmware = 1;
+
 		facts->CurrentHostMfaHighAddr =
 				le32_to_cpu(facts->CurrentHostMfaHighAddr);
 		facts->GlobalCredits = le16_to_cpu(facts->GlobalCredits);
@@ -3077,7 +3132,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
 		 * to 14 in MPI-1.01.0x.
 		 */
 		if (facts->MsgLength >= (offsetof(IOCFactsReply_t,FWImageSize) + 7)/4 &&
-		    facts->MsgVersion > 0x0100) {
+		    facts->MsgVersion > MPI_VERSION_01_00) {
 			facts->FWImageSize = le32_to_cpu(facts->FWImageSize);
 		}
 
@@ -3259,6 +3314,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
 
 	ioc_init.MaxDevices = (U8)ioc->devices_per_bus;
 	ioc_init.MaxBuses = (U8)ioc->number_of_buses;
+
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "facts.MsgVersion=%x\n",
 		   ioc->name, ioc->facts.MsgVersion));
 	if (ioc->facts.MsgVersion >= MPI_VERSION_01_05) {
@@ -3273,7 +3329,7 @@ SendIocInit(MPT_ADAPTER *ioc, int sleepFlag)
 	}
 	ioc_init.ReplyFrameSize = cpu_to_le16(ioc->reply_sz);	/* in BYTES */
 
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
+	if (ioc->sg_addr_size == sizeof(u64)) {
 		/* Save the upper 32-bits of the request
 		 * (reply) and sense buffers.
 		 */
@@ -3526,29 +3582,29 @@ mpt_do_upload(MPT_ADAPTER *ioc, int sleepFlag)
 	ii = mpt_handshake_req_reply_wait(ioc, request_size, (u32 *)prequest,
 	    reply_sz, (u16 *)preply, 65 /*seconds*/, sleepFlag);
 
-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT ": FW Upload completed rc=%x \n", ioc->name, ii));
+	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "FW Upload completed "
+	    "rc=%x \n", ioc->name, ii));
 
 	cmdStatus = -EFAULT;
 	if (ii == 0) {
 		/* Handshake transfer was complete and successful.
 		 * Check the Reply Frame.
 		 */
-		int status, transfer_sz;
-		status = le16_to_cpu(preply->IOCStatus);
-		if (status == MPI_IOCSTATUS_SUCCESS) {
-			transfer_sz = le32_to_cpu(preply->ActualImageSize);
-			if (transfer_sz == sz)
+		int status;
+		status = le16_to_cpu(preply->IOCStatus) &
+				MPI_IOCSTATUS_MASK;
+		if (status == MPI_IOCSTATUS_SUCCESS &&
+		    ioc->facts.FWImageSize ==
+		    le32_to_cpu(preply->ActualImageSize))
 				cmdStatus = 0;
-		}
 	}
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": do_upload cmdStatus=%d \n",
 			ioc->name, cmdStatus));
 
 
 	if (cmdStatus) {
-
-		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": fw upload failed, freeing image \n",
-			ioc->name));
+		ddlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "fw upload failed, "
+		    "freeing image \n", ioc->name));
 		mpt_free_fw_memory(ioc);
 	}
 	kfree(prequest);
@@ -3872,6 +3928,10 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 	CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 
 	if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
+
+		if (!ignore)
+			return 0;
+
 		drsprintk(ioc, printk(MYIOC_s_WARN_FMT "%s: Doorbell=%p; 1078 reset "
 			"address=%p\n",  ioc->name, __func__,
 			&ioc->chip->Doorbell, &ioc->chip->Reset_1078));
@@ -3889,6 +3949,7 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 				"looking for READY STATE: doorbell=%x"
 			        " count=%d\n",
 				ioc->name, doorbell, count));
+
 			if (doorbell == MPI_IOC_STATE_READY) {
 				return 1;
 			}
@@ -4039,6 +4100,10 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 				doorbell = CHIPREG_READ32(&ioc->chip->Doorbell);
 				doorbell &= MPI_IOC_STATE_MASK;
 
+				drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				    "looking for READY STATE: doorbell=%x"
+				    " count=%d\n", ioc->name, doorbell, count));
+
 				if (doorbell == MPI_IOC_STATE_READY) {
 					break;
 				}
@@ -4050,6 +4115,11 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ignore, int sleepFlag)
 					mdelay (1000);
 				}
 			}
+
+			if (doorbell != MPI_IOC_STATE_READY)
+				printk(MYIOC_s_ERR_FMT "Failed to come READY "
+				    "after reset! IocState=%x", ioc->name,
+				    doorbell);
 		}
 	}
 
@@ -4168,8 +4238,9 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag)
 			if (sleepFlag != CAN_SLEEP)
 				count *= 10;
 
-			printk(MYIOC_s_ERR_FMT "Wait IOC_READY state timeout(%d)!\n",
-			    ioc->name, (int)((count+5)/HZ));
+			printk(MYIOC_s_ERR_FMT
+			    "Wait IOC_READY state (0x%x) timeout(%d)!\n",
+			    ioc->name, state, (int)((count+5)/HZ));
 			return -ETIME;
 		}
 
@@ -4255,8 +4326,14 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "num_sge=%d numSGE=%d\n",
 		ioc->name, num_sge, numSGE));
 
-	if ( numSGE > MPT_SCSI_SG_DEPTH	)
-		numSGE = MPT_SCSI_SG_DEPTH;
+	if (ioc->bus_type == FC) {
+		if (numSGE > MPT_SCSI_FC_SG_DEPTH)
+			numSGE = MPT_SCSI_FC_SG_DEPTH;
+	}
+	else {
+		if (numSGE > MPT_SCSI_SG_DEPTH)
+			numSGE = MPT_SCSI_SG_DEPTH;
+	}
 
 	num_chain = 1;
 	while (numSGE - num_sge > 0) {
@@ -4493,6 +4570,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 	return 0;
 
 out_fail:
+
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
 		pci_free_consistent(ioc->pcidev,
@@ -5610,17 +5688,20 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
  *	-ENOMEM if pci_alloc failed
  **/
 int
-mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num, pRaidPhysDiskPage0_t phys_disk)
+mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num,
+			RaidPhysDiskPage0_t *phys_disk)
 {
-	CONFIGPARMS		 	cfg;
-	ConfigPageHeader_t	 	hdr;
+	CONFIGPARMS			cfg;
+	ConfigPageHeader_t		hdr;
 	dma_addr_t			dma_handle;
 	pRaidPhysDiskPage0_t		buffer = NULL;
 	int				rc;
 
 	memset(&cfg, 0 , sizeof(CONFIGPARMS));
 	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+	memset(phys_disk, 0, sizeof(RaidPhysDiskPage0_t));
 
+	hdr.PageVersion = MPI_RAIDPHYSDISKPAGE0_PAGEVERSION;
 	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_PHYSDISK;
 	cfg.cfghdr.hdr = &hdr;
 	cfg.physAddr = -1;
@@ -6074,7 +6155,8 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 	int		 ret;
 	u8		 page_type = 0, extend_page;
 	unsigned long 	 timeleft;
-	int		 in_isr;
+	unsigned long	 flags;
+    int		 in_isr;
 	u8		 issue_hard_reset = 0;
 	u8		 retry_count = 0;
 
@@ -6086,7 +6168,17 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 		dcprintk(ioc, printk(MYIOC_s_WARN_FMT "Config request not allowed in ISR context!\n",
 				ioc->name));
 		return -EPERM;
+    }
+
+	/* don't send a config page during diag reset */
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "%s: busy with host reset\n", ioc->name, __func__));
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		return -EBUSY;
 	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
 	/* don't send if no chance of success */
 	if (!ioc->active ||
@@ -6270,6 +6362,12 @@ mpt_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 			    MPT_MGMT_STATUS_DID_IOCRESET;
 			complete(&ioc->mptbase_cmds.done);
 		}
+/* wake up taskmgmt_cmds */
+		if (ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_PENDING) {
+			ioc->taskmgmt_cmds.status |=
+				MPT_MGMT_STATUS_DID_IOCRESET;
+			complete(&ioc->taskmgmt_cmds.done);
+		}
 		break;
 	default:
 		break;
@@ -6690,7 +6788,9 @@ int
 mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 {
 	int		 rc;
+	u8	 cb_idx;
 	unsigned long	 flags;
+	unsigned long	 time_count;
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler Entered!\n", ioc->name));
 #ifdef MFCNT
@@ -6721,30 +6821,24 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	 * Prevents timeouts occurring during a diagnostic reset...very bad.
 	 * For all other protocol drivers, this is a no-op.
 	 */
-	{
-		u8	 cb_idx;
-		int	 r = 0;
-
-		for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
-			if (MptResetHandlers[cb_idx]) {
-				dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling IOC reset_setup handler #%d\n",
-						ioc->name, cb_idx));
-				r += mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
-				if (ioc->alt_ioc) {
-					dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Calling alt-%s setup reset handler #%d\n",
-							ioc->name, ioc->alt_ioc->name, cb_idx));
-					r += mpt_signal_reset(cb_idx, ioc->alt_ioc, MPT_IOC_SETUP_RESET);
-				}
-			}
+	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
+		if (MptResetHandlers[cb_idx]) {
+			mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
+			if (ioc->alt_ioc)
+				mpt_signal_reset(cb_idx, ioc->alt_ioc,
+					MPT_IOC_SETUP_RESET);
 		}
 	}
 
-	if ((rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag)) != 0) {
-		printk(MYIOC_s_WARN_FMT "Cannot recover rc = %d!\n", ioc->name, rc);
+	time_count = jiffies;
+	rc = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_RECOVER, sleepFlag);
+	if (rc != 0) {
+		printk(KERN_WARNING MYNAM
+		    ": WARNING - (%d) Cannot recover %s\n", rc, ioc->name);
+	} else {
+		if (ioc->hard_resets < -1)
+			ioc->hard_resets++;
 	}
-	ioc->reload_fw = 0;
-	if (ioc->alt_ioc)
-		ioc->alt_ioc->reload_fw = 0;
 
 	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
 	ioc->ioc_reset_in_progress = 0;
@@ -6757,16 +6851,27 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, int sleepFlag)
 	}
 	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
 
-	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "HardResetHandler rc = %d!\n", ioc->name, rc));
+	dtmprintk(ioc,
+	    printk(MYIOC_s_DEBUG_FMT
+		"HardResetHandler: completed (%d seconds): %s\n", ioc->name,
+		jiffies_to_msecs(jiffies - time_count)/1000, ((rc == 0) ?
+		"SUCCESS" : "FAILED")));
 
 	return rc;
 }
 
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+#ifdef CONFIG_FUSION_LOGGING
 static void
-EventDescriptionStr(u8 event, u32 evData0, char *evStr)
+mpt_display_event_info(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply)
 {
 	char *ds = NULL;
+	u32 evData0;
+	int ii;
+	u8 event;
+	char *evStr = ioc->evStr;
+
+	event = le32_to_cpu(pEventReply->Event) & 0xFF;
+	evData0 = le32_to_cpu(pEventReply->Data[0]);
 
 	switch(event) {
 	case MPI_EVENT_NONE:
@@ -6800,9 +6905,9 @@ EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 		if (evData0 == MPI_EVENT_LOOP_STATE_CHANGE_LIP)
 			ds = "Loop State(LIP) Change";
 		else if (evData0 == MPI_EVENT_LOOP_STATE_CHANGE_LPE)
-			ds = "Loop State(LPE) Change";		/* ??? */
+			ds = "Loop State(LPE) Change";
 		else
-			ds = "Loop State(LPB) Change";		/* ??? */
+			ds = "Loop State(LPB) Change";
 		break;
 	case MPI_EVENT_LOGOUT:
 		ds = "Logout";
@@ -7002,28 +7107,53 @@ EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 	}
 	case MPI_EVENT_IR2:
 	{
+		u8 id = (u8)(evData0);
+		u8 channel = (u8)(evData0 >> 8);
+		u8 phys_num = (u8)(evData0 >> 24);
 		u8 ReasonCode = (u8)(evData0 >> 16);
+
 		switch (ReasonCode) {
 		case MPI_EVENT_IR2_RC_LD_STATE_CHANGED:
-			ds = "IR2: LD State Changed";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: LD State Changed: "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		case MPI_EVENT_IR2_RC_PD_STATE_CHANGED:
-			ds = "IR2: PD State Changed";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: PD State Changed "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		case MPI_EVENT_IR2_RC_BAD_BLOCK_TABLE_FULL:
-			ds = "IR2: Bad Block Table Full";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: Bad Block Table Full: "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		case MPI_EVENT_IR2_RC_PD_INSERTED:
-			ds = "IR2: PD Inserted";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: PD Inserted: "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		case MPI_EVENT_IR2_RC_PD_REMOVED:
-			ds = "IR2: PD Removed";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: PD Removed: "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		case MPI_EVENT_IR2_RC_FOREIGN_CFG_DETECTED:
-			ds = "IR2: Foreign CFG Detected";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: Foreign CFG Detected: "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		case MPI_EVENT_IR2_RC_REBUILD_MEDIUM_ERROR:
-			ds = "IR2: Rebuild Medium Error";
+			snprintf(evStr, EVENT_DESCR_STR_SZ,
+			    "IR2: Rebuild Medium Error: "
+			    "id=%d channel=%d phys_num=%d",
+			    id, channel, phys_num);
 			break;
 		default:
 			ds = "IR2";
@@ -7059,13 +7189,18 @@ EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 	case MPI_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
 	{
 		u8 reason = (u8)(evData0);
-		u8 port_num = (u8)(evData0 >> 8);
-		u16 handle = le16_to_cpu(evData0 >> 16);
 
-		snprintf(evStr, EVENT_DESCR_STR_SZ,
-		    "SAS Initiator Device Status Change: reason=0x%02x "
-		    "port=%d handle=0x%04x",
-		    reason, port_num, handle);
+		switch (reason) {
+		case MPI_EVENT_SAS_INIT_RC_ADDED:
+			ds = "SAS Initiator Status Change: Added";
+			break;
+		case MPI_EVENT_SAS_INIT_RC_REMOVED:
+			ds = "SAS Initiator Status Change: Deleted";
+			break;
+		default:
+			ds = "SAS Initiator Status Change";
+			break;
+		}
 		break;
 	}
 
@@ -7113,6 +7248,24 @@ EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 		break;
 	}
 
+	case MPI_EVENT_SAS_EXPANDER_STATUS_CHANGE:
+	{
+		u8 reason = (u8)(evData0);
+
+		switch (reason) {
+		case MPI_EVENT_SAS_EXP_RC_ADDED:
+			ds = "Expander Status Change: Added";
+			break;
+		case MPI_EVENT_SAS_EXP_RC_NOT_RESPONDING:
+			ds = "Expander Status Change: Deleted";
+			break;
+		default:
+			ds = "Expander Status Change";
+			break;
+		}
+		break;
+	}
+
 	/*
 	 *  MPT base "custom" events may be added here...
 	 */
@@ -7122,8 +7275,20 @@ EventDescriptionStr(u8 event, u32 evData0, char *evStr)
 	}
 	if (ds)
 		strncpy(evStr, ds, EVENT_DESCR_STR_SZ);
-}
 
+
+	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+	    "MPT event:(%02Xh) : %s\n",
+	    ioc->name, event, evStr));
+
+	devtverboseprintk(ioc, printk(KERN_DEBUG MYNAM
+	    ": Event data:\n"));
+	for (ii = 0; ii < le16_to_cpu(pEventReply->EventDataLength); ii++)
+		devtverboseprintk(ioc, printk(" %08x",
+		    le32_to_cpu(pEventReply->Data[ii])));
+	devtverboseprintk(ioc, printk(KERN_DEBUG "\n"));
+}
+#endif
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	ProcessEventNotification - Route EventNotificationReply to all event handlers
@@ -7140,37 +7305,24 @@ ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply
 {
 	u16 evDataLen;
 	u32 evData0 = 0;
-//	u32 evCtx;
 	int ii;
 	u8 cb_idx;
 	int r = 0;
 	int handlers = 0;
-	char evStr[EVENT_DESCR_STR_SZ];
 	u8 event;
 
 	/*
 	 *  Do platform normalization of values
 	 */
 	event = le32_to_cpu(pEventReply->Event) & 0xFF;
-//	evCtx = le32_to_cpu(pEventReply->EventContext);
 	evDataLen = le16_to_cpu(pEventReply->EventDataLength);
 	if (evDataLen) {
 		evData0 = le32_to_cpu(pEventReply->Data[0]);
 	}
 
-	EventDescriptionStr(event, evData0, evStr);
-	devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MPT event:(%02Xh) : %s\n",
-			ioc->name,
-			event,
-			evStr));
-
 #ifdef CONFIG_FUSION_LOGGING
-	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-	    ": Event data:\n", ioc->name));
-	for (ii = 0; ii < evDataLen; ii++)
-		devtverboseprintk(ioc, printk(" %08x",
-		    le32_to_cpu(pEventReply->Data[ii])));
-	devtverboseprintk(ioc, printk("\n"));
+	if (evDataLen)
+		mpt_display_event_info(ioc, pEventReply);
 #endif
 
 	/*
@@ -7225,8 +7377,9 @@ ProcessEventNotification(MPT_ADAPTER *ioc, EventNotificationReply_t *pEventReply
 	 */
 	for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
 		if (MptEvHandlers[cb_idx]) {
-			devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Routing Event to event handler #%d\n",
-					ioc->name, cb_idx));
+			devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			    "Routing Event to event handler #%d\n",
+			    ioc->name, cb_idx));
 			r += (*(MptEvHandlers[cb_idx]))(ioc, pEventReply);
 			handlers++;
 		}
@@ -7310,8 +7463,6 @@ mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info)
 	switch (info) {
 	case 0x00010000:
 		desc = "bug! MID not found";
-		if (ioc->reload_fw == 0)
-			ioc->reload_fw++;
 		break;
 
 	case 0x00020000:
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 11fc8f3..91499d1 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,7 +76,7 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.09"
+#define MPT_LINUX_VERSION_COMMON	"3.04.10"
 #define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.09"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
@@ -104,6 +104,7 @@
 #endif
 
 #define MPT_NAME_LENGTH			32
+#define MPT_KOBJ_NAME_LEN		20
 
 #define MPT_PROCFS_MPTBASEDIR		"mpt"
 						/* chg it to "driver/fusion" ? */
@@ -162,10 +163,10 @@
 /*
  * Set the MAX_SGE value based on user input.
  */
-#ifdef  CONFIG_FUSION_MAX_SGE
-#if     CONFIG_FUSION_MAX_SGE  < 16
+#ifdef CONFIG_FUSION_MAX_SGE
+#if CONFIG_FUSION_MAX_SGE  < 16
 #define MPT_SCSI_SG_DEPTH	16
-#elif   CONFIG_FUSION_MAX_SGE  > 128
+#elif CONFIG_FUSION_MAX_SGE  > 128
 #define MPT_SCSI_SG_DEPTH	128
 #else
 #define MPT_SCSI_SG_DEPTH	CONFIG_FUSION_MAX_SGE
@@ -174,6 +175,18 @@
 #define MPT_SCSI_SG_DEPTH	40
 #endif
 
+#ifdef CONFIG_FUSION_MAX_FC_SGE
+#if CONFIG_FUSION_MAX_FC_SGE  < 16
+#define MPT_SCSI_FC_SG_DEPTH	16
+#elif CONFIG_FUSION_MAX_FC_SGE  > 256
+#define MPT_SCSI_FC_SG_DEPTH	256
+#else
+#define MPT_SCSI_FC_SG_DEPTH	CONFIG_FUSION_MAX_FC_SGE
+#endif
+#else
+#define MPT_SCSI_FC_SG_DEPTH	40
+#endif
+
 /* debug print string length used for events and iocstatus */
 # define EVENT_DESCR_STR_SZ             100
 
@@ -576,6 +589,10 @@ typedef struct _MPT_ADAPTER
 	int			 pci_irq;	/* This irq           */
 	char			 name[MPT_NAME_LENGTH];	/* "iocN"             */
 	char			 prod_name[MPT_NAME_LENGTH];	/* "LSIFC9x9"         */
+#ifdef CONFIG_FUSION_LOGGING
+	/* used in mpt_display_event_info */
+	char			 evStr[EVENT_DESCR_STR_SZ];
+#endif
 	char			 board_name[16];
 	char			 board_assembly[16];
 	char			 board_tracer[16];
@@ -682,14 +699,11 @@ typedef struct _MPT_ADAPTER
 	int			 aen_event_read_flag; /* flag to indicate event log was read*/
 	u8			 FirstWhoInit;
 	u8			 upload_fw;	/* If set, do a fw upload */
-	u8			 reload_fw;	/* Force a FW Reload on next reset */
 	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
 	u8			 pad1[4];
 	u8			 DoneCtx;
 	u8			 TaskCtx;
 	u8			 InternalCtx;
-	spinlock_t		 initializing_hba_lock;
-	int 	 		 initializing_hba_lock_flag;
 	struct list_head	 list;
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
@@ -699,7 +713,7 @@ typedef struct _MPT_ADAPTER
 	struct list_head	 fw_event_list;
 	spinlock_t		 fw_event_lock;
 	u8			 fw_events_off; /* if '1', then ignore events */
-	char 			 fw_event_q_name[20];
+	char 			 fw_event_q_name[MPT_KOBJ_NAME_LEN];
 
 	struct mutex		 sas_discovery_mutex;
 	u8			 sas_discovery_runtime;
@@ -731,15 +745,22 @@ typedef struct _MPT_ADAPTER
 	u8			 fc_link_speed[2];
 	spinlock_t		 fc_rescan_work_lock;
 	struct work_struct	 fc_rescan_work;
-	char			 fc_rescan_work_q_name[20];
+	char			 fc_rescan_work_q_name[MPT_KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
+
+	/* driver forced bus resets count */
+	unsigned long		  hard_resets;
+	/* fw/external bus resets count */
+	unsigned long		  soft_resets;
+	/* cmd timeouts */
+	unsigned long		  timeouts;
+
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
 	u64			dma_mask;
-	char			 reset_work_q_name[20];
+	char			 reset_work_q_name[MPT_KOBJ_NAME_LEN];
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
-	spinlock_t		 fault_reset_work_lock;
 
 	u8			sg_addr_size;
 	u8			in_rescan;
@@ -870,9 +891,6 @@ typedef struct _MPT_SCSI_HOST {
 	MPT_FRAME_HDR		 *cmdPtr;		/* Ptr to nonOS request */
 	struct scsi_cmnd	 *abortSCpnt;
 	MPT_LOCAL_REPLY		  localReply;		/* internal cmd reply struct */
-	unsigned long		  hard_resets;		/* driver forced bus resets count */
-	unsigned long		  soft_resets;		/* fw/external bus resets count */
-	unsigned long		  timeouts;		/* cmd timeouts */
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 	char 			  *info_kbuf;
 	long			  last_queue_full;
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index ab62013..9b2e219 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2534,9 +2534,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 		MPT_SCSI_HOST *hd =  shost_priv(ioc->sh);
 
 		if (hd && (cim_rev == 1)) {
-			karg.hard_resets = hd->hard_resets;
-			karg.soft_resets = hd->soft_resets;
-			karg.timeouts = hd->timeouts;
+			karg.hard_resets = ioc->hard_resets;
+			karg.soft_resets = ioc->soft_resets;
+			karg.timeouts = ioc->timeouts;
 		}
 	}
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 8235f3f..3eb7b9c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -724,8 +724,8 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		 * Forming a port
 		 */
 		if (!port_details) {
-			port_details = kzalloc(sizeof(*port_details),
-				GFP_KERNEL);
+			port_details = kzalloc(sizeof(struct
+				mptsas_portinfo_details), GFP_KERNEL);
 			if (!port_details)
 				goto out;
 			port_details->num_phys = 1;
@@ -952,7 +952,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 
 	vtarget->deleted = 1; /* block IO */
 
-	target_reset_list = kzalloc(sizeof(*target_reset_list),
+	target_reset_list = kzalloc(sizeof(struct mptsas_target_reset_event),
 	    GFP_ATOMIC);
 	if (!target_reset_list) {
 		dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
@@ -1791,8 +1791,13 @@ static int mptsas_mgmt_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req,
 		memcpy(ioc->sas_mgmt.reply, reply,
 		    min(ioc->reply_sz, 4 * reply->u.reply.MsgLength));
 	}
-	complete(&ioc->sas_mgmt.done);
-	return 1;
+
+	if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_PENDING) {
+		ioc->sas_mgmt.status &= ~MPT_MGMT_STATUS_PENDING;
+		complete(&ioc->sas_mgmt.done);
+		return 1;
+	}
+	return 0;
 }
 
 static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
@@ -1831,6 +1836,7 @@ static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
 		MPI_SAS_OP_PHY_HARD_RESET : MPI_SAS_OP_PHY_LINK_RESET;
 	req->PhyNum = phy->identify.phy_identifier;
 
+	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done,
@@ -1862,6 +1868,7 @@ static int mptsas_phy_reset(struct sas_phy *phy, int hard_reset)
 	error = 0;
 
  out_unlock:
+	CLEAR_MGMT_STATUS(ioc->sas_mgmt.status)
 	mutex_unlock(&ioc->sas_mgmt.mutex);
  out:
 	return error;
@@ -1999,10 +2006,15 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	if (!dma_addr_out)
 		goto put_mf;
 	ioc->add_sge(psge, flagsLength, dma_addr_out);
-	psge += (sizeof(u32) + sizeof(dma_addr_t));
+	psge += ioc->SGE_size;
 
 	/* response */
-	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
+	flagsLength = MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+		MPI_SGE_FLAGS_SYSTEM_ADDRESS |
+		MPI_SGE_FLAGS_IOC_TO_HOST |
+		MPI_SGE_FLAGS_END_OF_BUFFER;
+
+	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
 	flagsLength |= rsp->data_len + 4;
 	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
 				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
@@ -2010,6 +2022,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		goto unmap;
 	ioc->add_sge(psge, flagsLength, dma_addr_in);
 
+	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
 
 	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
@@ -2031,7 +2044,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		req->data_len = 0;
 		rsp->data_len -= smprep->ResponseDataLength;
 	} else {
-		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
+		printk(MYIOC_s_ERR_FMT
+		    "%s: smp passthru reply failed to be returned\n",
 		    ioc->name, __func__);
 		ret = -ENXIO;
 	}
@@ -2046,6 +2060,7 @@ put_mf:
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
 out_unlock:
+	CLEAR_MGMT_STATUS(ioc->sas_mgmt.status)
 	mutex_unlock(&ioc->sas_mgmt.mutex);
 out:
 	return ret;
@@ -2109,7 +2124,7 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 
 	port_info->num_phys = buffer->NumPhys;
 	port_info->phy_info = kcalloc(port_info->num_phys,
-		sizeof(*port_info->phy_info),GFP_KERNEL);
+		sizeof(struct mptsas_phyinfo), GFP_KERNEL);
 	if (!port_info->phy_info) {
 		error = -ENOMEM;
 		goto out_free_consistent;
@@ -2271,10 +2286,6 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	__le64 sas_address;
 	int error=0;
 
-	if (ioc->sas_discovery_runtime &&
-		mptsas_is_end_device(device_info))
-			goto out;
-
 	hdr.PageVersion = MPI_SASDEVICE0_PAGEVERSION;
 	hdr.ExtPageLength = 0;
 	hdr.PageNumber = 0;
@@ -2315,6 +2326,7 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 
 	mptsas_print_device_pg0(ioc, buffer);
 
+	memset(device_info, 0, sizeof(struct mptsas_devinfo));
 	device_info->handle = le16_to_cpu(buffer->DevHandle);
 	device_info->handle_parent = le16_to_cpu(buffer->ParentDevHandle);
 	device_info->handle_enclosure =
@@ -2346,7 +2358,9 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 	SasExpanderPage0_t *buffer;
 	dma_addr_t dma_handle;
 	int i, error;
+	__le64 sas_address;
 
+	memset(port_info, 0, sizeof(struct mptsas_portinfo));
 	hdr.PageVersion = MPI_SASEXPANDER0_PAGEVERSION;
 	hdr.ExtPageLength = 0;
 	hdr.PageNumber = 0;
@@ -2392,18 +2406,23 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 	}
 
 	/* save config data */
-	port_info->num_phys = buffer->NumPhys;
+	port_info->num_phys = (buffer->NumPhys) ? buffer->NumPhys : 1;
 	port_info->phy_info = kcalloc(port_info->num_phys,
-		sizeof(*port_info->phy_info),GFP_KERNEL);
+		sizeof(struct mptsas_phyinfo), GFP_KERNEL);
 	if (!port_info->phy_info) {
 		error = -ENOMEM;
 		goto out_free_consistent;
 	}
 
+	memcpy(&sas_address, &buffer->SASAddress, sizeof(__le64));
 	for (i = 0; i < port_info->num_phys; i++) {
 		port_info->phy_info[i].portinfo = port_info;
 		port_info->phy_info[i].handle =
 		    le16_to_cpu(buffer->DevHandle);
+		port_info->phy_info[i].identify.sas_address =
+		    le64_to_cpu(sas_address);
+		port_info->phy_info[i].identify.handle_parent =
+		    le16_to_cpu(buffer->ParentDevHandle);
 	}
 
  out_free_consistent:
@@ -2423,11 +2442,7 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	dma_addr_t dma_handle;
 	int error=0;
 
-	if (ioc->sas_discovery_runtime &&
-		mptsas_is_end_device(&phy_info->attached))
-			goto out;
-
-	hdr.PageVersion = MPI_SASEXPANDER0_PAGEVERSION;
+	hdr.PageVersion = MPI_SASEXPANDER1_PAGEVERSION;
 	hdr.ExtPageLength = 0;
 	hdr.PageNumber = 1;
 	hdr.Reserved1 = 0;
@@ -2462,6 +2477,12 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
 	error = mpt_config(ioc, &cfg);
+
+	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
+		error = -ENODEV;
+		goto out;
+	}
+
 	if (error)
 		goto out_free_consistent;
 
@@ -2681,16 +2702,21 @@ static int mptsas_probe_one_phy(struct device *dev,
 				goto out;
 			}
 			mptsas_set_port(ioc, phy_info, port);
-			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-			    "sas_port_alloc: port=%p dev=%p port_id=%d\n",
-			    ioc->name, port, dev, port->port_identifier));
+			devtprintk(ioc, dev_printk(KERN_DEBUG, &port->dev,
+			    MYIOC_s_FMT "add port %d, sas_addr (0x%llx)\n",
+			    ioc->name, port->port_identifier,
+			    (unsigned long long)phy_info->
+			    attached.sas_address));
 		}
-		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "sas_port_add_phy: phy_id=%d\n",
-		    ioc->name, phy_info->phy_id));
+		dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+			"sas_port_add_phy: phy_id=%d\n",
+			ioc->name, phy_info->phy_id));
 		sas_port_add_phy(port, phy_info->phy);
 		phy_info->sas_port_add_phy = 0;
+		devtprintk(ioc, dev_printk(KERN_DEBUG, &phy_info->phy->dev,
+		    MYIOC_s_FMT "add phy %d, phy-obj (0x%p)\n", ioc->name,
+		     phy_info->phy_id, phy_info->phy));
 	}
-
 	if (!mptsas_get_rphy(phy_info) && port && !port->rphy) {
 
 		struct sas_rphy *rphy;
@@ -2703,9 +2729,10 @@ static int mptsas_probe_one_phy(struct device *dev,
 		 * the adding/removing of devices that occur
 		 * after start of day.
 		 */
-		if (ioc->sas_discovery_runtime &&
-			mptsas_is_end_device(&phy_info->attached))
-				goto out;
+		if (mptsas_is_end_device(&phy_info->attached) &&
+		    phy_info->attached.handle_parent) {
+			goto out;
+		}
 
 		mptsas_parse_device_info(&identify, &phy_info->attached);
 		if (scsi_is_host_device(parent)) {
@@ -3415,9 +3442,12 @@ mptsas_probe_devices(MPT_ADAPTER *ioc)
 	}
 }
 
-/*
- * Start of day discovery
- */
+/**
+ *	mptsas_scan_sas_topology -
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@sas_address:
+ *
+ **/
 static void
 mptsas_scan_sas_topology(MPT_ADAPTER *ioc)
 {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 955ddb4..ac072bc 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -80,7 +80,6 @@ MODULE_VERSION(my_VERSION);
 /*
  *  Other private/forward protos...
  */
-static struct scsi_cmnd * mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 static struct scsi_cmnd * mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i);
 static void	mptscsih_set_scsi_lookup(MPT_ADAPTER *ioc, int i, struct scsi_cmnd *scmd);
 static int	SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *scmd);
@@ -235,7 +234,8 @@ nextSGEset:
 	for (ii=0; ii < (numSgeThisFrame-1); ii++) {
 		thisxfer = sg_dma_len(sg);
 		if (thisxfer == 0) {
-			sg = sg_next(sg); /* Get next SG element from the OS */
+			/* Get next SG element from the OS */
+			sg = mpt_sg_next(sg);
 			sg_done++;
 			continue;
 		}
@@ -243,7 +243,8 @@ nextSGEset:
 		v2 = sg_dma_address(sg);
 		ioc->add_sge(psge, sgflags | thisxfer, v2);
 
-		sg = sg_next(sg);	/* Get next SG element from the OS */
+		/* Get next SG element from the OS */
+		sg = mpt_sg_next(sg);
 		psge += ioc->SGE_size;
 		sgeOffset += ioc->SGE_size;
 		sg_done++;
@@ -532,14 +533,15 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, struct scsi_cmnd *sc, SCSIIOReply_t * pSc
 	}
 
 	scsi_print_command(sc);
-	printk(MYIOC_s_DEBUG_FMT "\tfw_channel = %d, fw_id = %d\n",
-	    ioc->name, pScsiReply->Bus, pScsiReply->TargetID);
+	printk(MYIOC_s_DEBUG_FMT "\tfw_channel = %d, fw_id = %d, lun = %d\n",
+	    ioc->name, pScsiReply->Bus, pScsiReply->TargetID, sc->device->lun);
 	printk(MYIOC_s_DEBUG_FMT "\trequest_len = %d, underflow = %d, "
 	    "resid = %d\n", ioc->name, scsi_bufflen(sc), sc->underflow,
 	    scsi_get_resid(sc));
 	printk(MYIOC_s_DEBUG_FMT "\ttag = %d, transfer_count = %d, "
 	    "sc->result = %08X\n", ioc->name, le16_to_cpu(pScsiReply->TaskTag),
 	    le32_to_cpu(pScsiReply->TransferCount), sc->result);
+
 	printk(MYIOC_s_DEBUG_FMT "\tiocstatus = %s (0x%04x), "
 	    "scsi_status = %s (0x%02x), scsi_state = (0x%02x)\n",
 	    ioc->name, desc, ioc_status, desc1, pScsiReply->SCSIStatus,
@@ -594,16 +596,14 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 	req_idx_MR = (mr != NULL) ?
 	    le16_to_cpu(mr->u.frame.hwhdr.msgctxu.fld.req_idx) : req_idx;
+
+	/* Special case, where already freed message frame is received from
+	 * Firmware. It happens with Resetting IOC.
+	 * Return immediately. Do not care
+	 */
 	if ((req_idx != req_idx_MR) ||
-	    (mf->u.frame.linkage.arg1 == 0xdeadbeaf)) {
-		printk(MYIOC_s_ERR_FMT "Received a mf that was already freed\n",
-		    ioc->name);
-		printk (MYIOC_s_ERR_FMT
-		    "req_idx=%x req_idx_MR=%x mf=%p mr=%p sc=%p\n",
-		    ioc->name, req_idx, req_idx_MR, mf, mr,
-		    mptscsih_get_scsi_lookup(ioc, req_idx_MR));
+	    (le32_to_cpu(mf->u.frame.linkage.arg1) == 0xdeadbeaf))
 		return 0;
-	}
 
 	sc = mptscsih_getclear_scsi_lookup(ioc, req_idx);
 	if (sc == NULL) {
@@ -750,12 +750,16 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			 */
 
 		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
-		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			/* Linux handles an unsolicited DID_RESET better
 			 * than an unsolicited DID_ABORT.
 			 */
 			sc->result = DID_RESET << 16;
 
+		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
+			if (ioc->bus_type == FC)
+				sc->result = DID_ERROR << 16;
+			else
+				sc->result = DID_RESET << 16;
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
@@ -932,9 +936,9 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 		scsi_dma_unmap(sc);
 		sc->result = DID_RESET << 16;
 		sc->host_scribble = NULL;
-		sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
-		    "completing cmds: fw_channel %d, fw_id %d, sc=%p,"
-		    " mf = %p, idx=%x\n", ioc->name, channel, id, sc, mf, ii);
+		dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
+		    "completing cmds: fw_channel %d, fw_id %d, sc=%p, mf = %p, "
+		    "idx=%x\n", ioc->name, channel, id, sc, mf, ii));
 		sc->scsi_done(sc);
 	}
 }
@@ -993,9 +997,11 @@ mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
-			sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT "completing cmds: fw_channel %d,"
-			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name, vdevice->vtarget->channel,
-			   vdevice->vtarget->id, sc, mf, ii);
+			dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device,
+			   MYIOC_s_FMT "completing cmds: fw_channel %d, "
+			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name,
+			   vdevice->vtarget->channel, vdevice->vtarget->id,
+			   sc, mf, ii));
 			sc->scsi_done(sc);
 			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 		}
@@ -1286,7 +1292,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	MPT_FRAME_HDR		*mf;
 	SCSIIORequest_t		*pScsiReq;
 	VirtDevice		*vdevice = SCpnt->device->hostdata;
-	int	 lun;
 	u32	 datalen;
 	u32	 scsictl;
 	u32	 scsidir;
@@ -1297,7 +1302,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
-	lun = SCpnt->device->lun;
 	SCpnt->scsi_done = done;
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
@@ -1707,8 +1711,8 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
-	if (hd->timeouts < -1)
-		hd->timeouts++;
+	if (ioc->timeouts < -1)
+		ioc->timeouts++;
 
 	if (mpt_fwfault_debug)
 		mpt_halt_firmware(ioc);
@@ -1732,17 +1736,23 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 			 ctx2abort, mptscsih_get_tm_timeout(ioc));
 
 	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
-	    SCpnt->serial_number == sn)
+	    SCpnt->serial_number == sn) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command still in active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
 		retval = FAILED;
+	} else {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: command cleared from active list! (sc=%p)\n",
+		    ioc->name, SCpnt));
+		retval = SUCCESS;
+	}
 
  out:
 	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
 
-	if (retval == 0)
-		return SUCCESS;
-	else
-		return FAILED;
+	return retval;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1777,7 +1787,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		retval = 0;
+		retval = SUCCESS;
 		goto out;
 	}
 
@@ -1835,10 +1845,12 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 	       ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
 
-	if (hd->timeouts < -1)
-		hd->timeouts++;
+	if (ioc->timeouts < -1)
+		ioc->timeouts++;
 
 	vdevice = SCpnt->device->hostdata;
+	if (!vdevice || !vdevice->vtarget)
+		return SUCCESS;
 	retval = mptscsih_IssueTaskMgmt(hd,
 					MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 					vdevice->vtarget->channel, 0, 0, 0,
@@ -1866,8 +1878,9 @@ int
 mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
-	int              retval;
+	int              status = SUCCESS;
 	MPT_ADAPTER	*ioc;
+	int		retval;
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
@@ -1886,19 +1899,16 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-	if (mpt_HardResetHandler(ioc, CAN_SLEEP) < 0) {
-		retval = FAILED;
-	} else {
-		/*  Make sure TM pending is cleared and TM state is set to
-		 *  NONE.
-		 */
-		retval = 0;
-	}
+    retval = mpt_HardResetHandler(ioc, CAN_SLEEP);
+	if (retval < 0)
+		status = FAILED;
+	else
+		status = SUCCESS;
 
 	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
 	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
 
-	return retval;
+	return status;
 }
 
 static int
@@ -2242,7 +2252,6 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    sdev->ppr, sdev->inquiry_len));
 
 	vdevice->configured_lun = 1;
-	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"Queue depth=%d, tflags=%x\n",
@@ -2254,6 +2263,7 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
+	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d, ordered %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
@@ -2326,36 +2336,17 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 	}
 }
 
-/**
- * mptscsih_get_scsi_lookup
- * @ioc: Pointer to MPT_ADAPTER structure
- * @i: index into the array
- *
- * retrieves scmd entry from ScsiLookup[] array list
- *
- * Returns the scsi_cmd pointer
- **/
-static struct scsi_cmnd *
-mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i)
-{
-	unsigned long	flags;
-	struct scsi_cmnd *scmd;
-
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = ioc->ScsiLookup[i];
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-
-	return scmd;
-}
 
 /**
  * mptscsih_getclear_scsi_lookup
- * @ioc: Pointer to MPT_ADAPTER structure
- * @i: index into the array
  *
  * retrieves and clears scmd entry from ScsiLookup[] array list
  *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @i: index into the array
+ *
  * Returns the scsi_cmd pointer
+ *
  **/
 static struct scsi_cmnd *
 mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i)
@@ -2454,57 +2445,16 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 int
 mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 {
-	MPT_SCSI_HOST *hd;
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
 
 	devtverboseprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"MPT event (=%02Xh) routed to SCSI host driver!\n",
 		ioc->name, event));
 
-	if (ioc->sh == NULL ||
-		((hd = shost_priv(ioc->sh)) == NULL))
-		return 1;
-
-	switch (event) {
-	case MPI_EVENT_UNIT_ATTENTION:			/* 03 */
-		/* FIXME! */
-		break;
-	case MPI_EVENT_IOC_BUS_RESET:			/* 04 */
-	case MPI_EVENT_EXT_BUS_RESET:			/* 05 */
-		if (hd && (ioc->bus_type == SPI) && (hd->soft_resets < -1))
-			hd->soft_resets++;
-		break;
-	case MPI_EVENT_LOGOUT:				/* 09 */
-		/* FIXME! */
-		break;
-
-	case MPI_EVENT_RESCAN:				/* 06 */
-		break;
-
-		/*
-		 *  CHECKME! Don't think we need to do
-		 *  anything for these, but...
-		 */
-	case MPI_EVENT_LINK_STATUS_CHANGE:		/* 07 */
-	case MPI_EVENT_LOOP_STATE_CHANGE:		/* 08 */
-		/*
-		 *  CHECKME!  Falling thru...
-		 */
-		break;
-
-	case MPI_EVENT_INTEGRATED_RAID:			/* 0B */
-		break;
-
-	case MPI_EVENT_NONE:				/* 00 */
-	case MPI_EVENT_LOG_DATA:			/* 01 */
-	case MPI_EVENT_STATE_CHANGE:			/* 02 */
-	case MPI_EVENT_EVENT_CHANGE:			/* 0A */
-	default:
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-			": Ignoring event (=%02Xh)\n",
-			ioc->name, event));
-		break;
-	}
+	if ((event == MPI_EVENT_IOC_BUS_RESET ||
+	    event == MPI_EVENT_EXT_BUS_RESET) &&
+	    (ioc->bus_type == SPI) && (ioc->soft_resets < -1))
+			ioc->soft_resets++;
 
 	return 1;		/* currently means nothing really */
 }
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 1fa7182..a472977 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -90,6 +90,8 @@
 
 #endif
 
+
+#define mpt_sg_next	sg_next
 typedef struct _internal_cmd {
 	char		*data;		/* data pointer */
 	dma_addr_t	data_dma;	/* data dma address */
