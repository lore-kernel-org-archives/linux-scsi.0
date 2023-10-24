Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75F8C00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 17:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjJXRZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjJXRZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 13:25:07 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF5B133;
        Tue, 24 Oct 2023 10:25:04 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-578b4997decso3475796a12.0;
        Tue, 24 Oct 2023 10:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698168304; x=1698773104;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jb983rgp7Nh+wJp1TvTuOnepST3licaXPrceK0DOYZs=;
        b=phZ2W9uTtxLOoliN61lABu0EK6ecfSxSw3oZ8Y/rLZaMMcsryDvctuigNu4Sb2+Fw+
         SJMdQqbpy5vn9xXA5ltHWWrK58X72a/rXSivWPdNsq/0xmTWc/5JIyH9sCyY4ri/rV9D
         5naDnLsiW2iNGULCx05tePVp8W2pyHCkCq+mxQYUhC4IVyd+W89p01YDl/IwRpgDibRW
         5ytrITJah/ruN8pAjSmvEQabdNMOWXTJJt/fV/Vg7UC9S+zpwl0Q7lPE7ymHGkE2qe+L
         W/wJuWPevQfmGn8ILLXLQ+uIo8fpKoNjFuv7cMSnLuBxbv+/Zy1F4GUO9KaaBzG4I48L
         byXQ==
X-Gm-Message-State: AOJu0YwtQbC04dQ8W++5ezPlC1P0CudIM21TX5dSoDXOLVOHPTl82AWE
        W7cEGV0Ami2hw5NBEiPHSSM=
X-Google-Smtp-Source: AGHT+IFuNK+2OdEFPSGr9tCQdNUWt996Hu8UBzDUkXlW5TjYBGNAeDhzsiwJ5xlM65V3m464x0qPHg==
X-Received: by 2002:a17:90a:41:b0:27d:d9d:c54d with SMTP id 1-20020a17090a004100b0027d0d9dc54dmr11888935pjb.34.1698168303968;
        Tue, 24 Oct 2023 10:25:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:30e1:c9d3:6b41:493d? ([2620:15c:211:201:30e1:c9d3:6b41:493d])
        by smtp.gmail.com with ESMTPSA id lw7-20020a17090b180700b0027df62a9e68sm7262588pjb.13.2023.10.24.10.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 10:25:03 -0700 (PDT)
Message-ID: <b4a41a80-cf37-4689-b10f-4b026577bbbd@acm.org>
Date:   Tue, 24 Oct 2023 10:25:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 12/19] scsi: scsi_debug: Add the preserves_write_order
 module parameter
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-13-bvanassche@acm.org>
 <b65486b6-c1de-43e3-ba45-d9a4034c48d5@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b65486b6-c1de-43e3-ba45-d9a4034c48d5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 17:13, Damien Le Moal wrote:
> On 10/24/23 06:54, Bart Van Assche wrote:
>>   static int scsi_debug_slave_alloc(struct scsi_device *sdp)
>>   {
>> +	struct request_queue *q = sdp->request_queue;
>> +
>>   	if (sdebug_verbose)
>>   		pr_info("slave_alloc <%u %u %u %llu>\n",
>>   		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
>> +	if (sdeb_preserves_write_order)
>> +		q->limits.driver_preserves_write_order = true;
> 
> Nit: this could simply be:
> 
> 	q->limits.driver_preserves_write_order = sdeb_preserves_write_order;
> 
>>   	return 0;
>>   }

I will make this change.

> Otherwise, looks OK to me.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Thanks for the review!

Bart.


