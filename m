From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 03/03] scsi: remove spurious if tests from scsi_eh_{times_out|done}
Date: Sat, 14 May 2005 09:46:18 +0900 (KST)
Message-ID: <20050514004601.E140FAC9@htj.dyndns.org>
References: <20050514004601.783910E3@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.196]:15432 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262657AbVENAqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 20:46:22 -0400
Received: by rproxy.gmail.com with SMTP id a41so476299rng
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2005 17:46:21 -0700 (PDT)
In-Reply-To: <20050514004601.783910E3@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

03_scsi_timer_eh_timer_remove_spurious_if.patch

	'if' tests which check if eh_action isn't NULL in both
	functions are always true.  Remove the redundant if's as it
	can give wrong impressions.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-05-14 09:45:59.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-05-14 09:45:59.000000000 +0900
@@ -434,8 +434,7 @@ static void scsi_eh_times_out(struct scs
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
 					  scmd));
 
-	if (scmd->device->host->eh_action)
-		up(scmd->device->host->eh_action);
+	up(scmd->device->host->eh_action);
 }
 
 /**
@@ -457,8 +456,7 @@ static void scsi_eh_done(struct scsi_cmn
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
 					   __FUNCTION__, scmd, scmd->result));
 
-		if (scmd->device->host->eh_action)
-			up(scmd->device->host->eh_action);
+		up(scmd->device->host->eh_action);
 	}
 }
 

