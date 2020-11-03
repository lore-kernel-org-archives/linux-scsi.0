Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49478C55179
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D6122243
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SQ8vUoLJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgKCOMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbgKCOMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 09:12:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61949C0613D1
        for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2020 06:12:44 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 133so14287638pfx.11
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2020 06:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6AvKXyoKTUNec8TvllCUGoK9INwpjYCVoktaScqkOYE=;
        b=SQ8vUoLJqrTEXMv6XkpPChujVHO833dQ83pw5qS5dkaRJjZUUpZaKzy3CYsDHHHml+
         IVfWhxMSHW4GOFJ5AwXYirR4qiZMmXhsvsVNCp7vpZ8TF+mEonTP84bC12GHewo/zqgu
         kVHqgM3c4zLcb9XFxQQNbdrkwhdC4C1mXDePc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6AvKXyoKTUNec8TvllCUGoK9INwpjYCVoktaScqkOYE=;
        b=uQtlNLVLr+g7gBwZ9/FTYR9ZcgsaaSkmF4JnZk/EZ3QO5YBfvZhRTUo0MfJpGpDq0L
         R84jgzEDNQFoVRwOTrfR9xf5gtY2NcwhwWFQtKYHU5dQrN68Ed/meyCk/RjqXX0C6Suc
         NvmoEN3HT8Yc89Tib1g2zQcc0diKrha6ZXHnaZjGqeBSdFTdcEoV9U8RGeNtCUOwMAji
         XrCH/l00fA+rEq8iqnzd29nrxO6+ZVh8FEzaaDvLWYIOiwT9HXsxxT052RsfpLNAYUww
         6Ioz5PxPUbgkhoIVeZyIBl4EQIfsqSV3UWDXQZpeAIg1HAvavB0kNNkO4YZezB5UxuSm
         8mHQ==
X-Gm-Message-State: AOAM533Zex0gZa1MoMpTTtjHY1Qr8QBByzt6eAVU7fc1Uq5Q3M7eaLZw
        GeaIq7Xfivey/JqvXou6ohPhonr8gRlTgd6r
X-Google-Smtp-Source: ABdhPJyZHlBpz4CBZHF8l8E5YLjo2dh50SAF3LTQF2iFDpt8EdscHQxe72/F/801wT5u5SX7hdWo9w==
X-Received: by 2002:a17:90b:3505:: with SMTP id ls5mr3896677pjb.134.1604412763814;
        Tue, 03 Nov 2020 06:12:43 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id t19sm3596691pgv.37.2020.11.03.06.12.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 06:12:43 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v3 16/19] lpfc: vmid: Timeout implementation for vmid
Date:   Tue,  3 Nov 2020 12:48:20 +0530
Message-Id: <1604387903-20006-17-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604387903-20006-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604387903-20006-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e1708a05b33474e8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e1708a05b33474e8

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch implements the timeout functionality for the vmid. After the
set time period of inactivity, the vmid is deregistered from the switch.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 109 +++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    |  40 ++++++++++++
 2 files changed, 149 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 142a02114479..b20013866942 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -190,6 +190,115 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	return;
 }
 
+/**
+ * lpfc_check_inactive_vmid_one - VMID inactivity checker for a vport
+ * @vport: Pointer to vport context object.
+ *
+ * This function checks for idle vmid entries related to a particular vport. If
+ * found unused/idle, it frees them accordingly.
+ **/
+static void lpfc_check_inactive_vmid_one(struct lpfc_vport *vport)
+{
+	u16 i, keep;
+	u32 difftime = 0, r;
+	u64 *lta;
+	int cpu;
+
+	write_lock(&vport->vmid_lock);
+
+	if (!vport->cur_vmid_cnt)
+		goto out;
+
+	/* iterate through the table */
+	for (i = 0; i < LPFC_VMID_HASH_SIZE; ++i) {
+		if (vport->hash_table[i] && (vport->hash_table[i]->flag &
+					     LPFC_VMID_REGISTERED)) {
+			/* check if the particular vmid is in use */
+			/* for all available per cpu variable */
+			for_each_possible_cpu(cpu) {
+				/* if last access time is less than timeout */
+				lta = per_cpu_ptr(
+					vport->hash_table[i]->last_io_time,
+					cpu);
+				if (!lta)
+					continue;
+				difftime = (jiffies) - (*lta);
+				if ((vport->vmid_inactivity_timeout *
+				     JIFFIES_PER_HR) > difftime) {
+					keep = 1;
+					break;
+				}
+			}
+
+			/* if none of the cpus have been used by the vm, */
+			/*  remove the entry if already registered */
+			if (!keep) {
+				/* mark the entry for deregistration */
+				vport->hash_table[i]->flag =
+					LPFC_VMID_DE_REGISTER;
+				write_unlock(&vport->vmid_lock);
+				if (vport->vmid_priority_tagging)
+					r = lpfc_vmid_uvem(vport,
+							   vport->hash_table[i],
+							   false);
+				else
+					r = lpfc_vmid_cmd(vport,
+							  SLI_CTAS_DAPP_IDENT,
+							  vport->hash_table[i]);
+
+				/* decrement number of active vms and mark */
+				/* entry in slot as free */
+				write_lock(&vport->vmid_lock);
+				if (!r) {
+					struct lpfc_vmid *ht =
+							vport->hash_table[i];
+					vport->cur_vmid_cnt--;
+					ht->flag = LPFC_VMID_SLOT_FREE;
+					free_percpu(ht->last_io_time);
+					ht->last_io_time = NULL;
+					vport->hash_table[i] = NULL;
+				}
+			}
+		}
+		keep = 0;
+	}
+ out:
+	write_unlock(&vport->vmid_lock);
+}
+
+/**
+ * lpfc_check_inactive_vmid - VMID inactivity checker
+ * @phba: Pointer to hba context object.
+ *
+ * This function is called from the worker thread to determine if an entry in
+ * the vmid table can be released since there was no IO activity seen from that
+ * particular VM for the specified time. When this happens, the entry in the
+ * table is released and also the resources on the switch cleared.
+ **/
+
+void lpfc_check_inactive_vmid(struct lpfc_hba *phba)
+{
+	struct lpfc_vport *vport;
+	struct lpfc_vport **vports;
+	int i;
+
+	vports = lpfc_create_vport_work_array(phba);
+	if (!vports)
+		return;
+
+	for (i = 0; i <= phba->max_vports; i++) {
+		if ((!vports[i]) && (i == 0))
+			vport = phba->pport;
+		else
+			vport = vports[i];
+		if (!vport)
+			break;
+
+		lpfc_check_inactive_vmid_one(vport);
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
+}
+
 /**
  * lpfc_dev_loss_tmo_handler - Remote node devloss timeout handler
  * @ndlp: Pointer to remote node object.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 88777875f4b8..7e93049fba21 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4829,6 +4829,42 @@ lpfc_sli4_fcf_redisc_wait_tmo(struct timer_list *t)
 	lpfc_worker_wake_up(phba);
 }
 
+/**
+ * lpfc_vmid_poll - VMID timeout detection
+ * @ptr: Map to lpfc_hba data structure pointer.
+ *
+ * This routine is invoked when there is no IO on by a VM for the specified
+ * amount of time. When this situation is detected, the VMID has to be
+ * deregistered from the switch and all the local resources freed. The VMID
+ * will be reassigned to the VM once the IO begins.
+ **/
+static void
+lpfc_vmid_poll(struct timer_list *t)
+{
+	struct lpfc_hba *phba = from_timer(phba, t, inactive_vmid_poll);
+	u32 wake_up = 0;
+
+	/* check if there is a need to issue QFPA */
+	if (phba->pport->vmid_priority_tagging) {
+		wake_up = 1;
+		phba->pport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
+	}
+
+	/* Is the vmid inactivity timer enabled */
+	if (phba->pport->vmid_inactivity_timeout ||
+	    phba->pport->load_flag & FC_DEREGISTER_ALL_APP_ID) {
+		wake_up = 1;
+		phba->pport->work_port_events |= WORKER_CHECK_INACTIVE_VMID;
+	}
+
+	if (wake_up)
+		lpfc_worker_wake_up(phba);
+
+	/* restart the timer for the next iteration */
+	mod_timer(&phba->inactive_vmid_poll, jiffies + msecs_to_jiffies(1000 *
+							LPFC_VMID_TIMER));
+}
+
 /**
  * lpfc_sli4_parse_latt_fault - Parse sli4 link-attention link fault code
  * @phba: pointer to lpfc hba data structure.
@@ -6679,6 +6715,10 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_sli4_rb_alloc;
 	phba->hbqs[LPFC_ELS_HBQ].hbq_free_buffer = lpfc_sli4_rb_free;
 
+	/* for VMID idle timeout if VMID is enabled */
+	if (lpfc_is_vmid_enabled(phba))
+		timer_setup(&phba->inactive_vmid_poll, lpfc_vmid_poll, 0);
+
 	/*
 	 * Initialize the SLI Layer to run with lpfc SLI4 HBAs.
 	 */
-- 
2.26.2


--000000000000e1708a05b33474e8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCBByeCiaqbRgL4ZLg/HhvpmpjSFQzXbq7zP/uEnd6Fb/zAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDMxNDEyNDRaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAPEkaVpdSksQH/DGp
dqFcSver8R4n3bveG7cr7NyBViRGXvCoIbfWG+EuRLEQ3T/OoI64C2+bjJtyGALejdCeSxeSzXUg
2+trwwg3LyOzkpO0E7bfxCeJ4G/H0HrrgPqIhE/GYysd0l9laODytdyoXyK7wn8m5vfLAqT7u3Y8
0UIBv2xjikBqf0yZ1DX/HPZ0Ljpd6NMMqrRS1W8pbMeqtZSv4Ixrw/kdQ7dm4ACsaK1bJ5hgtnw0
sOUS+lN0/Rn3dPHxigpyxLPBc9JnXIxISIGy1+nUEHCaZIFYzH5rDzhjVro9Dk5L36/n+/9R8MDy
cNogh1d4/dPLpG78rTi9vQ==
--000000000000e1708a05b33474e8--
