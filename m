Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054B43E2745;
	Fri, 26 Jun 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782490304; cv=none; b=bgJ6039DqGdHr6NunT1Bnv88eP5143clnBEg3m6mNk8pA0j/A/hPSGTl89tXdFII4sUsKcTUq8GXUUgNuIebLgXcZnmkNqjl8KxuJ0vmzLW36z9hknm8IwHB4TexCFOaawRQYR9L1V4ik0BGMdlggjxXusSMg/muHq71XXa6XPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782490304; c=relaxed/simple;
	bh=JhYCIuPqpzsROBRMborDo+zF5VZEt7e4OKOmSwIMt6o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N2ICbOjiC/D+NwS4lR2eH+4WG1ZsXUkmu5oqHcDQwnB6+8wL+KK9UJPUz9PcANBPDXBV41H0VDcOZdKozf9dC7E8LqAl/BhMRCHGf/9iizxMaB54o9oZXHC47H50wuRV8H3S3no2o9qjJ+gnopOkNjlb+nSDsp/HrpxWsVmGVPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.66])
	by APP-01 (Coremail) with SMTP id qwCowACXO9S6pD5q2JFtAw--.4844S2;
	Sat, 27 Jun 2026 00:11:39 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] fix: scsi: cxgbi: cxgbi_ep_connect: remove extra cxgbi_sock_get leading   to reference leak
Date: Sat, 27 Jun 2026 00:11:38 +0800
Message-Id: <20260626161138.54852-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACXO9S6pD5q2JFtAw--.4844S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJrW5trW5Kw1DJFyUKr17KFg_yoW8JFyxpw
	4vkrWfKr18Jr4Fkr4kJr4rCF1a9a1a9FWDG3yxC34Sv398WFy5GFy8Kry2vFykCr1ktrW7
	Xa1DAa40va15CwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUDpnQUUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgkKA2o+h0FO3AAAsG

In cxgbi_ep_connect(), an explicit cxgbi_sock_get(csk) is called before
sock_get_port(csk), which internally calls cxgbi_sock_get(csk) again.
After sock_get_port, all error paths release only one reference via
release_conn, while the success path returns without releasing any. This
results in one leaked reference on every code path.

Remove the redundant cxgbi_sock_get(csk) call, letting sock_get_port's
internal get serve as the sole reference acquisition.

Cc: stable@vger.kernel.org
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/cxgbi/libcxgbi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 6a109269c68c..d2e8c8b8a138 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2891,10 +2891,12 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 
 	if (IS_ERR(csk))
 		return (struct iscsi_endpoint *)csk;
+
 	if (!hba)
 		hba = csk->cdev->hbas[csk->port_id];
 	else if (hba != csk->cdev->hbas[csk->port_id]) {
 		if (ifindex != hba->ndev->ifindex) {
+			cxgbi_sock_put(csk);
 			cxgbi_sock_closed(csk);
 			ifindex = hba->ndev->ifindex;
 			goto check_route;
-- 
2.39.5 (Apple Git-154)

