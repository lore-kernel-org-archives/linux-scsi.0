From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] sd: Ensure we correctly disable devices with unknown
 protection type
Date: Wed, 26 Sep 2012 11:26:48 +0300
Message-ID: <20120926082648.GA6721@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27599 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2IZI05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2012 04:26:57 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8Q8QtXp022207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2012 08:26:56 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8Q8QtUg002019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2012 08:26:55 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8Q8QtBV032466
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2012 03:26:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

Hi Martin,

The patch fe542396da73: "[SCSI] sd: Ensure we correctly disable
devices with unknown protection type" from Sep 21, 2012, leads to the
following warning:
include/scsi/scsi_host.h:879 scsi_host_dif_capable()
	 warn: buffer overflow 'cap' 4 <= 4

   838  enum scsi_host_prot_capabilities {
   839          SHOST_DIF_TYPE1_PROTECTION = 1 << 0, /* T10 DIF Type 1 */
   840          SHOST_DIF_TYPE2_PROTECTION = 1 << 1, /* T10 DIF Type 2 */
   841          SHOST_DIF_TYPE3_PROTECTION = 1 << 2, /* T10 DIF Type 3 */
   842  
   843          SHOST_DIX_TYPE0_PROTECTION = 1 << 3, /* DIX between OS and HBA only */
   844          SHOST_DIX_TYPE1_PROTECTION = 1 << 4, /* DIX with DIF Type 1 */
   845          SHOST_DIX_TYPE2_PROTECTION = 1 << 5, /* DIX with DIF Type 2 */
   846          SHOST_DIX_TYPE3_PROTECTION = 1 << 6, /* DIX with DIF Type 3 */
   847  };

   869  static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsigned int target_type)
   870  {
   871          static unsigned char cap[] = { 0,
   872                                         SHOST_DIF_TYPE1_PROTECTION,
   873                                         SHOST_DIF_TYPE2_PROTECTION,
   874                                         SHOST_DIF_TYPE3_PROTECTION };
   875  
   876          if (target_type > SHOST_DIF_TYPE3_PROTECTION)
   877                  return 0;
   878  
   879          return shost->prot_capabilities & cap[target_type] ? target_type : 0;
                                                  ^^^^^^^^^^^^^^^^
It looks like we're doing cap[1 << 2] here not cap[2].

   880  }

   882  static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsigned int target_type)
   883  {
   884  #if defined(CONFIG_BLK_DEV_INTEGRITY)
   885          static unsigned char cap[] = { SHOST_DIX_TYPE0_PROTECTION,
   886                                         SHOST_DIX_TYPE1_PROTECTION,
   887                                         SHOST_DIX_TYPE2_PROTECTION,
   888                                         SHOST_DIX_TYPE3_PROTECTION };
   889  
   890          if (target_type > SHOST_DIX_TYPE3_PROTECTION)
   891                  return 0;
   892  
   893          return shost->prot_capabilities & cap[target_type];
                                                  ^^^^^^^^^^^^^^^^^
We're doing cap[1 << 6] here, not cap[6];

   894  #endif
   895          return 0;
   896  }

regards,
dan carpenter

