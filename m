Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4C5C001DB
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Aug 2023 15:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjHCPBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Aug 2023 11:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbjHCPBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2023 11:01:53 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F851FCB
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 08:01:52 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686daaa5f1fso739751b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 03 Aug 2023 08:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691074912; x=1691679712;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e97bCmDaTB4tpth9KicXuomYDqP0eZLiRfIIYQcMS50=;
        b=B6NMFJkuqzFZZQzqVKvp5AyEPg8pyGDABG5TaO+Tppapu/5esl6QpoE8t11T5JhwIP
         bWihPBdDSTCXg0gMSyPGEgvzXfMCVgvt1LKwnot/KAONSXkg+pVFylbkwAD8BdPykF/k
         sQ/CSxTlcXh2tnpZTQU766FYefHATQ6wMRj3+K6BuZTcfJj1WNhJKbxQFeJiwzMvDtUK
         d/lqArIKRpELe8uWjfse6ss93UH1kSrqXSSvXFzYi5Orv5z8tgu/ORmfsItXGgTfg4Yy
         ez+hQavnNOzXj67a7lYVJofG3HELbILdAQ7b8Ep3MKi2GqsqastDYhRcexKPjAWSxzlT
         BnMg==
X-Gm-Message-State: ABy/qLYb1BonUXqjlci81HFBHnrfxNWjKr3izlv9o5DkwSA79jBqr3VK
        cRW9KEJiSwE5GzTwKZ1z71k=
X-Google-Smtp-Source: APBJJlFSaKyRpo2tEuqD5VvAvi3Iq6TkbVMpvTTC2eOx8fdEKzjaf8ncPlSCuyc3JPK1AU+YsTMNbw==
X-Received: by 2002:a05:6a00:2442:b0:686:ec1d:18e5 with SMTP id d2-20020a056a00244200b00686ec1d18e5mr18808253pfj.28.1691074911602;
        Thu, 03 Aug 2023 08:01:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b168:5a8:480e:1a0b? ([2620:15c:211:201:b168:5a8:480e:1a0b])
        by smtp.gmail.com with ESMTPSA id l21-20020a62be15000000b0068743cab196sm6469435pff.186.2023.08.03.08.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 08:01:50 -0700 (PDT)
Message-ID: <8f92a6d5-9185-72c4-51ba-725a2ebc1eb8@acm.org>
Date:   Thu, 3 Aug 2023 08:01:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH -next v3] SCSI: fix possible memory leak while
 device_add() fails
Content-Language: en-US
To:     Zhu Wang <wangzhu9@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, kay.sievers@vrfy.org, tonyj@suse.de,
        gregkh@suse.de, linux-scsi@vger.kernel.org
References: <20230803020230.226903-1-wangzhu9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230803020230.226903-1-wangzhu9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/23 19:02, Zhu Wang wrote:
> If device_add() returns error, the name allocated by dev_set_name() need
> be freed. As comment of device_add() says, it should use put_device() to
> decrease the reference count in the error path. So fix this by calling
> put_device, then the name can be freed in kobject_cleanp().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
