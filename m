Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53709C43458
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8967D22DA7
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fcm4hbV0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgHFKDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 06:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbgHFKCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 06:02:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3570C061574;
        Thu,  6 Aug 2020 03:02:23 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id bs17so15963907edb.1;
        Thu, 06 Aug 2020 03:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=acMvcXwcBtYuVO1z9M48ehd2KmaNhkmanOT5DecFSow=;
        b=fcm4hbV0mIupq6Ura/mLhD/DOSw0Muno0UEUr1h23NY7lfO4425p3RubEE+6LZGCOv
         U4eWSzvyUmDd9twx/WjZZCkSm/JBx43TrqrubefNLuwpN5PGA7V5ST/VQxNNSJN4vWRC
         1wGiyAsVhS+zEaOHmt78llB+pFx8PItTUS9VFdEcuBErwkWevMcIWRk+SR+Mw5m/U2rt
         nDoRpgS36shjRjhOdsl//DC+nCF7YjdaWHoTalr/hqhUpXaJV0Z5WUVBMPZjASX3XLYS
         1jJHfSVO6HvjrwWmZGXKcilqx1Oy73TEVqMK4bkUyrwSqJz8Kq2p7CZ+KFSgG5xGDD2e
         I1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=acMvcXwcBtYuVO1z9M48ehd2KmaNhkmanOT5DecFSow=;
        b=N55nLPfOH23FHfIhNjBrESMGi+Lm2gdo+yYf/br/XsGtKafs0EYlpf4gIuv0tCRmQE
         17TW/Sgdh4mfZ7jNqUGtqbqzppy5LDg6YwmpzG3YgsWaKEEdD08q5Idxmjmy0CNK0TGo
         E1J6YnRq5ZlIjkuVdxhsLn7Pwwum1H4WTaw97TkSTdSjAgFfqHx+tMFiyJmAIW6vHZ28
         GT6WxewPtg1ODhD8czKFqlo6mKYVai/QwZfHW6T1rPn4ZOgMDlLK4uoE6VNJpoiFeJdm
         qfUsKL8JtPSP+0NUVHCvJ8djNADpTgmWMonO3JCLHnY47FpRkRbiO3drsRxe08QmsJ9o
         MsPw==
X-Gm-Message-State: AOAM5337zlLLovGsOL9RHwrR6+H9oMN2bVIgTaIhpTsh5sP8A/fJM6zL
        4OOLHJlW3pnlDmDumPgqvuo=
X-Google-Smtp-Source: ABdhPJzwPfwKxoJyv2ZuVSzlGqJr3G+W4jzjeJ2TLOEologbczcQgS9xKnZPeUGONELkdNwDrAp35g==
X-Received: by 2002:aa7:c382:: with SMTP id k2mr3209558edq.249.1596708140320;
        Thu, 06 Aug 2020 03:02:20 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b906:f0c9:15b9:533b:62ba:b5b3])
        by smtp.googlemail.com with ESMTPSA id f20sm3332916ejq.60.2020.08.06.03.02.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 03:02:19 -0700 (PDT)
Message-ID: <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
Subject: Re: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
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
Date:   Thu, 06 Aug 2020 12:02:14 +0200
In-Reply-To: <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
         <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
         <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
         <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-08-06 at 09:56 +0000, Avri Altman wrote:
> > 
> > Hi Avri
> > what is your plan for this series patchset?
> 
> I already acked it.
> Waiting for the senior members to decide.
> 
> Thanks,
> Avri
> 
> > 
> > Bean
> 
> 
we didn't see you Acked-by in the pathwork, would you like to add them?
Just for reminding us that you have agreed to mainline this series
patchset.


thanks,
Bean

