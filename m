Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C25C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46FD6335E
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 18:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242735AbhKOSvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:51:36 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:35592 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbhKOStK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 13:49:10 -0500
Received: by mail-pg1-f177.google.com with SMTP id p17so15360670pgj.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 10:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4TsFkpOxjmTTIyqdCBuDp8N+seu4IkF3YkCjf7aCw14=;
        b=1Twnx51WPKXMEPWzQX+fx7x4uWwKnW8CblhAgF0gKIcxiApjWAvv3WLOIhu61ldJYT
         c+nOsnrUj7SVJfd/xBWdteW9lvLCziLgOAC+PMoklJVV2/VTKV+pBMIbTSC9dYemmesM
         KwAIEZLwsf88j1BM4xDqu5r4SNhy/kdjoGSHbvOFW+bu/l7tyzdjPqfBeINOFatisi9o
         2gzeiVsnW2plhkcTFDOBDGNOT5hN0u63VSU0LUFDQamEZZfJLvUa56f+mS8BlDqGQAeH
         gWB7EfEZPRNWwbcn6hGxRVpfZBnKFAs+j+omBAtAizFaoeWqu4cFS4DBHRIzUJtJExtL
         HPKQ==
X-Gm-Message-State: AOAM531LW2VOnwmgmpCxhZbi9N2OZkJEk1Kk3XUrXbuYi3yf8x54GBD+
        zpJGt2dKlziq0GqrbFDiV9E=
X-Google-Smtp-Source: ABdhPJzimhNZPyzXdWnf2T3GKcHGCwES/TN6qgh24G2QiBs6XaOUHJQjXazGfn+kw743tcYe+4FKxQ==
X-Received: by 2002:a63:5f02:: with SMTP id t2mr694548pgb.452.1637001974342;
        Mon, 15 Nov 2021 10:46:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id t21sm12030451pgo.12.2021.11.15.10.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:46:13 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: core: Add support for reserved tags
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-2-bvanassche@acm.org>
 <139e5cb6-c91e-fa64-f261-6359b6abe376@suse.de>
 <57aa04ba-edd5-93b9-4e0d-2fda4ccbe975@acm.org>
 <7f778b12-fe9b-f685-30f4-1c9f2ecdd571@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b6710811-77f5-a135-f7b0-cbbfef3424b5@acm.org>
Date:   Mon, 15 Nov 2021 10:46:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7f778b12-fe9b-f685-30f4-1c9f2ecdd571@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 10:54 PM, Hannes Reinecke wrote:
> On 11/10/21 8:19 PM, Bart Van Assche wrote:
>> In the UFS driver we are using a request queue that is not associated 
>> with any SCSI device for allocating driver-internal tags from the same 
>> tags space as SCSI commands. Is this a solution that is generic enough 
>> to be re-used by other SCSI drivers? See also the output of git grep 
>> -nH 'hba->cmd_queue'.
>
> Ah. Even easier.
> I've made a prototype for this kind of operation in
> git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> branch scsi-internal.v1
> 
> That introduces a function 'scsi_host_get_internal_tag()'
> to retrieve a tag from the reserved pool of the host tagset.
> Would that work for you?

That works for me. Thanks for the feedback!

Bart.
