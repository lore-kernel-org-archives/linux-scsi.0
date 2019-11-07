Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3929C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D14121D79
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKGVgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:36:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44955 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGVgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 16:36:23 -0500
Received: by mail-pl1-f193.google.com with SMTP id az9so1654550plb.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 13:36:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fXLNzqrExHNP/Lv3bYvfF5Obha995uVW2KDGdlKBTR0=;
        b=SFw1Tne3FvSBDEYkHsCqNwbakSvEihLB7rX/dTKQv5TyJlvAO12n7hAmbmCbe5HPDN
         fBuv+XljAhym+6YD/rjP2XdzSBVGi1W2Tlq7fXtFIvGqk/7INS5tcHbwg9XkeWCG11bZ
         F0jK3f2GJJGpFN0p/PYey90vjxCeVaQC8mBrnsVCTksxt2sFGQ/03lERj8F+pjZnTayU
         4mbc4Amh2YNelHlypzR/mb0k3jN9oha0ru9OXybWqjTkKTbmXHGLM/qxWURfRDTk+ICi
         HccwK7TZ2mvzdBH9i0YO9fJi7vvDCWt1pNidpwvyzOaVj5BCwV94imJ17eFxoBrXdsF4
         nRyg==
X-Gm-Message-State: APjAAAX6bftaEEN/XSX4zVPuAN0WY0ENwB3i2Z4LJlrySq8x+NShdq5q
        jjt8N9gzg9g2VDo8h7HZJ6AD3fD6
X-Google-Smtp-Source: APXvYqwXErFhwkKbHucBpdyGR6xOd6+4ZNWGAWchoU8ar9zp+Y26ed/cDYW1LwZnzRVxOf10upfN+w==
X-Received: by 2002:a17:902:bf0c:: with SMTP id bi12mr5870584plb.98.1573162582542;
        Thu, 07 Nov 2019 13:36:22 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x29sm4284643pfj.131.2019.11.07.13.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 13:36:21 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
From:   Bart Van Assche <bvanassche@acm.org>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20191107164848.31837-1-martin.wilck@suse.com>
 <20191107164848.31837-2-martin.wilck@suse.com>
 <4935afb4-a54f-5ebd-d9bd-bf4da70ba088@acm.org>
Message-ID: <e5425bd0-6cb6-81ff-e8af-5392454b72a1@acm.org>
Date:   Thu, 7 Nov 2019 13:36:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4935afb4-a54f-5ebd-d9bd-bf4da70ba088@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 1:26 PM, Bart Van Assche wrote:
> On 11/7/19 8:49 AM, Martin Wilck wrote:
>> Avoid an uninitialized value being falsely treated as NVMe priority.
> 
> Although this patch looks fine to me: which uninitialized value are you 
> referring to and how does this patch make a difference?

Does your comment refer to ha->fc4_type_priority ? You may want to 
mention this in the commit message since that variable does not occur in 
the code touched by this patch.

Thanks,

Bart.
