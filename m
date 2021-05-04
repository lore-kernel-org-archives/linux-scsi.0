Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1927C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9345660FF3
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 03:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhEDDys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 23:54:48 -0400
Received: from gateway30.websitewelcome.com ([192.185.147.85]:24341 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhEDDys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 23:54:48 -0400
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 23:54:48 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id E0CAD22AC0
        for <linux-scsi@vger.kernel.org>; Mon,  3 May 2021 22:05:47 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id dlNblFar0b8LydlNbl6IPC; Mon, 03 May 2021 22:05:47 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ynxraRepmF/wrqfGBTtF/Lw0WBzJdQn3z0ZlaWeqP84=; b=vfECnkExo4slsELE9bkegI0Zc1
        Dk3NUlTvOUzm+mm7/dUwu7OJQY9Anp0NAa+IMd1Ta2/P1BVp95w2KlzS17P18Ij3d78793ukGs5nK
        udB0jhviIsFxr4Sb/SQfWMqgBI69q2g1jC2OmWokwhOUQlV0mm0iAoSNwV5ohmHoNaARd5l889pcE
        QA4FAsWtN4Wo4JQbChkjZrnrRT4CW/up5AQcqMcS9t57EtrauuDXTtkp9OZcDThHtitH6NEEWDsuE
        +Cvt5vi6JnVUrgHV/I2gKiweYRUgXlpKT+7nRkcdUIrDhjv+5zZXCWmSLGFchbscWcqOk+wsJpM3Q
        9NLv9jsQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48928 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ldlNY-000JBD-Gm; Mon, 03 May 2021 22:05:44 -0500
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20210421185611.GA105224@embeddedor>
 <d26823dd-5248-4965-cc30-f9e6294536ee@embeddedor.com>
 <yq17dkfky0x.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <ce4091f6-f9c2-713b-2bdf-236db4b00783@embeddedor.com>
Date:   Mon, 3 May 2021 22:06:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <yq17dkfky0x.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1ldlNY-000JBD-Gm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48928
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/3/21 21:56, Martin K. Petersen wrote:

> Applied to 5.14/scsi-staging, thanks!

Awesome! :)

Thank you.
--
Gustavo
