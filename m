From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Mon, 24 Oct 2011 15:42:29 -0700
Message-ID: <1319496149.2094.3.camel@Joe-Laptop>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
> The first argument to kmalloc() is the size, the second is
> flags. pmcraid_chr_ioctl() gets this wrong and swaps the
> arguments. This patch corrects the mistake.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/scsi/pmcraid.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
>  compile tested only.
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index d079f9a..da19bdf 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
>  	struct pmcraid_ioctl_header *hdr = NULL;
>  	int retval = -ENOTTY;
>  
> -	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
> +	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
>  
>  	if (!hdr) {
>  		pmcraid_err("faile to allocate memory for ioctl header\n");
> -- 
> 1.7.7
> 
> 

James seems to be uninterested in picking up
obvious and trivially correct patches.

>From a year ago...

https://lkml.org/lkml/2010/10/31/123

James?
