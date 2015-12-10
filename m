From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/15] scsi xcopy: suppress error messages
Date: Thu, 10 Dec 2015 12:30:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1512101211440.25927@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1512101145430.25927@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch suppresses error messages when copying between two arrays that
support XCOPY each, but that cannot copy data between each other.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/sd.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-4.4-rc4/drivers/scsi/sd.c
===================================================================
--- linux-4.4-rc4.orig/drivers/scsi/sd.c	2015-12-07 16:58:48.000000000 +0100
+++ linux-4.4-rc4/drivers/scsi/sd.c	2015-12-07 16:59:09.000000000 +0100
@@ -1995,6 +1995,20 @@ static int sd_done(struct scsi_cmnd *SCp
 					req->cmd_flags |= REQ_QUIET;
 				}
 			}
+		} else if (sshdr.asc == 0x26) {
+			switch (op) {
+			/*
+			 * Copying between two arrays that support XCOPY, but
+			 * cannot access each other.
+			 */
+			case EXTENDED_COPY:
+				if ((SCpnt->cmnd[1] & 0x1f) == 0) {
+					good_bytes = 0;
+					req->__data_len = blk_rq_bytes(req);
+					req->cmd_flags |= REQ_QUIET;
+				}
+				break;
+			}
 		}
 		break;
 	default:
