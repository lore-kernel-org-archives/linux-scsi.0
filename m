Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388A84FB9C0
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790776804; cv=none; b=uWG0oNaEXvWbQk3xjQetdYj1/Lre+cV4JpzW6L6DlOAi4I53wgFvMurCWNXaADvSCUICAzktqO252ni2xh5Pz96aguc54tpDrFhTjaDgTdX9BNIOFjLS4/bFDg5NOfdBMlPuS4+IQ1g4K9tsCglsy00RrTN0Wsw9l6tm85E9YOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790776804; c=relaxed/simple;
	bh=7xCBHb06wAnDpFFA66OoUSe2oo0M+BmVYkxhUmhENsI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GLGoIAtwBlaB3tjH3h1tF07s/I4a6TckKceN2eO5YCjFSCo0v+MOx+NhX4SedZv5EWT6V86FXd0hb3Am75/dZPCoWrB8p437Y9Z7IVJ3hnWpq3tTcRTv/xvnsj+2GWLSnqOET+3kZO9htZ8Ll3yLdtHL8nIYPE4h+SG1c/3lAZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WF75rtx/; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WF75rtx/"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-86261e66700so4039438b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 06:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790776790; x=1791381590; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gPgPKBbr/ny2GVIIGOROpYD1joItJkDdIDRxnCyhbVY=;
        b=WF75rtx/jp/1AFtQ8Y01pZXTLGJjsG6F91AkfAcw671m6PQ+RZT6Vtb5CM6p7TDwaX
         DZeh0iYakPE5t45HjL7bTqQvK3eetBEobUAAK7UDNZx4//+zo8MI2Z6wjDH7hmiIDZ39
         31vMU3Iz0K7LxXS+oqpV5EQqoxeGmISZAy6d5TWznbRjokzQAN3G/59wxiAe4bktynmz
         adXQ+HoaCsV1XTAL2MQ0yZIMUkuAGbRL8eX81N3jhfjtsfza5NjfwhqgdjqrnXb4ktni
         Id76sIOEQSqd6+ippqaAxL+p0fTe6Zey8bF5Du/V5yzl9FuwHZ4P+5FhQ6gbam7nQIMx
         vyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790776790; x=1791381590;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gPgPKBbr/ny2GVIIGOROpYD1joItJkDdIDRxnCyhbVY=;
        b=b1dk1d1fbcPqbPGZBdfp2UH9mbP/3URV5N+r+Lgtqw0TWRTT1vgFIUaLFl4pX8xkcY
         DgppJ93v1wA2aSY724NMfZFt82HQ/a5Rw+FRTu81lJt1NyLiUK+nHOFMWDroCazTC2zZ
         HKAniqWoYBU0pzdLglOiQlQt0w9uvAKcW2/SvCxiHO5IgICFAkeJ4kfa9kn27pvHUu41
         ryolLBVSndzPUu9DhbprqNXBnu+a+W3xaQHtwEa1aaP8lqUu8w1fE3Q2rOR47hJaeYVy
         R9tiFwt+yzzNNm5lKu+zrKD2mHj+ELkdEysphnztsCsnPUC/cNpo+Qd0mN+MFNXC4ZuY
         q7+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzM4eM+ZfEGdtz1VfZTf/q1qSHYb/BOjwoibaePEEHxvMcOPiglnXJx8wslpPdU23SLRjstjljgwhLl@vger.kernel.org
X-Gm-Message-State: AFuF++l2f9yTCX98NmqlGbzJoNkq2W8k98JebIY7W0I6Zb7tp1mEFf8N
	JyA27vWCzC4cbgL/tuUWGYURSufIcWb35llyLXb+0d8g+tI3JvzqmCUNFimRqLXW04sg4czD+PX
	b7C+qPRa5BciSpeCLwQKYYQ==
X-Received: from pfblu1.prod.google.com ([2002:a05:6a00:7481:b0:883:42ce:9d90])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:9296:b0:886:61e5:cfbd with SMTP id d2e1a72fcca58-8874c8d331bmr1062690b3a.45.1790776789171;
 Wed, 30 Sep 2026 06:59:49 -0700 (PDT)
Date: Wed, 30 Sep 2026 21:59:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930135947.2339918-1-stanleyjhu@google.com>
Subject: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@sandisk.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

At Avri's request, remove him as a reviewer of the UFS host
controller driver. The listed wdc.com address also bounces.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6215fcb07770..7b5c27c68e5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28041,7 +28041,6 @@ F:	lib/union_find.c
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 R:	Alim Akhtar <alim.akhtar@samsung.com>
-R:	Avri Altman <avri.altman@wdc.com>
 R:	Bart Van Assche <bvanassche@acm.org>
 L:	linux-scsi@vger.kernel.org
 S:	Supported

base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

