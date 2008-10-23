From: "Pascal Terjan" <pterjan@gmail.com>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
Date: Fri, 24 Oct 2008 00:49:07 +0200
Message-ID: <e8ca35370810231549i56d9e4ean46ebfb1a09dba34c@mail.gmail.com>
References: <48FEECAC.6080304@panasas.com>
	 <20081022183739P.fujita.tomonori@lab.ntt.co.jp>
	 <48FEFB9B.3090806@panasas.com>
	 <20081022213418B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:9045 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYJWWtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2008 18:49:08 -0400
Received: by rv-out-0506.google.com with SMTP id k40so558575rvb.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2008 15:49:07 -0700 (PDT)
In-Reply-To: <20081022213418B.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, matthew@wil.cx, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, sumantp@lsil.com, bo.yang@lsi.com, bugme-daemon@bugzilla.kernel.org

On Wed, Oct 22, 2008 at 2:33 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 28c9da7..7dc62de 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -4402,6 +4402,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>        scb_t   *scb;
>        int     rval;
>
> +       scmd = scsi_allocate_command(GFP_KERNEL);
> +       if (!scmd)
> +               return -ENOMEM;
> +
>        /*
>         * The internal commands share one command id and hence are
>         * serialized. This is so because we want to reserve maximum number of
> @@ -4412,12 +4416,11 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>        scb = &adapter->int_scb;
>        memset(scb, 0, sizeof(scb_t));
>
> -       scmd = &adapter->int_scmd;
> -       memset(scmd, 0, sizeof(Scsi_Cmnd));
> -
>        sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
>        scmd->device = sdev;
>
> +       memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
> +       scmd->cmnd = adapter->int_cdb;
>        scmd->device->host = adapter->host;
>        scmd->host_scribble = (void *)scb;
>        scmd->cmnd[0] = MEGA_INTERNAL_CMD;
> @@ -4456,6 +4459,8 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>
>        mutex_unlock(&adapter->int_mtx);
>
> +       scsi_free_command(GFP_KERNEL, scmd);
> +
>        return rval;
>  }
>
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index ee70bd4..795201f 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -888,8 +888,8 @@ typedef struct {
>
>        u8      sglen;  /* f/w supported scatter-gather list length */
>
> +       unsigned char int_cdb[MAX_COMMAND_SIZE];
>        scb_t                   int_scb;
> -       Scsi_Cmnd               int_scmd;
>        struct mutex            int_mtx;        /* To synchronize the internal
>                                                commands */
>        struct completion       int_waitq;      /* wait queue for internal
>

I confirm that this patch fixes the oops and I can now read the usual info
