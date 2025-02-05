Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEE222A4DC;
	Wed,  5 Feb 2025 09:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738746709; cv=none; b=V3FcyNVEbNx+tk2vPp8klRA0qbxx7vkRNEQXUaGU5jgEjdOrU4435yz6beWuljFB/80cwXvRmBfUoWZofOcVjOYuqTtgP1I987vWbgL0sgeow2lPwZiltUVB41amoCT+/gzlrdJH84H96pmGqfrZDAvd/pxAirOT/5S9bu6/KkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738746709; c=relaxed/simple;
	bh=LbCUSJD0Czpt7W31mvEtgHb9EN6MNFmskiCKC6XcyeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Opu2OMYROXRZOc0hBldPAGqFqP28tvA2VRaoJD1IW/kH1rcw21PwhpVBCF65XsR7BD/FOEZuUJfnInRj70HMpfbP0hBP84/mcpgxCkE7afnjX5w6Dywvexs2F1qqr2YI0468mSNZR8t9Q8ym3rs/HbUm9Oa61gLZjnjTV7vrSGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vfz0+Lt7; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vfz0+Lt7"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-385dece873cso3036520f8f.0;
        Wed, 05 Feb 2025 01:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738746705; x=1739351505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9HHOddGHAWnD6MdP+cfS3QyTNQZ9GK6ZyaYhy+uXayQ=;
        b=Vfz0+Lt7KHey5NOEiMIPgeXiQqhfCTCN5MraqCxR/NLn3Ghmcd7dkK2uHNkTG9eihs
         6/DA2OikN2DzDUBsqqyAbY/SipESCUd3HFPr9NUCJ3REVGK0PQcHl4KNRAQm7KEMIlva
         kY5IZQ6RXbaxexVnOnj+/TqU/2tsa40fJijySmqTbVpbZltIWQlljks9ebN78MlSDvu1
         x+Z/X5pylV5XB2CkutqisJlq9R4gKyK4HJnG4mL0jhXJCRVK5fw18E5C2VjImln1Wpfm
         5OCX99EMDxTz8cQhlY8dKiQiYjQpB/mySBMq/6r96Y0y0LjGKtC9xSExgOQDigJbAMuD
         myVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738746705; x=1739351505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HHOddGHAWnD6MdP+cfS3QyTNQZ9GK6ZyaYhy+uXayQ=;
        b=uIZRtXYdY6Ejmw5O+BpiSetO/RTnLUB6iwROYOcnUZq3QzXI7XvkFzVq7iOZjimXEd
         TG6V/QlgqoQqFMYk6RqlQ7SvKjsTnuHUi1bL9vZmT3FBmeLaR/rRnPebAwMkNWQSt1CV
         zxrgEFuGKCGQsC5BVxs3TZjdXbOR5GhqTz6qK2qFS129N43sw1xCP81RbZ/zd9qahT8S
         AaSxiVptujfilSyeR5WuIcey4vj4OdcR9/aXDp2nlaU2Qd0/2xf4uvcgEl+IefiDF//5
         2BYnOr/WeeF+9JrmoxRQuVmCyc32UvBMmfcSKmEDMZVZGOQyFVmT/roOR303DE+SfOIl
         UZFQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4PNZk6pQ6NYRppNjZ98ZaiUen3wtc3pfNwuYuMeHXsh6x+4zJVmH/3+6hRIESnXRuXYXzGXcf2UvYsw==@vger.kernel.org, AJvYcCXcB6+mC9hM46E6Jj2khEXLansM3ivVv9qHkeOVZDAl5Ogo20jbfCkFheJnpsUFeHfJws5AHF9Tb1yXTuw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmTqsb6Y+9bLEQiuM+onSwX9ddoOh6gnIRbmRxD/QA7xbXKPe3
	7G+y/rG3HrX7FpzP6mL2YPIRLD7iiw5gPTxHtMaXOTbW5iu8PvHX
X-Gm-Gg: ASbGncuETOtB7jTMd7RszvQ9a6RxjjWcIyNv/5whQiJdjaJAbA/XBm0NPircqcBU5TN
	/T88anLnsX2Ufqs1thBE2OGLCR7VYM4ulgt5HlBr+L8dR7ZqUbww+yPymZWxOtIJ4/4BxJUCFwD
	nLYiYsT8yicX2Y4zOL+2OiGjoMDrRQ6di4bwU7ND4odjvqyd+bPQpQseLIOOZ9ToHDJaczPtmV1
	DMdGbVq2moqquTRw6uyjjR4sSk9wp1HBGcC0fnCbAyPcadWaOgUCFsgsG1xylL5PR7mFnC5qQIY
	9pDaqJv6i4mYP0bu
X-Google-Smtp-Source: AGHT+IGikbPCrNpiUQCL0O4o+XA1l4SRySklGuthhOGhFLhWjoNBOY1lyPsKx/iwMSDMDplQ5VBH3w==
X-Received: by 2002:a05:6000:2a1:b0:385:f17b:de54 with SMTP id ffacd0b85a97d-38db48a9044mr1345063f8f.5.1738746705342;
        Wed, 05 Feb 2025 01:11:45 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38db6320becsm928024f8f.98.2025.02.05.01.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 01:11:44 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: mpi3mr: Fix spelling mistake "skiping" -> "skipping"
Date: Wed,  5 Feb 2025 09:11:18 +0000
Message-ID: <20250205091119.715630-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a dprint_bsg_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 26582776749f..4ff9a73a7960 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -238,7 +238,7 @@ int mpi3mr_issue_diag_buf_post(struct mpi3mr_ioc *mrioc,
 	int retval = 0;
 
 	if (diag_buffer->disabled_after_reset) {
-		dprint_bsg_err(mrioc, "%s: skiping diag buffer posting\n"
+		dprint_bsg_err(mrioc, "%s: skipping diag buffer posting\n"
 				"as it is disabled after reset\n", __func__);
 		return -1;
 	}
-- 
2.47.2

