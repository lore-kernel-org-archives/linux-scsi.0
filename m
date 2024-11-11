Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B7C1EF1D;
	Mon, 11 Nov 2024 06:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731306133; cv=none; b=H9MTLpbtwZeZ407whOW3DPDRvCzEWda5Efv/TmuqICo29ikpUw3H3oPa8MFBXYPyuP7nxjxrLPZ95fCZB1APHXzUTPaA2kAgAsfuyN/lTh/DFx/BzurHmPkD0oaXdoDFC4t1D0C8sUGjNiq7Ipu/F1YwwFXKUukZN2joQntRf2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731306133; c=relaxed/simple;
	bh=6o1Wagd0uUVsHIpGzUJpqU/Rw+/J5VBWI+It9NIq3S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pK/b5iREWvZi7ctmyOgSQOrMc+xCAy52r1ekUTemevFi5F9H1YfPgG6TsNnt9NpBs8AyULKXgCqGEdbGKGqh6hYWJUUXKbAd5Y7V1w8utVmLb/6bkjvaAlETeYBLsntrmqJbBlH5v0LQZXuHHYBVlxTxpPblWiCI4GXZX2hLkwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpgbYIFO; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpgbYIFO"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20cbca51687so41110705ad.1;
        Sun, 10 Nov 2024 22:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731306131; x=1731910931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VBWbka6tcunvnkswMnINMIR9eUmPBlJrKkb4tiWy/N4=;
        b=kpgbYIFOzkV6dJog7O8OBrqApoP+5jPwkGHYpwnsTY1hQz1dPQiyBkZ2o+3iF3h8+q
         g3/zxqEsMyzajjM0Oko6TjmIS1vD3rZ8gW18zGShfRt1Wt6qfl8PuP0llrW4+e/UK/8e
         NDilwsDWBtved0GukQDVjfgD7cDVYdgCVf4BS8pAb9YxRfVX0vgJp+0oZGllwbjew2m9
         8nutJ06A3V6Q9IXdQTR96b7ZKIK71oVu+Mq171jXmJ9bOgVHtWoA6XrVQiymItpsh2oq
         QFbscNbBPw94/wIrN8RouIwkPR2z7qCCqVFg9HwNixPdiaTAAf+XhpXxRGnp8aAW3KFI
         0b6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731306131; x=1731910931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VBWbka6tcunvnkswMnINMIR9eUmPBlJrKkb4tiWy/N4=;
        b=Egf0Y1j2ZF8YKNudKDzDlmujbmesE3sP1VsKnDWWJc8T2dDPBDMaxrjN57vW21sJgq
         AtviZ+BsiKCXDPXHSCAWLmAuLGETQAksUz8zDH55mTX4gZDfqqavsVQSO27q/7NlR/gx
         ybDIosqUts0NYOfIdLByfxI3cjM93h3XwVuPrqxRBmNCkr+PwgaCsPErajVHEcYfm520
         v/PKKzzgM/hyODuom0tjdoPwzIYC/v2cuykwaePyvvvFqRfJj427zpT8M0/9Qi8Apv4v
         GKum3ELi1EmSqReXY9h5wsIO38HwbryHOG93SqUlcWYRi0OWhKQV9/jOSNpRsH5FNhhh
         o3tg==
X-Forwarded-Encrypted: i=1; AJvYcCXzvvaivMAgeAPgskzjU8GqH09lFrCypXqElRfDAIUNzBkM2IueAgGThsRuscp5sAgY88OF46P7mNdoBl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx1pYWvUpNfjk60snmL5K4sH0K6Ggqz/QhVf1wCO48LcXa4EAk
	dLrhiJEblFgbM5uIsxpe/QqC4DCp5NtC4BGg0Ow9vBFo4qhEfjbA
X-Google-Smtp-Source: AGHT+IHd1rVyG32K6mQRKSb5g8ZV+d4A7We4fZ1OI0UfFHjiqq+RNsFYAsV/vC0TZstA2Sqob/yLUA==
X-Received: by 2002:a17:902:d2cb:b0:20b:a25e:16c5 with SMTP id d9443c01a7336-211835c0f65mr162005455ad.53.1731306131446;
        Sun, 10 Nov 2024 22:22:11 -0800 (PST)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e68960sm69051915ad.220.2024.11.10.22.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 22:22:11 -0800 (PST)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: lduncan@suse.com,
	cleech@redhat.co,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>
Subject: [PATCH] scsi: iscsi: special case for GET_HOST_STATS
Date: Mon, 11 Nov 2024 14:21:50 +0800
Message-ID: <20241111062150.86091-1-hawkxiang.cpp@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Special case for ISCSI_UEVENT_GET_HOST_STATS:
- On success: send reply and stats from iscsi_get_host_stats()
  within if_recv_msg().
- On error: fall through.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fde7de3b1e55..ad4186da1cb4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4113,6 +4113,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {
-- 
2.44.0

