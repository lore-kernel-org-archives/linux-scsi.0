From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 01/04] scsi: replace REQ_SPECIAL with REQ_SOFTBARRIER in scsi_init_io()
Date: Mon, 11 Apr 2005 12:45:42 +0900 (KST)
Message-ID: <20050411034451.81FB61F1@htj.dyndns.org>
References: <20050411034451.B75F3870@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.199]:2117 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261685AbVDKDpr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 23:45:47 -0400
Received: by rproxy.gmail.com with SMTP id a41so1147342rng
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2005 20:45:47 -0700 (PDT)
In-Reply-To: <20050411034451.B75F3870@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

01_scsi_REQ_SPECIAL_semantic_scsi_init_io.patch

	scsi_init_io() used to set REQ_SPECIAL when it fails sg
	allocation before requeueing the request by returning
	BLKPREP_DEFER.  REQ_SPECIAL is being updated to mean special
	requests and we need to set REQ_SOFTBARRIER for half-prepp'ed
	requests.  So, replace REQ_SPECIAL with REQ_SOFTBARRIER.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_lib.c	2005-04-11 12:27:07.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_lib.c	2005-04-11 12:27:07.000000000 +0900
@@ -936,7 +936,7 @@ static int scsi_init_io(struct scsi_cmnd
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
 	if (unlikely(!sgpnt)) {
-		req->flags |= REQ_SPECIAL;
+		req->flags |= REQ_SOFTBARRIER;
 		return BLKPREP_DEFER;
 	}
 

