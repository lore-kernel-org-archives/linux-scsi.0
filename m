Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E361CC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 00:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjBGADA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 19:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjBGAC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 19:02:59 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D7D1BAC0;
        Mon,  6 Feb 2023 16:02:50 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so13045543pjb.5;
        Mon, 06 Feb 2023 16:02:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gvO8TD4qNAS7wiX58CNMN+rFSKTU4cEInv6xaIFB7s=;
        b=Q+ecqWEwY8e55UXqWvfwnCKVnLdoOok80Lo2fTY/R8dhsXDF69KXWpz1D7E8Qoy1tw
         g5Flcol5Um1SrOSmx9wwPoC2yjRex/Tcto2b9SkWZ4TbnRa+K8YecOYQsersm4jyplpA
         JcUPIn71sPQjqcU+N+Rc7clY93L6VLlRfV1TiCMcouo/cXm0ebTI1hWznSjBGV6Jmef1
         mrHMUdkob3wiBNUxTV8uCGudpoEqc5OkUcNFteXVIgBAlCFqIVwjDkGJIuvWGRd9Me6x
         Sdy1xJtQKooKKl74/pPmI7aK7f+PZPPeerSpC2jqFAOZGtUXg/drVYiEr80dC33FPiR9
         PQPA==
X-Gm-Message-State: AO0yUKV3Up9WC4LnaaTaf84YqVPjg6YGjXvvQq6QSNVqLWBlRp0yFoyQ
        iwQ3MKSdt6knb+ZwxKS9JQo=
X-Google-Smtp-Source: AK7set9aDFvOGb43vTfp6gRc47TLGYnoeCnwglSzIgsX06dGnTa0MTVwKc0XP1SFS0sLEpqfgbrSjw==
X-Received: by 2002:a05:6a20:d04f:b0:bc:c663:41b6 with SMTP id hv15-20020a056a20d04f00b000bcc66341b6mr1046779pzb.28.1675728169820;
        Mon, 06 Feb 2023 16:02:49 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:546b:df58:66df:fe23? ([2620:15c:211:201:546b:df58:66df:fe23])
        by smtp.gmail.com with ESMTPSA id e29-20020a630f1d000000b0047899d0d62csm2080808pgl.52.2023.02.06.16.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 16:02:48 -0800 (PST)
Message-ID: <24b34999-8f7c-7821-0b15-fdfc3f508b13@acm.org>
Date:   Mon, 6 Feb 2023 16:02:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 2/7] block: Support configuring limits below the page
 size
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <p.raghav@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-3-bvanassche@acm.org>
 <20230201235038.nnayavxpadq5yj34@garbanzo>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230201235038.nnayavxpadq5yj34@garbanzo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/23 15:50, Luis Chamberlain wrote:
> On Mon, Jan 30, 2023 at 01:26:51PM -0800, Bart Van Assche wrote:
>> @@ -122,12 +177,17 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
>>   void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_sectors)
>>   {
>>   	struct queue_limits *limits = &q->limits;
>> +	unsigned int min_max_hw_sectors = PAGE_SIZE >> SECTOR_SHIFT;
>>   	unsigned int max_sectors;
>>   
>> -	if ((max_hw_sectors << 9) < PAGE_SIZE) {
>> -		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
>> -		printk(KERN_INFO "%s: set to minimum %d\n",
>> -		       __func__, max_hw_sectors);
>> +	if (max_hw_sectors < min_max_hw_sectors) {
>> +		blk_enable_sub_page_limits(limits);
>> +		min_max_hw_sectors = 1;
>> +	}
> 
> Up to this part this a non-functional update, and so why not a
> separate patch to clarify that.

Will do.

>> +
>> +	if (max_hw_sectors < min_max_hw_sectors) {
>> +		max_hw_sectors = min_max_hw_sectors;
>> +		pr_info("%s: set to minimum %u\n", __func__, max_hw_sectors);
> 
> But if I understand correctly here we're now changing
> max_hw_sectors from 1 to whatever the driver set on
> blk_queue_max_hw_sectors() if its smaller than PAGE_SIZE.
> 
> To determine if this is a functional change it begs the
> question as to how many block drivers have a max hw sector
> smaller than the equivalent PAGE_SIZE and wonder if that
> could regress.

If a block driver passes an argument to blk_queue_max_hw_sectors() or 
blk_queue_max_segment_size() that is smaller than what is supported by 
the block layer, data corruption will be triggered if the block driver 
or the hardware supported by the block driver does not support the 
larger values chosen by the block layer. Changing limits that will 
trigger data corruption into limits that may work seems like an 
improvement to me?

Thanks,

Bart.

