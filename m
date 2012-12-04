From: adam radford <aradford@gmail.com>
Subject: Re: [patch,v3,repost 07/10] megaraid_sas: use scsi_host_alloc_node
Date: Mon, 3 Dec 2012 17:41:30 -0800
Message-ID: <CAHtARFEQvSgivGiyYizr80BCRWCkq7+zci8Hkmx822neKKWH3Q@mail.gmail.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
	<1354034799-8460-8-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354034799-8460-8-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, Bart Van Assche <bvanassche@acm.org>, Neela Syam Kolli <megaraidlinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 27, 2012 at 8:46 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index d2c5366..707a6cd 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4020,8 +4020,9 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>         if (megasas_set_dma_mask(pdev))
>                 goto fail_set_dma_mask;
>
> -       host = scsi_host_alloc(&megasas_template,
> -                              sizeof(struct megasas_instance));
> +       host = scsi_host_alloc_node(&megasas_template,
> +                                   sizeof(struct megasas_instance),
> +                                   dev_to_node(&pdev->dev));
>
>         if (!host) {
>                 printk(KERN_DEBUG "megasas: scsi_host_alloc failed\n");

Acked-by: Adam Radford <aradford@gmail.com>
