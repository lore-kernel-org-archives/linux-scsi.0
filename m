Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA98C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 09:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiBJJsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 04:48:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238982AbiBJJsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 04:48:35 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E8138
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 01:48:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id u16so3584616pfg.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 01:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Q547jMa4UA53t4ZYNiYRJ4odOz+LQPcghzvQ+7qW/uk=;
        b=Ub7gbKDAjQ51y5+ALxa2pWeKgZNMk0xpNWVTJ6+lI5JhEvF6w4Pj46n6gKHhh3Gwbh
         1T7JU80mpgou1bCrrpH7vaNvWfoe1zFyKmNO+gErjJreDg/rrJ/LvMftLRUe8IpVx0lT
         QnTaR88hcssC/CoF3gV+RvqoRzRw05+o39z08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Q547jMa4UA53t4ZYNiYRJ4odOz+LQPcghzvQ+7qW/uk=;
        b=NSU38s9C4bSEhtgLqoerWfrg6i33evKKqjBGTYKfbNHBOuxTFIa1JnWKBO9mZ9n3nV
         hpMkJpgANRUWPSVTxjlMJgthf0PSDzuwRYaKFdl4SfZ16cY/6rB+ucycZrs7BSWjaQkg
         /DOB/Uyu5QKQ20yFNOIj9nBS6dhJkXp1FT3d+n0JtcFZQNC91N4eXQVwSEF65RronIz5
         sBe404Xh/mfpL6spUQlhXq0ZNEVFXJQMHRerlc4TqOO9erN/39JwFLEPSDGfhuWC8rkW
         O8UzACrfZ4HhmLrz49KAjEZj69XZAmfLBuaPPiDkVSDDDD1K+aKjyGUskzpYhumy/6tW
         orug==
X-Gm-Message-State: AOAM531SH5BtiS3SSSzSZ+BogZNofTdD789nt/agYHBDUEO5bchL5m27
        fAWp2z6UOI5AZ71+OIpeCL45zBB9ugcF7hdw4zNn0lPeq0oD3t2qzguFsZ6MJbNQfH9/7tHl6mv
        rBqYBVvgHbU5jOWpa0uZ0uPkv6NG6A3LSBWIKmGdTNQMLxu/2RPsKZgaRA8jv2q0iYjvNNYhDfC
        olietJon9srXk=
X-Google-Smtp-Source: ABdhPJxH/X2EYCFZffoZON2PVsUnNopxDjXMqSpgYlLrJRPirrPH+E3So6GSuH9JMOqKkEuoAkxKGQ==
X-Received: by 2002:a05:6a00:198a:: with SMTP id d10mr6776571pfl.2.1644486515004;
        Thu, 10 Feb 2022 01:48:35 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o21sm23706698pfu.100.2022.02.10.01.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:48:34 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 1/9] mpi3mr: Fix deadlock while canceling the fw event
Date:   Thu, 10 Feb 2022 15:28:09 +0530
Message-Id: <20220210095817.22828-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
References: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000099ee8f05d7a6da17"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000099ee8f05d7a6da17
Content-Transfer-Encoding: 8bit

During controller reset, the driver tries to flush all
the pending firmware event works from worker queue that are queued
prior to the reset. However, if any work is waiting for
device addition/removal operation to be completed at the
SML then a deadlock is observed. This is due to the reason that
the controller reset is waiting for the device addition/removal
to be completed and the device/addition removal is waiting for
the controller reset to be completed.

So, to limit this deadlock, continue with the controller reset
handling without canceling the work which is waiting for
device addition/removal operation to complete at SML.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   4 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 106 ++++++++++++++++++++++++++------
 3 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index fc4eaf6..d892ade 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -866,6 +866,8 @@ struct mpi3mr_ioc {
  * @send_ack: Event acknowledgment required or not
  * @process_evt: Bottomhalf processing required or not
  * @evt_ctx: Event context to send in Ack
+ * @pending_at_sml: waiting for device add/remove API to complete
+ * @discard: discard this event
  * @ref_count: kref count
  * @event_data: Actual MPI3 event data
  */
@@ -877,6 +879,8 @@ struct mpi3mr_fwevt {
 	bool send_ack;
 	bool process_evt;
 	u32 evt_ctx;
+	bool pending_at_sml;
+	bool discard;
 	struct kref ref_count;
 	char event_data[0] __aligned(4);
 };
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 15bdc21..7193b98 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4353,8 +4353,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
 	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
 	memset(mrioc->evtack_cmds_bitmap, 0, mrioc->evtack_cmds_bitmap_sz);
-	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_flush_host_io(mrioc);
+	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
 	if (mrioc->prepare_for_reset) {
 		mrioc->prepare_for_reset = 0;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 284117d..90911ea 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -285,6 +285,35 @@ static struct mpi3mr_fwevt *mpi3mr_dequeue_fwevt(
 	return fwevt;
 }
 
+/**
+ * mpi3mr_cancel_work - cancel firmware event
+ * @fwevt: fwevt object which needs to be canceled
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
+{
+	/*
+	 * Wait on the fwevt to complete. If this returns 1, then
+	 * the event was never executed.
+	 *
+	 * If it did execute, we wait for it to finish, and the put will
+	 * happen from mpi3mr_process_fwevt()
+	 */
+	if (cancel_work_sync(&fwevt->work)) {
+		/*
+		 * Put fwevt reference count after
+		 * dequeuing it from worker queue
+		 */
+		mpi3mr_fwevt_put(fwevt);
+		/*
+		 * Put fwevt reference count to neutralize
+		 * kref_init increment
+		 */
+		mpi3mr_fwevt_put(fwevt);
+	}
+}
+
 /**
  * mpi3mr_cleanup_fwevt_list - Cleanup firmware event list
  * @mrioc: Adapter instance reference
@@ -302,28 +331,25 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 	    !mrioc->fwevt_worker_thread)
 		return;
 
-	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)) ||
-	    (fwevt = mrioc->current_event)) {
+	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)))
+		mpi3mr_cancel_work(fwevt);
+
+	if (mrioc->current_event) {
+		fwevt = mrioc->current_event;
 		/*
-		 * Wait on the fwevt to complete. If this returns 1, then
-		 * the event was never executed, and we need a put for the
-		 * reference the work had on the fwevt.
-		 *
-		 * If it did execute, we wait for it to finish, and the put will
-		 * happen from mpi3mr_process_fwevt()
+		 * Don't call cancel_work_sync() API for the
+		 * fwevt work if the controller reset is
+		 * get called as part of processing the
+		 * same fwevt work (or) when worker thread is
+		 * waiting for device add/remove APIs to complete.
+		 * Otherwise we will see deadlock.
 		 */
-		if (cancel_work_sync(&fwevt->work)) {
-			/*
-			 * Put fwevt reference count after
-			 * dequeuing it from worker queue
-			 */
-			mpi3mr_fwevt_put(fwevt);
-			/*
-			 * Put fwevt reference count to neutralize
-			 * kref_init increment
-			 */
-			mpi3mr_fwevt_put(fwevt);
+		if (current_work() == &fwevt->work || fwevt->pending_at_sml) {
+			fwevt->discard = 1;
+			return;
 		}
+
+		mpi3mr_cancel_work(fwevt);
 	}
 }
 
@@ -690,6 +716,24 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_from_tgtpriv(
 	return tgtdev;
 }
 
+/**
+ * mpi3mr_print_device_event_notice - print notice related to post processing of
+ *					device event after controller reset.
+ *
+ * @mrioc: Adapter instance reference
+ * @device_add: true for device add event and false for device removal event
+ *
+ * Return: None.
+ */
+static void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
+	bool device_add)
+{
+	ioc_notice(mrioc, "Device %s was under process before the reset and\n",
+	    (device_add ? "addition" : "removal"));
+	ioc_notice(mrioc, "completed after reset, verify whether the exposed devices\n");
+	ioc_notice(mrioc, "are matched with attached devices for correctness\n");
+}
+
 /**
  * mpi3mr_remove_tgtdev_from_host - Remove dev from upper layers
  * @mrioc: Adapter instance reference
@@ -714,8 +758,17 @@ static void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (tgtdev->starget) {
+		if (mrioc->current_event)
+			mrioc->current_event->pending_at_sml = 1;
 		scsi_remove_target(&tgtdev->starget->dev);
 		tgtdev->host_exposed = 0;
+		if (mrioc->current_event) {
+			mrioc->current_event->pending_at_sml = 0;
+			if (mrioc->current_event->discard) {
+				mpi3mr_print_device_event_notice(mrioc, false);
+				return;
+			}
+		}
 	}
 	ioc_info(mrioc, "%s :Removed handle(0x%04x), wwid(0x%016llx)\n",
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
@@ -749,11 +802,20 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	}
 	if (!tgtdev->host_exposed && !mrioc->reset_in_progress) {
 		tgtdev->host_exposed = 1;
+		if (mrioc->current_event)
+			mrioc->current_event->pending_at_sml = 1;
 		scsi_scan_target(&mrioc->shost->shost_gendev, 0,
 		    tgtdev->perst_id,
 		    SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
 		if (!tgtdev->starget)
 			tgtdev->host_exposed = 0;
+		if (mrioc->current_event) {
+			mrioc->current_event->pending_at_sml = 0;
+			if (mrioc->current_event->discard) {
+				mpi3mr_print_device_event_notice(mrioc, true);
+				goto out;
+			}
+		}
 	}
 out:
 	if (tgtdev)
@@ -1193,6 +1255,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
 
 	for (i = 0; i < event_data->num_entries; i++) {
+		if (fwevt->discard)
+			return;
 		handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
@@ -1324,6 +1388,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
 
 	for (i = 0; i < event_data->num_entries; i++) {
+		if (fwevt->discard)
+			return;
 		handle =
 		    le16_to_cpu(event_data->port_entry[i].attached_dev_handle);
 		if (!handle)
@@ -1362,8 +1428,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mrioc->current_event = fwevt;
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
+	mrioc->current_event = fwevt;
 
 	if (mrioc->stop_drv_processing)
 		goto out;
-- 
2.27.0


--00000000000099ee8f05d7a6da17
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJp/7/GvFu34J16tBYkq
m29rkfV7G6zB5kT7DWWjTwUbMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDIxMDA5NDgzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQACnFjC7mD7/HQuhd4DFnWiaqlXNRQ0zp36jFUJ
d4lVF4plmxDtZtXq4FDjEFR8SLlv/gfznpEAkMeBFJF4hIsIqWcjZ21ZhPhkErkmnpsWWvFhfHol
1JoQ7RGCOLzFi3wN/FAH0CwyDKCLhux+9HvQkWTv1yv2wdxiElfJZ6E4GOg+lAl18AkB/LsZo4zS
3NIjKVM7eoqYeKzWg7vGtD6rqGnUr44YKk5ZjZQ721mpl7TORWL+gV2tjH0ql5kH6bXBESSL1yNr
Rp2UJWcE7YSy9+9yAT80VBHSsgOkrR8CGGaH4ESW+GxY7Az/3XdROlr0PiLAXqp9pKMNhKTJzoVp
--00000000000099ee8f05d7a6da17--
