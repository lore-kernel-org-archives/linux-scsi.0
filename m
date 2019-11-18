Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37915C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 009382075E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:23:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lyB2ZoaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKRNXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:23:52 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46828 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfKRNXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 08:23:51 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so7728587iol.13;
        Mon, 18 Nov 2019 05:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=op5rd6aO2/xdLRaY54P25hFvtDdUpULFrgXMiQFvOAg=;
        b=lyB2ZoaEUVNsw5pIhq8A/M3Qf4XTcofq7KgDzHdZpm/rMYlbxqTqa1SW9AfwLBjDV0
         +NAp7cdLLr4J/MzbeRmqpxV1kjHgDUI0GU7FrEQZj3aDsokRzU8saxKwK9gwzAhxqWWA
         wTe8neVFFRviLugbthQcRmWZP+hgGJ/2qkBs8ANJGrQ5Q8R3XDCqu4evi/en8C1+wiMT
         6BRtC5QqqHgdxWfT0ox00G4YpsuOXdqpkhnEyYDvEn7rZ0gNeic3M8UZvFXVN72sR87q
         3hCO6xitjYcRNYdgBnT1M6eoEY/Ik98caOUXBYvOvXOYkZLNqxp2HI1etP97fdCGdtDQ
         rmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=op5rd6aO2/xdLRaY54P25hFvtDdUpULFrgXMiQFvOAg=;
        b=GRXF9rKNgcozHdSSNujPdbb1CuJijQ4Zz7RivIReg8fDIuoMj/ao3mHwiacjxadqUR
         LSeH3DVKDP47aDB6c8GcbDBUfk9EZeV7PDQQzvUNLdYWVW/cJIH/kBJJH3La4bA+qCuw
         lV/2GofAgKJGTU95kkvNBM3wvj7wqs1XS7g9Bi5l9VYFW5bKzEhDKDGTxuNMryZjRajh
         7RyCDvjxOguoPEuEjpAD0nqXMpKNxa53rMNvSg7jlMWfIpwpMt318JcRUzcM6Sp7IDsK
         bV5U+zhXXjN2njx94fVVQk+NtFp4x19OBNSLXRdLEj2k5TjLUvRcvSpeQOG7xFTjCWtr
         vJYw==
X-Gm-Message-State: APjAAAUXLFKcoWg8cMbZrBNnZ6T6wHw6u5x7ttlsTnXOtLQUCNGrgqd2
        7yBw4Q/5M/OGmnOTDr4zs89dxNgf2Hep3oRwgBeFE+6JoUY=
X-Google-Smtp-Source: APXvYqwwesXFTHMX8XUyxZkWh41hLitS8hyv0l7BRBm77qtkF2Vxd9k8PkikJb7y37ESM/fNSi6wklRzseDLD42tLo4=
X-Received: by 2002:a5d:9547:: with SMTP id a7mr13366391ios.198.1574083430516;
 Mon, 18 Nov 2019 05:23:50 -0800 (PST)
MIME-Version: 1.0
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com> <1574049061-11417-5-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574049061-11417-5-git-send-email-cang@qti.qualcomm.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Mon, 18 Nov 2019 18:53:13 +0530
Message-ID: <CAGOxZ53Z6je9Omuh2k=wVJrGVKZDfsfx6=mUJ-8QiRk-2q3u0g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] scsi: ufs: Complete pending requests in host reset
 and restore path
To:     Can Guo <cang@qti.qualcomm.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com,
        Mark Salyzyn <salyzyn@google.com>,
        Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 18, 2019 at 9:22 AM Can Guo <cang@qti.qualcomm.com> wrote:
>
> From: Can Guo <cang@codeaurora.org>
>
> In UFS host reset and restore path, before probe, we stop and start the
> host controller once. After host controller is stopped, the pending
> requests, if any, are cleared from the doorbell, but no completion IRQ
> would be raised due to the hba is stopped.
> These pending requests shall be completed along with the first NOP_OUT
> command(as it is the first command which can raise a transfer completion
> IRQ) sent during probe.
> Since the OCSs of these pending requests are not SUCCESS(because they are
> not yet literally finished), their UPIUs shall be dumped. When there are
> multiple pending requests, the UPIU dump can be overwhelming and may lead
> to stability issues because it is in atomic context.
> Therefore, before probe, complete these pending requests right after host
> controller is stopped and silence the UPIU dump from them.
>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>

Please add all previous Ack/reviewed and tested-by tags so that we are
aware what need to be done for this patch.
Thanks

>  drivers/scsi/ufs/ufshcd.c | 24 ++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |  2 ++
>  2 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5950a7c..b92a3f4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4845,7 +4845,7 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
>                 break;
>         } /* end of switch */
>
> -       if (host_byte(result) != DID_OK)
> +       if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
>                 ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
>         return result;
>  }
> @@ -5404,8 +5404,8 @@ static void ufshcd_err_handler(struct work_struct *work)
>
>         /*
>          * if host reset is required then skip clearing the pending
> -        * transfers forcefully because they will automatically get
> -        * cleared after link startup.
> +        * transfers forcefully because they will get cleared during
> +        * host reset and restore
>          */
>         if (needs_reset)
>                 goto skip_pending_xfer_clear;
> @@ -6333,9 +6333,15 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>         int err;
>         unsigned long flags;
>
> -       /* Reset the host controller */
> +       /*
> +        * Stop the host controller and complete the requests
> +        * cleared by h/w
> +        */
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_hba_stop(hba, false);
> +       hba->silence_err_logs = true;
> +       ufshcd_complete_requests(hba);
> +       hba->silence_err_logs = false;
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>
>         /* scale up clocks to max frequency before full reinitialization */
> @@ -6369,7 +6375,6 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>  static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>  {
>         int err = 0;
> -       unsigned long flags;
>         int retries = MAX_HOST_RESET_RETRIES;
>
>         do {
> @@ -6379,15 +6384,6 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>                 err = ufshcd_host_reset_and_restore(hba);
>         } while (err && --retries);
>
> -       /*
> -        * After reset the door-bell might be cleared, complete
> -        * outstanding requests in s/w here.
> -        */
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> -       ufshcd_transfer_req_compl(hba);
> -       ufshcd_tmc_handler(hba);
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
>         return err;
>  }
>
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e0fe247..1e51034 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -513,6 +513,7 @@ struct ufs_stats {
>   * @uic_error: UFS interconnect layer error status
>   * @saved_err: sticky error mask
>   * @saved_uic_err: sticky UIC error mask
> + * @silence_err_logs: flag to silence error logs
>   * @dev_cmd: ufs device management command information
>   * @last_dme_cmd_tstamp: time stamp of the last completed DME command
>   * @auto_bkops_enabled: to track whether bkops is enabled in device
> @@ -670,6 +671,7 @@ struct ufs_hba {
>         u32 saved_err;
>         u32 saved_uic_err;
>         struct ufs_stats ufs_stats;
> +       bool silence_err_logs;
>
>         /* Device management request data */
>         struct ufs_dev_cmd dev_cmd;
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>


-- 
Regards,
Alim
