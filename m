Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BBDC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 18:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C0321D6C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 18:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKGSai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:30:38 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43912 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfKGSai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 13:30:38 -0500
Received: by mail-pl1-f196.google.com with SMTP id a18so2066578plm.10
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 10:30:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=On+kvHgkoyY9xOpTQZYPwjhACHIVNdHQgh4V2JhduWM=;
        b=hFDE91G2zusuCYV50IwNJFZ89/s/8MxKbLzzJzz6Z7CBUA2du28CIaFvEK93EJzv2z
         Ds8Ouxe4S2eVzNNDG/+x20F0nyv4/CWmKVJ/Z/RBM6PDlmSpsR2ErFL2xFOXI2m1Yf9W
         NPt4QqQs947lc9ZkOGLpzdTOO2/9Hy6DCyGB0wFBjWLkLI3qgSncpRJ12DzDA69FfmN6
         1WwQpPkVzCvg7fyGFWr7SqCdQetw70XIoqAOUlsEY5ft9uISYuz/JHTzGiCiDcVBIZTh
         x7/fy/m9+em6e3mycDYXInM82aiUaHuSZkSC4TOWqyWbURdQu5AwMfiz3dEZS/12F4Iy
         x31w==
X-Gm-Message-State: APjAAAXMu46fekM/XOPROD7A/S7X76B34XZ9sJOuw3uINvOeiJUm1txW
        reDGCZeq2xG1+Q8pw/gqS+c4FuaD
X-Google-Smtp-Source: APXvYqxdT0XsCB4yN6103z/H48rt2kxHRqMDxWafWbW1uZJ8f3hseDwjBs9r5O/3KofgpTglZODbow==
X-Received: by 2002:a17:902:8bc2:: with SMTP id r2mr5459060plo.36.1573151436555;
        Thu, 07 Nov 2019 10:30:36 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a21sm3303091pjq.1.2019.11.07.10.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 10:30:35 -0800 (PST)
Subject: Re: [PATCH 4/8] qla2xxx: Fix driver unload hang
From:   Bart Van Assche <bvanassche@acm.org>
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
Message-ID: <cff0bb9a-4495-1064-dffc-5a15dcb30dbd@acm.org>
Date:   Thu, 7 Nov 2019 10:30:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <10b38f34-128a-fd71-1542-9025dc107f62@acm.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 9:58 AM, Bart Van Assche wrote:
> Does your answer mean that this hang has not yet been root-caused fully
> and hence that it is possible this patch is only a workaround but not a
> fix of the root cause?

Answering my own question: I think that a qpair refcount leak is a 
severe problem and not something that should be ignored. How about 
changing the while loop into something like the following:

	if (atomic_read(&qpair->ref_count))
		msleep(500);
	WARN_ON_ONCE(atomic_read(&qpair->ref_count));

Thanks,

Bart.
