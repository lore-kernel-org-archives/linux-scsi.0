From: Dave Jones <davej@redhat.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 12:06:08 -0400
Message-ID: <20070513160608.GA29024@redhat.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbXEMQGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 12:06:16 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, May 13, 2007 at 11:22:55AM -0400, Robert P. J. Day wrote:
 > 
 >   not a big deal, but is there a reason that a "make defconfig" on my
 > x86 system ends up selecting and building a single module?
 > 
 >   Building modules, stage 2.
 >   MODPOST 1 modules
 >   CC      drivers/scsi/scsi_wait_scan.mod.o
 >   LD [M]  drivers/scsi/scsi_wait_scan.ko
 > 
 > is there something special about that module?  just curious.

My guess is that someone was paranoid and wanted not to have
to answer a zillion "my machine won't boot any more" questions
when async scsi scanning was added.
This might further clarify..

---

The scsi_wait_scan module is only really useful if async scanning
is enabled.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e62d23f..0f6c370 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
 config SCSI_WAIT_SCAN
 	tristate
 	default m
-	depends on SCSI
+	depends on SCSI_SCAN_ASYNC
 	depends on MODULES
 
 menu "SCSI Transports"



-- 
http://www.codemonkey.org.uk
