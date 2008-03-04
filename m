From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi_debug: publish support for sg-chaining
Date: Tue, 04 Mar 2008 20:21:48 +0200
Message-ID: <47CD933C.4050209@panasas.com>
References: <1204450218-6858-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37459 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbYCDSWJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 13:22:09 -0500
In-Reply-To: <1204450218-6858-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Sun, Mar 02 2008 at 11:30 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> Here's minor cleanup of scsi_debug driver. This is against scsi-misc.
> 
> 
> --
If at it, might add this one also. I was sure it was done before, but apparently
it disappeared.

---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 4 Mar 2008 20:09:20 +0200
Subject: [PATCH] scsi_debug: publish support for sg-chaining

scsi_debug already supports sg-chaining. Let scsi-ml
know that, to let it send any sg-list size

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3abd286..fd9fef5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3076,7 +3076,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.bios_param =		scsi_debug_biosparam,
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
-	.sg_tablesize =		256,
+	.sg_tablesize =		~0,
 	.cmd_per_lun =		16,
 	.max_sectors =		0xffff,
 	.use_clustering = 	DISABLE_CLUSTERING,
-- 
1.5.3.3



