Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E861C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 13:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF07207B0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 13:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407804AbgLNNHJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 08:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407799AbgLNNHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 08:07:09 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99ADC0613D3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2020 05:06:28 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id c7so15406512qke.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2020 05:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=0WuvEppDleV+S7pcqpHxzCQflrbfbHnaCqqVzPSevY8=;
        b=WB4x6JSvNaAdYyu5uKrfp9edqClNEBHeo80crhHJgzMSX7V+9akduyKk+G6dctmVp+
         x9+JSCnFXt17Kea5ydmnhC/J8tM2e9zhPb+7i7UtRRQUikme8UaUdo9+OMBD0KiupAKB
         SJCMUIjMzlxjUgCgpMXeDLPTnRTsyqqgfSZYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=0WuvEppDleV+S7pcqpHxzCQflrbfbHnaCqqVzPSevY8=;
        b=uZFRVceWuz9v3scubm9HaXJ2yxwtXri54OBnq0H1KF3A49i154RR9nv5Zboxz1rsKi
         h0QZ5D+XvMSUBCyYmiXUK4bpvBHwXKd7aa7Mz+8g1YUZ7u4qqB8duoUSm9VZFn4DtbYF
         S08ETboPZvs8YSwi5wBLSw/1Nhoh6/bj993eUyBgpwz2dgHYZl2WItZgRcFnV1hXWgA9
         z8ySx7dktcZB5DDam7mFsI2O2RwHqk41An+4PYtBu74EWDDvQ2TMFuY3pcdPPH2/eidc
         9zTBYjVMkDQMYJiQ1YDfvfiVgsRhPmQAN7TU+PTSQRmnYC/hCoMO0z5Fhk1mD1D3n2+h
         SY/Q==
X-Gm-Message-State: AOAM533oQkAio+BQgWRrqZBYL2Smxh2u/j1+q3Br8MChZZhMgoriFB+8
        8QCccaBweuEME/pEAsXuQw0S/A==
X-Google-Smtp-Source: ABdhPJw94VHAaeYO/S57fRpgTfG5neMu6DcTMz24l3inWNQg2cpmf5vYTNLAlzT1E3QnXvk8n5wLdg==
X-Received: by 2002:a37:5242:: with SMTP id g63mr31559196qkb.317.1607951188064;
        Mon, 14 Dec 2020 05:06:28 -0800 (PST)
Received: from chatter.i7.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id x47sm14799292qtb.86.2020.12.14.05.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 05:06:26 -0800 (PST)
Date:   Mon, 14 Dec 2020 08:06:25 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devel@linuxdriverproject.org,
        Saruhan Karademir <skarade@microsoft.com>
Subject: Re: [PATCH AUTOSEL 5.9 15/23] scsi: storvsc: Validate length of
 incoming packet in storvsc_on_channel_callback()
Message-ID: <20201214130625.x2v53xhx5xw6jp4o@chatter.i7.local>
Mail-Followup-To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devel@linuxdriverproject.org,
        Saruhan Karademir <skarade@microsoft.com>
References: <20201212160804.2334982-1-sashal@kernel.org>
 <20201212160804.2334982-15-sashal@kernel.org>
 <20201212180901.GA19225@andrea>
 <20201214110711.GB2831@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214110711.GB2831@kadam>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 14, 2020 at 02:07:11PM +0300, Dan Carpenter wrote:
> On Sat, Dec 12, 2020 at 07:09:01PM +0100, Andrea Parri wrote:
> > Hi Sasha,
> > 
> > On Sat, Dec 12, 2020 at 11:07:56AM -0500, Sasha Levin wrote:
> > > From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> > > 
> > > [ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]
> > 
> > FYI, we found that this commit introduced a regression and posted a
> > revert:
> > 
> >   https://lkml.kernel.org/r/20201211131404.21359-1-parri.andrea@gmail.com
> > 
> > Same comment for the AUTOSEL 5.4, 4.19 and 4.14 you've just posted.
> > 
> 
> Konstantin, is there anyway we could make searching lore.kernel.org
> search all the mailing lists?  Right now we can only search one mailing
> list at a time.

This functionality is coming in the next version of public-inbox and 
should be available on lore.kernel.org within the next little while.

https://lore.kernel.org/workflows/20201201184814.GA32272@dcvr/

-K
