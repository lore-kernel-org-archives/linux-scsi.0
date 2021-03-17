Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D34C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 04:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6BD264F99
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 04:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhCQECD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 00:02:03 -0400
Received: from gateway36.websitewelcome.com ([192.185.196.23]:32100 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhCQEB5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 00:01:57 -0400
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2021 00:01:57 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 8FD1F400CF46B
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 22:41:23 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id MN3jlhwWHmJLsMN3jlWLtI; Tue, 16 Mar 2021 22:41:23 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/sZG3o7bmfQMeV8ZtSlTyo3QgbzHhviO3Gw8P9Lg0T0=; b=L6WeIS/ZZGmAWcRpydJ4g0+0eX
        1O8GR11G+9gyFvVN66KjWDWCxBfctGT1RdJMupOs1AIYstL3gcgOzvxXkyyq3cKhifIlFlBVgJBQ+
        JHHrwEe4EvQJXusSGZ2cqBYLq9tM7KpwjCYx80BXEoVvkVzEwOAa4TSHDFSrjFQh2RQOQDQyum/RN
        tl73Ku7l4RFkiZhqyz2LPFnfIBQCdcHPQjz6QGGEU3RKwRX++ytDi+h2posIFQB9vh8PzqFI+lWoN
        8I44w3WyVIakJ5XbtagHV6Fri7/xh0iOGsEbRZiI6sLi+BOZH0MloDrxB51LSHTf222/mi8MeH2Dr
        sv4zJmCw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:46638 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lMN3j-000pjB-5C; Tue, 16 Mar 2021 22:41:23 -0500
Subject: Re: [PATCH][next] scsi: mpt3sas: Replace unnecessary dynamic
 allocation with a static one
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210310235951.GA108661@embeddedor>
 <yq1eege1mlt.fsf@ca-mkp.ca.oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <62fa8461-23d3-5602-2897-f2b28344bedf@embeddedor.com>
Date:   Tue, 16 Mar 2021 21:41:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <yq1eege1mlt.fsf@ca-mkp.ca.oracle.com>
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
X-Exim-ID: 1lMN3j-000pjB-5C
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:46638
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 3/16/21 22:32, Martin K. Petersen wrote:
> 
> Gustavo,
> 
>> Dynamic memory allocation isn't actually needed and it can be replaced
>> by statically allocating memory for struct object io_unit_pg3 with 36
>> hardcoded entries for its GPIOVal array.
> 
> Applied to 5.13/scsi-staging, thanks!

Awesome. :)

I wonder if you can take a look at this one, too, please:

https://lore.kernel.org/lkml/20210304203822.GA102218@embeddedor/

Thanks!
--
Gustavo
