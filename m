Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C62EC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 16:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiF3QJh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 12:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiF3QJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 12:09:36 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729162409D
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 09:09:35 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id dw10-20020a17090b094a00b001ed00a16eb4so3348456pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 09:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z3RAsRAwIQYhEvWNhB8O/eQ6u+hUMzjwQoHb9vW3Bx4=;
        b=FFpxVT90RjU1+U5ZaSRQM7RIJ6ZEXABE3x7KXQBRp9prkcXCp6lJ9eIWZRbTmrO81Y
         chlRem/MOlDd61tYWqQAvj6q0ofZ43JiPi3NA9E5s8Zx20zr88tswO2HqASP2G4tVBSh
         p7265nppz9srsTpJqgeZ4eQM7JIzj1IRdTvyBo5RWD7qSuE/+7vfEr9m076Gv/h7bdPv
         26DW7704gfyYPwPlVzcL0XC/Uhibmu83UnmphrgMtjF5G8p4sY25xeKJgSqynkkUzNlX
         Y+eGEFNrUp+PZe19q7N2nS9Z4O0viTA0p4yKfJqckpzDifawfH24SRw0fkuqxyHBjEQr
         sHdg==
X-Gm-Message-State: AJIora+z+vDDFVyuIAMAfApzKrU7dkKdRRXTgw77k8vcaMNmtfFE6gqC
        QKq4C4OC+ZapBjmMzhel5Zk=
X-Google-Smtp-Source: AGRyM1s/SmBxWYISYUbHf4TPlEgP+MLHHuWmqHCmWSI7T6o9XGo8JXzXLW7mSWr+bmoacuzNeF7b+Q==
X-Received: by 2002:a17:90a:b701:b0:1e8:6d19:bcb with SMTP id l1-20020a17090ab70100b001e86d190bcbmr10794423pjr.218.1656605374076;
        Thu, 30 Jun 2022 09:09:34 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709027d8900b0016397da033csm13612233plm.62.2022.06.30.09.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 09:09:33 -0700 (PDT)
Message-ID: <0c498a20-5410-77e5-4492-fcd5fdbfab52@acm.org>
Date:   Thu, 30 Jun 2022 09:09:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] scsi: sd: Rework asynchronous resume support
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>, ericspero@icloud.com,
        jason600.groome@gmail.com
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-4-bvanassche@acm.org>
 <64551444-39fd-2853-7ea8-053d023df75d@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <64551444-39fd-2853-7ea8-053d023df75d@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/22 23:02, Hannes Reinecke wrote:
> On 6/29/22 00:21, Bart Van Assche wrote:
>> +/* Process sense data after a START command finished. */
>> +static void sd_start_done_work(struct work_struct *work)
>> +{
>> +    struct scsi_disk *sdkp = container_of(work, typeof(*sdkp),
>> +                          start_done_work);
>> +    struct scsi_sense_hdr sshdr;
>> +    int res = sdkp->start_result;
>> +
>> +    if (res == 0)
>> +        return;
>> +
>> +    sd_print_result(sdkp, "Start/Stop Unit failed", res);
> 
> Surely START/STOP unit can succeed, no?

Yes, hence the "if (res == 0) return;" code. Did I perhaps misunderstand
your question?

Bart.

