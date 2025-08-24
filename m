Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8B62DE6E5;
	Sun, 24 Aug 2025 18:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756058554; cv=none; b=KshvF2v+vreOJq/6WyePrnjZdbQWTSRp3oy1F3J2ApoewMJ6+rri9iWlkz9uJLCsDc6gx9E+qaV7DgGzwMyW8v3huG6EreLJeWP3/JdFRJ8HQGBlXuTUfrI5oybtbpmAw0mcWFKwDJOOHMzDhWb9JjjXHeOcBSkbS6oa0qHxvpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756058554; c=relaxed/simple;
	bh=8neVccFP2rjfyRAomk60wb6Ra09rbALDmri9T9rMr1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkrCo76Zjvemzd0qkMrM51DNcr5ydmfFZ3NIFDH3uPlsUJL/vaH0s6iAfLSltsJlFmCmciTxVcGnD8j8ecFnMHiME2HTio3ozog7JMw2lZA1AtTuBdGHd2hAQ/9m/YV7vWci1bDu+y35Jdw4S26w73ELcjxUScnDE+xyRA3Q3yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NI/eRN3Q; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NI/eRN3Q"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76e434a0118so4303677b3a.0;
        Sun, 24 Aug 2025 11:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756058553; x=1756663353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAy979kIdgmGwVYoGYlOkotFeCG3QUvnPH4+MWcyGm8=;
        b=NI/eRN3QPdToLhIEbdPiG/+a66jTVjnqVV+gmZQy9SAoUoMA7SIvD15o3GzcCyIduo
         my/ig3LcO3TWsATM4jaU4rADJTNDoGwa84teH7Q9ut9Zz+GTPRxRfyWpi5NqgOmavqB5
         hg1VUWdA2C+Aw4pLh1JT9j6gr17JBLjVGb3GSNWX5ZQ+uFQ3MgLVJF7pVdgnQzvLeNWD
         nz7jyv/MB6JWI6KefOnieQvPkWnvXXFx65adPRtpKFDj4PGu4BVur0aFOFKC6BktWc2x
         M8jVD92m1IBRf9GnuNoJGthrLnGVDRoVvR0L2JviflWtgOJtOxR5Masgfv51N9F5aMp+
         r7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756058553; x=1756663353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAy979kIdgmGwVYoGYlOkotFeCG3QUvnPH4+MWcyGm8=;
        b=botWyH2YL+jCs4ZeET+sn8/+wRZNonEV3A54GGZdHZnZiMo7w4ufWRPiE6ob8tnUSH
         OOcJ1Vql6mk8gqZM70DgEtb6OA/rTsYias+7W0qT1XCuQBnbXng5KtAJPVRSBi95CxmT
         dS2x+B9QHjP+/FlZWUQUN5shsZX5dDsbJfyteci1MVpZuKXvuNuOvwrD3xHZTL2Ses2I
         lIZ3NC9P/p1iflpekcLvih874d0nCfeCPQogn3pbmH5MNjuygPi+qJCukm5KsQok4kIp
         WELktbfTVdOuqiXgyMFr1rReYvMvrnFMV0MqROZqA4ymVyT02EhoTx6DWjmYhEbNEZZO
         7QcA==
X-Forwarded-Encrypted: i=1; AJvYcCU17u6UA45jjrJXxnzyoCXCjkiIibQYyDvWNsJ23inIMJiqSaIszqDiSBw/49P4fIUI798EFLzT//vISCU=@vger.kernel.org, AJvYcCWQry3FrvC81VKSI/PMDcdf45NowzAKJbFbqDHUKjwqAU4l0PpIH49P0RZtEfZ+1vITDa6XC8FZT+Egvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YydDNxsZK7SOZ0FDK5cDMx7MTD3zPTClc7YexpmZcGx1/lKJpwG
	q+afbZE0V6v0xwrPbtuiG5/Wd3+cb/SI6CxpyR5bnVxeKW5nL7To64Sl
X-Gm-Gg: ASbGncuOFELrBUxWV8p0kf72aA2qMF0XTCPlRftfNn+frCFtg/VdYKG+755Q6pN1RK/
	Xy6BHKuOST9qMJ5RRzAWpS6oJKfNiOhHCvm7qwOfuQVj1ToKLOr8H/FnT83BCDBM1X3IqFZjRol
	ZWQIL4djD8o0SBWLmEHGxgZZyxQfYUXWtM3JsotYJT154or/SljndJRmnvBVUcvz+zQNBI/jf4L
	WSG8NI43HVU8r9emIN2i5Yu6NUlDGxEAS7hmKFXzfaVYKDvrxDhWZe6Avt8x+ZOLuK95Gt7nQLe
	JITiWDRbRHx7hWSnHF//riJgqwen+GhonuTsT6gPDRbDe737sCJy2GCDvtsWlumdrXAwPFo87tD
	b3f37uxBJwiWlhiMh4Gqt5JLZNhCfg1x2lza/pn863sALLw==
X-Google-Smtp-Source: AGHT+IGxvQqGns0eROM2I/jmNvCWGZuNZOziziy5pguoweis5OA3MUk4N+PZw1Aa3ZnVrZVPbB+jfA==
X-Received: by 2002:a05:6a21:9999:b0:23d:ac50:333e with SMTP id adf61e73a8af0-24340e6bd14mr14100146637.43.1756058552653;
        Sun, 24 Aug 2025 11:02:32 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7b6fbsm4743532a12.30.2025.08.24.11.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 11:02:32 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v9 1/3] scsi: sd: Remove redundant printk after kmalloc failure
Date: Sun, 24 Aug 2025 23:32:16 +0530
Message-ID: <20250824180218.39498-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
References: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SCSI disk driver prints a warning when kmalloc() fails in
sd_revalidate_disk(). This is redundant because the page allocator
already reports failures unless __GFP_NOWARN is used. Keeping the
extra message only adds noise to the kernel log.

Remove the unnecessary sd_printk() call. Control flow is unchanged.

Fixes: e73aec824703 ("[SCSI] sd: make printing use a common prefix")
Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 drivers/scsi/sd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..aa9d944e27c5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3712,11 +3712,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		goto out;
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
-	if (!buffer) {
-		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
-			  "allocation failure.\n");
+	if (!buffer)
 		goto out;
-	}
 
 	sd_spinup_disk(sdkp);
 
-- 
2.43.0

