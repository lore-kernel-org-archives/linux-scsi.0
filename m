Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBDD0C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AF38206F6
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 10:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrvbgmPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgGYK3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 06:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYK3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jul 2020 06:29:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29B9C0619D3;
        Sat, 25 Jul 2020 03:29:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x9so5835484plr.2;
        Sat, 25 Jul 2020 03:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5iiobHJC3O2IChZKdVtcb9SVSJs7fTb/PaPBRVV381I=;
        b=QrvbgmPCB44/PtF+dfEMgm6KzsPzjZ4gJzJwcOv/e+Q+kmmqiwku3f5KsveJ6tNkSO
         iBPd27ixdWLcPUZOj8OPhywq/BYLv1AtMB6mzvdKHC/SJCSOQanYy8qGa1I5AwsYMI0V
         hqqTpPtUYHkzauLHaCGeizRhwc5PMfBpb+rJzsZ8Rz7BCN6/T7/1AUf1WWBDlFiA2pJX
         LDwiTp7eYkZp9MiqJjImyPDBFHlk/uNOMAZePvGHoHumZB7Cymup+Y/V4AbS0ClIxvM1
         qeNp/XE+6bn0Oz8adsCPUVNFEB0vxhvie9O+oJt6BZ7gsu6gJsWew0QOAYnzLO/ILMK4
         Es9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5iiobHJC3O2IChZKdVtcb9SVSJs7fTb/PaPBRVV381I=;
        b=K3dBx9wd1KYEP7Z6DKzGuObt6YnQoZJzMwIehtiXHM64xGwDiQMOoQLrBZLP0Ht28l
         HXaM8+oYUY0Ybi6B4iIUpLRkqg/0yGqVuTGcHx+MT69czTeHXEdptTps2iyjfQj9hq8j
         PnMMYX0rrcZvVp/FrV37IogLzBRiQgsbwQBVb0794fqyX9C9+G0EFadNXCA+XCn6JSU9
         CeGbOnHBKCZjTVmjMXO3HKD3/y+cmV4ytITxqZaLx2umKG89ye12RISOxT+snOpwYJFt
         fbkzIk0fzSo11z5/BGE5ljeVJAtseB3kGdLcPy2YBcC/6d1eswojqCvOjArNsRQUmrtK
         xyGg==
X-Gm-Message-State: AOAM530F9iX688T3nGbqITcoeY+lt7GGcTV8Iko9Ma0KHjUsbmLEXxa4
        QmJgHQNSRolDJOy2rkwoRjUBrnaHnijDJYcKf1tlDFjF
X-Google-Smtp-Source: ABdhPJwQV5hQSViTB/TcdBE4vtYE2CsMSC0ic/lA5AGomE7JF336tMBGTG/H4psobnqk+RIgItE7FclooWFBaTTeOuE=
X-Received: by 2002:a17:902:b098:: with SMTP id p24mr12097167plr.18.1595672984994;
 Sat, 25 Jul 2020 03:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200724171706.1550403-1-tasleson@redhat.com> <20200724171706.1550403-12-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-12-tasleson@redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 25 Jul 2020 13:29:28 +0300
Message-ID: <CAHp75VeRzY9wrLpEgi73p=7PEaG9N5iiBAuuys1nY6n4_arFCQ@mail.gmail.com>
Subject: Re: [v4 11/11] buffer_io_error: Use durable_name_printk_ratelimited
To:     Tony Asleson <tasleson@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 24, 2020 at 8:19 PM Tony Asleson <tasleson@redhat.com> wrote:
>
> Replace printk_ratelimited with one that adds the key/value
> durable name to log entry.

>  static void buffer_io_error(struct buffer_head *bh, char *msg)
>  {
> -       if (!test_bit(BH_Quiet, &bh->b_state))
> -               printk_ratelimited(KERN_ERR
> +       if (!test_bit(BH_Quiet, &bh->b_state)) {
> +               struct device *gendev;
> +
> +               gendev = (bh->b_bdev->bd_disk) ?
> +                       disk_to_dev(bh->b_bdev->bd_disk) : NULL;

Besides unneeded parentheses as Sergey noticed...

> +
> +               durable_name_printk_ratelimited(KERN_ERR, gendev,
>                         "Buffer I/O error on dev %pg, logical block %llu%s\n",
>                         bh->b_bdev, (unsigned long long)bh->b_blocknr, msg);
> +       }

...can we drop indentation level?

  if (test_bit(...))
   return;
  ...

>  }

-- 
With Best Regards,
Andy Shevchenko
