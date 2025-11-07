Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12389328B40
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762524910; cv=none; b=A4lHRMI59VhZdIE5ycxq5Zk/LwFxL2HmIirQ/LMJpYqwTMR8E1iH3CbNHuvp25BjGfuaswoF/1xqQdVq8FQJmIBaT427kpNyDh/UwzMoqDxvfBSE5bHXtT7dtgE9M13WGLbGnMgy0BGXaloWBRhQ61g3gnA9BTtWW4nsfcD1/SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762524910; c=relaxed/simple;
	bh=XHqib5P0luygOlwFQcX5ex0tga7jkw3zWlEHHEXkhCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hQopsSIc49JIDpOWuyzXHK2vZ/AilDQxmfeRZhKOt2HBUyvaeUOhP7rU7isWCSRQJk6cljuDYjhFAbOiBz/kde6dPXFQzwf99oV78/UkTLG2o1GU3ocoUV0ZyzG8LoRSAZnT/BON8IrWcGN1t3jtoo87i/mucL9qdvVJSLuCRRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HxABlOEK; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HxABlOEK"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4298b49f103so330956f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 06:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762524905; x=1763129705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G3gFQ6/5N2I+HN14q/CvmXF68f+oweRzkemP/li43qI=;
        b=HxABlOEKJZjAZSHKmEdgyOkBVpeeBq9S8DcZfmrW+ufakKnnlRB3SfJmcSQsTNU7oa
         5v9YdoO1g4OSgXO7RmjCCVeFcjq0QDxNls7ECMJNuxRRYLtb4F5j8PR871Px/0oGa/44
         Pl3ccu0ndnw+nUfa5wOQu42hm7kl888z9B9fETclg/pceSJFOfFf/NTGfmya8ZlIMbfu
         9r3VvQoDxOI85/rtqLUf1ODxShuWOgfejPj3H1+Q8nfKMomhfep+ywFwLir+7HMBqlGQ
         TWaPvtwP/8J8q/15WY7wUB/gCiWP8WyBfb3bibmUT7Tjym6AsLmK4bFvOyGigotK+Pvz
         /8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762524905; x=1763129705;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3gFQ6/5N2I+HN14q/CvmXF68f+oweRzkemP/li43qI=;
        b=GfoCRqKWe3PTfLt31QHNTTxDO3C5JuvVOhHwZJjWp0kLgp2l7rbTrQyKQqyoiFmSnF
         bA0c3TCLSQRslGZUWq41J0XWuFxswArnYm4cJ0IqccfgM0GAJUsjpMGZj0B35zvn2uN7
         OJ3AA7Bm/wHgg4XXvgRfvxmL6jtrM3PAkjx3neo56/rMyVANSrn7QeUtQcxwc/j61fEZ
         g5rHfGWIptErTXADmdQvRRx6rWN9oJ+68AKVvcTqqtON5hCuBb6bla6FqlPgbQnzGubs
         BDAyGGEd9E00UetaSNpHAVX65UL0giBWDhx53O/ekIjcsAA/wq0xFhoILDL7wpZhZuMf
         bTNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbyLHbsjbBOhJyy8pz6vzfHGuoPxP4ZormgvandjcKItczQpSU25Slbo2j4D+dBOBrets0t53Ise5q@vger.kernel.org
X-Gm-Message-State: AOJu0YwHzN0JMVB1PxSruhTRbxYi4G5MGbdmd6GH58s8oC6onLAqvlIc
	sJk3M2zpzNsjWI8r2vN+O/JRs8DdkCGtIvqFKtiYdQ3o9gNgez8smkhPaeO/kXc+sog=
X-Gm-Gg: ASbGncvJdM15tnpBtMsASgvmjXb+w2jXXzpsxp/LliZ9IJk6kKQaamrevAcFlfUElzD
	BE3YX/ZM98fK27KsLhsZcA3psJlChW23o4Uy6y3kFTFIeNNdJEfgBbppb8V4eYeIy/AVP7lDEQ8
	y3UdT0FYyriUikvjtnZrjFuBhGomclNb89G+zvQkVWsCTaOK2RQIOvZzzSouKbuB4QZ9Vql2/Oz
	PbsrOJuBZiT08Y7r+C55TFD3UL9D8lLwNsRq0XYvznhdT9J1xpn8bIHnsW+/ipz+5GNy2AnbE0A
	yfNwbTP8q2XCLIfYNiEml3dT0W5Y/fgkRDxaVaWxEJTJPP1fha4YL22pKnvYNknQI+OTEG67DaR
	NUNeg5Sucu4pm7Zw8QGRwaGPD1Hmhcf9ZMu5bleZbBtcyKV9BO3O/s59/Xzn045SJrt3bj79PXz
	EvNjD4ym0DAiU1AA/zy8hXvqji
X-Google-Smtp-Source: AGHT+IFfPXb8HgIu4Qd7GLXW/DH6761f/EmuF1ghCqH/M0Tj6NvO7VdNax1IVyh6UEpfUQabKmLlew==
X-Received: by 2002:a05:6000:2906:b0:426:d82f:889e with SMTP id ffacd0b85a97d-42ae5880c72mr2981260f8f.14.1762524905242;
        Fri, 07 Nov 2025 06:15:05 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac677abeasm5493343f8f.33.2025.11.07.06.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 06:15:04 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] scsi: message: fusion: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 15:14:58 +0100
Message-ID: <20251107141458.225119-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/message/fusion/mptbase.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 738bc4e60a18..e60a8d3947c9 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1857,7 +1857,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
 
 	ioc->reset_work_q =
-		alloc_workqueue("mpt_poll_%d", WQ_MEM_RECLAIM, 0, ioc->id);
+		alloc_workqueue("mpt_poll_%d", WQ_MEM_RECLAIM | WQ_PERCPU, 0,
+				ioc->id);
 	if (!ioc->reset_work_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
@@ -1984,7 +1985,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	spin_lock_init(&ioc->fw_event_lock);
-	ioc->fw_event_q = alloc_workqueue("mpt/%d", WQ_MEM_RECLAIM, 0, ioc->id);
+	ioc->fw_event_q = alloc_workqueue("mpt/%d",
+					  WQ_MEM_RECLAIM | WQ_PERCPU, 0,
+					  ioc->id);
 	if (!ioc->fw_event_q) {
 		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
 		    ioc->name);
-- 
2.51.1

