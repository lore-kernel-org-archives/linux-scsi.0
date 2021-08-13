Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDCAC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 01:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78468610A7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 01:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbhHMBnJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 21:43:09 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:50860 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbhHMBnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 21:43:09 -0400
Received: by mail-pj1-f46.google.com with SMTP id bo18so13096344pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 18:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IUyd+V6Utc/5YFEcI5LD+eGyb/WDvNnbEO2pkSyjjfY=;
        b=hiFe9yAwtB9K2ck4R03CyANrTgdFM0iHgwY0xsWlLlHckvIkIPYbMydaqUUsj/RtFr
         FVWHq0Vpeow9k0fpzS4eFL9svwC52VOXpt4u8ehGwIWgI/gbCj7SX6muqDXabSwXtyy8
         2R8eSgXM39XUR8OrDvqILREb6HP80AD2LfNSLNMkVPdxHduzdZkQLOCtN+JNtdv9tWm+
         s6INUafoPMxpZJfHAy1V72qTA6QgmYvoGwuO0P+1SDdvqwuy8UrkXYdD2RXgj3a8afdy
         eBN1MNquY96QCjomt0AXimjEH6s/t+oRxjVoYahrBFBCpqbBxEWTEw82rXgsBRgpR7Kr
         v6yQ==
X-Gm-Message-State: AOAM530+Q9/TiffWKulmf4SH2S7soRTqw50mFxkutOzm10oPm6qDd4GG
        0DhQr6z3D0cA4RpDkZEzvYc=
X-Google-Smtp-Source: ABdhPJysGPqTEpzFQ8f6VdUNWbeBPrHQ9gGlDHPRkzkNiACFz/3WzhWWwJ87q1jdv0s6x0h4+gmSAw==
X-Received: by 2002:a17:902:e9c6:b029:12d:4cb3:3985 with SMTP id 6-20020a170902e9c6b029012d4cb33985mr167803plk.56.1628818962905;
        Thu, 12 Aug 2021 18:42:42 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:d3bc:49f8:ea5e:ed48? ([2601:647:4000:d7:d3bc:49f8:ea5e:ed48])
        by smtp.gmail.com with ESMTPSA id h24sm19673pfn.180.2021.08.12.18.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 18:42:42 -0700 (PDT)
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
 <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
 <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
 <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
 <a8d96139-dcff-d37e-06fa-c2e46c75a309@suse.de>
 <798dbe0f-8ad0-6aa8-39e6-059dea4267b3@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <237bf5da-cd9f-e3e6-9fce-fc8e44d9ef36@acm.org>
Date:   Thu, 12 Aug 2021 18:42:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <798dbe0f-8ad0-6aa8-39e6-059dea4267b3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/21 2:05 AM, John Garry wrote:
> Bart, feel free to make a similar change - I don't want you to think I'm
> hijacking your work.

Hi John,

Since these patches are your work: do you perhaps want to post these
patches as a series? In case you want me to post these patches as a
series, I'd like to keep your name and email address in the git
"Author:" field.

Thanks,

Bart.
