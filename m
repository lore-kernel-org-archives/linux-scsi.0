From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/5] hpsa: fix bad -ENOMEM return value in
	hpsa_big_passthru_ioctl
Date: Thu, 03 Jul 2014 10:18:03 -0500
Message-ID: <20140703151803.22132.79451.stgit@beardog.cce.hp.com>
References: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:12464 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbaGCPSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:18:55 -0400
In-Reply-To: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com, hch@lst.de

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When copy_from_user fails, return -EFAULT, not -ENOMEM

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cd1a9b..08b34e9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5092,7 +5092,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 		if (ioc->Request.Type.Direction & XFER_WRITE) {
 			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status = -ENOMEM;
+				status = -EFAULT;
 				goto cleanup1;
 			}
 		} else

