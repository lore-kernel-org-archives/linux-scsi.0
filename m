From: "Tony A. Lambley" <tal@vextech.net>
Subject: Re: growisofs stopped working with 2.6.8
Date: Mon, 16 Aug 2004 13:59:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092679156.2393.8.camel@bony>
References: <1092674287.3021.19.camel@bony>
	 <1092672062.20838.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 130.67-18-18.reverse.theplanet.com ([67.18.18.130]:16325 "EHLO
	server3.imagelinkusa.net") by vger.kernel.org with ESMTP
	id S267838AbUHPR7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 13:59:20 -0400
In-Reply-To: <1092672062.20838.29.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

It still fails, but I get a different message with the patch:

$ growisofs -Z /dev/dvd=file.iso
Executing 'builtin_dd if=file.iso of=/dev/dvd obs=32k seek=0'
:-( unable to PREVENT MEDIA REMOVAL: Operation not permitted

K3B fails with the same message as above.

As you say, it does indeed burn fine as root.


On Mon, 2004-08-16 at 12:01, Alan Cox wrote:
> On Llu, 2004-08-16 at 17:38, Tony A. Lambley wrote:
> > Hi, burning a dvd iso now fails :(
> > 
> > $ growisofs -Z /dev/hdc=file.iso
> > :-( unable to GET CONFIGURATION: Operation not permitted
> > :-( non-MMC unit?
> 
> We fixed some security holes. In doing so we tightened up so a few apps
> that worked before no longer work except as root. Thanks for the error
> message. Thats helpful as it suggests the following patch.
> 
> (and does it help K3B ?)
> 
> 
> 
> 
> 
> 
> ______________________________________________________________________
> --- drivers/block/scsi_ioctl.c~	2004-08-16 18:01:36.627301624 +0100
> +++ drivers/block/scsi_ioctl.c	2004-08-16 18:01:36.627301624 +0100
> @@ -146,6 +146,7 @@
>  		safe_for_read(GPCMD_READ_TOC_PMA_ATIP),
>  		safe_for_read(GPCMD_REPORT_KEY),
>  		safe_for_read(GPCMD_SCAN),
> +		safe_for_read(GPCMD_GET_CONFIGURATION),
>  
>  		/* Basic writing commands */
>  		safe_for_write(WRITE_6),

