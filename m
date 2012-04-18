From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - 'rmmod --wait' race?
Date: Wed, 18 Apr 2012 18:18:43 +0000
Message-ID: <4F8F0583.5000104@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F86CF34.2000906@redhat.com> <4F8EF05F.8080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:53228 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2DRSSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 14:18:49 -0400
In-Reply-To: <4F8EF05F.8080307@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, stefanr@s5r6.in-berlin.de

On 04/18/12 16:48, Tomas Henzl wrote:

> And long term goal were not to use try_module_get in scsi_device_get ?


With a properly implemented eh_abort_handler the patch below should
avoid that error handler functions get invoked after scsi_remove_host()
finished. This patch needs further testing though - a similar patch has
been reverted in the beginning of 2011 (see also commit
09c9d4c9b6a2b5909ae3c6265e4cd3820b636863). So I'm not entirely sure
whether the patch below is the right approach.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4aa41d1..c9f6000 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1691,6 +1691,7 @@ struct request_queue *scsi_alloc_queue(struct
scsi_device *sdev)
 void scsi_free_queue(struct request_queue *q)
 {
 	blk_cleanup_queue(q);
+	blk_abort_queue(q);
 }

 /*
-- 
1.7.7

