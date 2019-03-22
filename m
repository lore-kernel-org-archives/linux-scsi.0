From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: avoid uninitialized variable warning
Date: Fri, 22 Mar 2019 09:47:14 -0700
Message-ID: <1a302ccb-2f9d-560d-8b07-eb5382684b76@broadcom.com>
References: <20190322142557.929966-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190322142557.929966-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 3/22/2019 7:25 AM, Arnd Bergmann wrote:
> clang -Wuninitialized incorrectly sees a variable being used without
> initialization:
>
> drivers/scsi/lpfc/lpfc_nvme.c:2102:37: error: variable 'localport' is uninitialized when used here
>        [-Werror,-Wuninitialized]
>                  lport = (struct lpfc_nvme_lport *)localport->private;
>                                                    ^~~~~~~~~
> drivers/scsi/lpfc/lpfc_nvme.c:2059:38: note: initialize the variable 'localport' to silence this warning
>          struct nvme_fc_local_port *localport;
>                                              ^
>                                               = NULL
> 1 error generated.
>
> This is clearly in dead code, as the condition leading up to it is
> always false when CONFIG_NVME_FC is disabled, and the variable
> is always initialized when nvme_fc_register_localport() got
> called successfully.
>
> Change the preprocessor conditional to the equivalent C construct,
> which makes the code more readable and gets rid of the warning.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
> index 1aa00d2c3f74..9defff711884 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -2080,15 +2080,15 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
>   		lpfc_nvme_template.max_hw_queues =
>   			phba->sli4_hba.num_present_cpu;
>   
> +	if (!IS_ENABLED(CONFIG_NVME_FC))
> +		return ret;
> +
>   	/* localport is allocated from the stack, but the registration
>   	 * call allocates heap memory as well as the private area.
>   	 */
> -#if (IS_ENABLED(CONFIG_NVME_FC))
> +
>   	ret = nvme_fc_register_localport(&nfcp_info, &lpfc_nvme_template,
>   					 &vport->phba->pcidev->dev, &localport);
> -#else
> -	ret = -ENOMEM;
> -#endif
>   	if (!ret) {
>   		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME | LOG_NVME_DISC,
>   				 "6005 Successfully registered local "

Looks good

Reviewed-By: James Smart <james.smart@broadcom.com>

-- james
