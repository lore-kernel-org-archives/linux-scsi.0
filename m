From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/7] libsas: Fix incorrect sas_port deformation in sas_form_port
Date: Fri, 26 Jan 2007 14:08:41 -0800
Message-ID: <20070126220841.20198.50710.stgit@elm3a70.beaverton.ibm.com>
References: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47718 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965321AbXAZWGu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:06:50 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM6lER031946
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:47 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM6mJL258614
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:48 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM6l9M002784
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:48 -0500
In-Reply-To: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Currently, sas_form_port checks the given asd_sas_phy's sas_phy to see if
there's already a port attached.  If so, the SAS addresses of the port and
the phy are compared to determine if we need to detach from the port
because the addresses don't match or if we can stop; the SAS address stored
in the sas_port reflects whatever device _was_ attached to the port/phy, and
the SAS address stored in the sas_port reflects whatever device we just
discovered.  As written, the code detaches from the port if the addresses
_do_ match, and prints an error if they do _not_ match.  I believe this to
be incorrect, as it seems more logical to keep the port if the addresses
match (i.e. the phy was reset but the device didn't change), and detach it
they do not (i.e. the device changed).

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index a796ae3..e1e2d08 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -46,7 +46,7 @@ static void sas_form_port(struct asd_sas
 
 	if (port) {
 		if (memcmp(port->attached_sas_addr, phy->attached_sas_addr,
-			   SAS_ADDR_SIZE) == 0)
+			   SAS_ADDR_SIZE) != 0)
 			sas_deform_port(phy);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
