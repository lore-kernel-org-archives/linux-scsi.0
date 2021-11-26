Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0B6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 23:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343742AbhKZXS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 18:18:57 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33764 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhKZXQ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 18:16:57 -0500
Received: by mail-pf1-f169.google.com with SMTP id x5so10264487pfr.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 15:13:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ptRRs5418giOGX8nSvXxT1+AoOjl6/W3w7C+b+3xNKc=;
        b=dqygWcQzv3WeszQd1VMEkJrCG+DIHT9bwbtWvFwgEr4rNUoB/WYGPx88SFseLUN+vX
         9b47L33YLP/VWN769QOks63tslKP3szZ2pQK41SCH4GPgZAV7Fh7eI96rLpyavg9Wprr
         pmUXjeWtixtlL4Vd5OspwlOjZYa5cLgXyaKC0oFi0+kw5S3KjiR2lUW+rcv+95T6bjiG
         ajH9ypEV/e0RkphePO07MtbxxquS7RHOC+F1ZMUCA/OTFqPZYSK3hZOplVWxIWqTMcuh
         RR7FEqbOfic4DC9szhLKWL7l06uXyE6g+xR4I6hvTI6bv3EbKOWntbdCPbdVhfzyXuw4
         Qh1g==
X-Gm-Message-State: AOAM533AkL7KsH3Gy7npJ3+bGW62iI5p1PyYkmQ2BDQ9936wnNebJ+bO
        6jtgImkW6+g7htfS5agtEW4=
X-Google-Smtp-Source: ABdhPJx1vWoqv8Eidlcu2ZOeMb3RecIYR4dhXU0LOpJ7kmEqDuONoJ2AF6d9HcpRIWbN1IXc6pyC8A==
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr9458883pgs.489.1637968423812;
        Fri, 26 Nov 2021 15:13:43 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id d12sm5738395pgf.19.2021.11.26.15.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 15:13:43 -0800 (PST)
Message-ID: <7964ddf8-6d48-8f6f-0800-6db0b0c4eb5e@acm.org>
Date:   Fri, 26 Nov 2021 15:13:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, chenxiang <chenxiang66@hisilicon.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <54d74843-3b14-68c2-a526-a111e26e84a3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/21 01:58, John Garry wrote:
> How about these:
> a. allow block driver to specify size of reserved request PDU separately 
> to regular requests, so we can use something like this for rsvd commands:
> struct scsi_rsvd_cmnd {
>      struct scsi_device *sdev;
> }
> And fix up SCSI iter functions and LLDs to deal with it.
> b. provide block layer API to provide just same as is returned from 
> blk_mq_unique_tag(), but no request is provided. This just gives what we 
> need but would be disruptive in scsi layer and LLDs.
> c. as alternative to b., send all rsvd requests through the block layer, 
> but can be very difficult+disruptive for users
> 
> *For polling rsvd commands on a poll queue (which we will need for 
> hisi_sas driver and maybe others for poll mode support), we would need 
> to send the request through the block layer, but block layer polling 
> requires a request with a bio, which is a problem.

How about postponing these changes until a patch is ready that converts 
at least one SCSI LLD such that it uses the above functionality?

Thanks,

Bart.
