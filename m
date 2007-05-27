From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 18:05:20 -0600
Message-ID: <20070527000520.GQ5798@parisc-linux.org>
References: <20070526191127.GB7080@colo.lackof.org> <20070526204447.GM5798@parisc-linux.org> <7d01f9f00705261525k56cd1b9ag531640cc212036ae@mail.gmail.com> <20070526230307.GN5798@parisc-linux.org> <7d01f9f00705261610q7d2d8bf8m777362802f8eb090@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48723 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXE0AFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 20:05:23 -0400
Content-Disposition: inline
In-Reply-To: <7d01f9f00705261610q7d2d8bf8m777362802f8eb090@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thibaut VARENE <T-Bone@parisc-linux.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, May 27, 2007 at 01:10:36AM +0200, Thibaut VARENE wrote:
> >diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> 
> Works For Me (tm)

Great, thanks!

James, can you put this patch into your tree?

-----

When all scsi drivers are built-in, we need to automatically call
scsi_complete_async_scans before we need to find the root filesystem.
This used to be done by compiling scsi_wait_scan into the kernel, but
that doesn't work when some scsi drivers are modular.  Instead, just add
a late_initcall() when the SCSI subsystem is built-in.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a67f315..2653a06 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -184,6 +184,11 @@ int scsi_complete_async_scans(void)
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
 
+/* If everything's built in, we need to wait for everything to scan */
+#ifndef MODULE
+late_initcall(scsi_complete_async_scans);
+#endif
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
