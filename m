From: James Smart <James.Smart@emulex.com>
Subject: Re: [patch 09/10] lpfc: use scsi_host_alloc_node
Date: Wed, 31 Oct 2012 14:56:43 -0400
Message-ID: <5091746B.3040405@emulex.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com> <1351628084-29358-12-git-send-email-jmoyer@redhat.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351628084-29358-12-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks Jeff.

-- james s


Acked-By: James Smart  <james.smart@emulex.com>


On 10/30/2012 4:14 PM, Jeff Moyer wrote:
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c |   10 ++++++----
>   1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 7dc4218..65956d3 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3051,11 +3051,13 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   	int error = 0;
>   
>   	if (dev != &phba->pcidev->dev)
> -		shost = scsi_host_alloc(&lpfc_vport_template,
> -					sizeof(struct lpfc_vport));
> +		shost = scsi_host_alloc_node(&lpfc_vport_template,
> +					     sizeof(struct lpfc_vport),
> +					     dev_to_node(&phba->pcidev->dev));
>   	else
> -		shost = scsi_host_alloc(&lpfc_template,
> -					sizeof(struct lpfc_vport));
> +		shost = scsi_host_alloc_node(&lpfc_template,
> +					     sizeof(struct lpfc_vport),
> +					     dev_to_node(&phba->pcidev->dev));
>   	if (!shost)
>   		goto out;
>   
