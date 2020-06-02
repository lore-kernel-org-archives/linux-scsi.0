Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62798C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C60206A2
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8cd4V5p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBLmz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgFBLmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 07:42:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEC1C061A0E;
        Tue,  2 Jun 2020 04:42:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l10so3045468wrr.10;
        Tue, 02 Jun 2020 04:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:in-reply-to:references:mime-version
         :date:content-transfer-encoding;
        bh=vjo6dgNKS2yqNivKUHaJ7wo9ZHvF45H5HmuT+8JqEzw=;
        b=M8cd4V5pvGvXVoqU9lc0ae1R1cCK0GgEg2kx8BruoKZGYkSDZFWQzGuHrPOnTUslJ0
         +hrNj0+RqdE4w301WuRu5VGtgHMx2x5AUJW1hL0ROIthLPDMgV2Zs5wqdiiYIBLdbhmZ
         EF/2KPrQ8S1WRiPv2tDl5nItW1QoNt67bWVR8+PTruvlcpnDExF44xGkDmt4mSolFEPh
         N6pUaSPk492eeFTak3334huxU0Na+2DzaM4W0k2+UVGzevnmZYdJ8noz8M0j5BTERxPv
         XFswA6DuVPu76sexGVOj4j3n8BnJ8n1VbKyq0jhrJr1jMYphIJxk9+Z9FjsmI121y1F4
         Cd9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:in-reply-to
         :references:mime-version:date:content-transfer-encoding;
        bh=vjo6dgNKS2yqNivKUHaJ7wo9ZHvF45H5HmuT+8JqEzw=;
        b=ErAAqwb+U9hWtNg5lpAwbuTQ1yL04gWzoXIn/InsNlvxw5bjV4meWDNZ26cC08l38U
         ZN863HIzvpRn6Xs7xPMWwJob6FAd0YfWnz711QpQUlkTHchqYdaGbTse9B+DZF0WOxxH
         uHq/u8rk3JnfB63DU1np4lvAestVGw/gz9BG6HyhBQWbL5QSZ6YkFIfRpiXG15j4S9ha
         TXe5qn0p1QdvALmGVFzUin54ZqSCoWKt6BNGhDpy9t+ZfipSH8LsMHIu8UwcBmmKzIXj
         HYrw7DjhpR+s7o2SAone6VlHUD2dNKTSzUdGW3lKmumO+ZzaVsut+cnB6GGXe6tbH1PD
         Rm0A==
X-Gm-Message-State: AOAM530MhiMpwV0/l1J4Tq9DHnWVXkVyuOPHac93S8Klv5p5vjspaWIM
        dmeSt/oynJlOYKK+VjP6ITY=
X-Google-Smtp-Source: ABdhPJxuupL8Nc79xhHSR99Ny8UrOD/NFOxd0/CwQJ6IJ6RvV9wE9gKTXDuy158h+0i7YHNwvgc93g==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr25373189wrs.127.1591098172996;
        Tue, 02 Jun 2020 04:42:52 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id x186sm3434922wmg.8.2020.06.02.04.42.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jun 2020 04:42:52 -0700 (PDT)
Message-ID: <43a81bce2159ccd290e5dfe4a69199f56c379ef7.camel@gmail.com>
Subject: Re: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer
 while memcpy
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
In-Reply-To: <SN6PR04MB4640741E1DC89A927F8A60A5FC8A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200531150831.9946-1-huobean@gmail.com>
         <20200531150831.9946-4-huobean@gmail.com>
         <SN6PR04MB4640741E1DC89A927F8A60A5FC8A0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date:   Tue, 02 Jun 2020 13:35:53 +0200
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi Avri
thanks review.


On Mon, 2020-06-01 at 06:25 +0000, Avri Altman wrote:
> Hi,
> 
> > If param_offset is not 0, the memcpy length shouldn't be the
> > true descriptor length.
> > 
> > Fixes: a4b0e8a4e92b ("scsi: ufs: Factor out
> > ufshcd_read_desc_param")
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index f7e8bfefe3d4..bc52a0e89cd3 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -3211,7 +3211,7 @@ int ufshcd_read_desc_param(struct ufs_hba
> > *hba,
> > 
> >         /* Check wherher we will not copy more data, than available
> > */
> >         if (is_kmalloc && param_size > buff_len)
> > -               param_size = buff_len;
> > +               param_size = buff_len - param_offset;
> 
> But Is_kmalloc is true if (param_offset != 0 || param_size <
> buff_len)
> So  if (is_kmalloc && param_size > buff_len) implies that
> param_offset is 0,
> Or did I get it wrong?

If param_offset is 0, This willn't get any wrong, after this patch, it
is the same since offset is 0. As mentioned in the commit message, this
patch is only for the case of param_offset is not 0.

> 
> Still, I think that there is a problem here because nowhere we are
> checking that  
> param_offset + param_size < buff_len, which now can happen because of
> ufs-bsg.
> Maybe you can add it and get rid of that is_kmalloc which is an
> awkward way to test for valid values?

let me explain further:
we have these conditinos:

1) param_offset == 0, param_size >= buff_len;//no problem, 
ufshcd_query_descriptor_retry() will read descripor with true
descriptor length, and no memcpy() called.


2) param_offset == 0, param_size < buff_len;// no problem, 
ufshcd_query_descriptor_retry() will read descripor with true
descriptor length buff_len, and memcpy() with param_size length.


3) param_offset != 0, param_offset + param_size <= buff_len;// no
problem, ufshcd_query_descriptor_retry() will read descripor with true
descriptor length, and memcpy() with param_size length.


4) param_offset != 0, param_offset + param_size > buff_len;// NULL
pointer reference problem, since ufshcd_query_descriptor_retry() will
read descripor with true descriptor length, and memcpy() with buff_len
length. correct memcpy length should be (buff_len - param_offset)

param_offset + param_size < buff_len doesn't need to add, and
is_kmalloc is very hard to be removed based on current flow.

so, the correct fixup patch shoulbe be like this:


-if (is_kmalloc && param_size > buff_len)
-	param_size = buff_len
+if (is_kmalloc && (param_size + param_offset) > buff_len) 
+	param_size = buff_len - param_offset;


how do you think about it? if no problem, I will update it in next
version patch.

thanks,

Bean

