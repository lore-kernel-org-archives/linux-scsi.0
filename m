From: Ballabio_Dario@emc.com
Subject: RE: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'
Date: Tue, 5 Feb 2008 03:09:47 -0500
Message-ID: <59E10AE3DC203E4AAA41B001A2FF2AB8087E25C0@CORPUSMX30B.corp.emc.com>
References: <47A7937C.7040701@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:12066 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYBEIK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 03:10:59 -0500
Content-class: urn:content-classes:message
In-Reply-To: <47A7937C.7040701@tiscali.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 12o3l@tiscali.nl
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Good to know that somebody still uses the Ultrastor 14f board :).....
Yes, this typo was introduced by somebody doing massive editing to all
scsi drivers long ago.
Cheers,
--db
 

-----Original Message-----
From: Roel Kluin [mailto:12o3l@tiscali.nl] 
Sent: Monday, February 04, 2008 11:37 PM
To: Ballabio, Dario
Cc: linux-scsi@vger.kernel.org; lkml
Subject: [PATCH][drivers/scsi/u14-34f.c] duplicate test
'SCpnt->sc_data_direction == DMA_FROM_DEVICE'

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
@@ -1208,15 +1208,15 @@ static void scsi_to_dev_dir(unsigned int i,
unsigned int j) {
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


