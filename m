Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDF2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 17:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiBIR6N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 12:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiBIR6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 12:58:13 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760FAC0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 09:58:16 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso4332445pjd.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 09:58:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GbUT5GE93e0QFPhYm46tfEwsOyLnT6Kwcc/88vCw/nw=;
        b=bzPWGNgMdYgxf5wobIQmyJpLwiJ13f201jE2fMXGChzF+zmSSdVeLm7zqZ6EdXn82S
         gXthTJ9shtviQz4SgcxpqIyYLpNPWQ5mkjc6AIhdAv4gZ2p27I0ELeTqAZDMJZrGHBt5
         uBjk6k+hjBvXS5Qd2HHf8Va7zT0ClOVAkfs2ml4M7p8q5MVbbS1wQOd87hZwkSPsUb1D
         rxGENCWYxgOA3be20eqyGIACIlugRYEtUjUuoO9o8WK3mjSaMoxd28PDiBJ+lyYLzq9b
         izSU+TKd0T1tivsR+vlceP/mAM5nov/vIE6K27Jx5Rl2ebn52qk0rzdOWFZYfqaMqn50
         8r9Q==
X-Gm-Message-State: AOAM532PJRZ7xYbysAe+RidFjM92igOgGw7pEJx/a2R2cprz6NNWZ0g7
        Qtj7LF53vCPc8E7x9bYkR+o=
X-Google-Smtp-Source: ABdhPJwu+k5tCSGizQmTiXMJzLXrsMUcTJYfLQIkCOtWZo+aeRklfK8PxO+WOjIASvvhhRNjS72wWA==
X-Received: by 2002:a17:90a:8c8b:: with SMTP id b11mr4598314pjo.197.1644429495729;
        Wed, 09 Feb 2022 09:58:15 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h6sm21997931pfk.110.2022.02.09.09.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 09:58:14 -0800 (PST)
Message-ID: <23f63a54-8dfd-ec0b-4552-b431ce5df3bf@acm.org>
Date:   Wed, 9 Feb 2022 09:58:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 05/44] NCR5380: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-6-bvanassche@acm.org>
 <43e1e556-7c3f-d0e6-ffc3-8e6b5fa6e4ab@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <43e1e556-7c3f-d0e6-ffc3-8e6b5fa6e4ab@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 23:29, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> +static inline struct scsi_pointer *NCR5380_scsi_pointer(struct 
>> scsi_cmnd *cmd)
>> +{
>> +    struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
>> +
>> +    return &ncmd->scsi_pointer;
>> +}
>> +
> 
> Seeing that it's open-coded at several places, maybe kill the macro 
> entirely?

macro -> function? Anyway, although that makes type checking less 
strict, I will do this.

Thanks,

Bart.
