Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA4CC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCGC5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGC5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:14 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025EE21947
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:13 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id d10so6790782pgt.12
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 18:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678157832;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jp5p6Ej08bEBkoQXFt1xc9yMy9F89D+N/6bMZIM1YoQ=;
        b=34XZcxC7GIjQfcvNAxQQD3640CRwqH8UzILorcs+zqKUrAehmTjQdsfClNLoF+2W2T
         k6u8nK5ZwB9Bzp7FM7kNjqXPpXggiCgP3LVeZDypSi37vquA54UfWbAaTYpkJl9QndqS
         +4lwtba2fD3xtQGKC8RkpKzCUyOV1phCTzKi/vivULA/yjMueYlBHYXeQmiwZJmuXYu0
         1WRr9BjC3PMFlnNs2aW6pb+sp0Tk0ZRwaSzGmfnX4lDMWnzwqKU/Ye1J/VuEy+99n5gB
         UiI6ccwsNi0e3okRuyYZcgAESCeoQKWYaiWmxdtbmoS0Ke+csKZYbMGD5lzvLQWTTz3d
         XT5Q==
X-Gm-Message-State: AO0yUKUaUP1cS1YEM8JRSp/5jpY60J/kFTpxg5tJZyeXyymI6gLn609Y
        u2kIOdz+KIsan39Hd/4EWrk=
X-Google-Smtp-Source: AK7set9CLRlN0x21xyp4O7hHm3x4NgQOdrwuZuGKY4JQAXi6Q52JOPL9+rhl1w7SiQ4310iEvxnE8Q==
X-Received: by 2002:a62:7b53:0:b0:5e7:710d:5e4 with SMTP id w80-20020a627b53000000b005e7710d05e4mr10314184pfc.9.1678157832252;
        Mon, 06 Mar 2023 18:57:12 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id x20-20020a62fb14000000b005d6fcd8f9desm7118004pfm.94.2023.03.06.18.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 18:57:11 -0800 (PST)
Message-ID: <add1722b-6077-fc73-1518-1753743c2a03@acm.org>
Date:   Mon, 6 Mar 2023 18:57:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 48/81] scsi: iscsi: Declare SCSI host template const
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Varun Prakash <varun@chelsio.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Jesper Juhl <jesperjuhl76@gmail.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-49-bvanassche@acm.org>
 <b89d5cfb-9c24-23e7-2ac5-0176c5a7b16f@oracle.com>
 <yq15ybdmiam.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq15ybdmiam.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 18:02, Martin K. Petersen wrote:
> Bart: Please put isci in a separate patch.

I will do that.

Thanks,

Bart.


