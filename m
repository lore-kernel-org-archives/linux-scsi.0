From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Add compat_ioctl to scsi host structure
Date: 19 Jan 2005 17:03:10 +0100
Message-ID: <20050119160310.GB71623@muc.de>
References: <20050118110354.GB43344@muc.de> <1106062536.5151.2.camel@mulgrave> <20050118232745.GA66256@muc.de> <1106150101.5150.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:54532 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261761AbVASQDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 11:03:12 -0500
Date: Wed, 19 Jan 2005 17:03:10 +0100
Content-Disposition: inline
In-Reply-To: <1106150101.5150.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jan 19, 2005 at 07:55:01AM -0800, James Bottomley wrote:
> On Wed, 2005-01-19 at 00:27 +0100, Andi Kleen wrote:
> > On Tue, Jan 18, 2005 at 07:35:36AM -0800, James Bottomley wrote:
> > > Shouldn't this also be surrounded by #ifdef CONFIG_COMPAT (on the
> > > grounds that you never fill it in unless CONFIG_COMPAT is defined)?
> > 
> > At least the standard file_operations has it without ifdef. 
> > I guess it doesn't hurt too much even on non compat systems.
> 
> Well, I wasn't really thinking of saving the four or eight bytes for the
> pointer:  It looks, from all the other patches, that the policy is that
> any compat ioctl code should be surrounded by #ifdef CONFIG_COMPAT.
> Thus, an easy way to enforce this policy is to do the same to the
> structure definition, so the compiler will error if the driver writer
> doesn't do it and tries to compile on a non-CONFIG_COMPAT platform.

Here's a new patch with the ifdef.


Add compat_ioctl vector to scsi_host.

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h-o linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h
--- linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h-o	2005-01-14 10:12:26.000000000 +0100
+++ linux-2.6.11-rc1-bk4/include/scsi/scsi_host.h	2005-01-19 17:01:21.000000000 +0100
@@ -71,7 +71,18 @@
 	 * Status: OPTIONAL
 	 */
 	int (* ioctl)(struct scsi_device *dev, int cmd, void __user *arg);
-	
+
+
+#ifdef CONFIG_COMPAT
+	/* 
+	 * Compat handler. Handle 32bit ABI.
+	 * When unknown ioctl is passed return -ENOIOCTLCMD.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* compat_ioctl)(struct scsi_device *dev, int cmd, void __user *arg);
+#endif
+
 	/*
 	 * The queuecommand function is used to queue up a scsi
 	 * command block to the LLDD.  When the driver finished
diff -u linux-2.6.11-rc1-bk4/include/scsi/scsi_ioctl.h-o linux-2.6.11-rc1-bk4/include/scsi/scsi_ioctl.h
