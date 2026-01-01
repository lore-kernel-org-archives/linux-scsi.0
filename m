Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96EA14D8CE;
	Thu,  1 Jan 2026 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767275780; cv=none; b=HKZMknv9vfFkfxlTglp4l3RGcGXgKGW838qFexT8zHXLh6UJJizQd2YGUFqA5uAtXXP6ppJ95ahJxhV0mSuFqxdo7YVUlpXPtieMzgTtyNZK4niYsKFeL7ZkpRjn+AiLQji8KxPc2xnjpxu4upJXqlyM2+4dWWmqllhQDXmL1T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767275780; c=relaxed/simple;
	bh=3IeWKdFGvRvBDVUWoFd1bClKbtfPh7ObHZIU/PPoEN4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ixKgY7nOInHod4VdfadH9uYpjf37hm1PsVr9/UXavO/XGA0V5f8VxdaEnBRbpOLzfqWXUgzZazF4iuiNuWUUivRrgMCq9PSUDHhh0XokYoSFgYOTYogoCn/OygAvhhIV0j+SJHgM5wtbd0cKhqUCez71eLThC3JnHKppAuL4FrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [218.12.17.91])
	by mtasvr (Coremail) with SMTP id _____wAXAVfcfFZpE053AQ--.14481S3;
	Thu, 01 Jan 2026 21:55:41 +0800 (CST)
Received: from ubuntu.localdomain (unknown [218.12.17.91])
	by mail-app4 (Coremail) with SMTP id zi_KCgC3mH_XfFZpr4cvBA--.17893S2;
	Thu, 01 Jan 2026 21:55:38 +0800 (CST)
From: Duoming Zhou <duoming@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	Duoming Zhou <duoming@zju.edu.cn>,
	stable@kernel.org
Subject: [PATCH RESEND] scsi: ppa: Fix use-after-free caused by unfinished delayed work
Date: Thu,  1 Jan 2026 21:55:32 +0800
Message-Id: <20260101135532.19522-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgC3mH_XfFZpr4cvBA--.17893S2
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwYSAWlVfIQD2AALsC
X-CM-DELIVERINFO: =?B?OZ3omgXKKxbFmtjJiESix3B1w3uoVhYI+vyen2ZzBEkOnu5chDpkB+ZdGnv/zQ0PbP
	CR1/fR3emQHM+UepV+H/1W7GG7aJs85WUTvaFneW0Q/Fsf/YJfiq4IFoQGnVmllaSlOPYO
	fZ4oy+ENW7WHxkWNwhBiJVq0Fjwp/yxyGdC2CIAVHJbKeFAoMukdRjYJgPUOPg==
X-Coremail-Antispam: 1Uk129KBj93XoW7Ar4fWr18Wry8tw47Jw13GFX_yoW8ArWUpr
	Z5Ca45ta9rWF409w47Xw18uFyfWrsxCrW3K3y0g3yfurn8JFy0vr1ft345ua48Jr40yw47
	Ar4qq348ZayqkFcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y48IcxkI7V
	AKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I
	3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxV
	WUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8I
	cVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuY
	vjxU26pBDUUUU

The delayed work item 'ppa_tq' is initialized in __ppa_attach() and
scheduled via ppa_queuecommand() for processing SCSI commands. When
the parallel port SCSI host adapter is detached through ppa_detach(),
the ppa_struct device instance is deallocated.

However, the delayed work might still be pending or executing when
ppa_detach() is called, leading to use-after-free bugs when the
work function ppa_interrupt() accesses the already freed ppa_struct
memory.

The race condition can occur as follows:

CPU 0(detach thread)   | CPU 1(delayed work)
                       | ppa_queuecommand()
                       |   ppa_queuecommand_lck()
ppa_detach()           |     schedule_delayed_work()
  kfree(dev) //FREE    | ppa_interrupt()
                       |   dev = container_of(...) //USE
                           dev-> //USE

Add disable_delayed_work_sync() in ppa_detach() to guarantee proper
cancellation of the delayed work item before ppa_struct is deallocated.
This is similar to commit ab58153ec64f ("scsi: imm: Fix use-after-free
bug caused by unfinished delayed work").

This bug was identified through static analysis.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/scsi/ppa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index ea682f3044b..8da2a78ebac 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -1136,6 +1136,7 @@ static void ppa_detach(struct parport *pb)
 	ppa_struct *dev;
 	list_for_each_entry(dev, &ppa_hosts, list) {
 		if (dev->dev->port == pb) {
+			disable_delayed_work_sync(&dev->ppa_tq);
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
 			scsi_host_put(dev->host);
-- 
2.34.1

