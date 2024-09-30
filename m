Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF5F19006B
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727703027; cv=none; b=Va2UJT9ycvCdejN6/HTURdYMGCjfyF6JbKELCzJqnAdJHnl8l8oWikMBFpqZ1RK13b2Ji5dJgrJ88FQ4Wp/0IoRfaGFYJSZHrojVbh+AqGJfk6DL0BFZvr/2ijIVxhdNVUcd3DBIKJPxKmkan1vrXBpTE5HG+RAgldOrw7f7OUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727703027; c=relaxed/simple;
	bh=V0AVZSoP9esQT6/3wsHOfFriJIdSLFPdJI/d81G6Gsk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=let/rfqlEyOOW5IfCJUPIhbS/9p7IG1pBhWvLjUMvxKxFor1fBagrDPt0PJTYEhC7mZB4k7x7xxMI8vh2KPxjmOwB/G2mLvLhEwNGqThrPc+dDAnFCYhmD1gL5DbVoctSrCAohDoFLhBzV1z28Z1oGsx0DrNijMwG1RWl6pqjcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T4TY42Pa; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T4TY42Pa"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cb6f3a5bcso54106195e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 06:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727703022; x=1728307822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yPWuOqfONvlHAzPAnRmUoKnMGp3BpKJrUQoWbsWOndA=;
        b=T4TY42PaUbEkd1wofONEdOedrme8Jltee2SC7EqhWs3sd2ysnuZYrpYQDSxyIX2ste
         Al0XaJcVkXWQdIDACLE3r+T8pA88Ovut8HJ4jgBMxNgKr/ik3X1R+SK7lXoffDm4lNdA
         kZE0NovcygIp2GpK5SbyWo66xl52O8+uPBwDriR42Wn0zp/yMFooRYISXl/flkfXvrPl
         su+gN3EAx+AmAn23QBDWbODUUtWfuhyvnZsQTZ27DAnFuNxSoKcyT87aKbvwbzEUi+OV
         I0oeDGTc7QdOeykvA6tccvvDdkhVRwiJBeNPKWBjtsbZ1q3WRuPuWW1GVNqVLBU3f/M1
         v5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727703022; x=1728307822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPWuOqfONvlHAzPAnRmUoKnMGp3BpKJrUQoWbsWOndA=;
        b=vplqSVHkVtLRbNWxM+J6XtkxgoG4J8fCUUgb4wCWPK3TjHfr/r4S3WklaZjj/gkKXW
         tkmmUkc4YepwGtkFXfDdpikTHqFvDn4S3RWYy55yQ0vIKZJivmtCc1pF9I/vhLvP9sBV
         s1wBiXMmnoIXDC2/1btNmhjOevZaQQlIMIaPOVe2oXFyOXynYEKwzjBg1El+drQ9u9Xn
         ifG6BvHznlSDJ+Ghu51+xJWHMtA734LRTRu2qsOsv2KI8xqIV0ZjR4s+gsAA5me3ntGt
         cm9EnDtyKNoJocRsbNmA6JuNEdthj0h5W45/W/OiQyKTwd3ulowwKX7ARZt8GbAtsLE2
         +UrA==
X-Forwarded-Encrypted: i=1; AJvYcCUnnPYFXfcJMPPiUaPfW5+5uZufGSss6hDB/acBvco/SKg7YYETPfYdrFT13hgrylje2JK8Wof6qJBK@vger.kernel.org
X-Gm-Message-State: AOJu0YwpNLyRswL4LP7jqK22/FaurAAZ1nKe0zcKIJrOhk+ezfOCzr1h
	ZIRCGnMCdjUdd97do7IGxJ6xaprZwlrRAqfckoBycmTSPBDR18tpxZRTpn4zhew=
X-Google-Smtp-Source: AGHT+IG1DRU20M3aslrggmS/lasdl+nh0zTAvChkq1uV6iHsUWJZn+SlhNHQDwV+iNPAIVR7/FkfQw==
X-Received: by 2002:adf:f10d:0:b0:374:c6af:1658 with SMTP id ffacd0b85a97d-37cd5a69a2dmr11883628f8f.1.1727703021816;
        Mon, 30 Sep 2024 06:30:21 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a93c2978a71sm531381666b.161.2024.09.30.06.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 06:30:21 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	linux-scsi@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: fnic: move flush_work initialization out of if block
Date: Mon, 30 Sep 2024 15:30:14 +0200
Message-ID: <20240930133014.71615-1-mwilck@suse.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(resending, sorry - I'd forgotten to add the mailing list)

After commit 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a work
queue"), it can happen that a work item is sent to an uninitialized work
queue.  This may has the effect that the item being queued is never
actually queued, and any further actions depending on it will not proceed.

The following warning is observed while the fnic driver is loaded:

kernel: WARNING: CPU: 11 PID: 0 at ../kernel/workqueue.c:1524 __queue_work+0x373/0x410
kernel:  <IRQ>
kernel:  queue_work_on+0x3a/0x50
kernel:  fnic_wq_copy_cmpl_handler+0x54a/0x730 [fnic 62fbff0c42e7fb825c60a55cde2fb91facb2ed24]
kernel:  fnic_isr_msix_wq_copy+0x2d/0x60 [fnic 62fbff0c42e7fb825c60a55cde2fb91facb2ed24]
kernel:  __handle_irq_event_percpu+0x36/0x1a0
kernel:  handle_irq_event_percpu+0x30/0x70
kernel:  handle_irq_event+0x34/0x60
kernel:  handle_edge_irq+0x7e/0x1a0
kernel:  __common_interrupt+0x3b/0xb0
kernel:  common_interrupt+0x58/0xa0
kernel:  </IRQ>

It has been observed that this may break the rediscovery of fibre channel
devices after a temporary fabric failure.

This patch fixes it by moving the work queue initialization out of
an if block in fnic_probe().

Signed-off-by: Martin Wilck <mwilck@suse.com>

Fixes: 379a58caa199 ("scsi: fnic: Move fnic_fnic_flush_tx() to a work queue")
Cc: stable@vger.kernel.org
---
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0044717d4486..adec0df24bc4 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -830,7 +830,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		spin_lock_init(&fnic->vlans_lock);
 		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
 		INIT_WORK(&fnic->event_work, fnic_handle_event);
-		INIT_WORK(&fnic->flush_work, fnic_flush_tx);
 		skb_queue_head_init(&fnic->fip_frame_queue);
 		INIT_LIST_HEAD(&fnic->evlist);
 		INIT_LIST_HEAD(&fnic->vlans);
@@ -948,6 +947,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&fnic->link_work, fnic_handle_link);
 	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
+	INIT_WORK(&fnic->flush_work, fnic_flush_tx);
 	skb_queue_head_init(&fnic->frame_queue);
 	skb_queue_head_init(&fnic->tx_queue);
 
-- 
2.46.1

