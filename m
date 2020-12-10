Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFA5C0018C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A7423B45
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390298AbgLJUOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393646AbgLJUOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:14:14 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5211C0613CF;
        Thu, 10 Dec 2020 12:13:32 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cw27so6916046edb.5;
        Thu, 10 Dec 2020 12:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KXgO4GifdvzY6EhKipkwQ6+uBUGL6+vhzbZkboDddCA=;
        b=WmsNWNjivibe5aaYVi3xZhk05JAMwnMYDzjKOfG3LvdE40P1PgIFdeeiSC9NlI/gXW
         tvFxLq77dsSfc2htEPKcVgqtv+94wbByKlP0ykBO7ilSw6VQOiw9L/0eCcTGl4O9PEJE
         DxzZ/6NoenqqvfI3n7flqhrwjcn5LZ45Y0xbRMwc3QnpvSp863hHiDWpdZVDlIH9IKeU
         PqInxmeGuy+7Ky8JrP2+y7ERwQZsbBNA1ky5HSNaXs3VtAYDDmHpEFZzWRanyK4B7oFf
         7X9zOzNlahFR46VsZCWstPdnHGF9QTzhCl022C0ThMYbD9GIO8pOWmjw0KWzIk5ZblUn
         I3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXgO4GifdvzY6EhKipkwQ6+uBUGL6+vhzbZkboDddCA=;
        b=l8l3HIOd2G9LNLHYhesoD65akrUqqHBRxe5SFlGRd9qS8tVtvL0eI5YIc4TRWUMx0F
         05XiPT7GmAw5/PdEkt0FFp7RDhe3HjTjiEZtwq7dqBTTDdj131HFL2o3IiiLdvKKKElu
         RXynDGBRlr3otbgck7CfbsOZ5HuP85qRHBOliinJCOvLGPMy8T+dE/GU8BtKcoqqv1Z6
         6oZFhs6E9AmuOzexldnLTfowUje3x5Eq/1PLsRNoVyl0d49+1EpGu+mwAv0d70jKRLLr
         MYEKIiMBFPV8pQ6/sIaAIq50n92lMtv64KWCwxSmzJbi41Z+wnWacRUf5PHrkLiEDYdd
         tFGQ==
X-Gm-Message-State: AOAM530OEu34Ad+2ETB2n9nk54gKlEZKNmKK1JVApjZwo9FYumsNO8c8
        ZaejXPLfWL4dEJ5dXsu7uY0=
X-Google-Smtp-Source: ABdhPJxRfb7mJRY7H+1Ywg5Dj50h34zEA9dgeDxhpbwTdZCYglR+VIv5ypzNSfrnIgrsH4V8V5n1sQ==
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr8518860edb.365.1607631211331;
        Thu, 10 Dec 2020 12:13:31 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id m13sm6043570edi.87.2020.12.10.12.13.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 12:13:30 -0800 (PST)
Message-ID: <7542e8637f2eca65e87e74c34b2203a3fcd4bb80.camel@gmail.com>
Subject: Re: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
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
Date:   Thu, 10 Dec 2020 21:13:29 +0100
In-Reply-To: <DM6PR04MB657504D6828919BAB731B16DFCCB0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201208210941.2177-1-huobean@gmail.com>
         <20201208210941.2177-3-huobean@gmail.com>
         <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
         <c95e0518fd5c73dead0139054c04dda2243af620.camel@gmail.com>
         <DM6PR04MB657504D6828919BAB731B16DFCCB0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 07:46 +0000, Avri Altman wrote:
> > 
> 
> Right.
> But it is a small price, and you no longer need to worry about rare
> error event.
> Also adding an if (fWriteBoosterBufferFlushDuringHibernate == 1) will
> allow some more flexibility,
> e.g. shutting it off from user-space (ufs-utils), unlike today,
> that it is categorically on for all platforms / devices.
> 
> Anyway, if you decided to add new capability,
> Preferable to do it in a different series.
> 
> Thanks,
> Avri

Hi Avri
Thanks. This reminds me that ufs-bsg is a latent defect. Currently,
userspace can pass any raw UPIU commands to the UFS through ufs-bsg,
ufs-bsg is a pass-through channel. So,
fWriteBoosterBufferFlushDuringHibernate is not the only one in the
ufshcd.c can be changed by ufs-utils. any flags in the UFS can be
changed by user-space tool after UFS finishing its initialization.


This modification after the fact (Linux initialization/probe itself) is
not legal. I remembered we discussed this on the eMMC case, the same
with here that, user can change some parameters in the eMMC through
eMMC Ioctl, the user feels great, but they did a wrong thing.


Ulf Hansson: "I don't think it's worth to compensate and try
to act accordingly to cover cases when userspace has messed up."



thanks,
Bean

