Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E8B1A705C;
	Thu,  6 Feb 2025 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869609; cv=none; b=rKDjliXRchO0PAICObcERsy3+DY3+gsdPxmliXEl8ReQJrQVy/Th9jPygdt3Ff5tdJnDAI8As0syqk/KX/znbP/G3GxfPkWxLtxk+8yK9HZgtFggcklyxwPLqkvOIkcSCUPgFhKUEhUw5eg3eiw50JFG1YVVsdATdeU9LxLsj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869609; c=relaxed/simple;
	bh=Iu+nNBkaCoKym9Ycn2G1Dg6dcJHBfMk4YGkMst3AeSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OziEHiv/+BDgOEav+9nY2PBThNfV4eNc2uGbYLj8mZFnMW3pAYYnQZttRp3PBX0SXDIGDPOxytQMRAMRq/O3OmPJ6VZDr3S42eRkgtk3rPB6wzHIGuNN04d5V0HNn6NvmmwO0m2zR4HPx9J04Xwo5WFOZIp9cQjybyErWiB7XH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqkuPzPZ; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqkuPzPZ"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4679d366adeso12806631cf.1;
        Thu, 06 Feb 2025 11:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738869606; x=1739474406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gX2NlSkCyAG7lTgSfLhENbVmwmDFeyF8ds9Vl/soGRA=;
        b=jqkuPzPZyz018731p2SvI3hj9E/eAZwRoTqcTKmFKzS5Fb2kecCZCRUzBY8PiQHMfW
         k6myeMSo60/mOOGBwVHvwqwvTBU3BDQN7hijPHVtYtpFVQ2LS9wA4sUkJY+eZrzNG4zm
         6wou3gLDv6Pkp9qg3w/UZ3bm24K2F/Vlde79FQo+quUPgfyDzB4nUH/bAMRszlQTkQKm
         jYkmupJez0MqH+tm6qsljonBWmmcBEEULeCA1bWcZsZx3LNaZUAzPEg2wD49mLRLjMiB
         NUI3V5gIB3VyKlmaSZ78KCcE64F1sW9EjYlR7N6icDKGZqa3dkNKrB8D6xaNX45NlFzf
         UREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738869606; x=1739474406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gX2NlSkCyAG7lTgSfLhENbVmwmDFeyF8ds9Vl/soGRA=;
        b=ltNVqK6XXOxHky6aV1JxqYo0V4zdPSX52564OQXrUTOiBapqt/z9GzuNB8ZGEnslDh
         fcXjAuUDe98TjCZbW6OnIMLFTVvA0Cg71BQdA+YW4gxIhdXlY/9zaVezO+QxxsbyrPgc
         62Vleg5IpJAxnUbhA5DcFxIq9PiiVCjaTFFMkL0t7RuNvc7DA4aM4i9NpC5G5vrBfS33
         +zm7ip6sGUmIp4BaqO+rIO1GYpPlJ+zxIIDw0PQ4f+iJ+BcYQHS9zWlP9+Z+l+vHWI2F
         GPNe9WOMbK18WNF3Yw3qdZZki00pEK5iyabhTgVqyHxzWcZ2ZCpW5KK5T8CZ57F8ouTZ
         QkCg==
X-Forwarded-Encrypted: i=1; AJvYcCVoHYKwgbmhzIrdIIYOUiAfBHDqze7CrIZ4aK9xw3DmgC6LZ9PqXqIG0WFRkKWvWRONXev8ZSInSFo0H4M=@vger.kernel.org, AJvYcCW2YZEjXxZu1RNM+ZEO3rZvfOD5RzPqv4C8Ji4Nr1yLFnGCrk/oorMqmTV+f1v3IVC7z3uUl32m@vger.kernel.org, AJvYcCXclp90cwITOKkjwjs63hHcEEZQv6axp2DyoQwhe5ZYXU+DFjFEMwik4eugseyyYy9OOXbYIvMY+4/9Gg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCMGQ9MEI1qXGZu+kCJqHE5Q1oz0THDB3iSTaE0EGsIFUgsPHv
	ugEeW8G9ZFZg4VmWQs0dPJhWp5HTenplub6jFFHV+IrDpF088h5w
X-Gm-Gg: ASbGncuSNE+yDI4pcZxuMOM4E4y1IQgfwQfI2mk01craDWBovZq0f4FACG0hGP+DWsO
	hrWT/IHw7URc7FZn8kysacnSqPRrHrnZqAkLBfIxIm2FpsXJsvrMPtZL2HPQHSlRivmgtromza6
	eYYInOtPbLAKBPNGJOUzNsQHc8iN0b7w0QM3F0tvnBRiQR0BH6KZxPhcBrJGEIWv8vfALicuN6/
	X2VUmth0P8OMwiQAqjW23B5YOxpq1KNIVMQ4t0z/RFkHzkWwQ5rHl72iyeQITRjLmJ2Egyj8gqv
	BAbmX9EFgke9b0BVNG/TAqtfHmQolOg1dbiGnA==
X-Google-Smtp-Source: AGHT+IE9n37ecuVxOtDgXdqYrNVqEhe6Q5Lap1HaYiRxh944wzZQejyr6evb+U4ne1iaVT/YxNMGKg==
X-Received: by 2002:a05:622a:6204:b0:462:b7c9:10e with SMTP id d75a77b69052e-4703362659fmr64191091cf.13.1738869606595;
        Thu, 06 Feb 2025 11:20:06 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471492763ebsm8159161cf.1.2025.02.06.11.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 11:20:06 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: gregkh@linuxfoundation.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	markus.elfring@web.de,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: qedf: Add check for bdt_info
Date: Thu,  6 Feb 2025 19:20:00 +0000
Message-Id: <20250206192000.17827-2-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250206192000.17827-1-jiashengjiangcool@gmail.com>
References: <2025020658-backlog-riot-5faf@gregkh>
 <20250206192000.17827-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check for "bdt_info". Otherwise, if one of the allocations
for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v1 -> v2:

1. No change.
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index d52057b97a4f..1ed0ee4f8dde 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -125,7 +125,7 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&qedf->pdev->dev, bd_tbl_sz,
 			    bdt_info->bd_tbl, bdt_info->bd_tbl_dma);
 			bdt_info->bd_tbl = NULL;
-- 
2.25.1

