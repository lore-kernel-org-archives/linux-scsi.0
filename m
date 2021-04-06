Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0C0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 10:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 186A6613BD
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 10:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhDFKSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:18:40 -0400
Received: from gateway22.websitewelcome.com ([192.185.46.229]:44444 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235980AbhDFKSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 06:18:40 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id E03EE2996F
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 04:58:21 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id TiTVlbQae1cHeTiTVlw8CD; Tue, 06 Apr 2021 04:58:21 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IzX4cfcD3Tvkceqwxmn15aHQjEVS0LM4NuODycgrcRc=; b=CfuDp3DThsr1ONZhKaEbg5gMUV
        POcXAFzPlHfMbaky6nNSQoi5IhqTFz2EpvJphGf04kifcK/rAQmbv9tHGX+yIop4DExpqcvnRsIMh
        ca4XAHWdeouVltU/t5rmvBpeqaxbuDP9q/zwoDZt1ro0vffGScxvMNUHpVLbUyb/9g96+cdK/46QR
        o+za4txpmLA4k+SS8uLovSWV5QX5uKx21jbcEgRAhsi3X6sUzt9K8+WEECTAIMFTDMB6Uwvs7AwN1
        bz0JtUp85sXn3Kn83F2H8BsOn7+6kED17a8RpIhX+9ccLFL6hXJmDGqR+TGsLMlIFqvxWWPsXdfc2
        fYdpvQIw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:43894 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lTiTU-000uuI-Rb; Tue, 06 Apr 2021 04:58:21 -0500
Subject: Re: [PATCH][next] scsi: mptlan: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
References: <20210324233344.GA99059@embeddedor>
 <161768454092.32082.2593948568576658600.b4-ty@oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b1354342-e9c9-5fea-ab50-e996fb790a5f@embeddedor.com>
Date:   Tue, 6 Apr 2021 04:58:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161768454092.32082.2593948568576658600.b4-ty@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lTiTU-000uuI-Rb
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:43894
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 4/5/21 23:53, Martin K. Petersen wrote:
> On Wed, 24 Mar 2021 18:33:44 -0500, Gustavo A. R. Silva wrote:
> 
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> Refactor the code according to the use of a flexible-array member in
>> struct _SGE_TRANSACTION32 instead of one-element array.
>>
>> [...]
> 
> Applied to 5.13/scsi-queue, thanks!
> 
> [1/1] scsi: mptlan: Replace one-element array with flexible-array member
>       https://git.kernel.org/mkp/scsi/c/4e2e619f3c9e
> 

Thanks for this.

Could you apply this one, too:
https://lore.kernel.org/lkml/20210304203822.GA102218@embeddedor/

This was my last reply to the thread:
https://lore.kernel.org/lkml/d79bde59-16c5-e006-0e31-c33c17f0ce3d@embeddedor.com/

Thanks!
--
Gustavo
