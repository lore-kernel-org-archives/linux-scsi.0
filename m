Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBB9C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 00:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2886E61405
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 00:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhEMAD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 20:03:59 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:40913 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352722AbhEMABq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 20:01:46 -0400
Received: by mail-pl1-f173.google.com with SMTP id n3so1277352plf.7
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 17:00:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZwS5wo/OU2SfD1LoDJRAA51hmhKPQ7ORt1sDee9a5Y=;
        b=U/UDBdtE+59ALtW9iAPtndbF5rGwkDKwJzCNlSSh0d0q8yCMMzhD0LjvMSOZGjtDUk
         EClSBxjnz08cDVyh+Uqyk/UzwCIhIB+PHXpfpurePRo8+WZy2eAVysSnUGCsI8bPNx+K
         4kVqjmUdrQjf+OsSqYebpIhor1iDKV7ywG2/UgtwoH+GRVlUXQgY+gdU1cbyBdNKz840
         1+v8lNjd3sho8c8T7lcNS5fpusUaMQn0Gu5Hd1saHRq2t3FxXHUusOGjmXeiHl9nBL1d
         8KOspb4ONjCf+nBOv92LcFQcIjrGxGARnlM97tvPVTyarF9QUib9FLlEeaWO5PfVKCqN
         eh7w==
X-Gm-Message-State: AOAM532oFGsNh6/wIQKNtbGvdR78FSuuw5OoMLxYyy76M9kyiw6Ilboy
        9q4w8H1DNVwla7vP665TZpUWTs2lgCzvUA==
X-Google-Smtp-Source: ABdhPJwo16hoCU2NW2vPjNXFUT0zeURe/87vvaLLBIQgX1WbBobcYq0lFEhMtNVcmEAuaoGXpiz6GQ==
X-Received: by 2002:a17:902:6bca:b029:ee:b72c:5585 with SMTP id m10-20020a1709026bcab02900eeb72c5585mr36666458plt.46.1620864037032;
        Wed, 12 May 2021 17:00:37 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g16sm5327939pju.17.2021.05.12.17.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 17:00:36 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] Rename scsi_get_lba() into scsi_get_pos()
To:     jejb@linux.ibm.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org
References: <20210512200849.9002-1-bvanassche@acm.org>
 <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
 <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
 <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8d72e969-44e9-5453-70fc-c9cb0779634d@acm.org>
Date:   Wed, 12 May 2021 17:00:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <5967066117ed90e6f72bee006ee7e66722a5d1b3.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 4:23 PM, James Bottomley wrote:
> No, we support physical sector sizes up to 4k.  The logical block size
> internal to the kernel and the block layer is always 512.  I can see
> the utility in using consistent naming to the block layer, but I can't
> see that logical block address is confusing ... especially now
> manufacturers seem all to have aligned on 512 for the logical block
> size even when it's usually 4k physical.

Are we talking about the same? Just below the code that I included in my 
previous email there is the following line:

	blk_queue_logical_block_size(sdp->request_queue, sector_size);

where sector_size is the logical block size reported by the READ 
CAPACITY command and has a value between 512 and 4096.

At least the LIO code supports reporting logical block sizes larger than 
512 bytes. From drivers/target/target_core_sbc.c:

	put_unaligned_be32(dev->dev_attrib.block_size, &buf[8]);

block_size is configurable through configfs. From block_size_store():

	if (val != 512 && val != 1024 && val != 2048 && val != 4096) {
		pr_err("dev[%p]: Illegal value for block_device: %u"
		    " for SE device, must be 512, 1024, 2048 or 4096\n",
		    da->da_dev, val);
		return -EINVAL;
	}

Bart.
