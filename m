From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: [PATCH 1/1]: pmcraid driver fix to avoid twice scsi_dma_unmap for
 a command
Date: Thu, 17 Dec 2009 14:51:53 -0800 (PST)
Message-ID: <alpine.LNX.1.10.0912171434100.20830@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:38892 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbZLRAAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2009 19:00:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: anil_ravindranath@pmc-sierra.com

For a particular driver error condition, driver was doing double 
scsi_dma_unmaps. Driver was calling scsi_dma_unmap in  
pmcraid_error_handler and return 0. This pmcraid_error_handler is called 
by pmcraid_io_done which will do scsi_dma_unmap again when it has 
return 0 from pmcraid_error_handler.

pmcraid.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2009-12-17 13:32:19.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2009-12-17 13:58:58.000000000 -0800
@@ -2483,14 +2483,12 @@
 			sense_copied = 1;
 		}
 
-		if (RES_IS_GSCSI(res->cfg_entry)) {
+		if (RES_IS_GSCSI(res->cfg_entry))
 			pmcraid_cancel_all(cmd, sense_copied);
-		} else if (sense_copied) {
+		else if (sense_copied)
 			pmcraid_erp_done(cmd);
-			return 0;
-		} else  {
+		else
 			pmcraid_request_sense(cmd);
-		}
 
 		return 1;
 


