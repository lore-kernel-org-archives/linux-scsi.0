Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4AFC5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 17:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C56CA2087E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 17:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbfKERC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 12:02:27 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46351 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387789AbfKERC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 12:02:27 -0500
Received: by mail-pg1-f196.google.com with SMTP id f19so14648147pgn.13
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 09:02:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l68aG+y0dqrWsIyfNLTTWM1vyVdAHg9uZYs+Et4HiI4=;
        b=WlbNSXFnQk1KwG+Q/wTVvoBfvgSNeVD7QgK+33nwp/9Tp/vz7Z+bUjlR3xM5Vl+dGO
         qXip11obAXxGYIdRebhkSc001WExL4e1U0t21P2cKJ/O345wWTM0Y6/phL5qVPSgFudy
         5JLL0qMBK818uc5ju/lgzAN0qryLx3LhN5VR7kRRC1Js+NHhrek1cAQ+mnUZWyZYJXiy
         mBkkAiQQDONVNxKiZPEhwB0ii2J2PFcu0tejLSOZit+T8Q8HNQcDTZeIK2+U83B+mupf
         n3oqy2MSR7JMUSrJ8p5ORvQ9b7zDoJWA9emXxuLeoM0unQXOcBr6V1qfMHdSRJcsFaIJ
         OkYQ==
X-Gm-Message-State: APjAAAXbRzvtlNwnyjedkREHkFJDdt2YnAsnT8LmLl991sgQj0HSWoRF
        Waup0hmjT0kRtu0lR9sURn4THpA1N8g=
X-Google-Smtp-Source: APXvYqxvFbvEGqtjHFJcQrNJg2kb+sdiwesLiNR3l2MxaQlhw6JLdEtXH3U3gcJCFydoQhNv8dfEFw==
X-Received: by 2002:aa7:96c5:: with SMTP id h5mr38657983pfq.101.1572973346353;
        Tue, 05 Nov 2019 09:02:26 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id t8sm5320pji.11.2019.11.05.09.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:02:25 -0800 (PST)
Subject: Re: [EXT] [PATCH RFC v2 2/5] ufs: Use reserved tags for TMFs
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-3-bvanassche@acm.org>
 <BN7PR08MB56849F96E16115321F44F257DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <11e7ba67-84ca-2f86-0bce-78646ced9612@acm.org>
Date:   Tue, 5 Nov 2019 09:02:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB56849F96E16115321F44F257DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/19 3:58 AM, Bean Huo (beanhuo) wrote:
>>   	host = cmd->device->host;
>>   	hba = shost_priv(host);
>> -	tag = cmd->request->tag;
>> +	tag = cmd->request->tag - hba->nutmrs;
>> +	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
> 
> Changing request tag number here is not proper way, we have trace tool using this tag to track request from block,
> SCSI to UFS layer. If tags being changed in UFS driver, there will be a confusion.

Hi Bean,

Thanks for having taken a look. Which information is used by the tracing 
tool? cmd->request->tag or the variable called 'tag' above? The latter 
should not be modified by this patch. cmd->request->tag is modified 
however for every command that is not a TMF. Preserving the block layer 
tag value is possible but would require to introduce a new tag set for TMFs.

Thanks,

Bart.
