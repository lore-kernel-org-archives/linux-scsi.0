From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] add help to WAIT_SCAN option
Date: Sat, 26 May 2007 17:03:07 -0600
Message-ID: <20070526230307.GN5798@parisc-linux.org>
References: <20070526191127.GB7080@colo.lackof.org> <20070526204447.GM5798@parisc-linux.org> <7d01f9f00705261525k56cd1b9ag531640cc212036ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36750 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXEZXDJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 May 2007 19:03:09 -0400
Content-Disposition: inline
In-Reply-To: <7d01f9f00705261525k56cd1b9ag531640cc212036ae@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thibaut VARENE <T-Bone@parisc-linux.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sun, May 27, 2007 at 12:25:22AM +0200, Thibaut VARENE wrote:
> My problem was that:
> - I use a standalone kernel (no init{rd,ramfs})
> - I have CONFIG_MODULES=y
> - I build all my (needed) scsi drivers 'y' (builtin)

> Yet CONFIG_SCSI_WAIT_SCAN defaults to 'm' with no possibility of
> setting it otherwise. So I ended up with a kernel with builtin async
> scsi scan and no wait_scan, thus not waiting for the probes to
> complete before trying to mount rootfs...

Thanks.  That's expected to work, as it's how I build my kernels too.
Looks like this got broken when other people were trying to fix the
modular case.  It *was* the case that scsi_wait_scan got built in to the
kernel if CONFIG_SCSI was =y.  But of course, that's no good for people
who build with CONFIG_SCSI=y and their driver =m -- they still have to
have a module to load.  And we shouldn't prompt the user for it, we
should determine the right thing to do.

Not even compile tested (but it's at least approximately what the
original async scanning patches used to do):

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
