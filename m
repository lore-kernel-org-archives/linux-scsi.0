From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] iscsi_tcp: make iscsi compile again after recent netlink
	changes
Date: Thu, 08 Sep 2005 10:14:11 -0500
Message-ID: <1126192451.4845.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59547 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932668AbVIHPOb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 11:14:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

netlink_kernel_create now has two new arguments; the module (which is
easy) and the number of groups, which I arbitrarily set to one.

James

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1230,7 +1230,8 @@ static __init int iscsi_transport_init(v
 	if (err)
 		goto unregister_session_class;
 
-	nls = netlink_kernel_create(NETLINK_ISCSI, iscsi_if_rx);
+	nls = netlink_kernel_create(NETLINK_ISCSI, 1, iscsi_if_rx,
+				    THIS_MODULE);
 	if (!nls) {
 		err = -ENOBUFS;
 		goto unregister_notifier;


