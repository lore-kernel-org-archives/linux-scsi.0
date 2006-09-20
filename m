From: "Metathronius Galabant" <m.galabant@googlemail.com>
Subject: [PATCH]: cciss - remove unneeded spaces in output for attached volumes (resend)
Date: Wed, 20 Sep 2006 13:22:09 +0200
Message-ID: <1b270aae0609200422h511d1169na201cdeaee05a24a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:60329 "EHLO
	wx-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1751132AbWITLWL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 07:22:11 -0400
Received: by wx-out-0506.google.com with SMTP id s14so239014wxc
        for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2006 04:22:10 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iss_storagedev@hp.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

please see the following patch against the cciss driver (HP/Compaq
SmartArray Controllers).
It removes the awkwards spaces after the "=" when displaying the
geometry of the attached volumes.

Before:
cciss: using DAC cycles
     blocks= 286734240 block_size= 512
     heads= 255, sectors= 32, cylinders= 35139

After:
cciss: using DAC cycles
     blocks=286734240 block_size=512
     heads=255, sectors=32, cylinders=35139


The following is against 2.6.18-rc6 (and I hope gmail doesn't corrupt
the inline patch).
Cheers,
M.


Signed-off-by: Metathronius Galabant <m.galabant@gmail.com>

diff -ru linux-2.6.18-rc6/drivers/block/cciss.c
linux-2.6.18-rc6-f/drivers/block/cciss.c
--- linux-2.6.18-rc6/drivers/block/cciss.c      2006-09-11
15:57:54.000000000 +0200
+++ linux-2.6.18-rc6-f/drivers/block/cciss.c    2006-09-11
16:32:42.000000000 +0200
@@ -1934,7 +1934,7 @@
        } else {                /* Get geometry failed */
                printk(KERN_WARNING "cciss: reading geometry failed\n");
        }
-       printk(KERN_INFO "      heads= %d, sectors= %d, cylinders= %d\n\n",
+       printk(KERN_INFO "      heads=%d, sectors=%d, cylinders=%d\n\n",
               drv->heads, drv->sectors, drv->cylinders);
 }

@@ -1962,7 +1962,7 @@
                *total_size = 0;
                *block_size = BLOCK_SIZE;
        }
-       printk(KERN_INFO "      blocks= %u block_size= %d\n",
+       printk(KERN_INFO "      blocks=%u block_size=%d\n",
               *total_size, *block_size);
        return;
 }
