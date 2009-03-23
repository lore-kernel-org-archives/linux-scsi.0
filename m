From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mptsas: remove unneeded check
Date: Mon, 23 Mar 2009 10:46:25 +0000
Message-ID: <20090323104522.32729.51098.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34832 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753471AbZCWKp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2009 06:45:26 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by www.etchedpixels.co.uk (8.14.3/8.14.3) with ESMTP id n2NAkPPi000307
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2009 10:46:25 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Alan Cox <alan@redhat.com>

>From coverity checker. Closes #9675

(This is a resend. This was discussed before, shown to be a bogus check and
 then the change never got applied - hence the origin of the diff being Red Hat)

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/message/fusion/mptsas.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 12b7325..a9019f0 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2279,9 +2279,8 @@ mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
 	mutex_lock(&ioc->sas_topology_mutex);
 	list_for_each_entry_safe(port_info, n, &ioc->sas_topology, list) {
 
-		if (port_info->phy_info &&
-		    (!(port_info->phy_info[0].identify.device_info &
-		    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
+		if (!(port_info->phy_info[0].identify.device_info &
+		    MPI_SAS_DEVICE_INFO_SMP_TARGET))
 			continue;
 
 		if (mptsas_sas_expander_pg0(ioc, &buffer,

