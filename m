From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: Sat, 17 Jan 2004 23:33:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118073321.GC383498@sgi.com>
References: <1074382860.1756.20.camel@mulgrave> <20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave> <20040118062157.GA11083@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:36783 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S266249AbUARHeP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 02:34:15 -0500
Content-Disposition: inline
In-Reply-To: <20040118062157.GA11083@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: jes@sgi.com

On Sat, Jan 17, 2004 at 10:21:57PM -0800, Andrew Vasquez wrote:
> 
> Jeremy:  have you had any problems with running I/O down the 64bit
> capable IOCB path?
> 
> --
> Andrew

No problems.  But then our Linux boxes are little endian.  We have
an ISP12160 on every one built so far, with no NVRAM.


James, with your code as it is now, ha->flags.enable_64bit_addressing
is always 0.  You'd need to add code to read the value out of the
nvram.  Then we'll need an nvram override for Altix.

Here's a patch to James's patch.  Yes, it has more nasty #ifdefs.  I
think there is probably a better way, but it's late  :-)

I'll let Jes continue with this, as I'll be away until next Friday.

thanks

jeremy

--- drivers/scsi/qla1280.c.bak	Sat Jan 17 23:22:54 2004
+++ drivers/scsi/qla1280.c	Sat Jan 17 23:22:59 2004
@@ -2935,6 +2935,15 @@
 	ha->flags.disable_risc_code_load =
 		nv->cntr_flags_1.disable_loading_risc_code;
 
+	/* Get NVRAM value from firmware */
+	ha->flags.enable_64bit_addressing =
+		nv->cntr_flags_1.enable_64bit_addressing;
+#if defined(CONFIG_IA64_GENERIC) || defined (CONFIG_IA64_SGI_SN2)
+	/* SN2 needs 64 bit */
+	if (ia64_platform_is("sn2"))
+		ha->flags.enable_64bit_addressing = 1;
+#endif
+
 	if (ha->flags.enable_64bit_addressing) {
 		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
 			ha->host_no);
