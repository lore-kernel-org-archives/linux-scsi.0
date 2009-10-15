From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Fix incorrect reporting of host protection capabilities
Date: Thu, 15 Oct 2009 14:46:13 -0400
Message-ID: <yq18wfc8phm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:36162 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935290AbZJOSsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 14:48:51 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by acsinet11.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n9FImYJI029603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2009 18:48:35 GMT
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by acsinet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n9FCxN0f015190
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2009 18:49:14 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The advent of DIF Type 2 devices exposed these missing break statements.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 6e728b1..7220125 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -801,12 +801,15 @@ static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsign
 	case 1:
 		if (shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION)
 			return target_type;
+		break;
 	case 2:
 		if (shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION)
 			return target_type;
+		break;
 	case 3:
 		if (shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION)
 			return target_type;
+		break;
 	}
 
 	return 0;
