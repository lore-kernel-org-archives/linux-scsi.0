Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9397C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5B82310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgLVKN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgLVKN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:27 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9766C061285
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:33 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id c22so8055569pgg.13
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xnK019hPA7fxwYWeNPLv+99uZBVpmhva9PEdJGbceak=;
        b=bO4YC7fl/qbvtV1J4Wd6qf9p9wqwRoc0/RtdHkGnLagTmCVq0vU1oCWQ866PfOlnW5
         ah23SfhinXaQ6d6ibxyhzcsSKzp9sqNFuY1oaUbvep2UQg6WvFcMknsVn/OCIwXTqlQ9
         7hCGx+1GNaVC7BE3eoec4A9SuObOf/tCnm608=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=xnK019hPA7fxwYWeNPLv+99uZBVpmhva9PEdJGbceak=;
        b=iODsbMbnPnb5B+HJNhwodJ6S7svnJDBf3BbsvesZmiMOeoHKYCDoWu9RKVjkBTrDYg
         wDFss36APFy4MKhpnNg9Md9jBkenm7JK/qlI79xUGM/86mz5BQWUhPw/LNVr7ubk5Z8V
         CDTNGc4mA+S9h7eGu6J9HfMXTFZULOvD9rzX+09m6NXeLqBl5pstQ6LGFHYPWeVHe3m1
         xQC7hUGiVcO4UtCgsCzOeMAY8PM7hd7EIemzhI4LY++QPqNNlZAxCjwyIFUEny1D8HEt
         1iDcZTza5y0IwKI4SFlLNKbdDR0hmTonsbNMB1RTCmKc5/WLnEPIfO0nyCg3xYxBRMAT
         T/2Q==
X-Gm-Message-State: AOAM5319R+xXgi17o/hZ7aglQ40Z6k0uy7AHuDg6thZxtf+i9PDChRzV
        izwBo+FctmjiIozwfGvbH7FVob3Xv3MaL3t7Kp3CTQCYn+y+y0Ahu2QKE6SKM+n5dheuDO3XaUm
        +ABiO8kFWYmOU3uxw16if9aWmwMtdYlnLMRsKoUepgxXnxouCM+OZjkPDqdjKyBlsKpUhvTt+2C
        yuJM/NXDTL
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJwi7ORFjcD6TehZ+bZPyOEM0Ub2caeAMS5+6XuZjk3vz3TIuNHigk8wHUAbA4F2s1tmCNKzow==
X-Received: by 2002:a62:844b:0:b029:19e:62a0:ca18 with SMTP id k72-20020a62844b0000b029019e62a0ca18mr19277916pfd.46.1608631952756;
        Tue, 22 Dec 2020 02:12:32 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:12:32 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 05/24] mpi3mr: add support of internal watchdog thread
Date:   Tue, 22 Dec 2020 15:41:37 +0530
Message-Id: <20201222101156.98308-6-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000026509705b70ad05d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000026509705b70ad05d
Content-Type: text/plain; charset="US-ASCII"

Watchdog thread is driver's internal thread which does few things like
detecting FW fault and reset the controller, Timestamp sync etc.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  11 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 125 ++++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c |   3 +
 3 files changed, 139 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index f23751e25d0f..0fa38036dcf3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -480,6 +480,10 @@ struct scmd_priv {
  * @sense_buf_q_dma: Sense buffer queue DMA address
  * @sbq_lock: Sense buffer queue lock
  * @sbq_host_index: Sense buffer queuehost index
+ * @watchdog_work_q_name: Fault watchdog worker thread name
+ * @watchdog_work_q: Fault watchdog worker thread
+ * @watchdog_work: Fault watchdog work
+ * @watchdog_lock: Fault watchdog lock
  * @is_driver_loading: Is driver still loading
  * @scan_started: Async scan started
  * @scan_failed: Asycn scan failed
@@ -493,6 +497,7 @@ struct scmd_priv {
  * @chain_buf_lock: Chain buffer list lock
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @diagsave_timeout: Diagnostic information save timeout
  * @logging_level: Controller debug logging level
  * @current_event: Firmware event currently in process
  * @driver_info: Driver, Kernel, OS information to firmware
@@ -574,6 +579,11 @@ struct mpi3mr_ioc {
 	spinlock_t sbq_lock;
 	u32 sbq_host_index;
 
+	char watchdog_work_q_name[20];
+	struct workqueue_struct *watchdog_work_q;
+	struct delayed_work watchdog_work;
+	spinlock_t watchdog_lock;
+
 	u8 is_driver_loading;
 	u8 scan_started;
 	u16 scan_failed;
@@ -591,6 +601,7 @@ struct mpi3mr_ioc {
 	u8 reset_in_progress;
 	u8 unrecoverable;
 
+	u16 diagsave_timeout;
 	int logging_level;
 
 	struct mpi3mr_fwevt *current_event;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index abdf8c653e6b..4f1524dcad4d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1480,6 +1480,129 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_watchdog_work - watchdog thread to monitor faults
+ * @work: work struct
+ *
+ * Watch dog work periodically executed (1 second interval) to
+ * monitor firmware fault and to issue periodic timer sync to
+ * the firmware.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_watchdog_work(struct work_struct *work)
+{
+	struct mpi3mr_ioc *mrioc =
+	    container_of(work, struct mpi3mr_ioc, watchdog_work.work);
+	unsigned long flags;
+	enum mpi3mr_iocstate ioc_state;
+	u32 fault, host_diagnostic;
+
+	/*Check for fault state every one second and issue Soft reset*/
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state == MRIOC_STATE_FAULT) {
+		fault = readl(&mrioc->sysif_regs->Fault) &
+		    MPI3_SYSIF_FAULT_CODE_MASK;
+		host_diagnostic = readl(&mrioc->sysif_regs->HostDiagnostic);
+		if (host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS) {
+			if (!mrioc->diagsave_timeout) {
+				mpi3mr_print_fault_info(mrioc);
+				ioc_warn(mrioc, "Diag save in progress\n");
+			}
+			if ((mrioc->diagsave_timeout++) <=
+			    MPI3_SYSIF_DIAG_SAVE_TIMEOUT)
+				goto schedule_work;
+		} else
+			mpi3mr_print_fault_info(mrioc);
+		mrioc->diagsave_timeout = 0;
+
+		if (fault == MPI3_SYSIF_FAULT_CODE_FACTORY_RESET) {
+			ioc_info(mrioc,
+			    "Factory Reset Fault occurred marking controller as unrecoverable"
+			    );
+			mrioc->unrecoverable = 1;
+			goto out;
+		}
+
+		if ((fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET)
+		    || (fault == MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS)
+		    || (mrioc->reset_in_progress))
+			goto out;
+		if (fault == MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET)
+			mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_CIACTIV_FAULT, 0);
+		else
+			mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_FAULT_WATCH, 0);
+	}
+
+schedule_work:
+	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
+	if (mrioc->watchdog_work_q)
+		queue_delayed_work(mrioc->watchdog_work_q,
+		    &mrioc->watchdog_work,
+		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
+	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
+out:
+	return;
+}
+
+/**
+ * mpi3mr_start_watchdog - Start watchdog
+ * @mrioc: Adapter instance reference
+ *
+ * Create and start the watchdog thread to monitor controller
+ * faults.
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc)
+{
+	if (mrioc->watchdog_work_q)
+		return;
+
+	INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
+	snprintf(mrioc->watchdog_work_q_name,
+	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
+	    mrioc->id);
+	mrioc->watchdog_work_q =
+	    create_singlethread_workqueue(mrioc->watchdog_work_q_name);
+	if (!mrioc->watchdog_work_q) {
+		ioc_err(mrioc, "%s: failed (line=%d)\n", __func__, __LINE__);
+		return;
+	}
+
+	if (mrioc->watchdog_work_q)
+		queue_delayed_work(mrioc->watchdog_work_q,
+		    &mrioc->watchdog_work,
+		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
+}
+
+/**
+ * mpi3mr_stop_watchdog - Stop watchdog
+ * @mrioc: Adapter instance reference
+ *
+ * Stop the watchdog thread created to monitor controller
+ * faults.
+ *
+ * Return: Nothing.
+ */
+void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc)
+{
+	unsigned long flags;
+	struct workqueue_struct *wq;
+
+	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
+	wq = mrioc->watchdog_work_q;
+	mrioc->watchdog_work_q = NULL;
+	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
+	if (wq) {
+		if (!cancel_delayed_work_sync(&mrioc->watchdog_work))
+			flush_workqueue(wq);
+		destroy_workqueue(wq);
+	}
+}
+
 
 /**
  * mpi3mr_setup_admin_qpair - Setup admin queue pair
@@ -2634,6 +2757,8 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
 {
 	enum mpi3mr_iocstate ioc_state;
 
+	mpi3mr_stop_watchdog(mrioc);
+
 	mpi3mr_ioc_disable_intr(mrioc);
 
 	ioc_state = mpi3mr_get_iocstate(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 01be5f337826..7b0d52481929 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -570,6 +570,7 @@ static int mpi3mr_scan_finished(struct Scsi_Host *shost,
 	if (mrioc->scan_started)
 		return 0;
 	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
+	mpi3mr_start_watchdog(mrioc);
 	mrioc->is_driver_loading = 0;
 
 	return 1;
@@ -856,9 +857,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->admin_req_lock);
 	spin_lock_init(&mrioc->reply_free_queue_lock);
 	spin_lock_init(&mrioc->sbq_lock);
+	spin_lock_init(&mrioc->watchdog_lock);
 	spin_lock_init(&mrioc->chain_buf_lock);
 
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
+
 	if (pdev->revision)
 		mrioc->enable_segqueue = true;
 
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--00000000000026509705b70ad05d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgMreoQRB7
RXbRXM+PX55vNWOD9Bzo/OWulNh5SV4Ih1QwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMjMzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIRi09ZEFzHEE4yyrjP+wBYeBDes
DJFy2tIb8Ws7zG3yCvoLpqIanixDVOBa6nDqpGEq1NUZ+1rWKiMoj4M/gdulZ9DUFfxM6x//Kbc3
d5u93l92KwrI9DvkQXoRvBdBVcAD/ofhkmqvsSDFlHhedzqS+H5XSUglaDyQUIr3EMje3YDUF17G
2NPyAmj+DLInD2fyWdXpsNWYmeY9zSEhjNYs/ojrBDWVXgGJLuKr2F/PHcloMH1rL/5BdumFyuHq
UuuoyiKZCDGVwCiT859HLyGSYEoi/nsLB7djCJB5h8vv656AmTFe+Yfikx9RR1RSW61oe3oNRr+s
w+8eMtpPeGo=
--00000000000026509705b70ad05d--
