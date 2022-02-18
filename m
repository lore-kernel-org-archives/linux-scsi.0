Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FACC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbiBRTni (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:43:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiBRTni (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:43:38 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8C0E7AF3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:43:19 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id 27so3506563pgk.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:43:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r7YJm91PzKi2mQubZ12ZinrxmxAr3SvQWIBr28eHloM=;
        b=mxaSRBJ9aS2ajRwSKPzVWhqlHolA1+gfAWyfnKD++fXF3hGeWQDpITGRtxgyqMbVc9
         9IzPM9SapnCAxQkbsBOr3RjB7jHcNdZP+V8SC3gXsDDQSaw3afjRqj4mc/3SaLclOnA4
         54Q0Tr5YiPbCqwoOUBQlpHrAesg0o5PDjPlroFCB4q3ZC1wCXRQd63I78FXsb9TY8/Bx
         dIeuG3MPk/R7eVnfRzCrWZrOqIdZ+HNJBhjq7IOy2pW/f4TRoSiBvHrqzbuA8lQcgiYX
         0DOXALasITlZsyJ06zW6FUCPTlKghvZ62NQb/vRfJ77hginFGyKPVlPpjctZOlOgC6Xy
         4GnQ==
X-Gm-Message-State: AOAM530rkPGUvB2XmFBiHeZV+rwZTdbXuaKtVgrCM23epumL2Fk0LaJM
        vqa0YLu0UXc0QaGO7ARQZPtooNhSFre8qw==
X-Google-Smtp-Source: ABdhPJy3IP4L18pFjx2RmbwqouPqste2W+BnwaIQTuAJO1Fp9bj7rqhUWVEB5QwlAwx3/tQgRXCjBw==
X-Received: by 2002:a05:6a00:1ac6:b0:4bd:140:626c with SMTP id f6-20020a056a001ac600b004bd0140626cmr9116782pfv.7.1645213398574;
        Fri, 18 Feb 2022 11:43:18 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j9sm2528633pfj.13.2022.02.18.11.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 11:43:17 -0800 (PST)
Message-ID: <9b52bd97-5535-a5b6-6533-17c196331372@acm.org>
Date:   Fri, 18 Feb 2022 11:43:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v4 00/50] Remove the SCSI pointer from struct scsi_cmnd
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Ondrej Zary <linux@zary.sk>
References: <20220216210233.28774-1-bvanassche@acm.org>
 <cacca1db-be52-d816-b0b9-e625438ebce@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cacca1db-be52-d816-b0b9-e625438ebce@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/22 16:45, Finn Thain wrote:
> On Wed, 16 Feb 2022, Bart Van Assche wrote:
>>    scsi: NCR5380: Introduce the NCR5380_cmd_priv() function
>>    scsi: NCR5380: Move the SCSI pointer to private command data
> 
> Please replace those two patches with the one below. This one is better
> because it adds less source code, adds less scsi_cmnd private data,
> updates an overlooked comment, avoids anything like "struct scsi_pointer"
> and doesn't shadow any local variables.

Thanks Finn for having written and shared this patch. I will replace the 
two patches mentioned above as requested.

Bart.
