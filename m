Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16A6C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 22:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjEEWAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 18:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjEEWAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 18:00:16 -0400
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80BA270C
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 15:00:14 -0700 (PDT)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so2112487a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2023 15:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683324014; x=1685916014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSsYzt6uaU07wWCTzBwJxVYmGATVytpcR6cw7D9QUwk=;
        b=SHmxKm1vlKQ7Fq0K9GU5VijVd2x75pIDul/pZ8D1mMcjv6WeJ7Mq5lDK+qWzMdV4Qz
         cmqHqN22IHk2WjpkZu+6TKRatfbGTqI3kmBmzhvtlZuFZGm+Wpe09xEPNX41ZqqkxTml
         QMG7iKjEqbTz6ncGZ5NUPs7LAm25UEr00sWKuJBm/QP8MCKtOudrYVj5/CLiSTsCqD7g
         uViNtW4AfG96RgwKGF7Qp0cpeMTdnSG+c7ly9x3m1gPkGhb0eCYwbewSZ7UF3WarEnRT
         Bpdl0SdEMlr5t3pPT8l8Z346uexOxy65flqUPpRj3Adas368FarTApvHES3eFmjKarXQ
         ynEA==
X-Gm-Message-State: AC+VfDwOA21PaKqsP8ODgdSCPZ26xbuld/73GYDqNKrVdUcrDsTHwSkN
        a/RZaWYsbPlxxWSK7//kHQE=
X-Google-Smtp-Source: ACHHUZ4so4fMCIwnb7Xk/Qb9SJv/XNtr5JZjyphuV+efO5gT5Ab7Qk8D7m2MeMgleMMzL2WVDeb/bA==
X-Received: by 2002:a17:902:db01:b0:1a6:fe25:4138 with SMTP id m1-20020a170902db0100b001a6fe254138mr3051230plx.59.1683324014127;
        Fri, 05 May 2023 15:00:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:127d:5561:7469:3abc? ([2620:15c:211:201:127d:5561:7469:3abc])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b001a9ac65ca7csm2209511plb.309.2023.05.05.15.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 15:00:13 -0700 (PDT)
Message-ID: <01b39bac-804a-0cbc-591c-f7c03c315576@acm.org>
Date:   Fri, 5 May 2023 15:00:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org>
 <18ee41a2-b314-6040-4790-6239d8838068@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <18ee41a2-b314-6040-4790-6239d8838068@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/23 01:07, Hannes Reinecke wrote:
> On 5/4/23 01:06, Bart Van Assche wrote:
>>       TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>>             "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
>> -          "result=(driver=%s host=%s message=%s status=%s)",
>> +          "result=(driver=%s host=%s message=%s status=%s "
>> +          "sense_key=%u asc=%#x ascq=%#x))",
> 
> Why two closing braces?

There should only be one closing brace. I will fix this.

Thanks,

Bart.
