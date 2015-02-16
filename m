From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] scsi/lpfc: use remove handler as shutdown handler
Date: Mon, 16 Feb 2015 14:41:58 -0500
Message-ID: <54E24806.5030605@emulex.com>
References: <1422285538-487-1-git-send-email-cascardo@linux.vnet.ibm.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422285538-487-1-git-send-email-cascardo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good.

Acked-By: James Smart  <james.smart@emulex.com>

-- james



On 1/26/2015 10:18 AM, Thadeu Lima de Souza Cascardo wrote:
> Without a shutdown handler, some cards behave very badly after a kexec.
> During probe, pending DMA writes will corrupt kernel memory, for
> example.
>
> Using the remove handler guarantees we will use a well tested path.
>
> With this patch I applied, I managed to use kexec multiple times and
> probe and SCSI scan worked every time.
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 0b2c53a..8aa804a 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11248,6 +11248,7 @@ static struct pci_driver lpfc_driver = {
>   	.id_table	= lpfc_id_table,
>   	.probe		= lpfc_pci_probe_one,
>   	.remove		= lpfc_pci_remove_one,
> +	.shutdown	= lpfc_pci_remove_one,
>   	.suspend        = lpfc_pci_suspend_one,
>   	.resume		= lpfc_pci_resume_one,
>   	.err_handler    = &lpfc_err_handler,
