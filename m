From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: 18 Jan 2004 09:54:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074437655.1804.12.camel@mulgrave>
References: <1074382860.1756.20.camel@mulgrave>
	<20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
	<20040118062157.GA11083@praka.local.home>  <20040118073321.GC383498@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44966 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261779AbUARO52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 09:57:28 -0500
In-Reply-To: <20040118073321.GC383498@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <praka@users.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, jes@sgi.com

On Sun, 2004-01-18 at 02:33, Jeremy Higdon wrote:
> James, with your code as it is now, ha->flags.enable_64bit_addressing
> is always 0.  You'd need to add code to read the value out of the
> nvram.  Then we'll need an nvram override for Altix.

Actually, I found it.  There was a missed endianness problem in the 64
bit path (see patch).

However, I have another question for you:  Does the card BIOS actually
get to run on bootup?  It doesn't (because it can't) on PA, so I get
strange values for certain NVRAM quantities (like the 32 bit mode, but
more importantly, the offset of all my devices gets set to 1).  I was
thinking about doing an override to set them more sensibly and wondered
if you were having the same problem.

James

===== drivers/scsi/qla1280.c 1.54 vs edited =====
--- 1.54/drivers/scsi/qla1280.c	Sat Jan 17 17:44:11 2004
+++ edited/drivers/scsi/qla1280.c	Sun Jan 18 08:47:42 2004
@@ -3332,7 +3336,7 @@
 #endif
 			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
 			*dword_ptr++ = cpu_to_le32(pci_dma_hi32(dma_handle));
-			*dword_ptr = (uint32_t)cmd->request_bufflen;
+			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
 
 			dprintk(5, "qla1280_64bit_start_scsi: No scatter/"
 				"gather command packet data - b %i, t %i, "

