Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99776C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 19:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7728E2078B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 19:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQSYiPZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgHaTig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgHaTif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 15:38:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26336C061573;
        Mon, 31 Aug 2020 12:38:35 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id q13so6586114ejo.9;
        Mon, 31 Aug 2020 12:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BxkwfFtwYfG6geWP6qay6mU0JJ9SDlVBhDfv2d4WbyU=;
        b=ZQSYiPZcXrYI9uWJ62qBJTIgZc68QR6thdOSu93hD3MzDSiIYhSvp/VuDGGsTCAEZT
         5IQmUB6lG2M2SQdfcmsnK7koxa/+0m9h7p7iwPIlBJYkl8V/ZIqrNnFx2ArbOnSX069q
         iImJJZvDhuWzf4Ne8TZTRnxHRwMw6emCaOCr+FXbOG1K7UREj1AtKRHHqw/IN7WuXnT8
         C4OXWxy9TAXTcSJ12QF50mw3uhtEld6vZhrMvLd0GJIwycLAwCKGvlnWPYIFV4n3Ylkv
         5GnjTSRuR5E8l7jwSZvYz5tL6zQ9rZpI8gKrh1DzAGvQPdPREBlIFx/5DPP0ym54XPfj
         6bJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BxkwfFtwYfG6geWP6qay6mU0JJ9SDlVBhDfv2d4WbyU=;
        b=LGuv24EsEBjqc8s2YLO+kvIN4SOc2hkeuGbqxXilQtS+S8K90WQWYlkHsLvH2X4JCi
         rypzWfJMEOdcn/qX25qv+kHCjrzUISitNII99bSk+y4hQVm7M5fuBoYllLnNSbgoveqE
         EpgdUhdcDj4755fTlBVcNZi2yUjDg2fkg5YPju5Ps+68bIXDbjx5GQKJL3F7waXPj2Qv
         HBNJd5TQjR3DO0ob/X/kS+J/FdyCpGz7GulqUtn4IgyMelpL0t5dAklmcXudmZDrbm1A
         5zSpdbNyUZDfC2CVKQdnJl0OifnxK91Sn9LfZ6RfJ7BSvvRKQTz/qTLwvtbMtXoXXnT2
         2KuQ==
X-Gm-Message-State: AOAM532TtcNycsNhCEEcy4PVfLOm5orVRXmqg7JZ3AkXFzMOgWVYpAGz
        Mpqq/iXOBuR56iN54H7eH7dAykX0tnc=
X-Google-Smtp-Source: ABdhPJyhVmXbzZQkZquFJp9KcOeQF+UKEMNNkdfn2SOULX5XD8spOsjPQNMXSl6KwKewjOXL8lIisg==
X-Received: by 2002:a17:906:5206:: with SMTP id g6mr2508687ejm.292.1598902713833;
        Mon, 31 Aug 2020 12:38:33 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfce6.dynamic.kabel-deutschland.de. [95.91.252.230])
        by smtp.googlemail.com with ESMTPSA id hk14sm8859318ejb.88.2020.08.31.12.38.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 Aug 2020 12:38:32 -0700 (PDT)
Message-ID: <137effceca0474e30bfbbfbbd71f9fbca53e1b9b.camel@gmail.com>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 31 Aug 2020 21:38:30 +0200
In-Reply-To: <ca7a01a24c8189646b5e7bb6bc8899bb@codeaurora.org>
References: <1598321228-21093-1-git-send-email-cang@codeaurora.org>
         <1598321228-21093-2-git-send-email-cang@codeaurora.org>
         <26bfbdf4e5c5802cce6b0ddf5eddbd75bd306d0f.camel@gmail.com>
         <ca7a01a24c8189646b5e7bb6bc8899bb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-08-31 at 09:20 +0800, Can Guo wrote:
> On 2020-08-31 02:11, Bean Huo wrote:
> > Hi Can
> > This patch conflicts and be not in line with this series patches :
> > h
> > ttps://patchwork.kernel.org/cover/11709279/, which has been applied
> > into 5.9/scsi-fixes. But they are not apppiled in the 5.9/scsi-
> > queue.
> > 
> > Maybe you should rebase your patch from scsi-fixes branch. or do
> > you
> > have another better option?
> > 
> > Thanks,
> > Bean
> > 
> 
> I am pushing this change due to LINERSET handling needs it and
> LINERESET
> handling is added based on my previous changes to err_handler, which
> are
> picked by 5.10/scsi-queue. So the two are applied for 5.10/scsi-
> queue 
> only.
> Any conflicts you see on 5.10/scsi-queue?

Hi Can
I meant scsi-fixes branch. no conflict with scsi-queue branch. If the
the changes in the scsi-fixes branch  will never be merged to scsi-
queue branch.It is fine.

Thanks,
Bean

> 
> Thanks,
> 
> Can Guo.

