Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF65C54FCB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 18:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A4620781
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 18:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNMprwWa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730162AbgDWSZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 14:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730074AbgDWSZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 14:25:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F7DC09B042
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 11:25:07 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o10so3293139pgb.6
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 11:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F2ujVAy1dJF7Q/C3AstinjeeMvVQyr8iW3tgjpw7aNw=;
        b=GNMprwWaaETipJCEmryzOaWk1XcAYYzHmeVIS9e7nY7V1kT0ld9xktQL343mcKsFTy
         VDZ+8hpOOVli9Eu2enpDWdVTNzVvaNoCCxDEHNDeUyUlAuE3HHHRwxZP3S0Bix4QEaNH
         4Ed8fSRKvx0fyxiuySwvz71kapbE4flh4IKLh0CA2Uz42o9zBatkcZrmdEq3mlcguYVs
         mJ08yLOoC4GheS7P7Pv6pfVW9akd7IWjRmZHUEBOUABrsRlRbx+Mq0x8nFPcq9tr7EJS
         KHExEuRFrcQ74t8iIEzD2cZ/+1VvODjVmTD0+HhyH0Si9Pc8XycHAHK8e8msWUgjTJtk
         Vn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F2ujVAy1dJF7Q/C3AstinjeeMvVQyr8iW3tgjpw7aNw=;
        b=lAG5SHoNCickk35kuTljfkqQdO/a7j88roNaOFflZhrvOU4D5YkAfro9YJtJGVBVVJ
         m9r+PonHT3ay58FK3GjR7upo799ay28o+KorzmEaKlP9gbqDaeyvMV8ntKz9uy68UYcO
         PR8qgRH/rzQFP+sK+sbgk2tRi75sMHnJuYzAOjJ7vaiojfpvWekXpQrzwh6Q1SIjw8n1
         Zfg9x7kZlpxkMuRGKR3YEdbBVVmr+fS0ItFMb5A6Q+Vdu7qhlgl4P7po9LGvrYqphYXc
         yQ4wadge9LqsyjWCx0MFGbchtEGgGeC0Ba0DtIA3bF6XmNEpZ4eNa4HIhUDsHFKjtnW7
         3VxA==
X-Gm-Message-State: AGi0Pub+Hd634yAmakvjQctQgVFouqlLSmCFT+T7qKbDUpL6RyMayYvf
        RfNDDFw3BZA8+BZDS9mwTtY=
X-Google-Smtp-Source: APiQypL/z77Hmfg8z44bY3+4SrnHkHZ6z3hI1Iuz0vIiRSfjJ/iKunvyfhWIaaKhwh/fGYuKyvVKuA==
X-Received: by 2002:a63:e957:: with SMTP id q23mr4756399pgj.401.1587666306804;
        Thu, 23 Apr 2020 11:25:06 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y10sm3254267pfb.53.2020.04.23.11.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 11:25:05 -0700 (PDT)
Subject: Re: [PATCH v3 12/31] elx: libefc: Remote node state machine
 interfaces
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        maier@linux.ibm.com, bvanassche@acm.org, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-13-jsmart2021@gmail.com>
 <1f711306-0c3d-ab28-6984-73299efe6e5f@suse.de>
 <3f7d5a66-f366-70d4-3730-a75fe2e1a3b8@gmail.com>
 <20200423080223.6muuun5ce2pumooe@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <ceb811e3-8771-af44-1170-6830a2d6fe77@gmail.com>
Date:   Thu, 23 Apr 2020 11:24:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423080223.6muuun5ce2pumooe@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/2020 1:02 AM, Daniel Wagner wrote:
> 
> Thanks a lot for this. IMO, this should be added as documentation.
> 
>> In IO path, EFC lock is acquired to find the sport and node, release the EFC
>> lock and continue with IO allocation and processing. Note: There is still an
>> unsafe area where we check for 'node->hold_frames" without the lock.
> 
> Is this is the fast path? Would RCU help to avoid taking the lock at all?
> The usage pattern sounds like it would be a candidate for RCU.
> 
>> Node is
>> assumed to be kept alive until all the IOs under the node are freed.  Adding
>> the refcounting will remove this assumption.

I'll see what we can do, and will look at RCU.

BTW: also agreed with your comments in all the remaining patches, so 
will address those as well.

Same for Hannes's comments.

-- james

