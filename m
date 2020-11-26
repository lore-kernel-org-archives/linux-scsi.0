Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A486C63777
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69B620872
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JA14uxHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733281AbgKZJqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733263AbgKZJqB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 04:46:01 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730A2C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:45:59 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id q10so1201925pfn.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=X79vlF+SRwtCYZ9RgHIlhFgJfHA7jCtCZf9Yn2w4vuk=;
        b=JA14uxHegPkkKgKSPLmUpJIDWIRGEISEmkRAT06S8xo66KHg+AWPyUZRckkkXIWyCF
         r9fvNlA4krpGLvK6LicIK2Tw8NsUFx43d1qPTSiBSmXL2rM9VGJsPPrrQ1SHRJEsvrOv
         jJq2G+HYELIHg6V7IEl/3411YCNc4N8VP9Htk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=X79vlF+SRwtCYZ9RgHIlhFgJfHA7jCtCZf9Yn2w4vuk=;
        b=THGq/n+2VJQOO2BOv93fDZWokBo9wyh06hnK9wovU/6iwPUCuN1whYo4b1aXiVb5lh
         a3HuRx+qn+QT/ZCwMSMtrywJZzBTHax/PgdBbv6XA7DL5T4UYmzOops6Nv8TyAEUuPlN
         lWtkSKLdctYmr8yZsiZpSWZiZlD7dz+q/0KiwCQK/VVkgCr1PcrH0urfsCY3nJR9um6v
         52Bd/Cchi7fRHVqgeZC/VSoLNuPi/iOd2vib5oyHFpKtoYZWzUiw+OxfDW6X/P5feMh7
         aJAWB6H7hR/ABhJ9ugcoVK7+fV+ijn9STDMMbezKW6QtU7l4iDZPiOJLt1HHOt4f9B4Z
         Iyew==
X-Gm-Message-State: AOAM533VwC42SjOGAT4uvJC2lryg5Ln3HYBpPlpkCFyv0MsLsxuzJb5P
        F6tyTrDLmkLpMvZ5gNZUGLEmmeWNHmLaQS1doD8zi3RYzC0hqvYUi3YPQCDYeWOhqH/RnIEkZoM
        7+feJO7tr6AOiayUbzZWLV9WtApMBQGrc6ejAkfb6iCoqiJ1A0BkHHP89g/3bL3IbUtnbQZCkWa
        4cVkZJboIR1i8xjnbO77QCww8=
X-Google-Smtp-Source: ABdhPJxy9/etYWP+Nm7oK42EDPmVwnuTXA3ZedKKCkoTQVqXFlr6s3iVbz+MjDs7FSAmkNcGiHYalQ==
X-Received: by 2002:a17:90b:1007:: with SMTP id gm7mr2907150pjb.18.1606383958255;
        Thu, 26 Nov 2020 01:45:58 -0800 (PST)
Received: from dhcp-10-123-20-14.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i10sm4343220pfk.206.2020.11.26.01.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 01:45:57 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v1 5/8] mpt3sas: Add SCSI sense triggers persistent Trigger
Date:   Thu, 26 Nov 2020 15:13:08 +0530
Message-Id: <20201126094311.8686-6-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
References: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003dba5605b4ff69b6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003dba5605b4ff69b6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Description:
This trigger page3 is used to store information about SCSI Sense
triggers.

Persistent Trigger Page-3
------------------------------------------------------------------
| 31         24 23            16 15              8 7            0|    Byte
------------------------------------------------------------------
| PageType      | PageNumber     | Reserved       | PageVersion  |    0x00
------------------------------------------------------------------
| Reserved      | ExtPageType    |          ExtPageLen           |    0x04
------------------------------------------------------------------
| Reserved      | NumScsiSense   |         TriggerEntries        |    0x08
------------------------------------------------------------------
|               ScsiSenseTriggerEntry[0]                         |    0x0C
------------------------------------------------------------------
|                    …        …                                  |
------------------------------------------------------------------
|               ScsiSenseTriggerEntry[19]                        |    0x58
------------------------------------------------------------------

NumScsiSenseTriggerEntries:
This field indicates number of SCSI Sense trigger entries stored in
this page. Currently driver is supporting a maximum of 20-SCSI Sense
trigger entries.

ScsiSenseTriggerEntry:
-----------------------------------------------
| 31      24 23       16 15       8 7       0 |
-----------------------------------------------
| Reserved   | SenseKey  |    ASC   |   ASCQ  |
-----------------------------------------------

ASCQ     => Additional Sense Code Qualifier
ASC      => Additional Sense Code
SenseKey => Sense Key values

ASCQ     => Additional Sense Code Qualifier
ASC      => Additional Sense Code
SenseKey => Sense Key values

During driver load:
 If SCSI Sense trigger type bit is enabled in the Persistent
 Trigger Page0 then read the Persistent Trigger Page3 and update the
 ioc instances diag_trigger_scsi.SCSITriggerEntry with Persistent
 Trigger Page3's SCSISenseTriggerEntries. This will restores the
 SCSI sense trigger type's triggers which are enabled before.

When user modifies the SCSI sense trigger type triggers:
 When user sets/clears the SCSI sense trigger type triggers then
 driver first checks whether IOC firmware supports trigger pages
 support or not. if firmware supports these pages then driver enables
 the SCSI sense trigger type bit in Persistent Trigger Page0 (if it
 was not enabled before) and updates the user provided trigger values
 in Persistent Trigger Page3.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reported-by: kernel test robot <lkp@intel.com>
---
v1 Changes:
Fixed sparse warnings and warnings with W=1 build.

 drivers/scsi/mpt3sas/mpt3sas_base.c   |  59 ++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h   |   6 +
 drivers/scsi/mpt3sas/mpt3sas_config.c | 157 ++++++++++++++++++++++++++
 3 files changed, 222 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1fd77aa..8c2ef56 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4848,6 +4848,57 @@ _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _base_get_scsi_diag_triggers - get scsi diag trigger values from
+ *				persistent pages
+ * @ioc : per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_get_scsi_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi26DriverTriggerPage3_t trigger_pg3;
+	struct SL_WH_SCSI_TRIGGER_T *scsi_tg;
+	MPI26_DRIVER_SCSI_SENSE_TIGGER_ENTRY *mpi_scsi_tg;
+	Mpi2ConfigReply_t mpi_reply;
+	int r = 0, i = 0;
+	u16 count = 0;
+	u16 ioc_status;
+
+	r = mpt3sas_config_get_driver_trigger_pg3(ioc, &mpi_reply,
+	    &trigger_pg3);
+	if (r)
+		return;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dinitprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg3, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		return;
+	}
+
+	if (le16_to_cpu(trigger_pg3.NumSCSISenseTrigger)) {
+		count = le16_to_cpu(trigger_pg3.NumSCSISenseTrigger);
+		count = min_t(u16, NUM_VALID_ENTRIES, count);
+		ioc->diag_trigger_scsi.ValidEntries = count;
+
+		scsi_tg = &ioc->diag_trigger_scsi.SCSITriggerEntry[0];
+		mpi_scsi_tg = &trigger_pg3.SCSISenseTriggers[0];
+		for (i = 0; i < count; i++) {
+			scsi_tg->ASCQ = mpi_scsi_tg->ASCQ;
+			scsi_tg->ASC = mpi_scsi_tg->ASC;
+			scsi_tg->SenseKey = mpi_scsi_tg->SenseKey;
+
+			scsi_tg++;
+			mpi_scsi_tg++;
+		}
+	}
+}
+
 /**
  * _base_get_master_diag_triggers - get master diag trigger values from
  *				persistent pages
@@ -4953,6 +5004,14 @@ _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 	    MPI26_DRIVER_TRIGGER0_FLAG_MPI_EVENT_TRIGGER_VALID)
 		_base_get_event_diag_triggers(ioc);
 
+	/*
+	 * Retrieve scsi diag trigger values from driver trigger pg3
+	 * if scsi trigger bit enabled in TriggerFlags.
+	 */
+	if ((u16)trigger_flags &
+	    MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID)
+		_base_get_scsi_diag_triggers(ioc);
+
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 1d381d7..ffc04e6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1829,11 +1829,17 @@ int
 mpt3sas_config_get_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage2_t *config_page);
 int
+mpt3sas_config_get_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage3_t *config_page);
+int
 mpt3sas_config_update_driver_trigger_pg1(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_MASTER_TRIGGER_T *master_tg, bool set);
 int
 mpt3sas_config_update_driver_trigger_pg2(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_EVENT_TRIGGERS_T *event_tg, bool set);
+int
+mpt3sas_config_update_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
+	struct SL_WH_SCSI_TRIGGERS_T *scsi_tg, bool set);
 
 /* ctl shared API */
 extern struct device_attribute *mpt3sas_host_attrs[];
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 9bad6a8..ae1caba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -2187,6 +2187,163 @@ out:
 	return rc;
 }
 
+/**
+ * mpt3sas_config_get_driver_trigger_pg3 - obtain driver trigger page 3
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_get_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage3_t *config_page)
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
+	mpi_request.Header.PageNumber = 3;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE3_PAGEVERSION;
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
+ * mpt3sas_config_set_driver_trigger_pg3 - write driver trigger page 3
+ * @ioc: per adapter object
+ * @mpi_reply: reply mf payload returned from firmware
+ * @config_page: contents of the config page
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_config_set_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2ConfigReply_t *mpi_reply, Mpi26DriverTriggerPage3_t *config_page)
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
+	mpi_request.Header.PageNumber = 3;
+	mpi_request.Header.PageVersion = MPI26_DRIVER_TRIGGER_PAGE3_PAGEVERSION;
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
+ * mpt3sas_config_update_driver_trigger_pg3 - update driver trigger page 3
+ * @ioc: per adapter object
+ * @scsi_tg: scsi trigger list
+ * @set: set ot clear trigger values
+ * Context: sleep.
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_config_update_driver_trigger_pg3(struct MPT3SAS_ADAPTER *ioc,
+	struct SL_WH_SCSI_TRIGGERS_T *scsi_tg, bool set)
+{
+	Mpi26DriverTriggerPage3_t tg_pg3;
+	Mpi2ConfigReply_t mpi_reply;
+	int rc, i, count;
+	u16 ioc_status;
+
+	rc = mpt3sas_config_update_driver_trigger_pg0(ioc,
+	    MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID, set);
+	if (rc)
+		return rc;
+
+	rc = mpt3sas_config_get_driver_trigger_pg3(ioc, &mpi_reply, &tg_pg3);
+	if (rc)
+		goto out;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg3, ioc_status(0x%04x)\n",
+		    __func__, ioc_status));
+		return -EFAULT;
+	}
+
+	if (set) {
+		count = scsi_tg->ValidEntries;
+		tg_pg3.NumSCSISenseTrigger = cpu_to_le16(count);
+		for (i = 0; i < count; i++) {
+			tg_pg3.SCSISenseTriggers[i].ASCQ =
+			    scsi_tg->SCSITriggerEntry[i].ASCQ;
+			tg_pg3.SCSISenseTriggers[i].ASC =
+			    scsi_tg->SCSITriggerEntry[i].ASC;
+			tg_pg3.SCSISenseTriggers[i].SenseKey =
+			    scsi_tg->SCSITriggerEntry[i].SenseKey;
+		}
+	} else {
+		tg_pg3.NumSCSISenseTrigger = 0;
+		memset(&tg_pg3.SCSISenseTriggers[0], 0,
+		    NUM_VALID_ENTRIES * sizeof(
+		    MPI26_DRIVER_SCSI_SENSE_TIGGER_ENTRY));
+	}
+
+	rc = _config_set_driver_trigger_pg3(ioc, &mpi_reply, &tg_pg3);
+	if (rc)
+		goto out;
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		dcprintk(ioc,
+		    ioc_err(ioc,
+		    "%s: Failed to get trigger pg3, ioc_status(0x%04x)\n",
+		     __func__, ioc_status));
+		return -EFAULT;
+	}
+
+	return 0;
+out:
+	mpt3sas_config_update_driver_trigger_pg0(ioc,
+	    MPI26_DRIVER_TRIGGER0_FLAG_SCSI_SENSE_TRIGGER_VALID, !set);
+
+	return rc;
+}
+
 /**
  * mpt3sas_config_get_volume_handle - returns volume handle for give hidden
  * raid components
-- 
2.27.0


--0000000000003dba5605b4ff69b6
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
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgdr9WfxtdUvpaZEiI+APi/KY9+5anzjQGvu0qWvkL
X5MwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTI2MDk0NTU4
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAGhoGyMfzkEct/4owMm5onYlWIxVrWZ48b7I4Jqo+fc0HkfuiPlGIvg3fpvT
FOzJma6D5X/6m/FBPb6Yign8kBpT/jDn8CuJTPcmTNm5O8uKO/TCLaeCuEcHvHd5GY8mK+3Wqa5Q
WPeyerJrJAL4d3GwFhRnU9N5UOkI/nxXkUdz0MWQUXIlLfb8Ca7KFlO37G8LDaNGuTlfKpMWN6pn
XgF1FUfMzGnYwvKuHQWSqMkkvvZuLnWozVgRFIPuuHdWTDF8bn373U+IjU1R0H+RKadcvRea6+DS
Zlx6b0f5ap0YP0rXMGZH7vs7WNRFwYO82PNBFDFFriceImEyFp6eDak=
--0000000000003dba5605b4ff69b6--
