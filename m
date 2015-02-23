From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 3/3] SCSI-debug: Fix exception handling for an alignment/granularity
 mismatch in scsi_debug_init()
Date: Mon, 23 Feb 2015 13:15:02 -0500
Message-ID: <54EB6E26.6090209@interlog.com>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54D4F7DF.8070008@users.sourceforge.net> <54D4F952.5070206@users.sourceforge.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D4F952.5070206@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On 15-02-06 12:26 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 6 Feb 2015 17:57:32 +0100
>
> The scsi_debug_init() function returned directly if the data items "alignment"
> and "granularity" did not fit together.
>
> Let us improve the affected exception handling by replacing the return
> statement by a goto statement so that previously allocated resources will also
> be appropriately released.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 756b7be..2c78663 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4909,7 +4909,8 @@ static int __init scsi_debug_init(void)
>   		    scsi_debug_unmap_alignment) {
>   			pr_err("%s: ERR: unmap_granularity <= unmap_alignment\n",
>   			       __func__);
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto free_dif;
>   		}
>
>   		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
>
