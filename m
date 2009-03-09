From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] unnecessary SCSI module
Date: Mon, 09 Mar 2009 21:10:29 +0000
Message-ID: <1236633029.6029.1.camel@localhost.localdomain>
References: <49b5689f@wupperonline.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50818 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbZCIVKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 17:10:34 -0400
In-Reply-To: <49b5689f@wupperonline.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Brueckl <ib@wupperonline.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2009-03-09 at 20:06 +0100, Ingo Brueckl wrote:
> When configuring MODULES with the kernel to be able to load external drivers
> coming as modules, but not using anything as module in the kernel itself, one
> would expect to end up in a module-free kernel. Currently, you don't if you
> use SCSI. You'll get one unnecessary module.
> 
> Please consider the attached patch.
> 
> Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
> 
> --- linux-2.6.28/drivers/scsi/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.28/drivers/scsi/Kconfig	2009-03-06 22:49:40.000000000 +0100
> @@ -259,7 +259,7 @@ config SCSI_SCAN_ASYNC
>  config SCSI_WAIT_SCAN
>  	tristate
>  	default m
> -	depends on SCSI
> +	depends on SCSI = m || SCSI_SCAN_ASYNC = y

This isn't right because SCSI_SCAN_ASYNC only sets the *default*
behaviour of the kernel.  Even if it's n the user can still boot up with
async scans by setting the kernel parameter.

It also keeps coming up regularly:

http://marc.info/?t=122658550300002

James


