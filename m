Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8A5224B04;
	Wed,  1 Jul 2026 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.175.55.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782916154; cv=none; b=cLM8XpQdi88/Jmw4gKmDxGzw+ein7Ik+kZL0VcOyQ7ORYpHSL7zOuB+OlZqLgosizXZfshauu3Zb7mXX6lSRifYhGzbSbWMEb7n9AjRgobdXuOSS/7zh05CLe2hCsDsD8pmOzgp8E+wOdi/Xps/xdpoDH3ZpzgbWnNPIZzID1zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782916154; c=relaxed/simple;
	bh=5KGXLuJSX0BjAWR3juBdii5Oe66hGwwQCohFUY34DJg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dwtQPS1Muz3d4BZj2sCrsu+ArQXTfg4CWo9mdpsEjamJV+pvWKo1ySS3ul4zI7y6ORHN0yF6V25aiiqu5nLjXzHsnb0EmutpD0x30dZKV8pBXGBafScJEyQSGhH5RPMPsc/DimqeRGKH8NoicZfyGFBKTyHtAPyVZU548GxDTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=52.175.55.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wDXl0YkJEVq0UlNAw--.19045S3;
	Wed, 01 Jul 2026 22:28:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app4 (Coremail) with SMTP id zi_KCgCn2jEkJEVqzTz8AQ--.5574S2;
	Wed, 01 Jul 2026 22:28:52 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: don.brace@microchip.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] scsi: smartpqi: cancel pending workers before freeing controller
Date: Wed,  1 Jul 2026 14:27:57 +0000
Message-Id: <20260701142757.8447-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgCn2jEkJEVqzTz8AQ--.5574S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?Wu+DqAXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnXz+g1OQfMo27QHy5TwQyZwEeP9aV36GJRgY7CgHqzw/4H/s5SQPYwcAkAkIL+W54GHX
	FQYp8/i1GZ6kQ0dgi24=
X-Coremail-Antispam: 1Uk129KBj93XoWxGr4ruF18uFWkWF1UuFyfuFX_yoWrtFW5pF
	WfX3srJr4ktFWY934qv3W8AFy3ur4DJw1DC397K3sxCa13Jry0qFyUGF4qvFW5Jrs5Ar12
	yrnYva45Wr98tFcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
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

The smartpqi driver schedules four struct work_struct members of
struct pqi_ctrl_info on the system workqueue: ctrl_offline_work,
event_work, ofa_memory_alloc_work and ofa_quiesce_work.
ctrl_offline_work is armed by pqi_take_ctrl_offline(), reached from the
heartbeat timer handler and the error paths; event_work is queued by the
event-interrupt handler, and the event worker can in turn queue the two
OFA workers while processing OFA events.

None of these workers is cancelled during controller teardown.
pqi_remove_ctrl() stops the heartbeat timer and cancels the rescan and
update_time delayed workers, then calls pqi_free_ctrl_resources(), which
frees the interrupts and finally the controller in pqi_free_ctrl_info()
(kfree).  A worker queued by the timer or the event handler can therefore
run after the controller has been freed:

    CPU0 (teardown)                 CPU1 (system_wq)
    heartbeat timer / event IRQ
    pqi_take_ctrl_offline()
      schedule_work(ctrl_offline_work)
    pqi_remove_ctrl()
      ...
      pqi_free_ctrl_resources()
        free_irq()
        kfree(ctrl_info)            pqi_ctrl_offline_worker()
                                      container_of(work) -> freed ctrl_info
                                      pqi_take_ctrl_offline_deferred()
                                        dereferences ctrl_info  UAF

Clearing controller_online does not stop an already-queued
ctrl_offline_work: pqi_ctrl_offline_worker() and its callee
pqi_take_ctrl_offline_deferred() never check it and dereference the
controller unconditionally.  pqi_event_worker() and the two OFA workers
recover the controller with container_of() and dereference it the same way.

Drain the workers in pqi_free_ctrl_resources(), in an order that drains
each layer of the arming chain.

ctrl_offline_work is disabled with disable_work_sync() rather than
cancelled.  Its armer, pqi_take_ctrl_offline(), checks controller_online
and then, still in the same call, clears it and calls schedule_work(); an
interrupt or error handler that has already passed that check will queue
ctrl_offline_work even after pqi_remove_ctrl() has cleared
controller_online, so a plain cancel_work_sync() can return before that
in-flight armer queues the work.  The worker's callback,
pqi_take_ctrl_offline_deferred(), also calls pqi_free_interrupts(), so an
instance running during teardown would race the
num_msix_vectors_initialized counter in pqi_free_irqs() and call
free_irq() twice for the same vectors.  disable_work_sync() drains any
queued or running instance and makes later schedule_work() calls on it
no-ops, so the worker can neither run during the teardown's own
pqi_free_interrupts() nor survive until the controller is freed.

The remaining three workers are cancelled after pqi_free_interrupts().
Freeing the IRQs first stops the handler from arming event_work, draining
event_work next stops the event worker from arming the OFA workers, and
the OFA workers are drained last: each cancel is a final drain with no
re-arm race.

cancel_work_sync() is the correct primitive for the remaining work_struct
items: it cancels a pending instance and waits for a running callback to
return.  pqi_free_ctrl_resources() is reached only through the
pqi_remove_ctrl() chokepoint shared by pqi_pci_remove() and the probe
error path, and the four work_structs are initialised in
pqi_alloc_ctrl_info(), so draining here always operates on initialised
work.

Fixes: 5f310425c8ea ("scsi: smartpqi: update rescan worker")
Cc: stable@vger.kernel.org # needs adjustments for <= 6.6: use cancel_work_sync()
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8891,7 +8891,16 @@ static void pqi_free_interrupts(struct pqi_ctrl_info *ctrl_info)

 static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
 {
+	/*
+	 * Disable, not cancel: the callback also frees IRQs, and
+	 * pqi_take_ctrl_offline() can re-queue it after a cancel.
+	 */
+	disable_work_sync(&ctrl_info->ctrl_offline_work);
 	pqi_free_interrupts(ctrl_info);
+	/* IRQs queue event_work, which can queue OFA work. */
+	cancel_work_sync(&ctrl_info->event_work);
+	cancel_work_sync(&ctrl_info->ofa_memory_alloc_work);
+	cancel_work_sync(&ctrl_info->ofa_quiesce_work);
 	if (ctrl_info->queue_memory_base)
 		dma_free_coherent(&ctrl_info->pci_dev->dev,
 			ctrl_info->queue_memory_length,

