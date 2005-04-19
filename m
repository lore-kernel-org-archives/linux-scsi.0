From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 02/04] scsi: remove spurious if tests from scsi_eh_{times_out|done}
Date: Tue, 19 Apr 2005 23:31:11 +0900 (KST)
Message-ID: <20050419143100.3724D346@htj.dyndns.org>
References: <20050419143100.E231523D@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.206]:62405 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261561AbVDSObQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 10:31:16 -0400
Received: by rproxy.gmail.com with SMTP id j1so1216634rnf
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2005 07:31:15 -0700 (PDT)
In-Reply-To: <20050419143100.E231523D@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

02_scsi_timer_eh_timer_remove_spurious_if.patch

	If tests which check if eh_action isn't NULL in both functions
	are always true.  Remove the if's.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-04-19 23:30:57.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-04-19 23:30:58.000000000 +0900
@@ -436,8 +436,7 @@ static void scsi_eh_times_out(unsigned l
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
 					  scmd));
 
-	if (scmd->device->host->eh_action)
-		up(scmd->device->host->eh_action);
+	up(scmd->device->host->eh_action);
 }
 
 /**
@@ -461,8 +460,7 @@ static void scsi_eh_done(struct scsi_cmn
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
 					   __FUNCTION__, scmd, scmd->result));
 
-		if (scmd->device->host->eh_action)
-			up(scmd->device->host->eh_action);
+		up(scmd->device->host->eh_action);
 	}
 }
 

