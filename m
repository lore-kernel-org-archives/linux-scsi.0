From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvscsi: fix timeout bugs
Date: Tue, 22 May 2007 13:50:51 +0900
Message-ID: <20070522135051C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:50517 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbXEVEvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 00:51:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcj@linux.vnet.ibm.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

The viosrp_crq timeout field is in seconds.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b10eefe..9d38c09 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -796,7 +796,7 @@ static void send_mad_adapter_info(struct
 	init_event_struct(evt_struct,
 			  adapter_info_rsp,
 			  VIOSRP_MAD_FORMAT,
-			  init_timeout * HZ);
+			  init_timeout);
 	
 	req = &evt_struct->iu.mad.adapter_info;
 	memset(req, 0x00, sizeof(*req));
@@ -893,7 +893,7 @@ static int send_srp_login(struct ibmvscs
 	init_event_struct(evt_struct,
 			  login_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  init_timeout * HZ);
+			  init_timeout);
 
 	login = &evt_struct->iu.srp.login_req;
 	memset(login, 0x00, sizeof(struct srp_login_req));
@@ -971,7 +971,7 @@ static int ibmvscsi_eh_abort_handler(str
 	init_event_struct(evt,
 			  sync_completion,
 			  VIOSRP_SRP_FORMAT,
-			  init_timeout * HZ);
+			  init_timeout);
 
 	tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 	
@@ -1083,7 +1083,7 @@ static int ibmvscsi_eh_device_reset_hand
 	init_event_struct(evt,
 			  sync_completion,
 			  VIOSRP_SRP_FORMAT,
-			  init_timeout * HZ);
+			  init_timeout);
 
 	tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 
@@ -1326,7 +1326,7 @@ static int ibmvscsi_do_host_config(struc
 	init_event_struct(evt_struct,
 			  sync_completion,
 			  VIOSRP_MAD_FORMAT,
-			  init_timeout * HZ);
+			  init_timeout);
 
 	host_config = &evt_struct->iu.mad.host_config;
 
-- 
1.4.3.2

