Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF25C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B15520801
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cn4FkR6n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgEaPLv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 11:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgEaPLu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 11:11:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB9C061A0E;
        Sun, 31 May 2020 08:11:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z5so6830901ejb.3;
        Sun, 31 May 2020 08:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qmyo/X6VyM6B0p3Oyzj8ZuaBZb1ZMqKAyygqVhv3TYY=;
        b=Cn4FkR6nLqCH9bdug4xsWLWFjLEptyie0SPoXp7+xXPEJgay48RckfPgTjZ5yAUhhp
         RLyjDGOkRikWF12WN9s4s+W4etR7qSL/e1h24sf9wVF83utnKlDBclkVbn7NIxX+0lsW
         EiiZkmrdF4pU+ScVAioEv5WXgiJee8/VabRULZu/R41CUCQvm0k2qdBc4fskfl8JQpkr
         1E/znehBjKdhwMJTHnVTBMOrXQGKuc5+jfXPM0NLTCAuLhNEf2d/M6ekpyUvYuNh1Ah4
         sKxMRYXw/slKGtDgzvCtJOI5gteUVY/q2rPmXQ01wGJZnn8gc36aUGuexOczdlyDNyYK
         whKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmyo/X6VyM6B0p3Oyzj8ZuaBZb1ZMqKAyygqVhv3TYY=;
        b=SPWb+viiph+gP/5+2zNzGebKf4WI1D2m4S1uXKye3QW3zSzBe7m+EvlHmndWvDwlRR
         Bz2acTYyGhV12hrsUWyLUQOralRw4Cr3jGUnYaSp4F0hJ8OKJ+vu0XMFrBrFpEYxDAhW
         Ric1KPXb7v9RYWiufIMQB0PrSLlTUFkLtyfBu3FU8lo+2myfwhM44YBpqhD2LgRFAY36
         08ppM2wljV7zTkFEgHG08OnKvo6C+43TK1KRdTPtTDCXcbi6H7UBhQPeruK/t4yH5QIL
         ZSpelXpYBmSEbPonS/IOyJQPKop3Vxh1WhxrqbpMWuZb+Bd2Ynjb+swYMbtsGrjRYor9
         +6vw==
X-Gm-Message-State: AOAM531n3dlbpSGxKXIBjo7iasn2LdjIBRwHNgjLjMJ3+1jb6pHdQVIC
        wJ4m4Xaju0pCf9Af37ec9MQ=
X-Google-Smtp-Source: ABdhPJwRVLZVbTZgwsAlntdh7babzGIhoc51394m6EBqdQ/YFUEk9QudbPPCXiTvfFSpjNAA1l2GvA==
X-Received: by 2002:a17:906:a44:: with SMTP id x4mr5929322ejf.237.1590937909059;
        Sun, 31 May 2020 08:11:49 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.googlemail.com with ESMTPSA id ld9sm12580892ejb.30.2020.05.31.08.11.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 31 May 2020 08:11:48 -0700 (PDT)
Message-ID: <3329e7ed6714cd86ec91cca96e5980da1df11f11.camel@gmail.com>
Subject: Re: [PATCH v4 3/4] scsi: ufs: cleanup ufs initialization path
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sun, 31 May 2020 17:11:46 +0200
In-Reply-To: <SN6PR04MB464078AE07966E53FFB237F5FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200529164054.27552-1-huobean@gmail.com>
         <20200529164054.27552-4-huobean@gmail.com>
         <SN6PR04MB464078AE07966E53FFB237F5FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-05-30 at 06:37 +0000, Avri Altman wrote:
> > +       /* Get the length of descriptor */
> > +       ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
> > +       if (!buff_len) {
> > +               dev_err(hba->dev, "%s: Failed to get desc length",
> > __func__);
> > +               return -EINVAL;
> >          }
> > 
> >          /* Check whether we need temp memory */
> 
> The first time we are reading the descriptor, we no longer can rely
> on its true size.
> So for this check, buff_len is 256 and kmalloc will always happen. 
> Do you think that this check is still relevant?
> 
> /* Check whether we need temp memory */
>         if (param_offset != 0 || param_size < buff_len) {
>                 desc_buf = kmalloc(buff_len, GFP_KERNEL);
>                 if (!desc_buf)
>                         return -ENOMEM;
>         } else {
>                 desc_buf = param_read_buf;
>                 is_kmalloc = false;
>         }

Avri
I found this checkup is still needed since LU descriptor read will
multiple enter this function. so I didn't delete it in the new version
patch.

thanks,
Bean

