Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AE22E2EF4;
	Fri, 27 Jun 2025 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034344; cv=none; b=un/as3rf4vptXBtpcQE4YM4Nx4RuocSj7/qNnkfiuMTpyBfWiwzUcXLEBHcG+eQz75oxx0QheKlrL0sCpvWzEcEGc/dC5YX+GAUq+qKUrJlPmjUkdIfkMCIasl2kOr0jg58HVSYRhUanr/rxricy/mNKgz8PjxmCknigNKSjQ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034344; c=relaxed/simple;
	bh=ME2cqXZUHKwJVGbFXLVEvCVVXrHKQ8El4V5MfXi0efU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EOJZJVo5Sjvqs7l2Y4wnX4hJnPim7MwHQzU6mnDaQDRCKDMZ0HHZAj0iru5BK9MCF6JoRQqvUfR4/IlaQ4l6B/D0tVGC00YSnwBR2AVVv5ISaVno0LocEsZ2Xu8bX8n58M+Dlckq1Fb4MkdnQkzsWD8KJNSYOz7Eo6s4tCC28cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OmrTwTjm; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmrTwTjm"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4eb4dfd8eso325723f8f.2;
        Fri, 27 Jun 2025 07:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751034341; x=1751639141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yk+TCPe5F7/HoOrV73Zo6MpjOMLx2phHFu+ne2bfNMI=;
        b=OmrTwTjmyIv8kgX9uyWM4kh0Qz7GG15qzicOWkaVT0ncR/Z6eNioDGUC7Gg4nLwPnv
         aIajgnJllz6q7a/138iboZTBpUWB0MivI55aoxxH+18PfWCjD/zYLcN3nRylecgOlfH6
         5K+LbiMwWgv3d4Zot6hzKilQDCZRkT51pj6fd1B+HDQMtBp3T8S7U1PriVTls2Cfar62
         Ejdg/ybgTr37YrnxippYZ08tOlbJDRz3XZqu+OzfBk5W2pmbLfpo5JpP7JLNmjN58pf4
         uUkT7vUrMJ+s7MuYjqE8ES3CD3/NDqqCtDkXEA/lsOEl9e5Cji9PRJexrGmDRbTCPOVA
         Qaig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751034341; x=1751639141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yk+TCPe5F7/HoOrV73Zo6MpjOMLx2phHFu+ne2bfNMI=;
        b=NQwKVnRfSR61wJ0ETgKV7m6GqKey3NasMeujFV22waHfn/uO0JoKiOvCoP42eYcA6U
         +GDyk2VIWa4vrCZ2UOFb1b1fI0R6o5ysKjLJ2W8gLJXker24KTWt3ihVzkrrr2qJgA5F
         fw4Ft8motHx9Cb/Uv7CftvYAjp4053SnxtwgSUg8x47SHegU2w0B1JkTfTA+WMKfINB5
         nJb/eTkujOu1tANK3tndE9FGTd8KElIxO1rMyuHA+NzMloojFdtewkFrLcnLj3DBsoKc
         7OqXZ/fM/Uywp2qlfWvV0c7qi4f5e5Of+efHyT8UTleqIVy8heg50eVHEXQwv5QlDmyM
         2n8w==
X-Forwarded-Encrypted: i=1; AJvYcCVsK/SjcfHz6f5DLKYWydjvRekUuKNUrzwAUjXzVJBWqsn5XQvpPjvrjCXqjdR1739KHGsSEkxdhyQWZg==@vger.kernel.org, AJvYcCXRNaolwYYTgZZ8CRz1PFCyQ9uzsnTSii4aLSc2Nmowb+HrfyvXfZA4cvLUhpakcm53XuJ/IZJm9Um8e64=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv9Xt635mWnVNeZs3T+EGXAlN2HiO8xUQL90e/vfPQlbfAov7i
	ZVOMrEsNKJRxgHmofgexhb/9QNrCBRIiHUOQ0nMXqYTj+/ehoQ9X41cY
X-Gm-Gg: ASbGncuWlo2sYhcVnv8G3irW1sqFP4vE1hIs06NVvCVyej3+OZZb6umPyOS35dEWIsN
	EVbmolnArXmwYLKjIEALRYWYtkgfSlfFKlO1514axdmz3f35tT2KU8yt9RgUSAGdBxmK4ORcpxV
	0wZOXoQ11VtpOSc1Nf5AEgMZ8Fym78rgp22gDA4RRXBuVvxciXv/mmva9NVlOzp43bAMq+PIBxS
	pSXi8m94/7rHIzuxUktRaMuq0iXl3fEB8F521U8T8EoizzOEvaYAKB63hLXdEJ+w8GHSdBx0q5T
	vyOuRITHnPcnovL/vVVabTlcGOxrZfoEzIz1SIsEeK4K7SKh4t9hBxABQIKiPnA3AJ/FJKtnYwa
	6e6PYGU6jtmEiDIN0YwXD1hmtUg==
X-Google-Smtp-Source: AGHT+IFgCpOkXg8yoUr8araE5Gzl7VuIF7NW3Fx9azLsYdBtEloAb5F9bReMzOc9yPTKcifJsH4H8A==
X-Received: by 2002:a05:6000:43c9:b0:3a4:d4a0:1315 with SMTP id ffacd0b85a97d-3a8fe1dd906mr1006346f8f.6.1751034340473;
        Fri, 27 Jun 2025 07:25:40 -0700 (PDT)
Received: from thomas-precision3591.imag.fr ([2001:660:5301:24:fade:13b1:a534:8568])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a88c7e7098sm2818338f8f.4.2025.06.27.07.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 07:25:40 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] isci: Fix dma_unmap_sg() nents value
Date: Fri, 27 Jun 2025 16:24:47 +0200
Message-ID: <20250627142451.241713-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: ddcc7e347a89 ("isci: fix dma_unmap_sg usage")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 355a0bc0828e..bb89a2e33eb4 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2904,7 +2904,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 					 task->total_xfer_len, task->data_dir);
 		else  /* unmap the sgl dma addresses */
 			dma_unmap_sg(&ihost->pdev->dev, task->scatter,
-				     request->num_sg_entries, task->data_dir);
+				     task->num_scatter, task->data_dir);
 		break;
 	case SAS_PROTOCOL_SMP: {
 		struct scatterlist *sg = &task->smp_task.smp_req;
-- 
2.43.0

