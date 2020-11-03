Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49850C55178
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F01662224E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604410562;
	bh=DRmFPUWjCfp3zN1gWNkKl/K4qOKyHQ0IjaPt1cmlPRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CIS167NZJUTWbyDcRU3IM59UMZUcZk6lKl7bRP3o2Qe4SDBqw5fzm5Yw8Dr4Khdi1
	 it/NHtTfum/rgVK+ALNqGzZ7QIuoY/OlKE2k8qMvBKrBgarUDV7bTvzX+PfglXXIne
	 zhY90S1tV+J6BUd40f3/79iydKjXvJlh42rQkewA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgKCNfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgKCNfw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 08:35:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7CED20870;
        Tue,  3 Nov 2020 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604410551;
        bh=DRmFPUWjCfp3zN1gWNkKl/K4qOKyHQ0IjaPt1cmlPRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lhCnHxg83jmBln9f27kSqXipTeJ/ou+ZzfQFAfbfu2GPuMce+JI5foxOO7Q7Fb+IE
         iXq9NlxTjUfP6peKfakQ6qPufulPWYmQmc6okWQZrqEChtUwOcHLSIEA4vzhXCoQGp
         bESwWvaaBl7x1NAtBUhbyMDsS0/zkiv8v5NDQ12s=
Date:   Tue, 3 Nov 2020 14:36:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luo Jiaxing <luojiaxing@huawei.com>
Cc:     akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        andriy.shevchenko@linux.intel.com, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, john.garry@huawei.com,
        himanshu.madhani@cavium.com, felipe.balbi@linux.intel.com,
        uma.shankar@intel.com, anshuman.gupta@intel.com,
        animesh.manna@intel.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v3 0/5] Introduce a new helper marco
 DEFINE_SHOW_STORE_ATTRIBUTE at seq_file.c
Message-ID: <20201103133644.GA2067567@kroah.com>
References: <1604406584-53926-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604406584-53926-1-git-send-email-luojiaxing@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 03, 2020 at 08:29:39PM +0800, Luo Jiaxing wrote:
> We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
> for read-only file, but we found many of drivers also want a helper macro
> for read-write file too.
> 
> So we add this macro to help decrease code duplication.
> 
> ---
>  v1->v2:
>         1.Rename DEFINE_STORE_ATTRIBUTE() to DEFINE_SHOW_STORE_ATTRIBUTE().
>  v2->v3:
>         1.Fixed some spelling mistakes in commit.
>         2.Revised resumes are added for easy tracing.

You forgot to address Al Viro's review comments :(

