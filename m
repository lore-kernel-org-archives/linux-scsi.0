From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [patch] [SCSI] pm80xx: remove unneeded NULL check
Date: Thu, 9 May 2013 05:51:53 -0700
Message-ID: <E5DEE6F468524847995699AD11E80885018BD7FF@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <518b863d.vBepQb4eXhQYEt/W%fengguang.wu@intel.com> <20130509124813.GA5132@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:56294 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab3EIMwA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 May 2013 08:52:00 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20130509124813.GA5132@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, xjtuwjp@gmail.com
Cc: lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Hi Dan,

Yes. I agree with your comment.
Acked-by: anandkumar_santhanam@pmcs.com

Regards
Anand

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Thursday, May 09, 2013 6:18 PM
To: xjtuwjp@gmail.com; Anand Kumar Santhanam
Cc: lindar_liu@usish.com; James E.J. Bottomley;
linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org;
dan.carpenter@oracle.com
Subject: [patch] [SCSI] pm80xx: remove unneeded NULL check

Coccinelle complains about the inconsistent NULL checking on "t".  It
turns out the check isn't needed because we verified that "t" is
non-NULL at the start of the function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index 69dd49c..683df42 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3740,7 +3740,7 @@ int pm8001_mpi_task_abort_resp(struct
pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	mb();
 
-	if ((pm8001_dev->id & NCQ_ABORT_ALL_FLAG) && t)	{
+	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
 		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
 		/* clear the flag */
