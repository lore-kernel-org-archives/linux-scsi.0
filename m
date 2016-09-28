From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 0/2] libfc/fcoe Fixes
Date: Wed, 28 Sep 2016 13:30:47 -0400
Message-ID: <1475083849-13478-1-git-send-email-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:53123 "EHLO
        mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750714AbcI1SPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Sep 2016 14:15:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@cavium.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

Hi James, Martin

During testing we fixed a deadlock we found in libfc while logging off from the
fabric if an ELS command was still outstanding.  Also we wanted to make clear
virtual link handling a little more robust when the fcoe_ctlr is not logged
into the fabric.

Please apply at your earliest convenience.

Thanks,
Chad

Chad Dupuis (2):
  fcoe: Harden CVL handling when we have not logged into the fabric.
  libfc: Do not take rdata->rp_mutex when processing a -FC_EX_CLOSED ELS
    response.

 drivers/scsi/fcoe/fcoe_ctlr.c | 35 ++++++++++++++++++++++++++++++++---
 drivers/scsi/libfc/fc_rport.c | 32 ++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 11 deletions(-)

-- 
1.8.5.6

