Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7B1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 11:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E9C239EE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 11:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbhAHLae (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 06:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHLad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2021 06:30:33 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E681C0612F5;
        Fri,  8 Jan 2021 03:29:53 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y24so10816640edt.10;
        Fri, 08 Jan 2021 03:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5O9MLXAkEP58Bjv7aYHHe7uD/qyvzBwG+zsvVsstEM=;
        b=Vj51S5TqplhIC7K50DbXUiplF6Tq4fYRRIg9vAnb7TqbAIsvJr1lkuSsbnijqloLsC
         uyG4TQv9SEV0qS9FgvHp/HsfAwbqv9YReQbJ6yrLIiR6fRoRzHub1nQNd8FJFhlcH528
         5fgZso2/p8FpCwah4hwCPz8O/Yaqa0PU7tAp8CGhaDhJCJDcbLjvzTCGKKhiCcR9gsf9
         fIA2brW/vl6QOeSz7AxCePB6eLG8hH/FK8z69G4XuR0JXBClOq62sMMlMf5+bougRah3
         DvQdHrliDRobjcd76KwRKSHmJ6yz07F8tgX6f5LC702lBhLbwDiN/whGO+a9/CxKtii1
         v9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5O9MLXAkEP58Bjv7aYHHe7uD/qyvzBwG+zsvVsstEM=;
        b=mumzcy2M7plwwGzMdx931LOQvQ7ROJj/i7kXwEBKsTRmN6JGPUH2L5gEq46PK/t0vR
         YEzUXhOF0Ws4Yh0P73acw/PDTq4/9P+PTi/m7PDPm4xqCjJVaJguglikB21qQ4W8anYZ
         +JNWtIa1wnGSBzmeEOY2Kucy1SJ6dLEus0E1D/5WHQLk5TPh/jwOzbnxHKvq4pOR7t6D
         ivDb791Nt+LnxOL6UyUzCHSNPius4XVgIe4nRq1MQb3f7IPDpKuIYG4uaENpO9UhGSHY
         Dyqz3J/Pn0IHQr+UFKwbUuOav16tR0aiXCfmx3ovIAbhUZ4+pNiUQUbABhI4PAiL8GRr
         sDEA==
X-Gm-Message-State: AOAM531Q0USFl3YycPX7c/tjfCYTA8iEWHsMavpyk7uSURsFVFjvJ5oG
        4a0kvDn+1Kxn6t21dNGiFM1IKEK+4WuPvA==
X-Google-Smtp-Source: ABdhPJx1xsN29pk75Ubfz0J0d1Y+7E1H0Pjsrb7nfpX45YePzwwUbloODsFdvflkQR5KPSavxe4Stw==
X-Received: by 2002:a05:6402:17cb:: with SMTP id s11mr4760831edy.119.1610105392248;
        Fri, 08 Jan 2021 03:29:52 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id pg9sm3411773ejb.102.2021.01.08.03.29.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 03:29:51 -0800 (PST)
Message-ID: <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, rjw@rjwysocki.net
Date:   Fri, 08 Jan 2021 12:29:50 +0100
In-Reply-To: <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
         <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
         <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
         <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
         <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-06 at 09:20 +0800, Can Guo wrote:
> Hi Bean,
> 
> On 2021-01-06 02:38, Bean Huo wrote:
> > On Tue, 2021-01-05 at 09:07 +0800, Can Guo wrote:
> > > On 2021-01-05 04:05, Bean Huo wrote:
> > > > On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
> > > > > + * @shutting_down: flag to check if shutdown has been
> > > > > invoked
> > > > 
> > > > I am not much sure if this flag is need, since once PM going in
> > > > shutdown path, what will be returnded by pm_runtime_get_sync()?
> > > > 
> > > > If pm_runtime_get_sync() will fail, just check its return.
> > > > 
> > > 
> > > That depends. During/after shutdown, for UFS's case only,
> > > pm_runtime_get_sync(hba->dev) will most likely return 0,
> > > because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
> > > will directly return 0... meaning you cannot count on it.
> > > 
> > > Check Stanley's change -
> > > https://lore.kernel.org/patchwork/patch/1341389/
> > > 
> > > Can Guo.
> > 
> > Can,
> > 
> > Thanks for pointing out that.
> > 
> > Based on my understanding, that patch is redundent. maybe I
> > misundestood Linux shutdown sequence.
> 
> Sorry, do you mean Stanley's change is redundant?

yes.

> 
> > 
> > I checked the shutdown flow:
> > 
> > 1. Set the "system_state" variable
> > 2. Disable usermod to ensure that no user from userspace can start
> > a
> > request
> 
> I hope it is like what you interpreted, but step #2 only stops
> UMH(#265)
> but not all user space activities. Whereas, UMH is for kernel space 
> calling
> user space.


Can,

I did further study and homework on the Linux shutdown in the last few
days. Yes, you are right, usermodehelper_disable() is to prevent
executing the process from the kernel space.

But I didn't reproduce this "maybe" race issue while shutdown. no
matter how I torment my system, once Linux shutdown/halt/reboot starts,
nobody can access the sysfs node. I create 10 processes in the user
space and constantly access UFS sysfs node, also, fio is running in the
background for the normal data read/write. there is a shutdown thread
that will randomly trigger shutdown/halt/reboot. but no race issue
appears.

I don't know if this is a hypothetical issue(the race between shutdown
flow and sysfs node access), it may not really exist in the Linux
envriroment. everytime, the shutdonw flow will be:

e10_sync_handler()->e10_svc()->do_e10_svc()->__do_sys_reboot()-
>kernel_poweroff/kernel_halt()->device_shutdown()->platform_shutdown()-
>ufshcd_platform_shutdown()->ufshcd_shutdown().

I think before going into the kernel shutdown, the userspace cannot
issue new requests anymore. otherwise, this would be a big issue.

pm_runtime_get_sync() will return 0 or failure while shutdown? the
answer is not important now, maybe as you said, it is always 0. But in
my testing, it didn't get there the system has been shutdown. Which
means once shutdonw starts, sysfs node access path cannot reach
pm_runtime_get_sync(). (note, I don't know if sysfs node access thread
has been disabled or not)


Responsibly say, I didn't reproduce this issue on my system (ubuntu),
maybe you are using Android. I am not an expert on this topic, if you
have the best idea on how to reproduce this issue. please please let me
try. appreciate it!!!!!


Thanks,
Bean


> 
> 264     system_state = state;
> 265     usermodehelper_disable();
> 266     device_shutdown();
> 
> Thanks,
> Can Guo.

