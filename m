Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8F1376F1;
	Wed,  5 Feb 2025 01:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738717658; cv=none; b=reiuHbw1QaWW8azu3/zCVagQSSLftVbrunAd3GIZBSlU+CL5HgciyFBBtU7hxG+ArFdSrrezexKie7T6wxIhc2i5uD9QSY5+H5vXVuT3eCs+0IDZju7jsaUgiBnqzMAzaiWCv9+d0qA85C35WMxRMiEyHiML7UvAo5yDoJyaJxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738717658; c=relaxed/simple;
	bh=J2D0ZcX/+bi6RNF/Exsk6jQgmhsvXhkq7jB3lOLM5mk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E1bYtmudGKQVE77EmuHrJq22ceQ/ANw16mbHXcE4R7zoYzkzoL348XZu1AX3j9t+MhxYgukugQoRtOF7/Fn4y2V6TpqhF//tyamCPCPcY9QusvczHTZbvnwwPX6ZNFWvIYGKwA8ImUxyOJKuRHXqRaVcFjQ+H6A9tw4O91TIWCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHrdY0S1; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHrdY0S1"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-46785fbb949so69996241cf.3;
        Tue, 04 Feb 2025 17:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738717655; x=1739322455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXT8w3YcSQ8eg0rORa5UeotKedUR4DvT2ng1N2NhGq8=;
        b=QHrdY0S1IKGajbTAtMnsDvMsk++nfJb9b/VTNgOy07LgGwn7CEZ9uxxkijCzsS2yTz
         I3EzVMBNJ6/qxAqwAfWotv600z1DYOkIMdm/NkofgwBVXVDrCPE4J4cknZ7sJRCpbTdh
         1a2baztK8VNd15uupj+THzqNWrfelYyKc37CJHEjPfPq5W5Wv9TSj7hnaYkJMJp2GJw6
         s5rgohwF5YdUD09yyUj2BqfzBgnz56+TwLiXWy6OtRXaWYW2RIJfxgiQd9knFOLNf8bm
         b6sTUlqc39mMbB5236hu1eHcA1AR96BtTlzHhKp/S/hCGWnJFaCA4vG3kvTkPsqdyB3d
         cfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738717655; x=1739322455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXT8w3YcSQ8eg0rORa5UeotKedUR4DvT2ng1N2NhGq8=;
        b=QhTkKg6J+73HiC4+FNQqAuEcY5IoSM5ytA9p3VXGuidWkxAo/pU7BIUuqDkI2rP51N
         E+cNiTTTTX4r8hp5W42QistLsaMf/vbVp5nYmj48q7/8EV8h7I+DM9WRaNSo72XKiaTt
         XOEdpimEpr0luXgltM/tHIRt+VjeJRpTHY0K6LJGyn0caaF/AvREYYXL6vX0NoCwsbqY
         S/J28UgKxBuMX6XPh6V7pC3cndWPgC8eW2+UinYR8gOrUvQo9/s+fF0Az2dx3wT6lSzZ
         YMxhTKZWZzKrsLM3w94+UvnTELGn+4qVDx2R/8Mz2XkxbiAt2ITtZ8YOWkW6mRVS+sLF
         fcVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvGff4lr7xKLRfj1JR7hMM2dg43xrMjOdBgq60wAf3AAdCA/dRc8PdKtE+HQa7HCas9nYSnogx9fwvpQ==@vger.kernel.org, AJvYcCVGepKZY4UoIngWWUf9UEno/nLEful6sudIzrITE/GCIlkfBCISdrcDv98Z2vZLrZ6CgvcH+ZtB2qmwh20=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx52iyY4jfGXjgJW/K9hlp2XpfBQocrwxgj6oOytcE5CFbngedE
	R7qKsHTywOqbe69ZzEJzytmf5Ooq5sBsWpoLdnDUxHdwA2RLfw3jjrjjyw==
X-Gm-Gg: ASbGnctYlgM8y0SjIstRdqfu8/HnJBI0miR8dQl6HN/jXQqQXQOeFRZkWy8zrSCZ0mB
	BhSXvZai8xsknLkXtADVUClRbb0pUVFjZruopBJ6gvuu+PKubnkMyLZZ88mPi7fDx8ne4pcOamO
	qXRWrCzCcG4Ak2m6q8m2pfmCRVJab3wR1ATGMiQ+e+IkyD2QlY773wXIgblEtJ6H8U2eAzzCN8D
	hjXA4uoFTQz6QVpcnDBEX7xzkH9xeqVLUEcMKwNrqwOMl6lrbAm/a6eCc9ppxDABe48YPmdb7+P
	Nq8QtERVCW56Akl8quFCAzpY9tMtYDsPWOlEAA==
X-Google-Smtp-Source: AGHT+IGsQMkAxU1o26B3yWdpntz8UNo4YA7Bor56+bGaWazJMd4w/K+p1nf5p+5a/NVM54hwMnsQVA==
X-Received: by 2002:a05:622a:d4:b0:466:acd2:1134 with SMTP id d75a77b69052e-470282e6933mr11722531cf.52.1738717655286;
        Tue, 04 Feb 2025 17:07:35 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf1728d3sm65069281cf.57.2025.02.04.17.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 17:07:35 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com
Subject: [PATCH v3 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Wed,  5 Feb 2025 01:07:31 +0000
Message-Id: <20250205010732.16891-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
References: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
Changelog:

v2 -> v3:

1. Remove the check for bdt_info.

v1 -> v2:

1. Replace kzalloc() with kcalloc().
---
 drivers/scsi/qedf/qedf_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d52057b97a4f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

