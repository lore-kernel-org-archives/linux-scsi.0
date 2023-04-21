Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5CBC7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 11:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjDULNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 07:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDULNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 07:13:11 -0400
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09F8A257;
        Fri, 21 Apr 2023 04:13:09 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6BF5F582152;
        Fri, 21 Apr 2023 07:13:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 21 Apr 2023 07:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1682075587; x=1682076187; bh=0t
        2qq+tQTWqA4ZpWihOO91zumC8XpczzQjvKGW1H0LE=; b=B6yYwcD4IOXkq7c+14
        fs0gD5K2A0OeZzLjcbgF6Xun91hwQzVIqO6Xa/JaBCPoh5eMdcuuFe4TFQP7VKST
        g6/LQQ7epWd41yphBcrfCdPOxRT/4I9iBmZlwlFsc4xAVJ00JHbf951eMKf4OAZF
        RxAKL1212bUp+vQd35Z6wTyYX2n0X42PzR4teQ3beOuceYQQUF5BoKoLJ9EILxyj
        ASZbAMhVnXA04AP1T6H4d3plsTm6C+SV9wgTOasrTeqG0Ynn0JOu9fsUpIttm4/F
        XXN1/0TCCo1DIfb5PVWBbVAavQJhygB+s3aXSEi6pAW6VBgBp9vLeEd8dmSt1oss
        RO7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1682075587; x=1682076187; bh=0t2
        qq+tQTWqA4ZpWihOO91zumC8XpczzQjvKGW1H0LE=; b=QPnvv6pfRl/7Ei7ANn0
        Xj236EDf7U5my6lgbtn1NAavbK3/lDVZ6QWnk71wp9GfJUzjXSc+ecvPCwcEA4q/
        dh7hPwMsI5viGFzSzn5v8I7ZZwpP8ItWAMp4V6LJvACg6hye/SYlx3kKtOByzbiH
        oYCafvedYPzQX355k+lYuFAw89dys5yLpjpIDFa9FwN01LskbMajwiMYFpD5+yMg
        NkW21vFUxZ7Bvarpq29cEIguA8m9K5Az1ssQjjs6xvnBdh/CFrXZzSYMMBWZ2ikX
        Ea4OvCV1PC5OMTNwZEUXrM6ljlTzEfFdDRdSXu1me89W1di3RgH6E/BFGCBDSEzx
        LcA==
X-ME-Sender: <xms:w29CZL236wP8bmLmnSG9BL-oOfeCW1MpxP91CFmzdbxT5YkwblUsfA>
    <xme:w29CZKElowL7pjG7iyK8vxMnVAzelLA7wkx1WvGxgOPTSf5CAzOXPU2X2bROQXS9c
    reSb0bJTof4hpRnZlk>
X-ME-Received: <xmr:w29CZL4DEvk7qvWyHD-JyUChI6Sh66hIzILJYXWxAgAziqaRRvV7ZH0s9P4x7f1JzYCYW9bN2hSpZpmtNf1cUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtgedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepvdegtdfgvdfhgfekvdektdfgfeeljeel
    gefgkedujeeiteehgefhgeethffgheehnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:w29CZA24E7gcTexPJ8fwIsEm67fKCD_aZd_lDZLuuMUTGVwoyxA9Gg>
    <xmx:w29CZOHPAEbbggBQXvLcurL1aEJ8wiUJWPNxhheYEFDsOVow4Rpnlw>
    <xmx:w29CZB9Fb8t5pCr_-ePdJICNIFwsNldz9TT7UY5_A4MnClAmIjZVHw>
    <xmx:w29CZDSYhw4Cfzzh0c-EZ2z8Ssf4FpTVvDxYvv-i7y-U2gXd9-keOiqT4fI>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 07:13:05 -0400 (EDT)
Date:   Fri, 21 Apr 2023 20:13:02 +0900
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests 5/9] scsi/004: allow to run with built-in
 scsi_debug
Message-ID: <4mab5xvql3xl6saolhvnbggeehovhdp3y4glz2ccfxvkqj34ur@wpnku3bybtrv>
References: <20230417125913.458726-1-shinichiro@fastmail.com>
 <f4997765-6ea5-52ad-e329-73b9e5eedde5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4997765-6ea5-52ad-e329-73b9e5eedde5@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Apr 18, 2023 / 20:18, Chaitanya Kulkarni wrote:
> On 4/17/23 05:59, Shin'ichiro Kawasaki wrote:
> > From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> >
> > To allow the test case run with build-in scsi_debug, replace
> > '_have_module scsi_debug' with _have_scsi_debug, and replace
> > _init_scsi_debug with _configure_scsi_debug.
> >
> > Also, save and restore the values of scsi_debug parameters 'opts' and
> > 'ndelay'. The test case modifies the parameters and do not restore their
> > original values. It is fine when scsi_debug is loadable since scsi_debug
> > is unloaded after the test case run. However, when scsi_debug is built-
> > in, the modified parameters may affect following test cases. To avoid
> > potential impact on following test cases, save original values of the
> > parameters and restore them at the end of the test case.
> >
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >
> 
> Perhaps we should look into a helper to record other default
> parameters before the testcase and restore it after when
> it is built in ?

Hi Chaitanya, thanks for the review comments. Your idea sounds good. I will try
to implement it.

> 
> Irrespective of that, looks good.
> 
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> 
> -ck
> 
> 
