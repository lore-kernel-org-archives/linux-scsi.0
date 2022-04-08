Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1715C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 12:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbiDHMrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 08:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiDHMrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 08:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A433EBAE3
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 05:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649421916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khBPZtzPFEMx9dKIM9CWO7Q/Lm+eAtWPqukaOGv/i8A=;
        b=YLtnpIsC0V7winnbPDIk8ihc1bA6iZGyvRj9ARC3Px6IupPR31DrGO1wJvQ37eQxfkUHHW
        pdU1brJZHsIjdqPWtFJl3TsIX8uPMC77CL1FaYl7weSAgIAJv1GKpcBy1UIe/GopodhpcN
        r+p1QFE2oLFswtseQaHaobOI3YKJRLQ=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-460K-yiNMJqnXPmTLMm4BQ-1; Fri, 08 Apr 2022 08:45:14 -0400
X-MC-Unique: 460K-yiNMJqnXPmTLMm4BQ-1
Received: by mail-lj1-f199.google.com with SMTP id o17-20020a2e0c51000000b0024b484876a8so1329535ljd.21
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 05:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=khBPZtzPFEMx9dKIM9CWO7Q/Lm+eAtWPqukaOGv/i8A=;
        b=ejSJBGIMAvHIFjht6q4NkHTjFI41wVKlCoaf2foynMiHIc4MwbkyILmEvx92xH2ghz
         sr4Dr+o982FF4siXWHMliCm14Y6fLdKh7+to7lNf8QbUBIa08g7TIWhJtdDIvq6WYzQB
         Yj7NIgEINiSovyeGIcazE/++19ZWQ05mKTjneVrYRMbBs6qJYrTATF8g6uNwBSKHuHre
         WVleli2fLVwJh6ljpg0Y1FHdLIYIH9Wu4ucDYoNVv9rsTOrcUZoP7WzCY0gxYihea47u
         oGjncegDmcKi8wV3xNMUCf9zpSlmZyYxLD4rZKsFRnmRbyM/MtaSErARYFOaE5JxBE7Z
         wezA==
X-Gm-Message-State: AOAM530S/4fbHv/Cu8s9j74gehrbXJHniTT3N7NeKwB2VogDRn291C5K
        zRA8QiguG0PlYlCzMaHWBu1uZfPM9yEJPf8055spJmqfIVUbXPyuVxtcQjM6bq7QWhbVwwvi75M
        z5XDRlIAJQNNq+OE+41jzmAZJ+z69yKDEZW8F5A==
X-Received: by 2002:a05:6512:158d:b0:44a:6522:f98f with SMTP id bp13-20020a056512158d00b0044a6522f98fmr12476803lfb.608.1649421913226;
        Fri, 08 Apr 2022 05:45:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxifoUmW3lR7s6bWQ1QaUPysHRDA51bV3Mjmn5J1/ODHj+CUYXo/iK2FzHxX3hDX/jFtBf6eHMKV1gEJAu6iCE=
X-Received: by 2002:a05:6512:158d:b0:44a:6522:f98f with SMTP id
 bp13-20020a056512158d00b0044a6522f98fmr12476781lfb.608.1649421912940; Fri, 08
 Apr 2022 05:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <CA+QYu4qTtXgVegAd7S5bjJQye+kmtPaFau4dg3YPU2tH9faBjg@mail.gmail.com>
 <175195a9b7840e883677c6f351ee186089ab2b6d.camel@HansenPartnership.com>
In-Reply-To: <175195a9b7840e883677c6f351ee186089ab2b6d.camel@HansenPartnership.com>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Fri, 8 Apr 2022 14:45:01 +0200
Message-ID: <CA+QYu4oKwOwKYJB0_SezXWaMWa9Obp2=nLd-2_bKx-jSAu1TDw@mail.gmail.com>
Subject: Re: RIP: 0010:ahd_init.cold+0x96/0x98 [aic79xx] - 5.17.0
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        CKI Project <cki-project@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 5, 2022 at 5:33 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Tue, 2022-04-05 at 09:14 +0200, Bruno Goncalves wrote:
> > Hello,
> >
> > We've been hitting the panic below when testing mainline kernel. More
> > logs can be found on [1] and CKI tracker [2].
>
> When was the last time this driver passed the test?  I'm asking because
> nothing significant has changed in this driver for a while and the
> trivial changes all seem to check out.

Hi James,

Sorry for the delay in replying to you. Do you think it could be some
patch from d51b1b33c51d147b757f042b4d336603b699f362 or
23d1dea55520c5cf89849279cd25de4da8392687 ?

I was able to reproduce it using the CKI kernel from d51b1b33, but not
from commit 2fce7ea0.

We don't have a kernel build for 23d1dea5, but if you want I can try
it next week.

Also, it seems I can only reproduce it on kernel build that adds some
debug flags when we build with selftests enabled.

kernel build: https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/03/23/499569088/build_x86_64_redhat:2242251830/kernel-mainline.kernel.org-x86_64-d51b1b33c51d147b757f042b4d336603b699f362.tar.gz
kernel config: https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/03/23/499569088/build_x86_64_redhat:2242251830/kernel-mainline.kernel.org-x86_64-d51b1b33c51d147b757f042b4d336603b699f362.config

Bruno


>
> James
>
>

