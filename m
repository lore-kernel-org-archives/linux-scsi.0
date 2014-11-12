From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH] st: set owner in struct device_driver
Date: Wed, 12 Nov 2014 04:01:22 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BEF2A93@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:49394 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaKLEDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2014 23:03:05 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <jbottomley@parallels.com>

After moving from from branch next-20141106 to next-20141111 to pick up recent changes to the st driver I found that the following message was being logged by the kernel (for many other modules as well):

Driver 'st' needs an owner

There was a change in driver_register to check the struct module *owner and if it's not set complain about it, the code path for the st driver is:

static int __init init_st(void)
{
...
        err = scsi_register_driver(&st_template.gendrv);

Which calls:

int scsi_register_driver(struct device_driver *drv)
{
        drv->bus = &scsi_bus_type;

        return driver_register(drv);
}
EXPORT_SYMBOL(scsi_register_driver);

Which calls:

int driver_register(struct device_driver *drv)
{
        int ret;
        struct device_driver *other;

        BUG_ON(!drv->bus->p);

        if (!drv->owner)
                printk(KERN_WARNING "Driver '%s' needs an owner", drv->name);
...

This patch sets the owner field in the struct device_driver contained in the struct scsi_driver for this module. Tested with kernel version 3.18.0-rc4-next-20141111. My assumption here is that the check added in driver_register() is correct and that forces this change and there's a lot of other modules that require a similar change (at least 72 including sd, sr, and osst).

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
diff -up a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	2014-11-10 21:23:27.088567337 -0600
+++ b/drivers/scsi/st.c	2014-11-11 14:07:37.312721375 -0600
@@ -207,6 +207,7 @@ static struct scsi_driver st_template =
 		.name		= "st",
 		.probe		= st_probe,
 		.remove		= st_remove,
+		.owner		= THIS_MODULE,
 	},
 };
