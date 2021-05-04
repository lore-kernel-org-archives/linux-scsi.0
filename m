Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E27C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58C761244
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhEDC0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 22:26:51 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:37501 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDC0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 22:26:50 -0400
Received: by mail-pg1-f182.google.com with SMTP id d29so4571439pgd.4
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 19:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ypA9EvrtXIjbGOu0vXJ9XM3WMPUsaYzMYftKtQut9vM=;
        b=AUXGQP76Hu+4/QjXsrHNNZf0f5mVeiKUjzyoRFxkQKVUllV5bSse2SjJIiRLs7Zn7f
         dF0i9NVMCp2SaiQ+CgGOCc2ZexeYkoX2u3v+YMxr9Xg2oSxPmsYWnXoWeSx9Z+qNoRNB
         0oRzwWzCVqxmqmJj4tNuIY8je4OmHh3+7VGjrIE7hfov56gXIr3foxUJ79FQ8/g9UEEc
         d3+HZ3eiuErJMS0I4hZoxWm8XtAKF0tFis3G4kOs4OqLLN8HnISkQeW5nYFCM23/VnYP
         5vGSxyt+g58xxZRdDDh66+wIx633oEnrEE+OG1eMeOsgakKJZqgRo4chhe3TnVDZrkE3
         exqg==
X-Gm-Message-State: AOAM530b+OSSY6vyPAinOpFJmAeA3uS84whR+1FdHptUvIqtOKLT2HPe
        imONgh9tgVkJVn+j2VguI6b2p3qENsE=
X-Google-Smtp-Source: ABdhPJwd+SO6h43D8/mzsrrbExS7wTY+z0ZadA6oiGYsvErqLfc1UJUxV0ycP2b4QkVh6ui7du1hUg==
X-Received: by 2002:a17:90a:f68f:: with SMTP id cl15mr2054559pjb.99.1620095155124;
        Mon, 03 May 2021 19:25:55 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id u12sm1166225pji.45.2021.05.03.19.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:25:54 -0700 (PDT)
Subject: Re: [PATCH 04/18] fnic: use internal commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-5-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <68455f2e-f3d9-52c4-d694-f45f66080c94@acm.org>
Date:   Mon, 3 May 2021 19:25:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> -	tag = sc->request->tag;
> -	if (unlikely(tag < 0)) {
> -		/*
> -		 * Really should fix the midlayer to pass in a proper
> -		 * request for ioctls...
> -		 */
> -		tag = fnic_scsi_host_start_tag(fnic, sc);
> -		if (unlikely(tag == SCSI_NO_TAG))
> -			goto fnic_device_reset_end;
> -		tag_gen_flag = 1;
> -		new_sc = 1;
> -	}

Since this patch removes the only callers of fnic_scsi_host_start_tag()
and fnic_scsi_host_end_tag(), please modify this patch such that it also
removes these functions.

Thanks,

Bart.
