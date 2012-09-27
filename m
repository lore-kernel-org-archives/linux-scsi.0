From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] sd: Ensure we correctly disable devices with unknown protection type
Date: Wed, 26 Sep 2012 22:39:44 -0400
Message-ID: <yq1txuk9ojz.fsf@sermon.lab.mkp.net>
References: <20120926082648.GA6721@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18503 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2I0Cjw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2012 22:39:52 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8R2dooM007532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 02:39:51 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8R2dngK022785
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 02:39:50 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8R2dnxO007797
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2012 21:39:49 -0500
In-Reply-To: <20120926082648.GA6721@elgon.mountain> (Dan Carpenter's message
	of "Wed, 26 Sep 2012 11:26:48 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan,

Dan> 	 warn: buffer overflow 'cap' 4 <= 4

Argh, yes. Type 3 is 4 because it's a bitmask.

-- 
Martin K. Petersen	Oracle Linux Engineering


SCSI: Fix range check in scsi_host.h

The range checking from fe542396 was bad. We would still end up walking
beyond the array as Type 3 is defined to be 4 in the protection
bitmask. Instead use ARRAY_SIZE() for the range check.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..2b6956e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -873,7 +873,7 @@ static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsign
 				       SHOST_DIF_TYPE2_PROTECTION,
 				       SHOST_DIF_TYPE3_PROTECTION };
 
-	if (target_type > SHOST_DIF_TYPE3_PROTECTION)
+	if (target_type >= ARRAY_SIZE(cap))
 		return 0;
 
 	return shost->prot_capabilities & cap[target_type] ? target_type : 0;
@@ -887,7 +887,7 @@ static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsign
 				       SHOST_DIX_TYPE2_PROTECTION,
 				       SHOST_DIX_TYPE3_PROTECTION };
 
-	if (target_type > SHOST_DIX_TYPE3_PROTECTION)
+	if (target_type >= ARRAY_SIZE(cap))
 		return 0;
 
 	return shost->prot_capabilities & cap[target_type];
