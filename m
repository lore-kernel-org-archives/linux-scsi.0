From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] zfcp: Report scatter gather limit for DIX protection
 information
Date: Fri, 10 Sep 2010 13:45:03 +0200
Message-ID: <20100910114503.GA3059@schmichrtp.mainz.de.ibm.com>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:57138 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0IJLpG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 07:45:06 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.1/8.13.1) with ESMTP id o8ABj40q000763
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 11:45:04 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8ABj4xA4096120
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 13:45:04 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o8ABj3qD022128
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 13:45:04 +0200
Content-Disposition: inline
In-Reply-To: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: jaxboe@fusionio.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

When sending DIX integrity segments with an I/O request, the
restriction for the maximum number of segments is still the same for
the zfcp hardware. Report the new sg_prot_tablesize for the SCSI host,
so that the number of integrity segments plus the number of data
segments is not larger than the hardware limit. This results in using
half of the hardware segments for integrity data and the other half
for regular data.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -681,6 +681,7 @@ void zfcp_scsi_set_prot(struct zfcp_adap
 	    adapter->adapter_features & FSF_FEATURE_DIX_PROT_TCPIP) {
 		mask |= SHOST_DIX_TYPE1_PROTECTION;
 		scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP);
+		shost->sg_prot_tablesize = ZFCP_QDIO_MAX_SBALES_PER_REQ / 2;
 		shost->sg_tablesize = ZFCP_QDIO_MAX_SBALES_PER_REQ / 2;
 		shost->max_sectors = ZFCP_QDIO_MAX_SBALES_PER_REQ * 8 / 2;
 	}
