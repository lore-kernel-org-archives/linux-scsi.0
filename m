Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFC333263A
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781720489; cv=none; b=olq++juSU1gWel45Saar/VUlRyKCx3GszPMQW2n/fGJTXaf8SZx4/jX9ooIUlY/mj/CPdf5c4nYIGEmxC+NcKdhDC1s1Eqv17B3EYdkTlvlEP90KDGTsgSBl9RtQ352J4qN+tLUCgvENC4YbX2woP9LvgKeljgm50V90zLN0HTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781720489; c=relaxed/simple;
	bh=5EkO+kKe+XG+j+gG6dZQgorrpjxbN3Pwb8lDh+j85RY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=m5H0q+PhTk1xEec33RpWfjOHKt7Yuz0Qn+734M+pZL4MxAgG6oatbUffLQbFzCCsct/a9sAWiih6nn8pL4J2uzMo8NYAnXHzbucdP8YGz2VVjaKqXvcS8Bmkd7u6tKWBlanTgUqFkPx5X98O7ndop84uqE6727ZBVdZ9vuKuwFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nFs3vbbK; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFs3vbbK"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-13986d61b4eso302530c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 11:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781720487; x=1782325287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vAl7Lbx6JYWedbPXdgrZx70B+jeSbFyD7OiCuKZu1GY=;
        b=nFs3vbbKHXCcIM//ZzJAW0V2aKptl412qcVAFc1TQDby9Dq9p4tvV1EODYymtX4+e1
         MM0+HW2sh2TOGqqjWRlojIHUFEGuXbD2jCShU32Wku9Rv7+q8c2Q6uFKzVisbzlum4KM
         FaBnbpHY1F+BTv1IAW/FU9KYUTZzZ2lWGJEGohyqtZqUt11SSX2kkLCr9qxNSylWmLKH
         Mc0uqDfJioY2MIlEMoFpHzdd/1hwR105b4+9P8lVHoN85czDIzxnY2eu6Hka5ZVt+rvo
         1qk2iqjV65M3RMPDkKHqDuxQSxQaYAFNAA0k+FPL6R5x/sIXfb9mZ79Hp6CQK9YsBmPM
         NQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781720487; x=1782325287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAl7Lbx6JYWedbPXdgrZx70B+jeSbFyD7OiCuKZu1GY=;
        b=erom3dSiqZJ/Ja0JDDvsiZ9HIr7AC042jOooOqaqJiiF131fmitSfwqrUQGLg3hq6e
         /lXPvO8Uhcz/iexmiZhy+lcWeYQcJC9bnjW8rocWA/0TpjMDBcPbjhsUhAN3wSjsMLrO
         dk5QOffqFRSkOJVfGQAMu18oEt2ZpIkz/YUAgpPB9NaYUcOi4nsoNAySQtQ9OTvOTqAx
         Whox57dZ3mPOZFu7tmUxp9uP6WSUTOkw+Gve0VM9oFvjAMVSs/Ebrt5FOCfjq91OXBxr
         2Vk4m0Nnl7Uhy9MU2qWj9cjAIR1B70b79LFLTbywxooD3fv+EmBDOAVIMYzyDaSBRy7O
         sYHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/2taWxtFp3DveYXp3+jra1UmoX44efKTBStHPg0Do+sG1gfE4g5ZXtJMO5+2UqqOrQHmegM70mpYi4@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6w9/W9+axeg30yfZjee5AePH2pope8Cjj5PnWGnfYwmTVOzG3
	ZaE2yJnxr7WvId8yUoQ/anIMmLpPUUCdDCayaPVrv+XstTMzDuCGuKyybXgs9kXkO+g=
X-Gm-Gg: Acq92OEmqSrFxhNTKwoNaCWLeWCc8DIFv949CLfNjUGTabbHHrn1xoWq4MuhW8xQ9wE
	/3cN5qY91jCpB4hhL6Z51P6Di0DhULFLpMR2/KYVgH9QSgTBt2eywnwPft9IESEMHLYJI/SRetF
	xFyhLKGgkrlTOcmSap00rwoVjHTiqY7+CypuZHmjS2LpokJVijgz5BW+scX2vEUYiE9Q3ft/1Lv
	T1APF+P7pX5z4QG9lQlr32xmk9LkqBUVQcK/yRKjU7uCAC7xsNUKd0y2neWltsCUZMmnEta7nCS
	eUrd8xBaNiBoCPQhccHihd19PleRliKCtvqWIioX/qv4KGsKLUx8REYSxHvFlaqrm/RikfTGQ+R
	1eTYd1Qd0VXLd6kTa4iduUUj1IFw0y5dvzjbJT/UQsh4pdwSPSCTDaS2A1HWVvbEtBCLpT+5v3o
	WogHZVKhNNdyK3DiDAKOTqkxi5mSfxbR5y
X-Received: by 2002:a05:7022:907:b0:128:d4be:7438 with SMTP id a92af1059eb24-1398f6dedc6mr2179384c88.30.1781720487367;
        Wed, 17 Jun 2026 11:21:27 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:1886:6b7a:3e78:272c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b964853sm16996924c88.11.2026.06.17.11.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 11:21:27 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ch: publish changer devices after probe setup
Date: Thu, 18 Jun 2026 02:21:21 +0800
Message-ID: <20260617182122.955546-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ch_probe() inserts the new changer into ch_index_idr before initializing
the kref, lock and scsi_device pointer. ch_open() looks up the object
directly from the IDR by minor, so a racing open can observe a partially
initialized changer.

Reserve the minor with a NULL IDR entry, finish device setup and element
discovery, then publish the initialized changer with idr_replace().
Early opens continue to fail with -ENXIO until the object is ready.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/scsi/ch.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4010fdbf813cc..12061e4681ace 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -897,6 +897,7 @@ static int ch_probe(struct scsi_device *sd)
 {
 	struct device *dev = &sd->sdev_gendev;
 	struct device *class_dev;
+	void *old;
 	int ret;
 	scsi_changer *ch;
 
@@ -909,7 +910,7 @@ static int ch_probe(struct scsi_device *sd)
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&ch_index_lock);
-	ret = idr_alloc(&ch_index_idr, ch, 0, CH_MAX_DEVS + 1, GFP_NOWAIT);
+	ret = idr_alloc(&ch_index_idr, NULL, 0, CH_MAX_DEVS + 1, GFP_NOWAIT);
 	spin_unlock(&ch_index_lock);
 	idr_preload_end();
 
@@ -951,6 +952,15 @@ static int ch_probe(struct scsi_device *sd)
 		ch_init_elem(ch);
 
 	mutex_unlock(&ch->lock);
+
+	spin_lock(&ch_index_lock);
+	old = idr_replace(&ch_index_idr, ch, ch->minor);
+	spin_unlock(&ch_index_lock);
+	if (IS_ERR(old)) {
+		ret = PTR_ERR(old);
+		goto destroy_dev;
+	}
+
 	dev_set_drvdata(dev, ch);
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
@@ -960,7 +970,9 @@ destroy_dev:
 put_device:
 	scsi_device_put(sd);
 remove_idr:
+	spin_lock(&ch_index_lock);
 	idr_remove(&ch_index_idr, ch->minor);
+	spin_unlock(&ch_index_lock);
 free_ch:
 	kfree(ch);
 	return ret;
-- 
2.51.0

