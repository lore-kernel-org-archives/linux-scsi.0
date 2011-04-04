From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] fusion: do not check serial_number in the abort handler
Date: Mon, 4 Apr 2011 09:42:41 -0400
Message-ID: <20110404134241.GD32522@infradead.org>
References: <20110404134203.GA29525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1DDNmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2011 09:42:42 -0400
Content-Disposition: inline
In-Reply-To: <20110404134203.GA29525@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

The SCSI midlayer stops all command processing when in error handling, which
means there is no chance for command reuse when the abort handler is called.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptscsih.c	2011-04-04 06:25:45.526096602 -0700
+++ linux-2.6/drivers/message/fusion/mptscsih.c	2011-04-04 06:26:07.036096337 -0700
@@ -1773,7 +1773,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	int		 scpnt_idx;
 	int		 retval;
 	VirtDevice	 *vdevice;
-	ulong	 	 sn = SCpnt->serial_number;
 	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
@@ -1859,8 +1858,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 			 vdevice->vtarget->id, vdevice->lun,
 			 ctx2abort, mptscsih_get_tm_timeout(ioc));
 
-	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
-	    SCpnt->serial_number == sn) {
+	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx) {
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "task abort: command still in active list! (sc=%p)\n",
 		    ioc->name, SCpnt));
@@ -1873,9 +1871,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	}
 
  out:
-	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p) (sn=%ld)\n",
+	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p)\n",
 	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), retval,
-	    SCpnt, SCpnt->serial_number);
+	    SCpnt);
 
 	return retval;
 }
