Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92847C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Nov 2023 18:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjKMS2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 13:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKMS2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 13:28:02 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4923F10EC
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 10:27:59 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5a7c08b7744so54976647b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 10:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699900078; x=1700504878; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mFbfcfYyHInn/qNJkcTbKME0wjom9QQT5atHoVOHFN0=;
        b=JV+p9XTP37VCe0fZIH1liyTZkQFUKS3hT1igXfHqizjdHFgUJ8DCli/sEMNZx4mtB9
         6YVyeTiiF1K21WzH76pAEXO2asgkmdrXLCG7vQLtgQE3+nzpbrmEkn3CnRe7YFBZksRE
         Hi03dqGevXsRucOc1Cb/9d9ZroUgzzFu+qI3wkfIJS+kWKdrETRXNPHjr65PWJ6D68PM
         FSfdTemqIsOoEwaXw+cvr21r/mgZ/ix24usDow9RrdaobGPqDx5qSV3MR1Cf4BfT6jqD
         NXFS71uBMba0Zrv6Ea2s2sJnkz6HSX+clyx27aFifapcP45dbzBMACYrLmptwjSt50Xk
         oEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699900078; x=1700504878;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mFbfcfYyHInn/qNJkcTbKME0wjom9QQT5atHoVOHFN0=;
        b=w+S7m2cNxCS49+rN/zRHM0BoYM9qCt6oMPClRB92ktYHJ4rM10UmTeNRz4eYrSDCG4
         VDn/VQQB7AJEJobbtnrxeAf0Faysaa6J2cS9lz6JtAFJo0wk66u8m2aWPMJKKbJGQSuX
         ZNiVJsmsPod7eYXlsdYWZKZxu+STkguvuvalyXRmVt2BZ+fIWqAPJDb2O6JQUd2Aw9b2
         3mVBZXz+nM7cW1uqFjO0tD2U9dyfq4wbvEWBin5/bqtEhdKMCzt4LvfYiPG8/mjEs9nd
         GPvMs+66VreJe6ziPQgO+I3wCzZU8eaV4l+nGKwFMXkXT24QfEgkZgBGOli42e+2wOwd
         yCXw==
X-Gm-Message-State: AOJu0YzB5d8IIL9yQsgdEVeR/+sfkMej9ygYALl8Nnhmfq2apzu1XqGB
        q3izFRj9xRUeG+zDeNnCuJTWl9fAHMWA2cbWT/g/qE19GOw=
X-Google-Smtp-Source: AGHT+IEYWompQvZoZ/UdCSM8PjX4vDhL4miXqEs1rfYSkiqze23yu8wCGyVue7QJKsIqQ7iKCycGJTyT2PlZ5AtZiKI=
X-Received: by 2002:a81:7387:0:b0:5a7:b682:7929 with SMTP id
 o129-20020a817387000000b005a7b6827929mr6691722ywc.17.1699900077377; Mon, 13
 Nov 2023 10:27:57 -0800 (PST)
MIME-Version: 1.0
References: <CAGnHSE=pipa-zi-kxWyPoow0wU04-N_eUopOaZWFftTsfLjEQQ@mail.gmail.com>
In-Reply-To: <CAGnHSE=pipa-zi-kxWyPoow0wU04-N_eUopOaZWFftTsfLjEQQ@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 14 Nov 2023 02:27:46 +0800
Message-ID: <CAGnHSEk3bARZ=ed4D62mv=n-nQRoiPteCLZPdMhrW_O5ntzfCA@mail.gmail.com>
Subject: Re: [BUG] write_cache sysfs file broken for WCE setting
To:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

So I realized that I mixed up the queue write_cache and the sd
cache_type sysfs files. cache_type is working fine.

But then I noticed that in commit
43c9835b144c7ce29efe142d662529662a9eb376, you define QUEUE_FLAG_HW_WC
as 18, which is also the value of QUEUE_FLAG_FUA. Was it intentional?
If so, what's the reason behind it?

Regards,
Tom

On Sun, 12 Nov 2023 at 17:42, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Hi,
>
> So I notice that the write_cache sysfs file seems to be broken for WCE
> (SBC) setting.
>
> First of all, "write back" gets rejected as "Invalid argument".
>
> On the other hand, while "write through" can be written to the file,
> it does not seem to actually change the WCE bit (as per sdparm
> reports). There's no new cache setting reporting kernel log either.
> However, reading the file after the write does give "write through".
>
> Nevertheless, the file does change accordingly when I set WCE to 0 or
> 1 with sdparm.
>
> I am reproducing this on 6.6.1. It seems that it at least affects the
> 6.1.x LTS branch as well though. (I can't tell for sure since for the
> latter I am using the raspberrypi tree.)
>
> Regards,
> Tom
