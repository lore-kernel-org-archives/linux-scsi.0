From: "Kai OM" <epimetreus@fastmail.fm>
Subject: Re: Bug: SCSI driver hangs in 2.6.6 and 2.6.7
Date: Tue, 29 Jun 2004 21:54:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088560481.30217.199438553@webmail.messagingengine.com>
References: <7411.1088552814@www56.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:63451 "EHLO
	out2.smtp.messagingengine.com") by vger.kernel.org with ESMTP
	id S266188AbUF3Byn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 21:54:43 -0400
Content-Disposition: inline
In-Reply-To: <7411.1088552814@www56.gmx.net>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Greve <thomas.greve@gmx.de>
Cc: linux-scsi@vger.kernel.org

The particular issue I'm having appears not to be a compiler issue; it's
happened when compiled using several versions of GCC, unless it's a
problem occuring in a range of versions of GCC.

My drive should be running in 32 bit synch, as well, but the newer
driver seems to force it into asynch.

I can't infer a lot about this issue, since I'm not a programmer or SCSI
expert, but I can observe and correlate.

Another person I know of has this issue as well, appended are links to
some log files of his.

http://ronmon.shacknet.nu/configs/scsi_boot_error

http://ronmon.shacknet.nu/configs/dmesg_good-2.6.7-rc3

http://ronmon.shacknet.nu/phpsysinfo/

http://ronmon.shacknet.nu/configs/lspci-vvx

----- Original message -----
From: "Thomas Greve" <thomas.greve@gmx.de>
To: "Kai OM" <epimetreus@fastmail.fm>
Date: Wed, 30 Jun 2004 01:46:54 +0200 (MEST)
Subject: Bug: SCSI driver hangs in 2.6.6 and 2.6.7

Hi Kai.

I encountered the same problem here, the kernel being caught in an
endless
loop during domain validation in scsi_transport_spi.c:spi_dv_retrain().

Interesting enough, this happens only while validating the 2nd of my two
hard disks (IBM DPSS-318350N on a Dawi Control sym80c875 host adapter).

The mm patches seem to contain a fix for this; since i did not get any
"dropping back" error messages after patching the file, this might as
well
be an optimisation problem with gcc 3.3.3.

After applying that patch, i got my kernel booting again, but the driver
reports / configures the hard disk as "asynchronous", what i suspect
might
be an unnecessary bottle neck:

<6>scsi(0:0:2:0): Beginning Domain Validation
<6>sym0:2: wide asynchronous.
<6>sym0:2: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
<6>scsi(0:0:2:0): Ending Domain Validation

Hope this helps,

-- 
- Thomas

