Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B756C299AAB
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957970; cv=none; b=Pt0gzVXSqVHWB6mB2TXHD3ONijufaQyakQoi9t9h/cCHINtrDybOjCp55TU74wz70Cw/UhckUkmYhbyN3aTU18KdzgfXQyL6M0sd5cFlbOdtDrtbdXDfMWNmVw6xIhusC/Ik17BOCz51a42Z9gGIHJT2bjZ4RsUPOMxO3ezTpZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957970; c=relaxed/simple;
	bh=ZybGZR7xa5+gKvsjLIcWeYScTY+06aMYTHnEWXbvm/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gvh9r0y8fW12jLKwNN2LvHpgkuAyXJ4N2t9V8E0Ldyp/AtvMzizxKfcZ+TzUvYGRFgpBZaiK9hj0QTXiHyjI/BtxKEC/3u+xbGYoLyMGF0eXKxtl9k9qPWNxdBcK6VHv6goM6pzaqF+s+pWN7e49Nob81N6WWfTLPsa19cyD3zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OV5Lyswn; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OV5Lyswn"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-765936cbdfeso41819166d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957967; x=1758562767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3p+mJyDodb5FCk1Ya4jVgosh1k5uDmVTZhtopNNIz0=;
        b=OV5LyswnbThdWiTl+OzegArNBv8tn4aSgLnFT8WuhQkerdDK6y3aX0AkP210AdS8eg
         3k3Nf3HPuLpQtTofcXwVYdTrugbRz1fTrGuKvM9AgCq+3YbQhErPVh4HcB7pRbGQBtOH
         5enRZHzaQyQXNFYyBupkM3wf89k5ELLPYuc1chP8IAhA9diH06awZW8st+cuZGSCRriu
         GCdad58GVyATtYivg0yQyL6qUyqnwqsWrWBayEzWYKlXRdKQ3hjXGMY2TxjWLOahylgF
         ZT/LVugVZjvOwvYuBRzvIKBaB1Jm47bCu6fmqfAaPodEr5pwl+BjePmr476RPs3NNd/B
         uxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957967; x=1758562767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3p+mJyDodb5FCk1Ya4jVgosh1k5uDmVTZhtopNNIz0=;
        b=KsM5OHyIBWq8dEd3UDkHSxI/75PC0k9Ujyv9dNG8kEMlBBZf4bJDPyzKl4db/N0cRf
         9Rj1EplPyULpEq1szyAK+6pGG9RxQL2Ayfwe6G8SA1WU9Y+/Gq1TNMvyeN2ki3qHey2e
         XXbOM1jZMQPHC+UjBeIuBGZoyUR4+7cDZoLrrHU36YBgCw3mGLaoqP4rOrwncHCcEUQW
         IE2sVuGnlycYnyajuGALTt3WkMVmnzWkJ68YAz3dkFT7Pv+t6HeBj//+T1iWx77V9PBq
         qHpA9WLqBEl2meFeyx88OUh/Arik88fbV6YC0xnwnNVRTkD22hNRf6A7F5tWxvuoc66z
         HP6g==
X-Gm-Message-State: AOJu0YxyCUv2kBvpqZ0F32vtHEnVYf+PUO4KnqMUZSk6yqqwnypGZWsh
	pADjX/aZ+fXJpEAkZ4SuYL+cRQKTRmq8CCazHaC3qMGiyhoX532RivpPAvv/wQ==
X-Gm-Gg: ASbGncsdxQftxpYUXWP9Qe1p4vMiGIC65N3scw5q1z2g9Nm+KrcQJmhAD1b9F2wlRXa
	eyCJBoq0g53EHLqZ2h4xBCrnZMdpq8hQXFekLAROxqENneJ2g5V9gON/P1GhwAw6NULsF+zjuVo
	2czm5As4XP6ybXykmP18N+4qLebkzJ5GyJwAnf4qIOGnEGrNOUDlX35LcRgoMS76AvzGjNA4Yaz
	EHjLL5eZiAkPbha4J1lT9In1hxzn3vm1JIdPIOk6QUcEch5oujtSuU/PZkZ1aF671AWDdQx3DFe
	TGCRROzDFvv5fIYrAFwSREEo82sufWTLsbrOSXgIgYSgIrM9W3UOdlRCeip3C/yr9xk9CkqN9U8
	TVndwm7nbca8EGuWyUhp67h5/nzd0kCnYWmiHHYlbPnK/2uLCmIcvJCg/idOk4iWpuuTzS6Bgf+
	ZGN0F1zqmWVSPBxZG2wK2pokEVmZ7k
X-Google-Smtp-Source: AGHT+IGW30LIyJfMLL2xtc1+JVVnnSmw7a2iCHlhniEuogH0pXV8N7aX0XSjelSbZNr4jEJnXcqZlw==
X-Received: by 2002:a05:6214:1c0f:b0:726:d08c:854 with SMTP id 6a1803df08f44-767c5064004mr164347316d6.61.1757957967240;
        Mon, 15 Sep 2025 10:39:27 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:27 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 10/14] lpfc: Use switch case statements in DIF debugfs handlers
Date: Mon, 15 Sep 2025 11:08:07 -0700
Message-Id: <20250915180811.137530-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the introduction of aux numbers for debugfs entries, there's no need
to use the if-else-if clause based on debugfs entry pointers.  Update both
the lpfc_debugfs_dif_err_read and lpfc_debugfs_dif_err_write routines to
use switch case based on aux instead.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/linux-fsdevel/20250702212917.GK3406663@ZenIV/
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 140 ++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_hw.h      |   1 +
 2 files changed, 83 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 7c4d7bb3a56f..691314c68b59 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2373,93 +2373,117 @@ lpfc_debugfs_dumpHostSlim_open(struct inode *inode, struct file *file)
 
 static ssize_t
 lpfc_debugfs_dif_err_read(struct file *file, char __user *buf,
-	size_t nbytes, loff_t *ppos)
+			  size_t nbytes, loff_t *ppos)
 {
 	struct lpfc_hba *phba = file->private_data;
 	int kind = debugfs_get_aux_num(file);
-	char cbuf[32];
-	uint64_t tmp = 0;
+	char cbuf[32] = {0};
 	int cnt = 0;
 
-	if (kind == writeGuard)
-		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wgrd_cnt);
-	else if (kind == writeApp)
-		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wapp_cnt);
-	else if (kind == writeRef)
-		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wref_cnt);
-	else if (kind == readGuard)
-		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rgrd_cnt);
-	else if (kind == readApp)
-		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rapp_cnt);
-	else if (kind == readRef)
-		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rref_cnt);
-	else if (kind == InjErrNPortID)
-		cnt = scnprintf(cbuf, 32, "0x%06x\n",
+	switch (kind) {
+	case writeGuard:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "%u\n",
+				phba->lpfc_injerr_wgrd_cnt);
+		break;
+	case writeApp:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "%u\n",
+				phba->lpfc_injerr_wapp_cnt);
+		break;
+	case writeRef:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "%u\n",
+				phba->lpfc_injerr_wref_cnt);
+		break;
+	case readGuard:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "%u\n",
+				phba->lpfc_injerr_rgrd_cnt);
+		break;
+	case readApp:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "%u\n",
+				phba->lpfc_injerr_rapp_cnt);
+		break;
+	case readRef:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "%u\n",
+				phba->lpfc_injerr_rref_cnt);
+		break;
+	case InjErrNPortID:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "0x%06x\n",
 				phba->lpfc_injerr_nportid);
-	else if (kind == InjErrWWPN) {
-		memcpy(&tmp, &phba->lpfc_injerr_wwpn, sizeof(struct lpfc_name));
-		tmp = cpu_to_be64(tmp);
-		cnt = scnprintf(cbuf, 32, "0x%016llx\n", tmp);
-	} else if (kind == InjErrLBA) {
-		if (phba->lpfc_injerr_lba == (sector_t)(-1))
-			cnt = scnprintf(cbuf, 32, "off\n");
+		break;
+	case InjErrWWPN:
+		cnt = scnprintf(cbuf, sizeof(cbuf), "0x%016llx\n",
+				be64_to_cpu(phba->lpfc_injerr_wwpn.u.wwn_be));
+		break;
+	case InjErrLBA:
+		if (phba->lpfc_injerr_lba == LPFC_INJERR_LBA_OFF)
+			cnt = scnprintf(cbuf, sizeof(cbuf), "off\n");
 		else
-			cnt = scnprintf(cbuf, 32, "0x%llx\n",
-				 (uint64_t) phba->lpfc_injerr_lba);
-	} else
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			 "0547 Unknown debugfs error injection entry\n");
+			cnt = scnprintf(cbuf, sizeof(cbuf), "0x%llx\n",
+					(uint64_t)phba->lpfc_injerr_lba);
+		break;
+	default:
+		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
+			     "0547 Unknown debugfs error injection entry\n");
+		break;
+	}
 
 	return simple_read_from_buffer(buf, nbytes, ppos, &cbuf, cnt);
 }
 
 static ssize_t
 lpfc_debugfs_dif_err_write(struct file *file, const char __user *buf,
-	size_t nbytes, loff_t *ppos)
+			   size_t nbytes, loff_t *ppos)
 {
 	struct lpfc_hba *phba = file->private_data;
 	int kind = debugfs_get_aux_num(file);
-	char dstbuf[33];
-	uint64_t tmp = 0;
-	int size;
+	char dstbuf[33] = {0};
+	unsigned long long tmp;
+	unsigned long size;
 
-	memset(dstbuf, 0, 33);
-	size = (nbytes < 32) ? nbytes : 32;
+	size = (nbytes < (sizeof(dstbuf) - 1)) ? nbytes : (sizeof(dstbuf) - 1);
 	if (copy_from_user(dstbuf, buf, size))
 		return -EFAULT;
 
-	if (kind == InjErrLBA) {
-		if ((dstbuf[0] == 'o') && (dstbuf[1] == 'f') &&
-		    (dstbuf[2] == 'f'))
-			tmp = (uint64_t)(-1);
+	if (kstrtoull(dstbuf, 0, &tmp)) {
+		if (kind != InjErrLBA || !strstr(dstbuf, "off"))
+			return -EINVAL;
 	}
 
-	if ((tmp == 0) && (kstrtoull(dstbuf, 0, &tmp)))
-		return -EINVAL;
-
-	if (kind == writeGuard)
+	switch (kind) {
+	case writeGuard:
 		phba->lpfc_injerr_wgrd_cnt = (uint32_t)tmp;
-	else if (kind == writeApp)
+		break;
+	case writeApp:
 		phba->lpfc_injerr_wapp_cnt = (uint32_t)tmp;
-	else if (kind == writeRef)
+		break;
+	case writeRef:
 		phba->lpfc_injerr_wref_cnt = (uint32_t)tmp;
-	else if (kind == readGuard)
+		break;
+	case readGuard:
 		phba->lpfc_injerr_rgrd_cnt = (uint32_t)tmp;
-	else if (kind == readApp)
+		break;
+	case readApp:
 		phba->lpfc_injerr_rapp_cnt = (uint32_t)tmp;
-	else if (kind == readRef)
+		break;
+	case readRef:
 		phba->lpfc_injerr_rref_cnt = (uint32_t)tmp;
-	else if (kind == InjErrLBA)
-		phba->lpfc_injerr_lba = (sector_t)tmp;
-	else if (kind == InjErrNPortID)
+		break;
+	case InjErrLBA:
+		if (strstr(dstbuf, "off"))
+			phba->lpfc_injerr_lba = LPFC_INJERR_LBA_OFF;
+		else
+			phba->lpfc_injerr_lba = (sector_t)tmp;
+		break;
+	case InjErrNPortID:
 		phba->lpfc_injerr_nportid = (uint32_t)(tmp & Mask_DID);
-	else if (kind == InjErrWWPN) {
-		tmp = cpu_to_be64(tmp);
-		memcpy(&phba->lpfc_injerr_wwpn, &tmp, sizeof(struct lpfc_name));
-	} else
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			 "0548 Unknown debugfs error injection entry\n");
-
+		break;
+	case InjErrWWPN:
+		phba->lpfc_injerr_wwpn.u.wwn_be = cpu_to_be64(tmp);
+		break;
+	default:
+		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
+			     "0548 Unknown debugfs error injection entry\n");
+		break;
+	}
 	return nbytes;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 32298285ea5e..b287d39ad033 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -366,6 +366,7 @@ struct lpfc_name {
 		} s;
 		uint8_t wwn[8];
 		uint64_t name __packed __aligned(4);
+		__be64 wwn_be __packed __aligned(4);
 	} u;
 };
 
-- 
2.38.0

