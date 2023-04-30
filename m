Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995CFC77B73
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Apr 2023 19:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjD3TjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Apr 2023 15:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjD3TjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Apr 2023 15:39:16 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DDB186;
        Sun, 30 Apr 2023 12:39:14 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-63b4960b015so1257672b3a.3;
        Sun, 30 Apr 2023 12:39:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682883554; x=1685475554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0MUOiR0NK0TNr+Y5AvgEYruL6TTgFuBbHWzDVlAEZz8=;
        b=H+EF7S2S2nU3wko1g7AODOm1hv3Vks+daOB4HPRhoC65jlvqIpnWeJ82vQeXRN+Nhq
         8mYI4h8apTXqnXPfnZ5mjXiprG1XNHixV9mb2E6Ol8TOmvPS51T5NYThd8ly8f+0FFbG
         UWtFDdwsX1PhBaHbCcI+PXOB41/cTCUMNX1XM0gzx3e5qND1DjzWJdfxdHLr7SyYYokO
         BAuoHXzpa4TAqKe1yNWKHSm7ZcAr1kiRDh4gP9JqPTDkm9vMfM1tXeJESlP2L+3Niqwv
         zQ7Z3vm7uhOCHvGjEKv4SJ15egMx3Pw2uaJhFUGJWLwH3iIFrgMT3vaoTjcYdrq9OvBX
         px/A==
X-Gm-Message-State: AC+VfDwE+l2TWctWdNfq9WKsfgJ4Za02oyc7mrPiP8bQ6S/3lTDw/lA6
        nzwe/kVglFgw5pAn7uPs8nM=
X-Google-Smtp-Source: ACHHUZ69pgbyqn8j5arzwt5/hGJKQ5lgE8NW0PVSzuHaTtHCrR0ZdTryj4NCoqlnTHXebKrWlpCwAQ==
X-Received: by 2002:a05:6a20:8403:b0:f6:d60d:dbc2 with SMTP id c3-20020a056a20840300b000f6d60ddbc2mr14853090pzd.28.1682883553953;
        Sun, 30 Apr 2023 12:39:13 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id s18-20020a056a00195200b0063b96574b8bsm18593068pfk.220.2023.04.30.12.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Apr 2023 12:39:13 -0700 (PDT)
Message-ID: <e9165662-7af2-0540-f823-56a5f051620f@acm.org>
Date:   Sun, 30 Apr 2023 12:39:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Content-Language: en-US
To:     Alan Stern <stern@rowland.harvard.edu>,
        Maxime Bizon <mbizon@freebox.fr>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/23 12:20, Alan Stern wrote:
>> This patch fixes the issue, not sure if it's correct:
>>
>> --- a/drivers/usb/storage/scsiglue.c
>> +++ b/drivers/usb/storage/scsiglue.c
>> @@ -455,6 +455,9 @@ static int device_reset(struct scsi_cmnd *srb)
>>   
>>          usb_stor_dbg(us, "%s called\n", __func__);
>>   
>> +       if (us->srb == srb)
>> +               command_abort(srb);
>> +
>>          /* lock the device pointers and do the reset */
>>          mutex_lock(&(us->dev_mutex));
>>          result = us->transport_reset(us);
> 
> Maybe...  But it would be better to check first whether the SCSI core is
> supposed to be reusing an active srb in this way.
> 
> Martin, can tell us what is supposed to happen here?  Is the
> eh_device_reset_handler routine supposed to be called with a scsi_cmnd
> for a currently active command?

Hi Alan,

I'm not aware of any other .eh_device_reset_handler implementation that 
aborts the command that is passed to this callback before it aborts 
other SCSI commands. However, I'm not aware of an equivalent of 
us_data.dev_mutex in other SCSI LLDs either. Maybe this deadlock is 
specific to the USB storage handler?

Martin, feel free to correct me if I got anything wrong.

Bart.

