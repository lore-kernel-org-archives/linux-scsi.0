Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1A5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 19:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245712AbhK3TY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 14:24:28 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:36704 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239820AbhK3TYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 14:24:24 -0500
Received: by mail-pj1-f47.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so19062753pja.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 11:21:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rFUVUyYZt++d16sRUJYkdH2pYmZbGuFxOaDacLUpXgU=;
        b=ckUrVvzyjxR4vlUIbytjj87BI2GwpvQYDYr5Faj65eCpRp3E8bTKqc1GUp49/G+0Oa
         5/YtzvexDM4NfdHrR3LbTeuTqgLtdVuVmxwgBs6OQyJKSJt6qQXZ3c5JGfTMI3USXWmw
         BXb2jUFXcerCWdrZBO7awMhiEOPo77UqDlata95ZRpY97WJ4EljGKHViog7/GIyUnjOl
         a6hfJDb483HLEd6ZeaYaEcpaXrLmDs/vblB70zVUbc7FLeLYmjJMYqoCWyn/kcghujzM
         vCRyn8gzrVqWw4DDmOPb2d479AUIv3yCfUclTYQdZdXirinIcfVHSsgpnFzm3YDI/gnh
         3p8Q==
X-Gm-Message-State: AOAM530p46TcsHFckjqqaZ2YAnmVrWz+PKGv6TCdtrYsQjg46LDx66F7
        /g/6hoMUjSBxlnrKk7nuX/07uPJUMfs=
X-Google-Smtp-Source: ABdhPJwJ4FT8DmK/+YLmQMbrav3lrqCt/MzZIE7aciSWSc5jI92j/ix923/GxEisu5pBl94zA7NjwQ==
X-Received: by 2002:a17:902:ecc1:b0:142:fae:f686 with SMTP id a1-20020a170902ecc100b001420faef686mr1204291plh.24.1638300065136;
        Tue, 30 Nov 2021 11:21:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id d12sm21473346pfh.165.2021.11.30.11.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 11:21:04 -0800 (PST)
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
 <bc19f55f-a3e9-a3fe-437d-57b9e077f532@acm.org>
 <1a9cddd9-b67a-be4b-4c83-3636f37e6769@intel.com>
 <2cb66e0a-df1e-0825-67b9-cbd2f116fe92@acm.org>
 <e214da03-ce47-9987-09d9-2bbf125b59bf@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ddb7001b-c6c5-ae5a-962b-832f2fd638a5@acm.org>
Date:   Tue, 30 Nov 2021 11:21:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e214da03-ce47-9987-09d9-2bbf125b59bf@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/21 11:15 AM, Adrian Hunter wrote:
> On 30/11/2021 19:51, Bart Van Assche wrote:
>> By using the block layer request allocation functions the block layer guarantees
>> that each tag is in use in only one context. When bypassing the block layer code
>> would have to be inserted in ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd()
>> to serialize these functions.
> 
> They already are serialized, but you are essentially saying the functionality
> being duplicated is just a lock.  What you are proposing seems awfully
> complicated just to get the functionality of a lock.

Are you perhaps referring to hba->dev_cmd.lock? I had overlooked that lock
when I wrote my previous email. I will take a closer look at the reserved
slot approach.

Thanks,

Bart.
