Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CABCCA482
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 13:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiFWNMT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 09:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiFWNMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 09:12:17 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE98E41F88;
        Thu, 23 Jun 2022 06:12:13 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id d14so15295164pjs.3;
        Thu, 23 Jun 2022 06:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CSfPRsek6TY0ETOoUksAgDlvP5eJ2iNIFz8xmTeCdD8=;
        b=hcv58u59jUGUW3r8SvvukxUSOrgEHqwfWDgds7x0j7IWgSsQx8TOABH/65fNQZgwKO
         PssZ1RqSisuDC5G43o0NpWu6OtYGdCAODTCeQVbZfpzcpBYDPeuIaBfQQKc4CBQgntfH
         T7a5YBCqjowmejiXsj55n4F7rQdvEz3XWjWzf0eLbTkrWsmZsu1FKlgPs1WfEnVGItTm
         PxhD+7FBO8W9WeF/0kMAnbsom2TKzefXTDOR/0qq2x/5dVqC9IYBOslz9orNG5vtFZu2
         0r4Ha+SkWqxdl5IYR1EulTKzIiwAtoqB85OILbi7U45VK4v5vR0TLEomAtRtIjQLuNRN
         yo5A==
X-Gm-Message-State: AJIora9av5U9wtPrkBWGSrare7tJeLbq9PpqutLjxJGxaGtDTUJ3+Yq0
        XSN3vpXBbZxf8t8Bwa2zK6/myh1ghm0=
X-Google-Smtp-Source: AGRyM1tYEwNFwAtN9BR7ToQECHxeTpniI+ubUdkmlhs5UOA+4VbnyarnXYp4aWf6C5UR5DIsVBXrjw==
X-Received: by 2002:a17:903:234c:b0:16a:4d9d:ed09 with SMTP id c12-20020a170903234c00b0016a4d9ded09mr6999802plh.120.1655989933067;
        Thu, 23 Jun 2022 06:12:13 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id w15-20020a170902a70f00b0016a106cb221sm3694381plq.243.2022.06.23.06.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 06:12:12 -0700 (PDT)
Message-ID: <2a124ef2-d46a-0888-0ba9-4890f3581c81@acm.org>
Date:   Thu, 23 Jun 2022 06:12:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 5/6] blk-mq: Drop 'reserved' arg of busy_tag_iter_fn
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        damien.lemoal@opensource.wdc.com, hch@lst.de, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com
Cc:     linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@other.debian.org
References: <1655810143-67784-1-git-send-email-john.garry@huawei.com>
 <1655810143-67784-6-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1655810143-67784-6-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/21/22 04:15, John Garry wrote:
> We no longer use the 'reserved' arg in busy_tag_iter_fn for any iter
> function so it may be dropped.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
