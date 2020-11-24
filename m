Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE93C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531552085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dN7OODsn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgKXDxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:53:51 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D194C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 19:53:51 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id b6so6693884pfp.7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 19:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=EFgyLrcCOw3mzK1BIplLs0ulIik1gBBpoimwHYY1MVk=;
        b=dN7OODsnoDaZSRU5zdaDdKgaw5TEw2e62s+91OFbjrL6iIkPn1spGDSoNju8ttNyV6
         ScRtW5tSOyr8qYEb7N0iiKF7tbVKxbExee+Nekoe4mw51S6od1ZaOpT8hmK1OWrV3nJU
         +eP+R4WAWdm39296r7VLgTgRU26rXVxrKsJLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=EFgyLrcCOw3mzK1BIplLs0ulIik1gBBpoimwHYY1MVk=;
        b=GGLn0DufW+PmHQYW9HYewa/uAhmpBLW17vQyhYyGegTu2LcuNTlBwM8/WXVd7lFZEe
         7S4/Tiff8qz344JB6QIUitpeA/TO0pcvjgyC7OUDqeuePTY4D6wKxrvuSrvE6EGRCELO
         WYdXFCgmT34ecKZcTmtdx4ztPkwL9GRxEL7Lcquz0nzBNrpBjWHlzcEq9UE6CLWeuWBF
         fu7UJleoqnH+RW2ozMWzw8+pYt5zTBi1W8ZmvZe7r60etr8jsUtC0qpGGl6wc0g2ItEe
         S4JTF26rsvRtsimhvaOLnfTL/3H3B4tgTeNEoM5OC0TWBD6Kg1tN4bL9rTqf/x8drypx
         ri0A==
X-Gm-Message-State: AOAM530dsBMZ7V0Cj7lk3knBKZNPTE530r5gdCzPRUWa/mCX8LgxXg1s
        4rk0HY20z5xq/DWRTZ7SQDsZwSd3sMTxT5mG2TnDu0lNTCe75f+r94hnbZtriIqaba/TKfqJah3
        sw+Wb93NMz0Jyd8NpurhHe1zALqZ3EeT93Kyp0JCsIWacMNtdqRMud6RqJMa4A2bAuA/O0o71gb
        C7rvZxSjaUimxEu1VLpimFK5Y=
X-Google-Smtp-Source: ABdhPJyopaEE9j2DbBkDD3/VXP6/DxbkxemKBFQIvmcFCbALunOh72XekOCaGoJGqYAheFMO6XBU3g==
X-Received: by 2002:a62:6586:0:b029:164:1cb9:8aff with SMTP id z128-20020a6265860000b02901641cb98affmr2441224pfb.64.1606190030401;
        Mon, 23 Nov 2020 19:53:50 -0800 (PST)
Received: from dhcp-10-123-20-14.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x8sm851093pjr.52.2020.11.23.19.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 19:53:49 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 6/8] mpt3sas: Add MPI triggers persistent Trigger Page4
Date:   Tue, 24 Nov 2020 09:20:17 +0530
Message-Id: <20201124035019.27975-7-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124035019.27975-1-suganath-prabu.subramani@broadcom.com>
References: <20201124035019.27975-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003dafb605b4d24200"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003dafb605b4d24200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Description:
This trigger page is used store information about
MPI (IOC Status & LogInfo) triggers.

Driver Persistent Trigger Page-4 format:
-------------------------------------------------------
| 31       24 23           16 15         8 7          0|  Byte
-------------------------------------------------------
| PageType   | PageNumber    | Reserved	 | PageVersion |  0x00
--------------------------------------------------------
| Reserved   | ExtPageType   |      ExtPageLength      |  0x04
--------------------------------------------------------
|          Reserved	     | NumMpiTriggerEntries    |  0x08
--------------------------------------------------------
|	      MPITriggerEntry[0]		       |  0x0C
--------------------------------------------------------
|		…                                      |
--------------------------------------------------------
|	     MPITriggerEntry[19]	   	       |  0xA4
--------------------------------------------------------

NumMpiTriggerEntries:
This field indicates number of MPI (IOC Status & LogInfo)
trigger entries stored in this page. Currently driver is supporting
a maximum of 20-MPI trigger entries.

MPITriggerEntry:
-----------------------------------------------------
| 31                    16 15                     0 |
-----------------------------------------------------
|        Reserved         |      IOCStatus	    |
-----------------------------------------------------
|                   IOCLogInfo	                    |
-----------------------------------------------------

IOCStatus  => Status value from the IOC
IOCLogInfo => Specific value that supplements the IOCStatus.

During driver load:
 If MPI trigger type bit is enabled in the Persistent
 Trigger Page0 then read the Persistent Trigger Page4 and update the
 ioc instances diag_trigger_mpi.MPITriggerEntry with Persistent
 Trigger Page4's MPITriggerEntries. This will restores the
 MPI trigger type's triggers which are enabled before.

When user modifies the MPI trigger type triggers:
 When user sets/clears the MPI trigger type triggers then driver
 fisrt checks whether IOC firmware supports trigger pages support
 or not. if firmware supports these pages then driver enables the
 MPI trigger type bit in Persistent Trigger Page0 (if it was not
 enabled before) and updates the user provided trigger values in
 Persistent Trigger Page4.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   |  61 +++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h   |   3 +
 drivers/scsi/mpt3sas/mpt3sas_config.c | 158 ++++++++++++++++++++++++++
 3 files changed, 221 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 75c0c64..ee86124 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4899,6 +4899,59 @@ _base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _base_get_mpi_diag_triggers - get mpi diag trigger values from
+ *				persistent pages
+ * @ioc : per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_get_mpi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi26DriverTriggerPage4_t trigger_pg4;
+	struct SL_WH_MPI_TRIGGER_T *status_tg;
+	MPI26_DRIVER_IOCSTATUS_LOGINFO_TIGGER_ENTRY *mpi_status_tg;
+	Mpi2ConfigReply_t mpi_reply;
+	int r = 0, i = 0;
+	u16 count = 0;
+	u16 ioc_status;
+
+	r = mpt3sas_config_get_driver_trigger_pg4(ioc, &mpi_reply,
+	    &trigger_pg4);
+	if (r)
+		return;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dinitprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg4, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		return;
+	}
+
+	if (le16_to_cpu(trigger_pg4.NumIOCStatusLogInfoTrigger)) {
+		count = le16_to_cpu(trigger_pg4.NumIOCStatusLogInfoTrigger);
+		count = min_t(u16, NUM_VALID_ENTRIES, count);
+		ioc->diag_trigger_mpi.ValidEntries = count;
+
+		status_tg = &ioc->diag_trigger_mpi.MPITriggerEntry[0];
+		mpi_status_tg = &trigger_pg4.IOCStatusLoginfoTriggers[0];
+
+		for (i = 0; i < count; i++) {
+			status_tg->IOCStatus = le16_to_cpu(
+			    mpi_status_tg->IOCStatus);
+			status_tg->IocLogInfo = le32_to_cpu(
+			    mpi_status_tg->LogInfo);
+
+			status_tg++;
+			mpi_status_tg++;
+		}
+	}
+}
+
 /**
  * _base_get_master_diag_triggers - get master diag trigger values from
  *				persistent pages
@@ -5011,7 +5064,13 @@ _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	if ((u16)trigger_flags &
 	    MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID)
 		_base_get_scsi_diag_triggers(ioc);
-
+	/*
+	 * Retrieve mpi error diag trigger values from driver trigger pg4
+	 * if loginfo trigger bit enabled in TriggerFlags.
+	 */
+	if ((u16)trigger_flags &
+	    MPI26_DRIVER_TRIGGER0_FLAG_LOGINFO_TRIGGER_VALID)
+		_base_get_mpi_diag_triggers(ioc);
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6c3bc50..6745d79 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1831,6 +1831,9 @@ mpt3sas_config_get_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 int
 mpt3sas_config_get_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage3_t *config_page);
+int
+mpt3sas_config_get_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage4_t *config_page);
 
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 98b6a59..c3aaaab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2344,6 +2344,164 @@ out:
 	return rc;
 }
 
+/**
+ * mpt3sas_config_get_driver_trigger_pg4 - obtain driver trigger page 4
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage4_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_EXTENDED;
+	mpi_request.ExtPageType =
+	    MPI2_CONFIG_EXTPAGETYPE_DRIVER_PERSISTENT_TRIGGER;
+	mpi_request.Header.PageNumber = 4;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE4_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
+/**
+ * mpt3sas_config_set_driver_trigger_pg4 - write driver trigger page 4
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+_config_set_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage4_t *config_page)
+{
+	Mpi2ConfigRequest_t mpi_request;
+	int r;
+
+	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_CONFIG;
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
+	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_EXTENDED;
+	mpi_request.ExtPageType =
+	    MPI2_CONFIG_EXTPAGETYPE_DRIVER_PERSISTENT_TRIGGER;
+	mpi_request.Header.PageNumber = 4;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE4_PAGEVERSION;
+	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
+	if (r)
+		goto out;
+
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	_config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
+	r = _config_request(ioc, &mpi_request, mpi_reply,
+	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
+	    sizeof(*config_page));
+ out:
+	return r;
+}
+
+/**
+ * mpt3sas_config_update_driver_trigger_pg4 - update driver trigger page 4
+ * @ioc: per adapter object
+ * @trigger_flags: trigger type bit map
+ * @set: set ot clear trigger values
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_update_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
+	struct SL_WH_MPI_TRIGGERS_T *mpi_tg, bool set)
+{
+	Mpi26DriverTriggerPage4_t tg_pg4;
+	Mpi2ConfigReply_t mpi_reply;
+	int rc, i, count;
+	u16 ioc_status;
+
+	rc = mpt3sas_config_update_driver_trigger_pg0(ioc,
+	    MPI26_DRIVER_TRIGGER0_FLAG_LOGINFO_TRIGGER_VALID, set);
+	if (rc)
+		return rc;
+
+	rc = mpt3sas_config_get_driver_trigger_pg4(ioc, &mpi_reply, &tg_pg4);
+	if (rc)
+		goto out;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg4, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (set) {
+		count = mpi_tg->ValidEntries;
+		tg_pg4.NumIOCStatusLogInfoTrigger = cpu_to_le16(count);
+		for (i = 0; i < count; i++) {
+			tg_pg4.IOCStatusLoginfoTriggers[i].IOCStatus =
+			    cpu_to_le16(mpi_tg->MPITriggerEntry[i].IOCStatus);
+			tg_pg4.IOCStatusLoginfoTriggers[i].LogInfo =
+			    cpu_to_le32(mpi_tg->MPITriggerEntry[i].IocLogInfo);
+		}
+	} else {
+		tg_pg4.NumIOCStatusLogInfoTrigger = 0;
+		memset(&tg_pg4.IOCStatusLoginfoTriggers[0], 0,
+		    NUM_VALID_ENTRIES * sizeof(
+		    MPI26_DRIVER_IOCSTATUS_LOGINFO_TIGGER_ENTRY));
+	}
+
+	rc = _config_set_driver_trigger_pg4(ioc, &mpi_reply, &tg_pg4);
+	if (rc)
+		goto out;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg4, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		rc = -EFAULT;
+		goto out;
+	}
+
+	return 0;
+
+out:
+	mpt3sas_config_update_driver_trigger_pg0(ioc,
+	    MPI26_DRIVER_TRIGGER0_FLAG_LOGINFO_TRIGGER_VALID, !set);
+
+	return rc;
+}
+
 /**
  * mpt3sas_config_get_volume_handle - returns volume handle for give hidden
  * raid components
-- 
2.18.4


--0000000000003dafb605b4d24200
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgVPVSNTVKdLj60v3xZcFGCGOSDfV9jTaCg6PAB5w5
C5EwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTI0MDM1MzUx
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAFwDp4LLOfVn8iv7HqBi+s3cWVdpxQzE9f4LhK60W6dE1c1dXd2MnT2IENHr
GygEovzoaD/93JudcksawTUQAfEWPDzeCPVyGaGvVUXTW8elCRiJEO4g0R0eMnKGAPzQRZSlHclZ
kvNHx2YNVtihTkDgWXGTBBElAfBj1LxZ8ov4vA8YVkjRnWuwW2fcJ3lJRDE71GHPXGXJZL174UHd
b5+YSN4clqXoPuVM0LdwO8Sb+NywEL3Y11emROLXm+/2rwgNQUsENbEXlWWceSwWsG+gTHkaUV1F
564YGikeoK2VrKfzvnLNov9f3+TMi1Yv4VctKnYhcfUboQFzVCjI6N8=
--0000000000003dafb605b4d24200--
