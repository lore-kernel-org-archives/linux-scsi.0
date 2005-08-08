From: Dave Jones <davej@redhat.com>
Subject: blacklist addition.
Date: Mon, 8 Aug 2005 19:01:43 -0400
Message-ID: <20050808230143.GA7072@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42649 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932343AbVHHXBt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 19:01:49 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id j78N1msj020775
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 19:01:49 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id j78N1hV05532
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 19:01:43 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.11) with ESMTP id j78N1h3i007781
	for <linux-scsi@vger.kernel.org>; Mon, 8 Aug 2005 19:01:43 -0400
Received: (from davej@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id j78N1hea007779
	for linux-scsi@vger.kernel.org; Mon, 8 Aug 2005 19:01:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When run on a kernel that scans all LUNs, a certain crappy
scsi scanner reports the same LUN over and over..
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=155457

Aparently they were so shamed by this, they chose to remain
anonymous. Though it seems the blacklist code handles
anonymous vendors just fine.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.11/drivers/scsi/scsi_devinfo.c~	2005-04-29 18:16:15.000000000 -0400
+++ linux-2.6.11/drivers/scsi/scsi_devinfo.c	2005-04-29 18:18:27.000000000 -0400
@@ -114,6 +114,7 @@ static struct {
 	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CRW6416S", "1.0c", BLIST_NOLUN},	/* locks up */
+	{"", "Scanner", "1.80", BLIST_NOLUN},	/* responds to all lun */
 
 	/*
 	 * Other types of devices that have special flags.
