From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Mark aha152x as ISA and !64BIT driver II
Date: Tue, 7 Oct 2003 20:26:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007182622.GA2368@averell>
References: <20031007173323.GA1607@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:53508 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262708AbTJGS0b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 14:26:31 -0400
Content-Disposition: inline
In-Reply-To: <20031007173323.GA1607@averell>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 07, 2003 at 07:33:23PM +0200, Andi Kleen wrote:
> 
> aha152x seems to be not 64bit safe and spews out warnings on x86-64. 
> As I think it's a ISA only driver anyways I just marked it as
> ISA only and !64BIT for Alpha's sake.


Matthew Wilcox pointed out that it was already marked ISA only.
I actually ment to change another driver, but looking at the source of one
it seems to be 64bit unclean too.

As there are 64bit architectures that have ISA slots (like old Alphas)
I think this patch is still appropiate.

-Andi
 
diff -u linux-2.5-cleanup/drivers/scsi/Kconfig-o linux-2.5-cleanup/drivers/scsi/Kconfig
--- linux-2.5-cleanup/drivers/scsi/Kconfig-o	2003-10-02 18:12:08.000000000 +0200
+++ linux-2.5-cleanup/drivers/scsi/Kconfig	2003-12-02 16:56:28.620210248 +0100
@@ -253,7 +253,7 @@
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && !64BIT
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
 	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
