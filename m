Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795645186;
	b=JgeqsEq5DapAu4qLE4gnjSZCMGYdD+8pa1cDL2/KtbJLyAb3NUI8pbkpt3HAbE3X/Ijd
	 9a4juvHbTkn72zidfYbeGgH5i7H+bi918a/V9PceQWQ3xKwOzEvHDclqH9LQC+lrQCBbq
	 zZ5NbstNr5WUMTcSqR+mvzvF4LfD2LMjWUaVXLOm7cEG4tDpwkA/MQfKwE9Se1ARB/nLp
	 YSUs1ujOJv0Q5l3bwrkH8wkx/NWcH5DLsPkymkGx5QgfVtnmB19aBx1E5pHp6Y6XPH7ik
	 /NeqdvXtWC4gQR6uM8Ia3RGtXoCOS+sNEDLL+sjkXPjcn5VfLPAPWSJVKr5ZLV2Dyeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795645186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=8qhBQZeyr54Cjg+V6vaROasttcE0+Xu/EBT3l5pruz8=;
	b=z9ZNcjvgRNFE+LOpicYUa3/ubD4xXxmTYiHNRZ6G2cu5+K1BTQexFS+xpr306N9IU0Bh
	 ybTT8C/4TLZa8t1hNbwnV27g+3FCLVK/j314nP/S4zBXklhkSbwuWBkN+tgkoNH5zOBtF
	 dQgQnhETuCflWYlMDEkdJ+Qmk/pDSsvASQtRnHrJ/8TZ89E5m3z8GaK8i2gZummGTJW24
	 pLdNvyRacD/+AiHIFB6OCthlwYDxKQaLZDoBuXDMKM/mdHfCG+tVv91zHcB+4vaJL9tgB
	 OWhcVTd2PlaeNQ1PMQo+Jo0S7Rp3rN6Yxz8E7cFM0484lpBSt2Hu0Y+ic7q8Q4i1I7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--elkin.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aXmyti0o;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F822606A321
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 22:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F822606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elkin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aXmyti0o
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso8020363eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 14:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795645185; x=1796249985; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8qhBQZeyr54Cjg+V6vaROasttcE0+Xu/EBT3l5pruz8=;
        b=aXmyti0oUhoeiQiWqCYLjKDi5NUwqcrxTSJE2pwBcKbticJsKT1Z2AZ9zVQ7kAj3co
         AOseJ670N2yeIgUMaXKkDKxAtI8HeRbSGVLSpi7J5c3zn8xEsxYWXE39kHBkIM49I4FO
         NJj3JyyCKHCGdz4yaklt80wonMjYZajZnDhQ4WTFh8HsgXk1nM9sotWxky8iWZ/HVNW/
         GLy9sXOQd5eLeDGE+BMznmwr1AH3xn5XyUPcoqHpqm6tHDdH3WlXmI5WzLpM/Umn6mFY
         X7hU4q1mjb9nCdFaa2w6EHQwnjGj4JCHVRedRPlnNrhW7kfRoBu9pyjRJH3q1L6y/tFE
         tNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645185; x=1796249985;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8qhBQZeyr54Cjg+V6vaROasttcE0+Xu/EBT3l5pruz8=;
        b=uP9FTMW33qT2NZ1IS+PhfLawb6JAX/VG3powXtKyBGOJHG0OKFMI36zZlZ0OAZ1KDz
         1mEwIP58kw/0wlf4kjSUyG3hO+SGcfYyYwXdsS8Qak6mvrr58bJ5xZikAkAtGNXocHmu
         2EJgVgvCiLcs1Pf1oh9IIe9YDWzX+LycSciyzo3EPgJRwu50gMFEW4glVvEiSfLcxC9N
         tAHPPAe5tVS+9Q1iN4Mt5zMpVuMAejBBocAEmCPh6Fn/O6inbdbfWFkK8F/oFB5IvAjC
         38Zo5yxvkfinu4o8ohvMfyQlF9RtqqU3Eh0CL1BzsGN8wFdvqeIrtZVNRS59hYVG5Ull
         db1A==
X-Gm-Message-State: APuU4Z+4mFnsRGZR2YJnti3afDoYirGqMyRMO1Wm6y7L/jkT7m3d9tWg
	kE7cNlDeAP/xM+fqjqVC5/yeE8cvsdFxfhaNmWiz65j87269eOFF0h+xgCZIrc7qXNhLcybGiRh
	btg==
X-Received: from dycnr11-n1.prod.google.com ([2002:a05:7300:e9cb:10b0:383:7f56:69a1])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:8956:20b0:36f:551:2bd5
 with SMTP id 5a478bee46e88-38570846826mr18757502eec.32.1795645184533; Wed, 25
 Nov 2026 14:19:44 -0800 (PST)
Date: Wed, 25 Nov 2026 22:19:21 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125221921.1425747-1-elkin@google.com>
Subject: [PATCH] scsi: fcoe: Fix use-after-free after pskb_may_pull() in fcoe_rcv()
From: Elkin Cruz <elkin@google.com>
To: Hannes Reinecke <hare@suse.de>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, irogers@google.com, Elkin Cruz <elkin@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In fcoe_rcv(), eh = eth_hdr(skb) is cached before pskb_may_pull(). If
pskb_may_pull() reallocates skb->head, eh is left pointing to freed
memory when validating eh->h_dest against the FC frame header.

Re-evaluate eh = eth_hdr(skb) after pskb_may_pull() succeeds.

Fixes: 0ee31cb5df4b ("[SCSI] fcoe: Fix broken NPIV with correction to MAC validation")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 drivers/scsi/fcoe/fcoe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a2cf65fac297..23d6b9893793 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1365,6 +1365,8 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 		     !pskb_may_pull(skb, FCOE_HEADER_LEN)))
 		goto err;
 
+	eh = eth_hdr(skb);
+
 	skb_set_transport_header(skb, sizeof(struct fcoe_hdr));
 	fh = (struct fc_frame_header *) skb_transport_header(skb);
 
-- 
2.56.1.839.g22a8290db9-goog

