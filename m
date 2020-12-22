Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6991EC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 07:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7FF2313C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 07:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgLVHGh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 02:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgLVHGe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 02:06:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199A3C0619DB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 23:06:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v1so829873pjr.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 23:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xgnYYVJa7rp7arYqjFKdDojkeAnpQdzqh+8Eql/wnxY=;
        b=Zbju3gSGEgN2i2dAlFfuELFTnnSbtDOjRXfMFUJOJ7fuB9/cK+eZjyxbhUJj29pcEg
         U4AjB/AFonzakJgU6XhRmoGZcZKGRGTuDHBuS3SfEONuL2gtM8fVFBtYXJ7lmYDmhx/C
         ZUFzKGAW0x7TcfyujOioI/x0ODtI6GFPOk2C8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=xgnYYVJa7rp7arYqjFKdDojkeAnpQdzqh+8Eql/wnxY=;
        b=D5WTwJ43ldtIoW0k8An/p4Z5Oa7QXFKJbkrGc38Sp5/k1pXiP77L8Dg4dYRcmOrcaM
         a1d4G+cbJG243mwRgqrDV26GbyrSj8la6RBs6FjjEwdDzeyyM5CSBgquyHYZarkBjgPi
         Us5y99WYRZ2XjQRAjQOpdqO+nnPulIu+dicFbD9fi1IbcRlfccPEwi1SVcrJUEAmelCV
         RtNlnJ1D2OYXgd1e+4srf2E/QeVr/GpMF+I69chxQEFVJAgpazUiQu/fPWcsOb+Zd5OY
         CvOqDQpu4V7VD4hh4mljHeJqDJwkrNq49Nz5kmTEOvOVmZ//me6rsMH0YiIAhB62WDiL
         Acwg==
MIME-Version: 1.0
X-Gm-Message-State: AOAM533rBw/ZlyrbJBa+UKbTa2qe8/aIUANyyjq5SpG4cq2OeJdwrdAY
        kgJZJtypw66XD9IEbJRN47AcODhaEQsad8TzRSlt2vD+DYcsj6Xokaa0zJHkH/xY0YQ8+fctCpL
        2aPD97hz3nq7h
X-Google-Smtp-Source: ABdhPJwn8fOEvoeSST86ryY0HuqQMoIh26d244uWPNq1uTeAJVsJ+/W/CpD7x5N+6pQoTnFuYGHswg==
X-Received: by 2002:a17:90b:1983:: with SMTP id mv3mr21441254pjb.211.1608620761417;
        Mon, 21 Dec 2020 23:06:01 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id t9sm12466082pgh.41.2020.12.21.23.05.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 23:06:00 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v6 15/16] lpfc: vmid: Introducing vmid in io path.
Date:   Tue, 22 Dec 2020 05:41:57 +0530
Message-Id: <1608595918-21954-16-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000017574805b70835eb"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000017574805b70835eb
Content-Type: text/plain; charset="US-ASCII"

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

The patch introduces the vmid in the io path. It checks if the vmid is
enabled and if io belongs to a vm or not and acts accordingly. Other
supporing APIs are also included in the patch.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v6:
No change

v5:
No change

v4:
No change

v3:
Replaced blkcg_get_app_identifier with blkcg_get_fc_appid

v2:
Ported the patch on top of 5.10/scsi-queue
Added a fix for issuing QFPA command which was not included in the
last submit
---
 drivers/scsi/lpfc/lpfc_scsi.c | 165 ++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 53baee21e0f9..21f151492a18 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5279,6 +5279,151 @@ static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
 	}
 }
 
+/*
+ * lpfc_vmid_get_appid- get the vmid associated with the uuid
+ * @vport: The virtual port for which this call is being executed.
+ * @uuid: uuid associated with the VE
+ * @cmd: address of scsi cmmd descriptor
+ * @tag: VMID tag
+ * Returns status of the function
+ */
+static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
+			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag)
+{
+	struct lpfc_vmid *vmp = NULL;
+	int hash, len, rc = 1, i;
+	u8 pending = 0;
+
+	/* check if QFPA is complete */
+	if (lpfc_vmid_is_type_priority_tag(vport) && !(vport->vmid_flag &
+	      LPFC_VMID_QFPA_CMPL)) {
+		vport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
+		return FAILURE;
+	}
+
+	/* search if the uuid has already been mapped to the vmid */
+	len = strlen(uuid);
+	hash = lpfc_vmid_hash_fn(uuid, len);
+
+	/* search for the VMID in the table */
+	read_lock(&vport->vmid_lock);
+	vmp = lpfc_get_vmid_from_hastable(vport, hash, uuid);
+	read_unlock(&vport->vmid_lock);
+
+	/* if found, check if its already registered  */
+	if (vmp  && vmp->flag & LPFC_VMID_REGISTERED) {
+		lpfc_vmid_update_entry(vport, cmd, vmp, tag);
+		rc = 0;
+	} else if (vmp && (vmp->flag & LPFC_VMID_REQ_REGISTER ||
+			   vmp->flag & LPFC_VMID_DE_REGISTER)) {
+		/* else if register or dereg request has already been sent */
+		/* Hence vmid tag will not be added for this IO */
+		rc = 1;
+	} else {
+		/* else, start the process to obtain one as per the */
+		/* switch connected */
+		write_lock(&vport->vmid_lock);
+		vmp = lpfc_get_vmid_from_hastable(vport, hash, uuid);
+
+		/* while the read lock was released, in case the entry was */
+		/* added by other context or is in process of being added */
+		if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
+			lpfc_vmid_update_entry(vport, cmd, vmp, tag);
+			write_unlock(&vport->vmid_lock);
+			return 0;
+		} else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
+			write_unlock(&vport->vmid_lock);
+			return FAILURE;
+		}
+
+		/* else search and allocate a free slot in the hash table */
+		if (vport->cur_vmid_cnt < vport->max_vmid) {
+			for (i = 0; i < vport->max_vmid; ++i) {
+				vmp = vport->vmid + i;
+				if (vmp->flag == LPFC_VMID_SLOT_FREE) {
+					vmp = vport->vmid + i;
+					break;
+				}
+			}
+		} else {
+			write_unlock(&vport->vmid_lock);
+			return FAILURE;
+		}
+
+		if (vmp && (vmp->flag == LPFC_VMID_SLOT_FREE)) {
+			vmp->vmid_len = len;
+
+			/* Add the vmid and register  */
+			memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
+			vmp->io_rd_cnt = 0;
+			vmp->io_wr_cnt = 0;
+			vmp->flag = LPFC_VMID_SLOT_USED;
+			lpfc_put_vmid_in_hashtable(vport, hash, vmp);
+
+			vmp->delete_inactive =
+			    vport->vmid_inactivity_timeout ? 1 : 0;
+
+			/* if type priority tag, get next available vmid */
+			if (lpfc_vmid_is_type_priority_tag(vport))
+				lpfc_vmid_assign_cs_ctl(vport, vmp);
+
+			/* allocate the per cpu variable for holding */
+			/* the last access time stamp only if vmid is enabled */
+			if (!vmp->last_io_time)
+				vmp->last_io_time =
+				    __alloc_percpu(sizeof(u64),
+						   __alignof__(struct
+							       lpfc_vmid));
+
+			/* registration pending */
+			pending = 1;
+			rc = 1;
+		}
+		write_unlock(&vport->vmid_lock);
+
+		/* complete transaction with switch */
+		if (pending) {
+			if (lpfc_vmid_is_type_priority_tag(vport))
+				rc = lpfc_vmid_uvem(vport, vmp, true);
+			else
+				rc = lpfc_vmid_cmd(vport,
+						   SLI_CTAS_RAPP_IDENT,
+						   vmp);
+			if (!rc) {
+				write_lock(&vport->vmid_lock);
+				vport->cur_vmid_cnt++;
+				vmp->flag |= LPFC_VMID_REQ_REGISTER;
+				write_unlock(&vport->vmid_lock);
+			}
+		}
+
+		/* finally, enable the idle timer once */
+		if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
+			mod_timer(&vport->phba->inactive_vmid_poll,
+				  jiffies +
+				  msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
+			vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
+		}
+	}
+	return rc;
+}
+
+/*
+ * lpfc_is_command_vm_io - get the uuid from blk cgroup
+ * @cmd:Pointer to scsi_cmnd data structure
+ * Returns uuid if present if not null
+ */
+static char *lpfc_is_command_vm_io(struct scsi_cmnd *cmd)
+{
+	char *uuid = NULL;
+
+	if (cmd->request) {
+		if (cmd->request->bio)
+			uuid = blkcg_get_fc_appid(cmd->request->bio);
+	}
+	return uuid;
+}
+
 /**
  * lpfc_queuecommand - scsi_host_template queuecommand entry point
  * @shost: kernel scsi host pointer.
@@ -5304,6 +5449,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	int err, idx;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0L;
+	u8 *uuid = NULL;
 
 	if (phba->ktime_on)
 		start = ktime_get_ns();
@@ -5431,6 +5577,25 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	}
 
 
+	/* check the necessary and sufficient condition to support VMID */
+	if (lpfc_is_vmid_enabled(phba) &&
+	    (ndlp->vmid_support ||
+	     phba->pport->vmid_priority_tagging ==
+	     LPFC_VMID_PRIO_TAG_ALL_TARGETS)) {
+		/* is the IO generated by a VM, get the associated virtual */
+		/* entity id */
+		uuid = lpfc_is_command_vm_io(cmnd);
+
+		if (uuid) {
+			err = lpfc_vmid_get_appid(vport, uuid, cmnd,
+				(union lpfc_vmid_io_tag *)
+					&lpfc_cmd->cur_iocbq.vmid_tag);
+			if (!err)
+				lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_VMID;
+		}
+	}
+
+	atomic_inc(&ndlp->cmd_pending);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
 		this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
-- 
2.26.2


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

--00000000000017574805b70835eb
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
BCAKEdvANalp605+hIMQ4R8+oKU7LiO4DSwRbPTy+T66ijAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEyMjIwNzA2MDFaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEACd6V/cYruQ51J8dp
SjCERoDmkpfpvSHQdKHyxjKrCAhYJbGyQ59ToG63rZcvCDlJIb2tc+jYqTb/X7F9k9UjkQ0DR99Y
uOFlnb5cvazlQA/0mmbs7OwvLSQz4L55jBsoIDYyLncNtaNISsvk6181mdfT1iSqK5G91F1aJcqM
UHKrd82cZvGfkAD0RkSBO6rNJTc2A7bFqj2ztZFLCtmaKIGGqHnRi6exAhQlfpMH0unSDrHzYTiA
/c/Cfr8H4I8ww7L0O3jwOgx5BAZz3RzGiVJFRXi/0Br3WmL+aA+ntcYMTiuxK9KqwyEv/2vLl9Xo
rE7zMjMkz/71S4Nc6nNLDw==
--00000000000017574805b70835eb--
