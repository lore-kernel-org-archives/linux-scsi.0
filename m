From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.20-rc3: known unfixed regressions (v3)
Date: Thu, 4 Jan 2007 11:13:27 -0700
Message-ID: <20070104181327.GF24620@parisc-linux.org>
References: <Pine.LNX.4.64.0612311710430.4473@woody.osdl.org> <20070104174632.GC20714@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965057AbXADSNr@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070104174632.GC20714@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 04, 2007 at 06:46:32PM +0100, Adrian Bunk wrote:
> Subject    : SPARC64: Can't mount /  (CONFIG_SCSI_SCAN_ASYNC=y ?)
> References : http://lkml.org/lkml/2006/12/13/181
>              http://lkml.org/lkml/2007/01/04/75
> Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
> Status     : unknown

It'd be nice if people bothered to cc authors on bug reports, eh?

It seems to me that you're building scsi as modules.  In which case
you need to follow the instructions in the help text to load the
scsi_wait_scan module.  Or just say 'n' to the CONFIG_SCSI_SCAN_ASYNC
option, of course.

You're right that the quotes need to disappear from the Kconfig help
text as they're just confusing.

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 60f5827..103d0da 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -230,6 +230,7 @@ config SCSI_SCAN_ASYNC
 	  The SCSI subsystem can probe for devices while the rest of the
 	  system continues booting, and even probe devices on different
 	  busses in parallel, leading to a significant speed-up.
+
 	  If you have built SCSI as modules, enabling this option can
 	  be a problem as the devices may not have been found by the
 	  time your system expects them to have been.  You can load the
@@ -237,8 +238,8 @@ config SCSI_SCAN_ASYNC
 	  If you build your SCSI drivers into the kernel, then everything
 	  will work fine if you say Y here.
 
-	  You can override this choice by specifying scsi_mod.scan="sync"
-	  or "async" on the kernel's command line.
+	  You can override this choice by specifying "scsi_mod.scan=sync"
+	  or async on the kernel's command line.
 
 menu "SCSI Transports"
 	depends on SCSI
