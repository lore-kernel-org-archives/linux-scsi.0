Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E740215F42
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788729307; cv=none; b=ei4IU9Xw5xF7PgkSbsrcClDV0CWpwgQ3QkXxe9iH+ev3/bSzHY4NOM/RzZcl6Ie49po5HYVVOhYnl+O9tNNQ22EoJ+rWkfv24mPWHEDCRio49saMilxQChntq1kV89Q6AbJhz236R/YcXHO8JVpePRQtPbN7CdRHq6wiD5ZayrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788729307; c=relaxed/simple;
	bh=vHHRUN0nu/6JFyn9S245jefHltW7+qiKnMMQksi7KP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elZmzHCbA9BeBWPbWcIf0d/oIhj6N2s0baCuzGtivB/y5WV39S38+9MjmrNDyrzfTxppolUhDoPEZMQe96CqptfRtxJiGEbLgAQ85vfo7ghBhuf6b7kb89pOcRHjWBODOn7blzUi3PUFyrZKRhvrxass9rPgELxQZ+tFgiQSEMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F5wKHEZN; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5wKHEZN"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so2124317a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2026 14:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788729306; x=1789334106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WUwZ4TKhPngatBg1HvsgtjPHLyp35oaMbmzVwgRy3+Q=;
        b=F5wKHEZN1VVU0lDIm1cHkUi6b+atwv4MeOszDA6jv+W2o8DYs6p21FXxh3z9ph+EhK
         zGlzwtR8VGGtn4YTTscHLdjiXlX5EsAdgcl9vqSGJnn4eFKi6qs3Aq1//JaPFjuapB36
         93Z6p3rrgwd3BRAUhNOfD8otRez8bXRAuqlDhcMZc/tyva0eCzyZ2LdXKAj4lAnI2bT3
         +xn/kBITsBPGMjwEI9eQGuHzpugdIUJ6iM8hj+TvAxhlUwQuc0OKRpj+lCZhzYyOg/83
         owmLGA0BQtZnyFE16/5brEcjzic0CvJG0ui2qQWlw7ewPiTOWBNcMDwcithhOa87BeUR
         dpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788729306; x=1789334106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WUwZ4TKhPngatBg1HvsgtjPHLyp35oaMbmzVwgRy3+Q=;
        b=S+fNuGmH3WN5Co8B51qrs1e54hePi9yT55HJX24tq+bmPpI09VNn9YNVLLSrLalCYx
         J/wkRGr8PG+OO/2K7MehA5Tc/yIDP0OqSSynaxk68az7R0Ifq/M0bjngk3lU+AMwU9AF
         tLbHHV4fVhaGQD3tte6NKDJhBiKdTABAQQ3+6E7bCCulVpXi7TY+jn1R88+vB99JDG7L
         XcZkwj2TUQ04dhFGOTZsHBMwPPB+YUHiugwADINd3XB8TAnu5SPwzway+Dd1oN+GVEAR
         ANK53VkGW7u4TKFN72YpiT86zTiybNq0IqAj0a3OGtAvuzVWQXzTmaFFbaQgyOd2EnEk
         6mdw==
X-Forwarded-Encrypted: i=1; AKwUvBwBbX3YS5Bj9CPTMkD256ffhhxvB6WgzNC1dQl5w5hSWPu/BDlJJyg7BeYJxZ6CrWHOE3nafrtT+nAW@vger.kernel.org
X-Gm-Message-State: AFuF++nkXJTeeT2xUOhE4HZLmSj3g0G0LkuSNmGVl/mXkMzLTqjWWox4
	Pf/rwgG/qfYR/EpIKH3zuSGAXk9cw1ZgjBlxHzAo7TNHgkpdeICz5/4C
X-Gm-Gg: AYBFou0zU4cQ/MllQZQqrxoFMI/GEOAJfWWIiRVKArCdpJoiOiAhQUqvXc7lWNGCNZ+
	BLa5hFazvpkERSBbd2jid5Ba3oWbjOaVQgsrQk4yXha5/V9dQWoBUFoNTyYqmFTQljIzj/5ecgo
	DFDzwjKnDjgjqfR4B8IuVVRTzyamHQ2u1hEImr1aDmMSAEpNTyjNsRlw1Tei38TF+aLWyibdJWp
	nIaUH3uEX/T68DjYlZGrusxgEs3n4sDQuYlQj3oU7TVJsb3QuIdFIfFR7ldwDfXzNG/B4Kra/0m
	i0wxGJRRrGAWDo0eyHC0f5Wze2sKjFjP7LQvLcxuwg65NzWe/EjMCGh1c0IysmNB7hocqH+wDpG
	CuRD6T792OYY0kmkQ7rr7D9tf1Wwp2RvytMmSpS75guPyhoORIbsR5pFPAcyVTJB7q4OXbtINOy
	GoQ3QPqp8tB9jFB1eW5MXjXEXqwphtvCygI5E/dgBeIOss5XM8AX6+cw==
X-Received: by 2002:a17:90b:4cce:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39b260dd4e9mr31172440a91.2.1788729305628;
        Sun, 06 Sep 2026 14:15:05 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::3820])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b4b72f62esm9617207a91.5.2026.09.06.14.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 14:15:05 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH v2] scsi: mpt3sas: fix nr_msix underflow in _base_assign_reply_queues()
Date: Sun,  6 Sep 2026 15:14:54 -0600
Message-ID: <20260906211454.71432-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906202236.53346-1-skunkolee@gmail.com>
References: <20260906202236.53346-1-skunkolee@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fallback path incorrectly subtracts iopoll_q_count when computing
nr_msix, when the intent is to reserve both high_iops_queues and
iopoll_q_count reply queues from the round-robin pool. Since
iopoll_q_count can be positive, the current subtraction inflates
nr_msix instead of reducing it, leaving far more queues in the
round-robin pool than actually available once high-iops and iopoll
queues are accounted for.

Beyond producing an incorrect grouping of cpus onto msix vectors, the
corrected formula can still drive nr_msix to zero or below under
plausible queue configurations, which would wrap to a large unsigned
value and silently break affinity grouping, or hit a divide-by-zero in
the following nr_cpus / nr_msix computation. Check whether the
reserved queue count meets or exceeds nr_msix before performing the
subtraction, and warn if the reply queue budget is exhausted.

Fixes: 432bc7caef4e ("scsi: mpt3sas: Add io_uring iopoll support")
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
v2: check reserved queue count against nr_msix before the subtraction
    instead of testing nr_msix for zero afterward, since the subtraction
    itself could wrap an unsigned int rather than land on exactly zero.
    Thanks to Sashiko AI review for catching this.
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ce5a5882acc8..3810038dc2ac 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3275,7 +3275,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 fall_back:
 	cpu = cpumask_first(cpu_online_mask);
-	nr_msix -= (ioc->high_iops_queues - iopoll_q_count);
+	if (ioc->high_iops_queues + iopoll_q_count >= nr_msix) {
+		ioc_warn(ioc, "high_iops_queues and iopoll_q_count exceed available MSI-X vectors\n");
+		return;
+	}
+	nr_msix -= (ioc->high_iops_queues + iopoll_q_count);
 	index = 0;
 
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-- 
2.55.0

