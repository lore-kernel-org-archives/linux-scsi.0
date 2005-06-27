From: "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 2.6.12 1/1] st: support ANSI end-of-volume processing
Date: Mon, 27 Jun 2005 15:15:32 -0400
Message-ID: <20050627191531.GC17260@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from apollo.tuxdriver.com ([24.172.12.2]:18701 "EHLO
	apollo.tuxdriver.com") by vger.kernel.org with ESMTP
	id S261750AbVF0TPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 15:15:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, Fabien.Collin@cern.ch, Jean-Philippe.Baud@cern.ch

The ANSI labelled tape standard specifies that the EOD on tape must be
preceeded by a trailer label.  If during writing your application hits
LEOT (Logical End Of Tape), it must be able to write the trailer label.
However with the default tape driver (st), you cannot write anything
after the LEOT. So the patch clears the error condition so that the
application can write the trailer label (there is some space available
on tape media between LEOT and PEOT=Physical End Of Tape).

Signed-off-by: Fabien Collin <Fabien.Collin@cern.ch>
Signed-off-by: Jean-Philippe Baud <Jean-Philippe.Baud@cern.ch>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Original patch by Fabien Collin.  Description above by Jean-Philippe
Baud.  Patch monkeying by me...  Honestly, I don't know a lot about
this patch.  But, I am told it "works"...  If you have questions
regarding this, send them to me and I'll get an answer for you.

 drivers/scsi/st.c |    1 +
 1 files changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3440,6 +3440,7 @@ static int st_ioctl(struct inode *inode,
 		}
 
 		STp->recover_reg = 0;		/* Clear after read */
+		STps->eof = ST_NOEOF;
 		retval = 0;
 		goto out;
 	}			/* End of MTIOCGET */
-- 
John W. Linville
linville@tuxdriver.com
