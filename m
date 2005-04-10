From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 04/07] scsi: remove unnecessary scsi_delete_timer() call in scsi_reset_provider()
Date: Mon, 11 Apr 2005 03:45:26 +0900 (KST)
Message-ID: <20050410184214.8FFBC5B6@htj.dyndns.org>
References: <20050410184214.4AAD0992@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.193]:29480 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261570AbVDJSph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 14:45:37 -0400
Received: by wproxy.gmail.com with SMTP id 68so2417147wra
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2005 11:45:31 -0700 (PDT)
In-Reply-To: <20050410184214.4AAD0992@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

04_scsi_timer_remove_delete_timer_from_reset_provider.patch

	scsi_reset_provider() calls scsi_delete_timer() on exit which
	isn't necessary.  Remove it.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |    1 -
 1 files changed, 1 deletion(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-04-11 03:42:11.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-04-11 03:42:12.000000000 +0900
@@ -1843,7 +1843,6 @@ scsi_reset_provider(struct scsi_device *
 		rtn = FAILED;
 	}
 
-	scsi_delete_timer(scmd);
 	scsi_next_command(scmd);
 	return rtn;
 }

