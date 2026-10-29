Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257725;
	b=b+n/osvfwB30SqwpQnHIAwH7Mzm2CkMAvwmEgsYrH3ni2ziMW8XSX/K7Vo+i8iy14ZS+
	 NlDLg0Sxx7+eWY7NQDy9kGWaB8PLv4gz76hU5VN1gphfvioZLNcLTC2eE+wpFsDpvvlZp
	 Qu/czArgDEilX6Le4D85WyE7kQkarjatOVdU/UIYW492Bx1cwX98oap1+85F72xAYPTKh
	 QiCJrBamnW6pBTn6I8eWEXTTwy/XQkHRBJyU0SCd5SdGkDYVh0zMlLa/h7whHAczcDSVz
	 UuyXACqjXaoPm/cLsv6u/DgBL1mg3g7mv5HEaMUmYizHoR5spYlJCgDK5HKyPizwlGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257725;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=c2wt0/O9P4h169mOPfGdNt9HMfMIWbdoAewi8Z+Zhoo=;
	b=mvkoqfU25IoDCfc8xDWbSuVoBhrQFhj0d5AMHsXK52OmAa03cJ363V6xupMqnqmxJILb
	 ZSGDAW8/IWayiU395X6XchnEc9vXk2eVKxm400nJkVA6qPyGSNka/z4exaEF6Sip5U/TP
	 dhTcQIrr7aLV58alViPk+1BRWtar9QbLtmGo7auzcISATMAng4iahJW4G9wAN60duCMzU
	 LW/ajknqw/SopsPELfYLFReGSLZD78CFTiVwfgm89jSVugz22Xe4UXhhXZCFPh6+AKNv4
	 AEKAZE1BxJn5RxHtTfqb0zDs5Vm4jVgzB2lFuNKDiL9ZtjiB2aqkSzsjfa2oAqwpanA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=G8w0gCtP;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A526606A33B
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:08:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A526606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=G8w0gCtP
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a08e315b5cso835350b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793257725; x=1793862525; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c2wt0/O9P4h169mOPfGdNt9HMfMIWbdoAewi8Z+Zhoo=;
        b=G8w0gCtPvtHfdPkRoHpX5bKVfSBj2vbcM8IdNuCuhd90wmJFzTVagaN2CO4SH9D5Qu
         xhGqnBq3HBijXRGx63AGeG5LN3vBbsDSUWX+oI3R2Rv57lHs6npjOM78etALD5USt09X
         ZL5mvZvwhDcoWLldvm3+tuQiWpyFVY3rvY6fvX5Uf+JKe0dfwMAHvCRkTCLrD8duQrbp
         M+UUeXG0g8YpecEmSMvan711a+DKe3HEMp2mFxJc16PIPx+xZKlRrG7/jOWLoMl4W7Kh
         2kMnSrWEmi61LMchzpdmoaihOhtFhVH15cfVZYUyCj/5BEG1NNm7RsTfXJ1gQ3zmI5NM
         Z8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257725; x=1793862525;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c2wt0/O9P4h169mOPfGdNt9HMfMIWbdoAewi8Z+Zhoo=;
        b=ivIuzukH8rovjlPbj3RbXRwRzzFXu5fGvkAYj5H+cuHGT64CfVf0q3SvCK/bT/l3Ks
         0V64JTLkkAdb56vgsxje7Z9TLvQ/9YKJ1D6hqt8JucM3LdNIOQ7+JNDloewoQCf0/6p7
         FF5oBKbUvkxVvy6QSJz7VCdT/C7x63FqswNnaOwUp/rQv9NZwNZ6NZiN9r1HSKS98QGi
         LQdWZ9e7zGmlSgEsLT9i3GNmvrg3bw6xFgz3ovHlbrFJeiGccPfim9jSjqsOW68mqNZe
         zcvCrTM+owgD5rOK0S1hrHNwVGcPvF7Q92YsdcEwE/PiKdPDJRBvfjmQ/lJqzx4btyzp
         weFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwFtU/bUY0mIfHlKmii18beu3L44mQ1GtPjfXZF6aLzbh6hecfdrRJqlQZrYM7wtU0B1mWx2mZ+4/TS@vger.kernel.org
X-Gm-Message-State: AFq9FYLQA9eyRrTxxiXBjJzje4IBPkgqxbwYsiXQ7QnHKcofUWkjCxGf
	euwcq40erJ6vJyrtHJTomhD/34NDcDk6S6PHTygpx7jzR/eJmcpx6FS6VD0AsNUnuTGX7QzukOl
	SxXNrgS+bQ/FUv3Z6uv2Enw==
X-Received: from pgdo13-n2.prod.google.com ([2002:a05:6a02:620d:20b0:cc7:52da:b682])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a21:b0:3e0:d5c0:74b3 with SMTP id adf61e73a8af0-3e90243d45fmr4171831637.65.1793257724559;
 Thu, 29 Oct 2026 00:08:44 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:08:36 +0800
In-Reply-To: <20261029040003.2100003-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029040003.2100003-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029040003.2100003-2-stanleyjhu@google.com>
Subject: [PATCH v2 1/5] scsi: ufs: core: Restore jiffies conversion of device
 management timeouts
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>
Cc: Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Before commit 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()"), ufshcd_wait_for_dev_cmd() converted the
millisecond timeout with msecs_to_jiffies() before waiting for the
command. That commit moved the timeout to the block layer and assigns
the millisecond value to rq->timeout as is, but rq->timeout is in
jiffies. A 1500 ms query timeout (QUERY_REQ_TIMEOUT_DEFAULT) becomes
6 s with CONFIG_HZ=250 and 15 s with CONFIG_HZ=100, and NOP_OUT_TIMEOUT
and ADVANCED_RPMB_REQ_TIMEOUT grow the same way.

Restore the conversion with msecs_to_jiffies().

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..68a98cde5812 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3390,7 +3390,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd,
 	struct request *rq = scsi_cmd_to_rq(cmd);
 	blk_status_t sts;
 
-	rq->timeout = timeout;
+	rq->timeout = msecs_to_jiffies(timeout);
 	sts = blk_execute_rq(rq, true);
 	if (sts != BLK_STS_OK)
 		return blk_status_to_errno(sts);
-- 
2.56.0.313.g2479322e68-goog

