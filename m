From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] scsi: improve description for deferred error
Date: Wed, 8 Dec 2010 16:14:26 -0500
Message-ID: <20101208211425.GA21249@redhat.com>
References: <4C739DE9.5070803@ct.jp.nec.com>
 <4C73FA8F.5080800@kernel.org>
 <4C74CD95.1000208@ct.jp.nec.com>
 <20100825152831.GA8509@redhat.com>
 <4C7789BE.1060609@ct.jp.nec.com>
 <20100827134940.GA22504@redhat.com>
 <4C7B4C23.8020100@ct.jp.nec.com>
 <20100901005537.GA21466@redhat.com>
 <4C7E0184.9030502@suse.de>
 <4C7E02F0.2020701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0LHVO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2010 16:14:29 -0500
Content-Disposition: inline
In-Reply-To: <4C7E02F0.2020701@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Properly describe a "deferred error" as such in scsi_io_completion.
The deferred error (and the associated sense) will have nothing to do
with the victim scsi command that is also printed.  The victim command
shall not have been processed and shall be retried.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/scsi_lib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..0aa0d68 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -889,7 +889,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
+		if (sense_deferred)
+			description = "Deferred error";
+		else
+			description = "Unhandled error code";
 		action = ACTION_FAIL;
 	}
 
