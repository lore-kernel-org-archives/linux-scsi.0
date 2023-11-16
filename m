Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E5DC197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 19:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjKPTfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 14:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjKPTfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 14:35:19 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF63D4D
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 11:35:15 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28396255b81so187463a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 11:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700163315; x=1700768115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f92jInGS1cb7E+/wQ4EV/gwaG10eV56GXZGZCz3Nqmk=;
        b=LEQAsFhYwzm9KcXUKjDczNfQjAInmuwSIJD3SCNDxxVgFnrrPVcczYJovQi+hJuQw/
         WEiKu7YC/8svdypzuWLU3VsbixrYGyng3z2aBrOjP8vLQ3vSGGAacSRqhmPyL/TMDy24
         oNuKxmn7qPVIOfLntIxwRi7LD+FLt/H5MUCjOdhDmrL6GFSFdEGgRaCCeuB5QJUDhpRK
         998LFtEX3zDAbu0b9odgpsrnQsirE60IabnWbNdHnHlpBl+5DyQKqeDP6mcN3QxmKTox
         2cm836LsNXvnKflCxzmFiaKie3GLClpRI00gU2UAIRr690nugqnK62LOhLgyBW1+ARbk
         cjfw==
X-Gm-Message-State: AOJu0YzRluIy/yNyw6lCKLobhLo0gJzhnT0VOrNlYAcEAOzTWC0FrNv+
        7nSEwbBkXb+wamQCPaYelVY=
X-Google-Smtp-Source: AGHT+IEe0H5B34cwFNqHKvmkX241pNrJ6qBmUO/J8nUQoI6QvT2OoVgBLKnp3IK+Qd6RoNyC+J4CJg==
X-Received: by 2002:a17:90b:3a8d:b0:281:3a0:f82a with SMTP id om13-20020a17090b3a8d00b0028103a0f82amr15771478pjb.9.1700163314630;
        Thu, 16 Nov 2023 11:35:14 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:b9d7:5844:d04b:7ef5? ([2620:0:1000:8411:b9d7:5844:d04b:7ef5])
        by smtp.gmail.com with ESMTPSA id mg6-20020a17090b370600b00280ccd5289dsm88266pjb.22.2023.11.16.11.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 11:35:13 -0800 (PST)
Message-ID: <247cfc2e-68cc-4db8-9f17-d9b3974846fe@acm.org>
Date:   Thu, 16 Nov 2023 11:35:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Add a precondition check in
 scsi_eh_scmd_add()
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231115193343.2262013-1-bvanassche@acm.org>
 <23e26659-5758-4c5c-a1d4-639edd29d496@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <23e26659-5758-4c5c-a1d4-639edd29d496@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/23 01:45, John Garry wrote:
> On 15/11/2023 19:33, Bart Van Assche wrote:
>> Calling scsi_eh_scmd_add() may cause the error handler never to be woken
>> up because this may result in shost->host_failed to become larger than
>> scsi_host_busy(shost). 
> 
> This is oddly worded. I think that you need to mention how calling
> scsi_eh_scmd_add() may lead to this scenario occurring.

This happened in development code that was never posted on any mailing list.
It took me a while to root-cause that issue. Hence this patch.

>> Hence complain if scsi_eh_scmd_add() is called
>> after SCMD_STATE_INFLIGHT has been cleared.
> 
> Now you hint that this mentioned scenario may occur if SCMD_STATE_INFLIGHT was cleared.
> 
> Can you provide some info on when scsi_eh_scmd_add() could be called for SCMD_STATE_INFLIGHT cleared? Or is it that you don't know how (it may occur), but it is fatal if it does and we should guard against or warn about it.

If anyone would add a call to scsi_eh_scmd_add() for a command for which
SCMD_STATE_INFLIGHT is not set.

>>       WARN_ON_ONCE(!shost->ehandler);
>> +    WARN_ON_ONCE(!test_bit(SCMD_STATE_INFLIGHT, &scmd->state));
> 
> What about if SCMD_STATE_COMPLETE is set - should we also warn about that?

Calls to scsi_eh_scmd_add() for commands for which SCMD_STATE_COMPLETE has
been set are much easier to find by reviewing the code than calls for commands
for which neither SCMD_STATE_COMPLETE nor SCMD_STATE_INFLIGHT have been set.

Thanks,

Bart.

