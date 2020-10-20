Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C09C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADBF8223BF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="sjQWm0/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbgJTCdQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:33:16 -0400
Received: from z5.mailgun.us ([104.130.96.5]:24729 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390706AbgJTCdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 22:33:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603161195; h=Message-ID: References: In-Reply-To: Subject:
 To: From: Date: Content-Transfer-Encoding: Content-Type: MIME-Version:
 Sender; bh=n4I5yOa4YBmI7PQMZH7cNL3gKJrkOtKtojuaGx87mVE=; b=sjQWm0/HAfGQItNxwvPVT2am1SLhrRFGLsAol97uoJuQNA2w1+pGSN9sSYVkFH2ZDmpbJPXt
 HyurTgikidlZpLFlV6cdO3fpQkQZyHfRBmlOKyepKIDM9THCDadKZxDT3NI1ljGiLVktJuql
 +oYruqfKguk83RxgeRGx4FbFD6s=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f8e4c6a57b88ccb56589c32 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 20 Oct 2020 02:33:14
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CBB41C433FF; Tue, 20 Oct 2020 02:33:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2AAAC43391;
        Tue, 20 Oct 2020 02:33:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Oct 2020 10:33:13 +0800
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Subject: Re: [PATCH v2 0/2] Fix some racing problems btw err_handler and paths
 like system PM ops and the task abort callback
In-Reply-To: <1600757252-23048-1-git-send-email-cang@codeaurora.org>
References: <1600757252-23048-1-git-send-email-cang@codeaurora.org>
Message-ID: <e45273aa4cab164a9f8ec2c2dd1c208e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2020-09-22 14:47, Can Guo wrote:
> This series mainly fixes racing problems btw err_handler and paths like
> system PM ops, async scan and task abort callback.
> 
> This series has been tested with error/fault injections to system PM
> operations, async scan and task abort to the UFS device W-LU.
> 
> Change since v1:
> - Removed Change-Id from commit msg
> 
> Can Guo (2):
>   scsi: ufs: Serialize eh_work with system PM events and async scan
>   scsi: ufs: Fix a racing problem between ufshcd_abort and eh_work
> 
>  drivers/scsi/ufs/ufshcd.c | 122 
> ++++++++++++++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |   3 ++
>  2 files changed, 89 insertions(+), 36 deletions(-)

How is your test of the 2 patches going? Could you please give your
review since they've been here for a while.

Thanks,

Can Guo.
