From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 1118] New: atp870u driver pegs the cpu 100%
 and never loads
Date: Sun, 17 Aug 2003 15:04:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030817150448.76057df9.akpm@osdl.org>
References: <200308170450.h7H4otH8028674@fire-1.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:62377 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271094AbTHQWDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2003 18:03:48 -0400
In-Reply-To: <200308170450.h7H4otH8028674@fire-1.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: zleite@mminternet.com
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

bugme-daemon@osdl.org wrote:
>
> http://bugme.osdl.org/show_bug.cgi?id=1118
> 
>            Summary: atp870u driver pegs the cpu 100% and never loads
>     Kernel Version: 2.6.0-test3
>             Status: NEW
>           Severity: blocking
>              Owner: andmike@us.ibm.com
>          Submitter: zleite@mminternet.com
> 
> 
> Distribution: RH9.0
> Hardware Environment:pentium4 1.8 ghz uniprocessor
> Software Environment: stardard RH
> Problem Description:can load driver for ACARD SCSI cards
> 
> Steps to reproduce:
> modprobe atp870u
> result: CPU use goes to 100% and module never loads.
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.

This fixes the lockup.  If you have the hardware, please retest
and send a report, thanks.  (I assume you don't, because having
the hardware prevents the lockup.  Oh well).



 drivers/scsi/atp870u.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/atp870u.c~atp870u_detect-lockup-fix drivers/scsi/atp870u.c
--- 25/drivers/scsi/atp870u.c~atp870u_detect-lockup-fix	2003-08-17 14:59:07.000000000 -0700
+++ 25-akpm/drivers/scsi/atp870u.c	2003-08-17 14:59:46.000000000 -0700
@@ -2304,9 +2304,7 @@ static int atp870u_detect(Scsi_Host_Temp
 	printk(KERN_INFO "aec671x_detect: \n");
 	tpnt->proc_name = "atp870u";
 
-	h = 0;
-	while (devid[h] != 0)
-	{
+	for (h = 0; devid[h]; h++) {
 		struct pci_dev *dev = NULL;
 		
 		while((dev = pci_find_device(0x1191, devid[h], dev))!=NULL)

_

