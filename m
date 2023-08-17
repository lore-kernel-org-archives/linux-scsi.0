Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5254C30626
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 14:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351959AbjHQOf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351997AbjHQOfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 10:35:18 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A73A2D73;
        Thu, 17 Aug 2023 07:35:16 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-688787570ccso1903008b3a.2;
        Thu, 17 Aug 2023 07:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692282916; x=1692887716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oEBxKdfaDkKngC/qlNvTeJaOp27bSzBmkIz5LjR/vig=;
        b=KxqyelhzdQNoz2PvXcePsHO/Oop5HCR8sG9EUT1U1UOlb6btdfagjK2LzgecUiTDl0
         5Ddm0Ozzawbz4vHjoKANipz40E8CulqS5crV6KWdXG1jRr3wWjHwN9gh0ACJ7DV5BIUR
         tuQ1LhH5H0AomJ34zpTIVRzu27pFDSW5uscw76AY3cG4lsnB81j2NjvRnub8+OI7HAQM
         nLFn8ei54y7Bf4jZpsPUKuqJTL8nkgVGPwg5V36e+/Q/+oGSWDaDbtq+JaMOYPSl3xPR
         lUvOBnxbJ98wl8RcA1dEIUEkybmhkpTCuUwHYE0vrSfBnP4X0JvkmxnwPmO+9PBc6/pm
         Fk2g==
X-Gm-Message-State: AOJu0Yw6HcPfs6rTGqAGagiQLtklc86dZMeAXjMFl6H5UE3gnjlTntYY
        nTRi9RnJ9UHAjUm8dEh2xTM=
X-Google-Smtp-Source: AGHT+IH3Q+qd4daBkdlN+fkSnPs3IbmDvnhPoUphtm3NTqIfY2TTwIrY24AVeiwrnCtzj4HLqtC7fw==
X-Received: by 2002:a05:6a00:2495:b0:66d:263f:d923 with SMTP id c21-20020a056a00249500b0066d263fd923mr5838228pfv.20.1692282915897;
        Thu, 17 Aug 2023 07:35:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id 9-20020aa79249000000b0067aea93af40sm12879923pfp.2.2023.08.17.07.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 07:35:15 -0700 (PDT)
Message-ID: <b9ce6883-2777-bfbc-a132-caafc51c11d3@acm.org>
Date:   Thu, 17 Aug 2023 07:35:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 09/17] scsi: scsi_debug: Support disabling zone write
 locking
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-10-bvanassche@acm.org>
 <cbce2335-7a64-e5bf-c8bc-e5f294efc763@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cbce2335-7a64-e5bf-c8bc-e5f294efc763@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:25, Damien Le Moal wrote:
>>   static int scsi_debug_slave_alloc(struct scsi_device *sdp)
>>   {
>> +	struct request_queue *q = sdp->request_queue;
>> +
>>   	if (sdebug_verbose)
>>   		pr_info("slave_alloc <%u %u %u %llu>\n",
>>   		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
>> +	if (sdeb_no_zwrl)
>> +		q->limits.driver_preserves_write_order = true;
> 
> The option is named and discribed as "no_zone_write_lock", which is a block
> layer concept. Given that this sets driver_preserves_write_order and does not
> touch the use_zone_write_locking limit, I think it is better to name the option
> "preserve_write_order" (or similar) to avoid confusion.

I will make this change.

Thanks,

Bart.

