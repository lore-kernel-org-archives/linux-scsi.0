Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF302D97BA
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025857; cv=none; b=WpZpn1Ws5AzalJrisr1L0OV9q07BF19LT9Qkf9TLhTnuJK1fO/SQ8wWqRkDZ4vF3yZ8ya3hll9iLfDIqH2YQtajR4eZTzjOT1c5HDyngz8aOuNgPnSeDIncq1pM9agRxL4yjvmWuKJmGb2QLMFj7TCUsTNhH5ScYHCES7kK/fB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025857; c=relaxed/simple;
	bh=WWTcqcrYuK6IbdrjMRhsuwFkgDt4+Cy7tBLo38z8uik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrXnBSqOD1Obu8AVXAajq46OvpaVFy8igTF1DGyEgtvqQvWDUYSw1so5f5rSAuH+aic8ep9D9U7ThU5k3w+f4PpkusTQ1l3DAcI+t1Nv8byB3uP9hjWCSPgXwEk2rHrp4Y9UiW452ncodK5QjscNtrK4KJuN86co62AfEOHtb6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=TEYYofoP; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="TEYYofoP"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd632f7a4a1so296450a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792025856; x=1792630656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmaZjOlL7Z4YX68oXGeP0K0pl8aIA8E2Yu5c3A96tCc=;
        b=TEYYofoPD2E+QW1x2bOy716DFgT9UFHODVVVdpRlrD4pDfC0k4S7eqvG8cUAdhehyv
         SPGRbmUCbK39jxgS+ZWNOO4AK77vnS/sJ7hnDMOHne8swW66KePsvU0rAGJEd+zVqvxY
         mrohmmyacdp3BCfxqoKPHz2hivsnqf/zv+AtmbzhTiwMMt9t2WrCbjVsVxcAQ1ZbSNBC
         MmK9c7Ed8UcGgRQYm3juT/zAlkliTjaeZF/sVo1YV90yT4PT2JCV3rJE7585UVkMe/w+
         L5h7lAG0NnxEqFvStAj6EgWCZeXa7qaRHGqhjoc+oAv6Rr13TeW6ewxi5kJqIw3sJKNs
         wCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792025856; x=1792630656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmaZjOlL7Z4YX68oXGeP0K0pl8aIA8E2Yu5c3A96tCc=;
        b=pB7wi2XC31XQN9Pw7AHloWDyY281+rY1KRpQs0DK2xH441UX7V587+tPt4oxYzckq7
         rFVAFoBz52PLK4tFbJdgIbik+xz5rCy4Oduy5WEiOyykzdlJE3BRPjSBMUXrRi/gkCDt
         ukGMk1L/NgHrd20Gt402m1l7bp8J3HzQjvrzsNq5p3xmf7AbnfkN7FpHlSY9YvYVIMM6
         EOKpsaOTnxfxqsnI/l1fOM4BC6AJi63yLG8kcnqxE4SqCIU7WC9Xgp+EpIyio1ezzyZh
         aJIJf3YRr9Yy8GERdw/yazI0hxs3E1SHBqw774Q6H/9XucPTdx4lS+8NNkwDg68fP/CZ
         5E9g==
X-Gm-Message-State: AFq9FYK4AxlCubjrsxcyREbE4cgf/7iAYfrwGW64ybVAs9/LGO9yShbm
	KSaYz38ORVqQ9EijVoSkVfSrS/i+Dt/68PFYaBdIw5bgDo6A5i+MjunLzihv+VWv5qI=
X-Gm-Gg: AYBFou3x0p5RdP13gwMY4R93Nx1xS6nW0RDB6cLkM6bjHU+rKEwZLsE7hkSXzKF3StJ
	W8cCDaNROt2yUM4z3PMXQHzZV3Zx+jGPVTDvwVJkW8V2VgF7GmQg4aFW2QoI2fJOVXf4fihGTTw
	F3I1FnVbAG7Coi0GX7pL2xfj9UcijkXK9m+poVnZMg59Hm0wkTPQ/vUfql2BrhhiHoFX0q59D7t
	IooDLJm8G04rfgv7ExOuPZilk5jSi2DdZ4ShCcz6sD0Y/ExlQoXD1qd7+LcJRrmOC/6VxhmREFo
	ma/nKFd062D7y21J8KDlVyu0dnPuy5y19NyKT0s68MxeLt9ty5VHuMXlBDBREpoq7+HtURrsMdU
	a0qhkuGbdPdk7wHbx1UVyPTZ4Se8w6pz5Xaw4Dc1croIycYCa5gm2tmrKTFZiTyCygwoSwtlq+4
	3lDNlK2rPgG9ZGyXvS/LtSYf7S+vhkKzZ5I/rVEaneLGzDcQAB1T+XyBlFDCIydDeo7iqwwG5BZ
	/kb9ce21IQ/+vCy
X-Received: by 2002:a17:90b:5546:b0:3ac:4e76:36b8 with SMTP id 98e67ed59e1d1-3ac4e7636f8mr5066203a91.5.1792025855959;
        Wed, 14 Oct 2026 17:57:35 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac92a43d98sm999198a91.0.2026.10.14.17.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 17:57:35 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v7 1/7] scsi: mvumi: bound the per-event parameter and sense dumps
Date: Thu, 15 Oct 2026 09:57:11 +0900
Message-ID: <20261015005717.3719956-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
References: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mvumi_show_event() prints param_count u32 words from params[] and
sense_data_length bytes from sense_data[], but both counts come from the
firmware event (struct mvumi_driver_event) and are never checked against
the arrays, which hold four words and 30 bytes.  A firmware that reports
the maximum (255 each) makes the loops read far past the event and past
the 512-byte buffer the event block is allocated in, printing the result
to the kernel log.

Stop each loop at the size of its array.

Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/mvumi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index e70d336b4ab39..38a92f8c25f5b 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1361,7 +1361,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
 	if (ptr->param_count) {
 		printk(KERN_WARNING "Event param(len 0x%x): ",
 						ptr->param_count);
-		for (i = 0; i < ptr->param_count; i++)
+		for (i = 0; i < ptr->param_count &&
+		     i < ARRAY_SIZE(ptr->params); i++)
 			printk(KERN_WARNING "0x%x ", ptr->params[i]);
 
 		printk(KERN_WARNING "\n");
@@ -1370,7 +1371,8 @@ static void mvumi_show_event(struct mvumi_hba *mhba,
 	if (ptr->sense_data_length) {
 		printk(KERN_WARNING "Event sense data(len 0x%x): ",
 						ptr->sense_data_length);
-		for (i = 0; i < ptr->sense_data_length; i++)
+		for (i = 0; i < ptr->sense_data_length &&
+		     i < sizeof(ptr->sense_data); i++)
 			printk(KERN_WARNING "0x%x ", ptr->sense_data[i]);
 		printk(KERN_WARNING "\n");
 	}
-- 
2.43.0

