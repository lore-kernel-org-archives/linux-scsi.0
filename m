From: Judith Lebzelter <judith@linux-foundation.org>
Subject: [ PATCH ] mptsas: Fix oops during driver load time(rev 2)
Date: Mon, 12 Mar 2007 15:14:31 -0700
Message-ID: <20070312221431.GA7493@shell0.pdx.osdl.net>
References: <20070310092643.GB22182@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbXCLWOq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Mar 2007 18:14:46 -0400
Content-Disposition: inline
In-Reply-To: <20070310092643.GB22182@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, James.Bottomley@SteelEye.com

This fixes an oops during driver load time.   

mptsas_probe calls mpt_attach(over in mptbase.c).  Inside that 
call, we read some manufacturing config pages to setup some 
defaults.  While reading the config pages, the firmware doesn't 
complete the reply in time, and we have a timeout. The timeout 
results in hardreset handler being called.  The hardreset 
handler calls all the fusion upper layer driver reset callback 
handlers.  The mptsas_ioc_reset function is the callback handler 
in mptsas.c.   In summary, mptsas_ioc_reset is getting called 
before scsi_host_alloc is called, and the pointer ioc->sh is 
NULL, as well as the hostdata.

Signed-off-by:  Judith Lebzelter <judith@osdl.org

---
Sorry I was not more descriptive.  Here is the patch with Eric's 
description as requested.

Index: linux-2.6.21-rc3/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.21-rc3.orig/drivers/message/fusion/mptsas.c
+++ linux-2.6.21-rc3/drivers/message/fusion/mptsas.c
@@ -815,7 +815,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
 static int
 mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	MPT_SCSI_HOST	*hd;
 	struct mptsas_target_reset_event *target_reset_list, *n;
 	int rc;
 
@@ -827,7 +827,10 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int r
 	if (reset_phase != MPT_IOC_POST_RESET)
 		goto out;
 
-	if (!hd || !hd->ioc)
+	if (!ioc->sh || !ioc->sh->hostdata)
+		goto out;
+	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	if (!hd->ioc)
 		goto out;
 
 	if (list_empty(&hd->target_reset_list))


