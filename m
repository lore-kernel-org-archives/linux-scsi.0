Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140F1CCCBD
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594390; cv=none; b=pO+2gTPj3QGVuItPClGmONAPDTxwCG1BY9LRhWXG1/3IpA4HpN1c0bnKFoRGsXNy8K3VrjJx4esmQQWr1rDrFjCSzapWqLCg7B3ga68Fv8IZ8bLYS3IUksazvAPV8rKUeG/P4pt0LuNtHanRRgzLAaOO5vxJy9LZr/1lW256zJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594390; c=relaxed/simple;
	bh=PvrlveKPqs+0HJxR+rli0Vbc2GJR7hvNoa09VKw+cv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d9PCo1GHV8DLo0p0FK3a9ZLyIdHO4LTMyPvK60piMxjneAxOHEpdl9eF+HxcZvsiauvNsJl3d+aQtDnapqxeqBOPDV9t2eSibEU4bcpJLb1HSKyk0yrRGriFTED5yv1+gwdEF7EhmLV0jZrlbq3ADIYHT+n7ESLuMRaxKSf+9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L24hWGUm; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L24hWGUm"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3762c172d94so488095ab.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594388; x=1720199188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iy7iomoDBwwUT5KvVF8VDfkmXA3JUEiZ7ec1EpJHMSg=;
        b=L24hWGUmrROPAX0rdxA7OA4OJS6Xn1x41VSPIBnxSi3xqypZQkZNSUtQtjEe4O/Zhk
         rsui8bFebBaBVRmHLUVkA4vH+BPA4uWsycqVC3TKq1qJ5TukMJ1kBF2JpFN/ZPNz1BhX
         lyxPGThkCkdUodn+3tXhOEcgRVlSSwJKjBOgN6EMBz4t6K8OvfmDJg3oJL4fFJY3f9IF
         WNYShxSd2UesLj6IYQz92OfKf/NoX0aWmHd+Jh+gp9jyRAc0gcsv2+6VtFbRtuI+oX/t
         6htp9Ct0IrG5ZKW2tAUCY4RtNel2XzYssDw0Fd0Ng1xhXwuofgOLsTZOW3OD7ymlNibE
         L7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594388; x=1720199188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iy7iomoDBwwUT5KvVF8VDfkmXA3JUEiZ7ec1EpJHMSg=;
        b=noC6B3Qt9Rb4vwUSqdWKcgzJyshOB7Z0Wm3vWF3fMTppC28oKJ2txkCeXkW9QX09xc
         3f938fEDyvU8ukdKqvE+uHJWmrx8KPiAMCeoDtwbgZt4JvsVaOSHNGOtexsV4N6wvqAE
         zXfgjz/EU26m7fmZwX3fNUYUaJffAKA+o7dUyGTAE3HtB6Lh3EQLHLh9plcE9hmFkGsW
         IFvNHgugoGGtI2BU46EL8l3ujFShcdC/6q0DHSzseQjXXnHYb1twY7a/DEK6Xq05fYy6
         w9e/8VH6w0gGZFzSMYQJgyDWqlsMLjPmzwY7vxqXCSg4Sc1COZqCnBKfNkOKcxzJYDKJ
         WfCA==
X-Gm-Message-State: AOJu0YzE31RdX+Om4f+zVaoj1DiOCvLsWb3g6x2ydqLx6bY3cdSy0cFn
	wYW5UkJM+pNZxweH2UFUIPh/pUKYO9PtZDNAjHBKIfYIolYwBQBsVlFbmA==
X-Google-Smtp-Source: AGHT+IE0/Jhxedpq3h15I2UTPtjSXPnRB7d21sct0sEgEgE+5+pacELilaBpgcYkh7vw1eQIj1mp8w==
X-Received: by 2002:a05:6602:3148:b0:7f3:9ef8:30a4 with SMTP id ca18e2360f4ac-7f39ef8334dmr1849525139f.1.1719594388098;
        Fri, 28 Jun 2024 10:06:28 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:27 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/8] lpfc: Update lpfc version to 14.4.0.3
Date: Fri, 28 Jun 2024 10:20:11 -0700
Message-Id: <20240628172011.25921-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.3

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index f06087e47859..7ac9ef281881 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.2"
+#define LPFC_DRIVER_VERSION "14.4.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

