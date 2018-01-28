From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH] mpt3sas: fix an out of bound write
Date: Sun, 28 Jan 2018 22:13:47 +0530
Message-ID: <CA+RiK67xk2y8R7C0P43Esw9FngCVMPvXeNUVXwiQXoJDSYgMug@mail.gmail.com>
References: <20180119152205.5461-1-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:43319 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751929AbeA1Qnt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jan 2018 11:43:49 -0500
Received: by mail-qk0-f195.google.com with SMTP id a5so2782617qkg.10
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2018 08:43:48 -0800 (PST)
In-Reply-To: <20180119152205.5461-1-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Hannes Reinecke <hare@suse.de>

Hi,
Please consider this patch as Ack-by: Suganath Prabu S
<suganath-prabu.subramani@broadcom.com>

Thanks.

On Fri, Jan 19, 2018 at 8:52 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> cpu_msix_table is allocated to store online cpus, but pci_irq_get_affinity
> may return cpu_possible_mask which is then used to access cpu_msix_table.
> That causes bad user experience.
> Fix limits access to only online cpus, I've also added an additonal test
> to protect from an unlikely change in cpu_online_mask.
>
> Fixes: 1d55abc0e98a0bf35f3af80665aac564e3b30572 scsi: mpt3sas: switch to pci_alloc_irq_vectors
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 13d6e4ec3..59a87ca32 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2410,8 +2410,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>                                 continue;
>                         }
>
> -                       for_each_cpu(cpu, mask)
> +                       for_each_cpu_and(cpu, mask, cpu_online_mask) {
> +                               if (cpu >= ioc->cpu_msix_table_sz)
> +                                       break;
>                                 ioc->cpu_msix_table[cpu] = reply_q->msix_index;
> +                       }
>                 }
>                 return;
>         }
> --
> 2.14.3
>
