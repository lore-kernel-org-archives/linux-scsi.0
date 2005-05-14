From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 02/03] scsi: remove unnecessary scsi_delete_timer() call in scsi_reset_provider()
Date: Sat, 14 May 2005 09:46:13 +0900 (KST)
Message-ID: <20050514004601.4404815C@htj.dyndns.org>
References: <20050514004601.783910E3@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.206]:18618 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262653AbVENAqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 20:46:17 -0400
Received: by wproxy.gmail.com with SMTP id 68so1391453wra
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2005 17:46:17 -0700 (PDT)
In-Reply-To: <20050514004601.783910E3@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

02_scsi_timer_remove_delete_timer_from_reset_provider.patch

	scsi_reset_provider() calls scsi_delete_timer() on exit which
	isn't necessary.  Remove it.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |    1 -
 1 files changed, 1 deletion(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-05-14 09:43:18.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-05-14 09:45:59.000000000 +0900
@@ -1870,7 +1870,6 @@ scsi_reset_provider(struct scsi_device *
 		rtn = FAILED;
 	}
 
-	scsi_delete_timer(scmd);
 	scsi_next_command(scmd);
 	return rtn;
 }

