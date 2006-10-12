From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH] zfcp: initialize scsi_host_template.max_sectors with appropriate value
Date: Thu, 12 Oct 2006 11:43:44 +0200
Message-ID: <200610121143.44321.swen@vnet.ibm.com>
References: <200610091533.42282.swen@vnet.ibm.com> <1160579121.3447.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:5113 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1422850AbWJLJns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 05:43:48 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id k9C9hk2D084382
	for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2006 09:43:46 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9C9k86g3158168
	for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2006 11:46:08 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9C9hjlU029012
	for <linux-scsi@vger.kernel.org>; Thu, 12 Oct 2006 11:43:46 +0200
In-Reply-To: <1160579121.3447.21.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Sorry James

won't happen again.

###############################################

commit 9ceca33ffd6287163e39030f3a5c6fad60d17f7b
Author: Swen Schillig <swen@vnet.ibm.com>
Date:   Thu Oct 12 11:24:54 2006 +0200

    Define ZFCP_MAX_SECTORS and initialize scsi_host_template.max_sectors
    with appropriate value.
    
    Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 8f88269..74c0eac 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -107,6 +107,10 @@ #define ZFCP_MAX_SBALES_PER_REQ		\
 	(ZFCP_MAX_SBALS_PER_REQ * ZFCP_MAX_SBALES_PER_SBAL - 2)
         /* request ID + QTCB in SBALE 0 + 1 of first SBAL in chain */
 
+#define ZFCP_MAX_SECTORS (ZFCP_MAX_SBALES_PER_REQ * 8)
+        /* max. number of (data buffer) SBALEs in largest SBAL chain
+           multiplied with number of sectors per 4k block */
+
 /* FIXME(tune): free space should be one max. SBAL chain plus what? */
 #define ZFCP_QDIO_PCI_INTERVAL		(QDIO_MAX_BUFFERS_PER_Q \
                                          - (ZFCP_MAX_SBALS_PER_REQ + 4))
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 4d2bc79..452d96f 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -58,6 +58,7 @@ struct zfcp_data zfcp_data = {
 		.cmd_per_lun		= 1,
 		.use_clustering		= 1,
 		.sdev_attrs		= zfcp_sysfs_sdev_attrs,
+		.max_sectors		= ZFCP_MAX_SECTORS,
 	},
 	.driver_version = ZFCP_VERSION,
 };


On Wednesday 11 October 2006 17:05, you wrote:
> On Mon, 2006-10-09 at 15:33 +0200, Swen Schillig wrote:
> > commit 7f3c3e955cfba57c4d95706c326d9c5b2f92e941
> > Author: Swen Schillig <swen@vnet.ibm.com>
> > Date:   Mon Oct 9 14:59:08 2006 +0200
> > 
> > Define (ZFCP_MAX_SECTORS) and initialize scsi_host_template.max_sectors with 
> > appropriate value.
> > 
> >      ZFCP_MAX_SECTORS (ZFCP_MAX_SBALES_PER_REQ * 8)
> >         /* max. number of (data buffer) SBALEs in largest SBAL chain
> >            multiplied with number of sectors per 4k block */
> 
> This needs a signoff.
> 
> Plus it doesn't apply: it looks like your mailer has converted tabs to
> spaces.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
