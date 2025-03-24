Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9467D136988;
	Mon, 24 Mar 2025 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742806301; cv=none; b=UbH1tCO7tMiPJz+3NPgGQPyXlZcOenO7NvZ+YU5fzHTQf1RAO8bAd+peL5aZ9fE7zUhYPVWPAc1wbpxKcZhFjvnU2p1cyrQFevYIkGMz1iXSFCCNo0a70Vu6PzPpKXziFACKmZRkNPq96+CHfLy+lRAAMlxtfJAGqB1TPkCMN/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742806301; c=relaxed/simple;
	bh=jMs358a025W5rZlrGuf3EpGosP/aRmWTeL5KWdoGoeU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cp4Riq/kCJkJvJrXBte5qugSQ9H07xRZXzEqhTJS8sbNfPKHbnPwQr7R8JH+lARljdsxJKNv/VDDlctsm0A0PV19EsUOQj0Tw39WBBWvf1GDY0O1b03tmR3mOkVxS+waMZechmgSAJa97DIujVZhrbLwzRfw/YngszjFIGKUwAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=txuDlAgE; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=gefietRw; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="txuDlAgE";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="gefietRw"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 2600AE000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1742806288; bh=44lYnrkjFp/kZnkuZ5MNTXbu+MbDe/0CqTQuJddqXAE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=txuDlAgE5oN6oF4clLDa95SjObJoeoLi2UR4zE/8fqbWkBiSRLkhzB/lsZaj/9DJi
	 6hPW+xYtMAMJUck/mbEYObXK9pFTDd2d6QPrMfGYUYcGA29qt2nAqXK6YfVq4upjHP
	 f8vocD0QMexQjwtyOI4hbLnkGBFu1Gx8IQNXFzVn5IhOAw0rnfUCClvhikQxuAIsP5
	 TLcHEwHrV7s4RhCOgFQTWW24Zb1B1yeeCZl8Dajrc9NPdo0NJdRncq3nJMQ3ALRO2O
	 sfLFIBZZDzmXtqvZNyLDwSx0DPoHbInMzLf0OfU6bdDEqExNZ/Jze9F5Ge+EIx3gCR
	 DgDIesUGZNBlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1742806288; bh=44lYnrkjFp/kZnkuZ5MNTXbu+MbDe/0CqTQuJddqXAE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=gefietRwEioMA2JHwB1QcBOeGHbXxihLwZJt9ZgTBWDyY3WBsmddRw/IAn+vULsBz
	 Isr9SlJ0h7LtUFG1rj6S9Lv1b6U7tdtFqOKu0+Ez/8wm6/7JXa+hNvCuoErWGzqY1T
	 3hnVSDnNGu+xXKDstVD0urFQNqHJ4obBdyeXn0zq4W6dUR4nXb3Wxc6Attb3E5gwny
	 FlRlqPvUDmGCOkLQj5HQV2rkH70sShLMhFEnTetMGOnrIHoWM1TXRydPpmZDnc96Uf
	 dOUMA25qUgdJWF87MV2xW9x3FMuSM/9CrB0z/ACzY/vbVkowz2U3R/nSet0A1pS0my
	 iSVMusZ+lElGQ==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<hare@suse.de>, <axboe@kernel.dk>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 1/1] scsi: uninit not completed scsi cmd
Date: Mon, 24 Mar 2025 11:49:33 +0300
Message-ID: <20250324084933.15932-2-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
In-Reply-To: <20250324084933.15932-1-a.kovaleva@yadro.com>
References: <20250324084933.15932-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: RTM-EXCH-01.corp.yadro.com (10.34.9.201) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Scsi commands that have not been completed with scsi_done() do not clear
the SCMD_INITIALIZED flag and therefore will not be properly
reinitialized. Thus, the next time the scsi_cmnd structure is used, the
scsi command may fail in scsi_cmd_runtime_exceeced() due to the old
jiffies_at_alloc field of the scsi command:

 kernel: sd 16:0:1:84: [sdts] tag#405 timing out command, waited 720s
 kernel: sd 16:0:1:84: [sdts] tag#405 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=66636s

Clear the SCMD_INITIALIZED flag for scsi commands, that have not been
completed by SCSI, so that they can be initialised when queueing.

Fixes: 4abafdc4360d ("block: remove the initialize_rq_fn blk_mq_ops method")
Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/scsi/scsi_lib.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 79a8fb317a2d..db4c0f07ea72 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1237,8 +1237,12 @@ EXPORT_SYMBOL_GPL(scsi_alloc_request);
  */
 static void scsi_cleanup_rq(struct request *rq)
 {
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+
+	cmd->flags &= ~SCMD_INITIALIZED;
+
 	if (rq->rq_flags & RQF_DONTPREP) {
-		scsi_mq_uninit_cmd(blk_mq_rq_to_pdu(rq));
+		scsi_mq_uninit_cmd(cmd);
 		rq->rq_flags &= ~RQF_DONTPREP;
 	}
 }
-- 
2.40.3

