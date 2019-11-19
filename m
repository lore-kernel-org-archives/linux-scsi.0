Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77502C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 17:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44A3B222B6
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 17:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T/uoVxbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfKSR0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:26:00 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45604 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbfKSRZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 12:25:59 -0500
Received: by mail-wr1-f67.google.com with SMTP id z10so24819959wrs.12
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 09:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=OMBD2QQQoCU7yP4WQk94AyQxF7iHg8KGVWW/zSQqulg=;
        b=T/uoVxbxYaOGX9wqZEjZPIu86xOQXEOo+zSrnymeJE1BmxQ/5isXpNgw9KaEwUfy4f
         aqGEmmCCeQ4tk7QUk0CmJwerFOFZ7PCOlzDjm5WHRqZ9EPuQCNrXQcd7/Zim1qZpRPQ6
         U2CLL7GQMMk57BFK/eDnq8Wy2pXqSLH+Dv8eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OMBD2QQQoCU7yP4WQk94AyQxF7iHg8KGVWW/zSQqulg=;
        b=f764NQQflfDB5r0qjroyJjED7aw/dpTuNx4A65M0NEaExDp0f0Qhj3rq9BUtbDfHq5
         +O67RC3Tjrl0FP+1lbQOp6U3bkGreQ2bvHI2wRS6JsFF03/4gor02/IHQKV4XdplORWh
         QF9SgvBNsTdxSYsusk2cuJM/odhlyzsPpCY3T2dGQ6KwAZupzBIYXqqZa3PEXWCi4AmE
         zfXQ9jv4BPpShau4KPRDUl8rwYKKkIUAi0pbOIo/UK45Yf1bzxdU1BnpTRzt26mu6I/Z
         LdtTPYk8maemUUHjk685UMLqL9J314EORImpp1YTGwWJZv3eZWXmqvChPAuwe8gmpJL4
         UpoA==
X-Gm-Message-State: APjAAAUXn+jqaY8oPrC/0Xo/1fNklNjaaQyboHtt9TTZhxW84Rjo0zCz
        jwaKrpl9/qZp3nwexSPArbY0tA==
X-Google-Smtp-Source: APXvYqwRxcjVLzTu9mvOATHREjWzHA6YUWlAbUmR0OMRD1Z4pbe9YbkHAsoujaznD5BMXjTcATrEJg==
X-Received: by 2002:adf:c786:: with SMTP id l6mr36689212wrg.45.1574184357732;
        Tue, 19 Nov 2019 09:25:57 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y16sm27846357wro.25.2019.11.19.09.25.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:25:57 -0800 (PST)
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
To:     Daniel Wagner <dwagner@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>
References: <20191105080855.16881-1-dwagner@suse.de>
 <yq1h838pivf.fsf@oracle.com> <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <4a1fedc9-03f1-7312-fd50-a041a78c0294@broadcom.com>
Date:   Tue, 19 Nov 2019 09:25:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/19/2019 5:28 AM, Daniel Wagner wrote:
> On Tue, Nov 12, 2019 at 10:15:00PM -0500, Martin K. Petersen wrote:
>>> While trying to understand what's going on in the Oops below I figured
>>> that it could be the result of the invalid pointer access. The patch
>>> still needs testing by our customer but indepent of this I think the
>>> patch fixes a real bug.
> I was able to reproduce the same stack trace with this patch
> applied... That is obviously bad. The good news, I have access to this
> machine, so maybe I able to figure out what's the root cause of this
> crash.

fyi - Dick and I were taking our time reviewing your patch as the major 
concern we had with it was that the splice and then the re-add of the 
work-list could have an abort complete before the IO, which could lead 
to DC.

We'll look anew at your repro.

-- james

