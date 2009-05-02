From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape: fix gcc 4.4 warning
Date: Sat, 2 May 2009 08:49:34 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.0905020848260.27860@kai.makisara.local>
References: <20090430060430.GA6040@localhost> <1241127084.3320.14.camel@mulgrave.int.hansenpartnership.com> <20090430215906.GA5214@mydomain.tld> <1241129324.3320.21.camel@mulgrave.int.hansenpartnership.com> <20090430222642.GP8633@ZenIV.linux.org.uk>
 <alpine.LNX.2.00.0905010759370.3660@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:36722 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZEBFtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 01:49:42 -0400
In-Reply-To: <alpine.LNX.2.00.0905010759370.3660@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>

This patch fixes the GCC 4.4 warning reported by David Binderman and Sergey
Senozhatsky. The old version was working correctly but was not easy to read.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index eb24efe..c3334ef 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf = !STp->use_pf | PF_TESTED;
+				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
 				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
