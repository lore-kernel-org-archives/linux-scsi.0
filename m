From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx: remove the unused tcm_qla2xxx_cmd_wq
Date: Wed, 02 May 2018 17:04:07 -0400
Message-ID: <1525295047.30573.1.camel@redhat.com>
References: <20180502203113.13183-1-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502203113.13183-1-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@openvz.org>, qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-05-02 at 13:31 -0700, Andrei Vagin wrote:
> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index aadfeaac3898..b63440fec18e 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -48,7 +48,6 @@
>  #include "tcm_qla2xxx.h"
>  
>  static struct workqueue_struct *tcm_qla2xxx_free_wq;
> -static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
>  
>  /*
>   * Parse WWN.
> @@ -1976,16 +1975,8 @@ static int tcm_qla2xxx_register_configfs(void)
>  		goto out_fabric_npiv;
>  	}
>  
> -	tcm_qla2xxx_cmd_wq = alloc_workqueue("tcm_qla2xxx_cmd", 0,
> 0);
> -	if (!tcm_qla2xxx_cmd_wq) {
> -		ret = -ENOMEM;
> -		goto out_free_wq;
> -	}
> -
>  	return 0;
>  
> -out_free_wq:
> -	destroy_workqueue(tcm_qla2xxx_free_wq);
>  out_fabric_npiv:
>  	target_unregister_template(&tcm_qla2xxx_npiv_ops);
>  out_fabric:
> @@ -1995,7 +1986,6 @@ static int tcm_qla2xxx_register_configfs(void)
>  
>  static void tcm_qla2xxx_deregister_configfs(void)
>  {
> -	destroy_workqueue(tcm_qla2xxx_cmd_wq);
>  	destroy_workqueue(tcm_qla2xxx_free_wq);
>  
>  	target_unregister_template(&tcm_qla2xxx_ops);
When I first saw this I thought, no way, it must be used, but when I
had a closer look and checked its indeed not used or even made
external.

This looks OK to me.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
