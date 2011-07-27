From: Dan Carpenter <error27@gmail.com>
Subject: re: [SCSI] mvsas: misc improvements
Date: Wed, 27 Jul 2011 21:54:17 +0300
Message-ID: <20110727185417.GS3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57454 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1G0S4P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 14:56:15 -0400
Received: by yxi11 with SMTP id 11so970319yxi.19
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 11:56:15 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: linux-scsi@vger.kernel.org

84fbd0cea11b80 "[SCSI] mvsas: misc improvements" introduces a
potential NULL dereference.

@@ -1375,6 +1385,7 @@ void mvs_dev_gone_notify(struct domain_device *dev)
                mv_dprintk("found dev has gone.\n");
---> mvi_dev is NULL on this path.
        }
        dev->lldd_dev = NULL;
+       mvi_dev->sas_device = NULL;
---> we dereference it here.
 
        spin_unlock_irqrestore(&mvi->lock, flags);
 }

regards,
dan carpenter
