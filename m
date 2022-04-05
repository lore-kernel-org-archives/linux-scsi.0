Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18990C4167B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446987AbiDFBIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573460AbiDETLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 15:11:18 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1BB1EADB;
        Tue,  5 Apr 2022 12:09:18 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id i10-20020a17090a2aca00b001ca56c9ab16so2443035pjg.1;
        Tue, 05 Apr 2022 12:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KqPdTTAkIPZEGxZKNABzyGtE0ndiZgNTYdvHB+Ojtik=;
        b=CnLRwKfCCJtDdt0ElG2ODjhOu/eeHu0LM0XUyT8v4/gzgp1ZOcZ0WIqYOoqRZPxzhg
         Wh2ZtmQeKZNmO49Fbu6Nu8h9YMycW7cnDKWhafqBSQ5drp+aotorHUas+IKmMxnNhphQ
         ORDH4BqAnqFwUP3iRKc/wXCQRYLGcN9hhVlKPtxJi2ZNDhM+dIvY4C/VRSPi4wz0VQZq
         6BWpc9h2UVomMgtU5jz1mvAiRSNgJjznOKnY6l3SrgThu/JeoByGuy7uBaYubP55vl9A
         DcM6FyABqLtugmeXEeABNf3p/f7eWMl27uxw/87TtYi6Qth08BVuCe7As/Ga0EhoU/TW
         sjZg==
X-Gm-Message-State: AOAM531PjZK6EJs6R76AunwChAp22Iv2eo8JsL5Sj4aCiNUwF44JYwlw
        GCAIhFObWsgbQyqxay0kdLs=
X-Google-Smtp-Source: ABdhPJwhSNjuHo4h/4MK/MjyZC/rq8mAiS9T7IwWyWtBqMnrLhJ5JJt3LmMSYSZC3cqhWhcBP6faOw==
X-Received: by 2002:a17:903:244b:b0:154:4104:4668 with SMTP id l11-20020a170903244b00b0015441044668mr4958750pls.30.1649185757702;
        Tue, 05 Apr 2022 12:09:17 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q6-20020a056a00150600b004fb2d266f97sm17149906pfu.115.2022.04.05.12.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 12:09:16 -0700 (PDT)
Message-ID: <ad7eb0c9-23b7-ac11-3de9-10393b9e526e@acm.org>
Date:   Tue, 5 Apr 2022 12:09:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] scsi: sym53c500_cs: Stop using struct scsi_pointer
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4948f86703d23e5048f4e24e649680259b2610f9.1649146056.git.fthain@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4948f86703d23e5048f4e24e649680259b2610f9.1649146056.git.fthain@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/22 01:07, Finn Thain wrote:
> This driver doesn't use SCp.ptr to save a SCSI command data pointer which
> means "scsi pointer" is a complete misnomer here. Only a few members of
> struct scsi_pointer are needed so move those to private command data.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
