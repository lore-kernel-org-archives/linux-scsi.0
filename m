From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mpt: missing break
Date: Tue, 16 Oct 2012 11:50:59 +0100
Message-ID: <20121016105056.27754.71631.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This happens to do the right thing in all cases on fibre channel but not on
other media types

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/message/fusion/mptscsih.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0c3ced7..164afa7 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -792,6 +792,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			 * than an unsolicited DID_ABORT.
 			 */
 			sc->result = DID_RESET << 16;
+			break;
 
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			if (ioc->bus_type == FC)
