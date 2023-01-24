Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B5FC54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 22:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbjAXWn3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 17:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbjAXWn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 17:43:28 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF14BBB2;
        Tue, 24 Jan 2023 14:43:27 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id lp10so13217207pjb.4;
        Tue, 24 Jan 2023 14:43:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNs8jrxoXazdOS9CAZfxUR9chM1rbECw8wTTy2kXKsM=;
        b=Jcl9caWAKi0B6HrsM8cEzjr4EQ5bceGNdhhSqt+HCG3BBlii3LVL4DfYDGEbeLCbrO
         Ga3U+PO/XTzFNWuamFmYnJe+TE1s7RJKPi++wHEFl8ngFTSFHXl+wjx5sl7FpsOd9T33
         eSy9n6hyVaCpIycc8uZ0wSf4Go5hZHyGd9hKqp3kRwauG22L2AGUOrTOA5TArNQ3OdAd
         fyPWG/2OYkXPw6AYXV9Fkz4EGMlr/smEshfH1o+M0uRXb6epPNInspGlojy03v2gpk7C
         wL+zW0/iG/fvbPrfI6CBMc55qAjyLP16HIV+oC3349r1Sv5bnApfVEa70tM7V2iZytJt
         UxAw==
X-Gm-Message-State: AFqh2krlZBmeKkgr4iUgs4s1625oBu6ZMqIvI9H6wV2+FUblqNJ0CgFt
        tsEqedkMSS8LNttSo/Ux9fpcoa48DoY=
X-Google-Smtp-Source: AMrXdXu5y41nH5PJs2rtaGovi14NQ2sfz9TRn+u7wWRakdJ7zqmW12TwELdWrWsPPFqfQ/+q1jiF6A==
X-Received: by 2002:a05:6a20:c18a:b0:b8:db12:b90c with SMTP id bg10-20020a056a20c18a00b000b8db12b90cmr32163441pzb.17.1674600206789;
        Tue, 24 Jan 2023 14:43:26 -0800 (PST)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id je19-20020a170903265300b00195f0fb0c18sm2205288plb.31.2023.01.24.14.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 14:43:26 -0800 (PST)
Message-ID: <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
Date:   Tue, 24 Jan 2023 14:43:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 13:29, Damien Le Moal wrote:
> I/O priority at the device level does not exist with SAS and with SATA,
> the ACS specifications mandates that NCQ I/O priority and CDL cannot be
> used mixed together. So from the device point of view, I/O priority and
> CDL are mutually exclusive. No issues.
> 
> Now, if you are talking about the host level I/O priority scheduling done
> by mq-deadline and bfq, the CDL priority class maps to the RT class. They
> are the same, as they should. There is nothing more real-time than CDL in
> my opinion :)
> 
> Furthermore, if we do not reuse the I/O priority interface, we will have
> to add another field to BIOs & requests to propagate the cdl index from
> user space down to the device LLD, almost exactly in the manner of I/O
> priorities, including all the controls with merging etc. That would be a
> lot of overhead to achieve the possibility of prioritized CDL commands.
> 
> CDL in of itself allows the user to define "prioritized" commands by
> defining CDLs on the drive that are sorted in increasing time limit order,
> i.e. with low CDL index numbers having low limits, and higher priority
> within the class (as CDL index == prio level). With that, schedulers can
> still do the right thing as they do now, with the additional benefit that
> they can even be improved to base their scheduling decisions on a known
> time limit for the command execution. But such optimization is not
> implemented by this series.

Hi Damien,

What if a device that supports I/O priorities (e.g. an NVMe device that 
supports configuring the SQ priority) and a device that supports command 
duration limits (e.g. a SATA hard disk) are combined via the device 
mapper into a single block device? Should I/O be submitted to the dm 
device with one of the existing I/O priority classes (not supported by 
SATA hard disks) or with I/O priority class IOPRIO_CLASS_DL (not 
supported by NVMe devices)?

Shouldn't the ATA core translate the existing I/O priority levels into a 
command duration limit instead of introducing a new I/O priority class 
that is only supported by ATA devices?

Thanks,

Bart.

