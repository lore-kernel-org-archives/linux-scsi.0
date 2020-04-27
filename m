Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FC2C54FCB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 00:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F65B206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 00:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hg0CT5zR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD0A0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 20:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbgD0A0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Apr 2020 20:26:54 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FBFC061A0F
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:26:54 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y4so15757310ljn.7
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 17:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sf/vP1zfkk7/lO6kOf3sxC65MlealLnjLWyX3zuwdis=;
        b=Hg0CT5zRzMiaMAkdUeWSBAWH6Ar9yMmLcRhkywJKcnwq1hfOrSdyLkaLI3W8msyr10
         RDW/BHlwP1LOfFqqU2TKJ6cytOKtzVxg/L5bCZ8RajVwhEnhtWS/5Dkk/clwkneIfPcB
         lmbLAwFOIuIycKRa3T8dD2DU8HMWJFQInIQm2Iy6SqNmBYXH3PtsM4He5rZhW0Tnmgx/
         PaHhtrlitEwELUcV70UnMG6JKkWjSEPykgXLHxkuoFiSL2xCCwT0CfgItsEzlilBDe9q
         jNVQDH+nyWAO0SaXBfD2Ktu1/Rjy0cJADmoMupAGtByYuPB2zWZep5WHvJYKiKf3pM8B
         GT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sf/vP1zfkk7/lO6kOf3sxC65MlealLnjLWyX3zuwdis=;
        b=ihP0Z8ltHtkX379kvT5DYCz4qq+HWRjFrokWrEwRLcUX7MztKstMd9nTYJ0Tu6mSDM
         M5hD7aggJUZjEkuiGX6ytobdagx9aag5BdHVpto120h+yLu+d7Vfmf7uig7l+YkuRa61
         IAW85dINeUV7ZJ98b67jmcQym+vfmVAhbs+0rCWBd90MIxS05i6k8K3ebIPCdwXpBEXK
         vMco2WncB4d7fKDWxgCNIpDhG3m9kMKRNrFT5RlIBmbHN5TAzsO8kPa3FzWMfNkUP8Kz
         +bOO1Y1izmYc0qXGkwJ+UERpKwDKv+Uv1WI7UX1VBf4eUCRcMwhlVFDg2DLTvxBhEmi4
         yRCA==
X-Gm-Message-State: AGi0PuY4ac7IsXSq+YLke23XQnX1K6BGbGvcoMyg5+iW5rZPOEouP8Ju
        FR54qMlaobgZQcGb9mKxgoOB3grgwzYCTu+ZLB4V5K5f
X-Google-Smtp-Source: APiQypI2pAnt1U3Ep8sSAMXmaVXdkwrQcG0IdmMsJOol16UBHrIO+9kfJvBdCsHBfBo2xsx463OLUs3/L1o+rXKJo5w=
X-Received: by 2002:a2e:9818:: with SMTP id a24mr12583562ljj.126.1587947212692;
 Sun, 26 Apr 2020 17:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHB2L+cDZCMAwQhVxU99Dwa7Fj90Wwn7qZ9e=78MCqQdwrEjGQ@mail.gmail.com>
 <1587945879.3423.5.camel@HansenPartnership.com>
In-Reply-To: <1587945879.3423.5.camel@HansenPartnership.com>
From:   Aijaz Baig <aijazbaig1@gmail.com>
Date:   Mon, 27 Apr 2020 05:56:41 +0530
Message-ID: <CAHB2L+fRtH6izbJXx8HH=26Zi7ZGPKkkTA0LKogPS_9LZW7+eg@mail.gmail.com>
Subject: Re: Venturing into HBA driver development
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James

I very well know the book. But the chapter on block devices is
targeted at, what I believe, are called 'target devices' in the
overall topology, isn't it? I am specifically looking at drivers for
HBAs, the host bus adapters. As you said, it is highly manufacturer
dependent, which is why perhaps there isn't a generic guide to it.

But I am looking at understanding the broader concepts associated with
writing HBA drivers. As far as I understand up until now, they talk
"scsi" to the target device (or its firmware to be more specific", who
then translates the scsi commands into actions to be taken on the
actual blocks (LBA/CHS). Am I right? So I believe I need some
familiarity with the SCSI "command set" as it is. Could you shed some
light on this?

On Mon, Apr 27, 2020 at 5:34 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Mon, 2020-04-27 at 05:24 +0530, Aijaz Baig wrote:
> > I'm a mid level developer with acceptable knowledge of OS internals
> > and some driver development but up until now, I've worked mostly on
> > the networking side of things
> >
> > most searches online are leading me to open solaris which seems to be
> > the only guide available online for writing HBA drivers
> >
> > Is there anything else (Besides reading the source), like a guide or
> > something, that I can read to help me get up to speed with it.
>
> This is a pretty good one
>
> https://lwn.net/Kernel/LDD3/
>
> And if you like it, you could buy the book.
>
> > Do I really need to know SAN to become acceptably good. How much SCSI
> > (and other protocol(s)) knowledge is needed?
>
> It depends *what* driver you want to write.  Obviously you have to
> understand the protocol of both the host bus adapter and usually also
> any devices attached to it, but the HBA protocol is usually highly
> manufacturer dependent, it's only the device protocol that you'll find
> in standards.
>
> James
>


-- 

Best Regards,
Aijaz Baig
