Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF434CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 15:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1A6520869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 15:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfKDPzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:55:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46740 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDPzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 10:55:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id l4so2490210plt.13
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 07:55:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7sBSlNq+fZbV65+LfVQq9PzNrypwNOBeNLk6aj/6htU=;
        b=QowEDDYhcjbUC5QlYONUQqB4JCJo6EBt3eDIIsQsCwl1MMf6kdIOQ4ngoHjpiHDYXg
         CVfrnBsCKLwPzsw5qwmnf3Jd7DCXyfJqlIX2qUNEvsk5Bqdgmr11ru0YWK5KYCLqnVMi
         ciGSNcSOpOaUzhmgtM13EgUU5pna/3kLF9sqlG7oFp1fvi5O/oOyfmN1tOB+T72Mkf3F
         YIquXEVgr52FvlgYM4L9d4lUVWVHKwiiECFSQbsksz/eLrPYSfNkhvU6hcXqEdLXj+Zi
         qxbid/UJ9hYyzp3UE5aOFoVIMdqNxk0HsrwtdQ3q7jH5AAWO/aCYWHHKAeFYTbruWUg/
         tY6g==
X-Gm-Message-State: APjAAAUS7VgCSBk7CdwlDBiIRsGIxKLyXE4xnizIY4IPfvUax2LU/rjl
        xmxzXDrpTgVStLthPuqRnFE=
X-Google-Smtp-Source: APXvYqx08EbMDqjyVjOUj2YP/OZQqIdYqUrxHd8AMDTgIDzNc8H1vY9SsrIu3i/B7+vPPPe0csmsEA==
X-Received: by 2002:a17:902:8ec7:: with SMTP id x7mr18551676plo.88.1572882903141;
        Mon, 04 Nov 2019 07:55:03 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 16sm17825952pgd.0.2019.11.04.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 07:55:01 -0800 (PST)
Subject: Re: [PATCH 0/4] Simplify and optimize the UFS driver
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20191031225528.233895-1-bvanassche@acm.org>
 <MN2PR04MB69910A6F1B859497BCF0A74EFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <17ae0e63-f1fc-429d-fb69-d2c8695ce3a3@acm.org>
Date:   Mon, 4 Nov 2019 07:55:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <MN2PR04MB69910A6F1B859497BCF0A74EFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 6:34 AM, Avri Altman wrote:
>> While reading the UFS source code I noticed that some existing mechanisms are
>> duplicated in this driver. These patches simplify and optimize the UFS driver.
>> These patches are entirely untested.
 >
> Please allow few more days to test it.

Thank you Avri for having offered to test this patch series. Please wait 
with testing until I have posted v2 of this series - I just realized 
that patch 2/4 needs more work.

Thanks,

Bart.

