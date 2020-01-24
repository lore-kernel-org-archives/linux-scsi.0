Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB97C35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 03:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E86B21D7D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 03:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgAXDMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 22:12:07 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32945 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730664AbgAXDMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 22:12:07 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so290458pgk.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 19:12:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L3dAXZNGNZz4ZwrSSlKRuiosN8qzuYywAoNayhLJGJA=;
        b=bGQxL0BfsQ7bnM5rHMYsH5O9Fr6zOurErp6sKMU0ZpR77L4dKnPwcXa0zNt9qil4Ai
         HDAoE4fUW9sR9AvyJEbsQgG3PJPR+QeJSAxZmG5EQjjqYIJ/iKM0jT8iGNEZp+/AgYUM
         iXVKIyjuXzYxlW9r3geW0d773mNgb70txxtNA75LrvWzu8dvv5VDetSIRpVXrZWlPVcS
         MYeUt00jds5wkcXT7tmAWnarUvlWAaW/0pWgNsXKrNkJvJVCg94bgfpyBEvIwsSmvNUf
         y4v7FryNbUVahgF5G7fZS9NzywPWtis3IbE26m3zZ1g/ZlNGrDYxgeX249CLx3vlWbwp
         jnKA==
X-Gm-Message-State: APjAAAUMZfEXX6zjjCuy/Bg5LSj40Vlqpa8q6hR+FriSufz2R/arhaVB
        Ktaq+DUChuefNq2QJkndNJm4pVCr
X-Google-Smtp-Source: APXvYqxAG1gl7c4bb5/AIusb7/oy+jzrlc0C7OhONTWd6VxygVJbixCJmyN66i3NzTRvkVmCOfpjwg==
X-Received: by 2002:aa7:8006:: with SMTP id j6mr1194466pfi.185.1579835526581;
        Thu, 23 Jan 2020 19:12:06 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:3d7d:713:61bd:ca2a? ([2601:647:4000:d7:3d7d:713:61bd:ca2a])
        by smtp.gmail.com with ESMTPSA id y20sm4124458pfe.107.2020.01.23.19.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 19:12:05 -0800 (PST)
Subject: Re: [PATCH v2 2/6] qla2xxx: Simplify the code for aborting SCSI
 commands
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-3-bvanassche@acm.org>
 <20200123101730.tqvkhgq42dvmq2tr@beryllium.lan>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <b110ffaa-aeaa-7454-d64a-cf35124aca7b@acm.org>
Date:   Thu, 23 Jan 2020 19:12:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123101730.tqvkhgq42dvmq2tr@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-23 02:17, Daniel Wagner wrote:
> On Wed, Jan 22, 2020 at 08:23:41PM -0800, Bart Van Assche wrote:
>> Since the SCSI core does not reuse the tag of the SCSI command that is
>> being aborted by .eh_abort() before .eh_abort() has finished it is not
>> necessary to check from inside that callback whether or not the SCSI command
>> has already completed. Instead, rely on the firmware to return an error code
>> when attempting to abort a command that has already completed. Additionally,
>> rely on the firmware to return an error code when attempting to abort an
>> already aborted command.
>>
>> In qla2x00_abort_srb(), use blk_mq_request_started() instead of
>> sp->completed and sp->aborted.
>>
>> This patch eliminates several race conditions triggered by the removed member
>> variables.
> 
> I can only guess here what the races are but I agree removing the
> logic here and relying on the SCSI layer to handle it correctly makes
> sense. 

I will make the patch description more clear when I repost this patch.

>> +/*
>> + * The caller must ensure that no completion interrupts will happen
>> + * while this function is in progress.
>> + */
> 
> So could we add something like WARN_ON(irqs_disabled())?

qla2x00_abort_all_cmds() is typically called after the kernel driver
discovered that the firmware stopped processing commands. If the
firmware has stopped processing commands it is safe to call this
function without disabling interrupts. Even if the caller would disable
interrupts, that would only disable interrupts on the local CPU but not
on other CPUs. Additionally, disabling interrupts is not a proper
solution because if a completion interrupt arrives after a command has
been aborted that will cause trouble if the command handle has already
been associated with another command.

Bart.


