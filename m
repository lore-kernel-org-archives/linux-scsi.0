From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 7/7] libsas: Enable automatic spin-up of SAS disks
Date: Fri, 26 Jan 2007 14:08:58 -0800
Message-ID: <20070126220858.20198.35335.stgit@elm3a70.beaverton.ibm.com>
References: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49600 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965567AbXAZWHH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:07:07 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM75a6014059
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:05 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM75eA233576
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:05 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM74x0003390
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:05 -0500
In-Reply-To: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Set allow_restart=1 for all SAS disks so that they are spun up when needed.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index eac1d2d..04eace9 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -723,6 +723,8 @@ int sas_slave_configure(struct scsi_devi
 		scsi_deactivate_tcq(scsi_dev, 1);
 	}
 
+	scsi_dev->allow_restart = 1;
+
 	return 0;
 }
 
