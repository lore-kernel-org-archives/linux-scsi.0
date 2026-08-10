Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A833AE6E5;
	Mon, 10 Aug 2026 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.237.72.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786365354; cv=none; b=E9cJXA9BVuYDDLEFJiFCM4o71g+lPH0OVMUOCMwQwu7feTN1llEsNUvArUFeSyAfGj/H870b9pYU563YycvIPVFCRI8kzctsBf1IEjnljfPPcCyrkuz701yB+B7ZnNVQk3cDErvpxOS61TQvTtISdgDFudC1TehPASHFFHiMQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786365354; c=relaxed/simple;
	bh=4EGy8XxImze5kg5V93EPfWIg5qCGq+tSC5lMLbZ+JDs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l2rLd2QSxcL/BCd94Q7id4UTgOEa9JuWjnXOKviUdWzh0WQ9f+8/T15Rz6nOC68Hw19SykIXwerSLD36bpLziHu/BXv1j8O4V1ZzxGgmpoVxWHA319JA4rSBf3zU+/b3n8Xyr6j39KJAc87Bbh0ufZjDZarumQv79na34uADcCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.237.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wB3hjSbxXlqbwCAAA--.36399S3;
	Mon, 10 Aug 2026 20:35:40 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgD3D3KbxXlqDWIwBA--.28189S2;
	Mon, 10 Aug 2026 20:35:39 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: Ram Vegesna <ram.vegesna@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Don Brace <don.brace@microchip.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] scsi: elx: efct: Use timer_shutdown_sync() for the stats timer
Date: Mon, 10 Aug 2026 12:34:43 +0000
Message-Id: <20260810123443.122397-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgD3D3KbxXlqDWIwBA--.28189S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?cvA2bQXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WO4v8p1q5Ynd8nc+Mqb2Chrg9WE6Tau6FeIlHX0sa0QwWe7
	wOvWht09dxf3+9JmBgWp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW7uF4kKF1fCw17tF43JF4fWFX_yoW8Kw18pF
	4kW39ruryUWF4jkr17Jr4UZFy5ZanaqFWDGF48W3y3uayfXryrCF15tFWDCFW3JrWvq3sI
	gw1DJrn3XFs5AFXCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU85l1PUUUUU==

The statistics timer re-arms itself on every expiry through
efct_xport_config_stats_timer().  timer_delete() only detaches a pending
timer: it does not wait for a callback that is already running and does
not stop that callback from re-arming the timer.  In efct_xport_detach()
the timer is stopped before efct_xport_free() frees the xport,
so a callback that re-armed it can fire after the free and dereference the
freed object.  efct_fw_reset() stops the same timer before a hardware
reset, where a callback left running can race the reset and re-arm the
timer.

timer_shutdown_sync() waits for a running callback to finish and
guarantees that the timer cannot be rearmed once it returns, so use it at
both points.  The now-pointless timer_pending() checks are dropped.

This issue was found by an in-house static analysis tool.

Fixes: ab332fcbcd81 ("scsi: elx: efct: Transport and hardware teardown routines")
Cc: stable@vger.kernel.org # v6.2+
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/elx/efct/efct_driver.c | 3 +--
 drivers/scsi/elx/efct/efct_xport.c  | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 07c2f4534..3556c6d8a 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -309,8 +309,7 @@ efct_fw_reset(struct efct *efct)
 	 * Function 0 will update and load the new firmware
 	 * during attach.
 	 */
-	if (timer_pending(&efct->xport->stats_timer))
-		timer_delete(&efct->xport->stats_timer);
+	timer_shutdown_sync(&efct->xport->stats_timer);
 
 	if (efct_hw_reset(&efct->hw, EFCT_HW_RESET_FIRMWARE)) {
 		efc_log_info(efct, "failed to reset firmware\n");
diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 9dcaef6fc..84fa5589e 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -507,8 +507,7 @@ efct_xport_detach(struct efct_xport *xport)
 	efct_scsi_del_device(efct);
 
 	/*Shutdown FC Statistics timer*/
-	if (timer_pending(&xport->stats_timer))
-		timer_delete(&xport->stats_timer);
+	timer_shutdown_sync(&xport->stats_timer);
 
 	efct_hw_teardown(&efct->hw);
 
-- 
2.34.1

