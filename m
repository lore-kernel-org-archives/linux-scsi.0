Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D06C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D34B2083B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NEiROki6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbgFRCwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgFRCwF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 22:52:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B80C06174E
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 19:52:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a127so2081891pfa.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 19:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=scQ0xWsmhNQkJt4nrg2M8FxSA/O+EPCpM7UPve0DYkw=;
        b=NEiROki6CaCUYearztmsXXPhHyFXevpX/lNS5Oa5P2kE3rnBmEns9f2I61d81rd8OH
         7jI9kgQPfdMc7/Gl2F7DY+KvX2M3sYns1Y/X4Y0EWdcz1aohyAV6AVyIuDc0aMdpat4o
         UmJIks5w5f0f6gCwDbJc1qfj8W2QCnU8DFLWqtjUXAwq5lZ3o08toyK4zwem7avGYgH1
         IRu7UQahBAMta15Hifse48sgupxuesrCHjzf9wvrUqU8Le8brBjc3iL4/JY4q2ZxXC8h
         ULFkwGyDg3QQ21UyRTXH0y0gAP6x7luktLXo6g634Q+8Fj0pseYyEJlkCZ2dh1LTUm8g
         3htQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=scQ0xWsmhNQkJt4nrg2M8FxSA/O+EPCpM7UPve0DYkw=;
        b=L6hR8pjVYL2gYVEVF+CSkNyH3kGU40cWgUhRUN5GztmLqgw14/qp3syzTZ54YQsgdF
         mUR5XcFuoSpE35IePMqAhay7AC521LdK1zCt2TRKtlgmVrnYOk0ofZblfwwbZtaVKEYC
         /ceA8NKfhcHXchh7/4pkDDKjFq4Er2RqifRemqXSoZ7OTNqClAlHhQGAsV3W1P3lPkjd
         /JMo2UWhj6pLOWYbkFkJFyWWE0RdrxfbPFLsIt8HfRwi/Jm1LFSIx+FahUg/0aCYtlR1
         WKXzLJqaC7rWaayLPiKw1/HNVe2qtlT5M6RBtZQqi1XMOjqM1WhYKS5Y+MGJ0iT2M0pr
         qfAw==
X-Gm-Message-State: AOAM533FqZ7k/OtcG5gylEJZA5aMFODDcEJcOk5q8aVj5d8tV2DtTxaU
        d9AWXlMMOCCbxN549iaqoTGkUWAtiaw=
X-Google-Smtp-Source: ABdhPJxJngkFUiMRQN1gMzvdbUo6V1A0UaGblI96hI4hykWTF+kk/MmkzPjtgK+BDpIUXinD/v8TGQ==
X-Received: by 2002:a05:6a00:15c7:: with SMTP id o7mr1609067pfu.51.1592448724031;
        Wed, 17 Jun 2020 19:52:04 -0700 (PDT)
Received: from google.com (124.190.199.35.bc.googleusercontent.com. [35.199.190.124])
        by smtp.gmail.com with ESMTPSA id f29sm1016074pgf.63.2020.06.17.19.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 19:52:03 -0700 (PDT)
Date:   Thu, 18 Jun 2020 02:52:00 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200618025200.GA100078@google.com>
References: <20200617081841.218985-1-satyat@google.com>
 <20200617081841.218985-4-satyat@google.com>
 <20200617162827.GD1138@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617162827.GD1138@sol.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 09:28:27AM -0700, Eric Biggers wrote:
> On Wed, Jun 17, 2020 at 08:18:41AM +0000, Satya Tangirala wrote:
> > Wire up ufshcd.c with the UFS Crypto API, the block layer inline
> > encryption additions and the keyslot manager.
> > 
> > Signed-off-by: Satya Tangirala <satyat@google.com>
> 
> I had also given Reviewed-by on this one; looks like that was missed as well :-)
> 
> https://lkml.kernel.org/linux-scsi/20200514051205.GB14829@sol.localdomain/
> 
The UFS comments slipped my mind entirely :( - I addressed them this
time.
> - Eric
