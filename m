From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/21] aic94xx: Don't eat TMF_QUERY_TASK results
Date: Thu, 11 Jan 2007 14:15:12 -0800
Message-ID: <20070111221512.3543.15421.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57379 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbXAKWOx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:53 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEqaG027408
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:52 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEqkl234322
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:52 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEpqQ012839
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:52 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


In this driver, TMF_QUERY_TASK translates to QUERY_SSP_TASK.  The
sequencer, it seems, is perfectly happy sending us a SSP response, which
this function promptly "converts" into TMF_RESP_FUNC_FAILED.  This leads to
the SAS EH making bad decisions based on bad data, so we should not perform
the conversion in this case.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_tmf.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 6123438..fd5269e 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -566,6 +566,11 @@ static int asd_initiate_ssp_tmf(struct d
 		res = TMF_RESP_FUNC_ESUPP;
 		break;
 	default:
+		if (tmf == TMF_QUERY_TASK) {
+			ASD_DPRINTK("%s: QUERY_SSP_TASK response: 0x%x\n",
+				    __FUNCTION__, res);
+			break;
+		}
 		ASD_DPRINTK("%s: converting result 0x%x to TMF_RESP_FUNC_FAILED\n",
 			    __FUNCTION__, res);
 		res = TMF_RESP_FUNC_FAILED;
