From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Date: Thu, 30 Oct 2014 11:25:17 +0530
Message-ID: <20141030055517.GC3519@sudip-PC>
References: <1414595704-3119-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1414595704-3119-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 29, 2014 at 04:15:04PM +0100, Fabian Frederick wrote:
> Fix -Wunused-but-set-variable warning

you should also mention why you have left the call to irq_set_affinity_hint().
i am not sure , but it looks like irq_set_affinity_hint() is only checking if
the lock is available or not. It is just locking ,then if lock is successfull then
returning 0 or if lock fails then return -EINVAL, and unlocks before returnig.
not doing anything else.

thanks
sudip

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/scsi/hpsa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index cef5d49..34330e1 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6619,11 +6619,11 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
>  
>  static void hpsa_irq_affinity_hints(struct ctlr_info *h)
>  {
> -	int i, cpu, rc;
> +	int i, cpu;
>  
>  	cpu = cpumask_first(cpu_online_mask);
>  	for (i = 0; i < h->msix_vector; i++) {
> -		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
> +		irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
>  		cpu = cpumask_next(cpu, cpu_online_mask);
>  	}
>  }
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
