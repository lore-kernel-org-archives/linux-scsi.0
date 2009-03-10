From: ib@wupperonline.de (Ingo Brueckl)
Subject: [PATCH] unnecessary SCSI module
Date: Tue, 10 Mar 2009 08:00:00 +0100
Message-ID: <49b60f4c@wupperonline.de>
References: <1236633029.6029.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tal.de ([81.92.1.5]:49350 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZCJHPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 03:15:22 -0400
In-Reply-To: <1236633029.6029.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> When configuring MODULES with the kernel to be able to load external
>> drivers coming as modules, but not using anything as module in the kernel
>> itself, one would expect to end up in a module-free kernel. Currently, you
>> don't if you use SCSI. You'll get one unnecessary module.

 > This isn't right because SCSI_SCAN_ASYNC only sets the *default*
 > behaviour of the kernel.  Even if it's n the user can still boot up with
 > async scans by setting the kernel parameter.

Ok, understood. But has it to be a module then? Why not giving the choice
between building it directly into the kernel or as a module?

 > It also keeps coming up regularly:

Well, then something doesn't seem to be ok, does it? ;-)

Ingo

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>

--- linux-2.6.28/drivers/scsi/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/scsi/Kconfig	2009-03-10 08:11:38.000000000 +0100
@@ -257,10 +257,14 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.

 config SCSI_WAIT_SCAN
-	tristate
-	default m
+	tristate "SCSI wait scanning"
 	depends on SCSI
 	depends on MODULES
+	help
+	  If you are using a SCSI module and do asynchronous SCSI scanning
+	  (either by having selected SCSI_SCAN_ASYNC or by specifying
+	  "scsi_mod.scan=async" on the kernel's command line), you MUST say Y
+	  here.

 menu "SCSI Transports"
 	depends on SCSI
