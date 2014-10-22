From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/18] scsi xcopy: suppress error messages
Date: Wed, 22 Oct 2014 09:29:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410220928510.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch suppresses error messages when copying between two arrays that
support XCOPY each, but that cannot copy data between each other.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/sd.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-3.18-rc1/drivers/scsi/sd.c
===================================================================
--- linux-3.18-rc1.orig/drivers/scsi/sd.c	2014-10-21 00:48:51.000000000 +0200
+++ linux-3.18-rc1/drivers/scsi/sd.c	2014-10-21 00:49:21.000000000 +0200
@@ -1935,6 +1935,18 @@ static int sd_done(struct scsi_cmnd *SCp
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
+				good_bytes = 0;
+				req->__data_len = blk_rq_bytes(req);
+				req->cmd_flags |= REQ_QUIET;
+				break;
+			}
 		}
 		break;
 	default:
