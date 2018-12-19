From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 12/41] scsi: bfa: bfa_ioc: Mark expected switch
 fall-throughs
Date: Wed, 19 Dec 2018 09:39:31 -0600
Message-ID: <b5f0c0bf-f671-65b0-dfed-39cefcd3fde1@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <520fb16cd3630d612c5768989e2ffa90f1a73f97.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <520fb16cd3630d612c5768989e2ffa90f1a73f97.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:27 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, I replaced "!!! fall through !!!"
> comment with "fall through" annotations, which is what GCC is expecting
> to find.
> 
> Addresses-Coverity-ID: 146155 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/bfa/bfa_ioc.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
> index 16d3aeb0e572..32b24e51cce6 100644
> --- a/drivers/scsi/bfa/bfa_ioc.c
> +++ b/drivers/scsi/bfa/bfa_ioc.c
> @@ -978,9 +978,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
>   
>   	case IOCPF_E_INITFAIL:
>   		bfa_iocpf_timer_stop(ioc);
> -		/*
> -		 * !!! fall through !!!
> -		 */
> +		/* fall through */
>   
>   	case IOCPF_E_TIMEOUT:
>   		writel(1, ioc->ioc_regs.ioc_sem_reg);
> @@ -1056,9 +1054,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
>   
>   	case IOCPF_E_FAIL:
>   		bfa_iocpf_timer_stop(ioc);
> -		/*
> -		 * !!! fall through !!!
> -		 */
> +		/* fall through */
>   
>   	case IOCPF_E_TIMEOUT:
>   		bfa_ioc_set_cur_ioc_fwstate(ioc, BFI_IOC_FAIL);
> @@ -6007,6 +6003,7 @@ bfa_dconf_sm_final_sync(struct bfa_dconf_mod_s *dconf,
>   	case BFA_DCONF_SM_IOCDISABLE:
>   	case BFA_DCONF_SM_FLASH_COMP:
>   		bfa_timer_stop(&dconf->timer);
> +		/* fall through */
>   	case BFA_DCONF_SM_TIMEOUT:
>   		bfa_sm_set_state(dconf, bfa_dconf_sm_uninit);
>   		bfa_fsm_send_event(&dconf->bfa->iocfc, IOCFC_E_DCONF_DONE);
> 
