From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: megaraid_sas: Optionally add SCSI devices for individual disks
 in a raidset
Date: Wed, 20 Aug 2008 13:53:09 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C32340969D@cosmail02.lsi.com>
References: <2834632.1190561219180854948.JavaMail.root@ouachita>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35003 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbYHTTyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 15:54:31 -0400
In-Reply-To: <2834632.1190561219180854948.JavaMail.root@ouachita>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Malicki <jmalicki@metacarta.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-poweredge <linux-poweredge@dell.com>, linux-scsi <linux-scsi@vger.kernel.org>

MegaRAID SAS controllers are RAID controller, it is not a good idea to export the physical drives to the midlayer (also it is dangerous).

Regards,

Bo Yang

-----Original Message-----
From: Joe Malicki [mailto:jmalicki@metacarta.com]
Sent: Tuesday, August 19, 2008 5:21 PM
To: DL-MegaRAID Linux; linux-poweredge; linux-scsi
Subject: megaraid_sas: Optionally add SCSI devices for individual disks in a raidset

This is very dangerous, and you shouldn't use it/apply it unless you're feeling adventurous.

This lets one, optionally, add /dev/sg* devices, and optionally also /dev/sd* devices, for disks in a RAIDset.  It is modeled after similar functionality in the aacraid driver.

I've been successfully using this to upgrade individual disk firmwares behind a Dell PERC RAID controller with sgdskfl from scsirastools - AFTER the RAID array has been stopped with other tools.

Use the kernel option "megaraid_sas.export_disks=-1" to get /dev/sg* devices.  Unless a specific option has been given, the patch doesn't modify behavior.

Note that the driver currently says (and has said for some time):

         * FIXME: Currently we don't export them to the midlayer at all.
         *        That will be fixed once LSI engineers have audited the
         *        firmware for possible issues.

So using this is certainly high risk and one should be careful.
(only signing off so others may feel free to use it, not encouraging this to go anywhere unless LSI feels it's safe)

Signed-off-by: jmalicki@metacarta.com

------------
--- linux-2.6.26.2-orig/drivers/scsi/megaraid/megaraid_sas.c    2008-08-06 12:19:01.000000000 -0400
+++ linux-2.6.26.2/drivers/scsi/megaraid/megaraid_sas.c 2008-08-19
+++ 17:12:02.000000000 -0400
@@ -46,6 +46,12 @@
 #include <scsi/scsi_host.h>
 #include "megaraid_sas.h"

+static int export_disks = 0;
+module_param(export_disks, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(export_disks, "Export physical disks to the SCSI midlayer (DANGEROUS)"
+       " -1=protect 0=off 1=on");
+
+
 /*
  * poll_mode_io:1- schedule complete completion from q cmd
  */
@@ -905,8 +911,12 @@
         *        That will be fixed once LSI engineers have audited the
         *        firmware for possible issues.
         */
-       if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
-               return -ENXIO;
+       if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type ==
+ TYPE_DISK)
{
+               if (export_disks < 0)
+                       sdev->no_uld_attach = 1;
+               else if (export_disks == 0)
+                       return -ENXIO;
+       }

        /*
         * The RAID firmware may require extended timeouts.
--------
