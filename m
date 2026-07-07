Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94583603EE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 03:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783393452; cv=none; b=FO8aPUmac72A6rNQwG/K1sTZSnApsXFmr76/nuL2beYc3vhsVyl2QCsSOl4scV+lRQPgQ34XGk4pRsmY2H4hvK6dwHDLDXzNOMErvNIpGRfRNH4UBeX0Ays5bXFUs6hPpSaAIEdam1X3YRfb+End1LQxUosytTb4CCVhKWTuqFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783393452; c=relaxed/simple;
	bh=EzkzojQSSbHiGfNtB88cJLqYSi9Pq0yRa/rOK1a7pG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jgnJmHLrnn4N6Wil2/9L7YzuABVCnZHQ66oTS54YOlhp2rbPkOletuWf9qRvk/HS7/c3JRD71dl8t90zzGC9NrSE+uk9+52IwIFUaIYw83OAKy1BWy14H2kKiuSdLayAWNFwXWlds3rEzY4VE3wzXnpviBZgvQgifHQZ8Q/nQW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NxbycRTy; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NxbycRTy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=K/
	mG0bGefzmsN/ihAQ7LmR0J/95mrKtn2QcAxqgIH1A=; b=NxbycRTy1F9dv41ngx
	pY5DxW0WenuBZgEktEtVOZtzmjIdTPb/8q23zCoNTuybAO8j827SEZ8pQFetGAZI
	GV22JNa37prBK9zsufO5UTF79zCYCXEpHS3PLbDLK3eYlqrOSi+dz3EWs0efbgj3
	oSUTo5vwl5kaOL1KuWKBwQX4Q=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3HB2HbExqrYb5Fw--.30099S5;
	Tue, 07 Jul 2026 11:03:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 3/3] scsi: sd: fix sd_done() sense handling condition
Date: Tue,  7 Jul 2026 11:03:33 +0800
Message-Id: <20260707030333.22245-4-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3HB2HbExqrYb5Fw--.30099S5
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWxAryftF1DCrW3AFyUtrb_yoWDJwb_ur
	4Fgrn7Wr1j9rsIvrySkrW3Z3s29w4qqFnY9r1vv343AryUW3sFga4jvrZxAF48WrW0yF15
	Jw4qyr1ayr1DXjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnr-BtUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Q3rfGpMbI0fZwAA3M

Only enter the sense_key switch when the command returned CHECK
CONDITION with valid, non-deferred sense. The old condition let
deferred or invalid sense fall through and mis-handle the I/O.

Fixes: 03aba2f79594 ("[SCSI] sd/scsi_lib simplify sd_rw_intr and scsi_io_completion")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8fed1cda9ac8..a1b21ea14e54 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2419,8 +2419,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (!scsi_status_is_check_condition(result) &&
-	    (!sense_valid || sense_deferred))
+	if (!scsi_status_is_check_condition(result) ||
+	    !sense_valid || sense_deferred)
 		goto out;
 
 	switch (sshdr.sense_key) {
-- 
2.25.1

