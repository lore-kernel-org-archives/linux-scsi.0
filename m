From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 11:48:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718114804.A22815@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0598B10@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:15375 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S270201AbTGRKdJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 06:33:09 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598B10@AVEXCH02.qlogic.org>; from andrew.vasquez@qlogic.com on Thu, Jul 17, 2003 at 04:40:00PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Thu, Jul 17, 2003 at 04:40:00PM -0700, Andrew Vasquez wrote:
> Finally, regarding some of the more interesting (if not the) question(s)
> pertaining to the development of qla2xxx:
> 
>   o Creation of a single driver module rather than three distinct
> 	drivers for each ISP type (21xx, 22xx, and 23xx).
> 
>   From the technical side, there aren't many compelling reasons for
>   the change to not occur.  Support for 2k logins on 2300s did
>   introduce a rather large, but manageable (through the compile-time
>   preprocessor), interface change between the host driver and
>   firmware.  The driver could of course manage this during run-time
>   with some creative structure overlays, etc.  Secondly, bundling
>   firmware for all ISP types can lead to a rather large binary
>   module (21xx - ~64kbytes, 22xx - ~90kbytes, 23xx - ~110kbytes).

Well, support for each of the subtypes can be conditional or even
in their own submodules that share a common "library" module.

>   Unfortunately, it is support that ultimately becomes the
>   overriding factor in maintaining the three-module build process.

Well, the current build process is horrible :)

>   By building distinct modules (i.e. qla2300.ko to support ISP2300,
>   ISP2312, and ISP2322 chips) our DVT group would focus their time and
>   efforts on testing 23xx HBAs and not on regressing support with
>   EOL'd products.

Why can't you declare the others unsupported even if they are in
the same module? You'd have three config option for including support
for each specific chip type and two of them would be marked unsupported.

> Until a policy change, the 8.x driver in its current form will have
> the limitation of only one driver, qla2100, qla2200, or qla2300, can
> be built as part of the kernel at any given time.

This is not acceptable for a driver in mainline, just FYI.

