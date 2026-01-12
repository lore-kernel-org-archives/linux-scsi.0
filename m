Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB1230F959
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205831; cv=none; b=nnuDjeJh0G85mmiFh6FYu8pw4NQHYV3s+NlxBeHEo1v/6kIYo15RN8rXcoOKghAbrVwy5Eg9CH8qZGJPM4EnvWxFhufjGPpZpZhoxakAokwivCrJSrToCRiUhhgfMQ+frSEKdfKky/izBJNWOsyl23hRiKge/pAYXFdin97FVD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205831; c=relaxed/simple;
	bh=Mxx8fr7dq4SvfKZLNOysdP3IZAmvOgcJVxnJjaBHzg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw0rxIviz+iIINb+WtGEPTULGSCv/GT/UHWlpLX1O+pciXHsmoSrZMWYr8mzwIu+7RF3veGQNvMxiyp4ueJiYpSVqk4ygxeuNGtYcVTrh29XYRWVyhu33hDWJ2W5r8FlHCrC1gUadL8p+utiWpBHYgIX9Mx3dWVuna/qUTTYo8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NHfwFQXb; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NHfwFQXb"
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-88fdac49a85so66391696d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205829; x=1768810629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rzljhpYNpTIoKySJ/ODiIvsRPaEcWnBviJG+IPXB6k4=;
        b=SnPILdrASGnbgFSLn2ItpRbooKX25WLTZ/s3tp/jtg8l9DsQwmuEYyK/HiW6GUpC9Y
         PEMUFP+AoUrGXba/WvbQRJiVMB8nwoNKUCT95/mDKsEb19G+9F57QMyAPbrTG8iVix2g
         JfovrLPdFdn3G8h+PAa1sAlvRHBQHu8IA2/pHEhslySik1chaX2DrGbzOjLJpDqVdp+i
         FRG4Lowzw9mqNSLQsCYXdf5eOQWpX2dLpgUbXgCs+KdBImTfcMvn6PZrb0ukcNM9p5gQ
         swRG8TKShpLP3u1d12pUwbgOqUIGtrAEpNZWXAwe7NqSXO8r8Novxeo2v3BX5fY/e9po
         S7lw==
X-Gm-Message-State: AOJu0Yw92fMRK/JU21sQqRcyRadkkiFa7lsGWbVgJKmfq7Ndc93Gquij
	MqKGEIkUuUizQrduAVlcGlMIqFuSplmJbw4c6vUr8K6fisc+OssM709TmDBB2TY5bNuQcvCqSdJ
	XReroWlo84cQtxuWBB/JEfHWuvuPU3dkvYtyTjKfWl56W4HR0MEnDzHDOEBPCnfpE8g0dB4NanQ
	zkiESrWtrM69h/4BUBa7AYl/7Q1xbsFTMlfI5r5/yYT0Y7iWf6qS0tGSOIzmDpJx4/W486u30AB
	KAhaVutRSD4o34E
X-Gm-Gg: AY/fxX6wkP8ZQiajMdF5EgjJ5VY2l5mlAmwulDr8Z0n3k9y8Q3zMIj18ly1erlJ58Gz
	6G5yf5qhbGTKqLvc/KlqMYhtVItg3Jq9PBzlkv6Ad2nSJPsNKAE2PoD3jd9lE6E5HncupPdopi0
	rYo2GYghxB7R+f9qQSFEGGn3rcOhpkhbqvaH6xsLUNlDteUO+XTJERHyKSxgK8tQqnpXMtUG1nq
	iXbuMJ9/DpwYbAeagSdUIKMsnRTVuHXI2bSgmmafsc3yIU68P84qIwkiG1pVjdEtxEQ21kup/zD
	hwHgrrPftLf3YyijbsT4DuqlAyoALzdpr6WoXgNHBk+DOFnj5DeU5MYSbCNq+qBZF9if3UCWn3o
	x1Wy4kDCXua089BDvg11wW44VC4OjikR1UcVMT1Zs9YGKe35LxVHlJzpXmvX0+thIgp8UxqCujk
	cXItAi2m2uX1Xf926GNNazjZXMviFF40Gegb9ul7uqxA==
X-Google-Smtp-Source: AGHT+IHCTn5W0AihyA8PI5mZHutWj5yRY3rXS3fbZQd8qAWRSA4Nl0ZCl2wAHiOWZ/Tv5ojga7+TWSziQQsM
X-Received: by 2002:ad4:5968:0:b0:88a:2d35:6a5e with SMTP id 6a1803df08f44-8908427022emr247551776d6.38.1768205828935;
        Mon, 12 Jan 2026 00:17:08 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-89077093d8esm21815826d6.7.2026.01.12.00.17.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:17:08 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so1274823a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768205827; x=1768810627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzljhpYNpTIoKySJ/ODiIvsRPaEcWnBviJG+IPXB6k4=;
        b=NHfwFQXbIsjFquOLKamvVd/qzoJYLsxfvd5YYcqOUG8zYfDyFQZLN9a0JwJKlE0+mb
         T0YJM16faizDcIyX7xA5tW/YZL3l8RRdKXpVKVMfK6+xhofTLs39czbBQ/nQVd6kSjup
         /li3pcWnQNKFE6VYY4PbqTNeOnld8bcdXkSj8=
X-Received: by 2002:a17:90b:1d0d:b0:343:6a79:6c75 with SMTP id 98e67ed59e1d1-34f68c62a3emr16553867a91.29.1768205826669;
        Mon, 12 Jan 2026 00:17:06 -0800 (PST)
X-Received: by 2002:a17:90b:1d0d:b0:343:6a79:6c75 with SMTP id 98e67ed59e1d1-34f68c62a3emr16553850a91.29.1768205826215;
        Mon, 12 Jan 2026 00:17:06 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8b1526sm16808659a91.14.2026.01.12.00.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:17:05 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/7] mpi3mr: Add module parameter to control threaded IRQ polling
Date: Mon, 12 Jan 2026 13:40:31 +0530
Message-ID: <20260112081037.74376-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add a module parameter to enable or disable threaded IRQ polling
in the driver. The default behavior remains unchanged
with polling enabled.

When disabled, completion processing is kept entirely in the
hard IRQ context, avoiding the threaded polling path.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8fe6e0bf342e..869e525f3e73 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -21,6 +21,10 @@ static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc);
 static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
+static bool threaded_isr_poll = true;
+module_param(threaded_isr_poll, bool, 0444);
+MODULE_PARM_DESC(threaded_isr_poll,
+			"Enablement of IRQ polling thread (default=true)");
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
@@ -595,7 +599,8 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		 * Exit completion loop to avoid CPU lockup
 		 * Ensure remaining completion happens from threaded ISR.
 		 */
-		if (num_op_reply > mrioc->max_host_ios) {
+		if ((num_op_reply > mrioc->max_host_ios) &&
+			(threaded_isr_poll == true)) {
 			op_reply_q->enable_irq_poll = true;
 			break;
 		}
@@ -692,7 +697,7 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 	 * If more IOs are expected, schedule IRQ polling thread.
 	 * Otherwise exit from ISR.
 	 */
-	if (!intr_info->op_reply_q)
+	if ((threaded_isr_poll == false) || !intr_info->op_reply_q)
 		return ret;
 
 	if (!intr_info->op_reply_q->enable_irq_poll ||
-- 
2.47.3

