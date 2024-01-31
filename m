Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4A017570
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726238; cv=none; b=rFfgF+uzeuaf5FaQI+yZ7UX+gQIv4ul+6eAuGO0aWWjjx3cGrbfhCaB3nTjUSG3OzU/Smg+Me0z/ear1YejbFeyh42TufyrIYh1wtyVHE5IjYGwN+F4scEtxQjhsSGrLvaECXsZzj8Atjl99nslxA+7y5zPsCqWoEpcbewr+gRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726238; c=relaxed/simple;
	bh=+WqancjfyH3kQ6JkvjEygr+/D2TfGrT9yzFBb7GdWMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d1mjL1OjaSZNqfk1l55N6j77L2aAMyOa1zL/Urzhy78eD2itviomDZGc+qVPAYv/KDxji/7IpuXzih521rf504EELf5YrRnaeKw2IlLiGStVjDnCtxdLAU82dc9A8OC2fIeJ9m0dXbC2sX5gcUz7O+lGRriyUvbnHhuVa0G/SaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ianq1HPK; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ianq1HPK"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-68c4e92396fso7666d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726236; x=1707331036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImZlimw8NaPW2DOOZyyfAZCoKws77h59LDy1/yw9qqg=;
        b=ianq1HPKZG8eOWjyB1bxkdu56vNTRQuhUQ6U9ugjNB+lwDDDqGfPUgAbXsMmOOBgjC
         9ulwWnOGvuJwfLFqsXReYNeX2Mu2BgxoHWJLlqjLijGRVLuIhYixuWMYLG/gLcSNiFWo
         +5alH3d5ubPvFiGbRVE6SNlKwuWAmBiPLFqCyKiospXa/H2rwo/2KjG3izp5sJLL9vYY
         Iw0QXZ611yAMT21SWRkbgISE3ik8Z5j1p5wYLZBoRPIZTGS5lNd9Nck2mPb7em0IGtHb
         gwTJbwGAJzGqJzf5TPH0Rl2S/a4eano4jcF4rtwBH8mwp0HAFkwi+cKn3EZEdrvkTgP/
         xvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726236; x=1707331036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ImZlimw8NaPW2DOOZyyfAZCoKws77h59LDy1/yw9qqg=;
        b=J67pdPNRZjrfuKmwKAExUEiw2jOYxhN+5ijmCJRTyvaDFC61w4mivejioOFpgEhGpB
         EmDdg9vwne1eM2eQh581RdwAd+hGRkgI+ExxC4/EJk1itXyFOpGdK7eh33bqYOg1Jyvw
         PPxDeBymsXVAWThxeHihaH2cZM+a9Hro77OYJERSPGucERoGC6019ERuzPPlUZnFL7nW
         9/VSE4rSdpeLiSDnAh+EdnxI+EutuLieP5NV0AfT1CTh/NP4XNCUfI/km65sKpAomz8D
         fAMLyDuneF7cT0r3/SHho9LfD8dL8wmRQF8UczO+qj+XBDBWRfJfSbzfnvz+P4moAfg7
         TUJA==
X-Gm-Message-State: AOJu0Yy/iiBd+Dg3y+iHshrxEPgFKZFWURQ+HCrL4yFguAg2flwbo3uR
	tnZHdJ3TqefA+0IrmjvnRL7LEiZABuHFy1k/mdNcTmtJFmT2ez3jn0UgD8+L
X-Google-Smtp-Source: AGHT+IF0EIS9t9pmyFOE9j9ZrARZaWJmETu2Qw+IwBdOXjZVkwbL9kb5NpFwybCRmJRSZ4vcTwffEw==
X-Received: by 2002:ad4:5ae3:0:b0:68c:6afe:aa31 with SMTP id c3-20020ad45ae3000000b0068c6afeaa31mr2707502qvh.1.1706726235842;
        Wed, 31 Jan 2024 10:37:15 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:15 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 01/17] lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list
Date: Wed, 31 Jan 2024 10:50:56 -0800
Message-Id: <20240131185112.149731-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A static code analyzer tool indicates that the local variable called status
in the lpfc_sli4_repost_sgl_list routine could be used to print garbage
uninitialized values in the routine's log message.

Fix by initializing to zero.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 706985358c6a..c7a2f565e2c2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7582,7 +7582,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
 	struct lpfc_sglq *sglq_entry = NULL;
 	struct lpfc_sglq *sglq_entry_next = NULL;
 	struct lpfc_sglq *sglq_entry_first = NULL;
-	int status, total_cnt;
+	int status = 0, total_cnt;
 	int post_cnt = 0, num_posted = 0, block_cnt = 0;
 	int last_xritag = NO_XRI;
 	LIST_HEAD(prep_sgl_list);
-- 
2.38.0

