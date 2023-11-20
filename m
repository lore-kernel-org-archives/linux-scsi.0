Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A036C2BB3F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 20:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjKTUou (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjKTUot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 15:44:49 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D668ACC;
        Mon, 20 Nov 2023 12:44:44 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1cf669b711fso6596825ad.2;
        Mon, 20 Nov 2023 12:44:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700513084; x=1701117884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t/+vZLSn8Zi0TmWbz/4mk8iNsQN+ForoQPmwsvN/7rE=;
        b=Auq45UKp3WREfWbLSBIPAR1mujidbiil3QeKGET9vipjdPb2V8spymQ2b4gSGuJL+K
         cMKHHYCAl6Jlgxn7hw8DAatfCjr7yLZK3gvkoy+Ihn7qUAk5DgbKcZUZdLbBagQYG5DB
         NYOkArJyc5Nn15CalZ8FYvXfjeGZzkIA/4+SwCxp/D5F3mQxDTlKByQxn/9EZw7/jDVY
         TAggaDDnkH9t8IU/dPFwse8ZX8m0YTo+ioKp6CAnOHa/EF9i0mfLMjcHd1AGRjJIXRnw
         G33Ez8SWmBHOmDghodItP7CPtC6oGed8B019Jdh3PFlhwBYv7D5BbEwHerBUVb5pce4e
         GnyA==
X-Gm-Message-State: AOJu0YzIyvK2RKpkjqwYfsC7VlarPrXxLdclasOkMRGx2Nin5vHL1RS9
        pJ4tYC+/LpO1NULmtn6Ha1I=
X-Google-Smtp-Source: AGHT+IFEaWE8qQ+OaE8496miXI47DPFPJEqW9A0WrnQ118bR05MWDwRH2Q7EO/RAc6zbgHtex1Kw9g==
X-Received: by 2002:a17:903:2448:b0:1cc:42ec:9b96 with SMTP id l8-20020a170903244800b001cc42ec9b96mr8596700pls.45.1700513084114;
        Mon, 20 Nov 2023 12:44:44 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bb61:2ac8:4d61:2b3d? ([2620:0:1000:8411:bb61:2ac8:4d61:2b3d])
        by smtp.gmail.com with ESMTPSA id jd22-20020a170903261600b001ce160421aesm6516853plb.200.2023.11.20.12.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 12:44:43 -0800 (PST)
Message-ID: <0d60bde5-018d-4850-8870-092b472463a6@acm.org>
Date:   Mon, 20 Nov 2023 12:44:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/19] block: Introduce more member variables related
 to zone write locking
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
References: <20231114211804.1449162-1-bvanassche@acm.org>
 <20231114211804.1449162-2-bvanassche@acm.org>
 <3d8d04d5-80d8-4eee-9899-d9fe197dd203@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3d8d04d5-80d8-4eee-9899-d9fe197dd203@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/23 15:29, Damien Le Moal wrote:
> On 11/15/23 06:16, Bart Van Assche wrote:
>> @@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>>   	lim->max_dev_sectors = UINT_MAX;
>>   	lim->max_write_zeroes_sectors = UINT_MAX;
>>   	lim->max_zone_append_sectors = UINT_MAX;
>> +	/* Request-based stacking drivers do not reorder requests. */
> 
> Rereading this patch, I do not think this statement is correct. I seriously
> doubt that multipath will preserve write command order in all cases...
> 
>> +	lim->driver_preserves_write_order = true;
> 
> ... so it is likely much safer to set the default to "false" as that is the
> default for all requests in general.

How about applying this (untested) patch on top of this patch series?

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4c776c08f190..aba1972e9767 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -84,8 +84,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
  	lim->max_dev_sectors = UINT_MAX;
  	lim->max_write_zeroes_sectors = UINT_MAX;
  	lim->max_zone_append_sectors = UINT_MAX;
-	/* Request-based stacking drivers do not reorder requests. */
-	lim->driver_preserves_write_order = true;
  }
  EXPORT_SYMBOL(blk_set_stacking_limits);

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 2d3e186ca87e..cb9abe4bd065 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -147,6 +147,11 @@ static int linear_report_zones(struct dm_target *ti,
  #define linear_report_zones NULL
  #endif

+static void linear_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	limits->driver_preserves_write_order = true;
+}
+
  static int linear_iterate_devices(struct dm_target *ti,
  				  iterate_devices_callout_fn fn, void *data)
  {
@@ -208,6 +213,7 @@ static struct target_type linear_target = {
  	.map    = linear_map,
  	.status = linear_status,
  	.prepare_ioctl = linear_prepare_ioctl,
+	.io_hints = linear_io_hints,
  	.iterate_devices = linear_iterate_devices,
  	.direct_access = linear_dax_direct_access,
  	.dax_zero_page_range = linear_dax_zero_page_range,

>> @@ -685,6 +689,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   						   b->max_secure_erase_sectors);
>>   	t->zone_write_granularity = max(t->zone_write_granularity,
>>   					b->zone_write_granularity);
>> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
>> +		b->driver_preserves_write_order;
>> +	t->use_zone_write_lock = t->use_zone_write_lock ||
>> +		b->use_zone_write_lock;
> 
> Very minor nit: splitting the line after the equal would make this more readable.

Hmm ... I have often seen other reviewers asking to maximize the use of each
source code line as much as reasonably possible.

Thanks,

Bart.

