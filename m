From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 02/13] scsi: don't turn on REQ_SPECIAL on sgtable allocation failure.
Date: Thu, 31 Mar 2005 18:08:00 +0900 (KST)
Message-ID: <20050331090647.C0E52845@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.198]:37200 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261224AbVCaJIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:08:05 -0500
Received: by rproxy.gmail.com with SMTP id j1so322965rnf
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 01:08:04 -0800 (PST)
In-Reply-To: <20050331090647.FEDC3964@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

02_scsi_no_REQ_SPECIAL_on_sgtable_allocation_failure.patch

	Don't turn on REQ_SPECIAL on sgtable allocation failure.  This
	was the last place where REQ_SPECIAL is turned on for normal
	requests.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

Index: scsi-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_lib.c	2005-03-31 18:06:19.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_lib.c	2005-03-31 18:06:20.000000000 +0900
@@ -940,10 +940,8 @@ static int scsi_init_io(struct scsi_cmnd
 	 * if sg table allocation fails, requeue request later.
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt)) {
-		req->flags |= REQ_SPECIAL;
+	if (unlikely(!sgpnt))
 		return BLKPREP_DEFER;
-	}
 
 	cmd->request_buffer = (char *) sgpnt;
 	cmd->request_bufflen = req->nr_sectors << 9;

