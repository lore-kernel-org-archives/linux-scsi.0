From: Arjan van de Ven <arjanv@redhat.com>
Subject: mark scsi_add_host __must_check
Date: Tue, 3 Aug 2004 11:34:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040803093419.GA28412@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:19629 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265293AbUHCJfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 05:35:03 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.10/8.12.10) with ESMTP id i739Z3e1001720
	for <linux-scsi@vger.kernel.org>; Tue, 3 Aug 2004 05:35:03 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i739Z3a08493
	for <linux-scsi@vger.kernel.org>; Tue, 3 Aug 2004 05:35:03 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.10) with ESMTP id i739YJvo031160
	for <linux-scsi@vger.kernel.org>; Tue, 3 Aug 2004 05:34:19 -0400
Received: (from arjanv@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id i739YJs8031158
	for linux-scsi@vger.kernel.org; Tue, 3 Aug 2004 11:34:19 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

it seems scsi_add_host() is one of those functions that a driver really has
to check the return value of, but several forget to do this. Patch below
marks it __must_check which will cause a warning in this case (with gcc
3.4 and later)..


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
