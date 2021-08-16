Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A36C43214
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AD1B60EFF
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhHPQvw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhHPQvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:51:49 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8793CC06129D
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:51:16 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id n27so2967351oij.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lkHKKxx6E91blWpox1bXj/LIePIAFS6deUe/aal8ts0=;
        b=2M7PsQmoW0m68H0tIVJvrAROv1UoWp/uy48nnzobRrc03mo4J/lqcPLEQEF1kpJUHw
         HQBa4gX5fuTsQap76AZD/5O7VV8iT7vusfHhUAUKN78fP0BZSnTbz5bFFrpuEHica0IG
         vNOnPFWucI7QTNpQA0kxldWWTEaok+vCXtpMF9OBhganoAYTPaU0jWc3pk2ipYfiP3qw
         KJv7dYM9ZKsD48MEvHmMnjHIhntqyqYB/aLy5wa1Nk3VqVwfnK6sD7DQ+glML2iy7RW5
         8bKOFtNVZE+7XBNUsAmXKRXSN7yXiZDUd4eqzd5A6g+KiYc52tKP/BJj3qVXfxUmmZ/Y
         b/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lkHKKxx6E91blWpox1bXj/LIePIAFS6deUe/aal8ts0=;
        b=Wk0kGGCOBZH6MHEYmjZ0ZfHRdtoW6xMkR0MlDD816DRnnHec7w7mXuaUCUbyagtZRv
         fltpgRWrHADCoy6kLEUF5R9OdWdt3a0DZ9tkS2929fm4pxTPbR3sW62mAPNMp7h+XIaI
         n1FsPHivv7r5HRp5p0PSqS13B5/nO1H8ZpQk2UIK6efDfALDKpv/FXEYqeGcT9IX0zxI
         R99tzGM6NVsWdZHSaSZRodPiI6t38LRh8dw9FgZG87LxTeOwBk1xRU2pNmVGRujsAUeB
         GYZIa+467Eo/oHcHPysRqQ5fhFh2aoBjdDjbeHDw2WJ76YzVCl7CKNLthV0jTtedB77o
         EyNg==
X-Gm-Message-State: AOAM531xffcc4sC+hUikdv/Cfnjhd8QU11JofBBoyuvzVzivPDlGV1Mg
        tDhgPCVtVk40K0Bz7uC9h1iTzDDmoo7MDVyw
X-Google-Smtp-Source: ABdhPJwPiJZucbHV+gTb5R7I/kfPLblHKKXb+EIub7hcvBOP41sFKxi/Q6epHu0YRXyVvO62JSl/PA==
X-Received: by 2002:a54:4619:: with SMTP id p25mr42850oip.5.1629132675579;
        Mon, 16 Aug 2021 09:51:15 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u18sm2018498ooi.40.2021.08.16.09.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 09:51:15 -0700 (PDT)
Subject: Re: add a bvec_virt helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210804095634.460779-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4e321dab-188d-ca0a-a98c-4a587e7b5f27@kernel.dk>
Date:   Mon, 16 Aug 2021 10:51:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/21 3:56 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series adds a bvec_virt helper to return the virtual address of the
> data in bvec to replace the open coded calculation, and as a reminder
> that generall bio/bvec data can be in high memory unless it is caller
> controller or in an architecture specific driver where highmem is
> impossible.

Applied, thanks.

-- 
Jens Axboe

