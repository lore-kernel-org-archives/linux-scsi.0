From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] mpt2sas: do not check serial_number in the abort handler
Date: Mon, 4 Apr 2011 09:42:30 -0400
Message-ID: <20110404134230.GC32522@infradead.org>
References: <20110404134203.GA29525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1DDNma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2011 09:42:30 -0400
Content-Disposition: inline
In-Reply-To: <20110404134203.GA29525@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

The SCSI midlayer stops all command processing when in error handling, which
means there is no chance for command reuse when the abort handler is called.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-04-04 06:25:05.892763786 -0700
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-04-04 06:25:24.592763544 -0700
@@ -2133,8 +2133,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_AD
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
 		scmd_lookup = _scsih_scsi_lookup_get(ioc, smid_task);
-		if (scmd_lookup && (scmd_lookup->serial_number ==
-		    scmd->serial_number))
+		if (scmd_lookup)
 			rc = FAILED;
 		else
 			rc = SUCCESS;
