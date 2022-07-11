Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC15CCA47F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 11:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiGKLOz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiGKLOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 07:14:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2A42408B;
        Mon, 11 Jul 2022 03:32:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id h23so8031926ejj.12;
        Mon, 11 Jul 2022 03:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W0F0+dXTQ5eUSgDBHtSzB6kQwdC7rU5BTU/Dvmo8qbM=;
        b=nWO73xisKGyqbJpJMOLdWmivDT9xRGxyxw/UWEmyu39dESuDatvQqUC8uvyEi0aH5w
         mwcnL56EgxCXWPL64aCqN8OznS+xd59Zhs/Cuq+cl7YZiWRGdUHNqFz1vKiKxmHLaP/5
         9pdmB1e+qx0b50yer41UOVE/yVIvXtyou5f03Jlj1ETCqf7euZlrfnVN7OWRa442u/R7
         m6tmvtaP6f4kd1Xw+TWd+Nllb10hSjj8FND9000Tkmd5G3Yb0bd3O5XPd7FQVz4u9jOz
         HnSkcdlcRngrtrAZDTvTVTl4F1GHOEcV379z4sX6evPSv92C1IWMXqoVtYAtmwJQh2Cd
         VqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W0F0+dXTQ5eUSgDBHtSzB6kQwdC7rU5BTU/Dvmo8qbM=;
        b=8M1nkLBtbmWBqgKelcq4aUcm0VOaHSONneqIb+QBHUzZ7BwWoKp/dR/hJpVjv2OJr8
         itWPjFKinTVxMjgxl8szxtXHaW1khqTQ2dw88GQGTZay9nNQZj/vPvCGsu1CYJqacE3N
         XU7w4u3DVHR/fvks2G1lM9dGO5ffcVv4Tob8hbBpwQLPcLZlOkxwhrn5rLTPTW15KXBP
         HopkF6gF7gHdrjYPPG4/Rp1vJqTruEsWjTSmtp5MFILhylPJBX2q5an2NTNLsUZZuf9a
         x5DffHPN4VbOQPjBahPnN/Dal25WC0l4HPZovFZbvVebiCfleA+qObKeKkS2/FpvyqAi
         Jr/A==
X-Gm-Message-State: AJIora9MyJppsLQ5jRR+ANIh9+uE8CU6mDFW7bqtir7qd1pxu4fgGwve
        N7sHKbURTSFJy32k3j367IQ=
X-Google-Smtp-Source: AGRyM1vuLUXIw/ymJcxqq1Ve89ZFAgjwLLXthqOqTdiN5W7avF6BbaN2zBtOM8M/Bw56CXDfGnQCCg==
X-Received: by 2002:a17:907:7e87:b0:72b:4af3:bf57 with SMTP id qb7-20020a1709077e8700b0072b4af3bf57mr7007733ejc.9.1657535521700;
        Mon, 11 Jul 2022 03:32:01 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1d9fa.dynamic.kabel-deutschland.de. [188.193.217.250])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906201100b00722bc0aa9e3sm2533464ejo.162.2022.07.11.03.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 03:32:01 -0700 (PDT)
Message-ID: <205876d4-5455-4f31-4c9b-34df736f68fc@gmail.com>
Date:   Mon, 11 Jul 2022 12:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 04/36] target: Does tmr notify on aborted command
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707125657.GB23838@yadro.com>
 <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On 09.07.22 01:11, Thinh Nguyen wrote:
> On 7/7/2022, Dmitry Bogdanov wrote:
>> Hi Thinh,
>>
>> On Wed, Jul 06, 2022 at 04:34:49PM -0700, Thinh Nguyen wrote:
>>> If the tmr_notify is not implemented, simply execute a generic command
>>> completion to notify the command abort.
>> Why? What are you trying to fix?
> 
> If tmr_notify() is not implemented (which most don't), then the user
> won't get notified of the command completion.

When you talk about 'user' you indeed mean the initiator, right?

The initiator _is_ notified of command completion, because TMR
completion is deferred until all aborted cmds are completed!

> 
> I was trying to directly notify the user via target_complete_cmd(). It
> may not be the right way to handle this, any advise?

Target core must defer TMR completion until backend has completed all
aborted cmds, because completion of TMR tells initiator, that processing
of aborted cmds has ended and it now can start new cmds.

I implemented the tmr_notify callback for two reasons:

1) It allows e.g. userspace backend on tcmu to create a consistent
logging not only showing scsi cmds, but the TMRs also.
Only cmds that are aborted before they reach backend processing (for
tcmu that means: before they reach tcmu's cmd ring) are not visible
for the backend.
Additionally, some userspace daemons need to know about incoming TMRs
to allow handling of special situations.

2) it allows to speed up TMR processing, if backend uses it to finish /
abort processing of aborted cmds as early as possible. In tcmu for all
cmds in the cmd ring this is up to userspace.

If you want to speed up TMR processing for other backends, you could do
that by implementing tmr_notify() in those backends. Changing the core
IMHO is the wrong way.

Bodo


> 
> Thanks,
> Thinh
> 
>>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>>> ---
>>>    drivers/target/target_core_tmr.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
>>> index 7a7e24069ba7..2af80d0998bf 100644
>>> --- a/drivers/target/target_core_tmr.c
>>> +++ b/drivers/target/target_core_tmr.c
>>> @@ -14,6 +14,7 @@
>>>    #include <linux/spinlock.h>
>>>    #include <linux/list.h>
>>>    #include <linux/export.h>
>>> +#include <scsi/scsi_proto.h>
>>>    
>>>    #include <target/target_core_base.h>
>>>    #include <target/target_core_backend.h>
>>> @@ -150,6 +151,9 @@ void core_tmr_abort_task(
>>>    			if (dev->transport->tmr_notify)
>>>    				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
>>>    							   &aborted_list);
>>> +			else
>>> +				target_complete_cmd(se_cmd,
>>> +						    SAM_STAT_TASK_ABORTED);
>> That is wrong and breaks a command lifecycle and command kref counting.
>> target_complete_cmd is used to be called by a backend driver.
>>>    
>>>    			list_del_init(&se_cmd->state_list);
>>>    			target_put_cmd_and_wait(se_cmd);
> 
