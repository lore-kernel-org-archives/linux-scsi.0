Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEF0C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CE1613B8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbhDGCFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343919AbhDGCEr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:04:47 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE763C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n38so2118948pfv.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EdDwc+9VBFwQbBWXjEZGT6vfzuM0oj7dKhv5yoXRJLs=;
        b=ToXLRMIARymvhHkIubjoMzXMakTTHmKzCChy0+Pkem1S7OSCqP8qOEXjj5QEGnOuHB
         8GYcznBQCjzvkoP/XTDu6l9csklswzj5Px0Ibe+KsDCmQ8wbS5fMXCmYZHzC+MTic5u3
         W38sJ1WSoXMvCVj8LquScYntZSbig0K46SNSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EdDwc+9VBFwQbBWXjEZGT6vfzuM0oj7dKhv5yoXRJLs=;
        b=dKId57E/Y/DS65mt7bqvFQqg9t+q9SqTOFn6jaAPOlP7k/UyVfLLlV1KFpgOkhJ3q3
         1d0WrgLqsxfaQA8nkq0fNPq/RH/onEQVXQcLRR59ZGuQiUwTYK2TQ+gPm0kXFTZRY7IZ
         qVctxLjc3r2hhKe2NOKIRQpsu9AvRi45VQNiGH5LUrWlY68ocRDTjWcqMkdq8Tdj7+xJ
         j9iTC6f5cgjc5dxBNUny/0akyaL0Bxxey/HrGvSfgcxjZM5ipjvXj3rf0RwtKxdzvTT/
         gIG3edOhmgdQAlmA0NEElhl603Cjtpx3Fr/Ve93Vt+QibZoShWjzNY6y3GCnOIK1FFO0
         VYSA==
X-Gm-Message-State: AOAM532PBN6w35Vg4xd/gf6UqB9ebVcOOjFS6LoANxygOsloxuUhuEYI
        v6gYREead/vMEUEFJyEVwjCi5XjrmustKBU/jbFXgcEdGtvzeMGCokCq75dpK0uZkatSW2doP7W
        g31BqaXJaOnO7UHFldTI9rbTvgB6orPzN4LRXgYZrlRvorcMsT6kWMo0GDbJ1tvyYYbsBGnsQ6f
        gqmZbYzg==
X-Google-Smtp-Source: ABdhPJx3Zu7+23gch+xafCfVzoIkekbNPrRrCWN141wnAgLZScC+E6lbHW2eGh/p00ZStEGzPdxv0A==
X-Received: by 2002:a63:67c7:: with SMTP id b190mr1031894pgc.162.1617761078075;
        Tue, 06 Apr 2021 19:04:38 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:37 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 10/24] mpi3mr: add support of timestamp sync with firmware
Date:   Wed,  7 Apr 2021 07:34:37 +0530
Message-Id: <20210407020451.924822-11-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000069c3f405bf585a2d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000069c3f405bf585a2d

This operation requests that the IOC update the TimeStamp.

When the I/O Unit is powered on, it sets the TimeStamp field value to
0x0000_0000_0000_0000 and increments the current value every millisecond.
A host driver sets the TimeStamp field to the current time by using an
IOCInit request. The TimeStamp field is periodically updated by host driver.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 74 +++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d18bfb954bc4..801612c9eb2a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -99,6 +99,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_PORTENABLE_TIMEOUT		300
 #define MPI3MR_RESETTM_TIMEOUT			30
 #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
+#define MPI3MR_TSUPDATE_INTERVAL		900
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
@@ -631,6 +632,7 @@ struct scmd_priv {
  * @dev_handle_bitmap_sz: Device handle bitmap size
  * @removepend_bitmap: Remove pending bitmap
  * @delayed_rmhs_list: Delayed device removal list
+ * @ts_update_counter: Timestamp update counter
  * @fault_dbg: Fault debug flag
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
@@ -753,6 +755,7 @@ struct mpi3mr_ioc {
 	void *removepend_bitmap;
 	struct list_head delayed_rmhs_list;
 
+	u32 ts_update_counter;
 	u8 fault_dbg;
 	u8 reset_in_progress;
 	u8 unrecoverable;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index b8e9c87ea677..d47031d05322 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1485,6 +1485,74 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_sync_timestamp - Issue time stamp sync request
+ * @mrioc: Adapter reference
+ *
+ * Issue IO unit control MPI request to synchornize firmware
+ * timestamp with host time.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_sync_timestamp(struct mpi3mr_ioc *mrioc)
+{
+	ktime_t current_time;
+	Mpi3IoUnitControlRequest_t iou_ctrl;
+	int retval = 0;
+
+	memset(&iou_ctrl, 0, sizeof(iou_ctrl));
+	mutex_lock(&mrioc->init_cmds.mutex);
+	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "Issue IOUCTL TimeStamp: command is in use\n");
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		goto out;
+	}
+	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->init_cmds.is_waiting = 1;
+	mrioc->init_cmds.callback = NULL;
+	iou_ctrl.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
+	iou_ctrl.Function = MPI3_FUNCTION_IO_UNIT_CONTROL;
+	iou_ctrl.Operation = MPI3_CTRL_OP_UPDATE_TIMESTAMP;
+	current_time = ktime_get_real();
+	iou_ctrl.Param64[0] = cpu_to_le64(ktime_to_ms(current_time));
+
+	init_completion(&mrioc->init_cmds.done);
+	retval = mpi3mr_admin_request_post(mrioc, &iou_ctrl,
+	    sizeof(iou_ctrl), 0);
+	if (retval) {
+		ioc_err(mrioc, "Issue IOUCTL TimeStamp: Admin Post failed\n");
+		goto out_unlock;
+	}
+
+	wait_for_completion_timeout(&mrioc->init_cmds.done,
+	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "Issue IOUCTL TimeStamp: command timed out\n");
+		mrioc->init_cmds.is_waiting = 0;
+		mpi3mr_soft_reset_handler(mrioc,
+		    MPI3MR_RESET_FROM_TSU_TIMEOUT, 1);
+		retval = -1;
+		goto out_unlock;
+	}
+	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	    != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "Issue IOUCTL TimeStamp: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+		    mrioc->init_cmds.ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->init_cmds.mutex);
+
+out:
+	return retval;
+}
+
 /**
  * mpi3mr_watchdog_work - watchdog thread to monitor faults
  * @work: work struct
@@ -1503,6 +1571,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	enum mpi3mr_iocstate ioc_state;
 	u32 fault, host_diagnostic;
 
+	if (mrioc->ts_update_counter++ >= MPI3MR_TSUPDATE_INTERVAL) {
+		mrioc->ts_update_counter = 0;
+		mpi3mr_sync_timestamp(mrioc);
+	}
+
 	/*Check for fault state every one second and issue Soft reset*/
 	ioc_state = mpi3mr_get_iocstate(mrioc);
 	if (ioc_state == MRIOC_STATE_FAULT) {
@@ -3313,6 +3386,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		mrioc->reset_in_progress = 0;
 		scsi_unblock_requests(mrioc->shost);
 		mpi3mr_rfresh_tgtdevs(mrioc);
+		mrioc->ts_update_counter = 0;
 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
 		if (mrioc->watchdog_work_q)
 			queue_delayed_work(mrioc->watchdog_work_q,
-- 
2.18.1


--00000000000069c3f405bf585a2d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJ49S3yjpDACxJrlTYgB4vh0CFxz
biUHr2rKrKnQxrNbMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAxn1d43h6rK8cAlLise8OV8CxPrktpADW1unuucpM/HWSM
TaiiVl3se3xYAOGsJamosXjPLMKYkEb+EvUYXfiH5Lj6ZefDWYVQRprrPGvB8aKajq/gPBpuQWoW
mdrAtIasJ3f3NzUWLdiY/hzxYDOuni0mpJVUaVRt9M+H2o2Iz6XaPLbmY37p6GXjPYfpxKVJzZ2D
I/0aebhk1efkbRn2Dpqz26V1idoxmcnBU20+MSj7NGZmjF/qw/2MyDz9yWBb5DTCo7GT6juKqvDm
rFHOUGMJ+aIbzmWhbdg00hUOy//DSXNpQLf4vQorJ+yu2rHVYMecDkh2o+eP+nzFIerd
--00000000000069c3f405bf585a2d--
