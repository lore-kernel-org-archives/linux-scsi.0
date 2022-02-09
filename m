Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83706C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbiBISfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiBISfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:35:02 -0500
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67CAC05CBA6
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:35:05 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id n23so5838183pfo.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:35:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7lzVKfstJYFW3akWX54+WBfEWVXY7XKtT96bRExLQlk=;
        b=uXRqqHvWXzM6F11unlZl7tbD1yD6GbLHRQY3jlwHW/cIOYU+AUUjoEBvwOdnhFtoEa
         fmL2hK63qYi503xHo8alA/vlrbMRAWP8Cokpja5eple5vVkWho45nDzSUPo4RhEt7L4o
         TXpAXvgXuD0ewpN1tywL7UHiI5jRXwW7X8lBWqC4caAiAgKLSAna5bOSabC9Ucnacd/T
         9Vqcuz55WCa0wRLLflArsOfmt6yw0aqw60qTgpx6j0sw9CfzWUH3qAV7OE5hEiqNLtdP
         B5Qtc8rEavSn2WLg6prA2qUVClB20y03wWPg5yBvmgT2PYfVZKgjRi3ABSgtXPQ+Eayx
         2/yQ==
X-Gm-Message-State: AOAM533ahKmVCJy8m09D+s8uhACVgnGChL4CMFhDeVKu7/97YjxHQz9D
        XGueQt2cpJmt+eQ67LGwkow=
X-Google-Smtp-Source: ABdhPJwAX/awOjCbcpYnAeu4ouY/OL4Jn22DWYJnyOKdP9opNHaowyrun13E3T8B+thTOTZD9xEwkQ==
X-Received: by 2002:a63:216:: with SMTP id 22mr2940705pgc.89.1644431704990;
        Wed, 09 Feb 2022 10:35:04 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id u13sm21886321pfg.151.2022.02.09.10.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:35:04 -0800 (PST)
Message-ID: <debd7b83-c470-6459-9a76-f4f83658d479@acm.org>
Date:   Wed, 9 Feb 2022 10:35:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 26/44] mac53c94: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-27-bvanassche@acm.org>
 <f003e500-a63d-5332-6122-0019cdcae1be@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f003e500-a63d-5332-6122-0019cdcae1be@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 00:11, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> +static inline struct scsi_pointer *mac53c94_scsi_pointer(struct 
>> scsi_cmnd *cmd)
>> +{
>> +    struct mac53c94_cmd_priv *mcmd = scsi_cmd_priv(cmd);
>> +
>> +    return &mcmd->scsi_pointer;
>> +}
>> +
>>   #endif /* _MAC53C94_H */
> 
> Also here: Why not use 'struct scsi_pointer' directly as command payload?

To make it easier to add more private command data in the future. Do you 
perhaps want me to use struct scsi_pointer directly?

Thanks,

Bart.
