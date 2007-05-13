From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 11:10:55 -0500
Message-ID: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34193 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757572AbXEMQLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2007 12:11:08 -0400
In-Reply-To: <20070513160608.GA29024@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, 2007-05-13 at 12:06 -0400, Dave Jones wrote:
> On Sun, May 13, 2007 at 11:22:55AM -0400, Robert P. J. Day wrote:
>  > 
>  >   not a big deal, but is there a reason that a "make defconfig" on my
>  > x86 system ends up selecting and building a single module?
>  > 
>  >   Building modules, stage 2.
>  >   MODPOST 1 modules
>  >   CC      drivers/scsi/scsi_wait_scan.mod.o
>  >   LD [M]  drivers/scsi/scsi_wait_scan.ko
>  > 
>  > is there something special about that module?  just curious.
> 
> My guess is that someone was paranoid and wanted not to have
> to answer a zillion "my machine won't boot any more" questions
> when async scsi scanning was added.
> This might further clarify..
> 
> ---
> 
> The scsi_wait_scan module is only really useful if async scanning
> is enabled.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index e62d23f..0f6c370 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
>  config SCSI_WAIT_SCAN
>  	tristate
>  	default m
> -	depends on SCSI
> +	depends on SCSI_SCAN_ASYNC

No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
wait scan to be built in, which isn't the idea at all.

James


