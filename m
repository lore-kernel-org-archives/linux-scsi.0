From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()
 -- should I be concerned?
Date: Wed, 14 Mar 2012 18:59:58 +0000
Message-ID: <4F60EAAE.3070803@acm.org>
References: <4F5379F5.6010604@msgid.tls.msk.ru> <4F545EB5.1070700@msgid.tls.msk.ru> <4F54FE51.1010401@acm.org> <4F5F6E34.6070208@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:58970 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab2CNTAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 15:00:08 -0400
In-Reply-To: <4F5F6E34.6070208@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 03/13/12 15:56, Michael Tokarev wrote:
> WARNING: at block/genhd.c:1474 __disk_unblock_events+0x123/0x130()

Does the patch below help ? This patch prevents that sd_probe_async()
races with scsi_host_remove().

---
 drivers/scsi/sd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..7161fc1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2544,6 +2544,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 	scsi_autopm_put_device(sdp);
+	scsi_host_put(sdp->host);
 	put_device(&sdkp->dev);
 }
 
@@ -2635,6 +2636,7 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
+	scsi_host_get(sdp->host);
 	async_schedule(sd_probe_async, sdkp);
 
 	return 0;
-- 
1.7.7

