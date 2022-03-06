Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019B1C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 20:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiCFUfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 15:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiCFUfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 15:35:32 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225B25D66B;
        Sun,  6 Mar 2022 12:34:40 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id 27so11900038pgk.10;
        Sun, 06 Mar 2022 12:34:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tkepIC4lMIVuMjQPZfxLhIDE5aSb73BtFhGo4WmZapk=;
        b=YbijS4XGBhiAhdzDOXM1BqmSgnEEMNOFGOGayYwHzbjcmdZVuKRGISmsD/00iq+2Vj
         JwGAjxxksNkEl9/4L6h89uUZPoDsCaSQpXc+XSEfMSOouljljMEZP0co76MYHjYLAoML
         1Lt/8wn1eSd8N/XP9asSOY3lWvpBe2UIdBRq6HeyfbNNAtdr189e/bSZLYpHy4yX9/Ct
         qIuS4uddqlJ5wK1eWRyDLHMa97G9QSMPPNsJeZ4HDtRmFoF2dOCLJS24jm7xKVDrxXCm
         B1uRCeObScbOo/NXUfUUOT74zBOhaX7uBvYQ2spg/5jaT5kBZc6WRTCVtq2h8y/XaROY
         6GBA==
X-Gm-Message-State: AOAM530kAhQIRyhDZnzHWEthgXoY09tqnnRL9FHKKODUM3g5XgNkk7I3
        bPuh9ryQQs0y64Dy1hYe2FKWrXXbMho=
X-Google-Smtp-Source: ABdhPJxi7xF5oPWbisf85OMHp34Qugacxe8OccsHlhz2lNAozZnC4a2JY8ahGvzSVK5l6APlJCim0Q==
X-Received: by 2002:a63:da0d:0:b0:364:b771:ff4 with SMTP id c13-20020a63da0d000000b00364b7710ff4mr7342369pgh.514.1646598879144;
        Sun, 06 Mar 2022 12:34:39 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id na8-20020a17090b4c0800b001bf191ee347sm9049196pjb.27.2022.03.06.12.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 12:34:38 -0800 (PST)
Message-ID: <99dc09a6-95b5-7dd4-2913-216aba35b3ba@acm.org>
Date:   Sun, 6 Mar 2022 12:34:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 04/14] sd: rename the scsi_disk.dev field
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-5-hch@lst.de>
 <7ff2340d-892b-94b5-ec39-355a8f8adc73@acm.org>
 <20220306084046.GA22113@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220306084046.GA22113@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/22 00:40, Christoph Hellwig wrote:
> On Sat, Mar 05, 2022 at 05:38:40PM -0800, Bart Van Assche wrote:
>> On 3/4/22 08:03, Christoph Hellwig wrote:
>>> +	/*
>>> +	 * This device is mostly just used to show a bunch of attributes in a
>>> +	 * weird place.  In doubt don't add any new users, and most importantly
>>> +	 * don't use if for any actual refcounting.
>>> +	 */
>>> +	struct device	disk_dev;
>>
>> Isn't "weird place" subjective? How about mentioning the sysfs path
>> explicitly (/sys/class/scsi_disk/H:C:I:L)? How about explaining why no new
>> sysfs attributes should be added to that device instance?
> 
> Well, weird place means that all normale drivers would just use
> attributes on the gendisk for it, but sd creates a completely pointless
> device under the gendisk device for it.  If you have a better wording
> I can change it.

It's not that important. I wish it would be possible to get rid of this 
struct device instance. I think this instance was introduced in 2006 by 
patch "[SCSI] allow displaying and setting of cache type via sysfs".

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
