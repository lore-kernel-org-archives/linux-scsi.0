Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F1EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiBISYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiBISYc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:24:32 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB475C0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:24:35 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id y7so2962256plp.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zJXn0mmNUoTYQBI1yucXoXeRGZYLQeIfSKqDBZPQNPQ=;
        b=6zywZ1uniyb4DA49bY1NLNNuW2GBW57snEG5MQB+JgKMRPEYP16b/qUSBITqxiEtzQ
         PDJ6N+zbvmCmPdFef+uvBmWJEANVfOvWHNElY5LPX26Jkzke+gXqow7oHiqLIOs3sTn3
         4yrbUM8FiXGNWBu8v6Z9L5zEoz4L7tlhTq398ExiCmhc+x61CoEcw2ubrYehxupVqBjF
         Qs9SvHyHJQZFHI8UDIjm/AfUtMNLKDGXgtcjeoWSNDhCFHXCbNPUO1W6A1iYZD/kL1kB
         SpIp8gPS+iqI0/tWU9kE/jipCKybdfIzKmxAVbwlDbm+BktT6oT0tl7Tt8/D0m955axN
         GBpQ==
X-Gm-Message-State: AOAM531VotIm7gA4S5L06HuXJKC05fBGG7ddtMT1eGeG3Tddik3jV0Gn
        kPB8oyqabtO+/KdW0lsqJU8=
X-Google-Smtp-Source: ABdhPJxOSQ8uAalRBN6bpfnoZTRTNBlr91evYFbrf9zMSsSRKium1vpUbKT2IKTzYDSSHLpYi6Ez5g==
X-Received: by 2002:a17:903:1c2:: with SMTP id e2mr3676803plh.154.1644431075324;
        Wed, 09 Feb 2022 10:24:35 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 207sm14406207pgh.32.2022.02.09.10.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:24:34 -0800 (PST)
Message-ID: <ceebc6a6-6515-f66d-bfd3-40693a2f0888@acm.org>
Date:   Wed, 9 Feb 2022 10:24:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 20/44] hptiop: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-21-bvanassche@acm.org>
 <726f470b-0262-7416-e2dc-8b68424fb74b@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <726f470b-0262-7416-e2dc-8b68424fb74b@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 23:57, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> -struct hpt_scsi_pointer {
>> +struct hpt_cmd_priv {
> 
> Why not keep the name? You have been using 'struct scsi_pointer' with 
> all the other drivers ...

I assume that "SCSI pointer" refers to a section in the SCSI II 
specification with the same title. The hptiop private data is not 
related to the SCSI II "SCSI pointer" section. Hence the renaming of 
this data structure.

Thanks,

Bart.
