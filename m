Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E7DCA9EC1
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 22:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE10120717
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 22:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfJ1WCd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 18:02:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41438 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfJ1WCd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 18:02:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id l3so7897583pgr.8;
        Mon, 28 Oct 2019 15:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bz8VblbiHFOYjXJUCKtVNIb5vyB/ffU+wnMQeoK63HA=;
        b=KnvXI1WsgXuwg8s9LptklJyQxQd5aY2nokkWuvcvx7c56Mi60/CZDAnkG/GWtMg2SK
         r0a6EQA4u/YwnS4pxsVNW6S4XvpcJ0gDhcD6ew2WBAhxEvbBSrzj1kij9iH2tOVvIn4k
         nI0YPeZr/BdocNWdo0IVGQ98yASN52RhYLayr5ZwnGFwSPMUzfD3Dpn3hOJUT6ArSoZa
         7nUOg5Hw/wObU3h0mZHiIKzPCZEPFJ00eicXTSJVA/xEcxuevu/Iz7X7EK/apYTUU/0B
         nyaebaNqRDWb62CkPA+lwsDUzByKPwPFQno1Thk7oALsSKlmH6XTJw0FWjnXB0FlLXFD
         AE2g==
X-Gm-Message-State: APjAAAWn31Js/NQN1x7Drt9P6CEbPJyBybOmEgJQp7eSUYjB/ON5qLof
        WJVklnbzkzu6GjXnOSh5AWk=
X-Google-Smtp-Source: APXvYqzLZZpO28g4Qa4rOV1u5j3YqZfy9PqRC0dUwOtqx1k/09KdM2J4ogP2MWOFdrWLc6kZdQuF1A==
X-Received: by 2002:a62:c1c1:: with SMTP id i184mr22769658pfg.65.1572300152794;
        Mon, 28 Oct 2019 15:02:32 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m2sm11457894pff.154.2019.10.28.15.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 15:02:32 -0700 (PDT)
Subject: Re: [PATCH 0/9] Consolidate {get,put}_unaligned_[bl]e24() definitions
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
 <20191028215258.GO4643@worktop.programming.kicks-ass.net>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d9c00250-7880-fa0b-75c3-2cdd58da0fd3@acm.org>
Date:   Mon, 28 Oct 2019 15:02:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028215258.GO4643@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/19 2:52 PM, Peter Zijlstra wrote:
> On Mon, Oct 28, 2019 at 01:06:51PM -0700, Bart Van Assche wrote:
>> Hi Peter,
>>
>> This patch series moves the existing {get,put}_unaligned_[bl]e24() definitions
>> into include/linux/unaligned/generic.h. This patch series also introduces a function
>> for sign-extending 24-bit into 32-bit integers and introduces users for all new
>> functions and macros. Please consider this patch series for kernel version v5.5.
> 
> While I applaud the effort (and didn't see anything off in a hurry), I do
> wonder why you think I should route these patches.
> 
> I don't think I've ever touched the unaligned accessors...

(+ Andrew Morton)

Hi Peter,

I wasn't sure which kernel maintainer to send this patch series to.

Andrew, I think that the include/linux/unaligned/generic.h header file 
went upstream through your tree in 2008. Can you perhaps recommend me to 
which kernel maintainer I should send this patch series? An archived 
version of this patch series is available at 
https://lore.kernel.org/lkml/20191028200700.213753-1-bvanassche@acm.org/T/#t.

Thanks,

Bart.


