Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C9218C930;
	Tue, 25 Feb 2025 16:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740500042; cv=none; b=NNq8kJzzZT74K+T35O/FLEtSNtOhKNJIwwxJEOKaC4nDFnXHeJmVV9VfZlKca+IctXTwAcDdsPhxya+ogBbNH3iHTTxCKtrUdMwwZYEBSh4KHj+ezTWkpyVSHy251FzfPRE51SHoSTh+wpd7/PrLc8pvNwoE78uCCdwKqyvqLDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740500042; c=relaxed/simple;
	bh=QFTbxmMTthkctu4tV0CojyuOfRzetFKnNh9ri6aKSLY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YwO2RXngaKUsM6tHb23ryCFiE1R+tVu5YrNjAzJD0mzDtAEVaxwFyZo+3Ze7UPjNEnr7m/zNEesECe+7v/t090b3vJGRMSCVbW3dBy47gwHU/vttUNEhaMG+IOLYPWq46D9d6e73J9kc4laN1l1FWjucACXvD+6uKIXaQEDVIIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k79C2Q8S; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k79C2Q8S"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4399a1eada3so50798495e9.2;
        Tue, 25 Feb 2025 08:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740500039; x=1741104839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YVqC1KYj3QeFyojAXvM68gVfAafK5PNiYMunoZclccA=;
        b=k79C2Q8Sz+4acTO6HyIOR+PCGa/R1169vPvkskAlTS6KeNEf7NVhjrbcA8a7MnsC1J
         rgDSUhs10q+XSf4I+4ucq/iT0uTxh6D9Pvi4zDoUNhIRUPXTJuggNIxzMveE9coflp2n
         agAcMnNJejyZHDGm2gLqWzSQKPAkqQ6PeV5hN7ysYqnRiFUdVL+6c6TF6eGQsBnxx0Vc
         TJVX4U5SvFLW1z/gsWS0mHe5gr6oKZaBTQWgCg5qVAQ8h5XhdXjEW3u6BtZw3pf1+vCy
         XFd8RgYCYJPeMidps4B2LY6pc29kYWC6q9pWDJ6GFPnqdnym2ZLWKapbtLwP7Kez36I8
         GlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740500039; x=1741104839;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVqC1KYj3QeFyojAXvM68gVfAafK5PNiYMunoZclccA=;
        b=iGaL5TEV+wsWAxB97h5jNhcddArBx71x7NxyxwkJGw+zKtZhRF6ziYBJLU9V7ZfodY
         KNJipGGahLq1yFkTU8HXCjhLw2myGIIIIkodg3ObozUz8kDaZ36PLhJCgs2CoB6VKptH
         fq0szww36RU27780iAeBMfO0vSriCYNSzC7Oyjivdb7ihlPIIWzQY82muaPpsr3jPCee
         iTJtTOsxeHBwg2vlw8Rk+Gq3RmAxGbOtg6UCUZn4e+T3j1FDDEiEqSx+1mN+YIDSHhrV
         0bE7t0f/gW7YfiJ7q29ZlqDqaYf6+/t8HbF94xmPj0XqFawYb1V1hnVoqk/D90bNCEh1
         huYw==
X-Forwarded-Encrypted: i=1; AJvYcCUk8RT4oVCl0uZSlavEh0NjtEz7BTR8YCGZLsp34OBIMdX61qs2b3ZIK0UAA8fHTacECvJG5O+otI41PXU=@vger.kernel.org, AJvYcCWHzZOi3fM329tmEWL5fzliVmo3Cvm1S0IYPOtfuwHLU51c8o2ju2MuJafNyKAPs1D6BP8Ln0KzrGkpgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqcRHYtpqf+jrui8AlFw/fWD9491gbz2BGomU1/VX00B3r8VXq
	4wDL5POVMOP1U0P1ugyKV3fFFG7e5DNA6ZFvnWhqouvkYHrTBH2u
X-Gm-Gg: ASbGnctDkovPMD2/GATnDw+KZzs7Sv5y3s/o7EcWXOHDhrLQASeOPRDJjyanCjuQ9kx
	TdEH33tvj+gZ7LjXyZsbHY0G8nSrodWbqvoSENMmm+dE3iY5V6NH6QXK13IUqFzm0s2sHO9bXeo
	gAaLt+H+EKjywsWPpLcU43q/GVbpB4f2GKapBfsUgDApuQQxsvMtr1LMmY9PZRyhsi4L6yG3bdp
	JR3CPe1N7AgLfGgHfio5GDowryocSF2F8PWVqe+WON8QsjK9BH3S6r45D/3AbWknRwzAXwGyNjy
	zTwh73H2KNWRVSFjqev9VGTyF6I=
X-Google-Smtp-Source: AGHT+IHy4xy6/HN4dy/+/6JzfHC644RceilHrzVGqkVL0BnSOX0fmHA+U1810SLzdXoTSnHtfBg5cg==
X-Received: by 2002:a05:600c:a05:b0:439:30bd:7df9 with SMTP id 5b1f17b1804b1-43ab8fd7947mr1252705e9.9.1740500039281;
        Tue, 25 Feb 2025 08:13:59 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43ab60c68b9sm18126425e9.29.2025.02.25.08.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 08:13:58 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: scsi_debug: Fix addition of uninitialized variable len
Date: Tue, 25 Feb 2025 16:13:24 +0000
Message-ID: <20250225161324.184873-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is an addition on a previously uninitialized variable len that
results in an undefined result. Fix this by making the addition an
assignment. Issue detected with static analysis.

Fixes: 568354b24c7d ("scsi: scsi_debug: Add compression mode page for tapes")

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 722ee8c067ae..f3e9a63bbf02 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3032,7 +3032,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	case 0xf:	/* Compression Mode Page (tape) */
 		if (!is_tape)
 			goto bad_pcode;
-		len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
+		len = resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
 		offset += len;
 		break;
 	case 0x11:	/* Partition Mode Page (tape) */
-- 
2.47.2

