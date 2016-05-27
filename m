From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 2/2] mpt3sas - avoid mpt3sas_transport_port_add NULL parent_dev
Date: Fri, 27 May 2016 13:48:43 +0530
Message-ID: <CAK=zhgqbrzEuzE2c-OE7q-ha+MheZv9Dm76TtYsN74B-CzkgXw@mail.gmail.com>
References: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
	<1464203669-31974-3-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33256 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbcE0ISo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2016 04:18:44 -0400
Received: by mail-oi0-f53.google.com with SMTP id k23so163179294oih.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2016 01:18:43 -0700 (PDT)
In-Reply-To: <1464203669-31974-3-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

Hi,

This patch looks good. Please consider this patch as Ack-by: Sreekanth Reddy
<sreekanth.reddy@broadcom.com>

Thanks,
Sreekanth


On Thu, May 26, 2016 at 12:44 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> If _scsih_sas_host_add's call to mpt3sas_config_get_sas_iounit_pg0
> fails, ioc->sas_hba.parent_dev may be left uninitialized.  A later
> device probe could invoke mpt3sas_transport_port_add which will call
> sas_port_alloc_num [scsi_transport_sas] with a NULL parent_dev pointer.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> index 6a84b82d71bb..ff93286bc32f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -705,6 +705,11 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
>                 goto out_fail;
>         }
>
> +       if (!sas_node->parent_dev) {
> +               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> +                   ioc->name, __FILE__, __LINE__, __func__);
> +               goto out_fail;
> +       }
>         port = sas_port_alloc_num(sas_node->parent_dev);
>         if ((sas_port_add(port))) {
>                 pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
