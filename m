From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: smp_processor_id warning in megasas driver on 3.19.3
Date: Wed, 8 Apr 2015 12:14:32 -0700
Message-ID: <CALCETrU2E3=mrf4MYTKs5GgKzjkQCHsF00bwi8U3BfKbk4SBmg@mail.gmail.com>
References: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
 <20150408185138.GA32580@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34109 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbDHTOy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 15:14:54 -0400
Received: by laat2 with SMTP id t2so66410350laa.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2015 12:14:52 -0700 (PDT)
In-Reply-To: <20150408185138.GA32580@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, Apr 8, 2015 at 11:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 08, 2015 at 10:59:36AM -0700, Andy Lutomirski wrote:
>> This is a regression somewhere between 3.15 and 3.19.3.  Let me know
>> if more diagnostics would be helpful.
>
> Try this patch:
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

I wrote an effectively identical patch (differed in whitespace and
formatting), and it seems to work.

Tested-by: Andy Lutomirski <luto@kernel.org>

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
