From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: build #436 warning for v2.6.25-rc6-117-g457fb60 in
	drivers/scsi/
Date: Thu, 20 Mar 2008 10:13:10 -0500
Message-ID: <1206025990.3038.22.camel@localhost.localdomain>
References: <200803201024.42729.toralf.foerster@gmx.de>
	 <4D5B18F8-8481-46FA-81A8-ABC6388F088D@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45250 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791AbYCTPNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 11:13:13 -0400
In-Reply-To: <4D5B18F8-8481-46FA-81A8-ABC6388F088D@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2008-03-20 at 10:05 -0400, Mark Salyzyn wrote:
> This is more a Linux Module design issue than a driver bug.
> 
> For instance, dpt_i2o.c has the following fragment:
> 
> static struct pci_device_id dptids[] = {
>          { PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID,  
> PCI_ANY_ID,},
>          { PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID,  
> PCI_ANY_ID,},
>          { 0, }
> };
> MODULE_DEVICE_TABLE(pci,dptids);
> 
> which kind of depends on MODULE_DEVICE_TABLE doing its job. But you  
> are compiling the driver into the kernel rather than as a module and  
> the net result is the warning message.
> 
> MODULE_DEVICE_TABLE, in drivers compiled as build-in to the kernel  
> needs to 'use' it's arguments in some manner that
> a) suppresses the warning
> b) does not take up any space
> 
> Or one could add an #ifndef CONFIG_SCSI_DPT_I2O wrapped around the  
> above to suppress the warning...<ick>

Yes, very ick.  Try this ... it should force a discarded reference even
in the non-modular case.

James

---

diff --git a/include/linux/module.h b/include/linux/module.h
index 819c4e8..838c63d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -84,7 +84,7 @@ extern const struct gtype##_id __mod_##gtype##_table		\
 extern struct module __this_module;
 #define THIS_MODULE (&__this_module)
 #else  /* !MODULE */
-#define MODULE_GENERIC_TABLE(gtype,name)
+#define MODULE_GENERIC_TABLE(gtype,name)	((void)name)
 #define THIS_MODULE ((struct module *)0)
 #endif
 


