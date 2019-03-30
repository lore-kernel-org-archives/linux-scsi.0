From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 39/57] scsi: core: Avoid that system resume triggers a kernel warning
Date: Fri, 29 Mar 2019 21:28:32 -0400
Message-ID: <20190330012854.32212-39-sashal@kernel.org>
References: <20190330012854.32212-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190330012854.32212-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Przemek Socha <soprwa@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 388b4e6a00bb3097278ed1648ac5a1cb48c894e6 ]

scsi_device_quiesce() and scsi_device_resume() are called during
system-wide suspend and resume. scsi_device_quiesce() only succeeds for
SCSI devices that are in one of the RUNNING, OFFLINE or TRANSPORT_OFFLINE
states (see also scsi_set_device_state()).  This patch avoids that the
following warning is triggered when resuming a system for which quiescing a
SCSI device failed:

WARNING: CPU: 2 PID: 11303 at drivers/scsi/scsi_lib.c:2600 scsi_device_resume+0x4f/0x58
CPU: 2 PID: 11303 Comm: kworker/u8:70 Not tainted 5.0.0-rc1+ #50
Hardware name: LENOVO 80E3/Lancer 5B2, BIOS A2CN45WW(V2.13) 08/04/2016
Workqueue: events_unbound async_run_entry_fn
Call Trace:
 scsi_dev_type_resume+0x2e/0x60
 async_run_entry_fn+0x32/0xd8
 process_one_work+0x1f4/0x420
 worker_thread+0x28/0x3c0
 kthread+0x118/0x130
 ret_from_fork+0x22/0x40

Cc: Przemek Socha <soprwa@gmail.com>
Reported-by: Przemek Socha <soprwa@gmail.com>
Fixes: 3a0a529971ec ("block, scsi: Make SCSI quiesce and resume work reliably") # v4.15
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 18e4289baf99..655790f30434 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3095,7 +3095,6 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
-	WARN_ON_ONCE(!sdev->quiesced_by);
 	sdev->quiesced_by = NULL;
 	blk_clear_preempt_only(sdev->request_queue);
 	if (sdev->sdev_state == SDEV_QUIESCE)
-- 
2.19.1
