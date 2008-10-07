From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: aacraid: Adaptec 2200S support broken on x86_64 by commit 94cf6ba11b068b8a8f68a1e88bffb6827e92124b
Date: Tue, 07 Oct 2008 15:37:04 +0200
Message-ID: <48EB6600.9020204@redhat.com>
References: <48D10E1A.8030804@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYJGNhJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 09:37:09 -0400
In-Reply-To: <48D10E1A.8030804@siemens.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Hillier, Gernot" <gernot.hillier@siemens.com>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mark_salyzyn@adaptec.com

Hillier, Gernot wrote:
> Hi there!
>
> On our AMD64 machines equipped with old Adaptec 2200S controllers, we
> experienced a regression when updating to 2.6.25. The machines won't
> boot anymore (in a reasonable time), but instead spit out tons of those
> messages:
> aac_srb: aac_fib_send failed with status: 8195
>
> This is already reported in quite some places including LKML:
> http://lkml.org/lkml/2008/5/12/365
> https://bugzilla.redhat.com/show_bug.cgi?id=450444
> https://bugzilla.redhat.com/show_bug.cgi?id=453472
> http://www.linuxquestions.org/questions/red-hat-31/aacsrb-aacfibsend-failed-with-status-8195-651078/
> http://forums.gentoo.org/viewtopic-p-5077382.html?sid=a51c3a0fba6aa854c0b49b8fae5cc15a
>
> We found that this regression seems to be introduced by the bugfix
> "aacraid: fix driver failure with Dell PowerEdge
> Expandable RAID Controller 3/Di":
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94cf6ba11b068b8a8f68a1e88bffb6827e92124b
>
> By simply removing the quirk flag for our controller, we could boot again.
>
> We did some quick stress tests on an AMD64bit machine with 16GB of RAM 
> and saw no problems after this change:
>
> diff -ur linux-2.6.25.11-0.1.ct1.orig/drivers/scsi/aacraid/linit.c linux-2.6.25.11-0.1.ct1/drivers/scsi/aacraid/linit.c
> --- linux-2.6.25.11-0.1.ct1.orig/drivers/scsi/aacraid/linit.c	2008-09-15 16:07:14.000000000 +0100
> +++ linux-2.6.25.11-0.1.ct1/drivers/scsi/aacraid/linit.c	2008-09-15 16:09:26.000000000 +0100
> @@ -176,7 +176,7 @@
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
> -	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
> +	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Adaptec 2200S (Vulcan) */
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
>  	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
>  	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */
>
> Can this be safely changed/merged? Or is this the wrong way to fix it?
>
> Please note that we also have machines equipped with newer Adaptec 2230S
> controllers (PCI ID 9005:0286) which run perfectly with the current driver.
>
>   
Hi,
from what I read about this it seems to me that people are complaining also about issues with the 2120S Controller.
So if the patch is taken in this form the original patch should be extended to cover both controllers.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

---
diff -Naurp linux-2.6.18.i686b/drivers/scsi/aacraid/linit.c linux-2.6.18.i686p6/drivers/scsi/aacraid/linit.c
--- linux-2.6.18.i686b/drivers/scsi/aacraid/linit.c	2008-09-25 18:06:23.000000000 +0200
+++ linux-2.6.18.i686p6/drivers/scsi/aacraid/linit.c	2008-10-03 12:12:06.000000000 +0200
@@ -175,8 +175,8 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2200S (Vulcan) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */



