Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68FCC6379D
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397F921D7F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ct2lJWyf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgKZJpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733240AbgKZJpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 04:45:44 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3A3C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:45:44 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id n137so1191521pfd.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=U7+tT/+gThjwd4e5TUlYCvovURlt3tudJGVem9Fj3lQ=;
        b=ct2lJWyfhim8B1RibAM2cy/6+C3n7NpLrZI3JVKq3f8TKqTRHFHVTqcxtitJPS6saI
         P/wjp3zZx+X5Vd82fDrvJ/UHwR2CBPk+k/Ui5CQ0SHWuN7EJM8w6RlHzcDSXYB+0JhLK
         4w13W6ZX9C0AJOBThDJBDmX0n1xfTR7YQv/zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=U7+tT/+gThjwd4e5TUlYCvovURlt3tudJGVem9Fj3lQ=;
        b=R7KgkYmLDvjBfSWGID2OytcbsQEvMyy9Np4QluqBBaa4LaQKS9ePHITMKNzYBcuse6
         sjVPjaTx9i1gxLaAdNJQ3oue89BSEw9tc1BNUzcdHt/sLI9aiVRBU93R5IYZwOSApH4s
         xMd4B0D44ljQYMpcRljVPW+ewTCFm+eMFBJU/n8L6Yr7UClA1zjnbaxBJ5rfBgltxKWy
         FnfNI2xDmOSx2Z1zfyPt/J/n93lQg1ByzREGQh1DDnKPcs/Ws/qP0whEnYCTe3Tf/pfq
         Znq1yTV+ap64TO2xXnn/8Kl/+MCrtHLJChcwjF7dDVCNopV66iD1UYPsBaHakVFw7ZhV
         0MWg==
X-Gm-Message-State: AOAM5315Bznw2KUAleDU5R1nniJsXXN3SkJ3p0kngAI7cManuuGuVEt3
        cDXhrpiA88nb26Pk1kjhfNvRFDfU8Ss966biPRbIKdbr+Zr5adzzmDgp8RK3imYdRXTFGJMCgx0
        tMEo/g0PMRe9ZPEFUgylyXn1cQC0cbChnUuPSsJRXflkmZmxA6X+urSVEQpq68SewLiS/xKbEj1
        7vGImVZ/SFNNWKgsF2TivO0UM=
X-Google-Smtp-Source: ABdhPJzXzOCZTlsdodujkf4SgwRega1arIyjtG1h9CzBSiPPM1q8uIRfkp+sXuT2lQMkA0q25p0IkQ==
X-Received: by 2002:a63:4d0e:: with SMTP id a14mr1871124pgb.91.1606383943091;
        Thu, 26 Nov 2020 01:45:43 -0800 (PST)
Received: from dhcp-10-123-20-14.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i10sm4343220pfk.206.2020.11.26.01.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 01:45:42 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v1 1/8] mpt3sas: Sync time stamp periodically between Driver and FW
Date:   Thu, 26 Nov 2020 15:13:04 +0530
Message-Id: <20201126094311.8686-2-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
References: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000056298805b4ff68e3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000056298805b4ff68e3
Content-Transfer-Encoding: 8bit

Issue Description:
In current Driver/FW, the controller timestamp gets updated
with host time during driver load time or when a controller
reset is issued. i.e. when host issues the IOCInit request
message to the HBA FW. This IOCInit message has a field named
'TimeStamp' using which the host updates the controller
timestamp. Over a period, sometimes we may observe controller
time drifting away from host and it is difficult to co-relate
host logs with controller logs with respect to time.
And every time driver cannot issue the IOCInit request message
just for updating the controller timestamp.

Implementation:
Instead of IOCInit, driver sends IO_UNIT_CONTROL Request to
sync time stamp periodically with controller. Timestamp
synchronization interval is specified in 'TimeSyncInterval'
field of Manufacturing Page11 by controller.
TimeSyncInterval - 8 bits
        bits  0-6: Time stamp Synchronization interval value
        bit     7: Time stamp Synchronization interval unit,
                (if this bit is one then Timestamp Synchronization
                interval value is specified in terms of hours else
                Timestamp Synchronization interval value is
                specified in terms of minutes).

Driver sends this IO_UNIT_CONTROL Request message from
watchdog thread (which gets invoked every one second).
Driver keeps tracks of timer using ioc's timestamp_update_count
field. This field value gets incremented whenever the watchdog
thread gets invoked. And whenever this field value is greater
than or equals to the Time stamp Synchronization interval value
then driver sends the IO_UNIT_CONTROL Request message to
controller to update the time stamp and then it resets the
timestamp_update_count field to zero.

Syncing Driver and FW timestamp periodically makes
correlating the FW logs and OS events easier.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Reported-by: kernel test robot <lkp@intel.com>
---
v1 Changes:
Fixed sparse warnings.

 drivers/scsi/mpt3sas/mpt3sas_base.c | 93 ++++++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h | 14 ++++-
 2 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 93230cd..8538c2d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -596,6 +596,71 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	return 0;
 }
 
+/**
+ * _base_sync_drv_fw_timestamp - Sync Drive-Fw TimeStamp.
+ * @ioc: Per Adapter Object
+ *
+ * Return nothing.
+ */
+static void _base_sync_drv_fw_timestamp(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi26IoUnitControlRequest_t *mpi_request;
+	Mpi26IoUnitControlReply_t *mpi_reply;
+	u16 smid;
+	ktime_t current_time;
+	u64 TimeStamp = 0;
+	u8 issue_reset = 0;
+
+	mutex_lock(&ioc->scsih_cmds.mutex);
+	if (ioc->scsih_cmds.status != MPT3_CMD_NOT_USED) {
+		ioc_err(ioc, "scsih_cmd in use %s\n", __func__);
+		goto out;
+	}
+	ioc->scsih_cmds.status = MPT3_CMD_PENDING;
+	smid = mpt3sas_base_get_smid(ioc, ioc->scsih_cb_idx);
+	if (!smid) {
+		ioc_err(ioc, "Failed obtaining a smid %s\n", __func__);
+		ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+		goto out;
+	}
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	ioc->scsih_cmds.smid = smid;
+	memset(mpi_request, 0, sizeof(Mpi26IoUnitControlRequest_t));
+	mpi_request->Function = MPI2_FUNCTION_IO_UNIT_CONTROL;
+	mpi_request->Operation = MPI26_CTRL_OP_SET_IOC_PARAMETER;
+	mpi_request->IOCParameter = MPI26_SET_IOC_PARAMETER_SYNC_TIMESTAMP;
+	current_time = ktime_get_real();
+	TimeStamp = ktime_to_ms(current_time);
+	mpi_request->Reserved7 = cpu_to_le32(TimeStamp & 0xFFFFFFFF);
+	mpi_request->IOCParameterValue = cpu_to_le32(TimeStamp >> 32);
+	init_completion(&ioc->scsih_cmds.done);
+	ioc->put_smid_default(ioc, smid);
+	dinitprintk(ioc, ioc_info(ioc,
+	    "Io Unit Control Sync TimeStamp (sending), @time %lld ms\n",
+	    TimeStamp));
+	wait_for_completion_timeout(&ioc->scsih_cmds.done,
+		MPT3SAS_TIMESYNC_TIMEOUT_SECONDS*HZ);
+	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->scsih_cmds.status, mpi_request,
+		    sizeof(Mpi2SasIoUnitControlRequest_t)/4, issue_reset);
+		goto issue_host_reset;
+	}
+	if (ioc->scsih_cmds.status & MPT3_CMD_REPLY_VALID) {
+		mpi_reply = ioc->scsih_cmds.reply;
+		dinitprintk(ioc, ioc_info(ioc,
+		    "Io Unit Control sync timestamp (complete): ioc_status(0x%04x), loginfo(0x%08x)\n",
+		    le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo)));
+	}
+issue_host_reset:
+	if (issue_reset)
+		mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
+	ioc->scsih_cmds.status = MPT3_CMD_NOT_USED;
+out:
+	mutex_unlock(&ioc->scsih_cmds.mutex);
+}
+
 /**
  * _base_fault_reset_work - workq handling ioc fault conditions
  * @work: input argument, used to derive ioc
@@ -720,7 +785,11 @@ _base_fault_reset_work(struct work_struct *work)
 			return; /* don't rearm timer */
 	}
 	ioc->ioc_coredump_loop = 0;
-
+	if (ioc->time_sync_interval &&
+	    ++ioc->timestamp_update_count >= ioc->time_sync_interval) {
+		ioc->timestamp_update_count = 0;
+		_base_sync_drv_fw_timestamp(ioc);
+	}
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
  rearm_timer:
 	if (ioc->fault_reset_work_q)
@@ -744,6 +813,7 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->fault_reset_work_q)
 		return;
 
+	ioc->timestamp_update_count = 0;
 	/* initialize fault polling */
 
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
@@ -4754,7 +4824,24 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 		else
 			ioc->nvme_abort_timeout = ioc->manu_pg11.NVMeAbortTO;
 	}
-
+	ioc->time_sync_interval =
+	    ioc->manu_pg11.TimeSyncInterval & MPT3SAS_TIMESYNC_MASK;
+	if (ioc->time_sync_interval) {
+		if (ioc->manu_pg11.TimeSyncInterval & MPT3SAS_TIMESYNC_UNIT_MASK)
+			ioc->time_sync_interval =
+			    ioc->time_sync_interval * SECONDS_PER_HOUR;
+		else
+			ioc->time_sync_interval =
+			    ioc->time_sync_interval * SECONDS_PER_MIN;
+		dinitprintk(ioc, ioc_info(ioc,
+		    "Driver-FW TimeSync interval is %d seconds. ManuPg11 TimeSync Unit is in %s\n",
+		    ioc->time_sync_interval, (ioc->manu_pg11.TimeSyncInterval &
+		    MPT3SAS_TIMESYNC_UNIT_MASK) ? "Hour" : "Minute"));
+	} else {
+		if (ioc->is_gen35_ioc)
+			ioc_warn(ioc,
+			    "TimeSync Interval in Manuf page-11 is not enabled. Periodic Time-Sync will be disabled\n");
+	}
 	mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
 	mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
 	mpt3sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
@@ -6466,6 +6553,8 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 		r = -EIO;
 	}
 
+	/* Reset TimeSync Counter*/
+	ioc->timestamp_update_count = 0;
 	return r;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 7dab579..cc4815c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -93,6 +93,14 @@
 /* CoreDump: Default timeout */
 #define MPT3SAS_DEFAULT_COREDUMP_TIMEOUT_SECONDS	(15) /*15 seconds*/
 #define MPT3SAS_COREDUMP_LOOP_DONE                     (0xFF)
+#define MPT3SAS_TIMESYNC_TIMEOUT_SECONDS		(10) /* 10 seconds */
+#define MPT3SAS_TIMESYNC_UPDATE_INTERVAL		(900) /* 15 minutes */
+#define MPT3SAS_TIMESYNC_UNIT_MASK			(0x80) /* bit 7 */
+#define MPT3SAS_TIMESYNC_MASK				(0x7F) /* 0 - 6 bits */
+#define SECONDS_PER_MIN					(60)
+#define SECONDS_PER_HOUR				(3600)
+#define MPT3SAS_COREDUMP_LOOP_DONE			(0xFF)
+#define MPI26_SET_IOC_PARAMETER_SYNC_TIMESTAMP		(0x81)
 
 /*
  * Set MPT3SAS_SG_DEPTH value based on user input.
@@ -405,7 +413,7 @@ struct Mpi2ManufacturingPage11_t {
 	u16	HostTraceBufferMaxSizeKB;	/* 50h */
 	u16	HostTraceBufferMinSizeKB;	/* 52h */
 	u8	CoreDumpTOSec;			/* 54h */
-	u8	Reserved8;			/* 55h */
+	u8	TimeSyncInterval;		/* 55h */
 	u16	Reserved9;			/* 56h */
 	__le32	Reserved10;			/* 58h */
 };
@@ -1113,6 +1121,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @cpu_msix_table_sz: table size
  * @total_io_cnt: Gives total IO count, used to load balance the interrupts
  * @ioc_coredump_loop: will have non-zero value when FW is in CoreDump state
+ * @timestamp_update_count: Counter to fire timeSync command
+ * time_sync_interval: Time sync interval read from man page 11
  * @high_iops_outstanding: used to load balance the interrupts
  *				within high iops reply queues
  * @msix_load_balance: Enables load balancing of interrupts across
@@ -1308,6 +1318,8 @@ struct MPT3SAS_ADAPTER {
 	MPT3SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	u32             non_operational_loop;
 	u8              ioc_coredump_loop;
+	u32		timestamp_update_count;
+	u32		time_sync_interval;
 	atomic64_t      total_io_cnt;
 	atomic64_t	high_iops_outstanding;
 	bool            msix_load_balance;
-- 
2.27.0


--00000000000056298805b4ff68e3
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
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg6D7kpT8Tt/dlQaeiRU0VnPzsTfxXV/dDPoC4FLuw
nFowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTI2MDk0NTQz
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAAdAx1x+yP55VExjBj3gAJ8iSZsvyTY6h9608mwGksRw11CtGv+9QdsSU/fD
r6xC7NtqBXGNSWJOIT9L8tlnEMyqkJlzMH4rJicFAdhMs2shTLhucdE8Rh+QYD1/e6AyuroQUJGu
rkUBm4QoU5w6LTwMFGaVGBlGwip2NV/C9HaUaoZBHiPlOR7sP0p19FCJFdVYoFjnTEdBssE2Q9vO
QU3j9c7fzr4ARGIvOCAJwND596R5Wvvpu306jTuLyWlu8fyRxbyUAI+gv/p6QwG06LSGpFzVznwu
5c0WffgDsW8edhioRipksX6JUe9d/2dl3O0AfoYuBHtwE5BY65bFPyU=
--00000000000056298805b4ff68e3--
