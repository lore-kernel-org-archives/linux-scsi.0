From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [patch v2] mpt3sas: issue_reset is uninitialized
Date: Wed, 10 Dec 2014 12:21:29 +0530
Message-ID: <CAK=zhgpGzt4tyu-knsJdYkFFH9jXE2HHgsoDq-rnYMi983MUcA@mail.gmail.com>
References: <20141203100918.GA29583@mwanda>
	<20141204105705.GB22643@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:37766 "EHLO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLJGvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2014 01:51:31 -0500
Received: by mail-ob0-f169.google.com with SMTP id vb8so1774274obc.14
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2014 22:51:30 -0800 (PST)
In-Reply-To: <20141204105705.GB22643@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This patch seems to be good. Please consider this patch as Acked-by:
"Sreekanth Reddy" <Sreekanth.Reddy@avagotech.com>

Regards,
Sreekanth

On Thu, Dec 4, 2014 at 4:27 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The "issue_reset" can be used uninitialized.  It should be set to false
> at the start.
>
> Also I cleaned up the types a little by using bool.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: style fix.  use true/false instead of 1/0.
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 1560115..b9c2739 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3419,7 +3419,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
>         u16 smid;
>         u32 ioc_state;
>         unsigned long timeleft;
> -       u8 issue_reset;
> +       bool issue_reset = false;
>         int rc;
>         void *request;
>         u16 wait_state_count;
> @@ -3483,7 +3483,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
>                 _debug_dump_mf(mpi_request,
>                     sizeof(Mpi2SasIoUnitControlRequest_t)/4);
>                 if (!(ioc->base_cmds.status & MPT3_CMD_RESET))
> -                       issue_reset = 1;
> +                       issue_reset = true;
>                 goto issue_host_reset;
>         }
>         if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID)
> @@ -3523,7 +3523,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
>         u16 smid;
>         u32 ioc_state;
>         unsigned long timeleft;
> -       u8 issue_reset;
> +       bool issue_reset = false;
>         int rc;
>         void *request;
>         u16 wait_state_count;
> @@ -3581,7 +3581,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
>                 _debug_dump_mf(mpi_request,
>                     sizeof(Mpi2SepRequest_t)/4);
>                 if (!(ioc->base_cmds.status & MPT3_CMD_RESET))
> -                       issue_reset = 1;
> +                       issue_reset = false;
>                 goto issue_host_reset;
>         }
>         if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID)
