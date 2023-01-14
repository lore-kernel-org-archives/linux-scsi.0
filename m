Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6A0C3DA78
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 07:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjANHMv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Jan 2023 02:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjANHM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2023 02:12:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167F2C13E1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 23:11:31 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cx21-20020a17090afd9500b00228f2ecc6dbso3043124pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 23:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1hhoYOhdFd/1XWBMyQAS/0V7h4xRZx/EixJ0JzHFu+g=;
        b=s/rwqXRQRrL287PIModN2dUSPDh/Rdn5QjNd5Xp+Axm/oMwq7OfgSfuDuisdK92Hq5
         MTLo1kefENmoT+Q58au/HYoJ7/OhtfVipv0+5dmgr8+c4+Q7Hvxbxjsj+5nOA0MLeWVN
         DZR+h96VSYYvWFA2l9s8uXTAmA8dvCNTT6eoE8OZ4jbckdImpMl0O4UCDnMxY3h9cCNC
         6rOTpmW/MGaeggiUS23KBUei63wgqnewzos/1PZYDzseOX5DojemX+yAlGmZW6kx2Hok
         3qYLB75spkgntclw0xXCtIluVmHzwlWYz9Gx4TPqTBOz1t/vZa0Xd/p/WDU0cOXB9M7d
         THVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1hhoYOhdFd/1XWBMyQAS/0V7h4xRZx/EixJ0JzHFu+g=;
        b=zJzmYR52xgDLkd84GTeT1YkdWEz1rrDlcN3XLar2caYqaLpF+ewzgadv6/+XCLoYAt
         khGp1GkHx5qV4LMbF6R+N8smPFvsSP9BNhVi0bEDrb9Nn+kEehH+2mIuMmRFzZnkrLeF
         lYLyp5QFMVJDcI9I3Ulxa8sBbsoXMa3DUZySsgOjoP6PvGz+R7x66qy4yCsbhZsDlrOz
         36eg44NrFVXnuKR18mhrbiYsX3jsmF5EFxL8htNUKgBkggn4QpJrpxKWg8cOvUrceeWE
         Fp3DKc7MFYkR0WrgvKLWSqf0Eqjxu2FkYiAwX+u9wiclAY4qJHqMggutG37jgNLOJdyP
         rafA==
X-Gm-Message-State: AFqh2kq4sU7AoJiuorLcQzWvA5rn1y15YfQkWf1TvJWfje8+pVQNxxnw
        fznZHc5EmebObX7HLxPjHP2I
X-Google-Smtp-Source: AMrXdXuRiszNGrahdiih775tFedEbPuYrEDVDujrhEjX5i2q3iO2KN2NrvpKq7SntYHOH003BwajVw==
X-Received: by 2002:a17:902:e5cd:b0:192:9140:ee76 with SMTP id u13-20020a170902e5cd00b001929140ee76mr86976458plf.37.1673680290585;
        Fri, 13 Jan 2023 23:11:30 -0800 (PST)
Received: from thinkpad ([220.158.159.156])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b00192d9258532sm15316913plh.150.2023.01.13.23.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 23:11:29 -0800 (PST)
Date:   Sat, 14 Jan 2023 12:41:24 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, quic_cang@quicinc.com,
        quic_asutoshd@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, dmitry.baryshkov@linaro.org,
        ahalaney@redhat.com, abel.vesa@linaro.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org
Subject: Re: [PATCH v5 00/23] ufs: qcom: Add HS-G4 support
Message-ID: <20230114071124.GA6992@thinkpad>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
 <Y8BNQZ/CFljuxsSL@matsya>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8BNQZ/CFljuxsSL@matsya>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2023 at 11:41:13PM +0530, Vinod Koul wrote:
> On 22-12-22, 19:39, Manivannan Sadhasivam wrote:
> > Hello,
> > 
> > This series adds HS-G4 support to the Qcom UFS driver and PHY driver.
> > The newer Qcom platforms support configuring the UFS controller and PHY
> > in dual gears (i.e., controller/PHY can be configured to run in two gear
> > speeds). This is accomplished by adding two different PHY init sequences
> > to the PHY driver and the UFS driver requesting the one that's required
> > based on the platform configuration.
> > 
> > Initially the ufs-qcom driver will use the default gear G2 for enumerating
> > the UFS device. Afer enumeration, the max gear supported by both the
> > controller and device would be found out and that will be used thereafter.
> > But for using the max gear after enumeration, the ufs-qcom driver requires
> > the UFS device to be reinitialized. For this purpose, a separate quirk has
> > been introduced in the UFS core along with a callback and those will be used
> > by the ufs-qcom driver.
> 
> The series lgtm. This fails for me to apply though due to other patches
> I have picked up.
> 
> Can you please rebase the phy patches and send those 
> 

Done!

Thanks,
Mani

> -- 
> ~Vinod

-- 
மணிவண்ணன் சதாசிவம்
