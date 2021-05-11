Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0793BC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6B161278
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhEKDxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:53:14 -0400
Received: from gateway20.websitewelcome.com ([192.185.62.46]:49233 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhEKDxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 May 2021 23:53:14 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2021 23:53:14 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 2C592400C53A3
        for <linux-scsi@vger.kernel.org>; Mon, 10 May 2021 22:18:24 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id gJ6IlHB81MGeEgJ6IlNEW4; Mon, 10 May 2021 22:30:26 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0T6q/WobVSrKEX00/Jpr82hwjxlRylETOPsQdVzHh0U=; b=azPwngBrgVv9uGzfbKYrK7WYeN
        rqjxV33JsNrLRV4thGTP0bOxTEo5Jq5gzt9Rb1TNw3HzVjpYYmFVXVxOYTX4y7HN22dXVU450TyT4
        K6g8M77ESL80DooqTvhHCnOnw3MJSci2kaNnhoZP8mjr4z5fjCo5gWA92071Q7QrRb0BNI2V7nUZ2
        nX1F1GVjji1GNoXjWbiCPqaenViXmifiFHkRwzOGK4lPVfZIysy02Mro2czEz8odvhFgKAh8vipU8
        PjT4R+mhEOSwHmhKlyzblS+huuEIfSpls6bVrGqM3324iYMmS9ytSpGfCN8y3in6KgIjhnpCzi0J0
        DVolRIoQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:43694 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lgJ6F-003Pgb-Gu; Mon, 10 May 2021 22:30:23 -0500
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210421185611.GA105224@embeddedor>
 <162070348784.27567.4297596089347883095.b4-ty@oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <65719db1-b1ec-8466-5f39-27af16d8a701@embeddedor.com>
Date:   Mon, 10 May 2021 22:30:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <162070348784.27567.4297596089347883095.b4-ty@oracle.com>
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
X-Exim-ID: 1lgJ6F-003Pgb-Gu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:43694
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/10/21 22:25, Martin K. Petersen wrote:
> On Wed, 21 Apr 2021 13:56:11 -0500, Gustavo A. R. Silva wrote:
> 
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> Refactor the code according to the use of a flexible-array member in
>> struct aac_raw_io2 instead of one-element array, and use the
>> struct_size() helper.
>>
>> [...]
> 
> Applied to 5.14/scsi-queue, thanks!
> 
> [1/1] scsi: aacraid: Replace one-element array with flexible-array member
>       https://git.kernel.org/mkp/scsi/c/39107e8577ad

Awesome. :)

Thanks, Martin.
--
Gustavo

