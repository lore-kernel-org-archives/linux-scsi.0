Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CE9C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 920C62085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZhO4gIO1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgKXDxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:53:42 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE283C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 19:53:40 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id v21so8736743plo.12
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 19:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=bKMpA1zq0aRtjdDezQUTmb84namq82ReWIAX8vKXHDI=;
        b=ZhO4gIO1fyrUqtwgLXjCDMb56xL0CQmTSeJefR6536BkTYb0Y0X5+F9RYpmYuCXqD7
         dxSbwkub/jZ3GbjDLIbAtGeWwczGXrk54VNXVWkunJv3sCCtrvVzmeBBYTbYpZmiNkBX
         2ta/g6OmaPlqKVh4PGZP+e6wiVHf7LDQAO4SU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=bKMpA1zq0aRtjdDezQUTmb84namq82ReWIAX8vKXHDI=;
        b=mAO09np6Uos8ACQKn5ZzNdCIXpxZJDkvAN2hGOJ6HQLkEhmOnQe/z/8UZ3NILiQgeH
         Jcisqpdkuz5OWyNTU0cthzSLsZtk69SIwufgw8NQsSPfbrlXI7keuUGiyUFtqVxxviHf
         mxU1dzwrF/OmT82CiYkPaFOJl97aWEZgIJ4NGoMGIqDf1bbeopH3R/RryVHky6ZiPqhw
         OG61s0OFrqgnKOb8yKX3gTrvJVF63mKYNa1sIfIc6QTx/muG7iANpIbDqKj0LhjX0m+f
         wLuwJ/+pYRcTl5Sl0iZfNNDwBSxhPhtzZxSLN5z3Js7TfRbq5N+YLBrvkSB6j5v2hlBh
         bO8Q==
X-Gm-Message-State: AOAM532tI8FSGn6f4ABN6wyfu+onLQ/g7pABeybdFYUaroxh4ffzDKvE
        4rCcwtvz1EonqzAmk2Zlwh5awlSD3NMz3YaYWoFCo9lbUkwcKfrtxe2+mozHMCxBGE7RIFwjfZ3
        ERoRdvBYOKwj30/VgVwulW4WO9XK3XZviS/TKubS3IOSJPfNA4Nyb7LdswuxUAggyaqJmKOdN7+
        6tUiidC1tHC9Hjn5QX84KG2uQ=
X-Google-Smtp-Source: ABdhPJz2+TRYA43qaqU138PmW8cp+QibpnpAXSoIUd78K3EeFWloyEX97GAWPgJmFbGaGq2rT39iYQ==
X-Received: by 2002:a17:902:9f90:b029:d9:da48:6021 with SMTP id g16-20020a1709029f90b02900d9da486021mr2201281plq.81.1606190019559;
        Mon, 23 Nov 2020 19:53:39 -0800 (PST)
Received: from dhcp-10-123-20-14.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x8sm851093pjr.52.2020.11.23.19.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 19:53:38 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 4/8] mpt3sas: Add Event triggers persistent Trigger Page2
Date:   Tue, 24 Nov 2020 09:20:15 +0530
Message-Id: <20201124035019.27975-5-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124035019.27975-1-suganath-prabu.subramani@broadcom.com>
References: <20201124035019.27975-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000978cff05b4d24143"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000978cff05b4d24143
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Description:
Trigger page2 is used to store information about event triggers.

Persistent Trigger page2 format:

 31     24 23        16 15      8 7         0   Byte
-----------------------------------------------
|PageType  |PageNumber  |Reserved |PageVersion| 0x00
-----------------------------------------------
|Reserved  |ExtPageType |   ExtPageLength     | 0x04
-----------------------------------------------
|     Reserved          | NumMPIEventTriggers | 0x08
-----------------------------------------------
|                 MPIEventTriggerEntries      | 0x0C
|                                             | 0xFC
-----------------------------------------------

NumMPIEventTriggers:
Number of MPI Event Trigger Entries currently stored in this page.
If this is set to zero, there are no valid MPI-Event-Trigger
entries available in this page.

MPIEventTriggerEntry:
- MPIEventCode [15:00]
  MPI Event code specified in MPI-Spec
- MPIEventCodeSpecific [16:31]
  For Event Code “MPI2_EVENT_LOG_ENTRY_ADDED (0x0021)”,
  this field specifies the Log-Entry-Qualifier.
  For all other Event Codes, this field is reserved and not used

Maximum of 20-event trigger entries can be stored in this page.

During driver load:
 If MPIEvent trigger type bit is enabled in the Persistent Trigger Page0
 then read the Persistent Trigger Page2 and update the ioc instances
 diag_trigger_event.EventTriggerEntry with Persistent Trigger Page2's
 MPIEventTriggerEntries. This will restores the MPIEvent trigger type's
 triggers which are enabled before.

When user modifies the MPIEvent trigger type triggers:
 When user sets/clears the MPIEvent trigger type triggers then driver
 fisrt checks whether IOC firmware supports trigger pages support
 or not. if firmware supports these pages then driver enables the
 MPIEvent trigger type bit in Persistent Trigger Page0 (if it was not
 enabled before) and updates the user provided trigger values in
 Persistent Trigger Page2.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   |  60 ++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h   |   4 +
 drivers/scsi/mpt3sas/mpt3sas_config.c | 160 ++++++++++++++++++++++++++
 3 files changed, 224 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2c13078..19e522a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4797,6 +4797,57 @@ _base_update_ioc_page1_inlinewith_perf_mode(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _base_get_event_diag_triggers - get event diag trigger values from
+ *				persistent pages
+ * @ioc : per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi26DriverTriggerPage2_t trigger_pg2;
+	struct SL_WH_EVENT_TRIGGER_T *event_tg;
+	MPI26_DRIVER_MPI_EVENT_TIGGER_ENTRY *mpi_event_tg;
+	Mpi2ConfigReply_t mpi_reply;
+	int r = 0, i = 0;
+	u16 count = 0;
+	u16 ioc_status;
+
+	r = mpt3sas_config_get_driver_trigger_pg2(ioc, &mpi_reply,
+	    &trigger_pg2);
+	if (r)
+		return;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dinitprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg2, ioc_status(0x%04x)\n",
+		   __func__, ioc_status));
+		return;
+	}
+
+	if (le16_to_cpu(trigger_pg2.NumMPIEventTrigger)) {
+		count = le16_to_cpu(trigger_pg2.NumMPIEventTrigger);
+		count = min_t(u16, NUM_VALID_ENTRIES, count);
+		ioc->diag_trigger_event.ValidEntries = count;
+
+		event_tg = &ioc->diag_trigger_event.EventTriggerEntry[0];
+		mpi_event_tg = &trigger_pg2.MPIEventTriggers[0];
+		for (i = 0; i < count; i++) {
+			event_tg->EventValue = le16_to_cpu(
+			    mpi_event_tg->MPIEventCode);
+			event_tg->LogEntryQualifier = le16_to_cpu(
+			    mpi_event_tg->MPIEventCodeSpecific);
+			event_tg++;
+			mpi_event_tg++;
+		}
+	}
+}
+
 /**
  * _base_get_master_diag_triggers - get master diag trigger values from
  *				persistent pages
@@ -4893,6 +4944,15 @@ _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	if ((u16)trigger_flags &
 	    MPI26_DRIVER_TRIGGER0_FLAG_MASTER_TRIGGER_VALID)
 		_base_get_master_diag_triggers(ioc);
+
+	/*
+	 * Retrieve event diag trigger values from driver trigger pg2
+	 * if event trigger bit enabled in TriggerFlags.
+	 */
+	if ((u16)trigger_flags &
+	    MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID)
+		_base_get_event_diag_triggers(ioc);
+
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 9f5983c..febd5ec 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1825,6 +1825,10 @@ mpt3sas_config_get_driver_trigger_pg0(struct MPT3SAS_ADAPTER *ioc,
 int
 mpt3sas_config_get_driver_trigger_pg1(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage1_t *config_page);
+int
+mpt3sas_config_get_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage2_t *config_page);
+
 
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 86d1643..b4c2b73 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2027,6 +2027,166 @@ out:
 	return rc;
 }
 
+/**
+ * mpt3sas_config_get_driver_trigger_pg2 - obtain driver trigger page 2
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage2_t *config_page)
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
+	mpi_request.Header.PageNumber = 2;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE2_PAGEVERSION;
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
+ * mpt3sas_config_set_driver_trigger_pg2 - write driver trigger page 2
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+_config_set_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage2_t *config_page)
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
+	mpi_request.Header.PageNumber = 2;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE2_PAGEVERSION;
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
+ * mpt3sas_config_update_driver_trigger_pg2 - update driver trigger page 2
+ * @ioc: per adapter object
+ * @trigger_flags: trigger type bit map
+ * @set: set ot clear trigger values
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_update_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
+	struct SL_WH_EVENT_TRIGGERS_T *event_tg, bool set)
+{
+	Mpi26DriverTriggerPage2_t tg_pg2;
+	Mpi2ConfigReply_t mpi_reply;
+	int rc, i, count;
+	u16 ioc_status;
+
+	rc = mpt3sas_config_update_driver_trigger_pg0(ioc,
+	    MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID, set);
+	if (rc)
+		return rc;
+
+	rc = mpt3sas_config_get_driver_trigger_pg2(ioc, &mpi_reply, &tg_pg2);
+	if (rc)
+		goto out;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg2, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (set) {
+		count = event_tg->ValidEntries;
+		tg_pg2.NumMPIEventTrigger = cpu_to_le16(count);
+		for (i = 0; i < count; i++) {
+			tg_pg2.MPIEventTriggers[i].MPIEventCode =
+			    cpu_to_le16(
+			    event_tg->EventTriggerEntry[i].EventValue);
+			tg_pg2.MPIEventTriggers[i].MPIEventCodeSpecific =
+			    cpu_to_le16(
+			    event_tg->EventTriggerEntry[i].LogEntryQualifier);
+		}
+	} else {
+		tg_pg2.NumMPIEventTrigger = 0;
+		memset(&tg_pg2.MPIEventTriggers[0], 0,
+		    NUM_VALID_ENTRIES * sizeof(
+		    MPI26_DRIVER_MPI_EVENT_TIGGER_ENTRY));
+	}
+
+	rc = _config_set_driver_trigger_pg2(ioc, &mpi_reply, &tg_pg2);
+	if (rc)
+		goto out;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg2, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		rc = -EFAULT;
+		goto out;
+	}
+
+	return 0;
+
+out:
+	mpt3sas_config_update_driver_trigger_pg0(ioc,
+	    MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID, !set);
+
+	return rc;
+}
+
 /**
  * mpt3sas_config_get_volume_handle - returns volume handle for give hidden
  * raid components
-- 
2.18.4


--000000000000978cff05b4d24143
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
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg9uVsouykGBYsYUOCKd5Y/2EOlxXxz7zvDbppszFz
xhYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTI0MDM1MzQw
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAB7jtZskzbNMF3Xq9+Txv9UPSuwPdfT270prLCecHVvuBuj+X0xIiNNG+k7X
gJcXzPLEpr6p/HeptGlw5+nGdiZbMqIvNTZvnpscgthCZO7WXRzvborovXtehSgK1xTfEGcHD51M
UKEBoSimXN1DqxfhkbU7Ex4lcUhqWFpSOljnoc234FNfW645ynr6V/AyHid7cI9yjMjQwxLL75iD
ONC0PPVDXZBMcSMlgEya+8GmJmFkSF0EkDlRz51Vs7aJbvBKTey7vDVxWN9u9ZmWAQaA6t2em3a/
UuEx4prKJgTF1CNuB2sLbej+RwhCPFZXjZQm75dQA8w6SV78EOdOM8Q=
--000000000000978cff05b4d24143--
