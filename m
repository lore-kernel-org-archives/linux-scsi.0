Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8919EED2;
	Sat, 28 Dec 2024 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735411819; cv=none; b=QwmGcH1ollIwVmLxFAUN6ySVigFWSmL32fVyRcvti2yRP27em5SGcXfBDjP0O/ADugETDGuONewwbVwetbvZZmMvaLK2AYpg1uNakVB5ntab5QKlimL2Q1/8FRTr1CqXE9NEpUBF5UjGQ+gyiCRUVFpbKDeqvi5M5cS3lvLYo6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735411819; c=relaxed/simple;
	bh=s1rUMlu7DzVnUwDvM6XNMOc3MzlAh/fRbyTbur6LiVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8hvZWN61fA/ku5giLFjKeDVkq74bJ7gOFt07kuJ6/c8YVp5bxpUonri6m2yEZl1V4vQWEspQpfhtUIkR5sEyTEkunJ/OCs15qjHldKoNkjyJNEz6uPJYFHNWukA2k9dpffsZWTOr7Iemd+pF/Vj8MhFqhsJIwq1Zn8FrfJ1VNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvVNDvWi; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvVNDvWi"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e396c98af22so4237708276.1;
        Sat, 28 Dec 2024 10:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735411817; x=1736016617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRlDoR4ytnS2bQfcaaePRsRcamLJG88lUbbmmAU/YJw=;
        b=cvVNDvWi0iHS8bcjeV6A4002fifCA7dc7ltEF0UGbkEletabWtG/sf3XfvUFAkFPUU
         iBCYjDOkpwMGfJ/WkBsVXgVXLuyW3SHSTh1lDRXFGwatUKvjay4/d37U0peAuSTqILUV
         16aQIz03Xv2gOO+y18Sg4QUzSJUSLYkRwvdM7wQgHY8CkKbmCdJE0jdP5Y6GtyOvH4jA
         vQvS4FzT5lvhWOmPh7EUdb3uEMZVQdANrnu8bHOPPtDJz0iHCixZFKXPPCGeCSDtFg/E
         PBTy/fFRj7zddPyUmbKUZ61H+EMNOxbNu5qeM9+Pd6f2oga8ZQgJXZSo4B6a0ZrqClM1
         pUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735411817; x=1736016617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uRlDoR4ytnS2bQfcaaePRsRcamLJG88lUbbmmAU/YJw=;
        b=rz/uoIqHPuDAQcmagMFKJs0AxbT9q+r/pxZyaIqIEczAa/3RssFTP9/LxlmXVRsVLA
         sipIn0wevu2kfUpqDXpWCwj7OpMcwCkJ7YQ8uPULiyIrkLHK5NAlTBgVtPPBzYx0ZQ13
         OffyLmSQs8zraCD5Hw+sicn+clY2KVX8xchzkMjeDNha1hRppNQvkMufXxXe+N7MpWty
         wsXUWp6zsHFKVFPMNZeSHZ0JqamF+SCt2p231/sxNgoyZT8ehB8OpfKJ4n/kLSK+9O1A
         EUECOKzYVBAcDua709EkzEZeoq4AYTEeCuw+8/5CYFSyB3VPHu1goievpONi/bgPuArw
         xTjw==
X-Forwarded-Encrypted: i=1; AJvYcCW/kc+e4O3VBdG3B97v/gHjmgpgHa72Y3Y68JtaKZ6MmahoErUvWkncFolzGemTQRPnQz8STbCG2fX0@vger.kernel.org
X-Gm-Message-State: AOJu0YzpqK46lo5v2vJZy55ko7WpGH4KqeJervVkZ95Mlb3wZ3IQ73gT
	KJCxAtNp6/b5sNhLXzO30pq3GfeCRmjlvazRBAYVNQjGcfDKDSYQdrzubZn4
X-Gm-Gg: ASbGnctxpthxJ+sqHwDhqI1fGbX+br6gLgcenMNPM9ckH4hD6yZLHBpptW0wjSZIS8X
	CkKpYEiM3WPS6dQ8qmIYF0u2CRigbKYrzMlUxBUvgbxi77azYiy7IHuY5wrUjHn0lTazJB60UFp
	3G1VjnY12nP3Q6/fHZNVMH+GGqKRAmay2O7hSlbZw2U5LJovY5TSJF0Xq0kpHImcJS04ejPfmee
	qlC+QG4uZGIc9gxMnarVjqDVpC9KO+3PctBqIQ7yRg7+f3Qk8C2auRI9SPwyoGL9/2FFRj7UF0h
	4eROC2SrFNSeyAzK
X-Google-Smtp-Source: AGHT+IGn/WRKVrT82iGZgkf9/jp1T9k7GHzUIn3Wq3ZCorYLAnjeqsNRUFnIKIH67oVoVPLCROoorg==
X-Received: by 2002:a25:6a02:0:b0:e44:82ef:397d with SMTP id 3f1490d57ef6-e538c20def6mr15858003276.6.1735411816812;
        Sat, 28 Dec 2024 10:50:16 -0800 (PST)
Received: from localhost (c-24-129-28-254.hsd1.fl.comcast.net. [24.129.28.254])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e537cc1e928sm5201774276.17.2024.12.28.10.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 10:50:15 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 11/14] scsi: lpfc: switch lpfc_irq_rebalance() to using cpumask_next_wrap()
Date: Sat, 28 Dec 2024 10:49:43 -0800
Message-ID: <20241228184949.31582-12-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241228184949.31582-1-yury.norov@gmail.com>
References: <20241228184949.31582-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling cpumask_next_wrap_old() with starting CPU equal to wrapping CPU
is the same as request to find next CPU, wrapping around if needed.

cpumask_next_wrap() is the proper replacement for that.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 31622fb0614a..e94a7b8973a7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12876,7 +12876,7 @@ lpfc_irq_rebalance(struct lpfc_hba *phba, unsigned int cpu, bool offline)
 
 	if (offline) {
 		/* Find next online CPU on original mask */
-		cpu_next = cpumask_next_wrap_old(cpu, orig_mask, cpu, true);
+		cpu_next = cpumask_next_wrap(cpu, orig_mask);
 		cpu_select = lpfc_next_online_cpu(orig_mask, cpu_next);
 
 		/* Found a valid CPU */
-- 
2.43.0

