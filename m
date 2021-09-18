Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4C0C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 01:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6167610D1
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 01:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhIRBMG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:12:06 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:35408 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhIRBMF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 21:12:05 -0400
Received: by mail-qk1-f181.google.com with SMTP id c7so17558178qka.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 18:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O48AXNGXIg9u5ILQwPiuH6nKlisr54tW0aZdCiNqJhU=;
        b=1AHfXkeFOeL70ZD4yRK9qI1uwin4SWpS2qrqFLJQenxsWG8hEcqPi1XnhhD5+W5xN9
         fqFGzDVRoYcOLaijJdD3z6MQJZ+y8L3rAnnZIdT8bvdmqByiUgm25IMEa3M2KtNM6j00
         LK8ROZnZwYBhAysUxfrjchDOa+yO2Fi4QiiDGARDPwlHVS3eP3cN+RfrNT61gp+hixDk
         B5D9FvGzIIEUtSzdAFgY0GvYx4sTyPVfcwGB7GBaSt5edWHPp7KwgG15IynT7p6fzDCX
         O9o5XmE+8GdPuH6oZ3EO7MAKGVkxdHx7EV07hAxEdP0stURcc9vJ3EjGgZaoChiHCToi
         pDVg==
X-Gm-Message-State: AOAM530KiY0ZDDEav7lmPMMj/Q+zorY7n3VedddT5R8kInqf5DTqegCy
        sJ2bTAUe2E7WyHuWYOKseOm+aLYU0D9wRqIxf7M=
X-Google-Smtp-Source: ABdhPJxahlfPrqTfp0kOykr3prRmutyrCsJDESFXDvc+tjrcGwhvy94RJjQ3WAUpmTOqcqi3kvuCsDALTSYgmwSC0+4=
X-Received: by 2002:a05:6902:521:: with SMTP id y1mr7769690ybs.125.1631927441974;
 Fri, 17 Sep 2021 18:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210918000607.450448-1-bvanassche@acm.org> <20210918000607.450448-58-bvanassche@acm.org>
In-Reply-To: <20210918000607.450448-58-bvanassche@acm.org>
From:   Masanori Goto <gotom@debian.or.jp>
Date:   Sat, 18 Sep 2021 10:10:31 +0900
Message-ID: <CALZLnaE3CPKxm5+VtmRxRjG2FZ3hD3UDOg4e_axLuU4gX4Yd0g@mail.gmail.com>
Subject: Re: [PATCH 57/84] nsp32: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm not sure this is a safe approach in general, but any background of
this change?

2021年9月18日(土) 9:07 Bart Van Assche <bvanassche@acm.org>:
>
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/nsp32.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index bc9d29e5fdba..1057b6fd7569 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -945,7 +945,6 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt,
>
>         show_command(SCpnt);
>
> -       SCpnt->scsi_done     = done;
>         data->CurrentSC      = SCpnt;
>         SCpnt->SCp.Status    = SAM_STAT_CHECK_CONDITION;
>         scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
> @@ -1546,7 +1545,7 @@ static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
>         /*
>          * call scsi_done
>          */
> -       (*SCpnt->scsi_done)(SCpnt);
> +       scsi_done(SCpnt);
>
>         /*
>          * reset parameters
