Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB14C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E44613B1
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhFBDzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:55:42 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.163]:16127 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhFBDzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:55:41 -0400
X-Greylist: delayed 1329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2021 23:55:41 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 260D5A6B2
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 22:31:48 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id oHbgl0AbjFRe9oHbglrLR5; Tue, 01 Jun 2021 22:31:48 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AfWP1Z4PsKQNJdy+qj3nFeR73DG6rWnP+m6kb1hdY5U=; b=NPhBLL6zu1P27XysgHWpg1WaJ1
        n4sjgEcqMkf618mQ0A8pbL+d9ez2y519I+4UflOYFvrneazglHKzOu7Ol5rxII96fSiEsPF7RIBUz
        T54EHLJtfAIpLocBKmN25PZSFd8Onj5dhoFmAgsOiXNatdON/gmwTLC5bixkB/TfgJfQzjeXNtMjy
        XGr3K2e46+OHSqkfhXU/VjzdimBzlG8HP7CvMZFDUyhSzQYdy/8g9FPE033DAOhG+/hOq3xpTIf+o
        afY8CnMNfUZiu5ezGS09s6dHs1EkhC/zB5dHVaWQa5KXBjpVEGwafXcWjRjZ5v1KHKuMwM97yyW/4
        dkvaylog==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:54416 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1loHbc-001hKJ-Js; Tue, 01 Jun 2021 22:31:44 -0500
Subject: Re: [PATCH][next] scsi: mpt3sas: Fix fall-through warnings for Clang
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210528200828.GA39349@embeddedor>
 <yq1v96xosp0.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <3fed84fc-ee7d-86f2-b0a2-d80a30fb1907@embeddedor.com>
Date:   Tue, 1 Jun 2021 22:32:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <yq1v96xosp0.fsf@ca-mkp.ca.oracle.com>
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
X-Exim-ID: 1loHbc-001hKJ-Js
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:54416
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/1/21 22:23, Martin K. Petersen wrote:

> Applied to 5.14/scsi-staging, thanks!

Thanks, Martin.
--
Gustavo
