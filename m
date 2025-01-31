Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7211C173C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 23:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280719; cv=none; b=kxDdNNnXtAcdd5TfapyhPcyq1H6M6POk7+1FEPyVcJcKmH3S3KbQwqGyIQxyW9Css4JBpXnFF/78d9JWDqZpGAQjj2mgY8ZnRr+V8IJVRdyOSZsd1AWEpv6znI9xxad0W9R0NpyTGxqn4PXmEBGTu2Ns78A6FaH/dPfBb5FP84c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280719; c=relaxed/simple;
	bh=ZMZCfZkqKCgllEJ8QLDE/uwjSzo5RLgQ2lNCHjj/YBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gdw7mUHkq23Y6ywwFR9Vg6nOshjxACMgOMmhVI85TTx8Wz+TKka9jzKxcCzJqq91uK+6ARpS+1NZjCC/jjCXtRwwewG8lrcePsOdu1q5YIKYf2bV1U1jR42llSPJ6RVGGPh8x94NLo0UTgSOu+Qp+bYDpUnIEYiy7N+bFt0nT5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3JkFwQe; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3JkFwQe"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5fa28eaa52cso782992eaf.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 15:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738280717; x=1738885517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daOSnBEGjxLGqhRdU7MOJbCe1fOkLUR5e6WYSwXMpG0=;
        b=N3JkFwQeYebdgyed27dD0x2kTdFMskN79OkO5a56M2p6839T6dj296fKrPc22MFHSB
         Xc6harRPivIwMXIXCv5oKWW/y880Jw8O6g0b9Pi6FRkE/rO77LR7my7ZbKxPALzW38pG
         bQGYKBZKnmi4zp37dE0tv3vsXWmeF+JtSJAWaaz+olRK/+ZnCwXwTeoMqmHW/PEy6zSs
         hnMHrluCm99det3pml6JGHrTCdkUa7zOKxaglTYylpMUrId6Yj8IN1GivHt6G80vSsXa
         W8Ys1uhSymfWb4ThPzOu3hzrR8oy2FDqKVIMMkr9mKKQxDXDJcGx+RHW4+9jVfODcLv1
         CXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738280717; x=1738885517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=daOSnBEGjxLGqhRdU7MOJbCe1fOkLUR5e6WYSwXMpG0=;
        b=gJKuWt9gGIzVPtG72BpRwuMcBnp+he+lbjggQK1yiAXADCR5v6RsGm55+MvGMrz9zX
         2+8WwxVfSSQU0+9VWeBDnmiskrduVqHWaJpanXlgCIrMIZ6SepzoI4rWSUr6mgSHbquU
         cIGjvSl897xRZxo3vzJ3+4DlZMhGxzLD9+UMyfmiptEn9d3SgFW52eVpZEUGIbf5wxw5
         l2Luj73EwOnWFJ+GSZvnYsQ0IGdrX4XXRbhTBj7lRhRaLt/uyjEChgZvMZovh18PdlPm
         wEL3op9jJR0ILOREziVqdJUkp/URfeYiG0ROe3qkMDMty4YZX0QexGbktZe44kQsomys
         0PqQ==
X-Gm-Message-State: AOJu0YyvksOu3oA3nOa0MuvtpVZQRiAm68mhDyKkJF/zKg374UC9f6uT
	d4ZXinFitbbpiaJr+w2TebiSdu0mQg6VW0h/ZGi8V67+5J1EDENXaz/FZg==
X-Gm-Gg: ASbGnctWnqwdFVQcvCpd228bAS+EBQ5ypiN983xuEkqK1M15hjk3D/62OZSHfolNJBn
	uLXoPLbZWLTJypFavuJHHKrVw5JM4pmjpSvFAC2jdEiA6rKG3wTNuvB7smyNjfSbWq/GUUN5NJg
	Kgqg7O3Io37id7RGwr1UNIvQiskxMXEONNjg11Raay3uKFWstCjHDhNB+rjfdeXiLfJ8vec8vjp
	+Ui2qA/Lh0KjF9nMKQHaYRyupmZ8wlIMoeu/3K/GvEHgdRgzBvzEvIxuhgDyeZmXir74oih7KvB
	6r/atQFbOI3wQu5oxMAjlA6KOhKRQJFugBwHw8Oz5nkeBCMD5b41yUtC+raMFz9eTbOL2DL3Lxe
	Q
X-Google-Smtp-Source: AGHT+IFK9P8Nacq0c7rM5dH6m1Z0SRGA+uJXsPLAmTZY2Zl21cJewG1dNPUnJlMVThYSlGfGy37PVg==
X-Received: by 2002:a05:6820:1523:b0:5fa:8925:3d76 with SMTP id 006d021491bc7-5fc0025fd1amr7072275eaf.1.1738280717158;
        Thu, 30 Jan 2025 15:45:17 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5fc105d8a22sm517609eaf.37.2025.01.30.15.45.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2025 15:45:16 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/6] lpfc: Update lpfc version to 14.4.0.8
Date: Thu, 30 Jan 2025 16:05:23 -0800
Message-Id: <20250131000524.163662-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250131000524.163662-1-justintee8345@gmail.com>
References: <20250131000524.163662-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.8

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c35f7225058e..8925b51910b6 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.7"
+#define LPFC_DRIVER_VERSION "14.4.0.8"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

