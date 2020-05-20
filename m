Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873B1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B2C206B6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IGPX9L4k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgETRvz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgETRvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:51:55 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8B2C061A0F
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2020 10:51:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u188so3828903wmu.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 May 2020 10:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6/K2r2mMGNXC0hjZP/edQuVZv9WqLKDECwgj0t5H2CI=;
        b=IGPX9L4k9Ivw+STA53YDbcHe/jWijBpChsxcqfoVM4H3g1XLSmcioRjHcCKLrrVXn/
         IvwXg4tS7GDt1kk9mgVwwD9zNxTRVsi4QdEtLK9WkvVz3kiTGOpAkUs+thETBXohhIbT
         jW+Ce0eAKMXAgHEZGKFtO3eooAOAnY3uy70m0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6/K2r2mMGNXC0hjZP/edQuVZv9WqLKDECwgj0t5H2CI=;
        b=Si6Vq1L/wyTzEiAUikc6CtaVkiIyqD1G8uj1P2QX4bhOIZxFswLinA5JmwpnqLebt3
         CtPveZdvdIXV4SnfF0A/PxZgaHAlnndeop7CW0Lt+kaJONWbIXI5Cs2WCFkjtmAt3PRt
         eDS9kHA7sCtAzHS7JP/ZDwKk3SkkgoMtg2VwqfKxzbGZCVoKJrKWqdnEI8vVoirVDhqF
         ss85CpzzPGCbykgUXKoZagmOxjolQmpaQOlLnQmTXXQTSBlbhz+eqWL9K8jbP3kuxmIs
         CV8sg2PMlpXJEkq3DZHBa1nQqeePloghQw2+7b5OhqsBkfx829zt1KXR/iwp6jurvmY/
         jXYQ==
X-Gm-Message-State: AOAM531RRQO13sbRSztR5MXW1FnWzZZbxp0aYsUARZk9InjRTBaPG5IM
        Q0iT3xEVEwozJ9Uz669pwg3LnQ==
X-Google-Smtp-Source: ABdhPJwUu6hTVJnqQMkiiZojWCHHXZqLpYI4Ef1FWPqKJaOiKZnv/kYPTv56XL9GKNQQAczOtcdHlg==
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr5386234wml.75.1589997113302;
        Wed, 20 May 2020 10:51:53 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id q9sm3646293wmb.34.2020.05.20.10.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 10:51:52 -0700 (PDT)
Subject: Re: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
To:     Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, linux-nvme@lists.infradead.org,
        Paul Ely <paul.ely@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <yq1y2purqt1.fsf@oracle.com> <20200515101903.GJ3041@kadam>
 <20200520165557.GA9700@infradead.org> <20200520172433.GD30374@kadam>
 <20200520172844.GA21006@infradead.org> <yq1y2pmtsv7.fsf@ca-mkp.ca.oracle.com>
 <20200520173752.GA13546@infradead.org> <yq1sgfutsjd.fsf@ca-mkp.ca.oracle.com>
 <20200520174800.GA13253@infradead.org>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <4693662b-60de-388e-d67f-722eabbba475@broadcom.com>
Date:   Wed, 20 May 2020 10:51:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520174800.GA13253@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/2020 10:48 AM, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 01:39:55PM -0400, Martin K. Petersen wrote:
>> Christoph,
>>
>>> I'll pick it up.  Can you give me an ACK for it to show Jens you are
>>> ok with that?
>> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> Thanks,
>
> applied to nvme-5.8.

Guess you didn't see Dan's response - we had replied, and Dick rejected 
it. Dick has created a new patch that I'll be posting shortly.

-- james


