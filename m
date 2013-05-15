From: Li Dongyang <dongyang.li@anu.edu.au>
Subject: [PATCH] mptfusion: avoid reset loop by setting the result to DID_SOFT_ERROR
Date: Wed, 15 May 2013 17:36:38 +1000
Message-ID: <1368603398-21969-1-git-send-email-dongyang.li@anu.edu.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from maildrop1.anu.edu.au ([130.56.64.107]:52145 "EHLO
	maildrop1.anu.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3EOHqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 May 2013 03:46:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com
Cc: James Bottomley <JBottomley@Parallels.com>

When IOs are terminated, we observed reset loops:

[  158.580529] sd 1:0:5:0: [sdh] CDB: 
[  158.596051] Read(10): 28 00 00 05 e4 00 00 04 00 00
[  158.601657] mptscsih: ioc1: 	fw_channel = 0, fw_id = 55, lun = 0
[  158.601659] mptscsih: ioc1: 	request_len = 524288, underflow = 524288, resid = 524288
[  158.601660] mptscsih: ioc1: 	tag = 400, transfer_count = 0, sc->result = 00080000
[  158.601662] mptscsih: ioc1: 	iocstatus = IOC terminated (0x004b), scsi_status = success (0x00), scsi_state = (0x0c)
[  158.646781] sd 1:0:5:0: [sdh] CDB: 
[  158.649766] Read(10): 28 00 00 05 e4 00 00 04 00 00
[  158.655158] mptscsih: ioc1: 	fw_channel = 0, fw_id = 55, lun = 0
[  158.655159] mptscsih: ioc1: 	request_len = 524288, underflow = 524288, resid = 524288
[  158.655161] mptscsih: ioc1: 	tag = 314, transfer_count = 0, sc->result = 00000002
[  158.655162] mptscsih: ioc1: 	iocstatus = success (0x0000), scsi_status = check condition (0x02), scsi_state = (0x01)
[  158.655163] mptscsih: ioc1: 	[sense_key,asc,ascq]: [0x06,0x29,0x00]

We should set result to DID_SOFT_ERROR to avoid that, as mpt2sas and mpt3sas are doing the same.

Signed-off-by: Li Dongyang <dongyang.li@anu.edu.au>
---
 drivers/message/fusion/mptscsih.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..12c408f 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -770,22 +770,9 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 						    << 16);
 					    break;
 				}
-			} else if (ioc->bus_type == FC) {
-				/*
-				 * The FC IOC may kill a request for variety of
-				 * reasons, some of which may be recovered by a
-				 * retry, some which are unlikely to be
-				 * recovered. Return DID_ERROR instead of
-				 * DID_RESET to permit retry of the command,
-				 * just not an infinite number of them
-				 */
-				sc->result = DID_ERROR << 16;
-				break;
 			}
-
-			/*
-			 * Allow non-SAS & non-NEXUS_LOSS to drop into below code
-			 */
+			sc->result = DID_SOFT_ERROR << 16;
+			break;
 
 		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */
 			/* Linux handles an unsolicited DID_RESET better
-- 
1.8.1.4

