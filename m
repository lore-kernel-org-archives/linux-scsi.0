From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/3] zfcp: Fix adapter activation on link down
Date: Tue, 05 Oct 2010 17:12:53 +0200
Message-ID: <20101005151358.922092386@de.ibm.com>
References: <20101005151252.217141720@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:47227 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0JEPOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 11:14:11 -0400
Content-Disposition: inline; filename=712-zfcp-adapter-activation.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

If an exchange config is executed while the local link is down, the
request succeeds but the returned data is incomplete.  Proceeding with
the adapter activation is leading to an unpredictable behaviour (e.g.
kernel panic) caused by invalid values.  In such a scenario the
recommended ERP is to retry the action and wait for a link up event.
If the issue persists the activation has to fail.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Sigend-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    3 ---
 1 file changed, 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-10-05 15:58:20.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-10-05 15:58:20.000000000 +0200
@@ -532,9 +532,6 @@ static void zfcp_fsf_exchange_config_dat
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
 
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
-				&adapter->status);
-
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;

