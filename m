Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA987C433EA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1CAE22D02
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nowOihB/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgHFKH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 06:07:58 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31402 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbgHFKHr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Aug 2020 06:07:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596708465; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GyyGr/JOFuGlAnvIiYAe0ifvybfJPXEKySOZwuEQVuY=;
 b=nowOihB/oNg3OqQlWNUNB1csvVBU7LbxT0Hvi8Nf1EZ8Tdh0zmKF3KpvBBO5hrjQwUMiFFh6
 Yv+DZU1T6/cvSQT4q0Ncw+AFLs6ZKXYwviONfaTpZlCjLT82dtUJ8bNqK+U3ou6ywGP1pR22
 pUTspSCsaHxlKZ6sE5DFCRC0GHE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-west-2.postgun.com with SMTP id
 5f2bd66b2889723bf8306741 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 Aug 2020 10:07:39
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36AC6C433A0; Thu,  6 Aug 2020 10:07:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A208C433C6;
        Thu,  6 Aug 2020 10:07:37 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Aug 2020 18:07:37 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: ufs: no need to send one Abort Task TM in case
 the task in DB was cleared
In-Reply-To: <871fdbc1719d7a3c469bf857071aa2c6bd71ddaf.camel@gmail.com>
References: <20200804123534.29104-1-huobean@gmail.com>
 <a68a1bdf74bdf8ada29808537290b35b@codeaurora.org>
 <871fdbc1719d7a3c469bf857071aa2c6bd71ddaf.camel@gmail.com>
Message-ID: <5ad1dbd76a0d5d476641a01bfb8bd435@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2020-08-06 17:50, Bean Huo wrote:
>> 
>> Please check Stanley's recent change to ufshcd_abort, you may
>> want to rebase your change on his and do goto cleanup here.
>> @Stanley correct me if I am wrong.
>> 
>> But even if you do a goto cleanup here, we still lost the
>> chances to dump host infos/regs like it does in the old code.
>> If a cmd was completed but without a notifying intr, this is
>> kind of a problem that we/host should look into, because it's
>> pasted at least 30 sec since the cmd was sent, so those dumps
>> are necessary to debug the problem. How about moving blow prints
>> in front of this part?
>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>> >  	}
>> >
>> >  	/* Print Transfer Request of aborted task */
> 
> Hi Can
> 
> Thanks, do you mean that change to like this:
> 
> 
> Author: Bean Huo <beanhuo@micron.com>
> Date:   Thu Aug 6 11:34:45 2020 +0200
> 
>     scsi: ufs: no need to send one Abort Task TM in case the task in
>   was cleared
> 
>     If the bit corresponds to a task in the Doorbell register has been
>     cleared, no need to poll the status of the task on the device side
>     and to send an Abort Task TM.
>     This patch also deletes dispensable dev_err() in case of the task
>     already completed.
> 
>     Signed-off-by: Bean Huo <beanhuo@micron.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 307622284239..f7c91ce9e294 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6425,23 +6425,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                 return ufshcd_eh_host_reset_handler(cmd);
> 
>         ufshcd_hold(hba, false);
> -       reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>         /* If command is already aborted/completed, return SUCCESS */
> -       if (!(test_bit(tag, &hba->outstanding_reqs))) {
> -               dev_err(hba->dev,
> -                       "%s: cmd at tag %d already completed,
> outstanding=0x%lx, doorbell=0x%x\n",
> -                       __func__, tag, hba->outstanding_reqs, reg);
> +       if (!(test_bit(tag, &hba->outstanding_reqs)))
>                 goto out;
> -       }
> -
> -       if (!(reg & (1 << tag))) {
> -               dev_err(hba->dev,
> -               "%s: cmd was completed, but without a notifying intr,
> tag = %d",
> -               __func__, tag);
> -       }
> -
> -       /* Print Transfer Request of aborted task */
> -       dev_err(hba->dev, "%s: Device abort task at tag %d\n",
> __func__, tag);
> 
>         /*
>          * Print detailed info about aborted request.
> @@ -6462,6 +6448,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>         }
>         hba->req_abort_count++;
> 
> +       reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +       if (!(reg & (1 << tag))) {
> +               dev_err(hba->dev,
> +               "%s: cmd was completed, but without a notifying intr,
> tag = %d",
> +               __func__, tag);
> +               goto cleanup;
> +       }
> +
> +       /* Print Transfer Request of aborted task */
> +       dev_err(hba->dev, "%s: Device abort task at tag %d\n",
> __func__, tag);
> +

The rest looks good but let below two lines stay where they were.

        /* Print Transfer Request of aborted task */
        dev_err(hba->dev, "%s: Device abort task at tag %d\n",
__func__, tag);


Thanks,

Can Guo.

>         /* Skip task abort in case previous aborts failed and report
> failure */
>         if (lrbp->req_abort_skip) {
>                 err = -EIO;
> @@ -6526,6 +6523,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                 goto out;
>         }
> 
> +cleanup:
>         scsi_dma_unmap(cmd);
> 
>         spin_lock_irqsave(host->host_lock, flags);
> 
> 
> 
> 
> 
> Author: Stanley Chu <stanley.chu@mediatek.com>
> Date:   Thu Aug 6 11:48:00 2020 +0200
> 
>     scsi: ufs: Cleanup completed request without interrupt notification
> 
>     If somehow no interrupt notification is raised for a completed
> request
>     and its doorbell bit is cleared by host, UFS driver needs to
> cleanup
>     its outstanding bit in ufshcd_abort(). Otherwise, system may behave
>     abnormally by below flow:
> 
>     After ufshcd_abort() returns, this request will be requeued by SCSI
>     layer with its outstanding bit set. Any future completed request
>     will trigger ufshcd_transfer_req_compl() to handle all "completed
>     outstanding bits". In this time, the "abnormal outstanding bit"
>     will be detected and the "requeued request" will be chosen to
> execute
>     request post-processing flow. This is wrong because this request is
>     still "alive".
> 
>     Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f7c91ce9e294..29d5e5e5d0e0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6489,7 +6489,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                         /* command completed already */
>                         dev_err(hba->dev, "%s: cmd at tag %d
> successfully cleared from DB.\n",
>                                 __func__, tag);
> -                       goto out;
> +                       goto cleanup;
>                 } else {
>                         dev_err(hba->dev,
>                                 "%s: no response from device. tag = %d,
> err %d\n",
