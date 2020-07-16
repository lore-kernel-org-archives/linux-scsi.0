Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87296C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C472070E
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 08:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVb0tt/E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgGPIOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPIOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 04:14:51 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614B5C061755;
        Thu, 16 Jul 2020 01:14:51 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dm19so4074192edb.13;
        Thu, 16 Jul 2020 01:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=URRzOHpgQhWz8k04t/0LNtBaTy9pE9Bui1vrbzjXhfI=;
        b=WVb0tt/EfTDdAo45KwKGv38Dfqf342lj+5fwHbe13QL/aVMx/pb3b9BnsLBHhc0Zhk
         AjqG99PTVwKhCujQ2CSYgS709Pn7LoSNLuS9hSW+M+t8ZoPhKpsFqhUer9e9+Jqd7I/H
         GCUnZYnRDbLGOy7EqCI7p7Hin/1z8e3HS0HQIZvkiSlwu1h3ENirbu6bmDqaXFBMnR7K
         bmbNJFN0ZSh5aKeCNt59mGANr6lJWqKp2OuD5fGqaAbUnceWNjm0KnZOVvfgb8tf+WiV
         sT12rEWdQizRb2zmEjOrCEyGTlw1uw5dGEC55g2kxs8fB3o4JDqbCVtfa6InSmAxVdqL
         r9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=URRzOHpgQhWz8k04t/0LNtBaTy9pE9Bui1vrbzjXhfI=;
        b=A4otV2+2HXfU4W3z7Yjy5X0zpzUNLj6OR9JrAdLsASctZstmd69B/eEcMfuIjI2vgH
         QuezpX29pSAZeXJip3TVXjl0uX3iG0Ek/1ZO9HTishVc/+t08H5wb14LxWZAUxkJ4Lef
         yHxEs4uug1y7Pi1A9QEzN94y75LfCwtKZu/T9f6KWf/E0dDuOHJuJBTJAIYHA8k2XQ7M
         E/RFVQPLiqUHwX1hjsYnrC7gdCK0G+S5m350GXemO/QIPP0hP3nOmCN4ZDcUNy5cBVz2
         jwB25vrQNDjNUGxKlAXrisTO0MAXBhDNljiTTzgWBLpDV+uwjE+YSuCUSUlmEfa7IJRu
         KExg==
X-Gm-Message-State: AOAM533YSNIyvIp015WEwxuXnrtLkbh+zrf7pt6J7a5DsIKkhNuLuT+x
        MnZvNB4FUjEtji5udTnDZzY=
X-Google-Smtp-Source: ABdhPJz2NfjKkfIn121rroaSFZGypqFhApaC3QZcXmHorYPN8Rbhf4pdLTQrbLvgwzLOJ18E36qxww==
X-Received: by 2002:a50:e801:: with SMTP id e1mr3272873edn.251.1594887290101;
        Thu, 16 Jul 2020 01:14:50 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id lm22sm4213084ejb.109.2020.07.16.01.14.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jul 2020 01:14:49 -0700 (PDT)
Message-ID: <0e2aaef299235c224051b95793c5e89c3820b1eb.camel@gmail.com>
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Thu, 16 Jul 2020 10:14:35 +0200
In-Reply-To: <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
         <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
         <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-15 at 18:34 +0000, Avi Shchislowski wrote:
> Hello All,
> My name is Avi Shchislowski, I am managing the WDC's Linux Host R&D
> team in which Avri is a member of.
> As the review process of HPB is progressing very constructively, we
> are getting more and more requests from OEMs, Inquiring about HPB in
> general, and host control mode in particular.
> 
> Their main concern is that HPB will make it to 5.9 merge window, but
> the host control mode patches will not.
> Thus, because of recent Google's GKI, the next Android LTS might not
> include HPB with host control mode.
> 
> Aside of those requests, initial host control mode testing are
> showing promising prospective with respect of performance gain.
> 
> What would be, in your opinion, the best policy that host control
> mode is included in next Android LTS?
> 
> Thanks,
> Avi
> 

Hi Avi
IMO, no matter how did the driver implement, if you truly want the HPB
host mode driver you mentioned to be mainlined in the upstream Linux,
the best policy is that you should first post the driver in the SCSI
maillist community, let us firstly review here. I didn't see your
driver, I don't know how to provide the correct answer.

Thanks,
Bean



