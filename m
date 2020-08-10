Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3818C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 15:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CE520825
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 15:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeaZuKWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgHJPlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 11:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbgHJPlb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 11:41:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B194C061756;
        Mon, 10 Aug 2020 08:41:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a26so9866333ejc.2;
        Mon, 10 Aug 2020 08:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pmIlVpEUwH8Ra61hHTKQjyHUWPaGv/XKB/OaiPGgml4=;
        b=FeaZuKWKfrsCbBnngc7meGA/8HmsVAKD53q8Cyo7sFBt9PJTPl3GoJl5pmkzy6Nic4
         COLehlC1DOXZihm0cyjNp0dJzMlc3w6cQ3YohWSQRrx7zaLPeiYgYXX0gqKXlZhP4Hze
         YEy8O3pOI10tKs3sxEmdupl5nvp2SXyGqUa8IBQTRkTj17mDWfU/odz8fVaQ1dognjwr
         w/5Nrg1dUcCbYMrXEkUFoeM+XrqcNCaPE0PVJJ/DF5CDcvN6JOxhh34sCgAdr+k/ldJB
         L0PJkrORF8pmA5EhHEk2iPHGy9Rlfel3eGhJI7I/biwTyR5teXs0X0HNiO2nRrxVs3Hw
         z/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pmIlVpEUwH8Ra61hHTKQjyHUWPaGv/XKB/OaiPGgml4=;
        b=CpdBNo5T79PKmpzUZs121612OdHmNh+koFMndk+UqSdMcRCmWAbpM6IE8qIbp99Sd5
         yXS5uXCUNJwJKgJGvgNHTF93IZjmnHW/yumXCvpA8Bwm5mik48BDmT2mKuVV7XWjJX1F
         INbZUIhO5dE39sAjWhgcepO9Yr5fWOtYUux10cBU2Bxz02UOqAIXVkvG4gYcoMFcJwGG
         sZ78WSG25QUxDdiwEoR5lpDLSV8wFwmMd327UkyCzspE+prLrQkTgKVsX/nLr/LSCOrh
         cD97kCFtfrRhmtFzDoeFGFzeph2zL7nzlb4NGfPwGKNsgNoK1PW/T0WlTUfeleKwlvxK
         rJZw==
X-Gm-Message-State: AOAM531bdee6FjwOXkZXhx7C3P+YkENxeTrhiM0t08BVty/1V5LP0ctt
        bvjZyroNRB4KIiDAKLfeaP4=
X-Google-Smtp-Source: ABdhPJx3hPXMNA7+TIBef0DKRduc+Z/07rybRf6TJvgPkMjKHWwkyw+Cbxcj18RFU0SwpdYFllAyoA==
X-Received: by 2002:a17:906:1cd3:: with SMTP id i19mr7158892ejh.552.1597074089772;
        Mon, 10 Aug 2020 08:41:29 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b910:3189:44c:d55b:5f94:2fc4])
        by smtp.googlemail.com with ESMTPSA id b13sm12551297edw.69.2020.08.10.08.41.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Aug 2020 08:41:29 -0700 (PDT)
Message-ID: <5c6f1ad9f703cc5721e081452e869a9ee6bc4ab6.camel@gmail.com>
Subject: Re: [PATCH v1] scsi: ufs: no need to send one Abort Task TM in case
 the task in DB was cleared
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 10 Aug 2020 17:41:22 +0200
In-Reply-To: <5ad1dbd76a0d5d476641a01bfb8bd435@codeaurora.org>
References: <20200804123534.29104-1-huobean@gmail.com>
         <a68a1bdf74bdf8ada29808537290b35b@codeaurora.org>
         <871fdbc1719d7a3c469bf857071aa2c6bd71ddaf.camel@gmail.com>
         <5ad1dbd76a0d5d476641a01bfb8bd435@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-08-06 at 18:07 +0800, Can Guo wrote:
> Hi Bean,
> 
> On 2020-08-06 17:50, Bean Huo wrote:
> > > 
> > > Please check Stanley's recent change to ufshcd_abort, you may
> > > want to rebase your change on his and do goto cleanup here.
> > > @Stanley correct me if I am wrong.
> > > 
> > > But even if you do a goto cleanup here, we still lost the
> > > chances to dump host infos/regs like it does in the old code.
> > > If a cmd was completed but without a notifying intr, this is
> > > kind of a problem that we/host should look into, because it's
> > > pasted at least 30 sec since the cmd was sent, so those dumps
> > > are necessary to debug the problem. How about moving blow prints
> > > in front of this part?
> > > 
> > > Thanks,
> > > 
> > > Can Guo.
> > > 
> > > >  	}
> > > > 
> > > >  	/* Print Transfer Request of aborted task */
> > 
> > Hi Can
> > 
> > Thanks, do you mean that change to like this:
> > 
> > 
> > Author: Bean Huo <beanhuo@micron.com>
> > Date:   Thu Aug 6 11:34:45 2020 +0200
> > 
> >     scsi: ufs: no need to send one Abort Task TM in case the task
> > in
> >   was cleared
> > 
> >     If the bit corresponds to a task in the Doorbell register has
> > been
> >     cleared, no need to poll the status of the task on the device
> > side
> >     and to send an Abort Task TM.
> >     This patch also deletes dispensable dev_err() in case of the
> > task
> >     already completed.
> > 
> >     Signed-off-by: Bean Huo <beanhuo@micron.com>
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 307622284239..f7c91ce9e294 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6425,23 +6425,9 @@ static int ufshcd_abort(struct scsi_cmnd
> > *cmd)
> >                 return ufshcd_eh_host_reset_handler(cmd);
> > 
> >         ufshcd_hold(hba, false);
> > -       reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >         /* If command is already aborted/completed, return SUCCESS
> > */
> > -       if (!(test_bit(tag, &hba->outstanding_reqs))) {
> > -               dev_err(hba->dev,
> > -                       "%s: cmd at tag %d already completed,
> > outstanding=0x%lx, doorbell=0x%x\n",
> > -                       __func__, tag, hba->outstanding_reqs, reg);
> > +       if (!(test_bit(tag, &hba->outstanding_reqs)))
> >                 goto out;
> > -       }
> > -
> > -       if (!(reg & (1 << tag))) {
> > -               dev_err(hba->dev,
> > -               "%s: cmd was completed, but without a notifying
> > intr,
> > tag = %d",
> > -               __func__, tag);
> > -       }
> > -
> > -       /* Print Transfer Request of aborted task */
> > -       dev_err(hba->dev, "%s: Device abort task at tag %d\n",
> > __func__, tag);
> > 
> >         /*
> >          * Print detailed info about aborted request.
> > @@ -6462,6 +6448,17 @@ static int ufshcd_abort(struct scsi_cmnd
> > *cmd)
> >         }
> >         hba->req_abort_count++;
> > 
> > +       reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> > +       if (!(reg & (1 << tag))) {
> > +               dev_err(hba->dev,
> > +               "%s: cmd was completed, but without a notifying
> > intr,
> > tag = %d",
> > +               __func__, tag);
> > +               goto cleanup;
> > +       }
> > +
> > +       /* Print Transfer Request of aborted task */
> > +       dev_err(hba->dev, "%s: Device abort task at tag %d\n",
> > __func__, tag);
> > +
> 
> The rest looks good but let below two lines stay where they were.
> 
>         /* Print Transfer Request of aborted task */
>         dev_err(hba->dev, "%s: Device abort task at tag %d\n",
> __func__, tag);
> 
> 
> Thanks,
> 
> Can Guo.
> 
Hi Can
I will change it in the next version.


Hi Stanly
would you mind I take your patch into my next version patchset? Since
we both will add a new same goto label. I will keep your patch
authorship.

Thanks,
Bean


