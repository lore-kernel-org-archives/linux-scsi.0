From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 0/3] zfcp fixes
Date: Fri,  9 Dec 2016 17:16:30 +0100
Message-ID: <20161209161633.72445-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48671 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933449AbcLIQRL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 11:17:11 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB9GF2EF111595
        for <linux-scsi@vger.kernel.org>; Fri, 9 Dec 2016 11:17:10 -0500
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 277ymhhduc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Dec 2016 11:17:10 -0500
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 9 Dec 2016 16:17:09 -0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

Hi all,

here is a series of important zfcp fixes all marked for stable.
They apply to the fixes branch of James' scsi.git or to v4.9-rc8.

Patch 1 is the most important one since it fixes a panic
that can occur under certain circumstances.

Benjamin Block (1):
  zfcp: fix use-after-"free" in FC ingress path after TMF

Steffen Maier (2):
  zfcp: do not trace pure benign residual HBA responses at default level
  zfcp: fix rport unblock race with LUN recovery

 drivers/s390/scsi/zfcp_dbf.c     | 17 +++++++++--
 drivers/s390/scsi/zfcp_dbf.h     | 41 +++++++++++++++++++++++++--
 drivers/s390/scsi/zfcp_erp.c     | 61 ++++++++++++++++++++++++++++++++++++++--
 drivers/s390/scsi/zfcp_ext.h     |  4 ++-
 drivers/s390/scsi/zfcp_fsf.h     |  3 +-
 drivers/s390/scsi/zfcp_reqlist.h | 30 +++++++++++++++++++-
 drivers/s390/scsi/zfcp_scsi.c    | 61 ++++++++++++++++++++++++++++++++++++----
 7 files changed, 202 insertions(+), 15 deletions(-)

-- 
2.8.4

