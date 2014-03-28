From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mpt3sas: tidy up output slightly
Date: Fri, 28 Mar 2014 11:39:01 +0300
Message-ID: <20140328083901.GQ25192@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36750 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaC1Ij3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Mar 2014 04:39:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The indenting here for "pr_info("\n");" is not correct.  It's not part
of the if condition.

Also using pr_info() would put extra characters in the middle of the
line.  I suppose that people could complain that pr_cont() is racy but
at least it's better than the original code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..aa0e042 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -585,9 +585,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 		if (event_data->DiscoveryStatus)
-			pr_info("discovery_status(0x%08x)",
+			pr_cont("discovery_status(0x%08x)",
 			    le32_to_cpu(event_data->DiscoveryStatus));
-			pr_info("\n");
+		pr_cont("\n");
 		return;
 	}
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
