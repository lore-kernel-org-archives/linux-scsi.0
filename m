Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91302442F
	for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2024 01:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734486145; cv=none; b=HLgH1Ibt2dC4wsEcwxqRHwdsJ3fJm740KSFvcqegCytVWk1QxxP3wjAb4ol+Hu6yV71c94Ojf5iiNy42b51LtzedL4gUOXCmq7YoZFV5oID5zpGg2hLjwu6bkajNER36GnIxPRNdF0KCM4BoLz9cwWBbzOAKZFj3/eBM2nULdj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734486145; c=relaxed/simple;
	bh=a24ICNyiZz4BkIKRwq2stCG0DsVCrQMlJaDMx4t7SgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ezhe6D/uajRTEcaSrYk45eNEwytl9Ozgi8s5o9WmhP8SjouWFB6uEVGkGZVyThggVApc/W+DVlXY6GLLfLUZpZbtA8mJVGDphRG8KymrhX33fCN2nwl00rh2QnwPl7321v/Z5znxpchdz5noyaTOAjh3vFYSyyaBiFSpQR6QMKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EQh+0dq4; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EQh+0dq4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734486139; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=J6yZ/ZysNF4pfV5L/uKXRbg4uUXx4+pvNOxSbRVtodk=;
	b=EQh+0dq4nZaECt6txXC8qQ8oVzfYASZIVneuOK3jTHBsHrudCgTRZ9fQaljeRMwKqUVylsA8OiY2xWz2FK208IFWvwKnrMsj8ZsQFB/V2b4DKnreD+/YgtR810iWZh+yBFv+CJNMkMBPbVTK5N0O27F2mg+o4xjEBON5xfXMxGk=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLkhQNN_1734486134 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Dec 2024 09:42:19 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/2] fix some bsg related bugs
Date: Wed, 18 Dec 2024 09:42:12 +0800
Message-ID: <20241218014214.64533-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes from v1 to v2:
- Add fixes tag to the first patch.
- Add rb tag from Avri, thanks.

Guixin Liu (2):
  scsi: ufs: delete bsg_dev when setup bsg fail
  scsi: ufs: set bsg_queue to NULL after remove

 drivers/ufs/core/ufs_bsg.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.43.0

