Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EF4193079;
	Mon,  6 Jan 2025 04:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736136978; cv=none; b=BXNVSOZfeCY6Z+jaLRhhM1RsaxNugu5x8vq8WmvWxRpfd0B2oVnNXNju5YUWM1y711L4GlA7rbf5pw7ZyJSDQUx3KIetOQx6hMZ2/YJnioJieXGvRlsX/XxdOCc2WOh9dmq/e2Or9Aph1lP/gXdy+HXV8tdg87+Anot/NvUVvj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736136978; c=relaxed/simple;
	bh=ZGtFqmYngGwTGZ1gSrarUBI185qDuWtCX2PB4Fv/CLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr1d1g/RL+2FEJZPUtTzVz9HDFzr4GXfUEqEPpJDGZRTCWF6/nLeGAcGFOrr0zZWzPwQNnSJFOgDOlLW1WTep+pqOXC69IOHi7CdaC3hNSw6+a/bNtZCcHh3KhCH9y0iGM9feZZoJ0IJ69DIjk4hpkb8uxjBv/rb9wMHlv1U5tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGkT/f/u; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGkT/f/u"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21670dce0a7so13509255ad.1;
        Sun, 05 Jan 2025 20:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736136975; x=1736741775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7DFprzlK5jXPjS8oE+l8vnkYlLTV49W/zeVgE0gmOU=;
        b=ZGkT/f/uIJ3dIhbCbigmrRzhDQQtKOlAXmRGMrsng7XJgv5VxGw3Sx4rLsdvnFUCKf
         YYxFNxuWxY/9tJAre9U+am/Yi215NKsMkJZ9asw0fTZ3NZkIyu5x6Y41CcoXlQe0fo1/
         27jBglGe6efkkbljH6TXqwsAnci2IsEVDxmLsfK//u+FYDn12QVdFFZ0buqOMy0wBKxy
         g+/ee60S9DUx6Wpqi8IJd5odZNrCg+Nh3HSOLIDOG9bGl+YR+b2ItbZk+St8P0sfQZqb
         i9Vt4Ib0J3/r8GE3Rhczly7w4MzRdp/bTL0VhImIexKiBfpsCeqzIY72JlGkxcZfPHdS
         Icvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736136975; x=1736741775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I7DFprzlK5jXPjS8oE+l8vnkYlLTV49W/zeVgE0gmOU=;
        b=hn3B3SGJzejSBCb/l8ztTJaYf9QI7JbCGW3z3qStb9jFCVlanva5FQa9rGZSI0AXSh
         +twDy5dau5BzknbRAriSkgPi0VHfOKIkC8bUtdUdhis/qcf9s+mTNz03+RSEGhqstLYB
         afy+6I0DWmXTe29QdYNMCGnsMhwrgDuJXe6Qf4R11GbtKJWrzsOG9/WN8SbaqjwSypoG
         a0IoX8wNvB6A9QSk/mlyC067a91pjvnRCH9dAf4faPUvgASeLvqIRTwEmg7+DGwrvuh8
         595rUWEdKS0wYLEPjAhfkM0frDg5D/S2/SJZH52ywzrpRDn6gpBO1btNeGBF3mZ0mt3A
         vv+A==
X-Forwarded-Encrypted: i=1; AJvYcCUCQlVsWwd1I8hgaD6kLqouR25G0hLGgxTBQybjFktwECBgBqiOMGQHIEeuO4eyz+PCn8IeGFp8W2kyLyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiBliiO+frif8h4H4ZQhL/MYHve2xPrzER6PooI1KdA0mkKfb3
	Vnri0WinCKW5CYYzsnTPymY8RtXrvAhOP+1KEhY7D7G07a0bEVJz
X-Gm-Gg: ASbGnct9AU7W+wfqywf8tHEKwMSZUxilBEHQ6brGqtdPok9Wc00lKrpxBhNevzlLpNM
	gd3oTcAw3YqaXag4HTKYBb3sJl6H3vFXSxslftd+XYtTZx/Gb93F6W4TXu7jozbRDd2VwHaK7R8
	EbXxN3A7DLTTsgGis0GtlndP20SelszUeTFdnEouYUbqCl5WvZwhZLcIDqOd/jPKici6fUyDiC7
	IOCYmVxs2YKk9Uo+dZTedvor6lY4Acus25RyN6s3gT51oaM39QSWTy8wWXeitN7OwIp1SujfAoY
	of4Fna4YkA==
X-Google-Smtp-Source: AGHT+IHo2cgwq5UcNx/Pu5YJMbaeE5dIoKcpTN5ayfD2AazKRL32FW/jNFZeQbHXeb1EcJO4ztgMag==
X-Received: by 2002:a05:6a20:918c:b0:1e1:a06b:375a with SMTP id adf61e73a8af0-1e5e080dbafmr105452444637.35.1736136975147;
        Sun, 05 Jan 2025 20:16:15 -0800 (PST)
Received: from localhost.localdomain ([103.150.184.35])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8157d7sm31367407b3a.21.2025.01.05.20.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 20:16:14 -0800 (PST)
From: Xiang Zhang <hawkxiang.cpp@gmail.com>
To: michael.christie@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Zhang <hawkxiang.cpp@gmail.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	open-iscsi@googlegroups.com
Subject: [PATCH v2] scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request
Date: Mon,  6 Jan 2025 12:16:07 +0800
Message-ID: <20250106041607.71102-1-hawkxiang.cpp@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <2caf466e-322b-46c8-9028-8bfd8347792a@oracle.com>
References: <2caf466e-322b-46c8-9028-8bfd8347792a@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ISCSI_UEVENT_GET_HOST_STATS request is already replied to iscsid in iscsi_get_host_stats,
This fix ensures that redundant responses are skipped in iscsi_if_rx.
- On success: send reply and stats from iscsi_get_host_stats()
  within if_recv_msg().
- On error: fall through.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
---
V1 -> V2: Update commit message
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

