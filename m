From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v3 0/2] scsi: mpt3sas: prevent oops in the shutdown/unload path
Date: Fri, 16 Feb 2018 20:39:56 -0200
Message-ID: <1518820798-21018-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750797AbeBPWkI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Feb 2018 17:40:08 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1GMdHLC058473
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 17:40:08 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2g62ybv3jp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 17:40:08 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Fri, 16 Feb 2018 17:40:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com, sreekanth.reddy@broadcom.com
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

The first patch prevents the SCSI error handlers to run once the shutdown/unload
path starts.  This avoids an oops at least in the host reset handler, on kernels
with a recent patch, and also in the abort handler on kernels without that patch.

The second patch goes a step further, and prevents the SCSI error handlers to be
called for SCSI IO commands running at the shutdown/unload time (in case adapter
interrupts are disabled before they complete) by finishing them.

Notice the second patch only affects SCSI IO commands. Other command types, e.g.,
Task Manangement Functions, which are running at the shutdown/unload time still
must be handled separately -- this is also covered in patch 1.

The patchset is v3 as PATCH 1/2 is identical to its v2 submission, and PATCH 2/2
has been added (in its first version).

Thanks to Sreekanth Reddy and Bart Van Assche for review and contributions.

Mauricio Faria de Oliveira (2):
  scsi: mpt3sas: fix oops in error handlers after shutdown/unload
  scsi: mpt3sas: wait for and flush running commands on shutdown/unload

 drivers/scsi/mpt3sas/mpt3sas_base.c  |  8 ++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 21 ++++++++++++++++-----
 3 files changed, 23 insertions(+), 9 deletions(-)

-- 
1.8.3.1
