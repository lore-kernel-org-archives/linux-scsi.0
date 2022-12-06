Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C138AC352A1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Dec 2022 13:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiLFNOz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 08:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiLFNOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 08:14:38 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9307B2C661
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 05:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670332438; x=1701868438;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E+zH3taK7NgyDK8TXFfZUMrZiqituFM79TKPCsHMraQ=;
  b=Ot38ApnwfBQSfwwjB43LvdFjhPMzEVK5UID03r4+pSQ4C3IQVUIoJqLh
   rh+mVUnuYKj8NolyZxAQjT+rFoTwmuALtSEdtosHEXZs3stPfbZ1ArnI7
   Q/xWOQiN2XzEBnuYREmgteCYvTEM3nZjnCyFE0LKxqqGYC6mo3ivI4XpZ
   ZNctak7fq+0ZIaSEQZH1RD6/l/dLAhYzpIIHcng/CsTWAdMwgfXvE8ECt
   NE6CxZMJcchaRApwzdo1NzVBnvzN1JdRXjZRqSaPgctzGA5aMAYNDYndx
   PuN/HXmDzwUuwT/vbstl3K1KZw+FGx7XSx48OxFoJ47d4zz6nDth+FP1x
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,222,1665417600"; 
   d="scan'208";a="322368418"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Dec 2022 21:13:56 +0800
IronPort-SDR: plTmR9DuOSTsrrSjsXHsFOWdBBjSdk+H29DJpkxOkCbjaCcKOUKZwGfGD/QhB1Q7VtkIjE6xkD
 88uRrm4josJErYYC3c0fdT3Tl42IZvfxLbTjIyXnTLmRqqnoPPjHe0JR+WmnIE+rYJkpvj5NxE
 Uw/A7cWQQH1nzCMkslfReyYlqZciDintRJcOrKu5KW1R+/gWAVCXRi9dPnptE2s3cqabVfyYQp
 Sk38gt/rinMdO4ahtMFAu3JZ5nIN/GxAnTI7BTLacY/p7T6faj20Nt3zg+W97my4zrGmqmgndS
 1fI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Dec 2022 04:32:28 -0800
IronPort-SDR: ysuBKngdOt919FjiNktpKEgenpsLBMWkqQkwdQtZAarFbHaS0UNc+uID4NVlzCcIK9hGUKFR/1
 ZFbOYWB+HeHglSxkalyKZUMJzfSAMJV6tXNRbZ6JMYGY9HydnLosNQA3NIYv197MKzIr6Fjq/v
 cw0TlePxMZZATBlM2NwalFS+xEzxuKC4vSIu4B0wZarkNQacHYnfrahG0fFIR3gMUfz3Ck78HE
 VqouLc66m4VkfXTyHrQLE8n6RiD1gWUO3YYFLGLlD5S6De34uZJtYrOllhUmiIxglhOCZyOdFG
 hPg=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Dec 2022 05:13:54 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi_error: do not queue pointless abort workqueue functions
Date:   Tue,  6 Dec 2022 14:13:45 +0100
Message-Id: <20221206131346.2045375-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

If a host template doesn't implement the .eh_abort_handler()
there is no point in queueing the abort workqueue function;
all it does is invoking SCSI EH anyway.
So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
is not implemented and save us from having to wait for the
abort workqueue function to complete.

Cc: Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[niklas: moved the check to the top of scsi_abort_command()]
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Changes since v1:
-moved the check to the top of scsi_abort_command(), as there is no need to
 perform the SCSI_EH_ABORT_SCHEDULED check if there is no eh_abort_handler.

I know that John gave a review comment on V1 that it is possible to not
allocate the shost->tmf_work_q in case there is no eh_abort_handler,
however, that is more of a micro optimization. This patch significantly
reduces the latency before SCSI EH is invoked for libata.

It would be nice if we could get this patched merged for 6.2, for which
the merge window opens soon.

 drivers/scsi/scsi_error.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a7960ad2d386..2aa2c2aee6e7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -231,6 +231,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
+	if (!shost->hostt->eh_abort_handler) {
+		/* No abort handler, fail command directly */
+		return FAILED;
+	}
+
 	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
 		/*
 		 * Retry after abort failed, escalate to next level.
-- 
2.38.1

