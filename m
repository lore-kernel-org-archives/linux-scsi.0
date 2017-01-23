From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] mpt3sas: Force request partial completion alignment
Date: Mon, 23 Jan 2017 14:35:18 +0530
Message-ID: <CAK=zhgoFH+G-m=VXNAe+ORKUZKJ0e3OY3SvB96_6wS+tB_CQHw@mail.gmail.com>
References: <1482929480-16688-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:35276 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdAWJFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2017 04:05:19 -0500
Received: by mail-qt0-f178.google.com with SMTP id x49so112305343qtc.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 01:05:19 -0800 (PST)
In-Reply-To: <1482929480-16688-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Brian King <brking@linux.vnet.ibm.com>, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com

On Wed, Dec 28, 2016 at 6:21 PM, Guilherme G. Piccoli
<gpiccoli@linux.vnet.ibm.com> wrote:
> From: Ram Pai <linuxram@us.ibm.com>
>
> The firmware or device, possibly under a heavy I/O load, can return
> on a partial unaligned boundary. Scsi-ml expects these requests to be
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
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b5c966e..55332a3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4644,6 +4644,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>         struct MPT3SAS_DEVICE *sas_device_priv_data;
>         u32 response_code = 0;
>         unsigned long flags;
> +       unsigned int sector_sz;
> +       struct request *req;
>
>         mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>         scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
> @@ -4703,6 +4705,20 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
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

[Sreekanth] Patch looks good. But can we print xfer_cnt & sector_sz
values along with above print.

Also if it is generic drive issue, then can we move this work around
to SCSI Mid Layer?

> +               xfer_cnt = (xfer_cnt / sector_sz) * sector_sz;
> +       }
> +
>         scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
>         if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
>                 log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
> --
> 2.1.0
>
