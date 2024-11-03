Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9ECB673;
	Sun,  3 Nov 2024 07:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730617363; cv=none; b=Tofy5BRV0ZwQ/FOHpj7Z4AxpEH6gvp0hMjtY6gU1I5luXuZuM4vatAfAPktEFDjySF4fZILSXzQ9S2P0G261KM5voDg4jaojguj+1kYqvF7kMp5AchD6ScTGZwv01A6BIaRvWfcw/r0anYNR36WVh59YV632j5SQwuGsR+x7l3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730617363; c=relaxed/simple;
	bh=6o1Wagd0uUVsHIpGzUJpqU/Rw+/J5VBWI+It9NIq3S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wm43rvvDMBT0RRhTNr0WP70tEi9v/8Z2zT7HlkLZYBtjOj2jA0HGv1X3fmVal2qI2VenV3cWsry7dZ1Oqy7vwI0I28Pz4Vg5PVb7dIKGSlZI+LJWy8VYSZlOMfHJAmInaSt2y2Y6wJvzy9ZURV/66DKVO8NK4UcVD8Azke81wr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4sAqlpI; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4sAqlpI"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e7086c231so2730658b3a.0;
        Sun, 03 Nov 2024 00:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730617361; x=1731222161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VBWbka6tcunvnkswMnINMIR9eUmPBlJrKkb4tiWy/N4=;
        b=h4sAqlpISr81c2EHaVcg07CgeQ3nhN0z4kKb8y/x3kUhOQvC8RfMMgBKSRouzQaA1Q
         sW2jqe9PXa9GumMxcJIChgXcW6D5w3LqjusUsn00Io/oCZJfCdQcAmnSyMWR9q8vfEFA
         aoUcrxGyesxswSlO7ZrTV2+S+j64CXZJ/LASKYDN2i1Eu0s01YBf7OwGaADU9jO9fhZR
         D3Bz85wyb3N0sc/1VPvqRd5/AMK4E30I9PYCL7b67N7SbltNihFdhp0Nxzo/+pC9XxBn
         VJX+kEbadEolI+SmciEu5RMCZrF4MCEeSlxW2w6CG32i6/eNS//NDwektZreCUp74Mzo
         WX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730617361; x=1731222161;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VBWbka6tcunvnkswMnINMIR9eUmPBlJrKkb4tiWy/N4=;
        b=GKeQJImctGCvGlqu0B/s1jRkbvOEJjfRPlSftD3HBhK+oeQZUkpfueWdYVyMYP3JNt
         rgy9Hmv942vNDauw2SxF4Rwk+IkgGLUrpWWoAT+pwRMnO4xOsSpiz7FCi91U8E/n0fWD
         b93sbe9McKTf36eHi7LfTWK0V/ptipap3pmZj8lnX5dBpx8XNT3Bk/CP0CS8zNlCWCbn
         28sBEo2GAd5nKMqSWuXk7YtFpe2Yy/iOaewfMoeS3WlD9CgbX0GZZoyqMwid43ON5aoL
         YfM1G1lklxUmwuTFGyFeJzllx639zdSlZ1gEZPMMY0zUXb9f0dHeI7aqQSqKwS2Kywyx
         O2Tw==
X-Forwarded-Encrypted: i=1; AJvYcCVS3aHL4C8D4tX7cjVXh932EZiiIl+SUSgYKGjCLx8MV7U5JsWRoXYGhso7mjAlkyxJhrbJj4bC2HApRHw=@vger.kernel.org, AJvYcCX2MaCeMpLTkeXouJFE5x5NfMLX/b4kV4ucJBV1sZey9PleRT6HEa9fyY0YtV8LuJnDKjO7aUw7Tt35/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ+oc/ssSoLtOe4EbD7RCVkrs4r/BXg+yM1VE0eiOzjMnZwK7F
	+ixSc7Hscz1LagWkgBrQpArE6fnZFoXA6Ppo31lmN6aqNNcJz6rfBAmKkiHO
X-Google-Smtp-Source: AGHT+IHU0vj4Pj3iMVr+/EJms2QQfuERXpC9vF1oOT/lUMi3mXG4gUxOOEoiQrRZikcZZ/281+Q+2A==
X-Received: by 2002:a05:6a00:845:b0:71e:6e4a:507a with SMTP id d2e1a72fcca58-72062f4f6c2mr38185268b3a.3.1730617360801;
        Sun, 03 Nov 2024 00:02:40 -0700 (PDT)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2eb3bfsm5151965b3a.156.2024.11.03.00.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 00:02:40 -0700 (PDT)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: lduncan@suse.com,
	cleech@redhat.co,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>
Subject: [PATCH] scsi: iscsi: special case for GET_HOST_STATS
Date: Sun,  3 Nov 2024 15:02:20 +0800
Message-ID: <20241103070220.6695-1-hawkxiang.cpp@gmail.com>
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

