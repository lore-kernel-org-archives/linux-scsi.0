Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE1CC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 22:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A30061073
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 22:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhELWnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 18:43:39 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:34561 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbhELWWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 18:22:00 -0400
Received: by mail-pg1-f175.google.com with SMTP id l70so4683485pga.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 15:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7u9FGlZkXfNcYur9/GBlEiAMc0Klqb5ddoFfkjJJEas=;
        b=BUIL3B8AWOI58JjBEuoaX9YxrTx7CMB2hn8Zv+RbbH669vwipg6tcQvgSrJsivv6gg
         icLW7Pw0d3rWL634VSy4Al4HylwbtGDO7ht2UDWaGrLAYdijwyMKMTvljk/V+BuOkjTk
         apuC+efpOb/aM3mzLNOJ9InRPWTXKd75NN58a+3l+zUH6L4T0F+1vOB2rU2F/2qzNBDb
         7St2G8//hl+L+ZJv4MQImTESXdZx7O/4sZ1OKjsUCMFNSWCkam8r7iVA9srAMV+NwULH
         YarJYcSk4SgSn+jlXyu2OZChZhcVI4tyiI/FxCribn7V0YMBaSRxa6FUspb3H7TRaBcT
         w73A==
X-Gm-Message-State: AOAM533Kl1O+vZCXJ2ED0Ihnx/KcJ3i/qG2pM4ydX1bVSmDZsoIhUZC/
        Mg378pFSHznNmG6GaIG8e1Q8cYmq2zwE7A==
X-Google-Smtp-Source: ABdhPJwZxR+lfMXiLPfsiRxU+yieMaQNbygCDbEwUMkMU4kZt+bRrBKtIv5qT9u8oZKElBIc5Ix7hQ==
X-Received: by 2002:a62:8fcd:0:b029:2ac:9a4d:930e with SMTP id n196-20020a628fcd0000b02902ac9a4d930emr28824258pfd.61.1620858050578;
        Wed, 12 May 2021 15:20:50 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h19sm653437pgm.40.2021.05.12.15.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 15:20:49 -0700 (PDT)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b27a3c7d-1c10-faaa-4c33-273a463faa80@acm.org>
Date:   Wed, 12 May 2021 15:20:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <96a253f8776a7736b480bdf190840440ffb4e53c.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 3:10 PM, James Bottomley wrote:
> On Wed, 2021-05-12 at 13:08 -0700, Bart Van Assche wrote:
>> This patch series renames scsi_get_lba() into scsi_get_pos(). The
>> name of scsi_get_lba() is confusing since it does not return an LBA
>> but instead the start offset divided by 512.
> 
> OK, I'll bite: given the logical block size for all drives is 512 why
> is logical block address not the start offset in bytes divided by 512?

My understanding is that LBA = logical block address = (start offset in 
bytes) / (logical block size) and also that the Linux kernel supports 
logical block sizes between 512 bytes and 4 KiB. From drivers/scsi/sd.c 
(sector_size represents the logical block size):

	if (sector_size != 512 &&
	    sector_size != 1024 &&
	    sector_size != 2048 &&
	    sector_size != 4096) {
		sd_printk(KERN_NOTICE, sdkp,
			 "Unsupported sector size %d.\n",
			  sector_size);
		/*
		 * The user might want to re-format the drive with
		 * a supported sectorsize.  Once this happens, it
		 * would be relatively trivial to set the thing up.
		 * For this reason, we leave the thing in the table.
		 */
		sdkp->capacity = 0;
		/*
		 * set a bogus sector size so the normal read/write
		 * logic in the block layer will eventually refuse any
		 * request on this device without tripping over power
		 * of two sector size assumptions
		 */
		sector_size = 512;
	}

Thanks,

Bart.
