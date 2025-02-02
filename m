Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D395442F;
	Sun,  2 Feb 2025 21:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738531965; cv=none; b=HG5c0md1KPX0hSUfmP5Yrs26Uzg2GJcDV3G3YoW54xkrhQFXWqahY0Gw/RqB8NGOJCDUMJB2Fx9jKNppz5FrRZ9fNI37R/9x6P3lZD3aS7txDz5chawlCgIlJWqYNv3nwIWhT50xomPL58NVvuFcrq33c2L8OUdj1nR2Hu1AfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738531965; c=relaxed/simple;
	bh=R7ncgOmphOFsW4I3xwdv7haFc+NVQ+pYShvyDRzNgVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mNaEXUaytBCL7YHo3vud2Sl+M1/lKxb4cWHXLOr3BbjBb4KuLaG48B5rWXW0wLcdItzNAqnU3qcaNoLr6xCn9o+/pEKtxpj5eqQ5y6YWI6L40f9xRnYP7+mJf9ZiXLJfovYloleg0RJg03I5sEMLnjbqoCtqgmeXPPRggNX9l84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RysQEo/f; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RysQEo/f"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-467a1d43821so45109851cf.1;
        Sun, 02 Feb 2025 13:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738531963; x=1739136763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkUMQKaY0kLwFtHQlNd6rdcDuErtLiDSRWPedu76oGo=;
        b=RysQEo/fj8obhzDe9jGjsY5oaivXs/+xXU7rdudE3GLWRfkjDYGtyBCfLeW8sIx7lE
         P82/P4MPqoOo77ZIN7VZC8HeZ7SXAa0wDV5AYp7AGS/g812BCiC79OwBIL0NjwFr7Ht5
         CJMadggyy7u7VgCAtvgXpqUuAAz1SYWjznAAz6gmWSu6t/qa5vbtrL6sz+2FZ+DV6DIf
         ICmIZOeXxeCnp4tWlKO4Ge2MzljsZyf81FnvKu1IvBwQj1VBqX/moc7Mi+8dqZxsEULx
         CgSvx34Co9WoCWL/DJltJXLoSXNuy6iFiSrZBTYrDFtF4leFRULqCJyiCOqDUXxrBgFO
         C1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738531963; x=1739136763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkUMQKaY0kLwFtHQlNd6rdcDuErtLiDSRWPedu76oGo=;
        b=olsC1WdV5wL4JEslKmoHDVXAcRoYB6eOdKy9nsw/ojBrksEIcAI1XagInvKAitSBha
         dykfJvlEANhwC3PU4lk60VNtXdSH+G5AROd1fILYNw3VLrd3mfuMMn67Z2jMAuaVrVpu
         z+JLUkkOEjaqyLSRSU42DTWIcnor4T/NBH3aXqCjNoljA6VOg1VomdUNzVhUvSqDDG86
         //uJ4V2YYyjQIaVDVP9tDTunJbIh1+Jg67RumklvMYztJp75esqfRui5u7wQaobcmp7A
         USeNpp5w+3GDAwWCeR4LI6MhYU09WpD4dczh1uJz3MMAoKyR4uxUa8DmHZ3U9KYyRRgP
         7rbg==
X-Forwarded-Encrypted: i=1; AJvYcCU+nr0YvJySb8F7euq0l7FObYSbOV8pDaL8w50HKu8y+cZHJ9bYxql3LMvb5RL2juykVoNeUryK0Ns6ipI=@vger.kernel.org, AJvYcCW9C8wWjU9M8lw6KKA5G+2CI24jRcs07QNMl6yHITfdKqmlZQynF6FZJCitCg/ppNDCuyMa215VIcdmHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhPXAaEMwEBI3pMqjyee1FSmZu2FDAOwipKnivLUQoEucHT+WJ
	VzfF7Qmo7O+xaeyuEw9ZCav1o3Qr74dL8dDaQ9quweaYrx+icGJO
X-Gm-Gg: ASbGnctX5eexr1ErwEoguUv6XWbmDFcMeA5teobR/d/MgxQxZqaumaHuzKbsVNoaNre
	RtghdzLDzBlIUSBjD2XQJzwTFfitkEc5spbjd68T9ovEjI4veRZ9lnn/PKn7XMWombtN/p/yHVw
	QQ7Ly2W6HoDQbNPI6o7j0WRYxyYj4EUGGOhjO4hpUb2gjsNT/4Q1tG8ST9M5gF5BarEOTvtsuYT
	wJZsCZ33emd5vEd57CjPTqdZV/EB0q9pOhaliTmNCTjwMhC0kAxHC24UM/Wt8ClamwUaCL1BiZ6
	yzfFcQSly6YGGuncnpp6AbE7EDuGUoo26RdzBA==
X-Google-Smtp-Source: AGHT+IGLS7jYo1AQmtJY7btwLnOx+ZTaocLGeXU6MicVqZbaqc4kEpYuFazWNGkygrTN7jGoehz3fA==
X-Received: by 2002:a05:622a:1a98:b0:467:517b:90ca with SMTP id d75a77b69052e-46fea10acd5mr190428531cf.21.1738531963195;
        Sun, 02 Feb 2025 13:32:43 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf17c92fsm41457801cf.67.2025.02.02.13.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2025 13:32:42 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
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
Subject: [PATCH] scsi: qedf: Replace kmalloc_array() with kcalloc()
Date: Sun,  2 Feb 2025 21:32:39 +0000
Message-Id: <20250202213239.49065-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
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

