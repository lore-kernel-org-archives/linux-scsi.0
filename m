From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mptscsih: Mark expected switch fall-throughs
Date: Wed, 20 Mar 2019 15:31:39 -0500
Message-ID: <20190320203139.GA18369@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warnings:

drivers/message/fusion/mptscsih.c: In function ‘mptscsih_io_done’:
drivers/message/fusion/mptscsih.c:741:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
    if ( ioc->bus_type == SAS ) {
       ^
drivers/message/fusion/mptscsih.c:790:3: note: here
   case MPI_IOCSTATUS_SCSI_TASK_TERMINATED: /* 0x0048 */
   ^~~~
drivers/message/fusion/mptscsih.c:884:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
    scsi_set_resid(sc, 0);
    ^~~~~~~~~~~~~~~~~~~~~
drivers/message/fusion/mptscsih.c:885:3: note: here
   case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR: /* 0x0040 */
   ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/message/fusion/mptscsih.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 587b5daf74b4..f0737c57ed5f 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -786,6 +786,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			/*
 			 * Allow non-SAS & non-NEXUS_LOSS to drop into below code
 			 */
+			/* Fall through */
 
 		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
 			/* Linux handles an unsolicited DID_RESET better
@@ -882,6 +883,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 		case MPI_IOCSTATUS_SCSI_DATA_OVERRUN:		/* 0x0044 */
 			scsi_set_resid(sc, 0);
+			/* Fall through */
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
 			sc->result = (DID_OK << 16) | scsi_status;
-- 
2.21.0
