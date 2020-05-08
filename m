Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2074CC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 09:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C52208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 09:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q4C6RqS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEHJPs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 05:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgEHJPr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 05:15:47 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19371C05BD43;
        Fri,  8 May 2020 02:15:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so1010698wrt.1;
        Fri, 08 May 2020 02:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Lv9uDjkppOStZ32t12pHufk6Qwcf3rJNdN9DkJLtNs=;
        b=Q4C6RqS8kQEgDF388uxPXhT9ittdOv1qUOdQCseeggDd3P1mdS0YI1XcBfoKmPHZJZ
         JAro9bLcqafl5B1Z3/GS9w5T98klSaZ0+OZv+cBnsj8wMTf4QKrXDfXv2+h4Cv5swSn6
         kTXvHSx4Bgm6lMn2domzoAHBKziY65pEgt5j+1rHvi4KjhfnwIbOH82Ch6J8inL85Kou
         24oezoa91tGzxK2pT/5CRoOIAknw8nqQhyU1pmyn7rxePXkwwcW3+hLN6XSjCyGteaFz
         Nu/vwa2jInHDFQcF50v39fJyOU2Izf4/TJg3b8HrUtKoPUIQxhQrC/ND/qJ/67OKT+RX
         vMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Lv9uDjkppOStZ32t12pHufk6Qwcf3rJNdN9DkJLtNs=;
        b=DP6K1D8lBTUehPizSXV/oUlQSJELIUM9Gj4TMx0NSu13pGnQFGqL+pQD8ch45S+7uS
         64HWAe4ZJoCZHB8m5zPTiNMqMyLD+x5uiTaIBZdQCtAsC4fkZAN1Fbz7H8Y8+1yhUw0a
         3bcqmp4Ui6uVLuCqsOcuOTRqZWC/+/F6KvSJjELyMd575e+OV0g4Df4aQWbz7ZN3xJ+u
         G2AZO7e6MGZIC9L/9Fea4L6zQUN3XSAA/PxwbF9Dh0fVaOGJBEa6Q8AZL8Mkh4t69fdV
         bqudKNo068BHCo4i4HuZwExmOBYT3ILNTVdXPU13C2qxM020KaytowPESoGdxDP/LHSg
         OqyA==
X-Gm-Message-State: AGi0PuYJBYWccGiEA60jmUSLIZfDlB/KGEVyMmBH/UU/4f9nlUF1GaaA
        rDFP0Jyn99eYY8Umw8S//Hk=
X-Google-Smtp-Source: APiQypI8iRDyNW3+5pqpYL/X6MMNvNummNPHl5B4YO3SDsgdxj7szMC8GkFOMgQ0BPLgkkqGgW4VMQ==
X-Received: by 2002:adf:d841:: with SMTP id k1mr1770183wrl.129.1588929344877;
        Fri, 08 May 2020 02:15:44 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id n18sm1906356wrw.90.2020.05.08.02.15.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 02:15:44 -0700 (PDT)
Message-ID: <5a88c8a33e77ea2fc086cfbf1aeb1c0b3b6843c2.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 3/5] scsi: ufs: add ufs_features parameter
 in structure ufs_dev_info
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, cang@codeaurora.org
Date:   Fri, 08 May 2020 11:15:43 +0200
In-Reply-To: <f3485a4d-dadd-423a-e186-7736c3bfe5f1@acm.org>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-4-beanhuo@micron.com>
         <f3485a4d-dadd-423a-e186-7736c3bfe5f1@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-07 at 18:02 -0700, Bart Van Assche wrote:
> On 2020-05-04 07:20, huobean@gmail.com wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Make a copy of bUFSFeaturesSupport, name it ufs_features, add it
> > to structure ufs_dev_info.
> > 
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > ---
> >  drivers/scsi/ufs/ufs.h    | 2 ++
> >  drivers/scsi/ufs/ufshcd.c | 2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> > index 53a5e263f7c8..1f2d4b4950b8 100644
> > --- a/drivers/scsi/ufs/ufs.h
> > +++ b/drivers/scsi/ufs/ufs.h
> > @@ -543,6 +543,8 @@ struct ufs_dev_info {
> >  	u16 hpb_ver;
> >  	/* bHPBControl */
> >  	u8 hpb_control_mode;
> > +	/* bUFSFeaturesSupport */
> > +	u8 ufs_features;
> >  };
> >  
> >  /**
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 83ed2879d930..1fe7ffc1a75a 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6625,6 +6625,8 @@ static int ufs_get_device_desc(struct ufs_hba
> > *hba)
> >  		goto out;
> >  	}
> >  
> > +	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
> > +
> >  	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
> >  		hba->dev_info.hpb_control_mode =
> >  			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
> 
> Since this patch touches the same code as patch 1/5, please merge
> patches 1/5 and 3/5 into a single patch.
> 
> Thanks,
> 
> Bart.


Bart
you have addressed this in the V2, sorry for this fault.
I will merge them in the next version.

thanks,

Bean
> 
> 

