From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] [SCSI] sd: call blk_pm_runtime_init before add_disk
Date: Thu, 10 Oct 2013 13:22:36 +0800
Message-ID: <5256399C.10105@intel.com>
References: <6c835b531761fe70209d015daa6b87e8.squirrel@www.codeaurora.org>    <4ed022cf2fedc9ee1049254ea274f705.squirrel@www.codeaurora.org>    <52551CD3.2060803@intel.com> <04811251e7b06dd74849872257d9bb7c.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46256 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3JJFWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Oct 2013 01:22:01 -0400
In-Reply-To: <04811251e7b06dd74849872257d9bb7c.squirrel@www.codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>

Sujit has found a race condition that would make q->nr_pending
unbalanced, it occurs as Sujit explained:

"
sd_probe_async() ->
	add_disk() ->
		disk_add_event() ->
			schedule(disk_events_workfn)
	sd_revalidate_disk()
	blk_pm_runtime_init()
return;

Let's say the disk_events_workfn() calls sd_check_events() which tries
to send test_unit_ready() and because of sd_revalidate_disk() trying to
send another commands the test_unit_ready() might be re-queued as the
tagged command queuing is disabled.

So the race condition is -

Thread 1 			  |		Thread 2
sd_revalidate_disk()		  |	sd_check_events()
...nr_pending = 0 as q->dev = NULL|	scsi_queue_insert()
blk_runtime_pm_init()		  | 	blk_pm_requeue_request() ->
				  |	nr_pending = -1 since
				  |	q->dev != NULL
"

The problem is, the test_unit_ready request doesn't get counted the
first time it is queued, so the later decrement of q->nr_pending in
blk_pm_requeue_request makes it unbalanced.

Fix this by calling blk_pm_runtime_init before add_disk so that all
requests initiated there will all be counted.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reported-and-tested-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: stable@vger.kernel.org
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e62d17d..5693f6d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2854,6 +2854,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
 	}
 
+	blk_pm_runtime_init(sdp->request_queue, dev);
 	add_disk(gd);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
@@ -2862,7 +2863,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-	blk_pm_runtime_init(sdp->request_queue, dev);
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }
-- 
1.8.4.12.g2ea3df6
