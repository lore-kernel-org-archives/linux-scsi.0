Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD56C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 16:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346882AbiDRQ7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 12:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346733AbiDRQ67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 12:58:59 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC48637A03
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 09:54:39 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id 203so846049pgb.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 09:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HNXO0G852NRxwbKg95XUdktcYvCQO2cYqk1aZN+IXRc=;
        b=SRkNn7nPhdME0QATUWlxfWfH0WB589NWAhdRqEhwC1SYsLPZN85W0lwwNG7c9vV5I7
         Ejc62Mnlc/ZopbSh4IvjXFEvWXeCPmfDTzCy3/eKJ93ue1uspfFeIZjHHOFuqiC+ECge
         3ZlWRvDSyKIHOfLchOgGQAY7ohW/cBJVBh8Ifv66f1uP03zRynz5vGT/fFw6L7H/0PMq
         5tZCtvjvxuB9o9L5V8a7vFJ9gjiwbm/LU1bs2qhKRN3RIcT3I+8qqMcjwNzK24HQmxgU
         lPrEJGT9GqqeqI9vBuGPFjnT2Lx58u4oxt/qiGXNy/ZjQlWWkRC17hyyYuXQXk6/+5+/
         3doA==
X-Gm-Message-State: AOAM5329sOlbMErEQbvjvuesmLHjKifBasbxBPTPl4igcG4F7f69eoWg
        yefFSg+LlzNiXf07rxdYrfk=
X-Google-Smtp-Source: ABdhPJy+DfIy/AAZL0zxdt/ErdfxEHQItOEdHzJ3juno+TAlDk4Jz2b94gEbmfzsS6PvtGtgWYv9dw==
X-Received: by 2002:aa7:920d:0:b0:505:c9d4:5819 with SMTP id 13-20020aa7920d000000b00505c9d45819mr13471942pfo.15.1650300879245;
        Mon, 18 Apr 2022 09:54:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:713b:40eb:c240:d568? ([2620:15c:211:201:713b:40eb:c240:d568])
        by smtp.gmail.com with ESMTPSA id p1-20020a17090a680100b001d28905b214sm4415950pjj.39.2022.04.18.09.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 09:54:38 -0700 (PDT)
Message-ID: <9820f086-1cb9-2362-c961-0d67beb606a6@acm.org>
Date:   Mon, 18 Apr 2022 09:54:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 3/8] scsi: sd_zbc: Verify that the zone size is a power of
 two
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-4-bvanassche@acm.org>
 <eb2e59d1-b28b-aaa3-ca70-46f7ccfbba06@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <eb2e59d1-b28b-aaa3-ca70-46f7ccfbba06@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/22 16:09, Damien Le Moal wrote:
> On 4/16/22 05:17, Bart Van Assche wrote:
>> The following check in sd_zbc_cmnd_checks() can only work correctly if
>> the zone size is a power of two:
>>
>> 	if (sector & (sd_zbc_zone_sectors(sdkp) - 1))
>> 		/* Unaligned request */
>> 		return BLK_STS_IOERR;
>>
>> Hence this patch that verifies that the zone size is a power of two.
> 
> Note that this is already checked in blk_revalidate_disk_zones(), but it
> does not hurt to add the check.

If the block layer would be modified such that support is added for zones with
a size that is not a power of two I think we will really need this check.

Thanks,

Bart.
