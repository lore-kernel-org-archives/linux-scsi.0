From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix Scsi_Host leak in BusLogic
Date: Tue, 14 Sep 2004 20:23:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914182352.GA16223@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43400 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269653AbUINSXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 14:23:55 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.33/drivers/scsi/BusLogic.c	2004-08-29 16:58:42 +02:00
+++ edited/drivers/scsi/BusLogic.c	2004-09-14 22:11:49 +02:00
@@ -2344,6 +2344,8 @@
 	   Remove Host Adapter from the list of registered BusLogic Host Adapters.
 	 */
 	list_del(&HostAdapter->host_list);
+
+	scsi_host_put(Host);
 	return 0;
 }
 
