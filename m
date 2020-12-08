Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F6FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7302223B26
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgLHVnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgLHVnR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:43:17 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100F7C0613CF;
        Tue,  8 Dec 2020 13:42:37 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id dk8so16277770edb.1;
        Tue, 08 Dec 2020 13:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h4DTYQeYJg/FEdSffrAfQrBpakqJmGcXZl/saAgMsOQ=;
        b=stfm1gSfOfW8hHFXQ8m4sFhxzfgIuQ/abOjFm1uASl+qgNli4eT+noBozuz6JdOAIF
         TdPIQCxFFp4O9qW7trBdflCeYa+QZT9JKmpoPYx0SmWbpQAclCusAFM+ZlSNPYZSh3K2
         wGnjjTz0WIZMtahb0/yRirP2p+d8HLbd2if5xi6fxf0xvP/RySVQo2N6bNtrsKcuT3GH
         GAIK4fL6uTtSAPua56csAIYssOCmwq+vW5iWEhVPlZEW+szhQCWnJEBDg3No1A/RRrAa
         f4z8tkitbfrlO2rROm+TqqAoIJKMO93Rj0MhTvvQqoRn+n/JNl0MYOLk8a6ffrCR7jkF
         YyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h4DTYQeYJg/FEdSffrAfQrBpakqJmGcXZl/saAgMsOQ=;
        b=eFDjHRsQKchTi/zz0sC56v1xlTysnOXY4uV8ZvgHsuuMdD4efkmdvqCGnQBgtR/RUe
         TBARcrJcqPp8an/oBMW17inZM1An5/k7OxrZddkq0LG7YDXYbvoiqXPlXM2/jXe8pMVo
         gC/gR9O+p7dJCxPJdzWgawbuCe3JejNmlLZDqBkFDMzxORF8B/l4zvJauZBPRdbGQ2ph
         gNIXeT2OwyzBRUxdXY0InyTXlHQ1sx4Z3gT0c09VwrQMprfIyJ7hizq7CjN6tuTpPD8O
         J5dFDeJAIuFw5Ef1WaVo2IW7OyObzo4snJYfq1ilRDJ97dIzrH1x3eSvOxCu2tkWmRvL
         D9eQ==
X-Gm-Message-State: AOAM5305gO7lrk0cm0rwlAroXlgpyMfyVzcq3ySj4hfGnX78l73JdlcM
        8soWsEHQ3qpdNVQ4YRxij99GSfZEFYY=
X-Google-Smtp-Source: ABdhPJyk9Orzh1gsZjqIsfwIJ6a7JF3GX86Jsk2PJaT+iQ3VuRy6mAr+7NsFCGVHEF+AwL3G/jQw8g==
X-Received: by 2002:a50:ccdb:: with SMTP id b27mr23337edj.20.1607463755817;
        Tue, 08 Dec 2020 13:42:35 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id c25sm16974995ejx.39.2020.12.08.13.42.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 13:42:35 -0800 (PST)
Message-ID: <ff0d08c891d22ddcd09edb87b82881eeb6cee19f.camel@gmail.com>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Date:   Tue, 08 Dec 2020 22:42:34 +0100
In-Reply-To: <DM6PR04MB65757385EE651DBAAC468BD1FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
         <20201206164226.6595-4-huobean@gmail.com>
         <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
         <c4333f6ad6172d991f6afdaea3698c75fb0f7c36.camel@gmail.com>
         <DM6PR04MB65757385EE651DBAAC468BD1FCCD0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-08 at 08:35 +0000, Avri Altman wrote:
> > didn't differenciate them. we take all of these as CDB. This is
> > wrong.
> > 
> > I want to make it clearer and make UPIU trace in line with the
> > Spec.
> > what's more,  how do you filter OSF, TM parameters with current
> > UPIU
> > trace? you take all of them as CDB? if so, I think, it's better to
> > change parser.
> 
> Indeed, it is just a small change, but breaking user-space is not an
> acceptable approach.
> Also, the upiu tracer was never meant to be human-readable: it just
> dump the upiu,
> Which contains all the info required to parse it anyway,
> So breaking user-space just to making it more readable doesn't really
> make sense?
> 
> Looking at the previous 2 patches of this series, I was hoping that
> you will do the same for
> Command upiu, as well?
> Again - same comment: if you are doing that need to change the str
> not to break current parsers.
> 
> Thanks,
> Avri

will not change original CDB format, just add new OSF, TM.
the string format will not be change. The current the HDR and CDB in
the send and complete trace are the same, I guess, you even didn't
trace CDB in your parser, they cannot tell you the request execution
result.

Bean





