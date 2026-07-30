Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A043C197E
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 20:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442310; cv=none; b=V/pAkoWB6715oMNMiwFvkFVu9FUzbwxKxjq008UGQFWNnlEcmHpmt7IlDohUNgvQ70z+xOtlgwbJEjgWoeSFbjJJOVII7guOqrjYSI8fiht+Ridnu9lmbGSfZxW9QC8dK58IWsq2zRzsxIbR84AT8fAFBixa59BI5WCgi6+cqco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442310; c=relaxed/simple;
	bh=82dBttW5BbKeJKJs/OF80tfwpM2MddI/t/zJLyO/za8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LAVXqlQIH0d0fi3Fv+smyEBHWEQwnM4M8zBXy9Lj35ZK6f1xe9AZFcfwZJCq1J1MiJuMFtvTVnxp44TD7XI492Wg/+x3gQ6j6vwG/n0tR96rUBWX7yRqzWzMpFWnCh6k3jMkQhgAgHyAgF5zrUHS+8SPg7HEjd0C12VBfk0ynqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkLoGcDB; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkLoGcDB"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84e507b079dso249283b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 13:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785442299; x=1786047099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1cRzxCLmJh01GBR+ktuxuJ/o0iMR1lZqgXW5wBf6dg0=;
        b=HkLoGcDB3WBibfwJOqTSPhktaOR12tYrn1Z2YDjlIijtIW0jt/y84TTd58TwPijLB+
         su9HlquHfO6asdTGrNx6RH1XttqGkuWS4CVnYGMh3bnUB05Td0l/0sdQnJXCkaWl1yCc
         SDd9D08//3ifMA2WRmm/p3MOQb+kLLDCQcQe5hwpDor0zCtwL2yd4I84GYPLMpem4kuF
         HKOwvVo2Ig21oxAwDDGOaWOW6f8sFMco0vOERzbo/HhcwK+6RIW/EXwkrGXj4/v7+SON
         ZNb9Iq+WCDHIVknVzZNrQdnTdfmT4y2eSU5YdBjiJjeN+KNtKNmhIK3jmQfF8mYxEXo1
         5sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442299; x=1786047099;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1cRzxCLmJh01GBR+ktuxuJ/o0iMR1lZqgXW5wBf6dg0=;
        b=RDfUN9ropNM8sYZ2fG1tmVnDxZl26SBxcmYiL4NTKySpph7Pt4Ra7twOY5Fvk5vOs1
         j06NiqVM62UvVjs0NmN2KOsqCR9/5ERGMtotoI1C3xkgLPScei07DdCN2lcHA+p1eUDb
         7bxoWgcFMKsLWIQB9zYxg+2VOGyojvnvB48I0SKUTHGyS8xTYOFT7+HHe1CfZFG+VdOb
         lz60RkMMXLi4eG78rOTSlN5R5YPOm/Cb6gxoRzV7Xi+/AzVuhZPctbKS80QIoS0KEFH1
         Q5vYgzeIOLuMDUKtL0giH++8sHFulB9nK7MCKQwRhUnOWBeQrlusb5tYd/7UbaM+fLMa
         Zx0A==
X-Forwarded-Encrypted: i=1; AHgh+Rqi9YJ8mPB+a3PwoxNFYW3TUEry5bzR9z7OmdVU4CfHFGZM1xbTjRHvfmjoq/mtlVVAnSOyDMy5hM3Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzm1YqaFxqmJf3FkiCmSWAEntFCEYwFg4qCrXob62J18VKQqTN
	L5Ou7DfqzpHawNe9EHcWHinEKc+N9Vcyu1axcbMdKZCLL0AEQb74f9V2
X-Gm-Gg: AR+sD13xe8jJPf841oBW9t5Gg2xfiWGMkSBFJ3zcr1d3nGQMwJx4x0efHiEzZx4Vb66
	u7sQ/iKh22Wqi4N4EVb0qVio+OwIL6ewTELl9fLSjetdWWmebgwV1mtWdnGZ2NCkwgK5+aeVQjV
	u5Hnu/WSfXq1JEo1igU0+41ve3SKOtPLaoGaCBO1H81IUSVInshuUMy0y/C+YlDn8X+RSD86PfW
	l8BToBDDaE/2h7F5RaBfChkSHanjjj3zLt2h6VxMbj3chibBbGs1HevULEbBnMc2lvi4207gDK1
	JiyyyPgP5a8U+w8nbqzZQ7IX7McDxmV2+UnjJf6NC8Xu7uOf0rYECNeuhgKUoelAqSm1DagSgpQ
	zmQrGtoIfPl0FZ3S+IopU2SkxHKDmtyGiXHdXEC17i+FxbmVGc97en7zdwYC2VSkQlyNXa5Rh55
	QkIgmgNIAcjQbcUzZptwDT3Q3zjkuIDUMK3xs5fB0s4TWN/2hVDINBewnYyMbyXGQaPWUAyLQMp
	CKsC1cTOkKTDU4uDVvlI8yXXeFAWTSCUcV/naMpjM8=
X-Received: by 2002:aa7:88c7:0:b0:848:760e:eb76 with SMTP id d2e1a72fcca58-84ebc432c34mr3475574b3a.61.1785442298760;
        Thu, 30 Jul 2026 13:11:38 -0700 (PDT)
Received: from localhost.localdomain (c-174-165-208-10.hsd1.wa.comcast.net. [174.165.208.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm3689108b3a.15.2026.07.30.13.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:11:37 -0700 (PDT)
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
Subject: [RESEND PATCH net-next 2/6] hv_sock: Remove check for old Hyper-V hosts
Date: Thu, 30 Jul 2026 13:11:19 -0700
Message-Id: <20260730201123.1767-3-mhklinux@outlook.com>
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
hosts earlier than WS2016 and Windows 10, the check for such versions
during hv_sock initialization is no longer necessary. Remove the
check.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 net/vmw_vsock/hyperv_transport.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 5405c2680dec..855b15971c35 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -961,9 +961,6 @@ static int __init hvs_init(void)
 {
 	int ret;
 
-	if (vmbus_proto_version < VERSION_WIN10)
-		return -ENODEV;
-
 	ret = vmbus_driver_register(&hvs_drv);
 	if (ret != 0)
 		return ret;
-- 
2.25.1

