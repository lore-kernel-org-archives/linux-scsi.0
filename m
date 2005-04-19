From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 04/04] scsi: remove unnecessary scsi_delete_timer() call in scsi_reset_provider()
Date: Tue, 19 Apr 2005 23:31:21 +0900 (KST)
Message-ID: <20050419143100.284C6D23@htj.dyndns.org>
References: <20050419143100.E231523D@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261572AbVDSOdQ@vger.kernel.org>
In-Reply-To: <20050419143100.E231523D@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

04_scsi_timer_remove_delete_timer_from_reset_provider.patch

	scsi_reset_provider() calls scsi_delete_timer() on exit which
	isn't necessary.  Remove it.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_error.c |    1 -
 1 files changed, 1 deletion(-)

Index: scsi-reqfn-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-reqfn-export.orig/drivers/scsi/scsi_error.c	2005-04-19 23:30:58.000000000 +0900
+++ scsi-reqfn-export/drivers/scsi/scsi_error.c	2005-04-19 23:30:58.000000000 +0900
@@ -1882,7 +1882,6 @@ scsi_reset_provider(struct scsi_device *
 		rtn = FAILED;
 	}
 
-	scsi_delete_timer(scmd);
 	scsi_next_command(scmd);
 	return rtn;
 }
