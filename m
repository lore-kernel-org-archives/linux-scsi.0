From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [patch v2] [SCSI] qla2xxx: fix incorrect debug printk
Date: Mon, 5 May 2014 14:52:52 -0400
Message-ID: <alpine.WNT.2.00.1405051452020.4964@N5102REMCQXM4BS.qlogic.org>
References: <20140505094757.GA22383@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140505094757.GA22383@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Mon, 5 May 2014, Dan Carpenter wrote:

> There are missing curly braces here so it prints that the recovery
> failed even when it succeeded.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: version 1 patch was corrupted in sending somehow.
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index afc8481..00754a2 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4913,12 +4913,13 @@ qla2x00_do_dpc(void *data)
> 				if (qlafx00_reset_initialize(base_vha)) {
> 					/* Failed. Abort isp later. */
> 					if (!test_bit(UNLOADING,
> -					    &base_vha->dpc_flags))
> +					    &base_vha->dpc_flags)) {
> 						set_bit(ISP_UNRECOVERABLE,
> 						    &base_vha->dpc_flags);
> 						ql_dbg(ql_dbg_dpc, base_vha,
> 						    0x4021,
> 						    "Reset Recovery Failed\n");
> +					}
> 				}
> 			}
>
>

Looks good. Thanks.

Reviewed-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
