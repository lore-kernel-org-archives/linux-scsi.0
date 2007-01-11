From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/21] aic94xx: Set lldd_max_execute_num in sas_ha
Date: Thu, 11 Jan 2007 14:15:06 -0800
Message-ID: <20070111221506.3543.52184.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45912 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXAKWOr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:47 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFKXJ020715
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:20 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEko0153742
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:46 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEk6a012583
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:46 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


The aic94xx module has a parameter that looks like it should set
lldd_max_execute_num in the sas_ha, but it never sets this value.  Either
we should set it or remove the parameter.  This allows us to enable task
collector mode for this driver, though it is still off by default.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index fbc82b0..9a9ea74 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -526,6 +526,7 @@ static int asd_register_sas_ha(struct as
 	asd_ha->sas_ha.num_phys= ASD_MAX_PHYS;
 
 	asd_ha->sas_ha.lldd_queue_size = asd_ha->seq.can_queue;
+	asd_ha->sas_ha.lldd_max_execute_num = lldd_max_execute_num;
 
 	return sas_register_ha(&asd_ha->sas_ha);
 }
