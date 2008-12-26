From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/7] drivers/message/fusion: Move a dereference below a NULL
 test
Date: Fri, 26 Dec 2008 08:27:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0812260827250.25450@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:55461 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYLZH1v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Dec 2008 02:27:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptctl.c     |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index b89f476..c638171 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -308,10 +308,11 @@ static void mptctl_timeout_expired (MPT_IOCTL *ioctl)
 {
 	int rc = 1;
 
-	dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
-				ioctl->ioc->name, ioctl->ioc->id));
 	if (ioctl == NULL)
 		return;
+	dctlprintk(ioctl->ioc,
+		   printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
+		   ioctl->ioc->name, ioctl->ioc->id));
 
 	ioctl->wait_done = 0;
 	if (ioctl->reset & MPTCTL_RESET_OK)
