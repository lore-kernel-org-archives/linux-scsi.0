From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 2/7] aic94xx: use available
	list_for_each_entry_safe_reverse()
Date: Tue, 06 Jun 2006 16:44:53 -0700
Message-ID: <1149637493.25278.68.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:53160 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751367AbWFFXpK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:45:10 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nj9iI032018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:45:10 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56Nj6ga070878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:45:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56Nj9Lk007488
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:45:09 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nj9Ml007469
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:45:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Use available list_for_each_entry_safe_reverse() function

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
---

Index: linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c
===================================================================
--- linux-2.6.17-rc5.orig/drivers/scsi/sas/sas_discover.c	2006-06-02 15:48:52.000000000 -0700
+++ linux-2.6.17-rc5/drivers/scsi/sas/sas_discover.c	2006-06-02 18:01:08.000000000 -0700
@@ -634,7 +634,7 @@
 	sas_begin_event(DISCE_PORT_GONE, &port->disc.disc_event_lock,
 			&port->disc.pending);
 
-	list_for_each_entry_reverse_safe(dev,n,&port->dev_list,dev_list_node)
+	list_for_each_entry_safe_reverse(dev,n,&port->dev_list,dev_list_node)
 		sas_unregister_dev(dev);
 
 	port->port->rphy = NULL;


