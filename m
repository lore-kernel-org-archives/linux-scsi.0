Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3D8C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 09:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8BC208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 09:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GR8yi/LX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEHJJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 05:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgEHJJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 05:09:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D679FC05BD43;
        Fri,  8 May 2020 02:09:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id v12so956924wrp.12;
        Fri, 08 May 2020 02:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CSQz/16NegmLO3Gs8FCh+9dcNHGXLHCoCqOFnJP2G+8=;
        b=GR8yi/LXdeGsQgWazi5YgoPI44ntAvEEp50myty0g/zr60tzqOwbQuXbV9xjEMwqop
         XzfJUztkqlBb5L6JNW8rXKYDg1sw79+BTWCF5X/L+ReQhfgijoY1/YFf6NBII86gY78o
         lpep9+N5VeHOCRZEt/Rp1/dgaRt1Q0oT0409ooatHo3LozcVUgLujHz8J6IdHYYW4gY3
         k3nFvdDbGQrrvOOWDhLQcFYPCdx6Go9IFnjc5MjX1L+j8bmpnfbd7JAjhuDgsU1MSbl3
         RqvS0RRm8/FgPlPNxfrGV2FMnYsHg8IkylBUCsHLPkYo0fYBq6/+L637EU5xLS4UdOIN
         pyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CSQz/16NegmLO3Gs8FCh+9dcNHGXLHCoCqOFnJP2G+8=;
        b=JZEHVvxInjQZQlEVvDfHus+fmtzXXhXXHGOZ/Ek8T74UjSsmAjud5YrX+Y2yw3u/I8
         cuNNwb7odgQu2mVhLW7LPw4mYX3ruu6ahkzsKvFotdhJtBcbVyXdfC+PsCnF8c7UX4nj
         d7BwZAlzlZf6kIgEz4IjgxDBWgBswbcd0Nco+uK5JI/YU7T3ji9zLaCWty+GV5ivX6SO
         Ahg/bAXCkRVOUSyPGus+WfHAVERjydoPaFz7dtN82q/MN2BgeUoFjczAU3LyypXl48e1
         /9we5a+s3s/Fd5nR5zGI1Y9yQqEROIjqHGySikQQSFtQgaoPO5kA1d+FDBC4OorJku/E
         vgZg==
X-Gm-Message-State: AGi0PuYGHYxG4cAdFCjtsyeZTB9ccoWKPM8y+RVJz29IvQaRz1qnX4m/
        H4f7LJtdkv3zb6jw8TRLrvI=
X-Google-Smtp-Source: APiQypLdn9bkiOZTmbGDcIzznYL62b1js44tepFklBnkRp3CDVcUr6r/u45cKkffo/EVY8punplGzA==
X-Received: by 2002:a05:6000:8:: with SMTP id h8mr1867206wrx.372.1588928952614;
        Fri, 08 May 2020 02:09:12 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id f5sm1905389wrp.70.2020.05.08.02.09.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 02:09:12 -0700 (PDT)
Message-ID: <1e9dca38dba71b0a8437f752db5f97cab789af60.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 1/5] scsi; ufs: add device descriptor for
 Host Performance Booster
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, cang@codeaurora.org
Date:   Fri, 08 May 2020 11:09:10 +0200
In-Reply-To: <6d06ec34-04d2-93ff-1ff5-dc1317c3d060@acm.org>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-2-beanhuo@micron.com>
         <6d06ec34-04d2-93ff-1ff5-dc1317c3d060@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-07 at 17:59 -0700, Bart Van Assche wrote:
> On 2020-05-04 07:20, huobean@gmail.com wrote:
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 698e8d20b4ba..de13d2333f1f 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6627,6 +6627,17 @@ static int ufs_get_device_desc(struct
> > ufs_hba *hba)
> >  		goto out;
> >  	}
> >  
> > +	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
> > +		hba->dev_info.hpb_control_mode =
> > +			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
> > +		hba->dev_info.hpb_ver =
> > +			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] <<
> > 8) |
> > +			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];
> > +		dev_info(hba->dev, "HPB Version: 0x%2x\n",
> > +			 hba->dev_info.hpb_ver);
> > +		dev_info(hba->dev, "HPB control mode: %d\n",
> > +			 hba->dev_info.hpb_control_mode);
> > +	}
> >  	/*
> >  	 * getting vendor (manufacturerID) and Bank Index in big endian
> >  	 * format
> 
> Please introduce a symbolic name for the constant 0x80, e.g.
> UFS_FEATURE_HPB.
> 
> Please use get_unaligned_be16() instead of open-coding it.
> 
> Thanks,
> 
> Bart.
> 
> 
Bart
thanks, I will change them in the next version.

thanks.

Bean

