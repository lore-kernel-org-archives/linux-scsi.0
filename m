From: Willem Riede <wrlk@riede.org>
Subject: [PATCH] osst buglet
Date: Sat, 25 Oct 2003 17:19:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031025211900.GI16329@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:39423 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S263005AbTJYVMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2003 17:12:46 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can someone please commit the change below to 2.6-test scsi BK for me?
It fixes a "Bad page state at destroy_compound_page" error.

Thanks, Willem Riede, osst maintainer.
------ start patch ------
--- lk/drivers/scsi/osst_options.h	2003-10-25 10:12:24.000000000 -0400
+++ wr/drivers/scsi/osst_options.h	2003-10-25 17:09:26.000000000 -0400
@@ -57,7 +57,7 @@
 /* The size of the first scatter/gather segments (determines the maximum block
    size for SCSI adapters not supporting scatter/gather). The default is set
    to try to allocate the buffer as one chunk. */
-#define OSST_FIRST_ORDER  5
+#define OSST_FIRST_ORDER  (15-PAGE_SHIFT)
 
 
 /* The following lines define defaults for properties that can be set
------ end patch ------
