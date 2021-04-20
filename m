Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07637C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D15610A1
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhDTPDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 11:03:20 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:34357 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbhDTPDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 11:03:19 -0400
Received: by mail-pf1-f178.google.com with SMTP id 10so16855926pfl.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 08:02:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IrB81cPouWH0vFXJOtiPB2Ixm0USDk7grAxY1sGrjHE=;
        b=KR2ShhOyiCYrA/cAgFThSz5xJRG9zcaMrrIV4TP21qRYMeiauWXDQEQq9HGzyXMNA5
         Y6fYW7jOCqJ7XAKYHWuY5XIpNi4bBU7g0v3d8JfyoYLiqLfsNI/FxltJl3/dkS7aZeyG
         RMeaN84hJRDTqa6QkxWzSIbhGAEr2PVtbllfLgTTpyzzNoqYeyu6C+JMaqMaeTpxZyKw
         wkjXNGS0fYqL3lb7TWFfX8bW3UkN1OP1IW6y/cmRyrSe9iefeGSuF0IoU2bmv0oPVaQN
         W0wWuie7jQvS/MMWg9b/k0kp1i1+ChsKUtLXPogUhz2iU4As7aUgDLQAc1KSgxCxj6Vg
         r0SQ==
X-Gm-Message-State: AOAM533Y6wQ21ek5+NETQ3wYkWdiBGPdOX3Na0T543AODxQ2U4OD+ytI
        0uRxUTk+5mOIbH9xT8vYYT8=
X-Google-Smtp-Source: ABdhPJx3Mhji7cajYkfo6AI9TBIq5A+YUJPZo2f//+fIA/G0shPRaqFBWKLNkj6uWbLAfrR16jGwJw==
X-Received: by 2002:a63:5814:: with SMTP id m20mr17576669pgb.82.1618930968225;
        Tue, 20 Apr 2021 08:02:48 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b389:6c06:5046:89e? ([2601:647:4000:d7:b389:6c06:5046:89e])
        by smtp.gmail.com with ESMTPSA id b25sm4806637pfd.7.2021.04.20.08.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 08:02:47 -0700 (PDT)
Subject: Re: [PATCH 093/117] staging: Convert to the scsi_status union
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-3-bvanassche@acm.org> <YH6HKauLLpJdGqeU@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2800d64f-cb58-374b-5d22-321c754bd691@acm.org>
Date:   Tue, 20 Apr 2021 08:02:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YH6HKauLLpJdGqeU@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 12:47 AM, Greg Kroah-Hartman wrote:
> On Mon, Apr 19, 2021 at 07:13:38PM -0700, Bart Van Assche wrote:
>> An explanation of the purpose of this patch is available in the patch
>> "scsi: Introduce the scsi_status union".
> 
> Where is that at?
> 
> As a stand-alone-patch, this is not ok in a changelog text at all,
> sorry, and I can not take this.

Hi Greg,

That is a reference to an earlier patch in this series. I plan to
replace the above text with the more elaborate description when I repost
this patch series. For the current version of this patch series, please
take a look at
https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@acm.org/T/#u

Thanks,

Bart.
