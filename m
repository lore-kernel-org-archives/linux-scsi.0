Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CAEC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 06:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8777613B1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 06:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244712AbhDMGcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 02:32:14 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.161]:48521 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230350AbhDMGcO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Apr 2021 02:32:14 -0400
X-Greylist: delayed 1504 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 02:32:13 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 420475DB7
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 00:45:47 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id WBrula0TZMGeEWBrvl4LEa; Tue, 13 Apr 2021 00:45:47 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FdPe7BzPOHgzj9TAvNc5/1y9jOqgs2aGr6NfsdIlyjs=; b=FFxIhESqbN4S3mFCetyJhSUf+O
        zl+teQNvVNZGJ6wZmWOqESG6ZyvCVFoXMhRxNXaG0S/Dzvps1W8X1XjntvoTKamXop8KSlzcqkzvF
        +aE0Stl1LcGnrLP6+lDVloFMeYxF3kQP+viXkSA/5i3LepxaHyXOB3c9uakm+/tgFNTkJzoIdIAit
        h9nZSPmcEsnlryDNAW22w/t8GNCD5GbXFwCBtRikP5cgNSL9WdIGBCShtefyD+QcYZepwjivEyTA0
        1+L42/ERkUxCAPxAo8y/xTxjxTzuMfjl2xsN81ucyxKQKrh7Sf++QyCRf4oZGdAYfTlbLAfObJcv5
        vNVWGfvg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:43606 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lWBru-000DkR-Kb; Tue, 13 Apr 2021 00:45:46 -0500
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210304203822.GA102218@embeddedor>
 <202104071216.5BEA350@keescook> <yq1h7ka7q68.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <aba7d5cb-79be-088d-d1f8-9309109e9afc@embeddedor.com>
Date:   Tue, 13 Apr 2021 00:45:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <yq1h7ka7q68.fsf@ca-mkp.ca.oracle.com>
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
X-Exim-ID: 1lWBru-000DkR-Kb
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:43606
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 4/12/21 23:52, Martin K. Petersen wrote:

> Silencing analyzer warnings shouldn't be done at the expense of human
> readers. If it is imperative to switch to flex_array_size() to quiesce
> checker warnings, please add a comment in the code explaining that the
> size evaluates to nseg_new-1 sge_ieee1212 structs.

Done:
	https://lore.kernel.org/lkml/20210413054032.GA276102@embeddedor/

Thanks!
--
Gustavo
