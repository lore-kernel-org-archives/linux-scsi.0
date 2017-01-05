From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH] mpt3sas: Force request partial completion alignment
Date: Thu, 5 Jan 2017 09:44:06 -0700
Message-ID: <4abb9a3372287c2be32230eee5bcbf4d@mail.gmail.com>
References: <1482929480-16688-1-git-send-email-gpiccoli@linux.vnet.ibm.com> <CAK=zhgqM6ffZ0yQMutc6BHJF_v268vx8RE7fiPo25NWwwR6Fgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36155 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969571AbdAEQoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 11:44:09 -0500
Received: by mail-io0-f173.google.com with SMTP id p127so37058897iop.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jan 2017 08:44:09 -0800 (PST)
In-Reply-To: <CAK=zhgqM6ffZ0yQMutc6BHJF_v268vx8RE7fiPo25NWwwR6Fgw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Brian King <brking@linux.vnet.ibm.com>, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com, Peter Rivera <peter.rivera@broadcom.com>

Sreekanth,
Let us discuss internally more about this before ACKING this patch.

Thanks
Sathya

-----Original Message-----
From: Sreekanth Reddy [mailto:sreekanth.reddy@broadcom.com]
Sent: Wednesday, January 04, 2017 4:33 AM
To: Guilherme G. Piccoli
Cc: linux-scsi@vger.kernel.org; PDL-MPT-FUSIONLINUX; Sathya Prakash; Chaitra
Basappa; Suganath Prabu Subramani; Brian King; mauricfo@linux.vnet.ibm.com;
linuxram@us.ibm.com
Subject: Re: [PATCH] mpt3sas: Force request partial completion alignment

Hi Guilherme,

Can please share us the driver logs (with driver logging_level set to
0x3f8) for the original issue (i.e. without this patch changes) and the HBA
firmware version you have used.

Also can you please share us the steps you have followed to reproduce this
issue, so that I can try on my setup.

Thanks,
Sreekanth

On Wed, Dec 28, 2016 at 6:21 PM, Guilherme G. Piccoli
<gpiccoli@linux.vnet.ibm.com> wrote:
> From: Ram Pai <linuxram@us.ibm.com>
>
> The firmware or device, possibly under a heavy I/O load, can return on
> a partial unaligned boundary. Scsi-ml expects these requests to be
> completed on an alignment boundary. Scsi-ml blindly requeues the I/O
> without checking the alignment boundary of the I/O request for the
> remaining bytes. This leads to errors, since devices cannot perform
> non-aligned read/write operations.
>
> This patch fixes the issue in the driver. It aligns unaligned
> completions of FS requests, by truncating them to the nearest
> alignment boundary.
>
> Reported-by: Mauricio Faria De Oliveira <mauricfo@linux.vnet.ibm.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b5c966e..55332a3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4644,6 +4644,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16
> smid, u8 msix_index, u32 reply)
>         struct MPT3SAS_DEVICE *sas_device_priv_data;
>         u32 response_code = 0;
>         unsigned long flags;
> +       unsigned int sector_sz;
> +       struct request *req;
>
>         mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>         scmd = _scsih_scsi_lookup_get_clear(ioc, smid); @@ -4703,6
> +4705,20 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8
> msix_index, u32 reply)
>         }
>
>         xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
> +
> +       /* In case of bogus fw or device, we could end up having
> +        * unaligned partial completion. We can force alignment here,
> +        * then scsi-ml does not need to handle this misbehavior.
> +        */
> +       sector_sz = scmd->device->sector_size;
> +       req = scmd->request;
> +       if (unlikely(sector_sz && req && (req->cmd_type == REQ_TYPE_FS) &&
> +                   (xfer_cnt % sector_sz))) {
> +               sdev_printk(KERN_INFO, scmd->device,
> +                           "unaligned partial completion avoided\n");
> +               xfer_cnt = (xfer_cnt / sector_sz) * sector_sz;
> +       }
> +
>         scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
>         if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
>                 log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
> --
> 2.1.0
>
