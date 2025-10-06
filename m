Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC9826CE36
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 17:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759772834; cv=none; b=TXnFcv9hZtLI5ODj0O4jbkgguHOZG2OrpqJQrBZpHBWt/1STOpLPUpBb9UWLN6uuWf4puqdkKDgRvRCVamamGKqooCkI2WQJAfj7AnllxiDHk4476oyDNIYFXZ6DO66KIIkyQsWwEV+ex6lW4M0kaGVV4H0qHC1ngimGAXUSYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759772834; c=relaxed/simple;
	bh=RIiagnyRRBU18SYukiZhday7InM2c8S8PNgxP9C7a14=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVFNgSz2Nu6ix2tOBGfC5CWYA0IXT5SRxMdSOop+iY0ryhZ7kbJ4v1gIJEaq4vOtVOO0NUHxvUNSkOx0JLV+WhpP43xfuMVjyq2Iq0Uh9d2N0nRd3CmHaZ9emV8IASoHe1B0wIXzBb4WBEHz++mOKFHcH3S3ydkApbztCGVr00w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRRQ/Y5C; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRRQ/Y5C"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-78f3bfe3f69so1561514b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 10:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759772832; x=1760377632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8fcadXEt2TbOOW1SS8BtpXmdQoRjzLU/r23ulkh5ITM=;
        b=WRRQ/Y5Ct8gfBjV/hnoxzpj2GEnZo/FVUTmsFHkNE9eJTHiY5FhGEHp9T0E3Hdz/7E
         K+y9t68aylYZ13dVvPmFgHS0lHdQ8qwhJ9ycB82S7LgHChMjLL2T2VxByMiMMuNt7N0V
         k9L2qpHoKziaxBna4PbBB0X+jmoFga+emxiUSb0HTvHwWmjTfkAYt6QU4EXq56sDTlZK
         LmKuww9a1F4UvxF/GTEKygzy91H393Z63RoFaPwn/gM0GNBBjqjBtiiTvoAIZNHYf77S
         CjiQsJPDmKtDdG2nUORnOVVuFf6LX0M6fxiKVUFCopYVJDwnnUfIiZd+lzgDNtQaMWIo
         m8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759772832; x=1760377632;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fcadXEt2TbOOW1SS8BtpXmdQoRjzLU/r23ulkh5ITM=;
        b=JOIOZ9bS+1DAkcmSNaMHwQSjRzvfU3IKZOU3R2G80YN/pzZ4dEBBEKlkeYEx/oWzfs
         wv78S5V19htkxUA+DpRBBKyGQZ6Qcz7YRPpPl5f8T3JFuGq5BdK8RIEMPO49FTcthKaB
         v6UhJQUk2beGWrKVMEz1ZrqY8zzqOkV0Z321JsBriKNhwPpQZGnWsiUDxUEJ0UvW23YK
         LN+1bcLQRA1EeC6tHQy7VFCnSgEtARlA5YW90khmDuF7i53X6lPdsVU5C9spYPGA6mc8
         dtFOmQ1xTib5Jw0/tksTG9NkVyffku+qzg8YPxKbvM6TVrpHlHM2CzgK8yJdlYDTgUmp
         jgNA==
X-Forwarded-Encrypted: i=1; AJvYcCUh3PEgNy0N0kKEioZSgTyQeomAh3w9lYNZPTRg1qCIqdCij0LGz1cU7QECyw7RV+2A9SdKv15mO4f7@vger.kernel.org
X-Gm-Message-State: AOJu0YzZg9YoGb4V1sPmMQCZpBjsaM2Co1DrkpO9C87SAthwUJ4qQ0I7
	XJRiJyC19CSOOCEE5wViBuFyhm8nnbjVl/o4clCg7yKC54mKSvmPtVu0
X-Gm-Gg: ASbGncs35+vIdC7lsV+v/N3DeP6rmfu3qdKmQMwRwk5MfGB4lm9H0QWAkvWP2wMhnHm
	X00/N7NavyeITW5IPyEVRIJrCvH4WhMjhS9h4qUVGu3GMDV5W2xtIcJXpdvdKTe0GPAz0W6djQf
	NFJFBAczx0Up7dzytBgMpC56JSxKriZqN1OjalOMz8t8tOqGl5Iq78dMotXqDrNwFaJApjePlKN
	aJX+WapLGxKU0aeoIFFGKhX9RbtBlw1CpTsmmXclcmEZtckLT4J6SdHsyAIk5pMuIGh0VbqJ6yC
	+HExs3JBUr6SpLtB1mn4RSFfbt8Qb6Wp6UIgZ3EYIdGW8eHyLA2Uj6i1vn6FHfzcsEE548qK1ib
	0eJRR/o860BmudjK7GrpfkG2CXFaeWoSfQxC+03n4r/fYKgHnj7vGiNfOPq4AQiXDWkgBtY2Q0Q
	==
X-Google-Smtp-Source: AGHT+IEAZ3GTNkzOlBaQRRxaIIrZTAJwj5D6x0H+u0usVi9mnU3RcuVZuSifIPdG1jRzEv56AOGPGA==
X-Received: by 2002:a05:6a21:9994:b0:2e6:22da:91bf with SMTP id adf61e73a8af0-32b61dff85fmr12599233637.9.1759772831719;
        Mon, 06 Oct 2025 10:47:11 -0700 (PDT)
Received: from kshitij-laptop.. ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b0206e50esm13084516b3a.62.2025.10.06.10.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 10:47:11 -0700 (PDT)
From: Kshitij Paranjape <kshitijvparanjape@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Kshitij Paranjape <kshitijvparanjape@gmail.com>,
	stable@vger.kernel.org,
	syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Subject: [PATCH] scsi: fix shift out-of-bounds in sg_build_indirect The num variable is set to 0. The variable num gets its value from scatter_elem_sz.  However the minimum value of scatter_elem_sz is PAGE_SHIFT. So setting num to PAGE_SIZE when num < PAGE_SIZE.
Date: Mon,  6 Oct 2025 23:16:58 +0530
Message-ID: <20251006174658.217497-1-kshitijvparanjape@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
Signed-off-by: Kshitij Paranjape <kshitijvparanjape@gmail.com>
---
 drivers/scsi/sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index effb7e768165..9ae41bb256d7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1888,6 +1888,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		if (num < PAGE_SIZE) {
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
+			num = scatter_elem_sz;
 		} else
 			scatter_elem_sz_prev = num;
 	}
-- 
2.43.0

