Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4566DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbhLTOEs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhLTOEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:45 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD9CC061401
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:45 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b22so4047822pfb.5
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=unjv1E3D2Lr0uwOMu9VzUQYiA+hYGGK3M1mGVQfrqEs=;
        b=gN2vOMKGM/pO79vuxq4SLfFm6KYVAhfrB5OLdh3fkI0I3a64vATwycypPQuTk0TLNl
         QGUKvbM1kMOVcT4RAfzNvMpr81kHUfIqLG14ChGENU+ApMc++OY0CdKkWLWh5rfZPv2U
         AjCdyd8Juea8Q3E7v9XOgMFDgzdVr/060eNA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=unjv1E3D2Lr0uwOMu9VzUQYiA+hYGGK3M1mGVQfrqEs=;
        b=TrH1TaKP0qLttprneM0/Dwhyfpz6UeNPO+pQPJ5fJTQ/GRGM9IV70+X4Ym4yIHz5xk
         8AW6zYZqA3irM/ONVX0M+KsrflvwZC+fAguvGu4304OUgklTzK35oELhoNjNH3rBNmhZ
         MV4O1yzphoWemJocFyOoCtMQghTyRYEvQYb8XU6eWH/J6seWXSNwNYALXrgucQMCs+F4
         aTTXdV0iQSFY0Z+HnPXh45MJH6ZhyEHZRj/3KTqsA2mNqUfpH561AZrDhaRC25zEndSl
         Mdd9AnaqgeItq6PcHtmOTm8A8yHwUxOHtwm1BZNitUA382yv6rUDwbbymkhmaqgHLJBO
         MoqA==
X-Gm-Message-State: AOAM5300Tj2Jm+xVRgbeijRU1WYZUEq7dZ5kyrtMVBu4i3eykeJgHH6R
        fdov0ljMOU7q2ylwivkqid3D2jbjjRp4iAfdE1kMGRmKodLfMoTjsEojzUmHVjtJbtUB1eAyP/G
        pDJ7dnc7gXs7dCaGuTMhAf6eJpzi2KmN98NmYdQpM0Z6KOUNT/lxBZ8kZ3GLSQesihrfvmYsTKR
        LIERA013vY
X-Google-Smtp-Source: ABdhPJwvNFbO9P4hYLdctAoAhKdBCvRHo+kKbk5o/mnop3JgUQYJV68PG148Egy48WeIwdnKZzYzag==
X-Received: by 2002:a62:83c3:0:b0:4ba:bb14:4bf7 with SMTP id h186-20020a6283c3000000b004babb144bf7mr8589092pfe.32.1640009084642;
        Mon, 20 Dec 2021 06:04:44 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:43 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 19/25] mpi3mr: Add support Prepare for Reset event
Date:   Mon, 20 Dec 2021 19:41:53 +0530
Message-Id: <20211220141159.16117-20-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f4509505d3945e21"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f4509505d3945e21
Content-Transfer-Encoding: 8bit

The IOC sends a Prepare for Reset Event to the host to prepare
for a Soft Reset. This event data has below two reason codes,
1. Start - The host is expected to gracefully quiesce all
I/O within approximately 1 second.
2. Abort - The IOC is requesting to abort a previous
Prepare for Reset Event request. Normal I/O may be resumed.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  6 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 83 ++++++++++++++++++++-------------
 drivers/scsi/mpi3mr/mpi3mr_os.c | 40 ++++++++++++++++
 3 files changed, 96 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 2602957..8dd669f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -114,6 +114,7 @@ extern int prot_mask;
 #define MPI3MR_TSUPDATE_INTERVAL		900
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
 #define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
+#define MPI3MR_PREPARE_FOR_RESET_TIMEOUT	180
 #define MPI3MR_RESET_ACK_TIMEOUT		30
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
@@ -693,6 +694,8 @@ struct scmd_priv {
  * @prev_reset_result: Result of previous reset
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
+ * @prepare_for_reset: Prepare for reset event received
+ * @prepare_for_reset_timeout_counter: Prepare for reset timeout
  * @diagsave_timeout: Diagnostic information save timeout
  * @logging_level: Controller debug logging level
  * @flush_io_count: I/O count to flush after reset
@@ -825,6 +828,9 @@ struct mpi3mr_ioc {
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
 
+	u8 prepare_for_reset;
+	u16 prepare_for_reset_timeout_counter;
+
 	u16 diagsave_timeout;
 	int logging_level;
 	u16 flush_io_count;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index b513dca..d5f7f58 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2262,7 +2262,8 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	    container_of(work, struct mpi3mr_ioc, watchdog_work.work);
 	unsigned long flags;
 	enum mpi3mr_iocstate ioc_state;
-	u32 fault, host_diagnostic;
+	u32 fault, host_diagnostic, ioc_status;
+	u32 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
 	if (mrioc->reset_in_progress || mrioc->unrecoverable)
 		return;
@@ -2272,43 +2273,55 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		mpi3mr_sync_timestamp(mrioc);
 	}
 
+	if ((mrioc->prepare_for_reset) &&
+	    ((mrioc->prepare_for_reset_timeout_counter++) >=
+	     MPI3MR_PREPARE_FOR_RESET_TIMEOUT)) {
+		mpi3mr_soft_reset_handler(mrioc,
+		    MPI3MR_RESET_FROM_CIACTVRST_TIMER, 1);
+		return;
+	}
+
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+	if (ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) {
+		mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_FIRMWARE, 0);
+		return;
+	}
+
 	/*Check for fault state every one second and issue Soft reset*/
 	ioc_state = mpi3mr_get_iocstate(mrioc);
-	if (ioc_state == MRIOC_STATE_FAULT) {
-		fault = readl(&mrioc->sysif_regs->fault) &
-		    MPI3_SYSIF_FAULT_CODE_MASK;
-		host_diagnostic = readl(&mrioc->sysif_regs->host_diagnostic);
-		if (host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS) {
-			if (!mrioc->diagsave_timeout) {
-				mpi3mr_print_fault_info(mrioc);
-				ioc_warn(mrioc, "Diag save in progress\n");
-			}
-			if ((mrioc->diagsave_timeout++) <=
-			    MPI3_SYSIF_DIAG_SAVE_TIMEOUT)
-				goto schedule_work;
-		} else
-			mpi3mr_print_fault_info(mrioc);
-		mrioc->diagsave_timeout = 0;
+	if (ioc_state != MRIOC_STATE_FAULT)
+		goto schedule_work;
 
-		if (fault == MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED) {
-			ioc_info(mrioc,
-			    "Factory Reset fault occurred marking controller as unrecoverable"
-			    );
-			mrioc->unrecoverable = 1;
-			goto out;
+	fault = readl(&mrioc->sysif_regs->fault) & MPI3_SYSIF_FAULT_CODE_MASK;
+	host_diagnostic = readl(&mrioc->sysif_regs->host_diagnostic);
+	if (host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS) {
+		if (!mrioc->diagsave_timeout) {
+			mpi3mr_print_fault_info(mrioc);
+			ioc_warn(mrioc, "diag save in progress\n");
 		}
+		if ((mrioc->diagsave_timeout++) <= MPI3_SYSIF_DIAG_SAVE_TIMEOUT)
+			goto schedule_work;
+	}
 
-		if ((fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET) ||
-		    (fault == MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS) ||
-		    (mrioc->reset_in_progress))
-			goto out;
-		if (fault == MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET)
-			mpi3mr_soft_reset_handler(mrioc,
-			    MPI3MR_RESET_FROM_CIACTIV_FAULT, 0);
-		else
-			mpi3mr_soft_reset_handler(mrioc,
-			    MPI3MR_RESET_FROM_FAULT_WATCH, 0);
+	mpi3mr_print_fault_info(mrioc);
+	mrioc->diagsave_timeout = 0;
+
+	switch (fault) {
+	case MPI3_SYSIF_FAULT_CODE_POWER_CYCLE_REQUIRED:
+		ioc_info(mrioc,
+		    "controller requires system power cycle, marking controller as unrecoverable\n");
+		mrioc->unrecoverable = 1;
+		return;
+	case MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS:
+		return;
+	case MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET:
+		reset_reason = MPI3MR_RESET_FROM_CIACTIV_FAULT;
+		break;
+	default:
+		break;
 	}
+	mpi3mr_soft_reset_handler(mrioc, reset_reason, 0);
+	return;
 
 schedule_work:
 	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
@@ -2317,7 +2330,6 @@ schedule_work:
 		    &mrioc->watchdog_work,
 		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
 	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
-out:
 	return;
 }
 
@@ -3488,6 +3500,7 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PREPARE_FOR_RESET);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
 
@@ -4223,6 +4236,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_flush_host_io(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
+	if (mrioc->prepare_for_reset) {
+		mrioc->prepare_for_reset = 0;
+		mrioc->prepare_for_reset_timeout_counter = 0;
+	}
 	mpi3mr_memset_buffers(mrioc);
 	retval = mpi3mr_reinit_ioc(mrioc, 0);
 	if (retval) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 728d6ce..192986f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1988,6 +1988,40 @@ out:
 		mpi3mr_tgtdev_put(tgtdev);
 }
 
+/**
+ * mpi3mr_preparereset_evt_th - Prepare for reset event tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: event data
+ *
+ * Blocks and unblocks host level I/O based on the reason code
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_preparereset_evt_th(struct mpi3mr_ioc *mrioc,
+	struct mpi3_event_notification_reply *event_reply)
+{
+	struct mpi3_event_data_prepare_for_reset *evtdata =
+	    (struct mpi3_event_data_prepare_for_reset *)event_reply->event_data;
+
+	if (evtdata->reason_code == MPI3_EVENT_PREPARE_RESET_RC_START) {
+		dprint_event_th(mrioc,
+		    "prepare for reset event top half with rc=start\n");
+		if (mrioc->prepare_for_reset)
+			return;
+		mrioc->prepare_for_reset = 1;
+		mrioc->prepare_for_reset_timeout_counter = 0;
+	} else if (evtdata->reason_code == MPI3_EVENT_PREPARE_RESET_RC_ABORT) {
+		dprint_event_th(mrioc,
+		    "prepare for reset top half with rc=abort\n");
+		mrioc->prepare_for_reset = 0;
+		mrioc->prepare_for_reset_timeout_counter = 0;
+	}
+	if ((event_reply->msg_flags & MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_MASK)
+	    == MPI3_EVENT_NOTIFY_MSGFLAGS_ACK_REQUIRED)
+		mpi3mr_send_event_ack(mrioc, event_reply->event, NULL,
+		    le32_to_cpu(event_reply->event_context));
+}
+
 /**
  * mpi3mr_energypackchg_evt_th - Energy pack change evt tophalf
  * @mrioc: Adapter instance reference
@@ -2075,6 +2109,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		mpi3mr_pcietopochg_evt_th(mrioc, event_reply);
 		break;
 	}
+	case MPI3_EVENT_PREPARE_FOR_RESET:
+	{
+		mpi3mr_preparereset_evt_th(mrioc, event_reply);
+		ack_req = 0;
+		break;
+	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	{
 		process_evt_bh = 1;
-- 
2.27.0


--000000000000f4509505d3945e21
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHmXEApN2ImxMN2BD25c
O9m/YvJmBL2/eaHhj3wHTRItMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ0NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDEzUBxVopmSn7spQ8N9r0Oa8g0OYBG0Cj8K0cy
63Jd4By5s9NQBgKf0kDIvjcckJo8hxZhfS/8hOMD+SkuS03EqH+SVwAYOJleWydGWIK1k41oHzPb
zSjgoDlFZS1lcroxTGgvrodVWB3OLBSrNX06T9TxPEv3FgMMBRRhagdSB+2usTr5K11N8T34jB/1
upHaxw1uOokoQk3JQ88bx1aYV6VVX9fRAUuMPVCNK2RcJ9z9U9AGv1PUzHiKYKInW2Sv6ag0j+6o
8QzkCFoY1lsaD0+KT7pzGmPv2Dk9EuFXCg+jyV6CT/vsBRMJEK+S25ZHGIyQk0DmGQtJSg1p2V0i
--000000000000f4509505d3945e21--
