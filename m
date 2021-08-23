Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9286C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 22:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78F460F4C
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 22:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhHWWb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 18:31:57 -0400
Received: from gateway34.websitewelcome.com ([192.185.149.13]:11074 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229760AbhHWWb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 18:31:56 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2021 18:31:56 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id DA10C2BC35A
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2021 17:09:20 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id II88mtDACrJtZII88mSZBH; Mon, 23 Aug 2021 17:09:20 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Nvz4RJ/c/ELjx3o/GfsmIR+Yc//YtkkK/MQGr5AMep4=; b=zv/w2fImFL6b0Vo0Dxl/s87Kcx
        hCdga5LHQftIJUkQ5PdSnygHb5Tlff/KB/athbmQIF06S0yY/wVErVf4xeYHo3A5qbR0y7RJKWtwK
        VPKFWbHCbhDwrUkpdBl2fd41cugSPok7xtuiWUSYfGHZM2hJ+Zou3wLplyXyHgR7GMQDswiKfOZFP
        IpdB0M0YdxVbE/UTpDuoQsq4N0/ATPSQHcfjCEpLMGefo24xm/b1Zoi63IkHZuXrIMc/6Znqutxr3
        O90g3stlvYxKEdtDwz2N+/7rtdxCCHWZI7/nx7i5yMQowBeuaTH2PSlBlIvS3nEiNtv/RWlFpM3Yr
        vG42CHqQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:36712 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mII88-001CSE-7v; Mon, 23 Aug 2021 17:09:20 -0500
Subject: Re: [PATCH][next] scsi: smartpqi: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210810210741.GA58765@embeddedor>
 <yq1pmucojub.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d721d67e-1eb1-7d4c-24f5-a22ae7fe347b@embeddedor.com>
Date:   Mon, 23 Aug 2021 17:12:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <yq1pmucojub.fsf@ca-mkp.ca.oracle.com>
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
X-Exim-ID: 1mII88-001CSE-7v
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:36712
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 8/16/21 22:01, Martin K. Petersen wrote:
> 
> Gustavo,
> 
>> There is a regular need in the kernel to provide a way to declare
>> having a dynamically sized set of trailing elements in a
>> structure. Kernel code should always use “flexible array members”[1]
>> for these cases. The older style of one-element or zero-length arrays
>> should no longer be used[2].
> 
> Applied to 5.15/scsi-staging, thanks!

Thanks for this. :)

Could you take this series too, please:

https://lore.kernel.org/linux-hardening/cover.1628136510.git.gustavoars@kernel.org/

Thanks!
--
Gustavo
