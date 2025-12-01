Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.205.26])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED2C199FB2;
	Mon,  1 Dec 2025 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.205.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764586052; cv=none; b=FDqMLM9n2fYO8lXMSlDjKf9waCQ5sJZ+yCqCgYgp1Luc4hBMcEPMZ7Uvd6BHqmGUELGIcKJA8SffVyAMKZkUBpz9AMx+DF2L7EyL1ROQ1e38yZnpJzpNaxcp/nvsn5NewjimumUDwFkq723UpV83fRCKr0RedafVNOJw0oIZ9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764586052; c=relaxed/simple;
	bh=zGUezxXGkLWBno8l9xQpOTdMBmDt5cjCB+yM8vPKqdM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j0xvlF9//48qaX9CFGQKTOtBmSPgKkslHDMKB+LnU497JQ12h1qgPbt+t13mKGlsxyadf+9g4ffGHtNl+Fq7an07TFphpVgQoc2YNwhqHJoXFeuS42HhZtL7f2OWODtyQwjPQBbi4cVSFeiKge28ipiofUud18L8wTFHzM4GuqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.229.205.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [218.12.21.37])
	by mtasvr (Coremail) with SMTP id _____wAH_FAoci1pPQtnAA--.162S3;
	Mon, 01 Dec 2025 18:47:05 +0800 (CST)
Received: from ubuntu.localdomain (unknown [218.12.21.37])
	by mail-app4 (Coremail) with SMTP id zi_KCgCXT4Yjci1ptzKfAw--.13527S2;
	Mon, 01 Dec 2025 18:47:03 +0800 (CST)
From: Duoming Zhou <duoming@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	Duoming Zhou <duoming@zju.edu.cn>,
	stable@kernel.org
Subject: [PATCH] scsi: ppa: Fix use-after-free caused by unfinished delayed work
Date: Mon,  1 Dec 2025 18:46:55 +0800
Message-Id: <20251201104655.13286-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgCXT4Yjci1ptzKfAw--.13527S2
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwUHAWksngEI+AAfs1
X-CM-DELIVERINFO: =?B?m62WfAXKKxbFmtjJiESix3B1w3uoVhYI+vyen2ZzBEkOnu5chDpkB+ZdGnv/zQ0PbP
	CR1+OXM+ceWozZiJasFKyEGDC/hCTzRCaGYihPJJN3a1yGF9DrDiUB36IEyU/9iI3kAT9I
	25iynK2FkUCgyVJ7LTLqOxtF0fvaBTwPUFtnKQy2ZCKUz6T9Wo2HR2QbHyhYKQ==
X-Coremail-Antispam: 1Uk129KBj93XoW7Ar4fWr18Wry8tw47Jw13GFX_yoW8WrW7pr
	Z3Ca45ta9rWF409w47Xw48WFyfWrsxCrW5K3y0g3yfurn8JFy0vr1fta45ua48Jr40yw17
	Ar4qqw18ZayqkFcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
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

