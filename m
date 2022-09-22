Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F871C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 18:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiIVST1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 14:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIVSTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 14:19:25 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4087C107586
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:19:25 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id v186so2180699pfv.11
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 11:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WUxLqhU1xor3GBi6CHNRELKAW7C+MaUX6mfJsNyeQ7s=;
        b=qc6co8Ui8CUUKV6/yLrxKFDOo0aLmAPtFM0/cDVvdD79ZSZupC0Ix3gqzB+JbdmB7e
         Jk0386lpEWpm7sKEVya6wNe2QudnKm26U7FS/BJXLid8OhU88R2kXblGj1aG7bQhIU/F
         7YuTw2757OPRKgf0MW6H4Cz53gu3HCL3Q4EWGP12T2VyckXtkuaYZqLKpG7HtD1gDFDX
         8FmyObnvryH5sWoSr7UM9funP265pCHE2H9ocppzpsE7bOFn14Jg0EnqRnNCDBqRLAok
         4L65KTI6ov+G0m8r/jvJRUQXvkaJN275DDwxrhyBOlgvP4ruzEwyd4W9sXsrZv3Cr3xX
         UGnw==
X-Gm-Message-State: ACrzQf01IveFnNW169jwgo0mh0cTyO9/gdQ5jZzsyYrQRHRyAoMcVJoo
        6XBE7jXL7OwxCHKBwBMKQRU/HIGUNzI=
X-Google-Smtp-Source: AMsMyM5fWsrcqY5mffK1DCU+TAqhB4cVdxWc7bJmuDi4WwGvxs9Kbg7BvnQiT0ZIwtbMhBWzzm+sKg==
X-Received: by 2002:a63:eb0e:0:b0:429:aefa:9fa9 with SMTP id t14-20020a63eb0e000000b00429aefa9fa9mr4003730pgh.122.1663870764644;
        Thu, 22 Sep 2022 11:19:24 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7c7b:f882:f26a:23ca? ([2620:15c:211:201:7c7b:f882:f26a:23ca])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902c94300b00176acd80f69sm4442253pla.102.2022.09.22.11.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 11:19:23 -0700 (PDT)
Message-ID: <ed334e51-21aa-62e7-9a08-df4904dc8174@acm.org>
Date:   Thu, 22 Sep 2022 11:19:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 01/22] scsi: Add helper to prep sense during error
 handling
Content-Language: en-US
To:     michael.christie@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-2-michael.christie@oracle.com>
 <d31df5c9-3e5c-224a-c8f8-296402e4cb58@acm.org>
 <ea1c4d77-0712-b782-1e02-5d92f9584b6e@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ea1c4d77-0712-b782-1e02-5d92f9584b6e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 10:36, michael.christie@oracle.com wrote:
> On 9/22/22 11:57 AM, Bart Van Assche wrote:
>> On 9/22/22 03:06, Mike Christie wrote:
>>> +static enum scsi_disposition scsi_prep_sense(struct scsi_cmnd *scmd,
>>> +                         struct scsi_sense_hdr *sshdr)
>>
>> How about choosing another name for this function? All other functions with "prep" in their name are called before a command is submitted while this function is called from the completion path.
> 
> I'll think of something. scsi_init_sense_processing or scsi_start_sense_processing?

Thanks - I like the second name a bit better than the first :-)

Bart.
