Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FE8C636D3
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Feb 2023 21:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjBFVMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 16:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBFVL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 16:11:58 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2293252A4;
        Mon,  6 Feb 2023 13:11:55 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id d2so9209834pjd.5;
        Mon, 06 Feb 2023 13:11:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+7txarfqCiCLUnqD4SGgm4cOFDcNxQ2HVILBqdiFA2A=;
        b=aF5lY9z7EgS0oG4STMCXAYXFH7L4MFM6ppCDhAIJ85j34V4wanVXDiYy0/7E7WlzcO
         2enF7r5J1Wd32Ml1vqefhxgLGudNqe94TOufV2KTZ33iggtSAiXrrhN8hVRx1D7VMMan
         aYySmHeb0nzvr8c1IpWDHc8TnDQhzfKtkmtVUOZvLq3zPqn1KtpRFwt5jNBMVegkeidy
         pev0lDYkjiecB+Wf9mVrgdbll5ifuyeS59X9KeB1k4DADimCigz4DYhttHFNr5+1Oo5W
         9UjbGjiaJgwdEGGTw8f0ulBcFJV3ddZMo6ORmMwuPwHLg/207ZObO2REVbnA+DsHUuGo
         06wQ==
X-Gm-Message-State: AO0yUKX+y7Rwh5rJjePetsaL4b54k9GAJV922UyIxfxg+1OQ0xE69dEd
        eyD51sD0QmDLZhYy//E4ilc=
X-Google-Smtp-Source: AK7set9+kxgKye1mSsnUlfufHVU7xtXrzf46BGkcxAKXIkok0aHjf93KJDNyLsIfeIvrKzE4lF+fSQ==
X-Received: by 2002:a17:902:c404:b0:196:2b0d:feb7 with SMTP id k4-20020a170902c40400b001962b0dfeb7mr411973plk.13.1675717915029;
        Mon, 06 Feb 2023 13:11:55 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:546b:df58:66df:fe23? ([2620:15c:211:201:546b:df58:66df:fe23])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902849200b0019906c4c9dcsm3574362plo.98.2023.02.06.13.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 13:11:54 -0800 (PST)
Message-ID: <a291e155-875c-d8b2-67ad-092c91b99597@acm.org>
Date:   Mon, 6 Feb 2023 13:11:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
 <20230130212656.876311-2-bvanassche@acm.org>
 <20230201205800.t3gpx7w3aw2ozab7@garbanzo>
 <20230201212332.p3mdb5ab3qisuo2x@garbanzo>
 <4c9b87dc-aeeb-43b6-0c18-4d04495683da@acm.org>
 <20230201235919.q5rhglvgw7uduexy@garbanzo>
 <ea0eff5f-5c05-ebca-58a4-1e772a6fa739@acm.org>
 <Y+EkzOIVEaTmVvw7@bombadil.infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y+EkzOIVEaTmVvw7@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/23 08:03, Luis Chamberlain wrote:
> Yes, my point is prior to this patch the debugfs directory is created
> even if you have CONFIG_BLK_DEBUG_FS=n and I've mentioned the commit
> which describes why, but the skinnys is blktrace.

I overlooked that the blk-mq-debugfs code is guarded by 
CONFIG_BLK_DEBUG_FS instead of CONFIG_DEBUG_FS. I will fix the issue 
that you reported.

Thanks,

Bart.

