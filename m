From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] dpt_i2o.c set array timeout
Date: Mon, 20 Jun 2005 12:08:07 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520DFF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61606 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261373AbVFTQIx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 12:08:53 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@steeleye.com, Christoph Hellwig <hch@lst.de>

Adds in the array timeout adjustment removed by the '[PATCH] remove
scsi_cmnd.eh_state' authored by Christoph Helwig. There are no issues
with the sequence of the application of these patches.

Signed-off-by: Mark Salyzyn aacraid@adaptec.com

Index: linux-2.6/drivers/scsi/dpt_i2o.c
--- linux-2.6.orig/drivers/scsi/dpt_i2o.c    Fri Jun 17 11:41:10 2005
+++ linux-2.6/drivers/scsi/dpt_i2o.c    Mon Jun 20 08:59:35 2005
@@ -376,6 +376,8 @@
        } else {
                scsi_adjust_queue_depth(device, 0, 1);
        }
+       if (device->type == TYPE_DISK)
+               device->timeout = TMOUT_SCSI * HZ;
        return 0;
 }

Sincerely -- Mark Salyzyn
