Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E029C6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 11:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCPLCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCPLCk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 07:02:40 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129CB497EF
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 04:02:39 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso4970207pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 04:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678964558;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pWgUILMo208KL6qMozPFMcB2ZRZyvD4fJw228I237UI=;
        b=KBhBynPiaUBAxZJS3LQO8FrhXGH0pr+K5ywgawCNvMn3EUmeb3N0qieL6mJD/ugVMV
         xg2g+BS5NHuFN8CHgyPAt525GmWX3MWd/T/LX+vX54pv4aioi59sgj2JlD2xvhfsLUPi
         nUvb6Z+M80WP8LDV3qLWW8+StCizq9ufvwqOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678964558;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pWgUILMo208KL6qMozPFMcB2ZRZyvD4fJw228I237UI=;
        b=nJWTU/RqaSNoS/uJpiP+PKwChH8HeYhsHND1OZt59Z6kHNojOdwtvHK2nGbIwIGKX/
         wf64EpTPj/85W0El6ORgI9X6KI21TR3tTHAMtcXcoHB9966To8N48e355IDPj6WsxlBi
         +cpiIOjcbgxzyfm9vERyBmqya+D05RZkhz1zTPr0lnqCPP06o5WGfYsQxuayhOm9So6Y
         9IwGCbe6fd9MNzchaIDlnR+V5HKEOVmOh+WX3shC26lK/UzYWo9aurFHbcWuPOPHc1yG
         pKoOQ9cbdMvfRCxUPB7DWyxO3qkxbPCii5AXXHtRJ940A1lFF1Fzl5oKpA8rI9N1yitg
         zdrQ==
X-Gm-Message-State: AO0yUKWzyESUjckTZ+lfsCDWk0DYGfMP7+fiKVs+y+txy4HbyZSCwkcn
        4QIbsU/sykv+nDCpAekz8NqbZXZFogZ43Xj7GPR4ku0yr5Oq1PVT92GvoLvCfdmaiEmkQrk+sCL
        FdSvxBpVH5y/qmBVVtMPmEe63/+AUS0mpRTmAcXQtW0yR3fBcPJB9VVx//irvd0B/rF9K/mPpsj
        WOzzVwQNbnzA==
X-Google-Smtp-Source: AK7set8P3aQHirwVISYF+sQ+vwDJPpLLxSjmnW2hYkaLc75MU2Shqt5LhXOVz4ogsM2gn3O+/jKheg==
X-Received: by 2002:a17:90a:1a41:b0:23c:fef0:d441 with SMTP id 1-20020a17090a1a4100b0023cfef0d441mr3291342pjl.33.1678964558124;
        Thu, 16 Mar 2023 04:02:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id kb5-20020a170903338500b0019a6cce2060sm5343590plb.57.2023.03.16.04.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 04:02:37 -0700 (PDT)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 1/8] mpi3mr: Successive VD delete and add causes FW Fault
Date:   Thu, 16 Mar 2023 16:32:02 +0530
Message-Id: <20230316110209.60145-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
References: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001bad1905f70266e3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001bad1905f70266e3
Content-Transfer-Encoding: 8bit

Upon Virtual disk removal, firmware sends device status
change event(Virtual disk remove event) and expects the
driver to start device remove handshake(by sending target
reset and IOU control command to firmware).But the driver
does not initiate the device remove handshake which leads
to the firmware FAULT.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  8 +++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 48 +++++++++++++++++++++++----------
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 23de2603e71f..4cb00bdb0039 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -652,7 +652,11 @@ union _form_spec_inf {
 	struct tgt_dev_vd vd_inf;
 };
 
-
+enum mpi3mr_dev_state {
+	MPI3MR_DEV_CREATED = 1,
+	MPI3MR_DEV_REMOVE_HS_STARTED = 2,
+	MPI3MR_DEV_DELETED = 3,
+};
 
 /**
  * struct mpi3mr_tgt_dev - target device data structure
@@ -676,6 +680,7 @@ union _form_spec_inf {
  * @enclosure_logical_id: Enclosure logical identifier
  * @dev_spec: Device type specific information
  * @ref_count: Reference count
+ * @state: device state
  */
 struct mpi3mr_tgt_dev {
 	struct list_head list;
@@ -697,6 +702,7 @@ struct mpi3mr_tgt_dev {
 	u64 enclosure_logical_id;
 	union _form_spec_inf dev_spec;
 	struct kref ref_count;
+	enum mpi3mr_dev_state state;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6eaeba41072c..7ebd00dfd396 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -652,6 +652,7 @@ static void mpi3mr_tgtdev_add_to_list(struct mpi3mr_ioc *mrioc,
 	mpi3mr_tgtdev_get(tgtdev);
 	INIT_LIST_HEAD(&tgtdev->list);
 	list_add_tail(&tgtdev->list, &mrioc->tgtdev_list);
+	tgtdev->state = MPI3MR_DEV_CREATED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
 
@@ -659,20 +660,25 @@ static void mpi3mr_tgtdev_add_to_list(struct mpi3mr_ioc *mrioc,
  * mpi3mr_tgtdev_del_from_list -Delete tgtdevice from the list
  * @mrioc: Adapter instance reference
  * @tgtdev: Target device
+ * @must_delete: Must delete the target device from the list irrespective
+ * of the device state.
  *
  * Remove the target device from the target device list
  *
  * Return: Nothing.
  */
 static void mpi3mr_tgtdev_del_from_list(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_tgt_dev *tgtdev)
+	struct mpi3mr_tgt_dev *tgtdev, bool must_delete)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
-	if (!list_empty(&tgtdev->list)) {
-		list_del_init(&tgtdev->list);
-		mpi3mr_tgtdev_put(tgtdev);
+	if ((tgtdev->state == MPI3MR_DEV_REMOVE_HS_STARTED) || (must_delete == true)) {
+		if (!list_empty(&tgtdev->list)) {
+			list_del_init(&tgtdev->list);
+			tgtdev->state = MPI3MR_DEV_DELETED;
+			mpi3mr_tgtdev_put(tgtdev);
+		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 }
@@ -1036,7 +1042,7 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 			    tgtdev->perst_id);
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, true);
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 	}
@@ -1281,12 +1287,12 @@ static void mpi3mr_devstatuschg_evt_bh(struct mpi3mr_ioc *mrioc,
 		if (!tgtdev->host_exposed)
 			mpi3mr_report_tgtdev_to_host(mrioc, tgtdev->perst_id);
 	}
-	if (tgtdev->starget && tgtdev->starget->hostdata) {
-		if (delete)
-			mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-	}
+
+	if (delete)
+		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
+
 	if (cleanup) {
-		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
 
@@ -1604,7 +1610,7 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
 			mpi3mr_tgtdev_put(tgtdev);
 			break;
 		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
@@ -1762,7 +1768,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
 			if (tgtdev->host_exposed)
 				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
 			mpi3mr_tgtdev_put(tgtdev);
 			break;
 		default:
@@ -2016,12 +2022,18 @@ static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *mrioc,
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	u16 perst_id = 0;
+	unsigned long flags;
 
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	if (perst_id == MPI3_DEVICE0_PERSISTENTID_INVALID)
 		return retval;
 
-	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
+	if (tgtdev)
+		tgtdev->state = MPI3MR_DEV_CREATED;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
 	if (tgtdev) {
 		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
 		mpi3mr_tgtdev_put(tgtdev);
@@ -2219,6 +2231,14 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	u8 retrycount = 5;
 	struct mpi3mr_drv_cmd *drv_cmd = cmdparam;
 	struct delayed_dev_rmhs_node *delayed_dev_rmhs = NULL;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
+		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
 	if (drv_cmd)
 		goto issue_cmd;
@@ -5108,7 +5128,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
+		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, true);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
 	mpi3mr_stop_watchdog(mrioc);
-- 
2.31.1


--0000000000001bad1905f70266e3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFn1fndB4eozN/VtvbBW/BYmBY4ZrW58
EpU6Ew6/rR9FMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMx
NjExMDIzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAQu69gxbN2e+OuVYsJB/yFl0qW/Gm5Qv8bPFmAHsHVFpPy2Pko
SFowDHIwuPIFOyHMbjZqmHwEw9JbsBIm0j4ca2zjIeyAPSmdhbxRJjZJjrVXxAymJLWOeCgrFdPw
0sjQn9LHvXLRkhly9USGScEzuxSdU9t60PBhcJ73ZGDzkEMQCVb/ixYBmWVYccfREFYzgcUR9ESr
H71NZ9dcigGj3eFcdgHttHU8osrd/5SPN+sn4lUN4I88/1ncb+e9XfZqgOri8Z04fgtAS8fP5+Uj
J0rdE8aJWnPsw1uf+G/gu4i9JrwxbZIlJ28OrzhL5KwfzRTKBrhYwyc1Ni4OEy5i
--0000000000001bad1905f70266e3--
