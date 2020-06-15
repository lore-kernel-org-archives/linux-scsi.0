Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D32C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 13:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A802074D
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 13:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5VTwYE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgFONJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFONJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 09:09:42 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CE2C061A0E;
        Mon, 15 Jun 2020 06:09:40 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y17so17034677wrn.11;
        Mon, 15 Jun 2020 06:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2hNGEnaVoQal93lbWY/52qr5BHwkcMyXt4V9L1ZazME=;
        b=G5VTwYE05Hk6xTerY0UHALfQgUm4ZA9zNF43JDgzQzmX7a9vFtFm/DNZWQKBTHuV/v
         T9fa23JAS7/fngxzS4BlWqvX5QustnRT6M4McOPfpP7jIAMgFHp0AJb1V7G9Uco3qjZE
         CvFR56tzw08bxyI+g35zy0Z0Rk5y2vJv3Z6TWhtXeh1RJlaAuHldcoHUNPSCYRdE6mq9
         BlB6n7uE2H1Jj7mnAf25mo7xISovDdlaot4t1h+hl4u7fUmLPyzVK3I4nX9OXC6ByRsn
         vIXebOCAVv/3Vm/Ou1uIKZ2ApFfFf40qTyyla/F41iyBGFmkNcPj1xQVC4PsXn5RMMPt
         NPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hNGEnaVoQal93lbWY/52qr5BHwkcMyXt4V9L1ZazME=;
        b=qplgHj0Mb68ze5fh0sxChH4ZyxUL9guogFAaZhfulqU6tWGmuddT7jcDXiOkR8/b42
         Yd7ASQgFtDTQf4/zRUjLqh8QH/gR0mSh27lrHKMElqq0JSq5Ia2hCtCAaj5pPOrc6GeO
         BR/T/3YsJAmR7jABYPhv6c6K9UsIkqvJDNSlQRsn1Jv4tYdNzt58OnN+CQOcOX7cDNYN
         YHsmuz7yvyH4WBGH7J4tNe4/Pz3yjp827KE2iiJ3+sp1MNXEHv0VCzlEguCym1OAtmqr
         RPUb76YlUmFbPl7la4+kf8vucW87F1F5eO3PMTUrRIl2qCxAxXmd2NOLg91zJDhJi1iQ
         BnHQ==
X-Gm-Message-State: AOAM531/vuZvBvbcMccn/k4sEAlyEQd5ZdmntzjEmFKASgQqFnO+lKnS
        kp4JEZdR2fjmrdWXGHETGTI=
X-Google-Smtp-Source: ABdhPJzkAkLa4121RL9RP4yPu1ORGLEtaYbRqL3TLPlEw210EC99TJLJBc7JAC3sCZA2Z/uibPSA3Q==
X-Received: by 2002:adf:f245:: with SMTP id b5mr28026570wrp.303.1592226579595;
        Mon, 15 Jun 2020 06:09:39 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b10e:413b:41dc:307c:ea47:9556])
        by smtp.googlemail.com with ESMTPSA id s2sm21459716wmh.11.2020.06.15.06.09.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 06:09:39 -0700 (PDT)
Message-ID: <47dcc56312229fc8f25f39c2beeb3a8ba811f3e9.camel@gmail.com>
Subject: Re: [RFC PATCH v2 2/5] scsi: ufs: Add UFS-feature layer
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Mon, 15 Jun 2020 15:09:28 +0200
In-Reply-To: <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
References: <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
         <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
         <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p8>
         <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Daejun

On Mon, 2020-06-15 at 16:23 +0900, Daejun Park wrote:
> +void ufsf_scan_features(struct ufs_hba *hba)
> +{
> +       int ret;
> +
> +       init_waitqueue_head(&hba->ufsf.sdev_wait);
> +       atomic_set(&hba->ufsf.slave_conf_cnt, 0);
> +
> +       if (hba->dev_info.wspecversion >= HPB_SUPPORTED_VERSION &&
> +           (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT)) 

How about removing this check "(hba->dev_info.wspecversion >=
HPB_SUPPORTED_VERSION" since ufs with lower version than v3.1 can add
HPB feature by FFU, 
if (hba->dev_info.b_ufs_feature_sup  &UFS_FEATURE_SUPPORT_HPB_BIT) is
enough.


> 
> +#define HPB_SUPPORTED_VERSION                  0x0310



Thank,
Bean

