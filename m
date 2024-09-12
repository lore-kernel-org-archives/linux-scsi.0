Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7502C80
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182597; cv=none; b=ELidl/SGOKKyZ9WQMXaBJZPsmQkdh/CxPAtBXQ++9wZ6j45Gc0LJudKRa9w86+rp8FX7zuC+6NoZfFK+X0wdpi0VN7IR2Kx6OgDHF/t7evMk8KL9L/pcuhq5BdFhZRZnwZZRwxHqeg/OzTNlSYflTVZIxSjRudlXT4rgenFAkAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182597; c=relaxed/simple;
	bh=TNjR3OPytMXT/bYUnKn1u8RQyXcTcS9fx5ulmrohPHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=li/C8DwJxFwBea/QkVBkWzYn+ufBR6p9A3uZC+dfUDhj5O1fhXoP4a3EeXca7YiKHEYAdY6q0ckoFDzEAUWaLB1PGlcVU17qDn7gMEU8VxQxvvC0ju9msSHPC1SH1ymL5dITnR2rm1yh9ASDfSrTqvgLFAJsS/WNtGgai1jB/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UGMI1tF/; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UGMI1tF/"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6c34dd6c21aso10902526d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182595; x=1726787395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFI1DnonW2Yu3pi8vhiZeBpNucvdRqm5cKpMYKYAcRw=;
        b=UGMI1tF/2KmLqKJ9f9oNdl9VVXCASFFS4yBSJUNUV6Qn0l7GIQaDi7VkBFoycurSJU
         TwKr3iS8zIbcxmWVU+8gj5uOcUfUHmGAwQN/Uon36Z1W+pyCAayYsvrWUuqZP+H7MDrU
         3WoooBu/f+bfHnPaxlJdIVzIsA4xPuof1naL4Gh4Ux1LwniUv/jboSMevfcQCQon3NeO
         1ajU1uWAsmonuZmRTuSCNKhBvQhfRhKh32+LiG32PrtJxJUxwdcyECvC5iRNCICNRwY7
         QQGr6YfYs1JU7IpaZt1/e17TwZW/hfGm57MGUsFd3CfsVs5WIkeXT9Zl+AEz357Jy6CN
         S3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182595; x=1726787395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VFI1DnonW2Yu3pi8vhiZeBpNucvdRqm5cKpMYKYAcRw=;
        b=PA7/Ih2M24hitrTMv514tRLKeYiB0hHm6BiO9Wgp04fvLXdQfQQIe+jwUms4O28ZpX
         p7vntuQ5NnFoWcg34EX2KW5HfC3sa0gmW0MH6dRPHRffvsBih2QOWQ9uwFU7jfPzMCdH
         Uf0etYZ322QnFpNU0LmRlgIeWEYyRY+pdLqGsrPp3DH90mlLxSkU2oTlWPqWyAIMYp1t
         XVVSzaqQJtTpOpkR/mfXX7Ecc5wwjX88Qw7Cb8lamG4Xr6wv+BYz/NlliRa5nAAVtAnT
         XAK9w2aUJV4pANls7X8kWo6ZFCzE2SFx5Tt+oR3TOg5c5OVFCXY87bI+g/EqQDEEH8ez
         KVXA==
X-Gm-Message-State: AOJu0YyW+gUVCeBarGO/QfWzikIcQJqt6qsBPaFJTPwjQWWDu2l/LUbj
	5GGxyw5h+peLz73tUr+/H6PxCgiqDmKq1vLG4wGqOcaIVI4/4jiiBVvG2g==
X-Google-Smtp-Source: AGHT+IF/iNzQlc2JWoSkv5dZ2d2A22hw9uVJI9FwpWC0m0W6mFFGE6mv6QaPRwfuDN4a6NVbx+E39g==
X-Received: by 2002:a05:6214:2c03:b0:6c5:2747:f458 with SMTP id 6a1803df08f44-6c57351a6d8mr67608106d6.14.1726182594627;
        Thu, 12 Sep 2024 16:09:54 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.09.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:09:54 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/8] lpfc: Update phba link state conditional before sending CMF_SYNC_WQE
Date: Thu, 12 Sep 2024 16:24:41 -0700
Message-Id: <20240912232447.45607-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's possible for the driver to send a CMF_SYNC_WQE to nonresponsive
firmware during reset of the adapter.  The phba link_state conditional
check is currently a strict == LPFC_LINK_DOWN, which does not cover
initialization states before reaching the LPFC_LINK_UP state.

Update the phba->link_state conditional to < LPFC_LINK_UP so that all
initialization states are covered before allowing sending CMF_SYNC_WQE.

Update taking of the hbalock to be during this link_state check as well.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 332b8d2348e9..bb5fd3322273 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1940,12 +1940,15 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	atot = atomic_xchg(&phba->cgn_sync_alarm_cnt, 0);
 	wtot = atomic_xchg(&phba->cgn_sync_warn_cnt, 0);
 
+	spin_lock_irqsave(&phba->hbalock, iflags);
+
 	/* ONLY Managed mode will send the CMF_SYNC_WQE to the HBA */
 	if (phba->cmf_active_mode != LPFC_CFG_MANAGED ||
-	    phba->link_state == LPFC_LINK_DOWN)
-		return 0;
+	    phba->link_state < LPFC_LINK_UP) {
+		ret_val = 0;
+		goto out_unlock;
+	}
 
-	spin_lock_irqsave(&phba->hbalock, iflags);
 	sync_buf = __lpfc_sli_get_iocbq(phba);
 	if (!sync_buf) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-- 
2.38.0

