From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] megaraid_mbox fix
Date: Sat, 12 Feb 2005 02:01:59 +0000
Message-ID: <20050212020159.GZ8859@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:35289 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262382AbVBLCCA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 21:02:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	wrong order of arguments in memset().

That, BTW, shows why cross-builds are useful - the only indication of
problem had been a new warning showing up in sparse output on alpha build
(number exceeding 256 got truncated).

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC11-rc3-bk8-base/drivers/scsi/megaraid/megaraid_mbox.c current/drivers/scsi/megaraid/megaraid_mbox.c
--- RC11-rc3-bk8-base/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-11 15:30:27.000000000 -0500
+++ current/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-11 20:54:12.434724497 -0500
@@ -4100,9 +4100,9 @@
 	mbox64	= raid_dev->sysfs_mbox64;
 	ldmap	= raid_dev->sysfs_buffer;
 
-	memset(uioc, sizeof(uioc_t), 0);
-	memset(mbox64, sizeof(mbox64_t), 0);
-	memset(ldmap, sizeof(raid_dev->curr_ldmap), 0);
+	memset(uioc, 0, sizeof(uioc_t));
+	memset(mbox64, 0, sizeof(mbox64_t));
+	memset(ldmap, 0, sizeof(raid_dev->curr_ldmap));
 
 	mbox		= &mbox64->mbox32;
 	raw_mbox	= (char *)mbox;
