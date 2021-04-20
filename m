Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8792C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A23F861221
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhDTDVL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:21:11 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:37617 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhDTDVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 23:21:09 -0400
Received: by mail-pg1-f177.google.com with SMTP id p2so10205590pgh.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 20:20:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=puc/cQ319Wz7meNvmeMFkMHqWA0VDWNdHtKYUYLxtkw=;
        b=A41Iuz05rGkG//wWlE2rQHm+W2EX8cJIYQIiBpxGt/JtWAFtsJIa0JR3n7PBSlk9Ty
         5CQj+OYXXUHxiXLDo/K/NHsXrROaR4uX7w3euxGoBSFYetVZIqdvQNCLH9Qwi+iDyV5t
         kfxBvaE+p1R7JMBqeNd+GYjQdYKRJOoj4J+GSls5RthMGBu4FGaKR1/zGMDUSA3b5JAt
         42cZczqLhQ95azo6z0c1DOSxRvwb4bZ7CRF5ZbTnWzx3VATv19Tl2J64Ih7QVGed54XG
         BQE3MkYyTGRs5gI3asUpXw9nWXFDRv5FGjmVeOAcnzPw1ghfB1LAtO9j+yW9uxY/bOeA
         yO1Q==
X-Gm-Message-State: AOAM532k16IU6Hc1ygJ4jgT9x7Z0fEPzk0zxkQ1mhI+PgEyJHFtxuhkO
        O6V5mtX2HG3hM8GQCgwGV44=
X-Google-Smtp-Source: ABdhPJxsBkWw+9OhwRDO8rsLL0T8sbRw0mansbwzBAHOupp9OpPUcphd/fXM0v3RB4yx0aSkXuwTWA==
X-Received: by 2002:aa7:8a4e:0:b029:263:5a27:e867 with SMTP id n14-20020aa78a4e0000b02902635a27e867mr1831556pfa.55.1618888838917;
        Mon, 19 Apr 2021 20:20:38 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3e77:56a4:910b:42a9? ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id b23sm751218pju.0.2021.04.19.20.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 20:20:38 -0700 (PDT)
Subject: Re: [PATCH 027/117] advansys: Convert to the scsi_status union
To:     dgilbert@interlog.com, Matthew Wilcox <willy@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-28-bvanassche@acm.org>
 <20210420014917.GH2531743@casper.infradead.org>
 <f77989f9-f0fa-b878-f3ec-60065845f9c8@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c227b552-35df-21bf-f16a-5f83ccd425fa@acm.org>
Date:   Mon, 19 Apr 2021 20:20:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <f77989f9-f0fa-b878-f3ec-60065845f9c8@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 7:27 PM, Douglas Gilbert wrote:
> And it is non-bisectable (I guess) and could only be made bisectable
> (without some ugly unions) by rolling it up into one patch. But having
> separate patches definitely makes it easier for me to look at the
> sg and scsi_debug driver changes, which look fine at first glance.
> 
> Is there any way to mark a patchset like this non-bisectable? And
> I think a separate patch that explains why this is being done (cause
> the cover-sheet gets lost). Then git might think of a way not to
> repeat that explanation 107 times.

Hi Doug,

If this would be considered useful I can integrate the text from the
cover letter into the description of one of the patches in this series.

This series should be fully bisectable. If not, it means that I made a
mistake.

Thanks,

Bart.
