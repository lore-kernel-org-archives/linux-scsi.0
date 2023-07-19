Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034EBC001B0
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjGSSlX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjGSSlW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:41:22 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA61FD8
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:41:20 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1b8b4749013so56736645ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:41:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689792079; x=1692384079;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kx3jqiMRxsbThzTTykIYeJ+NTxLjqyWz/3/3p9AeMkM=;
        b=iqvOO9NOQfjDoXbQ5rsxE0rnsv7sndnbKI1Aa/1Gk6ZipDr/Ht3T11syVTs7XAfCV9
         6dwb67slX/JhK2MvyiOlynsHZvGylz/YQOS+3xlzEbsA2LWn/EcXK854NfXd6jNPcS3y
         dDFvArNMs8zZty0g6tXBDItrH6h6xAj641Pf5LDMyzpsVu1Bb/FTtIjuZ48fzpY9qwLT
         OQ/MMU/m95dyP8vPs0fjfPpNCI/cAjwvyfUU9UnXBBdXNNB+0A/PutdSyG7sRBoKcL70
         Bhtj3mH9CYz6xub2Ztp5Tz1pp+nzufMALMGMWJpjI0NxlbHCSpdAxU8MP/e9H8TIANue
         wn2g==
X-Gm-Message-State: ABy/qLbq1hAuZlN7Bp6BPG34eEZjWqLFMyFWtMzgXqhUqDRzJ1SRRg1b
        lTNBHb3lqvMTawHL2xdN0H0=
X-Google-Smtp-Source: APBJJlFIqXKTJcbESJD8ATz06NvadwjEmmdkS7rLXX3EtXeqdGnN8AmTKtMMMl4ao6ecQ11KdM3/UA==
X-Received: by 2002:a17:902:868a:b0:1b8:1335:b775 with SMTP id g10-20020a170902868a00b001b81335b775mr17027159plo.0.1689792079425;
        Wed, 19 Jul 2023 11:41:19 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a2ab:183f:c76c:d30d? ([2620:15c:211:201:a2ab:183f:c76c:d30d])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902eacc00b001b895a18472sm4318711pld.117.2023.07.19.11.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 11:41:18 -0700 (PDT)
Message-ID: <08e146ce-e957-db02-c5b6-8d86e1d30f57@acm.org>
Date:   Wed, 19 Jul 2023 11:41:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 08/33] scsi: Use separate buf for START_STOP in
 sd_spinup_disk
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-9-michael.christie@oracle.com>
 <e040738e-2518-4780-50ef-eb80085ceea4@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e040738e-2518-4780-50ef-eb80085ceea4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/23 08:45, John Garry wrote:
>> +                /* Return immediately and start spin cycle */
>> +                const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
>> +                    sdkp->device->start_stop_pwr_cond ?
>> +                    0x11 : 1 };
> 
> same comment as previous patch

I'm not sure that using designated initializers for initializing only the
first five elements will improve readability ...

Thanks,

Bart.

