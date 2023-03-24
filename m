Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA73C6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 19:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjCXTqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCXTqS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 15:46:18 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF31166D1;
        Fri, 24 Mar 2023 12:46:17 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso6082340pjb.3;
        Fri, 24 Mar 2023 12:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679687177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J7dxhXOhPm1rjnBhX708y4lq+UW0mc9qQ6mqHHtCoG4=;
        b=SNEmdezo4mFrdPPVWFp5qoiBBh8ncNCmJnJlB+HpuyvDGiZYbCXJvq413O9d3YIJHT
         YhO6hGT0UQptCd38WEoAgcg+iN+OOOO6ZRy+mMDZoNMxhiAeG6oAVnm625Jfnv2GTCrA
         vBz6o/5bppr1dimHbJLreySD3Y7p4rz/CuS0NoCPtU5SsuyUEOuNgRMhyrNQTXKWHMhB
         1mbzokg58NFnCTAQvpT8C9FL1yKypLL1JP794XIyfk/i1Q8MiEpUrwW7LBMZQZVcLKeK
         VKpYtzFhtFYMLagZ43DnJDS8YMJCfxWBewr2vnYuD5sQkSqQuWxJpUsxtCAgac6IE+k8
         Lkqg==
X-Gm-Message-State: AAQBX9f0CtzyxABzZ/f7LK6WiGAjDiRjhT7nl9yMHH4wsCPtNTNH7ZP+
        Hv5XDGsCI72liUhj5se1mrE=
X-Google-Smtp-Source: AKy350YIsFGcV01ac5EKq37TJfDpDKKDtii9V8hYor/rYLrdjT6fks/kkJW+tmPAJbXZUh9YIxzmkQ==
X-Received: by 2002:a17:902:fb4e:b0:1a1:cd76:7880 with SMTP id lf14-20020a170902fb4e00b001a1cd767880mr3549674plb.15.1679687176657;
        Fri, 24 Mar 2023 12:46:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:386d:2249:7df8:ecf? ([2620:15c:211:201:386d:2249:7df8:ecf])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902854900b0019c61616f82sm14572264plo.230.2023.03.24.12.46.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:46:16 -0700 (PDT)
Message-ID: <901b8d9d-dc20-f409-7dd4-000db8b03259@acm.org>
Date:   Fri, 24 Mar 2023 12:46:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Stefan Haberland <sth@linux.ibm.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/23 11:17, Mike Christie wrote:
> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts and DASD's
> locking feature which works similar to NVMe/SCSI reservations where a
> host can get a lock on a device and when the lock is taken it will get
> failures.
> 
> This patch renames BLK_STS_NEXUS so it better reflects this type of
> use.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
