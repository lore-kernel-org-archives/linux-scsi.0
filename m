Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42CBC49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B8DD206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f3scPEko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388130AbfIMNFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40212 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so15241142pgj.7
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dh9NmDmP8haPBL7ZkqQvAf4+1d98JV3KSNHC9waDqmY=;
        b=f3scPEkoutxC5VWfGb1/lgzFjaN9m01ceYE5X3jVA74MTnr1Qu1TCEMMQiu6rth7Gw
         Vjq7VjImf5/cBHTW3E4Nt4B9Eubn6oKQ0qsqDkXD1caA10R94Yh1SlnaumaDuahsJwGC
         uApFgp/RvrlN6fNl/N9vv+/bxtliWeSFVPxMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dh9NmDmP8haPBL7ZkqQvAf4+1d98JV3KSNHC9waDqmY=;
        b=Q+0FPfq6r72dBbLXUwb6+hpCN6rbMm2l+aTckCVVF+aa5l0S+JhQ3ag35vNCbdgCkB
         WGi6W6wQHYp1RkYa7g2t1dGmSd9OuzKy8lgTB9oSdn/ygFSnB9zgxQj5n/AewNzWXIiM
         FNZa+3nZ4cFxaZy7aE7U3jsmDFTtb5nSDMfeZ9nZLt85+6Oj7gTC22XpWP+Tfcqh0M1u
         aQgma/7NyfDCWTVxQDCKZPtJt6FBB/+PdpsKvNWyt3JnloHkihRdH0EbVl8VG0rMNl4D
         7yTSkxOaqMmcpUTyDnfGLm01LYlZQfvh+5oMNg79mbPetGG3RR6IyrZ3T2rshkrgTt4d
         gckA==
X-Gm-Message-State: APjAAAXE0avA4xxqNzLnyC5b09GRlLQf7qQaec9xWqezo0GxsyzNh9Wa
        4wWwGePJ6N4vxnsCHNG4ykDBUg==
X-Google-Smtp-Source: APXvYqxUCqk8AkxvInDH3DAknxjZkJIZnsbO/gwkrbsKiaVJkBH2Y31lHa/OepLEXVLX0XtDlmVSWQ==
X-Received: by 2002:a62:d4:: with SMTP id 203mr55334548pfa.210.1568379919054;
        Fri, 13 Sep 2019 06:05:19 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:18 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 08/13] mpt3sas: Add app owned flag support for diag buffer
Date:   Fri, 13 Sep 2019 09:04:45 -0400
Message-Id: <1568379890-18347-9-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a new status flag named MPT3_DIAG_BUFFER_IS_APP_OWNED and it will
set whenever application registers the diag buffer & it will be cleared
when application unregisters the buffer.

When this flag is enabled and if application issues diag buffer register
command without releasing the buffer then register command will be failed
with -EINVAL status by saying that this buffer is already registered by
the application.

When user issues a trace buffer register command through sysfs parameter
and if trace buffer is in released stated but not yet unregistered by the
application which was owning it then driver will unregister the buffer
by itself and freshly registers the 1MB sized trace buffer with the
HBA firmware.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |  1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 43 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index eaeb71f..91f6636 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -304,6 +304,7 @@ struct mpt3sas_nvme_cmd {
 #define MPT3_DIAG_BUFFER_IS_RELEASED	(0x02)
 #define MPT3_DIAG_BUFFER_IS_DIAG_RESET	(0x04)
 #define MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED (0x08)
+#define MPT3_DIAG_BUFFER_IS_APP_OWNED (0x10)
 
 /*
  * HP HBA branding
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b5492f1..62e878d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1565,6 +1565,16 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 		return -EINVAL;
 	}
 
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_APP_OWNED) &&
+	    !(ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_RELEASED)) {
+		ioc_err(ioc,
+		    "%s: buffer_type(0x%02x) is already registered by application with UID(0x%08x)\n",
+		    __func__, buffer_type, ioc->unique_id[buffer_type]);
+		return -EINVAL;
+	}
+
 	if (ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) {
 		/*
@@ -1884,6 +1894,12 @@ _ctl_diag_register(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	}
 
 	rc = _ctl_diag_register_2(ioc, &karg);
+
+	if (!rc && (ioc->diag_buffer_status[karg.buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_REGISTERED))
+		ioc->diag_buffer_status[karg.buffer_type] |=
+		    MPT3_DIAG_BUFFER_IS_APP_OWNED;
+
 	return rc;
 }
 
@@ -1956,6 +1972,8 @@ _ctl_diag_unregister(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED) {
 		ioc->unique_id[buffer_type] = MPT3DIAGBUFFUNIQUEID;
 		ioc->diag_buffer_status[buffer_type] &=
+		    ~MPT3_DIAG_BUFFER_IS_APP_OWNED;
+		ioc->diag_buffer_status[buffer_type] &=
 		    ~MPT3_DIAG_BUFFER_IS_REGISTERED;
 	} else {
 		request_data_sz = ioc->diag_buffer_sz[buffer_type];
@@ -2040,6 +2058,10 @@ _ctl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED))
 		karg.application_flags |= MPT3_APP_FLAGS_DYNAMIC_BUFFER_ALLOC;
 
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_APP_OWNED))
+		karg.application_flags |= MPT3_APP_FLAGS_APP_OWNED;
+
 	for (i = 0; i < MPT3_PRODUCT_SPECIFIC_DWORDS; i++)
 		karg.product_specific[i] =
 		    ioc->product_specific[buffer_type][i];
@@ -3331,8 +3353,27 @@ host_trace_buffer_enable_store(struct device *cdev,
 			/* post the same buffer allocated previously */
 			diag_register.requested_buffer_size =
 			    ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE];
-		} else
+		} else {
+			/*
+			 * Free the diag buffer memory which was previously
+			 * allocated by an application.
+			 */
+			if ((ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE] != 0)
+			    &&
+			    (ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
+			    MPT3_DIAG_BUFFER_IS_APP_OWNED)) {
+				pci_free_consistent(ioc->pdev,
+				    ioc->diag_buffer_sz[
+				    MPI2_DIAG_BUF_TYPE_TRACE],
+				    ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE],
+				    ioc->diag_buffer_dma[
+				    MPI2_DIAG_BUF_TYPE_TRACE]);
+				ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] =
+				    NULL;
+			}
+
 			diag_register.requested_buffer_size = (1024 * 1024);
+		}
 
 		diag_register.unique_id =
 		    (ioc->hba_mpi_version_belonged == MPI2_VERSION) ?
-- 
1.8.3.1

