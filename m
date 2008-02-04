From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction
 == DMA_FROM_DEVICE'
Date: Mon, 04 Feb 2008 23:36:44 +0100
Message-ID: <47A7937C.7040701@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43531 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbYBDWgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 17:36:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ballabio_dario@emc.com
Cc: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

It should be like this I guess? this patch was not yet tested, please
confirm.
--
Note the duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'

from Documentation/DMA-API.txt:
DMA_TO_DEVICE         = PCI_DMA_TODEVICE      data is going from the
                                              memory to the device
DMA_FROM_DEVICE       = PCI_DMA_FROMDEVICE    data is coming from
                                              the device to the

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 662c004..1e704f9 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1208,15 +1208,15 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
       };
 
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
 
-   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
+   if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
       cpp->xdir = DTD_IN;
       return;
       }
    else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
       cpp->xdir = DTD_OUT;
       return;
       }

