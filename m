Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E1BC77B7A
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 01:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjFBBBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 21:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjFBBBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 21:01:10 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D44F2
        for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2023 18:01:07 -0700 (PDT)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6EC0D3F554
        for <linux-scsi@vger.kernel.org>; Fri,  2 Jun 2023 01:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1685667665;
        bh=wCbPB1ZDTWLt/oEJv6P7qx4Cdd8dnV7Y9TrZ5aVJ2o0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=qf/XcOkaa1ZekfrU8e8pefIvLAuErEBq2vbDuJeLl8UfohcxPbe53BJdfDpOaKIzc
         3qRU+g4B1JsDXDPhbh90sNjTLaj5i+nwDJm1VJ0+HzUKXFjgfLx4nm/ycnHVD8Y4S9
         XRW+jb9MagLpnuaBrpEceiDDB/W319ytSabXGMyavt8guDZF7yTbMlJHvGu4qBbPMt
         1PLRK+TJNUBKBuKyZJA0ZGzT9u71UlUk02E6+Mx9dY3cl6oL745QR+VQCuBdw2U1y2
         0uB+z+iW0Ofu/T04g9FzsTlSeMlpmAjV6F0UFmJ7+ic8AXIyg09xQBN7SomdQu16Zl
         ZURwHdFUk1h+g==
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5428d1915acso294654a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2023 18:01:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667663; x=1688259663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wCbPB1ZDTWLt/oEJv6P7qx4Cdd8dnV7Y9TrZ5aVJ2o0=;
        b=H4TJQyo/uS0S1Q3yMHMdKh47JYuflZRusOmiVx70zUShQaZC1sMw2gC4AURWpwmNZj
         KgEmnN/2sYZmakefifg4DHmyc+y7Ub5ieAVCEtQFdNRl/K8WTjozXGA+shdElaNQKxa+
         6I17VXEkb6P+jAja/FEIreptEBCO7oeTbN+unvhc4p+SW4oJ+t0P5DO8Mn0ySiUZNkMU
         4754usI1SWNSKNTXHYcZlfT2sCO+BA6J3MPJiIrzmdUt/kdeTQ1gzkVLQypV7oFp+Y1K
         //AaqWcph4Sdgd5r4X4oqaVHdRrksNbyHWmbAbEzqPv9cFtz4PlESSy1vGKWfybv+vBA
         AQ1A==
X-Gm-Message-State: AC+VfDzHNuKKJQMkaxRu9PYNNU6ytvmn1u2P+NN8oB791CI3oLDHiwkl
        dCEDhukyE2ZjyNQrwIVVZviW17Rs5GbUfkd0V6ka5m7DIgNO/5GfAFvbd0yEoXjRg+jG/iWb/aY
        3S58bfs6Jg9W+qTMM3b/dzRgy+fCfVh3VfUTUYF850g2ILEqG2PWStEA=
X-Received: by 2002:a05:6a20:101a:b0:103:b436:aef7 with SMTP id gs26-20020a056a20101a00b00103b436aef7mr3265575pzc.16.1685667663270;
        Thu, 01 Jun 2023 18:01:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6VYL0KZ+3iS8gCc9F1FccQPyYsJMympHRukppGkxqbJhX/s/Mr1+03VnVxAzE9Sg4EziYgwHd5k/dOBTS9O0k=
X-Received: by 2002:a05:6a20:101a:b0:103:b436:aef7 with SMTP id
 gs26-20020a056a20101a00b00103b436aef7mr3265549pzc.16.1685667662942; Thu, 01
 Jun 2023 18:01:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230601155652.1157611-1-kai.heng.feng@canonical.com> <164576ab-4e68-ca5d-0c9e-d756588cdbb5@acm.org>
In-Reply-To: <164576ab-4e68-ca5d-0c9e-d756588cdbb5@acm.org>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 2 Jun 2023 09:00:51 +0800
Message-ID: <CAAd53p6S=nzxgwBky6daJZ8wa-HaBODpjwLPYZ52g8FPXbbACw@mail.gmail.com>
Subject: Re: [PATCH v5] scsi: core: Wait until device is fully resumed before
 doing rescan
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, dlemoal@kernel.org,
        bblock@linux.ibm.com, acelan.kao@canonical.com,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 2, 2023 at 3:48=E2=80=AFAM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> On 6/1/23 08:56, Kai-Heng Feng wrote:
> > During system resuming process, the resuming order is from top to down.
> > Namely, the ATA host is resumed before disks connected to it.
> >
> > When an EH is scheduled while ATA host is resumed and disk device is
> > still suspended, the device_lock hold by scsi_rescan_device() is never
> > released so the dpm_resume() of the disk is blocked forerver, therefore
> > the system can never be resumed back.
> >
> > That's because scsi_attach_vpd() is expecting the disk device is in
> > operational state, as it doesn't work on suspended device.
> >
> > To avoid such deadlock, wait until the scsi device is fully resumed,
> > before continuing the rescan process.
>
> Why doesn't scsi_attach_vpd() support runtime power management? Calling
> scsi_attach_vpd() should result in a call of sdev_runtime_resume(),

It's system-wide resume in this context, so it's dpm_resume() waiting
for the lock to be released by scsi_rescan_device().

Kai-Heng

> isn't it?
>
> Thanks,
>
> Bart.
>
