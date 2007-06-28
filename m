From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6-mm1: multiple definition of `check_reset'
Date: Thu, 28 Jun 2007 13:01:02 -0700
Message-ID: <20070628130102.ef6e7d12.akpm@linux-foundation.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628192950.GT1094@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765327AbXF1UBn@vger.kernel.org>
In-Reply-To: <20070628192950.GT1094@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Mark Salyzyn <aacraid@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
List-Id: linux-scsi@vger.kernel.org

On Thu, 28 Jun 2007 21:29:50 +0200
Adrian Bunk <bunk@stusta.de> wrote:

>  LD      drivers/built-in.o
> drivers/isdn/built-in.o: In function `check_reset': (.text+0xab974):
> multiple definition of `check_reset'
> drivers/scsi/built-in.o:(.data+0xdba8): first defined here
> ld: Warning: size of symbol `check_reset' changed from 4 in drivers/scsi/built-in.o to 214 in drivers/isdn/built-in.o
> ld: Warning: type of symbol `check_reset' changed from 1 to 2 in drivers/isdn/built-in.o

check_reset wasn't a great choice of identifier...


diff -puN drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/aachba.c
@@ -177,9 +177,9 @@ int check_interval = 24 * 60 * 60;
 module_param(check_interval, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(check_interval, "Interval in seconds between adapter health checks.");
 
-int check_reset = 1;
-module_param(check_reset, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(check_reset, "If adapter fails health check, reset the adapter.");
+int aacraid_check_reset = 1;
+module_param_named(check_reset, aacraid_check_reset, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(aacraid_check_reset, "If adapter fails health check, reset the adapter.");
 
 int expose_physicals = -1;
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
@@ -1211,7 +1211,7 @@ int aac_get_adapter_info(struct aac_dev*
 			  (int)sizeof(dev->supplement_adapter_info.VpdInfo.Tsid),
 			  dev->supplement_adapter_info.VpdInfo.Tsid);
 		}
-		if (!check_reset ||
+		if (!aacraid_check_reset ||
 		  (dev->supplement_adapter_info.SupportedOptions2 &
 		  le32_to_cpu(AAC_OPTION_IGNORE_RESET))) {
 			printk(KERN_INFO "%s%d: Reset Adapter Ignored\n",
diff -puN drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1857,4 +1857,4 @@ extern int aac_reset_devices;
 extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
-extern int check_reset;
+extern int aacraid_check_reset;
diff -puN drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~aacraid-rename-check_reset
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1370,8 +1370,9 @@ int aac_check_health(struct aac_dev * aa
 
 	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
 
-	if (!check_reset || (aac->supplement_adapter_info.SupportedOptions2 &
-	  le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
+	if (!aacraid_check_reset ||
+		(aac->supplement_adapter_info.SupportedOptions2 &
+			le32_to_cpu(AAC_OPTION_IGNORE_RESET)))
 		goto out;
 	host = aac->scsi_host_ptr;
 	if (aac->thread->pid != current->pid)
_
