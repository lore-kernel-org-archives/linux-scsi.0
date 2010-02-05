From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] obsolete config in kernel source (BUFFER_DEBUG)
Date: Fri, 05 Feb 2010 09:18:07 -0600
Message-ID: <1265383087.14404.35.camel@mulgrave.site>
References: <20100205133500.GC6874@faui49.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100205133500.GC6874@faui49.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: oliver@neukum.name, aliakc@web.de, lenehan@twibble.org, u.kleine-koenig@pengutronix.de, jkosina@suse.cz, dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-02-05 at 14:35 +0100, Christoph Egger wrote:
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	This is another example of a block of code, here since ever
> and never compiled in modern history. Couldn't find out much more
> about it but as it can't be set for ages it might be wise to just
> remove it right now?

To be honest, not really unless the person maintaining the driver
agrees.  The reason for not doing this to obsolete drivers is that
although in theory git will remember it, trying to find a lost block of
code in git is time consuming and you often have to know where to look
for it.  Secondly, the code might be relevant to someone actually
needing to fix or use the driver.  Sometimes the code in non compiled
blocks can give valuable insights into how the driver actually worked.

Often, for dead code we don't quite know what to do with, we surround it
with #if 0/#endif blocks to make it quite clear it's not compiled, but
for nonexistent config options, that's not really necessary.

> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
> 
> Regards
> 
> 	Christoph Egger
> 
> [0] http://vamos1.informatik.uni-erlangen.de/
> 
> ----
> From 5cb8acd3f6939c617d6f28bd3eabb276c443c34e Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Date: Fri, 5 Feb 2010 13:39:33 +0100
> Subject: [PATCH] Remove config SCSI_DC395x_TRMS1040_TRADMAP
> 
> There's exactly one in source-check for SCSI_DC395x_TRMS1040_TRADMAP
> imported with the first git revision and no corresponding KConfig Item
> ever. Removing this single left-over block from the kernel config.
> 
> Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> ---
>  drivers/scsi/dc395x.c |   22 ----------------------
>  1 files changed, 0 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 6c59c02..7b3d0d3 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -1160,29 +1160,7 @@ complete:
>  static int dc395x_bios_param(struct scsi_device *sdev,
>  		struct block_device *bdev, sector_t capacity, int *info)
>  {
> -#ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
> -	int heads, sectors, cylinders;
> -	struct AdapterCtlBlk *acb;
> -	int size = capacity;
> -
> -	dprintkdbg(DBG_0, "dc395x_bios_param..............\n");
> -	acb = (struct AdapterCtlBlk *)sdev->host->hostdata;
> -	heads = 64;
> -	sectors = 32;
> -	cylinders = size / (heads * sectors);
> -
> -	if ((acb->gmode2 & NAC_GREATER_1G) && (cylinders > 1024)) {
> -		heads = 255;
> -		sectors = 63;
> -		cylinders = size / (heads * sectors);
> -	}
> -	geom[0] = heads;
> -	geom[1] = sectors;
> -	geom[2] = cylinders;
> -	return 0;

So this looks like a standard bios remapping for something ... I'd guess
a traditional mapping flag for the TekRam 1040.  Someone would likely
have to dig into history to find out what it was originally for and why
it's still here.

James
