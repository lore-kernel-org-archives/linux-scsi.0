From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] g_NCR5380: Kill compiler warning if builtin
Date: Thu, 29 Jan 2015 17:57:29 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1501291551250.7510@nippy.intranet>
References: <1420322416-13960-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420322416-13960-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Sat, 3 Jan 2015, Geert Uytterhoeven wrote:

> If CONFIG_SCSI_GENERIC_NCR5380=y:
> 
> drivers/scsi/g_NCR5380.c:727: warning: ?id_table? defined but not used
> 
> In the non-modular case, MODULE_DEVICE_TABLE() expands to nothing, and
> id_table is not referenced.
> 
> Correct the existing #ifdef to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/scsi/g_NCR5380.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index f35792f7051c0884..74ec2f5669aba5f5 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -723,7 +723,7 @@ module_param(ncr_53c400a, int, 0);
>  module_param(dtc_3181e, int, 0);
>  MODULE_LICENSE("GPL");
>  
> -#ifndef SCSI_G_NCR5380_MEM
> +#if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
>  static struct isapnp_device_id id_table[] = {
>  	{
>  	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
> 
