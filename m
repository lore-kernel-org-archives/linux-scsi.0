Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FE8C17441
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 23:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E5C20673
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 23:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKHX6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 18:58:41 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42922 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHX6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 18:58:41 -0500
Received: by mail-pg1-f194.google.com with SMTP id q17so5086146pgt.9
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2019 15:58:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=by6k9WUQnpIGUiKq2nPiTEfm/oSWm8qP2sEiWRNQD3w=;
        b=Lo1GBSbAVwy+djn34ueGopajjyJ9cUPyh/OIOaN8GQZmmC29QqepRy8FuMG3LBomW8
         ckatdTDqIqOVCnavzfJaRuR0liPdwmHpWXwa19fSNSzgQRKZrPA6+tObpQdF6CEkoADw
         dvNSo+p/IxD4jSZn33MAt1TlRR6/wUhYH3tz3WS9BbR5Kt+vwJN+//miTLP6v/IWRrnJ
         tRuXndqguevplzK3QS7HHThQptzem3D6pyK85BPH6NqhzJrAx07IkEa2nfO7dJROmZRu
         f2s5XmOJnhtgcqg/R7fqz6xqdzKD/MDWFbknqpuklg3Ir3z7rUMIGrFBReiydIiLdL+9
         YiEA==
X-Gm-Message-State: APjAAAXAt6FsdnT7cquPelUwUYntZyr0kSi1IaywBkksnAyeKB/pR9wz
        t6jrx6cP6V1SGLhlFmzLZaPqJqeO
X-Google-Smtp-Source: APXvYqwbmFu45WBM+S5gzEDRB2PfFBQdBYTh5twSYZzVrlr3TOoD57qHSB4LaOT3BdWE6MLnlFUz4A==
X-Received: by 2002:aa7:8495:: with SMTP id u21mr15116360pfn.159.1573257519816;
        Fri, 08 Nov 2019 15:58:39 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id k2sm6100537pjl.5.2019.11.08.15.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:58:38 -0800 (PST)
Subject: Re: [EXT] [PATCH 4/8] qla2xxx: Fix driver unload hang
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     "<James.Bottomley@hansenpartnership.com>" 
        <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-5-hmadhani@marvell.com>
 <f4c6df6c-f1b1-d465-dc41-dc8e63df56e2@acm.org>
 <83CC0DDF-4907-41A2-91EC-1569A07A6BA9@marvell.com>
 <10b38f34-128a-fd71-1542-9025dc107f62@acm.org>
 <cff0bb9a-4495-1064-dffc-5a15dcb30dbd@acm.org>
 <1516C4D6-198B-45E1-82E8-5FDE39BEDAEB@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5f23db54-1e22-e0ab-f56d-be855b2c5002@acm.org>
Date:   Fri, 8 Nov 2019 15:58:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1516C4D6-198B-45E1-82E8-5FDE39BEDAEB@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/19 3:38 PM, Himanshu Madhani wrote:
> Hi Bart,
> 
>> On Nov 7, 2019, at 12:30 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>> On 11/7/19 9:58 AM, Bart Van Assche wrote:
>>> Does your answer mean that this hang has not yet been root-caused fully
>>> and hence that it is possible this patch is only a workaround but not a
>>> fix of the root cause?
>>
>> Answering my own question: I think that a qpair refcount leak is a severe problem and not something that should be ignored. How about changing the while loop into something like the following:
>>
>> 	if (atomic_read(&qpair->ref_count))
>> 		msleep(500);
>> 	WARN_ON_ONCE(atomic_read(&qpair->ref_count));
>>
>> Thanks,
>>
>> Bart.
> 
> Since we had seen this hang in a specific cluster environment and refcount leak was observed, I would like to add this patch as is and will consider your suggestion to verify if adding WARN_ON_ONCE will make any difference. If we discover that adding WARN_ON_ONCE indeed helps, then I will add a patch with fixes tag during rc window.
> 
> Let me know if you disagree.

Hi Himanshu,

Please do not suppress reports of kernel bugs but instead make sure that 
some report is provided that indicates that something went wrong and 
needs further attention.

Thanks,

Bart.
