From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] megaraid_sas: use raw_smp_processor_id()
Date: Wed, 15 Apr 2015 13:22:45 -0700
Message-ID: <CALCETrU1At7o6MMOS7xBD1aSO7xBRvKpAfKQKMfX=Z=7qeKKng@mail.gmail.com>
References: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
 <20150415164437.GA17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35986 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbbDOUXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2015 16:23:08 -0400
Received: by lbbqq2 with SMTP id qq2so43018006lbb.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2015 13:23:06 -0700 (PDT)
In-Reply-To: <20150415164437.GA17287@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, Apr 15, 2015 at 9:44 AM, Christoph Hellwig <hch@infradead.org> wrote:
> We only want to steer the I/O completion towards a queue, but don't
> actually access any per-CPU data, so the raw_ version is fine to use
> and avoids the warnings when using smp_processor_id().
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Tested-by: Andy Lutomirski <luto@kernel.org>
> Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

Cc: stable?

>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 675b5e7..5a0800d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1584,11 +1584,11 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
>                         fp_possible = io_info.fpOkForIo;
>         }
>
> -       /* Use smp_processor_id() for now until cmd->request->cpu is CPU
> +       /* Use raw_smp_processor_id() for now until cmd->request->cpu is CPU
>            id by default, not CPU group id, otherwise all MSI-X queues won't
>            be utilized */
>         cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
> -               smp_processor_id() % instance->msix_vectors : 0;
> +               raw_smp_processor_id() % instance->msix_vectors : 0;
>
>         if (fp_possible) {
>                 megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
> @@ -1693,7 +1693,10 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
>                         << MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
>                 cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
>                 cmd->request_desc->SCSIIO.MSIxIndex =
> -                       instance->msix_vectors ? smp_processor_id() % instance->msix_vectors : 0;
> +                       instance->msix_vectors ?
> +                               raw_smp_processor_id() %
> +                                       instance->msix_vectors :
> +                               0;
>                 os_timeout_value = scmd->request->timeout / HZ;
>
>                 if (instance->secure_jbod_support &&



-- 
Andy Lutomirski
AMA Capital Management, LLC
