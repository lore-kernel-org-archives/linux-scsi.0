From: Christoph Hellwig <hch@infradead.org>
Subject: Re: megaraid /proc under kernel 2.6.2
Date: Mon, 16 Feb 2004 09:59:01 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040216095901.A13715@infradead.org>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:47111 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264506AbUBPJ7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 04:59:02 -0500
Content-Disposition: inline
In-Reply-To: <1076884890.2943.265.camel@morsel.kungfoocoder.org>; from paul@kungfoocoder.org on Sun, Feb 15, 2004 at 11:41:31PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Paul Wagland <paul@kungfoocoder.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

On Sun, Feb 15, 2004 at 11:41:31PM +0100, Paul Wagland wrote:
> partitions in use, one which is used for swap, one for /boot and one for
> a device mapper PV, even though my system is running, and using all
> three devices, the usage count on the megaraid driver is still 0, and I
> can rmmod the module, although doing so brings up:
> 
> tidbit kernel: journal-601, buffer write failed
> 
> which is, I assume, reiserfs bitching about the fact that it's backing
> device has just totally disappeared, and as soon as I try to do anything
> that wants read access to the disk, that program will freeze, but that
> is only to be expected. What is not expected is that I can remove a
> device that is in use...
> 
> Does anyone know what is going on? I am investigating further, but I
> thought that I would throw this out so that people might be able to tell
> me where to look...

megaraid doesn't set the moduler owner for the host_template.  Fix is below.

I don't have the lsightest idea about the procfs issue, though (and no
megaraid card neraby to test)

===== drivers/scsi/megaraid.c 1.59 vs edited =====
--- 1.59/drivers/scsi/megaraid.c	Fri Jan 23 06:37:03 2004
+++ edited/drivers/scsi/megaraid.c	Sun Feb 15 00:52:51 2004
@@ -4614,6 +4614,7 @@
 }
 
 static struct scsi_host_template megaraid_template = {
+	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
 	.proc_name			= "megaraid",
 	.info				= megaraid_info,
