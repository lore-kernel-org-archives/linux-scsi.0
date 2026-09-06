Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DEC3859DC
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 20:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788726183; cv=none; b=rnFcPFbtXUuGFtrHroybN1Ea3Qb8guuX7A669DijGQMe2NAddAMHPdjtQf/omzv2SQbikNjQoR3LgKToe3GLBdCrWCFXLQWcUKxE7a39QWX2S35mxwjInqqh+MA0VKEo3kcMyXULrpOueAzl/J9+Q3VpjBFumdYadd9yqR3qO/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788726183; c=relaxed/simple;
	bh=5mxvOsv8nCII7gEdYfav7bjQqgxjWLiZKvu4xBlOaYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cvsAw54Ttu8kzhpZxGBKpr3jk0c3R9skYXFtBlNp+i9hTOWo+vNhBPgQZ80fdac0gWY62SgjZkLtJQLOAviC8fvxtTeXAPva5xBOsZkF64keSeFYYj3L0LLPolqgLyQfX6dmtvzZQwd0v+hPv5AbvNYUTojkUleQHHOB7Hd7C8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUs9T3VU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUs9T3VU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d032846c95so30479565ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2026 13:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788726181; x=1789330981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p2SYgP+pKU8rLYSTxOYL/j57xs0a8PDs8sQOKP3s3I0=;
        b=BUs9T3VUEB9RmW/eeZw9IzxEOC2Pa0sfcGBZdtHT6rLunm/uQhCTRbIEz8GSQeAj3r
         dfF+bpth2QtM7H9s7nYcu+7NdAfHi01G22ipgIav56j8RqweOTdFKm5TDkfE1tlX8J1T
         dGzUt9HEBgpcbsXEEP+IV74is3oiqXTB+/U28ymv5KqffgkOw3U5z2haSj4AubDJKQKF
         1fz6vEf7ocxIJMA5wEkxT0eyepO/gZU8Di0oPQHQ5dDhcm2PimQk3Dc1dyS1aUVGiWNK
         xCqC54aw6GalBoxDfVG1qDHfcWcxF3YYh36lvF79feZh8TyzHFpWFdEJeNL6bhmDGDhj
         TSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788726181; x=1789330981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p2SYgP+pKU8rLYSTxOYL/j57xs0a8PDs8sQOKP3s3I0=;
        b=LLQ+7bCLjlaEWE9TS5a/+DFHAfHWNTpMSxcqGj74/hIUJxFLvCxAQhqvrbgtZguO3Z
         t3GNy+kKSNKGYH6/4+Q1w+dB8biFAop0WbVw5pMwuNDCiZPGt8+dG0xeBRMqz12WT3Qg
         9lGtz2dkBQCBMqzmjO6C3MO6d9t11ODCAhTGN5I52pMUQ7j6GPJDhuO93gq8PtjirJRt
         RtQuE4yedZcQHywPD7HlFrZ5CAmrhEVywwBcZFWveGm82Z884HBFZN/iSVlMj8gxQrUL
         kaFFkTz12RoS8J7cNxD6wpDMtF9OT8lc+/Q3pXsqb4c+Oe/Mi1l7WiqTJUfE7Zv+3UBB
         uSdQ==
X-Forwarded-Encrypted: i=1; AKwUvBzw9voTf/tShVqTofF06GcU4pRgQOmxakIcyEHzssM2RWpqnuJ2jwFBsZBu9EtlqnOl/q6btKde9FL9@vger.kernel.org
X-Gm-Message-State: AFuF++lqsX0oTHW+vstpXAyPZVjF2j0js2YR9dJdFl1c4s10LqFEVUBk
	ZZ1r/pMNU2afU0ZoAwvWRIbSu6VpADUfal7ZUnmj4P5duQP3ZpWyOqyg
X-Gm-Gg: AYBFou1LvcaBafQXBfWjTRHyer/dBAob56RElgp+UyHbqIloEEco4uaLN9YnsBHTdEO
	bMyjGa/MV9xGA8K2qSggl62hJ0IiJ+nOc4EGJSP2h5IuJ9QhvlOLZqdCgf8C60fHtfOl8wwyC0d
	qXjLH6KZXMSemyf0244JBQNZ8Gz2Emm0HISd30daX06DNhVc0/fnna8/af/9pI8JZp2bOOTQpnF
	tTJpAOFi010+sSMPEHZYGzc7aCp7qMcOTDUFtcDcjUP7bDwknVCmOX/aTd5rVD42IquQXbhd5iZ
	gX5wzaFlzY1y6YeKkuCV0e8ZceZ4lHHwMXx5wHs7GoMLGUES/1p9Oll8TD+v13rPhnF+1ZSjQ9h
	VtPX5/g31duoG1WOK0PpA+nMcR4YF914UiuGgwTnU1AlWh1WH8k8qXXVNiANDRXDWyX58OPTm7H
	hUYOA2p4m3nz9WE3qdaALoD1Vu6P5Zir8EgX/WJ8wNK+1SaYAaLBrJUQ==
X-Received: by 2002:a17:90b:1d45:b0:398:9bd4:d1a with SMTP id 98e67ed59e1d1-39b262995b8mr28336253a91.25.1788726181467;
        Sun, 06 Sep 2026 13:23:01 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::3820])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b25c974cfsm16736906a91.0.2026.09.06.13.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 13:23:00 -0700 (PDT)
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
Subject: [PATCH] scsi: mpt3sas: fix nr_msix underflow in _base_assign_reply_queues()
Date: Sun,  6 Sep 2026 14:22:50 -0600
Message-ID: <20260906202250.53653-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
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
plausible queue configurations (verified arithmetically), which would
either wrap to a large unsigned value and silently break affinity
grouping, or hit a divide-by-zero in the following nr_cpus / nr_msix
computation. Add an explicit check for nr_msix == 0 and also warn if the
reply queue budget is exhausted.

Fixes: 432bc7caef4e ("scsi: mpt3sas: Add io_uring iopoll support")
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ce5a5882acc8..31b80ed6ddec 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3275,7 +3275,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 fall_back:
 	cpu = cpumask_first(cpu_online_mask);
-	nr_msix -= (ioc->high_iops_queues - iopoll_q_count);
+	nr_msix -= (ioc->high_iops_queues + iopoll_q_count);
+	if (!nr_msix) {
+		ioc_warn(ioc, "high_iops_queues and iopoll_q_count exceed available MSI-X vectors\n");
+		return;
+	}
 	index = 0;
 
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-- 
2.55.0

