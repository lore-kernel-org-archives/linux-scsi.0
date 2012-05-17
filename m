From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] qla2xxx: don't free pool that wasn't allocated
Date: Thu, 17 May 2012 10:13:40 +0300
Message-ID: <20120517071340.GH14660@elgon.mountain>
References: <20120517071120.GG14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120517071120.GG14660@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In the original code, if dma_pool_alloc() fails then we call
dma_pool_free().  It causes an error, possibly a NULL dereference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c17975d..44380d3 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2386,7 +2386,7 @@ sufficient_dsds:
 		if (!ctx->fcp_cmnd) {
 			ql_log(ql_log_fatal, vha, 0x3011,
 			    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
-			goto queuing_error_fcp_cmnd;
+			goto queuing_error;
 		}
 
 		/* Initialize the DSD list and dma handle */
