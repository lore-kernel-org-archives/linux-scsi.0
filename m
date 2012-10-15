From: Maciej Patelczyk <maciej.patelczyk@intel.com>
Subject: [PATCH] isci: copy fis 0x34 response into proper buffer
Date: Mon, 15 Oct 2012 14:29:03 +0200
Message-ID: <20121015122903.1538.77822.stgit@gklab-128-044.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:44483 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2JOMdM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2012 08:33:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

SATA MICROCODE DOWNALOAD fails on isci driver. After receiving Register
Device to Host (FIS 0x34) frame Initiator resets phy.
In the frame handler routine response (FIS 0x34) was copied into wrong
buffer and upper layer did not receive any answer which resulted in
timeout and reset.
This patch corrects this bug.


Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 drivers/scsi/isci/request.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 7a0431c..94483c9 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1972,7 +1972,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 								      frame_index,
 								      (void **)&frame_buffer);
 
-			sci_controller_copy_sata_response(&ireq->stp.req,
+			sci_controller_copy_sata_response(&ireq->stp.rsp,
 							       frame_header,
 							       frame_buffer);
 

