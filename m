Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9DC1CAA92
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758535033; cv=none; b=seOqYNOVI2R4w2ju6CBsHXzLwZFLWx4AkNaVX4Ji0BnmwtqNHtGq3BpJ+B2aXA8IDpSHq37aPOs6WZs+xhQJbu+ixL7kJstIuFFJmckFsequSHgEyY2+RDhIOsnnbhNQNO6fLnjiNS6rOz4N4X02Kw0fby0jeJadDCglHLEGizc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758535033; c=relaxed/simple;
	bh=/QND+t/HIU6DQdse8jPZCPhqfTGQuWhb21QvRlgMSn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw/KJ2DF5RatxN/pXXQViH7ObVLmfeGij2PBfS0TrD1DTMtvcu3tyb96AaJ1J3SX4ywSYe76MmsOR+H9LAvejXSK3ahTnWEHCyX/hlb9pH4ExAzAM5UvkkM9nEVRtcfRe8/FuFvOsZuDIUn8cgkltlYDKyIFun6IZbzq2cSngEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cd9XIaxa; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cd9XIaxa"
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-4256ef4eeebso13871185ab.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758535031; x=1759139831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2FqRGuK/kp1NSW3uC/+D5X2ahuEwjMfDFbYzuX5mT4U=;
        b=h+Zoq0zG03cmRx8SoIo8nI9Ht70w+9OZNmFndiTRF6YNajirNUsbP8VSomwKb5E0s/
         74l96QJty8EvanDOz8PqBr8OSgZwA9L4eleKYFu1YTut3/1wlqF2vrrAAPmoPyaFhphF
         ijDkNPPe3HZ5/C3AczXikerICmlCD5IeFefv28Ukl16AgbfQfWmQiRn7I4Ls7LUYzNVl
         YkJtZ0GeTjc7imvELT15z7E681Jv4l8pW0MHO5T+ZaJtNWQNFBoFl63syX+TOgudI42i
         sOszpUlFP4gGDwdYnGwYCdhcqZqOoUaMiRgonc2oo1c4XCCEbkj6E6x7TvY/eQ1HWo1N
         GThQ==
X-Gm-Message-State: AOJu0YxqlMylIPzgiGAnuUTnztuG1t0o4KMlaktOunIhV7Jrethfwh13
	TgJxu0NI9+EwXrUpz+uCen9tqzIznhS3COH1eIISQf1+16VtdEFAf7OuYPMHqh+IUadRhfHHW0J
	a2FaMInr1cm8QJXQexP4j238RUnbnh9WfOaqECSok9nsI4DXm8QrBcIHsGRdSN6Fb+/d1VxlZqL
	lCwM0KzbEMOHoxqA8uZ/7iRui/vFFaHxVRTnc5jiPd6I8Otgatj6HQN51ZQ//QFmuydBbBIy4xK
	jka8UtuFfhzFeWL
X-Gm-Gg: ASbGncvVphC/9ReR8iO+CAP2wke2fJPg+3lc62MRl4vWWnnRG58XRKXVIRbl1tjKNuc
	jCmoHdn4X74mmVu1Y7H6vI7z2fzVtDg5xLcK6Tz8GlRc+6aepCBs9bRD2ZQAQhET5DkwvKM0z+1
	iMcSOS+FE9QTtXEjWd61eXFv63VjCA6ZYXPrsbAs0frnNHYEt26SRvVthjM4984Fhz0yKhIU9i1
	HU7ud+VV+yHgn0ZItEabHgU46XdR5UrgYs1sIbTyDRGSv+r3OougQI7uNSXJUYJtvGO772KgU3z
	2eGj7y3z7aO7L8ECH8Y5d6EnF6mdue5YrFvM0xMfQCMNlVUm/zCAAn68IFKS9K9uAM3NqlbVQNN
	cYTMPwYwRTgdjnqGsxcsRmYfRXkBSg8IuI/vK82fdWjU1V/stuSVTvT/HLkmvvqBr0cyn0qYBeP
	Cc3Q==
X-Google-Smtp-Source: AGHT+IGlnpgzp7exjCXPd0xBjBgaen9dSSOF6dxSw5SiZSgPb47qsowoDhleWe57v4nvMZcEEJVJlnAFEDAV
X-Received: by 2002:a05:6e02:b48:b0:41f:8265:4100 with SMTP id e9e14a558f8ab-4248199c677mr203513715ab.18.1758535030733;
        Mon, 22 Sep 2025 02:57:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-119.dlp.protect.broadcom.com. [144.49.247.119])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-4247e4fbd41sm6069225ab.40.2025.09.22.02.57.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:57:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-77f18d99ebaso1651296b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1758535028; x=1759139828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FqRGuK/kp1NSW3uC/+D5X2ahuEwjMfDFbYzuX5mT4U=;
        b=cd9XIaxaeXrZpDoIJZsLwlAQKE9UGgBEBp2QiY364TbcaeBEaPyFCEC7dGCQLB4EX9
         1rGZFAC/9NNrV/APmsjqPUmC6sk5w67t597toRK0atPu4BhEwzQecod2wdklahBEW98Y
         Fw60v6MIb+xJ7Rx8B1k+gizQRHIoNln3p7XD8=
X-Received: by 2002:a05:6a00:348a:b0:77f:efd:829b with SMTP id d2e1a72fcca58-77f0efd851emr10193239b3a.22.1758535027923;
        Mon, 22 Sep 2025 02:57:07 -0700 (PDT)
X-Received: by 2002:a05:6a00:348a:b0:77f:efd:829b with SMTP id d2e1a72fcca58-77f0efd851emr10193219b3a.22.1758535027452;
        Mon, 22 Sep 2025 02:57:07 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f4594a76bsm1034584b3a.62.2025.09.22.02.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:57:07 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/4] mpt3sas: update driver version to 54.100.00.00
Date: Mon, 22 Sep 2025 15:21:13 +0530
Message-ID: <20250922095113.281484-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
References: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Updated driver version to 54.100.00.00

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 939141cde3ca..e6a6f21d309b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -77,8 +77,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"52.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		52
+#define MPT3SAS_DRIVER_VERSION		"54.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		54
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		00
 #define MPT3SAS_RELEASE_VERSION		00
-- 
2.47.3

