Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B72C2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 976FA2080D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXzpDS4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfL0BYt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:24:49 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:41664 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 20:24:48 -0500
Received: by mail-ua1-f68.google.com with SMTP id f7so8624297uaa.8
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 17:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKstf8LEJVXP1R8cJr53huZGWo/mM/zsizlEBK0ewPE=;
        b=aXzpDS4ehWyCjyerZG4iT1W8MtfYAK594u0jODaAJCaw2UFRsJ9IXKM4qjlBz/ICzC
         blnPgbLycMQMIsO+wrDVQO8Uqjj+KLxowJ3RqhwCtDyMbwId0X8iHpd0OYJQNiM/ygGj
         JBYL21P502Cu5nc/nxJlaSD7mlLivEv2IYLwMg5h/acffFd7Deq3VbLgLLV3QbyMC5p5
         xB4TsNx7qi4U6pjFzUU+Y83XzoSS7BPIhBMRJt1vvzMARAvXi509wFEFOotrRtXRUfnQ
         Duw/HBmpeQhlcDIjuEWXTdEout0imhWCtKa1NSOAYlnF4V2n8+fEeLgSPt/XdhJzutrI
         doNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKstf8LEJVXP1R8cJr53huZGWo/mM/zsizlEBK0ewPE=;
        b=g03ZMGT+wT4Iw+aDccMtnf6hHOmOublalkbungkmLeSblfZHmqI+DBfz68PFOOZgNJ
         n6KB63tkM2bu7KHg+CC/K1qwpZSVG9B5af9RptqJmLO0TbeeKGSW+T07drh/B4SPMiyX
         3N2eUn/Jafq7SibI/PQ4ktdpnXPKk3jKxgL8AcspuXUK6qQ+u46qU2Gq59nc9RzpEo5U
         jiyNT5Ut+sG4Ab6aJfV782Q29J3VWBoB+8EFHZTN8qy8jsnb6dyPmWwTLPmH9plxeOcH
         mnXuV53WCrEUP3cP2UcJ+K6F4n7ICASctoHuM6HGxNZjYP0cVjLXl8mzPwtd12WFb4SW
         vLIw==
X-Gm-Message-State: APjAAAVPMMr3IWAcMD//piNwpmPIzcivdb9eyyU+hEYzba7RQj/QqkUe
        oUgBRQQfnJh0zyuSqP3VAMzltluUEH49P7WDoss=
X-Google-Smtp-Source: APXvYqxHtygFVcqaLt8A4/Mz23XxAQDt+ntjIanlZ8OftxCO8tm8fArsOOMzVynXMPu6XpenF963ptLMwqrehoqRF08=
X-Received: by 2002:ab0:70a7:: with SMTP id q7mr30136093ual.18.1577409887847;
 Thu, 26 Dec 2019 17:24:47 -0800 (PST)
MIME-Version: 1.0
References: <20191224220248.30138-1-bvanassche@acm.org> <20191224220248.30138-7-bvanassche@acm.org>
In-Reply-To: <20191224220248.30138-7-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 27 Dec 2019 06:54:11 +0530
Message-ID: <CAGOxZ53V1hidM5xsh-KRnNhOUiNFffcozxWM8kxOx2hXm39vqw@mail.gmail.com>
Subject: Re: [PATCH 6/6] ufs: Remove the SCSI timeout handler
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 25, 2019 at 3:35 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> The UFS SCSI timeout handler was needed to compensate that
> ufshcd_queuecommand() could return SCSI_MLQUEUE_HOST_BUSY for a long
> time. Commit a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by eliminating
> tag conflicts") fixed this so the timeout handler is no longer necessary.
>
> See also commit f550c65b543b ("scsi: ufs: implement scsi host timeout handler").
>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 36 ------------------------------------
>  1 file changed, 36 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index edcc137c436b..763e41286a4b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7092,41 +7092,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>         ufshcd_probe_hba(hba);
>  }
>
> -static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
> -{
> -       unsigned long flags;
> -       struct Scsi_Host *host;
> -       struct ufs_hba *hba;
> -       int index;
> -       bool found = false;
> -
> -       if (!scmd || !scmd->device || !scmd->device->host)
> -               return BLK_EH_DONE;
> -
> -       host = scmd->device->host;
> -       hba = shost_priv(host);
> -       if (!hba)
> -               return BLK_EH_DONE;
> -
> -       spin_lock_irqsave(host->host_lock, flags);
> -
> -       for_each_set_bit(index, &hba->outstanding_reqs, hba->nutrs) {
> -               if (hba->lrb[index].cmd == scmd) {
> -                       found = true;
> -                       break;
> -               }
> -       }
> -
> -       spin_unlock_irqrestore(host->host_lock, flags);
> -
> -       /*
> -        * Bypass SCSI error handling and reset the block layer timer if this
> -        * SCSI command was not actually dispatched to UFS driver, otherwise
> -        * let SCSI layer handle the error as usual.
> -        */
> -       return found ? BLK_EH_DONE : BLK_EH_RESET_TIMER;
> -}
> -
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>         &ufs_sysfs_unit_descriptor_group,
>         &ufs_sysfs_lun_attributes_group,
> @@ -7145,7 +7110,6 @@ static struct scsi_host_template ufshcd_driver_template = {
>         .eh_abort_handler       = ufshcd_abort,
>         .eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>         .eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> -       .eh_timed_out           = ufshcd_eh_timed_out,
>         .this_id                = -1,
>         .sg_tablesize           = SG_ALL,
>         .cmd_per_lun            = UFSHCD_CMD_PER_LUN,



-- 
Regards,
Alim
