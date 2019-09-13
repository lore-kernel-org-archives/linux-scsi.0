Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D2EC4CEC5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 501FE2084F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F0K3fw0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388096AbfIMNFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45759 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:17 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so18006202pfb.12
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=asrLyvq7JzpY38ezcQ9IkaJ3l7Q0BduBVN6nErk1Ge4=;
        b=F0K3fw0BkFXZnRoT543BIokt6H9g0qNBNu8+o1RHD6iFpYkvErlIZvtnx1GceoZyzj
         zGxvDl3R76IHEVNGzQvGIncfDuwQACcTJawL0j5DLT8zK8agn8+FQiCBCN1iyM08C+jG
         aq2a3gqPHxEOPIITkLFGhbxzxZC1+CcFIevMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=asrLyvq7JzpY38ezcQ9IkaJ3l7Q0BduBVN6nErk1Ge4=;
        b=HylHYhwQkH9HtYY6Kv4g4rWMjWtFJxHQ7YB0MymipzbgeSsfRffGHrWp0ULe6sImQJ
         2lXpWXRqW4JWPWuZmsyp2Jmy9Gj2DJf836n9grQEKvzq8hJ2bS66IAkaDoar69pCLpXW
         cxaHNj7AKVTn8hQUCoEkMgRVWmWEvHye+amxNQEld5vCaDgx4XaDQ1IiKprmQQJyjc2k
         pjXvubEvRtKsG3qMZj+9BJqWLm8uaVZqsnZtWtBLmIAEZ2N3CiYmKjxaoVOK5ZqjVfcV
         xG0qocYDJO8njl49n0WY+Vm8ADS+KQt20EtJQOykpLEKPoSKz4+dCpXQOg/QB3ypbH/4
         fqwg==
X-Gm-Message-State: APjAAAXYTdjoWMVRyHT2BYY1wLo/jeNusD5GZfyCHXTaGIY7F6moOogz
        /ZZeyA427G7Wy663R2hSD67FqA==
X-Google-Smtp-Source: APXvYqwtiHcBJrXFXL+pNrxBV6Iet/+wOcoG2bwn94tqwAm/XEzDUfnYjdYk3EKAbGtbzbpt0bjQYA==
X-Received: by 2002:a65:4c4d:: with SMTP id l13mr42600042pgr.156.1568379916842;
        Fri, 13 Sep 2019 06:05:16 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:16 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 07/13] mpt3sas: Reuse diag buffer allocated at load time
Date:   Fri, 13 Sep 2019 09:04:44 -0400
Message-Id: <1568379890-18347-8-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The diag buffer which is allocated during driver load time or through
sysfs parameter is marked as driver allocated diag buffer.
MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED bit will be set for this buffer.

This buffer won't be de-allocated even when application issues unregister
command, driver just clear's the registered status bit. Same buffer will
be reused while re-registering the same diag buffer type by any
application. While re-registering the same diag buffer type application
has to register with the same size that the buffer was allocated during
driver load time. This buffer size can be read by the application by
issuing diag 'query' command.

This always make sure that the memory is available for applications for
collecting the firmware logs. Only thing is that this won't
allow the application to re-register the diag buffer with different size,
but the buffer size which is allocated during driver load time will be
enough for most of the cases for collecting the firmware logs.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |  1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 88 ++++++++++++++++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_ctl.h  |  1 +
 3 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a501c25..eaeb71f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -303,6 +303,7 @@ struct mpt3sas_nvme_cmd {
 #define MPT3_DIAG_BUFFER_IS_REGISTERED	(0x01)
 #define MPT3_DIAG_BUFFER_IS_RELEASED	(0x02)
 #define MPT3_DIAG_BUFFER_IS_DIAG_RESET	(0x04)
+#define MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED (0x08)
 
 /*
  * HP HBA branding
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 504e035..b5492f1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1617,6 +1617,19 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 			    __func__, buffer_type);
 			return -EINVAL;
 		}
+	} else if (ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED) {
+
+		if (ioc->unique_id[buffer_type] != MPT3DIAGBUFFUNIQUEID ||
+		    ioc->diag_buffer_sz[buffer_type] !=
+		    diag_register->requested_buffer_size) {
+
+			ioc_err(ioc,
+			    "%s: already a buffer is allocated for buffer_type(0x%02x) of size %d bytes, so please try registering again with same size\n",
+			     __func__, buffer_type,
+			    ioc->diag_buffer_sz[buffer_type]);
+			return -EINVAL;
+		}
 	}
 
 	if (diag_register->requested_buffer_size % 4)  {
@@ -1641,7 +1654,8 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	request_data = ioc->diag_buffer[buffer_type];
 	request_data_sz = diag_register->requested_buffer_size;
 	ioc->unique_id[buffer_type] = diag_register->unique_id;
-	ioc->diag_buffer_status[buffer_type] = 0;
+	ioc->diag_buffer_status[buffer_type] &=
+	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
 	memcpy(ioc->product_specific[buffer_type],
 	    diag_register->product_specific, MPT3_PRODUCT_SPECIFIC_DWORDS);
 	ioc->diagnostic_flags[buffer_type] = diag_register->diagnostic_flags;
@@ -1731,9 +1745,12 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 
  out:
 
-	if (rc && request_data)
+	if (rc && request_data) {
 		dma_free_coherent(&ioc->pdev->dev, request_data_sz,
 		    request_data, request_data_dma);
+		ioc->diag_buffer_status[buffer_type] &=
+		    ~MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
+	}
 
 	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
 	return rc;
@@ -1817,9 +1834,14 @@ mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 			    "Cannot allocate trace buffer memory. Last memory tried = %d KB\n",
 			    diag_register.requested_buffer_size>>10);
 		else if (ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE]
-		    & MPT3_DIAG_BUFFER_IS_REGISTERED)
+		    & MPT3_DIAG_BUFFER_IS_REGISTERED) {
 			ioc_err(ioc, "Trace buffer memory %d KB allocated\n",
 			    diag_register.requested_buffer_size>>10);
+			if (ioc->hba_mpi_version_belonged != MPI2_VERSION)
+				ioc->diag_buffer_status[
+				    MPI2_DIAG_BUF_TYPE_TRACE] |=
+				    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
+		}
 	}
 
 	if (bits_to_register & 2) {
@@ -1930,12 +1952,19 @@ _ctl_diag_unregister(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -ENOMEM;
 	}
 
-	request_data_sz = ioc->diag_buffer_sz[buffer_type];
-	request_data_dma = ioc->diag_buffer_dma[buffer_type];
-	dma_free_coherent(&ioc->pdev->dev, request_data_sz,
-			request_data, request_data_dma);
-	ioc->diag_buffer[buffer_type] = NULL;
-	ioc->diag_buffer_status[buffer_type] = 0;
+	if (ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED) {
+		ioc->unique_id[buffer_type] = MPT3DIAGBUFFUNIQUEID;
+		ioc->diag_buffer_status[buffer_type] &=
+		    ~MPT3_DIAG_BUFFER_IS_REGISTERED;
+	} else {
+		request_data_sz = ioc->diag_buffer_sz[buffer_type];
+		request_data_dma = ioc->diag_buffer_dma[buffer_type];
+		dma_free_coherent(&ioc->pdev->dev, request_data_sz,
+				request_data, request_data_dma);
+		ioc->diag_buffer[buffer_type] = NULL;
+		ioc->diag_buffer_status[buffer_type] = 0;
+	}
 	return 0;
 }
 
@@ -1974,11 +2003,14 @@ _ctl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EPERM;
 	}
 
-	if ((ioc->diag_buffer_status[buffer_type] &
-	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		ioc_err(ioc, "%s: buffer_type(0x%02x) is not registered\n",
-			__func__, buffer_type);
-		return -EINVAL;
+	if (!(ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED)) {
+		if ((ioc->diag_buffer_status[buffer_type] &
+		    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
+			ioc_err(ioc, "%s: buffer_type(0x%02x) is not registered\n",
+				__func__, buffer_type);
+			return -EINVAL;
+		}
 	}
 
 	if (karg.unique_id) {
@@ -1996,13 +2028,17 @@ _ctl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -ENOMEM;
 	}
 
-	if (ioc->diag_buffer_status[buffer_type] & MPT3_DIAG_BUFFER_IS_RELEASED)
-		karg.application_flags = (MPT3_APP_FLAGS_APP_OWNED |
-		    MPT3_APP_FLAGS_BUFFER_VALID);
-	else
-		karg.application_flags = (MPT3_APP_FLAGS_APP_OWNED |
-		    MPT3_APP_FLAGS_BUFFER_VALID |
-		    MPT3_APP_FLAGS_FW_BUFFER_ACCESS);
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_REGISTERED))
+		karg.application_flags |= MPT3_APP_FLAGS_BUFFER_VALID;
+
+	if (!(ioc->diag_buffer_status[buffer_type] &
+	     MPT3_DIAG_BUFFER_IS_RELEASED))
+		karg.application_flags |= MPT3_APP_FLAGS_FW_BUFFER_ACCESS;
+
+	if (!(ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED))
+		karg.application_flags |= MPT3_APP_FLAGS_DYNAMIC_BUFFER_ALLOC;
 
 	for (i = 0; i < MPT3_PRODUCT_SPECIFIC_DWORDS; i++)
 		karg.product_specific[i] =
@@ -3303,6 +3339,16 @@ host_trace_buffer_enable_store(struct device *cdev,
 		    (MPT2DIAGBUFFUNIQUEID):(MPT3DIAGBUFFUNIQUEID);
 		ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] = 0;
 		_ctl_diag_register_2(ioc,  &diag_register);
+		if (ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+		    MPT3_DIAG_BUFFER_IS_REGISTERED) {
+			ioc_info(ioc,
+			    "Trace buffer %d KB allocated through sysfs\n",
+			    diag_register.requested_buffer_size>>10);
+			if (ioc->hba_mpi_version_belonged != MPI2_VERSION)
+				ioc->diag_buffer_status[
+				    MPI2_DIAG_BUF_TYPE_TRACE] |=
+				    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
+		}
 	} else if (!strcmp(str, "release")) {
 		/* exit out if host buffers are already released */
 		if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE])
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index d1a6ab1..0f7aa4d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -318,6 +318,7 @@ struct mpt3_ioctl_btdh_mapping {
 #define MPT3_APP_FLAGS_APP_OWNED	(0x0001)
 #define MPT3_APP_FLAGS_BUFFER_VALID	(0x0002)
 #define MPT3_APP_FLAGS_FW_BUFFER_ACCESS	(0x0004)
+#define MPT3_APP_FLAGS_DYNAMIC_BUFFER_ALLOC (0x0008)
 
 /* flags for mpt3_diag_read_buffer */
 #define MPT3_FLAGS_REREGISTER		(0x0001)
-- 
1.8.3.1

