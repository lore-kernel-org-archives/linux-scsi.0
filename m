Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B378C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 11:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC64206E5
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 11:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UP2peo19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgKILSN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgKILSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 06:18:11 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EEDC0613CF
        for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2020 03:18:11 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x23so4570663plr.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2020 03:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Rg7UO2XHBfNUlPyysjs2ZJcndOZj3DRkAvIUfLuBneA=;
        b=UP2peo19JDExclC8sNGHefJDzccSxQOcdgCcwAzDqlCPChgtHYS4PtbJb9wHsY8aaM
         EzmxCKNvIhRoW8caX+JjDrCBjotQ6R1taowYT34t6p7uBsGA/oKUY6ogQsJe2iWI/OkR
         6AZOoYjaLYr442IZmgQqP5FwKEHz68IIBDru8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Rg7UO2XHBfNUlPyysjs2ZJcndOZj3DRkAvIUfLuBneA=;
        b=YNVHdxGU4Vi7gwEYIc9zwLJlmt+lfS4qeZX9z/5DHvh2rMDC/Cp7Sftb0DS2D/Uj2O
         ygRNpA38vOInSeNQyLZsGkPC4oW0ZuEgqaTqAFDJ+MnpP+ek7Qs7VPoLm03c4cKVMIsE
         GNyaccq2lyji0T2DrtMJ5BOLK0HrywZ0bobpYa9YNuYmV3q13dCq3RdUUjM5M8GLdyQr
         xAl6pTdf9YtRn8IsS+Sm0LrTbq/dOLonYknQ+iIYSmYAD/GbuuEyDW+dySZ5lAi67Rz0
         DRXoZ0/++tMlVdAycanTVzrUFVI+M7lI6YeROhudRlClrqr13bx3rK9JN09KdrCZnpo1
         AtgQ==
X-Gm-Message-State: AOAM531JWlqVCHO/RvvmExcNGWsiK+sZhzcQNO6AwX2vfCNliByJc3uD
        zBhozNLnoKGp7qU4BcTrM4ExkA==
X-Google-Smtp-Source: ABdhPJyuzKRflM4/7Q8uhjIEnq1+23atRo9wADWO4qETAxLZDvBsPMvv94mmV9eXOiSCIc0WmCuQqA==
X-Received: by 2002:a17:902:c281:b029:d7:ce5d:6406 with SMTP id i1-20020a170902c281b02900d7ce5d6406mr8848345pld.35.1604920691188;
        Mon, 09 Nov 2020 03:18:11 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k9sm10889364pfp.68.2020.11.09.03.18.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 03:18:10 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v4 13/19] lpfc: vmid: Functions to manage vmids
Date:   Mon,  9 Nov 2020 09:53:59 +0530
Message-Id: <1604895845-2587-14-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b636fb05b3aab79b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b636fb05b3aab79b

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch contains the routines to save, retrieve and remove the vmids
from the data structure. A hash table is used to save the vmids and
the corresponding UUIDs associated with the application/VMs.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc_scsi.c | 139 ++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7bc1fd69b715..e5a1056cc575 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -28,6 +28,7 @@
 #include <asm/unaligned.h>
 #include <linux/t10-pi.h>
 #include <linux/crc-t10dif.h>
+#include <linux/blk-cgroup.h>
 #include <net/checksum.h>
 
 #include <scsi/scsi.h>
@@ -4485,6 +4486,144 @@ void lpfc_poll_timeout(struct timer_list *t)
 	}
 }
 
+/*
+ * lpfc_get_vmid_from_hastable - search the UUID in the hash table
+ * @vport: The virtual port for which this call is being executed.
+ * @hash: calculated hash value
+ * @buf: uuid associated with the VE
+ * Returns the vmid entry associated with the UUID
+ * Make sure to acquire the appropriate lock before invoking this routine.
+ */
+struct lpfc_vmid *lpfc_get_vmid_from_hastable(struct lpfc_vport *vport,
+					      u32 hash, u8 *buf)
+{
+	struct lpfc_vmid *vmp;
+	u16 count = 0;
+
+	while (count < LPFC_VMID_HASH_SIZE) {
+		vmp = vport->hash_table[hash];
+		if (vmp) {
+			if (strncmp(&vmp->host_vmid[0], buf, 16) == 0)
+				return vmp;
+		} else {
+			return NULL;
+		}
+		/* search the next available slot and continue till entry */
+		/* is found */
+		count++;
+		hash++;
+
+		/* or the end is reached */
+		if (hash == LPFC_VMID_HASH_SIZE)
+			hash = 0;
+	}
+	return NULL;
+}
+
+/*
+ * lpfc_put_vmid_from_hastable - put the VMID in the hash table
+ * @vport: The virtual port for which this call is being executed.
+ * @hash - calculated hash value
+ * @vmp: Pointer to a VMID entry representing a VM sending IO
+ *
+ * This routine will insert the newly acquired vmid entity in the hash table.
+ * Make sure to acquire the appropriate lock before invoking this routine.
+ */
+int
+lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
+			   struct lpfc_vmid *vmp)
+{
+	int count = 0;
+
+	while (count < LPFC_VMID_HASH_SIZE) {
+		if (!vport->hash_table[hash]) {
+			vport->hash_table[hash] = vmp;
+			vmp->hash_index = hash;
+			return 1;
+		}
+		/* if the slot is already occupied, a collision has occurred. */
+		/* Store in the next available slot */
+		count++;
+		hash++;
+		/* table is full */
+		if (hash == LPFC_VMID_HASH_SIZE)
+			hash = 0;
+	}
+	return 0;
+}
+
+/*
+ * lpfc_vmid_hash_fn- creates a hash value of the UUID
+ * @uuid: uuid associated with the VE
+ * @len: length of the UUID
+ * Returns the calculated hash value
+ */
+int lpfc_vmid_hash_fn(char *vmid, int len)
+{
+	int c;
+	int hash = 0;
+
+	if (len == 0)
+		return 0;
+	while (len--) {
+		c = *vmid++;
+		if (c >= 'A' && c <= 'Z')
+			c += 'a' - 'A';
+
+		hash = (hash + (c << LPFC_VMID_HASH_SHIFT) +
+			(c >> LPFC_VMID_HASH_SHIFT)) * 19;
+	}
+
+	return hash & LPFC_VMID_HASH_MASK;
+}
+
+/*
+ * lpfc_vmid_update_entry - update the vmid entry in the hash table
+ * @vport: The virtual port for which this call is being executed.
+ * @cmd: address of scsi cmmd descriptor
+ * @vmp: Pointer to a VMID entry representing a VM sending IO
+ * @tag: VMID tag
+ */
+void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
+				   *cmd, struct lpfc_vmid *vmp,
+				   union lpfc_vmid_io_tag *tag)
+{
+	u64 *lta;
+
+	if (vport->vmid_priority_tagging)
+		tag->cs_ctl_vmid = vmp->un.cs_ctl_vmid;
+	else
+		tag->app_id = vmp->un.app_id;
+
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		vmp->io_wr_cnt++;
+	else
+		vmp->io_rd_cnt++;
+
+	/* update the last access timestamp in the table */
+	lta = per_cpu_ptr(vmp->last_io_time, raw_smp_processor_id());
+	*lta = jiffies;
+}
+
+void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport, struct lpfc_vmid *vmid)
+{
+	u32 hash;
+	struct lpfc_vmid *pvmid;
+
+	if (vport->port_type == LPFC_PHYSICAL_PORT) {
+		vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
+	} else {
+		hash = lpfc_vmid_hash_fn(vmid->host_vmid, vmid->vmid_len);
+		pvmid =
+		    lpfc_get_vmid_from_hastable(vport->phba->pport, hash,
+						vmid->host_vmid);
+		if (!pvmid)
+			vmid->un.cs_ctl_vmid = pvmid->un.cs_ctl_vmid;
+		else
+			vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
+	}
+}
+
 /**
  * lpfc_queuecommand - scsi_host_template queuecommand entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
-- 
2.26.2


--000000000000b636fb05b3aab79b
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
BCBIndRVYTSvbjJxbXHRStU1YSg+41PXtvKNATHE++FL7DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDkxMTE4MTFaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAMbJAsvEQ4lIbphEH
+W/I7LedEVEQy4y4ejpIwQfyRGT5ZF9856A9mQ7jlNvIFTihKaFdYJE76N06FJJw8tGH+8gR2WXK
FRyqSh3m0F0S4IXcM7Hh4OJ5HeLCtjdWfjwesUNKnPHqEcJOjFQp9gyzuthdHY32MSehKNvIXaJ8
3ekvTVH1BmGQisLfOIUbk1CQXsPubmZnPyDuL4DHmEYA9qrnjiv4NcWGFvS/e1Di5hbUIMtUP0rM
TUno11pOyBc6ykozH1nn7Bfzg3y0hLHBHHR+7k2oyqDnuhZTodAuYGtInml7vdCGnuqT734Lz9Sy
lcYPLqXo5yNsUPGsUQRiqg==
--000000000000b636fb05b3aab79b--
