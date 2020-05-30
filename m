Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAB3C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73DD420721
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWOOuwFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgE3Si2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 14:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbgE3Si2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 14:38:28 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF06AC03E969;
        Sat, 30 May 2020 11:38:27 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so5291890eje.13;
        Sat, 30 May 2020 11:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YwliNzdV3H/Ve6pKeZGydt7jOsfeEsBTpzoW3tVwaJQ=;
        b=lWOOuwFmWJQupZWqy0PetRo8YdXBhV8jNPiIY/7l5qI+mucX2wiFQJdPulL8YiKP9v
         XfO6a9yDrN2ne80QRS5YdGOEtjSTnybDJPjp1m5/urChuqPahnclEksjS/3MZDnyUPHu
         BoiyAm1eFkcOUr5tfKP72vMxtitaDtoZzQ/PE5r6WC3aa+EqHS2hr95jw/YoCq9wnqtL
         i5EETv5y4n0MQpCFbXaJiGnBbLCidR966goRRPC5jdfMctGjjO+Hhlf6sHVFgdkcRs8t
         vSrltKkLME7lfjWMW1x4JWayVgRGu77lhBUZ8Tt4y4aHK1VG7+sQ09+2bXwyIReheuiK
         8y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YwliNzdV3H/Ve6pKeZGydt7jOsfeEsBTpzoW3tVwaJQ=;
        b=nvZHH2yK4NgQlGmtA8tKj5e0D+hgNX//VV00gmhau/8ePr3LiYUD99vEWerNjl+fYP
         wxfp+WaGJ79VpB97I/BzrF/Ef7l0/IEDq/Bf3weK0v/mYIhJEuE1GSzsj6qdmOSblV2E
         kK/LKLGVEumbR82AqBvviuNdJ5mcNz4oo3X79/WoLbocszE4yZ7FoVC/HbvzdQLNhXrc
         4cyUNQfhN9S7VjQDCSJP6MFqOS63GSeC4xhqHTx79XGm3EYJ+ZeZvQv0V7zCvE3S7QhH
         AxMGBAv2w7anh5+sEjAT6kPSSunZvAT5fFLVtlwgw35i1MH2HHMY/SjkaZ9rk45SHo0O
         aTfg==
X-Gm-Message-State: AOAM533jcE+xWVxJ9v5UWVvMFc80Js10TPNI26s9cR3vGVKNCfEhI8Xm
        BKyif/ceJK08ZG18bqc9zM8=
X-Google-Smtp-Source: ABdhPJz9uSOGAh/6za7XAH2706SP8tCfgYhMqmG1ehV3tuAQjOPW96+4IVmDopZs38sCIIKccrgefw==
X-Received: by 2002:a17:906:35cf:: with SMTP id p15mr12572312ejb.520.1590863906355;
        Sat, 30 May 2020 11:38:26 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.googlemail.com with ESMTPSA id v13sm4570519eja.55.2020.05.30.11.38.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 May 2020 11:38:25 -0700 (PDT)
Message-ID: <b028d1f8364a9180a36d6c80cc560ad1886bb898.camel@gmail.com>
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
Date:   Sat, 30 May 2020 20:38:24 +0200
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

Hi Avri
thanks your review.

On Sat, 2020-05-30 at 06:37 +0000, Avri Altman wrote:
> > -       case QUERY_DESC_IDN_RFU_0:
> > -       case QUERY_DESC_IDN_RFU_1:
> 
> You forgot to check that desc_id < QUERY_DESC_IDN_MAX

I deleted it since I saw the caller has checked this.
I will add back.

>  
> 
> > +       if (desc_id == QUERY_DESC_IDN_RFU_0 || desc_id ==
> > QUERY_DESC_IDN_RFU_1)
> >                 *desc_len = 0;
> > -               break;
> > -       default:
> > -               *desc_len = 0;
> > -               return -EINVAL;
> > -       }
> > -       return 0;
> > +       else
> > +               *desc_len = hba->desc_size[desc_id];
> >  }
> >  EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
> > 
> > +static void ufshcd_update_desc_length(struct ufs_hba *hba,
> > +                                     enum desc_idn desc_id,
> > +                                     unsigned char desc_len)
> > +{
> > +       if (hba->desc_size[desc_id] == QUERY_DESC_MAX_SIZE &&
> > +           desc_id != QUERY_DESC_IDN_STRING)
> > +               hba->desc_size[desc_id] = desc_len;
> > +}
> > +
> >  /**
> >   * ufshcd_read_desc_param - read the specified descriptor
> > parameter
> >   * @hba: Pointer to adapter instance
> > @@ -3168,16 +3105,11 @@ int ufshcd_read_desc_param(struct ufs_hba
> > *hba,
> >         if (desc_id >= QUERY_DESC_IDN_MAX || !param_size)
> >                 return -EINVAL;
> > 
> > -       /* Get the max length of descriptor from structure filled
> > up at probe
> > -        * time.
> > -        */
> > -       ret = ufshcd_map_desc_id_to_length(hba, desc_id,
> > &buff_len);
> > -
> > -       /* Sanity checks */
> > -       if (ret || !buff_len) {
> > -               dev_err(hba->dev, "%s: Failed to get full
> > descriptor length",
> > -                       __func__);
> > -               return ret;
> > +       /* Get the length of descriptor */
> > +       ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
> > +       if (!buff_len) {
> > +               dev_err(hba->dev, "%s: Failed to get desc length",
> > __func__);
> > +               return -EINVAL;
> >         }
> > 
> >         /* Check whether we need temp memory */
> 
> The first time we are reading the descriptor, we no longer can rely
> on its true size.
> So for this check, buff_len is 256 and kmalloc will always happen. 
> Do you think that this check is still relevant?

you are right, I will delete this redundat code.

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
> 
> 
> > @@ -3209,6 +3141,9 @@ int ufshcd_read_desc_param(struct ufs_hba
> > *hba,
> >                 goto out;
> >         }
> > 
> > +       ufshcd_update_desc_length(hba, desc_id,
> > +                                 desc_buf[QUERY_DESC_LENGTH_OFFSET
> > ]);
> > +
> >         /* Check wherher we will not copy more data, than available
> > */
> >         if (is_kmalloc && param_size > buff_len)
> >                 param_size = buff_len;
> 
> And here, we might want to update buff_len to hold the true
> descriptor size,
> Before checking the copy-back buffer.
> 

yes, buff_len should be updated here. will change it.

thanks 
Bean


