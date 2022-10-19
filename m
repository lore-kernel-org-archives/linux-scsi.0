Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AA1C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 21:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiJSVLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 17:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJSVLM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 17:11:12 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6CA183E11
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 14:11:11 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id b5so17395245pgb.6
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 14:11:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bqfj5QumneczF79gsMRxucFVdiol1CAr+JQNpOVg9BY=;
        b=YPgMBL6vT7ifkrgHnMQg085YGeaw6lTgwqMJGvciuyhdmH6ZpV+K39HTidsiRXjy3u
         a4eKve3lI+CqNvDQPTrYAz8hrckpXh/AjtdvtVQinqV5vLdScEK5lnQCfX9BAUds4lYM
         /QUrI4mH4S5J4HspudyblRgpxFC1XvhocQdywcSP9xSl7W11cnePb5aGa2DWkw1+CFZH
         lkdnZlc5HtZA7d8l8vIz75Wcu27U5thoQPkgpyLD04te3q0P20TEIOM4ijAoWkPPr1be
         hIWZgFi44BAMg/2LFsgnB6IlsN1iVDJQ8FNi1jW/5nIrZgFtoZbOAR8TMkOjrD67erUw
         ZFBQ==
X-Gm-Message-State: ACrzQf3zDUDsRMFN44/P/d5ph7I3hShIupdAtVk1MO4zQHN5xLS9w2VE
        4PM4PdBsaUleLDv8q1jZeZw=
X-Google-Smtp-Source: AMsMyM7cA5B1s102LjbQe/Ee+4eSF3RENC4xSJ6fnm7jPkpYGSKFsT2q6wfLZYD3QLL/lx1JLaDsGQ==
X-Received: by 2002:a05:6a00:2485:b0:561:c0a5:88aa with SMTP id c5-20020a056a00248500b00561c0a588aamr10335160pfv.51.1666213870837;
        Wed, 19 Oct 2022 14:11:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:8280:2606:af57:d34? ([2620:15c:211:201:8280:2606:af57:d34])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090aac0200b0020a821e97fbsm130019pjq.13.2022.10.19.14.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 14:11:09 -0700 (PDT)
Message-ID: <cd2d08ee-5ebe-6c23-8896-5e684dfb03a4@acm.org>
Date:   Wed, 19 Oct 2022 14:11:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v4 03/10] scsi: core: Support failing requests while
 recovering
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20221018202958.1902564-1-bvanassche@acm.org>
 <20221018202958.1902564-4-bvanassche@acm.org>
 <b4cb1875-19f4-c7b0-a1d3-4f41418e44fe@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b4cb1875-19f4-c7b0-a1d3-4f41418e44fe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 12:52, Mike Christie wrote:
> Will we always hit this check? For example, if we have hit the
> device's queue depth limit so
> 
> scsi_mq_get_budget -> scsi_dev_queue_ready
> 
> is returning -1, will we not even call scsi_queue_rq? So because
> we are in recovery and no commands are completing, we will be
> stuck waiting for a token to be put back on the sdev->budget_map.
> 
> Do you need a similar check in scsi_dev_queue_ready or should
> the check go in there only or can we hit a race for the latter?

Hi Mike,

A later patch in this series uses the SCMD_FAIL_IF_RECOVERING flag in 
the suspend path of the UFS driver. The UFS suspend code waits for the 
SCSI error handler to finish before the UFS device is suspended. Does 
this answer your question?

Bart.


