Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFAEC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502B5206E5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbhASOhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387584AbhASJec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 04:34:32 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E881C061575;
        Tue, 19 Jan 2021 01:33:48 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id 6so27538006ejz.5;
        Tue, 19 Jan 2021 01:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IABaVdUYHRPsPlVF0/vawd3QW8nnC9cA4OeVAWdYtLE=;
        b=PIy+DGZ2JkAycV25VNA6uFUpYlhxHe++FXERzwkz3I+7Rw0aeWELb5mNYl5Lw66Vor
         VTmj3l2tCPjYAV7Z4i+HNEzlGh2JRqPAuf3JCNt4OB4YZK4TY/1vooAIEKM3WhvPERjQ
         s1fcvywcuWUc3hcWH0ldLODeL1m5jgHF6e3pfwI4uOgw62ahLVT0vAadNcE61l/zgmmO
         bvpbFhR/HflzuGDcVuyQ5mD6dB9VTE/KcW2geM/76dTH5Nxv08T9V66LYZ7AiHqBOVpc
         ezDnqI/9t5+MfUHuhoAt0R39xtV97SHtfKf6UYLwhHv3YCuPuB2SSPOrROby9KdjWkj9
         zxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IABaVdUYHRPsPlVF0/vawd3QW8nnC9cA4OeVAWdYtLE=;
        b=B5K9/YkXluzqa6GdfMaAk8vA4yOr9xcA6bKyaV2sJQoCd9PKgiyQcLnvxd9CUsEbfZ
         n3vspM2aXmi4kNZRXgY+ZhTZaXQlRl8ThwJb18NgxQBzVhIJ9hlSiqM8CYG6ngxc1rPy
         Vfm7diUHgn2TaDlTwqkHZSFK9Bu5zvCwEY0uAOWBca79Q8p6rRW6Mu6vODTHef9RRJiO
         Ewdq/uhLh0zXW/OPzV/IQjokeVhdMiuLA+sC/DmZDcr8xMzcqI4sMmWsJdOGkPHM069D
         ZmnMIvAFosxbknUXQbXuafDoi1Q/YjTKu3s0Kkdv7WYwXNGAQg/nqdHI2YxGxL5Xyq/f
         zbTg==
X-Gm-Message-State: AOAM532yrfPnP+HZ322yPYmLbEWfbqsk2dxS2mBaNhSV5lP4IB9+YivE
        A77/Kt2SR6oKaRUYFSX9A7M=
X-Google-Smtp-Source: ABdhPJyJ7thX7Z5Wg+GZ9AKvvlsD/6vaTO3z5yqKEHZ3ivZiMhirZcZbNXWhMvxwSczqRn37XMzKHg==
X-Received: by 2002:a17:906:2f83:: with SMTP id w3mr2543434eji.292.1611048826844;
        Tue, 19 Jan 2021 01:33:46 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id pj11sm7657845ejb.58.2021.01.19.01.33.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Jan 2021 01:33:46 -0800 (PST)
Message-ID: <fabf0e83387f6155efea521a15b00bb1225d35a4.camel@gmail.com>
Subject: Re: [PATCH v6 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 19 Jan 2021 10:33:45 +0100
In-Reply-To: <0a9971aa-e508-2aaa-1379-fb898471a252@intel.com>
References: <20210118201039.2398-1-huobean@gmail.com>
         <20210118201039.2398-2-huobean@gmail.com>
         <0a9971aa-e508-2aaa-1379-fb898471a252@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 09:01 +0200, Adrian Hunter wrote:
> On 18/01/21 10:10 pm, Bean Huo wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Currently UFS WriteBooster driver uses clock scaling up/down to set
> > WB on/off, for the platform which doesn't support
> > UFSHCD_CAP_CLK_SCALING,
> > WB will be always on. Provide a sysfs attribute to enable/disable
> > WB
> > during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable
> > UFS WB.
> 
> Is it so, that after a full reset, WB is always enabled again?  Is
> that
> intended?

Hello Adrian
Good questions. yes, after a full reset, the UFS device side by default
is wb disabled,  then WB will be always enabled agaion in
ufshcd_wb_config(hba). but, for the platform which
supports UFSHCD_CAP_CLK_SCALING, wb will be disabled again while clk
scaling down and enabled while clk scaling up.

Regarding the last question, I think OEM wants to do that. maybe they
suppose there will be a lot of writing after reset?? From the UFS
device's point of view, the control of WB is up to the user.

Thanks,
Bean






