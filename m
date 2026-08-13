Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA8935CBD7
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 07:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786604916; cv=none; b=Eowh/SSJsmI8n3MNxOTeB/y9gQI5PT0Skba6nWEQFh78Ztk1eIuY7/k09E2uX4FcykEo2/0Xw3asuadadze8evTzsQuaYCPN5sJhKtDT86/oAevp2YUI4x6VzXE43hVxxoGxdLxj/A627QFA3S/j+boFiZjnorf4p779Ui31ps4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786604916; c=relaxed/simple;
	bh=9LlZk6pVY9oRzBTK4VcviaL3zrXDmWeRw6oq30URFYI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gjLjzD4FcmaZiPJR564Wyn86SyQhpi/7Yjeu5R+Q3pRHKHMwb4sbWxU8Cb1QGx2eBKqOe66lnX6Zpsca4wpsvanvCxzsI9cNuGlI5sF6IutF8rFMHElHOi45l1ClGvXfcElM2t65irKCrMJO2KXGoV9CFnpgu8wxA3T8YMehPsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asUyFl0e; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asUyFl0e"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c15bf5000so1488181cf.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 00:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786604912; x=1787209712; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n9x2E241o23Uh70FRs1x9EQZ3vFUwK3mBeIpCG7HTJA=;
        b=asUyFl0ejc7bS2cUvtwVrsGU7JNhxFbj9Zxao4nTawNtIsGbeaNO0jU6UDd2FpMana
         lQB76Lwam4MmxcRGFw/68a8P2QPIqphevibvsjFOnY732/OPRjabtfNZqvMLYVRhKXWS
         hwmfM0GgxEaMrD3/PLrzcbyvZXutAcT93Gl0n5Ejl5PILq/uysqcm7yv3ICLfLCRvqfT
         OviLNhSgQIsXwwN3DzRbhbDQpebv4fa2cXomDUgaMCcBsrNB03/rmphqijJfuEgFanBM
         MQmxn/Zm8rDdQ7RqlqvIKItSeY27HR/Ssso0IN55yQCQQHn32l78xb8FjCAeCi6FLOGm
         duTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786604912; x=1787209712;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n9x2E241o23Uh70FRs1x9EQZ3vFUwK3mBeIpCG7HTJA=;
        b=biL4BzHm2wzJgaBgjvZ+Yei4atF3EQpLq0tZ2ck77Vpee9sGJqTle5AG6ix0egZpx0
         istUAnO8i8k8wddXb3AQb9QuYbpKoge1Pd9kdhnMSdwqok5Wu7TYvleO/cq0b/yExJx9
         rErCNaWndigcNmogXguUHuezTgB4o0A5PGfb+22rBk1cxC4eL5DNWmytuRP4c6z/kek1
         YYtvnpo9PK/8ErX3YNJwB3eUuSClJGAJ1uH7leaZLkePdHySNVUuh0uAipsNcMz91Vg9
         9uLWa+gA6HwHY/JTRdymJ9GI4HMCLgPAS3v/i2Nm0ZRAPD260rzUJoxKJpyh1SpsERkd
         9duA==
X-Forwarded-Encrypted: i=1; AHgh+RqCi/QXdrsCmZWvm1uGoux06fDt/zVkDqRdqRH8WlAJ+XY2SUTMV03MceoczjMDuDep2azExBuC8nrA@vger.kernel.org
X-Gm-Message-State: AOJu0YzdBqetWqYhZQTd/a8zaliiQIrN6G+Ghb/EXiMlEz04MJRtYeld
	noP39wKICegHMqIEXU5MvQRJieZZhd/XKCC6oYKjS7HtrzDty8KRU78FSsNfxTY+1Qn4ZQ==
X-Gm-Gg: AR+sD1258wFhSZ4h88o7Qz9MrA7foPqCqIPqeoVD/l+YZkkixtgdeN1JEi6/4xjjCEu
	i/XL1ipSwfdRQ329k1iK2ktikbXf2JCl5LOQpHsNCM0W7PTD8fgNsvhDx4xoSJaUDLnXaZ0bc0S
	2e9Vc1kn9EQ+Kh5475I/44woQvGLt5fnvyDkjNlyNqpifATaBpkdnDBHQ/g2NiXofg0ThBKPMeR
	OgPDuKHUJx//vx/zXt/ZSNgJRKG7tdnQqNIO4kzKSQMS/XYtPIKTiWNZxu0nbKpXvxMgf/6S4uv
	bKIUZWY1sjfDuBkYQM31+uKFvKkXW6qWA6livINLPQcZFLfw9sX5z3Mnzxc7WUQtaib4LHKXvdZ
	SvpTo1cV+6MknATcVV3IplV5zuefbsH8m2Shd3K7JPr80S+aoQltiJiG+0GupwsCeZtTRNBxZeK
	sBGKmGBSZ9zOSKXxhJf3rfRzvH4XLzWdMJTW8qtlA1G8QXAkqmyVCC
X-Received: by 2002:a05:622a:58c5:b0:519:efea:cf41 with SMTP id d75a77b69052e-52d73d93652mr37205551cf.28.1786604912341;
        Thu, 13 Aug 2026 00:08:32 -0700 (PDT)
Received: from localhost ([37.19.206.57])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d73fde516sm11008501cf.23.2026.08.13.00.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:08:31 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:08:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Fix an error code in qla_get_tmf()
Message-ID: <an1taxANE_4_vzJT@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Negative -EIO was intended instead of positive EIO.  The caller, doesn't
care so this doesn't affect runtime.  It's just a cleanup.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2b9a9c672ec6..0c4e8ce9decf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2302,7 +2302,7 @@ int qla_get_tmf(struct tmf_arg *arg)
 		if (TMF_NOT_READY(fcport)) {
 			ql_log(ql_log_warn, vha, 0x802c,
 			    "Unable to acquire TM resource due to disruption.\n");
-			rc = EIO;
+			rc = -EIO;
 			break;
 		}
 		if (ha->active_tmf < MAX_ACTIVE_TMF &&
-- 
2.53.0

