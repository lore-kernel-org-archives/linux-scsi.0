From: Brad Campbell <brad@wasp.net.au>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 22:34:50 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412E2D4A.3000705@wasp.net.au>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E1039.7030508@pobox.com> <412E135B.1030605@wasp.net.au> <412E1D3E.2050307@pobox.com> <8746466a04082610346b07ea11@mail.gmail.com> <412E2190.7030504@pobox.com> <412E22D9.2060000@wasp.net.au> <412E23E7.4040402@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_wasp.net.au-9936-1093545252-0001-2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412E23E7.4040402@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Dave <dave.jiang@gmail.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_wasp.net.au-9936-1093545252-0001-2
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
>
>> Yep.. using a bridge!
>> How to detect the bridge though?
> 
> 
> It's not terribly easy :/
> 
> If you can google for the datasheet, that would be helpful.

Did that. No dice. The data available says nothing about any way of detection. It's a completely 
transparent bridge. SIL3611.

> Sometimes bridges will modify the underlying 40-char ATA model name,
> 
>     WD123456                        ADDONICS68
> 
> where "WD123456" is the underlying ATA device, and "ADDONICS68" is the 
> bridge identifier.

Nope. Does not do that either.

I based this on the fact the drive number is a PATA drive (the WD2000JD is a SATA drive).
This patch was modeled on the sil quirk detection code and "works for me" in that I have 
read/written 2GB with 2.6.9-rc1 now where 128KB would kill it before.

I have a little flat spot on my forehead and a little forehead shaped dent in the wall next to this 
machine.

Thanks for your help, patience and guidance guys.

Regards,
Brad

--=_wasp.net.au-9936-1093545252-0001-2
Content-Type: text/plain; name="sata.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata.patch"

--- orig/linux-2.6.0/drivers/scsi/sata_via.c	2004-08-26 22:21:56.000000000 +0400
+++ linux-2.6.9-rc1/drivers/scsi/sata_via.c	2004-08-26 22:14:19.000000000 +0400
@@ -59,10 +59,13 @@
 
 	SATA_EXT_PHY		= (1 << 6), /* 0==use PATA, 1==ext phy */
 	SATA_2DEV		= (1 << 5), /* SATA is master/slave */
+	SVIA_QUIRK_200SECTS	= (1 << 0),
+
 };
 
 static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static u32 svia_scr_read (struct ata_port *ap, unsigned int sc_reg);
+static void svia_dev_config(struct ata_port *ap, struct ata_device *dev);
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static struct pci_device_id svia_pci_tbl[] = {
@@ -71,6 +74,14 @@
 	{ }	/* terminate list */
 };
 
+struct svia_drivelist {
+        const char * product;
+        unsigned int quirk;
+} svia_blacklist [] = {
+        { "WDC WD2000JB",         SVIA_QUIRK_200SECTS },
+        { }
+};
+
 static struct pci_driver svia_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= svia_pci_tbl,
@@ -122,6 +133,8 @@
 
 	.port_start		= ata_port_start,
 	.port_stop		= ata_port_stop,
+	.dev_config		= svia_dev_config,
+
 };
 
 MODULE_AUTHOR("Jeff Garzik");
@@ -283,6 +296,40 @@
 	return rc;
 }
 
+static void svia_dev_config(struct ata_port *ap, struct ata_device *dev)
+{
+        unsigned int n, quirks = 0;
+        unsigned char model_num[40];
+        const char *s;
+        unsigned int len;
+
+        ata_dev_id_string(dev, model_num, ATA_ID_PROD_OFS,
+                          sizeof(model_num));
+        s = &model_num[0];
+        len = strnlen(s, sizeof(model_num));
+
+        /* ATAPI specifies that empty space is blank-filled; remove blanks */
+        while ((len > 0) && (s[len - 1] == ' '))
+                len--;
+
+        for (n = 0; svia_blacklist[n].product; n++) 
+                if (!memcmp(svia_blacklist[n].product, s,
+                            strlen(svia_blacklist[n].product))) {
+                        quirks = svia_blacklist[n].quirk;
+                        break;
+                }
+        
+        /* limit requests to 200 sectors */
+        if (quirks & SVIA_QUIRK_200SECTS) {
+                printk(KERN_INFO "ata%u(%u): applying WD errata fix\n",
+                       ap->id, dev->devno);
+                ap->host->max_sectors = 200;
+                ap->host->hostt->max_sectors = 200;
+                return;
+        }
+
+}
+
 static int __init svia_init(void)
 {
 	return pci_module_init(&svia_pci_driver);

--=_wasp.net.au-9936-1093545252-0001-2--
