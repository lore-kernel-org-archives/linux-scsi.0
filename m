Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4A539AD39
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 20:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442312; cv=none; b=WUeaPrf2NOygDXBpZmvgqZCKHv/Em6sjOVxPDwHNZP2U2bchB8QfloAiP8L+4jVt2iIawkqA1+Wo9TnOGIL96crkLWUF2A3UY9PgzPNM0wZ/OCAEb4Xvur+lbJEHuTO2EUDpaytXdxGEoN2eRMPPGR1lWJvHmVBuSsb6ogkfeeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442312; c=relaxed/simple;
	bh=ywoJVudyQly2BSU4Suu/ELob67veyV2IT2JljVMnXPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B5/K5LzV1iSZ8O4JbyhDcub8PIYjKSKx04HHi19/D6st/wGizHRjaqbev/Ct40hW5T23wZAxXEXnvq/oTHn2GJWL+DHxDY1xm51REP5pfIHtvO451zYmIq2cMMOX7kVjWzTy0ca3Bro97cjNyM9aUCLw5yu5lOEMJmvRIWC3UIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZE+rgqp; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZE+rgqp"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso324293b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 13:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785442301; x=1786047101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SiwSGXnRH3TAjHZf8TYJ+bLPyzkydxq8UaVMUOfakl0=;
        b=ZZE+rgqpWGO8ojZDXUbip2ounkYY1eNg1d/0oFePsUOEIaLoBEWK68sJkW7Do71l+c
         mv2c21/bWO0tG92lgpzz8W59tzWOgzs5Dyb+TSZ63ocakvnEwITXuv2zLJHhH5YoFoUf
         h32nb2ymWScCbUNtfx1Wh9iEYigiS3fehlP6otLLhF/HFqkH3dC9bLl/rlouFDNV1lNp
         57RGYHcbxYHG6TKhdjIMrOTJSX6ljivYWRSYXrsjc9RyVX3bqWyG84P2MnMo2XJKI8jQ
         DgjQ+LjftpwVskuSqBOBR/leyinBmGfR93VbzVs5jHN5dy6CqqY8jpajaPK5QyvgGU9L
         qCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442301; x=1786047101;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SiwSGXnRH3TAjHZf8TYJ+bLPyzkydxq8UaVMUOfakl0=;
        b=oCLKt4nxFW0X5psOAJGP+zuOD+x4Xlm4wA1Qr2Y8x0JtncqW3P6foRNqwpA5A4nzBU
         wLSjQGqB7yG8W9wUitgsuNyRm/YcTQt9mLZPtNWrMFPzUNfqprVdD57RjAOB+HN7CeAg
         ifrxQrD/KgEJPKy31zkEa1DTHAqTQNdyu1e9+QZa1IaJu1xrwkr+nJfOlsFtunKhlcdX
         x6y1El8+fX+/SkGKXGjrcUXM95F175Wo3Xfpvy3LxfB5vA2v91iCU2bQapyTf5ucOgkT
         Hyiluc7lpXwl8WpXXB8kk5IL7qaofqpTiF8OKn2nVru9Y++DBFh0oESQ9j1v6IHuglan
         21dA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8/tdmplEzYe8oM+su+zOmmhko9SVca/a35iioB3OHH5pkCJcITaFJUS/Zx/C6jPOV4dLZt5NZfETF@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0W9GS6fsRQLZYyxZS2QQWmH4mHqMYdEAHexEF3AIOXM4N3uEC
	YkE6UfD3TB2oTLBUJZ9zlvJ/tYtFSE9kVBYHz6gAhlsBYutOyXzP5gNA
X-Gm-Gg: AR+sD100uxaYZKUw9izSI3YzRGhnR1NOosg4KR33AUC9opTeF92dkZaP4D/OSw4Hv4Q
	J3NUkSJ6k0pmFZ05R6SQk6CS5mqSOOmHJbqkNDP/ZaiChEm7TN+aIKwlnHw7omUG20cEzH2aOuY
	DEgeWWuIlWIb38+1V++p6RdjNRc8me5//YVe5GzkI56TfZCi9HRwT9vN4f10LCQBB9J4pICZcAs
	B6Mo5tIN8xPbXsu6cNS0pdTxZu7VNOmJNnwZbMJsIizKtvmp0hH3p5Ao086x71ytv1SLnV7dn86
	9pbcyEnKPBDs8/arNHrVBJOM3a02Ka3RxuMQfgEKdvsWmv9MYk8G0sX8Z4oXMZfZ0pIocUnRw/6
	lUWhAxFOaLBRTZYlaNAKxwp+HzdoUzrY25LdzwQYHxrBbGm7cHldsQ0VTbFBTp5iMOenaluqRSY
	BwJlKuT2TSCLWE7nLCbjjS8+F6/JiKnOOEsRmK1X5HX9RMsy/KYKt2DGEahuogrFF7gxoyP97d9
	64cT2jG6CW09xEulL4trr0tkzDvvQVIsjin5VguVYOLBU9yvwqu+A==
X-Received: by 2002:a05:6a00:1391:b0:848:56ff:6ced with SMTP id d2e1a72fcca58-84ebc1f5844mr3898044b3a.8.1785442301426;
        Thu, 30 Jul 2026 13:11:41 -0700 (PDT)
Received: from localhost.localdomain (c-174-165-208-10.hsd1.wa.comcast.net. [174.165.208.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm3689108b3a.15.2026.07.30.13.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:11:40 -0700 (PDT)
From: Michael Kelley <mhkelley58@gmail.com>
X-Google-Original-From: Michael Kelley <mhklinux@outlook.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [RESEND PATCH net-next 3/6] hv_netvsc: Remove GPADL teardown special case for old Hyper-V hosts
Date: Thu, 30 Jul 2026 13:11:20 -0700
Message-Id: <20260730201123.1767-4-mhklinux@outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730201123.1767-1-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the overall removal of Linux support for running on Hyper-V
hosts earlier than WS2016 and Windows 10, the special case handling of
GPADL teardown is no longer necessary. Remove it.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 drivers/net/hyperv/netvsc.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 4d319c50955e..4295b96b4312 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -695,17 +695,8 @@ void netvsc_device_remove(struct hv_device *device)
 		= rtnl_dereference(net_device_ctx->nvdev);
 	int i;
 
-	/*
-	 * Revoke receive buffer. If host is pre-Win2016 then tear down
-	 * receive buffer GPADL. Do the same for send buffer.
-	 */
 	netvsc_revoke_recv_buf(device, net_device, ndev);
-	if (vmbus_proto_version < VERSION_WIN10)
-		netvsc_teardown_recv_gpadl(device, net_device, ndev);
-
 	netvsc_revoke_send_buf(device, net_device, ndev);
-	if (vmbus_proto_version < VERSION_WIN10)
-		netvsc_teardown_send_gpadl(device, net_device, ndev);
 
 	RCU_INIT_POINTER(net_device_ctx->nvdev, NULL);
 
@@ -733,14 +724,9 @@ void netvsc_device_remove(struct hv_device *device)
 	/* Now, we can close the channel safely */
 	vmbus_close(device->channel);
 
-	/*
-	 * If host is Win2016 or higher then we do the GPADL tear down
-	 * here after VMBus is closed.
-	*/
-	if (vmbus_proto_version >= VERSION_WIN10) {
-		netvsc_teardown_recv_gpadl(device, net_device, ndev);
-		netvsc_teardown_send_gpadl(device, net_device, ndev);
-	}
+	/* Must do the GPADL teardown after channel is closed */
+	netvsc_teardown_recv_gpadl(device, net_device, ndev);
+	netvsc_teardown_send_gpadl(device, net_device, ndev);
 
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
-- 
2.25.1

