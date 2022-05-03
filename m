Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BC8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiECQ1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbiECQ1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:27:08 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3403CA7B
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:23:23 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id a191so1825847pge.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 09:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W3xeUrb5YMMI+GIW7qEbQ5jReKchbY1U88ZPaBwW7ME=;
        b=QTDwLkoYlVarpipmHMEc3aU4dl4AsYAQy+US2qtxOmceQllH/b4UQj4SaTO4Ch6l9R
         BeGZAce8C+mlMLVX5xiELb0nh81JDxGq/42awFIV/sXnQeMbJ3th1KYJNdHi/NIQ7HC0
         3tWNgJgPv5AaCf4Gl6lPJi9EoGqI4v5i/EcOuv3I8jDlsYtqA4c7yrWZ+FEksGCjhjsI
         W2fh+jCszDhTTfkMfWW9bmOjwpnS8b99nb29VvCCMIxDz+lMTkh/tqndxDETseERuXCG
         R9zU3Zdx1LG6mPsThrvBnqtjUGYiTOpNH1dFcme5C21miAHB2Jz6knqx1pZC1RwXrMbS
         GSdw==
X-Gm-Message-State: AOAM532XD2LDuHB/1lzcg7CMFoJeUBliIMRPPrqmMgSQ29pBohpZ5qYe
        TNKZvPOGZdt1nHVxwxV2odk=
X-Google-Smtp-Source: ABdhPJzryz33XJ8HaR9jbsWDLD0d278jMO2dmzD5F5BIBZHknTn4WpKJ7cy5TNhpR40CbV5zYOWXrA==
X-Received: by 2002:a63:5d60:0:b0:3a9:ef9f:eac2 with SMTP id o32-20020a635d60000000b003a9ef9feac2mr14387065pgm.553.1651595003424;
        Tue, 03 May 2022 09:23:23 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id s22-20020aa78296000000b0050dc76281b5sm6749000pfm.143.2022.05.03.09.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:23:22 -0700 (PDT)
Message-ID: <245a26dc-3e09-e460-d8dd-5634246ed6d5@acm.org>
Date:   Tue, 3 May 2022 09:23:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 01/11] pmcraid: Select device in
 pmcraid_eh_bus_reset_handler()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502215416.5351-1-hare@suse.de>
 <20220502215416.5351-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220502215416.5351-2-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:54, Hannes Reinecke wrote:
> The reset code requires a device to be selected, but we shouldn't
                                                        ^^^^^^^^^^^^
> rely on the command to provide a device for us. So select the first
> device on the bus when sending down a bus reset.
Why is it that we shouldn't rely on the SCSI EH to provide a device? I 
think this should be explained in the commit message.

Thanks,

Bart.
