From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] scsi: fix uninitialized variable in iscsi
Date: Wed, 29 Oct 2008 17:03:59 +1100
Message-ID: <20081029170359.70682e02.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753079AbYJ2GEX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[Resend to get through vger's filters, sorry]

drivers/scsi/scsi_transport_iscsi.c: In function 'iscsi_add_session':
drivers/scsi/scsi_transport_iscsi.c:704: warning: 'err' may be used uninitialized in this function

Indeed the error path can be taken without err being set.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/scsi_transport_iscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

I don't know if ENOMEM is the proper error code to return.

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4a803eb..99855db 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -719,6 +719,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 						 "Too many iscsi targets. Max "
 						 "number of targets is %d.\n",
 						 ISCSI_MAX_TARGET - 1);
+			err = -ENOMEM;
 			goto release_host;
 		}
 	}
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
