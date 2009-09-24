From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: PATCH 1/1] pmcraid: Fix ppc64 driver build for using cpu_to_le32 on
 U8 data type
Date: Thu, 24 Sep 2009 16:27:42 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0909241613320.16579@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:59719 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZIYAZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 20:25:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: gregkh@suse.de, anil_ravindranath@pmc-sierra.com


Fix a reported ppc64 driver build issue. Removed cpu_to_le32 conversion 
usage for flags in struct pmcraid_ioadl_desc. This was breaking the driver build in ppc64.

drivers/scsi/pmcraid.c: In function 'pmcraid_request_sense':
drivers/scsi/pmcraid.c:2254: warning: large integer implicitly truncated
to unsigned type

(I have not done compile/build test on ppc64 with these changes)

Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>

pmcraid.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2009-09-24 15:06:06.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2009-09-24 15:46:22.000000000 -0700
@@ -1071,7 +1071,7 @@ static struct pmcraid_cmd *pmcraid_init_
 
 	ioarcb->data_transfer_length = cpu_to_le32(rcb_size);
 
-	ioadl[0].flags |= cpu_to_le32(IOADL_FLAGS_READ_LAST);
+	ioadl[0].flags |= IOADL_FLAGS_READ_LAST;
 	ioadl[0].data_len = cpu_to_le32(rcb_size);
 	ioadl[0].address = cpu_to_le32(dma);
 
@@ -2251,7 +2251,7 @@ static void pmcraid_request_sense(struct
 
 	ioadl->address = cpu_to_le64(cmd->sense_buffer_dma);
 	ioadl->data_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
-	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
 
 	/* request sense might be called as part of error response processing
 	 * which runs in tasklets context. It is possible that mid-layer might
@@ -3017,7 +3017,7 @@ static int pmcraid_build_ioadl(
 		ioadl[i].flags = 0;
 	}
 	/* setup last descriptor */
-	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
 
 	return 0;
 }
@@ -3387,7 +3387,7 @@ static int pmcraid_build_passthrough_ioa
 	}
 
 	/* setup the last descriptor */
-	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
 
 	return 0;
 }
@@ -5314,7 +5314,7 @@ static void pmcraid_querycfg(struct pmcr
 		cpu_to_le32(sizeof(struct pmcraid_config_table));
 
 	ioadl = &(ioarcb->add_data.u.ioadl[0]);
-	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
 	ioadl->address = cpu_to_le64(pinstance->cfg_table_bus_addr);
 	ioadl->data_len = cpu_to_le32(sizeof(struct pmcraid_config_table));
 
