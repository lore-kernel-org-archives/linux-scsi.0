Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E420C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 16:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB1C613C1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 16:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhETQ7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 12:59:40 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:44810 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbhETQ67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 12:58:59 -0400
Received: by mail-pf1-f177.google.com with SMTP id 22so12413663pfv.11;
        Thu, 20 May 2021 09:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jLPo0GB3A2MoBZjU1iN/tZ1ti56h7RK68caLrB/74lo=;
        b=b46D5DAIRmxCCm8Mj78SXEJ/X9uPFlHirqwFQ4aGm/wMbdj3TmaB3DPs3wQrSZaxbK
         cwFIqMjx3qDdzmscT7WiP0TSquHb4p+ban+T7hWrKShvR5rTOwy3ANk65XKxD78zmkJ5
         ziAkP20Yn7SNsMOjVc+P/2MJXstqD2GZ48cfHq2eKjXJQRL+VK1K4VspH+0K+cTa2EOw
         Y1rB0czY+fRsJwjfpjSyrrGHrzKB2OkOaXuUH+sDLudaqoWCh6da4g+1XO2NZuVBORkD
         j1HAOxWIs6Y8w4n1dmXJvXZwutmBPVT9s/Z7gT2fQt614xb78oK05M6cLNkSAcpb3rQf
         dEUw==
X-Gm-Message-State: AOAM530iNepWp6VFJgLpq5gRc11KCvvHWwJnq1Rk5SZ8lbjSqITZyx+w
        nlKrlLkLh8C8Vyp5WHpxXvc=
X-Google-Smtp-Source: ABdhPJzQ764raH3JeUb3X+DRnbbP8JSaUQs6h4uV476RdeXIRYMfHF9TNhAAxjxJLnDlTTgPF9CPPg==
X-Received: by 2002:a05:6a00:acb:b029:2dc:db73:d44c with SMTP id c11-20020a056a000acbb02902dcdb73d44cmr5771286pfl.28.1621529857668;
        Thu, 20 May 2021 09:57:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9549:3d1e:fcc5:81d1? ([2601:647:4000:d7:9549:3d1e:fcc5:81d1])
        by smtp.gmail.com with ESMTPSA id w123sm2301648pfw.151.2021.05.20.09.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 09:57:36 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
 <988856ad-8e89-97e4-f8fe-54c1ca1b4a93@acm.org>
 <a838c8e2-6513-a266-f145-5bcaed0a4f96@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <439c6fb8-3799-bfae-7f44-9f8c26a7bf79@acm.org>
Date:   Thu, 20 May 2021 09:57:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a838c8e2-6513-a266-f145-5bcaed0a4f96@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/21 9:41 AM, John Garry wrote:
> On 20/05/2021 16:57, Bart Van Assche wrote:
>> In SCSI header files a mix of int, short and unsigned int is used for
>> cmd_per_lun and can_queue. How about changing the types of these two
>> member variables in include/scsi/*h into u16?
> I don't mind doing that, but is there any requirement for can_queue to
> not be limited to 16b?

Maybe I'm missing something but it is not clear to me why different
structures in the SCSI headers use different data types for can_queue
and cmd_per_lun?

$ git grep -nHEw '(cmd_per_lun|can_queue);' include/scsi
include/scsi/scsi_device.h:318:	unsigned int		can_queue;
include/scsi/scsi_host.h:372:	int can_queue;
include/scsi/scsi_host.h:425:	short cmd_per_lun;
include/scsi/scsi_host.h:612:	int can_queue;
include/scsi/scsi_host.h:613:	short cmd_per_lun;

> It seems intentional that can_queue is int and cmd_per_lun is short.

Intentional? It is not clear to me why? Even high-performance drivers
like iSER and SRP set can_queue by default to a value that fits well in
a 16-bit variable (512 and 64 respectively). The highest value that I
found after a quick search is the following:

 #define ISCSI_TOTAL_CMDS_MAX		4096

Thanks,

Bart.
