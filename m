Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCCBC433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3AE2078E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 18:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e1CSJvhp";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="R816NwrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731697AbgIHSGk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 14:06:40 -0400
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:60490
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731513AbgIHQL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 12:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599581516;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=JcwEdDvR+N97p02uRPCMEGaYzKVquRHosx1PuKw5R6k=;
        b=e1CSJvhpy5RS4w7Bwt2YjTFBYBprV26QE00rSbyTQ1HHMADH/AJq7eZhxJixZAYn
        xYrDdlUj/gEb7jyZ33kh7O0HC8oPVdImuQEjJ7daWaiSyv9+lCPWScFuk3XSb8AWDdJ
        dXTctLuulvGdNluMoN161V2Q8/zH/+klrKLfehWo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599581516;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=JcwEdDvR+N97p02uRPCMEGaYzKVquRHosx1PuKw5R6k=;
        b=R816NwrEFuA1O6D9XbEFE8/A1G/WuelMkz8VdumyaPgLHaYXFVuvqfavDAezFVXy
        QzJN4fA3zs0e01G+LYvzAeTp4wz6TKzXwCbSht1fjUW/SsEQizj/EP8VPTWQ+qum/xX
        QDtknTThdK8/rFB6CNJd4JQkjVAOLH+LbG/uGpw8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 010CCC433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 0/2] ufs: introduce skipping manual flush for wb
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, bvanassche@acm.org, grant.jung@samsung.com,
        sc.suh@samsung.com, hy50.seo@samsung.com, sh425.lee@samsung.com
References: <CGME20200905061548epcas2p1dc708a23247702c6b1f6c0eedc513a92@epcas2p1.samsung.com>
 <cover.1599285983.git.kwmad.kim@samsung.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <010101746e7cf007-206ebd56-335c-4624-a0a6-3741c245f2d1-000000@us-west-2.amazonses.com>
Date:   Tue, 8 Sep 2020 16:11:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1599285983.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2020.09.08-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/4/2020 11:06 PM, Kiwoong Kim wrote:
> v3 -> v4: migrate these to 5.10
> v2 -> v3: modify some commit messages
> v1 -> v2: enable the quirk in exynos
> 
> We have two knobs to flush for write booster, i.e.
> fWriteBoosterBufferFlushDuringHibernate and fWriteBoosterBufferFlushEn.
> However, many product makers uses only fWriteBoosterBufferFlushDuringHibernate,
> because this can reportedly cover most scenarios and
> there have been some reports that flush by fWriteBoosterBufferFlushEn
> could lead to raise power consumption thanks to unexpected internal
> operations. So we need a way to enable or disable fWriteBoosterEn
> operations. For those case, this quirk will allow to avoid manual flush
> 
> Kiwoong Kim (2):
>    ufs: introduce skipping manual flush for wb
>    ufs: exynos: enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
> 
>   drivers/scsi/ufs/ufs-exynos.c | 3 ++-
>   drivers/scsi/ufs/ufshcd.c     | 3 +++
>   drivers/scsi/ufs/ufshcd.h     | 5 +++++
>   3 files changed, 10 insertions(+), 1 deletion(-)
> 

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
