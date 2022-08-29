Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF583ECAAD4
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 12:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiH2Mbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiH2MbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 08:31:10 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7F2647C7
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 05:15:11 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id f24so5033178plr.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 05:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=7Ov5I5pslw/ReMv11MgQPLDgw8iL24fS6AbkxiJv+O8=;
        b=AuFO58tP1d9KP3tibm3oJzw1nrXehI3bkSjGzMHsJlieTODMGHZjRjf3igAsxqXd9t
         Qrg9zcXUP0zu8Iqoj+eM36JerdzuSVY8njdXeQCfKT8ZISBcjkA/RbAAkyp0NguRz1BQ
         JgFMmk1zfPDv2j67SJBo4wcPxnSejNv9LREcAdBFBqqsTHyxP0PJdDEs9uTP1luMlb3H
         mfsr3jadExqkCSfVQW1PxMmA/hxWVEpQcwAyPvij94eRFO0pXJ4LBDxpHsmJ3TaJsWZ7
         DaDO+dYJEm0p5o+usg6fDHbiGtnCcS4zQQiVsD7K3hVlnpVmSYbXcBkcnA7Nl81v6I4E
         hlbg==
X-Gm-Message-State: ACgBeo00xK9HbyypbNWjkCjximPZq4IRoKJ7H1tRh294fudfQL2TTuI2
        AoOHza14QC3JBxoCgH30C3A=
X-Google-Smtp-Source: AA6agR6sZuVWCgw4q0GcOo1b+QgkpiqEH8JzIBLO5WGdmrxDzAMyU2oD7JcwwbvNJee8PYzwXx0J/w==
X-Received: by 2002:a17:902:b184:b0:172:766e:7f35 with SMTP id s4-20020a170902b18400b00172766e7f35mr16035001plr.174.1661775251241;
        Mon, 29 Aug 2022 05:14:11 -0700 (PDT)
Received: from [172.20.0.236] ([12.219.165.6])
        by smtp.gmail.com with ESMTPSA id z5-20020a17090a66c500b001f334aa9170sm6514224pjl.48.2022.08.29.05.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 05:14:10 -0700 (PDT)
Message-ID: <a4dedbb9-8a7f-2576-11a5-322aedd6e9fe@acm.org>
Date:   Mon, 29 Aug 2022 05:14:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] Revert "Call blk_mq_free_tag_set() earlier"
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220821220502.13685-1-bvanassche@acm.org>
 <CAFj5m9Ka4-Ee9E7Wo4R7+FrscYZ+GU4EThoweFNRMOR6rPMxJA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAFj5m9Ka4-Ee9E7Wo4R7+FrscYZ+GU4EThoweFNRMOR6rPMxJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/29/22 02:14, Ming Lei wrote:
> On Mon, Aug 22, 2022 at 6:05 AM Bart Van Assche <bvanassche@acm.org> wrote:
>> Since a device, target or host reference may be held when scsi_remove_host()
>> or scsi_remove_target() is called and since te patch series "Call
>> blk_mq_free_tag_set() earlier" makes these functions wait until all references
>> are gone, that patch series may trigger a deadlock. Hence this request to
>> revert the patch series "Call blk_mq_free_tag_set() earlier".
> 
> Care to share the deadlock details? Such as dmesg log or theory behind.

Hi Ming,

Details of two different deadlock scenarios are available here:
* [syzbot] INFO: task hung in scsi_remove_host 
(https://lore.kernel.org/all/000000000000b5187d05e6c08086@google.com/).
* https://lore.kernel.org/all/Yv%2FMKymRC9O04Nqu@google.com/. The link 
[2] in this email includes a call trace and instructions for reproducing 
this issue. My root cause analysis of this deadlock is available here: 
https://lore.kernel.org/all/27d0dde8-344c-1dd0-cc26-0e10c4e1f296@acm.org/.

Thanks,

Bart.
