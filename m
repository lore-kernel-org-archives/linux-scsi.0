Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC5AC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A12A064E22
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhCKPs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:48:29 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:35727 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhCKPsH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 10:48:07 -0500
Received: by mail-pj1-f48.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so9261475pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2021 07:48:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gK/0F0ef4Lte7vVeIyn+EPhh8Zvm4IiAalovDhy+pG8=;
        b=kQGiiFVe4e/ymi8vhN8lAywJEnH4Wj7I6QMIxo2+ct4KkXNKLYQIcsIN6PkX1X4lZR
         CWu/bo6shJ35m7gKLX8Iyy5qxS1h5hmswxR0WEbcknvUtCBsAXnBJOKIQ/bd//uMVjdU
         WszMDLhaUrhIsGGmABQFbESDzx6/ppaZkZ34gkKXSD5OfJ4hyIYC46OeO6SSu9ygLGxW
         jGqrC5Aynw8RDPfVFI50kUWTcxjXF74/G4i6xKh3ZU8Z2b6KgxzIIqsmPFICchBJVxJU
         wndqoSOHA4PNdbfj0po2pZgvBozua8f5RGWeVziI486EwLNa5trQweNUpJB9gyyPuJKG
         IXrw==
X-Gm-Message-State: AOAM532wSwmtSdJ+K9Lm/cF8lSjpiny5Mof4xA8aIdM6FHsqgNfhWJMn
        arwqOvCjnIcne78pmfeyYB6OMNO6XIM=
X-Google-Smtp-Source: ABdhPJyOBWkYlWIL5w1f6D62q3LCQhtroFkqZLGE2i3wk36bN8D/E1G9srrvklGH4bPOW3/bq/hjRQ==
X-Received: by 2002:a17:902:bd87:b029:e6:4c27:e037 with SMTP id q7-20020a170902bd87b02900e64c27e037mr8734340pls.29.1615477686334;
        Thu, 11 Mar 2021 07:48:06 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:c25c:5b7c:8cae:df7e? ([2601:647:4000:d7:c25c:5b7c:8cae:df7e])
        by smtp.gmail.com with ESMTPSA id 14sm2888638pfo.141.2021.03.11.07.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:48:05 -0800 (PST)
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <2a68a06c-7bcf-337d-b819-9e8f63f5e68c@acm.org>
 <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <87928742-6bba-1db1-1ee2-4d62188b2cbb@acm.org>
Date:   Thu, 11 Mar 2021 07:48:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <PH0PR04MB7416733D30D20EA68EBBE0EB9B909@PH0PR04MB7416.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/11/21 7:18 AM, Johannes Thumshirn wrote:
> On 11/03/2021 16:13, Bart Van Assche wrote:
>> On 3/10/21 1:48 AM, Johannes Thumshirn wrote:
>>> Recent changes [ ... ]
>>
>> Please add Fixes: and/or Cc: stable tags as appropriate.
> 
> I couldn't pin down the offending commit and I can't reproduce it locally
> as well, so I opted out of this. But it must be something between v5.11 and v5.12-rc2.

That's weird. Did Shinichiro use a HBA? Could this be the result of a
behavior change in the HBA driver?

Thanks,

Bart.


