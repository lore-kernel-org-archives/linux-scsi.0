Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3334FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11B35610D2
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 17:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240394AbhKHRez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:34:55 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:44570 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhKHRey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 12:34:54 -0500
Received: by mail-pg1-f181.google.com with SMTP id p8so14448035pgh.11;
        Mon, 08 Nov 2021 09:32:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kKEuO5YXcbBlcHaiiVKVj0NBTGwhOLq1VPBkrxjpGEI=;
        b=wis6nSqm3DsWoYY3ny6WqnHW28ojTbggo3bHbVAfaIjHLAdj+N96De7gbhDpovaikp
         0Yqes43as2Jf0n2Z8rwWWGRfCozoPBikUL14qNsgWTswQQHbGx8pCiUMeiiGaM7/O350
         nRxMAWFbKfCWbmEsUy4d9vexbbmiD0uCiU8C1EIhNrl/V6XVed5DUYe14EZflNbFO3wT
         N6D1fRAtwdH10xjVizOq1WAQJiEConSdKZUsredT+auxvbU6jxH3U6VK5TxDOw/6G6+8
         spBV1duNAFYSJ+Xqf9jqh/7OajhU2jdsUlwfp0axSMJKU5UejwSrwm0VjcfuDSf+OT45
         /v5A==
X-Gm-Message-State: AOAM532j29ke9iJqRuNSieBcPbA+/uex07Q21Iw0ebYQRcqFldegnw51
        ye6WWqvVGZ13tkSwRmkPhX/Aw4myWSJuew==
X-Google-Smtp-Source: ABdhPJxA6HRzdCk7J8G41bAHf2+UxRBqtGYb6cBaS2kU1X97QVAXgRcM+2EiJuke1yBCb64pDZt56A==
X-Received: by 2002:aa7:808e:0:b0:493:f071:274f with SMTP id v14-20020aa7808e000000b00493f071274fmr937796pff.37.1636392729209;
        Mon, 08 Nov 2021 09:32:09 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4ca8:59a2:ad3c:1580])
        by smtp.gmail.com with ESMTPSA id j15sm16588841pfh.35.2021.11.08.09.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 09:32:08 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if
 eh-in-progress
To:     Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
References: <20211108120804.10405-1-avri.altman@wdc.com>
 <20211108120804.10405-3-avri.altman@wdc.com>
 <fa7dae1f-06ac-9d5a-616d-cc00c38e5feb@acm.org>
 <DM6PR04MB6575F4831649503EE848C4CFFC919@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <06c95606-ac89-5750-224f-04c72b5cc111@acm.org>
Date:   Mon, 8 Nov 2021 09:32:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575F4831649503EE848C4CFFC919@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/8/21 9:24 AM, Avri Altman wrote:
> I am not sure. I would expect a retry / polling / other, if any, to
> be done in user-space and not in the kernel. e.g. a common practice
> in the code that send SG_IO or other ioctls is to retry on EBUSY. Not
> sure that this is the case in ufs-utils though.
Shouldn't we aim to make sure that user space code does not have to use 
busy waiting?

Thanks,

Bart.
