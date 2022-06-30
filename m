Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3F0C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 18:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiF3S5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbiF3S5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 14:57:40 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574103C730
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 11:57:39 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id w1-20020a17090a6b8100b001ef26ab992bso392139pjj.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 11:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w3ABJMZ1a8USZEuFMaqLKbI+FgosswJiTdxBKxxRB4I=;
        b=WS1GJehR9fgZlSeE3ByIT2HSBtyfvIBAyRi58i06MZeUiJfSCGjuaLoD8mHseWBEoX
         3Yq64jZhjT8X6a+ZBzpnTp0EUr3Q4FfCIwoskk/tKPMd1qZCNf9ETvMMdrqFGEOzKoZS
         cLHrjb5JlzPtfgQuC3LUSkKc5J1k6qmkLesQTYRaVBrvPZbliBkC/VmWQL/V3zrUs7l0
         4uAfRqBpoProuOCxPFXohzL0SmzTerdYaW6CJWY+GjJ4+McXzKvHDL/Zur6YC0GQ6QfM
         tF6/Bjt4/VcosjoIKSZsQY6W/ZLb3GDn2QKjVUFdwNZjsNEEoua40i2yAAJyMu0YZZxx
         fTOg==
X-Gm-Message-State: AJIora9ZEmV799qZR1aEEbLjnCXBpYIPWsX7UiQvMLzqx9Ag1PAwyRee
        6we4bVjMcY4iq2Zle3wcGjA=
X-Google-Smtp-Source: AGRyM1uNKERzeiliIZiP3Hw0u2dlGPZ9oYzJJMTF9rwGuia59VAH1QaQ0cvLpbbjGv3vZ8UOQsY5pw==
X-Received: by 2002:a17:902:b215:b0:168:da4b:c925 with SMTP id t21-20020a170902b21500b00168da4bc925mr15524462plr.155.1656615458709;
        Thu, 30 Jun 2022 11:57:38 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 63-20020a630542000000b0040c762eb57esm13750000pgf.82.2022.06.30.11.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 11:57:37 -0700 (PDT)
Message-ID: <b55be9e0-e1b7-8c8e-7c40-0cb633e381d3@acm.org>
Date:   Thu, 30 Jun 2022 11:57:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 3/3] scsi: sd: Rework asynchronous resume support
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        ericspero@icloud.com, jason600.groome@gmail.com
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-4-bvanassche@acm.org>
 <82e30007-1ffc-92e4-38b5-eaf7dd2e316d@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <82e30007-1ffc-92e4-38b5-eaf7dd2e316d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 09:23, John Garry wrote:
> On 28/06/2022 23:21, Bart Van Assche wrote:
>> +/* A START command finished. May be called from interrupt context. */
>> +static void sd_start_done(struct request *req, blk_status_t status)
>> +{
>> +    const struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>> +    struct scsi_disk *sdkp = scsi_disk(req->q->disk);
>> +
>> +    sdkp->start_result = scmd->result;
>> +    WARN_ON_ONCE(scmd->sense_len > SCSI_SENSE_BUFFERSIZE);
> 
> If scmd->sense_len > SCSI_SENSE_BUFFERSIZE, do you really want to go on 
> to copy at sdkp->start_sense_buffer (which is of size 
> SCSI_SENSE_BUFFERSIZE)? Won't that cause a corruption?

scsi_mq_init_request() allocates a buffer with size 
SCSI_SENSE_BUFFERSIZE. SCSI LLDs copy sense data into that buffer. I am 
not aware of any SCSI LLD that modifies the cmd->sense_buffer pointer. 
So if scmd->sense_len would be larger than SCSI_SENSE_BUFFERSIZE that 
either indicates that the LLD reported a sense length that is too large 
or that it wrote outside the bounds of the sense buffer. Do we really 
need to add a protection in the SCSI core against buggy LLDs?

Thanks,

Bart.
