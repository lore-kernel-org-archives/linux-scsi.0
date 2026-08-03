Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99BD330D24;
	Mon,  3 Aug 2026 08:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785744295; cv=none; b=rWgLDVsZu0GZRL3r5r/LXbzhpe1JNgcp3bkHi9KpKLOJH0omnRViHesA4T4DxXEHTCCicIhy8XbFDa0F+cLyFH7PxrUdDDlrEpRIvcuHQg3/+lFVjJxv3I9kZBYSwJNAWbYAILPFfD/w6zbV2u4/0KzGsCEhS1Dv/arOsg2jfY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785744295; c=relaxed/simple;
	bh=JOtKXZh8X20eSMS9RrUJ7ribFUWH68ckq8nsYl4FrdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AEUJxQhhwJA9fChi0ECDCXAdBZ3xrn1yo4WhBC0nwOdZNB6hqSsI9yqpMkDoRAoLIOExuNdi0vnlZWwKjreBoaNhGc+JT7hPOEddPW5jHWrwJdlpj6TFQd+O86TvSSSHQBZocv6Et3PkTTD0iGfUD5DKMF5gYdD6sKvYIOS4jU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wBH9D2ZS3BqGB5eAA--.2692S3;
	Mon, 03 Aug 2026 16:04:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app4 (Coremail) with SMTP id zi_KCgC36jGYS3BqBqbYAg--.3139S2;
	Mon, 03 Aug 2026 16:04:40 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: fischer@norbit.de,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] scsi: aha152x: fix use-after-free of the bottom-half work
Date: Mon,  3 Aug 2026 08:03:45 +0000
Message-Id: <20260803080345.467914-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgC36jGYS3BqBqbYAg--.3139S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?E2XOHAXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnXz+g1OQfMo27QHy5TwQyZy3Yle9Q/p35LEXj5/uDnknE2X+H5LoCAJcmH6LOrbvSjUM
	ZolN+k0mktfrWwmfDPM=
X-Coremail-Antispam: 1Uk129KBj93XoWxWw43JryxCw17Xry3Zr1kZwc_yoW5tF1rpF
	ZIg342kF48tF4093y3JF45ur1SkF1kG34DG3s5CwsIyr1rt3WUtFnrCFWUZay5GrWkua13
	CFW3tr17ur48AFcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8rHUDUUUUU==

The interrupt handler schedules a module-global work_struct that neither
aha152x_release() nor the scsi_add_host() failure path cancels before
freeing the host, so a worker armed by a just-returned interrupt can run
after the host is freed.  Because the worker is shared across hosts,
draining it on one host's release cannot stop another host's interrupt
handler from re-arming it.

Make the work_struct per-host, initialize it once at probe, and cancel it
from both free paths.  Each host's interrupt handler then arms only its own
work, so cancel_work_sync() is sufficient to drain it before the host is
freed.

This issue was found by an in-house static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/aha152x.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e3ccb6b..1616ea7 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -509,6 +509,9 @@ struct aha152x_hostdata {
 	struct pnp_dev *pnpdev;
 #endif
 	struct list_head host_list;
+
+	struct work_struct work;
+		/* per-host bottom-half worker */
 };
 
 
@@ -635,6 +638,7 @@ static struct {
 
 /* setup & interrupt */
 static irqreturn_t intr(int irq, void *dev_id);
+static void run(struct work_struct *work);
 static void reset_ports(struct Scsi_Host *shpnt);
 static void aha152x_error(struct Scsi_Host *shpnt, char *msg);
 static void done(struct Scsi_Host *shpnt, unsigned char status_byte,
@@ -759,6 +763,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	}
 
 	spin_lock_init(&QLOCK);
+	INIT_WORK(&HOSTDATA(shpnt)->work, run);
 	RECONNECT   = setup->reconnect;
 	SYNCHRONOUS = setup->synchronous;
 	PARITY      = setup->parity;
@@ -856,6 +861,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	return shpnt;
 
 out_host_put:
+	cancel_work_sync(&HOSTDATA(shpnt)->work);
 	list_del(&HOSTDATA(shpnt)->host_list);
 	scsi_host_put(shpnt);
 
@@ -870,6 +876,7 @@ void aha152x_release(struct Scsi_Host *shpnt)
 	scsi_remove_host(shpnt);
 	if (shpnt->irq)
 		free_irq(shpnt->irq, shpnt);
+	cancel_work_sync(&HOSTDATA(shpnt)->work);
 
 #if !defined(AHA152X_PCMCIA)
 	if (shpnt->io_port)
@@ -1314,21 +1321,16 @@ static void done(struct Scsi_Host *shpnt, unsigned char status_byte,
 		printk(KERN_ERR "aha152x: done() called outside of command\n");
 }
 
-static struct work_struct aha152x_tq;
-
 /*
  * Run service completions on the card with interrupts enabled.
  *
  */
 static void run(struct work_struct *work)
 {
-	struct aha152x_hostdata *hd;
+	struct aha152x_hostdata *hd = container_of(work, struct aha152x_hostdata, work);
+	struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
-	list_for_each_entry(hd, &aha152x_host_list, host_list) {
-		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
-
-		is_complete(shost);
-	}
+	is_complete(shost);
 }
 
 /*
@@ -1371,8 +1373,7 @@ static irqreturn_t intr(int irqno, void *dev_id)
 		HOSTDATA(shpnt)->service=1;
 
 		/* Poke the BH handler */
-		INIT_WORK(&aha152x_tq, run);
-		schedule_work(&aha152x_tq);
+		schedule_work(&HOSTDATA(shpnt)->work);
 	}
 	DO_UNLOCK(flags);
 
-- 
2.34.1

