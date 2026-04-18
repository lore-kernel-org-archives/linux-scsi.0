Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BCD37649B
	for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2026 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776519020; cv=none; b=fiRVPwASIsxnMaDTlUbRUCjbNYriPjk+bw1bt9rJjq6zdyVpPmMYYVH54BBF3SHXpgzkP8XIP9RlrJyFRituZUQgtf/5Mb+mwT/2IfVsvCOtQxv4GTE3WLcq4pdSsACPd+7zSylrchZncNvy0B/xyR3q+1WYSn3Ob/YtDxnwTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776519020; c=relaxed/simple;
	bh=FSw9T+IBDfp7hvGNXwhUDw2Z2ayVOPz6zaav9EQJDoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JYk+4AkWsrL/sISJtGRcDTQPr+62yn36ZuiCPP0zG20ll0Vd5zinmYXK+Q3doNKIy8hV8wxo9K6amhDLp0J0kbD8eLS4YJpuYHGBVbwTLTMhy3/YVYckg+pbQLOX0etHsD+5JSCywSrU8NgSArQQmeltojYv6MWZO4H1EnU67qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=FhbPxN/S; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="FhbPxN/S"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d95017a68so1037517a91.3
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2026 06:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1776519018; x=1777123818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMB6KXkkm0c0b8EnPP7cQVspQAzGNbeaZSme+aUt7G0=;
        b=FhbPxN/SoMPaj6tB3y4E6sEDS4yHdfHnLIlAT+0YXvrgPbi81ur/lp/a9kGSMh8SsD
         1j8ypvj5GtZaUs8xOfAzG221uocvciX6/rF8OBwaVq5KF1xwWf9MZlX1BMrhkCFl3XrD
         t4VuJL0hRJni1C+Nv7gjwRwaOcCX3da5Irvmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776519018; x=1777123818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sMB6KXkkm0c0b8EnPP7cQVspQAzGNbeaZSme+aUt7G0=;
        b=fcqHWEVg2rzFr/8FGlHfRsVYJvfO8SV69ap+JJSM8AD834qtetOxZVPS+kxAV2j/eS
         EAJ/ENluVCxnVJcNa64Le6iYUISsAMngu2Oa6QqJa4DvfyRZOur4DFWdB2hK6NM8WkiW
         dOkN7zgVcWlIS9vc/kjQZVxA9MPslqA2Ama79NghN5zYlulDnY9RbmS6A7LkffEwgGAG
         wWOFXKQ/JIQkDyCSh7VylIF/JeDF73ca3yZj69nui3J44/Ytjv1hGR7fIhNXPhBzw7di
         jKHJMltavYnGBGcaVdrnaQ9vnSbEFk2J5+sfymzu2HZmyWGitxQy7tyIvTIZZB+Cj/Yc
         T1rQ==
X-Forwarded-Encrypted: i=1; AFNElJ+p7QGIXFrf0oON1CrApUAVzWgTY5L5i+vZKrRJ3RgWNcMU0DKY4ohKtOf4c1BdsG0CfPA7u1g5Ki/H@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3Ph20LS5vqmE5cP8r0x5Hv7Em/jmemCUhDPDVfB9W7hFSB63k
	cCl2NS4wdI7qZJBSUYfZxaVsCpxnckkj9UyRSYcIcecaMIykjBAi7vTuBhhTbYIz8ww=
X-Gm-Gg: AeBDiet6IIMuDsjTrdBhBJdmTYJChbqb9wJMNxZZqpPlICw5z0Jgplw9SV9SekPtDV0
	KtExzDGGkXQTsqF4b5o9T3dL9+jsc7p/HD+8d7ozayCJsBYwCaoOXqLrvx1sY0bkGJheC5W4j6d
	1IApV6rwcw0/Hc3TPQRbY70x8yRWeQ4uINmSXT1Wn4ew3p3uUP+14VEcAspCuKHw1fOllmsL+5l
	4ho50FQmucQlPu0S5YHzte3WtI3H9GIjW49LA4NtLbEGhw6++geZKGwfStaZupYgg/L2lt92hRn
	/hBRwr51CWrW4mnD1yv8s47grfQx+a9vQ3AxNoqwzyB/uGrR6FDtosRRumiJ8d4c4tcQ4HWt6Jn
	wEGeNjKnuDERnq8lkf/aF4zjildDSA8J3KLKfbRUacGwxr3+tlhEc6xaaYJAHN8qQofwRQbSib8
	xCAPJsVNik1TJogDLAjJQQCeTdjdVGR9tGiaCeobxpJ30Ej5ZDDteNOCtWxVpGd3YYjDtfkA==
X-Received: by 2002:a17:90b:3f47:b0:35b:a7be:ae47 with SMTP id 98e67ed59e1d1-3614048ee93mr8074585a91.21.1776519018335;
        Sat, 18 Apr 2026 06:30:18 -0700 (PDT)
Received: from nunu.. (nunu.snu.ac.kr. [147.46.112.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3614195a9fbsm6843001a91.11.2026.04.18.06.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 06:30:18 -0700 (PDT)
From: Sangyun Kim <sangyun.kim@snu.ac.kr>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: mvsas: drain delayed work before unmapping MMIO in mvs_free()
Date: Sat, 18 Apr 2026 22:30:02 +0900
Message-Id: <20260418133003.2462460-2-sangyun.kim@snu.ac.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260418133003.2462460-1-sangyun.kim@snu.ac.kr>
References: <20260418133003.2462460-1-sangyun.kim@snu.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvs_free() currently calls MVS_CHIP_DISP->chip_iounmap(mvi) before the
loop that cancels pending mwq->work_q delayed work items.  If a
mvs_work_queue() callback starts executing between chip_iounmap() and
cancel_delayed_work_sync(), it dereferences the now-unmapped MMIO
region via MVS_CHIP_DISP->read_phy_ctl() and faults.

Move the cancel_delayed_work_sync() loop above chip_iounmap() so that
all pending and running callbacks have completed before the MMIO BARs
are torn down.  scsi_host_put() is also deferred past the cancel loop
so that no callback can touch host state that has already been
released.

Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
---
 drivers/scsi/mvsas/mv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 5abc17a2e261..0c9c62c25987 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -120,11 +120,11 @@ static void mvs_free(struct mvs_info *mvi)
 		dma_free_coherent(mvi->dev, TRASH_BUCKET_SIZE,
 				  mvi->bulk_buffer1, mvi->bulk_buffer_dma1);
 
+	list_for_each_entry(mwq, &mvi->wq_list, entry)
+		cancel_delayed_work_sync(&mwq->work_q);
 	MVS_CHIP_DISP->chip_iounmap(mvi);
 	if (mvi->shost)
 		scsi_host_put(mvi->shost);
-	list_for_each_entry(mwq, &mvi->wq_list, entry)
-		cancel_delayed_work_sync(&mwq->work_q);
 	kfree(mvi->rsvd_tags);
 	kfree(mvi);
 }
-- 
2.34.1

