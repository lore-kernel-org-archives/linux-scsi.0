Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [4.193.249.245])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3548A21CC44;
	Tue, 28 Oct 2025 10:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.193.249.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761645732; cv=none; b=YtjJd8ljIkgiMqHRjsAiCLNxoyPO9VNfzJwXplIWP4yAc6oH3tf7vrLPFbIev8DLVKWWMJ6C02uoQh1W8osOEtk8yMtHZuDlLaGFvM/i8c87GgcvxEbCTiXrANZzC+moULb6LuOs6f737WRAvao2vVBggVEJZanH34mSXcyZKP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761645732; c=relaxed/simple;
	bh=LsYTuV7LLN5FAg+rUEomU5ZVfWHzIhuwGB/sNrd2ySE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fLy+mMmo0WxuAUEFj2gmx33lQJ7kAHTSt4mdijzMdQoWPSWNGB9xYsKSpaYXV5xFmNFsQpDAk0Cq6Dj07J23cBLYxJMNROgf+pXVwdEp7rVCZyTQ2Xg6YtPmieVqpCFa4/+eHJwrZzJRvi01yu/Zz3e6nBIS//mLvLKnYo0etBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=4.193.249.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [218.12.19.0])
	by mtasvr (Coremail) with SMTP id _____wDnk2mTlABpgDcnAw--.432S3;
	Tue, 28 Oct 2025 18:01:56 +0800 (CST)
Received: from ubuntu.localdomain (unknown [218.12.19.0])
	by mail-app2 (Coremail) with SMTP id zC_KCgB3RDaOlABpdXFUAw--.49170S2;
	Tue, 28 Oct 2025 18:01:54 +0800 (CST)
From: Duoming Zhou <duoming@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] scsi: imm: fix use-after-free bugs caused by unfinished delayed work
Date: Tue, 28 Oct 2025 18:01:49 +0800
Message-Id: <20251028100149.40721-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgB3RDaOlABpdXFUAw--.49170S2
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwUNAWj-yv4F7QA+s-
X-CM-DELIVERINFO: =?B?aaysbgXKKxbFmtjJiESix3B1w3uoVhYI+vyen2ZzBEkOnu5chDpkB+ZdGnv/zQ0PbP
	CR1yNwzV7anoiB6+B/SY26SzCtXLsURgkJIJQorRbNy8C5r+8AVgZrgI/5IUEDxN9XmH+v
	Ws5s1vt5/vKW3V7J0whNC/8f+UfxYoAS7oQgkoOLlUUxR07JOb8BTt7NEwh8aQ==
X-Coremail-Antispam: 1Uk129KBj93XoW7WF4kCFW3KFy8AFy8Cr4ftFc_yoW8XFyUpr
	Z3Ga45t3y7uay8uw47Xr48WFySgrs8Gry7K3yxW3yfCr98JF1jqF13ta15Wa4rCrW8A39x
	ZF4jqwn5ZayqyrcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
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

The delayed work item imm_tq is initialized in imm_attach() and
scheduled via imm_queuecommand() for processing SCSI commands.
When the IMM parallel port SCSI host adapter is detached through
imm_detach(), the imm_struct device instance is deallocated.

However, the delayed work might still be pending or executing
when imm_detach() is called, leading to use-after-free bugs
when the work function imm_interrupt() accesses the already
freed imm_struct memory.

The race condition can occur as follows:

CPU 0(detach thread)   | CPU 1
                       | imm_queuecommand()
                       |   imm_queuecommand_lck()
imm_detach()           |     schedule_delayed_work()
  kfree(dev) //FREE    | imm_interrupt()
                       |   dev = container_of(...) //USE
                           dev-> //USE

Add disable_delayed_work_sync() in imm_detach() to guarantee
proper cancellation of the delayed work item before imm_struct
is deallocated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/scsi/imm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 5c602c057798..45b0e33293a5 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1260,6 +1260,7 @@ static void imm_detach(struct parport *pb)
 	imm_struct *dev;
 	list_for_each_entry(dev, &imm_hosts, list) {
 		if (dev->dev->port == pb) {
+			disable_delayed_work_sync(&dev->imm_tq);
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
 			scsi_host_put(dev->host);
-- 
2.34.1

