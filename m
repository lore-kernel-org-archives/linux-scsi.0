From: Arjan van de Ven <arjanv@redhat.com>
Subject: mark scsi_add_host() as __must_check
Date: Mon, 23 Aug 2004 13:24:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823112440.GA31874@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50661 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262062AbUHWLYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 07:24:42 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.10/8.12.10) with ESMTP id i7NBOge1011602
	for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 07:24:42 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i7NBOga10189
	for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 07:24:42 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.10) with ESMTP id i7NBOeAp032316
	for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 07:24:40 -0400
Received: (from arjanv@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id i7NBOeIY032314
	for linux-scsi@vger.kernel.org; Mon, 23 Aug 2004 13:24:40 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

It seems it's a dangerous trap to write the following code:

        scsi_add_host(host, &pdev->dev);
        scsi_scan_host(host);

without checking the return value of scsi_add_host; it seems scsi_add_host()
is one of those functions that you reall have to check the return value of,
this patch makes it so:

--- linux-2.6.7/include/scsi/scsi_host.h~	2004-08-03 11:33:19.127693290 +0200
+++ linux-2.6.7/include/scsi/scsi_host.h	2004-08-03 11:33:19.127693290 +0200
@@ -524,7 +524,7 @@
 	container_of(d, struct Scsi_Host, shost_classdev)
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
-extern int scsi_add_host(struct Scsi_Host *, struct device *);
+extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
