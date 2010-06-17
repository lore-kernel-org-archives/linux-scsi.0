From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/08] mptfusion: Use DID_TRANSPORT_DISRUPTED instead of DID_BUS_BUSY
Date: Thu, 17 Jun 2010 14:37:25 +0530
Message-ID: <20100617090714.GC29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59401 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932827Ab0FQJnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:43:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Changed the return value for Nexus Loss IOs to be DID_TRANSPORT_DISRUPTED.
What this will allow is the multi-path driver to delay the fail over
process. They would like the path to keep up as long as the nexus loss
Loginfo is return from firmware. With DID_BUS_BUSY the path fails over
immediately.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 5c53624..2a32c8d 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -742,7 +742,9 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 				if (ioc_status & MPI_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE) {
 					if ((log_info & SAS_LOGINFO_MASK)
 					    == SAS_LOGINFO_NEXUS_LOSS) {
-						sc->result = (DID_BUS_BUSY << 16);
+						sc->result =
+							(DID_TRANSPORT_DISRUPTED
+							<< 16);
 						break;
 					}
 				}
