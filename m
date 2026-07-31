Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2099D23909C
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 21:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534771; cv=none; b=MNzEA6CGHQ4dTwCCG3Qt11Qh1JkvXubUePWj7rOrh6b8zCYWQaHEst4EbMCEL9SKaxeZclZBVu+KcSq3zPDf0RGA6T4LdoEVZ/4AdGxqAumnDcwXBm07LCjFslC9BFdUnFjaarkELem+SQod+cWKaoWDHGwhY0L+ATMYOwrwuq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534771; c=relaxed/simple;
	bh=abwWQD+IQSdGT6r0WScaz2VKBREvmME8iEAD245H+/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWrUSvdbeaZLN1V4ZMIELtW5iY7D0gfp3VGHk7l2hPjIp+eKKN8lE0T397cbYO16uzIvnk44HF8cHuXFWY7A1LsflcSKAKVcQgUXE1JVHzzKxOgfiAJBXbipIaX6pA/n8SXwXKQP4K4R6gILTbMTccAyAgtulZcXYDt0nUTtkUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UR7h4BnY; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UR7h4BnY"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hBfv54g00zlfvq2;
	Fri, 31 Jul 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785534764; x=1788126765; bh=26Zkn
	Lonb/UIwuHRzZaEVnDZAX1RpgEquLXinRiQBTI=; b=UR7h4BnY/mMy7D1wjlKWY
	AR3gHetEh1A5G1nEZJ9/dBbtzHy8zv785w4MI0J18BV/YKngEQ75h8/2Vh24jsh0
	f8pUYSOydkp6lysb/yrE1f50cnCdwEYd+8UgKhZqA7n8w/fE2YogDqyAG5ER6vvK
	0+LzTtusL3RacA6XH9e+lF3yAb3wVU34CHIBDwNUKMFO8/79wzBWCRUTOnfeYcVc
	+h5oHGMxTooccyStDqJsvLdOdSaCwcXXa70oYOLqdStF9PHfc/RWEDKyapCYei2C
	jExUAGHLenP0qt+z9+rYOEQtuvy309lxo4xhdujMPtGxBntG6FCuHTi5PXeI4AKs
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8aQQR8WcDfwJ; Fri, 31 Jul 2026 21:52:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hBftx46C4zlfvq7;
	Fri, 31 Jul 2026 21:52:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sashiko <sashiko-bot@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Stanley Jhu <chu.stanley@gmail.com>
Subject: [PATCH v4 1/6] ufs: core: Set task state before io_schedule_timeout()
Date: Fri, 31 Jul 2026 14:52:06 -0700
Message-ID: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785534655.git.bvanassche@acm.org>
References: <cover.1785534655.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Set the task state to TASK_UNINTERRUPTIBLE before calling
io_schedule_timeout() in ufshcd_wait_for_pending_cmds().
Without setting the task state, io_schedule_timeout() returns
immediately because the task state remains TASK_RUNNING. This
results in a busy loop that wastes CPU cycles.

Fixes: 2000bc309703 ("scsi: ufs: core: Reduce the clock scaling latency")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1a5a851d43b2..5f99aad26d57 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1317,6 +1317,7 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_=
hba *hba,
 			break;
 		}
=20
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
