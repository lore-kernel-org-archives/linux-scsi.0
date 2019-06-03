From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH] scsi: ibmvscsi: Don't use rc uninitialized in
 ibmvscsi_do_work
Date: Mon, 3 Jun 2019 10:45:24 +0200
Message-ID: <d932b755-606e-6847-a460-da463411c562@c-s.fr>
References: <20190531185306.41290-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531185306.41290-1-natechancellor@gmail.com>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: clang-built-linux@googlegroups.com, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Le 31/05/2019 à 20:53, Nathan Chancellor a écrit :
> clang warns:
> 
> drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
> uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
>          case IBMVSCSI_HOST_ACTION_NONE:
>               ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ibmvscsi/ibmvscsi.c:2151:6: note: uninitialized use occurs
> here
>          if (rc) {
>              ^~
> 
> Initialize rc to zero so that the atomic_set and dev_err statement don't
> trigger for the cases that just break.
> 
> Fixes: 035a3c4046b5 ("scsi: ibmvscsi: redo driver work thread to use enum action states")
> Link: https://github.com/ClangBuiltLinux/linux/issues/502
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 727c31dc11a0..6714d8043e62 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -2118,7 +2118,7 @@ static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
>   static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
>   {
>   	unsigned long flags;
> -	int rc;
> +	int rc = 0;

I don't think the above is the best solution, as it hides the warning 
instead of really fixing it.

Your problem is that some legs of the switch are missing setting the 
value of rc, it would therefore be better to fix the legs instead of 
setting a default value which may not be correct for every case, 
allthough it may be at the time being.

Christophe


>   	char *action = "reset";
>   
>   	spin_lock_irqsave(hostdata->host->host_lock, flags);
> 
