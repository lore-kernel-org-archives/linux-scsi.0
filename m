From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 3/4] aic94xx: Remove TMF result code munging
Date: Mon, 29 Jan 2007 23:48:22 -0800
Message-ID: <20070130074822.7612.47071.stgit@elm3a70.beaverton.ibm.com>
References: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51331 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965431AbXA3Hpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 02:45:51 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U7jnpr007321
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:49 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U7jnpI191522
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:49 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U7jn2s008959
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:49 -0500
In-Reply-To: <20070130074810.7612.31980.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


In asd_initiate_ssp_tmf, the TMF result code is replaced with
TMF_RESP_FUNC_FAILED except when the TMF returns a result code immediately.
However, TMFs can return result codes via an ESCB... yet these codes are
also replaced with "FAILED".  The only values that can fall into that case
are TMF_* codes anyway, so get rid of this code where COMPLETE and SUCCESS
are turned into FAILED.  This also lets us propagate those TMF_* codes up
to the caller.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_tmf.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index fd5269e..9a14a6d 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -566,14 +566,7 @@ static int asd_initiate_ssp_tmf(struct d
 		res = TMF_RESP_FUNC_ESUPP;
 		break;
 	default:
-		if (tmf == TMF_QUERY_TASK) {
-			ASD_DPRINTK("%s: QUERY_SSP_TASK response: 0x%x\n",
-				    __FUNCTION__, res);
-			break;
-		}
-		ASD_DPRINTK("%s: converting result 0x%x to TMF_RESP_FUNC_FAILED\n",
-			    __FUNCTION__, res);
-		res = TMF_RESP_FUNC_FAILED;
+		/* Allow TMF response codes to propagate upwards */
 		break;
 	}
 out_err:
