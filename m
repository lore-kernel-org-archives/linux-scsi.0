From: James.Smart@Emulex.Com
Subject: [PATCH 5 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:17 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F414A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42430 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261247AbVFYOeT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:19 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYI9P008186
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:18 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Set max_sectors in host template

Add max_sectors to the driver host template and initialize it with
0xFFFF since the driver has no limitations on the size a transfer
contained by a scsi command and that fits within the sg_tablesize
provisioned by the driver.  This fixes a performance issue seen in
some configurations. 

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_scsi.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/lpfc/lpfc_scsi.c~maxsectors drivers/scsi/lpfc/lpfc_scsi.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_scsi.c~maxsectors	2005-06-25 09:42:09.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_scsi.c	2005-06-25 09:42:09.000000000 -0400
@@ -1273,4 +1273,5 @@ struct scsi_host_template lpfc_template 
 	.cmd_per_lun		= LPFC_CMD_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= lpfc_host_attrs,
+	.max_sectors		= 0xFFFF,
 };
_
