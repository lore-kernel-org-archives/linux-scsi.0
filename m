Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633CC2F1FDA
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607466; cv=none; b=YdcP+ZNFzxs3cFNXjerzrPJ31XZ3RprfdNzOWBOSP1xS92CZaCPqp0XB7PrXGSqXafY4abF8891cjLsMveDA0EYfhR1cTV1L/sZAhQqN2WWT4/MVyoTIEc1S5fznwIz6GuzdzfOcI1CpYjJTdlkAWVXrWu/ivbJa+GbJu432GBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607466; c=relaxed/simple;
	bh=p7X6MBPoflUqkFR7gWj31Wmxn4fz8Mi/PNGcug2X16A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bHOG86BT1dDh4pLAcQIzrd9q+sDfxr8Gzl9iME3TBWhs1qRH+vvA7t79z3U7fQA91psmUzVsPLkBz4Scu8uD+Yjerhc+47yMZC2Q4mcKbX0qXgWOFMArho/+wqhJ9Yl2/P+6ujnXR1FWPx17uUM4jXpEpuVh6hDZuszcHoVXpaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+vLYCZR; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+vLYCZR"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b67ae7e76abso4039271a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607464; x=1762212264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mQrriS4SPQnQ17D+O73Qcb1oB2v7CEu1S7xgGU48BE=;
        b=M+vLYCZRreRIIBmls1aaDk0ZXqITRyuZBxHrqz1vBQwgRmvDBDbQNr5YFn1SYb615k
         c2e0vZ4LHqlm9nkvl46O5Wrz198JTNt7FpcqkIPbO4wIYZPEAY1bNM3WnnIpAQV5hWJW
         GV2kXMdtY3McuzXzopRsHQLIlbEkSi83FLRSunuFk1u+/Xta4OVxz+5KsmDDK5gwQcAu
         4L3y/5Rst+mQrQAZWWAxvDontI0W3dWVw4bzAW8oV2sRxnEHHqetyu+ol1cl2ysFn7rr
         LilmATd5YWtpqaIbfFhT25XeTYcEVxT3SCA7aD6znNMOLBZzJony9FpeBGbTo19Kl94L
         MNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607464; x=1762212264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5mQrriS4SPQnQ17D+O73Qcb1oB2v7CEu1S7xgGU48BE=;
        b=Wt8DR2FgEqofU5gKL3buZg0TPot2zlec1olYmPBcXPgUTgVsKxIohJpuPhUohIDTLR
         fMb2CYyniTaheh3scOaTceBkK0wIhrFa2XX2Hj28gBBwY7cKWV+NNntRCHgKPlB1VouL
         o0GPlHop1m8M4PYc2UrpHJSZcevFOQwibXkw8yw8ON+76BKV5dO+/FywmUcW47n4XCZw
         c9nUTHgG/r5wvErccb2tH23iSU7a5KeC1c1zNvrQdRdOj1+Cy6oGELHvsIkRtqkPVSyb
         dZNVslGxGqMWThromwzIdRUfBVcf/iggegZ4rZbFwdfcOn4za48ieXI5M1ci+ph5QrT4
         SH5A==
X-Gm-Message-State: AOJu0YwnbNz294IW6SlyiwheOnltc/72WnVAQbvyex+MRIKI7K/HZynA
	Qb0PnMvoAAI6apYxIUD/EICugnxiy2uf/mV83mmPOUrtCLRsqInBzDvDtDry/Q==
X-Gm-Gg: ASbGncu8De5zxd3BtFF/kIZd/wxAvDw4xdFONn/XHxK+TzdTmOh69/Gv3nFI5aUHGFx
	L8owmXDKBwH70/XvoK5DjDfnYCUmwpHX+bLkRMDl2vKjWuYILzBkmxpf7nb4B7ZNtAznCc9b7HV
	3b6zUD0u8YZ/evaLYMU5/PLJjV8UVRWT/wR7GAqh9n3YAezsdrF52N9MS/ULnak4i02Xb/KLdNO
	I6qnCrz47wX6NQ4U+pmLQyWQqV2n3/3LdWCFbSvgxTSi+1cFCMvZ3BBYXn3G+T7JCV54Q2xp1bV
	fFkGC7oGUdjNeteVLZNN6qsX4f3kft31BtIf0FUplFlDoks9jMI/1pPFYQC7T2krv1pEdjK3Pvm
	/UmrJzpwC/zoKB6QO+KbxwHyaxhhAkX4a0G82TX+SsGmn/PaR8Ak4qwxA/O5L2zqcL3lu1qqJoD
	ZxDvy4zM6w79LqWpSQODixyRnk5O/HnC7bgQn1Q9uDaSyhlieYEYU36SlZFFmR
X-Google-Smtp-Source: AGHT+IFr+4ye4FHIQU1ZHoazWNKzChA/hhBgi8K6GCusJX5QWO62GJz8sFH1wqoM2yjAVCo+37FqYw==
X-Received: by 2002:a17:902:f602:b0:269:6e73:b90a with SMTP id d9443c01a7336-294cb379df4mr17122795ad.15.1761607464380;
        Mon, 27 Oct 2025 16:24:24 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:23 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/11] lpfc: Update lpfc version to 14.4.0.12
Date: Mon, 27 Oct 2025 16:54:45 -0700
Message-Id: <20251027235446.77200-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.12

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 31c3c5abdca6..f3dada5bf7c1 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.11"
+#define LPFC_DRIVER_VERSION "14.4.0.12"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

