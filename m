Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1001D7E5F
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 23:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734045297; cv=none; b=fZLijRfDJb/mzQWlVUJh0/Xo/PcktJE2kKU1uYUmFTrW+DkSgZKHvvUm2ursPzYZ9ts6aUYcQdr1o20PlimYAME2jbSANpW+MnCuaHQ/sR0LJStFBQypU66w+dMQu1GOTCC13QZcSNMANgv2fmsFou94YMYtunsOX6pKhY26Cyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734045297; c=relaxed/simple;
	bh=yBg6p/BQTP6m9R+xHoDKNi6MehvglNHxhDCSFKvurTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rhTJvFiAyLkQdHzjHB0blp7N48YxL04fq1GYmyPdVVvhNdTW7dxupg2AFy65TVXWiGOhZIYMYE8NoJYXHSMgJMyl7A7IZRqg4gkhcGjW1cxkEw7nDvO63/0lkIzBtBVigoEGZZ4LzgLoOHzoEe6KRnP/vX+awFXz3jl7W+HzlCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPdkTqia; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPdkTqia"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2162c0f6a39so21943975ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 15:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734045295; x=1734650095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+c3LTJGLk/5jvIJlBDTWhLHuX0s7lJFTQZUxM6t9wYs=;
        b=iPdkTqiayWHuNnk9qMlidmPUjvGhvPjrBsOEdpiPbnILG8rkcwvwUxaWQG4xBU08Ix
         U8EgijFl6jhXmAdxeKj1DkXQ7A8P5y7NUNsYNc5EOv3TYuIW4QwvRyPhB+9HjdYVAgqr
         hvHEzSVv4U5l8BCHg3ENuzBa3YZbndz5VdKaijnuHL7ffgasAKgIDAxv5/6/rpCFak9c
         AsIpi1wDo0D8MfZ0LuT0WvyzPKoDkxc3O//tfzx/IWJDDNjlWJIyyq6HlWwTybT7+UQC
         yyQVnkVs9ed+bZ9bfPFuz1QYqVYpNTPriVz030NJt1Lg/vYZ6B/7FjLn87IIWILXs9v9
         xZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734045295; x=1734650095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+c3LTJGLk/5jvIJlBDTWhLHuX0s7lJFTQZUxM6t9wYs=;
        b=bPov4f6VPv/9QfkF2JL+sxWzmu+ne5U2Q1OZ0IW8AwQaxRJ2x5kpKOA5o1osGZydpu
         jZyv8IAReY2D0It6wWcHCrw0GW7DRS8WLdRbRl3Mvhr+KHRc673pwnaYc9gQ8f85NFsh
         CAh4bgzZLqnMqzcyo9a9Vvze25yJ5GOxn2UjWtYfj3CjPmOuOUo4jwRQsVHEyAir+VxX
         6sEdvFY3Prt2VEYY+6wIDpZrr6d7yWezpHnotsU1x9fgO4yyvE9h/WP9r6QUE7v/A0rP
         6HPal1reu0UcG01MOP/ryqd3b5qjLo2KBB05BIMncjhhOZnjfGSypaRnRI3m5FDuXhBl
         aioA==
X-Gm-Message-State: AOJu0YzXxKKeut1dgmaCtJ8wA6kPo7Z4cywRp2NuwVbI1OIG4DlJAshf
	NM8P2cpzZAPvD3+FvSeAvN83SHrbxoulk8oqZDFcKElmrbSwpCub2lFILw==
X-Gm-Gg: ASbGncuEF5VMfsnzhIMdaKeXLlLBvXPuTLOfNUHVO9wRqQ+pZHg1+v6uQ0DFtXrg/CU
	7MyRSlAtKmLmpstTAlv2dTwAw82twlw2rCzxIY6269SCChIsnIHWlqa/D58JLJHWo3SpAe+13NY
	23UbbcH9WgQ7NA0NWTp0r/9eYXrxvMU8yzvj/8wYd+jcBgiv3wT1DWSrMSXX2t38tmj+2jFoOnR
	12AkRG5QNnq6Wgak8XjNKwt5HaplwMiQtWJsZnJJapEdtFubGYqZxyHYhHWipmGzRL+Meb8NIMy
	J7YBFAMp+7FtP1tPDNmjJNP1B2284PWSwHtZ95Zd5g==
X-Google-Smtp-Source: AGHT+IF79JnzL6FOQNQmV8eVRl0p4VEc5Fb84TKclhnK7c4I85BEa6TnvyVCrDPW52/RLpQMlbZj/w==
X-Received: by 2002:a17:902:ef44:b0:216:4676:dfb5 with SMTP id d9443c01a7336-218941ea491mr4472495ad.21.1734045295289;
        Thu, 12 Dec 2024 15:14:55 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216325f51d6sm92727875ad.197.2024.12.12.15.14.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2024 15:14:55 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/10] lpfc: Update lpfc version to 14.4.0.7
Date: Thu, 12 Dec 2024 15:33:08 -0800
Message-Id: <20241212233309.71356-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241212233309.71356-1-justintee8345@gmail.com>
References: <20241212233309.71356-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.7

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 61fe1220f8ad..c35f7225058e 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.6"
+#define LPFC_DRIVER_VERSION "14.4.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

