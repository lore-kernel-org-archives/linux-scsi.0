Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B98EBA37
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2024 02:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712716321; cv=none; b=a2Ue5g3IUXzp0GiJTA3VDju9wxDXlbEIsMYr2GJ2NYc2kPnGgt75eJGGtI/MJ5anJFs9a1XXcMcpuf0TgAZAfi2bTaEcWJ2XYq71ZDxO/j/q3C268ZL8AFbJ/HUARnPfSfnrhMGLqirYg4x4tnqlvjLa2ly08xT1C+mpx7SlurY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712716321; c=relaxed/simple;
	bh=wOiV2yfTENWLRGydHWukSXwdaF1bD6b3ubfyN5UQxMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V3BahLKt0Des113WP8AFRDZ6yDbhJ7s3Gwoq5EzsfrqMyIzCEUArJjJwSoA8j2I6vioqRtX99BKKkE/UPaqnYFYO3ZOM4L48B4CwWyYQAwtoQDmt7WQFzUCg4qjmDbtxhrgyHQiiseND6fPaHlmtsbKv1gf3oubzVED5Q+9BMCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dlV/75FZ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dlV/75FZ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e424bd30fbso20064295ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Apr 2024 19:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712716320; x=1713321120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6X8WYL7fXMONqNFFELPH+FGxt8D533JimXjm1OqHfE=;
        b=dlV/75FZDkfL8NtgnkEK3zWH5uTbet9pNBEktSugJ0hvB+cOHj8UwlYWQbHy4s+a2y
         L/ZgOwkLOozi+tFwj13epg4QQEoSkPuxmnZwQtvXJPUbPz2LBGGOYPTBOFlBQO+Eju2D
         UJmDWzoSGPH7C1peLHOe2XBI8FvMPdQ0ONrbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712716320; x=1713321120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6X8WYL7fXMONqNFFELPH+FGxt8D533JimXjm1OqHfE=;
        b=pknCUo2oAqQJc2nP53KY5NZmsO9lk8mF7ZoX7R1LUmGHCyi9b41iGVDq4b8DvhueLZ
         YKP0hclA91oDi7XWO+35yi0W02ZJKl0q1TuPb8wA0YorhERXVetyMsibCpuzeF7UCyhM
         DWgkxSsNc8+OpBlj9soZGWx3DoASD/lfvkuThc7+Pep8NaKUsv562u5imSP4cP9CwVj6
         WhflxAhZvl5ZiOiC0PT/2jqW3NmP7LVVh36A7NTTN9Fdlax4metO6WhEN/vjDlM2TNP6
         teL85KtQ1pNlxdc2gRxDMRtmnCwR6n5ACz7HCyNakMTVhFpUxSdxke/0eXK9jhIS6Jhd
         H0qg==
X-Forwarded-Encrypted: i=1; AJvYcCVzlNCaGja7tzx1TQ03jkS+MOyFti4AEQX9Ep8YK62i9+oqcob0QR4FPK67tjTu/5pCIJaJ9+8G5L4VHJxt8UF1B4orkKbuSQsuBA==
X-Gm-Message-State: AOJu0YxEBmF/AkXAXteP0mwlpPPggeMjEAa8xWEkVxcaTUiqA3IMcuBX
	WUARybErCM5c7/QHFCN1RM/MLxXscN0uddr1p/uq5wr1Q8O/5x6MYbyQ9K0ghQ==
X-Google-Smtp-Source: AGHT+IEJI6UyNneK9SdMEc4oHZG0B61XTOkfsKSOPKOyL7mCh8bSG+wOr83riq+WpD5i+5tSc0uekA==
X-Received: by 2002:a17:903:11cd:b0:1e4:b1c7:9a7a with SMTP id q13-20020a17090311cd00b001e4b1c79a7amr2229577plh.22.1712716319727;
        Tue, 09 Apr 2024 19:31:59 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902d49100b001e1071cf0bbsm6453240plg.302.2024.04.09.19.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 19:31:58 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Charles Bertsch <cbertsch@cox.net>,
	Justin Stitt <justinstitt@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Andy Shevchenko <andy@kernel.org>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 4/5] scsi: mpi3mr: Avoid possible run-time warning with long manufacturer strings
Date: Tue,  9 Apr 2024 19:31:53 -0700
Message-Id: <20240410023155.2100422-4-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240410021833.work.750-kees@kernel.org>
References: <20240410021833.work.750-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2372; i=keescook@chromium.org;
 h=from:subject; bh=wOiV2yfTENWLRGydHWukSXwdaF1bD6b3ubfyN5UQxMo=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmFfoaOu7l1waaK4FQgneueH0+sHylFwmR30Rnw
 irc5WiWS+mJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZhX6GgAKCRCJcvTf3G3A
 JuqBD/0aNjp+oEmj3j6I7sA8SUQFNKh6JfV/vEkMWHazs0KZ7epk6NGADFi94OJ4cuV+UpObs33
 XdDhWdBGcLn2wHww3mVMp9FJb4wNdQpakLtRGDWqe5TFnSsww/KaDz/Fn/Z5q0AJULeOzZx9g2K
 vq9x87rN8jftZpBBvwsyJWOWQTqhqKdq1fGs7BD2D1BhG4dODBImgCD+Q+mpsaTB9DvuB3rGFNy
 gNkf9XgfrExDmJ8NmnbQhinqyc90rjZnIY8WNSR14gXLOdF63G83KE+lEqnVZ8eAfcP1kAHBI2r
 WPorcRhLLYv2hQm3hT7gX5UJim+X4BzVtKpkfc7mMQu4S0W8OL88MNp0+Ve/36sodn61bOgahYg
 xpiT9iU5DnOfJagWv0i3oa5uf1LoVx8yqoeffTlzzBH+YWFQBiHeD19ixC+PpOfj+jcaStLV+iY
 PlTiLmzMtz/L4FYH6Q966l6Qwhq5O8un5Gg+RqFkxBx1y5bP09JMxahmLL/yLykoH4EfklPHVIF
 C8PHlUG0XRzpQGxqDOLG8gIc8ifaYb0H5oRg9BMMq5ymAaFMsUdKbeB6VBU0hf6/b28hj9bpW02
 ZQbNSpbuRCl6IQDnWP0OixUHzM4l7mgT5hjlUuqXsdep0o2Vj56Zw/uFcewnqeXya5cQp1mabaT zBjzfoS88J/NUfA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

The prior use of strscpy() here expected the manufacture_reply strings to
be NUL-terminated, but it is possible they are not, as the code pattern
here shows, e.g., edev->vendor_id being exactly 1 character larger than
manufacture_reply->vendor_id, and the strscpy() was copying only up to
the size of the source character array. Replace this with memtostr(),
which is the unambiguous way to convert a maybe not-NUL-terminated
character array into a NUL-terminated string.

Fixes: 2bd37e284914 ("scsi: mpi3mr: Add framework to issue MPT transport cmds")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index dabb91f0f75d..3caceddb864a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -211,17 +211,13 @@ static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
 		goto out;
 	}
 
-	strscpy(edev->vendor_id, manufacture_reply->vendor_id,
-	     SAS_EXPANDER_VENDOR_ID_LEN);
-	strscpy(edev->product_id, manufacture_reply->product_id,
-	     SAS_EXPANDER_PRODUCT_ID_LEN);
-	strscpy(edev->product_rev, manufacture_reply->product_rev,
-	     SAS_EXPANDER_PRODUCT_REV_LEN);
+	memtostr(edev->vendor_id, manufacture_reply->vendor_id);
+	memtostr(edev->product_id, manufacture_reply->product_id);
+	memtostr(edev->product_rev, manufacture_reply->product_rev);
 	edev->level = manufacture_reply->sas_format & 1;
 	if (edev->level) {
-		strscpy(edev->component_vendor_id,
-		    manufacture_reply->component_vendor_id,
-		     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+		memtostr(edev->component_vendor_id,
+			 manufacture_reply->component_vendor_id);
 		tmp = (u8 *)&manufacture_reply->component_id;
 		edev->component_id = tmp[0] << 8 | tmp[1];
 		edev->component_revision_id =
-- 
2.34.1

