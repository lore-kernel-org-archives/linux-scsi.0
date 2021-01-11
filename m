Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C914C433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514A2216C4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbhAKI0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 03:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbhAKI0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 03:26:35 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04200C061786;
        Mon, 11 Jan 2021 00:25:55 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so23523066ejb.3;
        Mon, 11 Jan 2021 00:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CSC3aRVO5ZxUUnNQTzCtcTLTQwLce1l3eFEfXxrgFOw=;
        b=A2QvxSj9cFoYe4LJJ0kyiWaOHT0y7JE2caRSNBaF8CGkO1ZiOerMPSDmrdxmEych4L
         pSZ4tWSYaaZcD3t33/VdIDRg8RAQ7zDYgoKg4K/dJSAe0v/Xvf1elYapiTEo1FuzhYfn
         EoyoKZHQtEyzhHAG+7eyakLFamulxVJPKw107KnhqL+PmnLeV+IDKB5X93MghGuHDcD+
         f+zyX+2eJM8E4WN5GkJ5o9Mmv+E5SBZP1Xw0QgBkNBXFbQB7UiuHdrj23sOvvwtw1uw+
         /1Lcz0xsuoue3xeC1weF6AXtG2WLUuGusAKLGKAHdbsziJWIpfcijqlPXo3J/3bUX99N
         YNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CSC3aRVO5ZxUUnNQTzCtcTLTQwLce1l3eFEfXxrgFOw=;
        b=JgWK4hCJTY5fs/0TVzfrb7+Guhnhr9DhriGXh+/YX5LTNsFqZ3L5lJ6O2Va6qlXtE4
         DBIw9ClCMOeEZm1XbKle/8gN3YkNf9wNw6tToYG0+iQke91U+RNjvy77hMZP9LtIsSk+
         vTWIPvrtTmAq841zPQODB34j5Jlai7prYqHPH7uec2q/YmJHDSTiXTDaXBK5razVqtPj
         +D85MnWkUUg+BwKtAlBkAdt4xnQghS2OWwaGO6OHoNB/5KmjiIqEVgHVbrRSneI3Rqtb
         ysOqcp6EWobtiTqGus15dc4s2czPysMHw1A3DfUaFQ/OYW5kYX/88CrUnQpeeRRTKIVP
         tYlw==
X-Gm-Message-State: AOAM531afnJx3h3NaCf0cBne/WqTnbYkiHUNRbtfUQvrmvReoApcP3ue
        Wx9Qt9A+INval3p2WhQti6A=
X-Google-Smtp-Source: ABdhPJxISqx0x62ge4Zd4vTOhMdV9TQBEXNgfXx8Kzg0n67NAID4MZYt/gwWMW0CcLE5BlxjZftjow==
X-Received: by 2002:a17:907:d8e:: with SMTP id go14mr10191370ejc.472.1610353553680;
        Mon, 11 Jan 2021 00:25:53 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id dx7sm6737231ejb.120.2021.01.11.00.25.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Jan 2021 00:25:53 -0800 (PST)
Message-ID: <4d85d61319e6991dda75a68cb466c86c8fea30e4.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 11 Jan 2021 09:25:52 +0100
In-Reply-To: <4d1ad38dbe0235020183e474a3610294@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
         <0ad818b10110c4c383afbc2c39235a4f7f17f4c7.camel@gmail.com>
         <4d1ad38dbe0235020183e474a3610294@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-01-11 at 09:30 +0800, Can Guo wrote:
> > > +static inline bool ufshcd_is_sysfs_allowed(struct ufs_hba *hba)
> > > +{
> > > +       return !hba->shutting_down;
> > > +}
> > > +
> > 
> > 
> > Can,
> > 
> > Instead adding new shutting_down flag, can we use availible
> > variable
> > system_state?
> > 
> > Thanks,
> > Bean
> 
> Hi Bean,
> 
> I prefer the flag shutting_down, it tells us whether
> ufshcd_shutdown()
> has been invoked or not. It comes handy when debug some system crash
> issues caused by UFS during reboot/shutdown tests. system_state is
> too
> wide in this case.
> 

It is only a suggestion, and others LLD use system_state, you prefer
adding new flags.

Bean

> Thanks,
> Can Guo.

