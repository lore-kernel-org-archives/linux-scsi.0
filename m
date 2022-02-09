Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129C8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbiBISjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbiBISjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:39:01 -0500
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F6AC05CB86
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:38:35 -0800 (PST)
Received: by mail-pf1-f177.google.com with SMTP id z35so5853497pfw.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:38:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h0Yyi1heXRlRbqph+NryNzDBx0pc2okezUxX/rjYR1g=;
        b=XX2IXhfSIze4wghA2tE8VoNLSuraaXs/kylxWYzE2+yHu1/FzLo0CBUnF3qDp9qWHs
         icco9Dd0S0A7tJWY8XdAv0mfAmCZVop2kRuG2GJSuDO58WQNaRGLxoqnSfEuHAYvN8jj
         cti2TuEqz/3BcbNC/xKmDqzkDoCN2HQKrUnWAisqGBnddZyrMDK8rcbDjlZ2IUgzNgLw
         3j9EeA+pfCYrQvg+lGfBJUGvMw+L1TJx2D4qGA+nCqGInN4kvo8FoBSWq4Rx6rmieaQo
         WcnQY5D5sRoJBXowicu1AWbSyVwqI3oKudYvqMJzeALvpe+bfvzhTk6iIGa7N04S2Vh2
         JKcQ==
X-Gm-Message-State: AOAM533sYFzPirk9Sa5L6ycBKuivAJ/kMoI/RsZWzCcLil8bLHqlPYxn
        BALx85+SY7f/EZqFRPGze3g=
X-Google-Smtp-Source: ABdhPJzUDFV4I+2unRMp6OzpD7/tI1OT4uPY0aLE/0ZBOhGJrR3lGlv1QianIlRt9xHp2HOCwOWK0Q==
X-Received: by 2002:a05:6a00:134b:: with SMTP id k11mr3639632pfu.33.1644431915331;
        Wed, 09 Feb 2022 10:38:35 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 207sm14420159pgh.32.2022.02.09.10.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:38:34 -0800 (PST)
Message-ID: <f3d5d410-c6c1-925e-edf4-0b2ffaa2c2e7@acm.org>
Date:   Wed, 9 Feb 2022 10:38:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 27/44] megaraid: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-28-bvanassche@acm.org>
 <8e2ce1a3-ea79-9a91-d32e-b245067bb9a0@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8e2ce1a3-ea79-9a91-d32e-b245067bb9a0@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 00:14, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> +static inline struct scsi_cmnd *
>> +megaraid_to_scsi_cmd(struct megaraid_cmd_priv *cmd_priv)
>> +{
>> +    struct scsi_cmnd *cmd = (void *)cmd_priv;
>> -#define SCSI_LIST(scp) ((struct list_head *)(&(scp)->SCp))
>> +    return cmd - 1;
>> +}
> 
> cmd - 1? Seriously?
> 
> If you need this you'd better introduce a helper
> (eg scsi_cmd_from_priv()).

The megaraid driver is the only driver in which I could not find an 
alternative for converting a private command data pointer into a SCSI 
command pointer. How about defining a data structure in the megaraid 
driver that has two members, a struct scsi_cmnd and a struct 
megaraid_cmd_priv and using container_of() to do the pointer conversion?

Thanks,

Bart.
