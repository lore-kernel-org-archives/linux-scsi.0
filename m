Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24D4C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbiBIST6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238768AbiBISTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:19:46 -0500
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A287C03FEFB
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:19:04 -0800 (PST)
Received: by mail-pf1-f176.google.com with SMTP id y8so2981027pfa.11
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:19:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/ErX0knGqs5hn+npPWBiZ6BYP/UNovVl3QWn36OQy3c=;
        b=It3rkQjzOwDt43ljfGQOtnFteskGZeFLw0y4IFMxmy5PMRIaQtXHGwv6c59jpZTe9P
         uGpyVd8MCrH0QiEqp0B22lzwhRZ8rlV6/xYVxYKksu8D0Gaf5O7Fll4oj0ZHTYNEzG9r
         ZBk3Y8JVlOmDtVWVGfXHkABV7zpR7JadricPk/rW8QhfVRR7UThRqcH9eHi4acwqN+75
         88qGDcD69CVxRt2DKWW0uyuG+CrPNG1PUuHvThhoKxVcw49utfNyYs2a78voaJb+enGK
         flyOUE+EBUf/SOfTuWLULWIUXi1bK/aD548yD2KKvu5MHTYnu5cAQRgp/erHF+U07wCR
         sJDA==
X-Gm-Message-State: AOAM531EzmTw6F4YtN07DtdjSmDsqzDIHd0x9TRWwEdPeSFbZZ5eXsTs
        mxAX4BZQxamL8JzFXfDH6oI=
X-Google-Smtp-Source: ABdhPJyIyxaPAJGykTWhyFHD0pjL4Wl1LM4ufs+ykORl0a4nwsNg1BAwPW25XuZ6uW4DegTUJ2178A==
X-Received: by 2002:a63:2c4e:: with SMTP id s75mr2817666pgs.497.1644430743342;
        Wed, 09 Feb 2022 10:19:03 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id z17sm14133008pgf.91.2022.02.09.10.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:19:02 -0800 (PST)
Message-ID: <69a9c6be-169e-0a20-3a92-06a1ba3cfc95@acm.org>
Date:   Wed, 9 Feb 2022 10:19:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 13/44] bfa: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-14-bvanassche@acm.org>
 <7c9c006c-4bdd-7412-947a-05114eac14fc@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7c9c006c-4bdd-7412-947a-05114eac14fc@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 23:40, Hannes Reinecke wrote:
> When moving SCSI pointer usage into the command payload, have you 
> considered dropping the use of the 'host_scribble' pointer, too?
> As we already allocated a command payload it should be easy to increase 
> it by another pointer, and move the 'host_scribble' stuff in there.
> Hmm?

I agree that the 'host_scribble' pointer is no longer essential since 
the introduction of the .cmd_size field in the host template and also 
that the host_scribble pointer can be moved into private command data. I 
have not done that in this patch series because I think this patch 
series is already bigger than it should.

Thanks,

Bart.
