Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32D3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E13611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhIVQct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:32:49 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46970 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhIVQct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 12:32:49 -0400
Received: by mail-pf1-f175.google.com with SMTP id 203so3131047pfy.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Sep 2021 09:31:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nw8TE4ZnhetIn/KqB2kFfjx4GgteLJRkp2owQt22a6g=;
        b=RhKon3bjDsfLwKXHmzIe+oAdbTH7RFYJSYuMkT8OsNd97KMy6W8kiLCOF76r2s+TDT
         oOAbecSCfHMDf73gV4tyVzZYeTI5KCzSCosqU1GN79wTSi8yE4XDkzFzm/HgDVdoCZx9
         I/hvwNGUD8B9JEFd9+6q1gdL1KBYx1gOrmNFM5qVmuFWfA47YS9pqytuQa9gpfVPkdCJ
         PAiAPO9c6XTImrtgS4xH4GuN1U/6FRoBb23TisyeW+qszKk4qREekQ88HRogKIBxdLZJ
         yIJvzjGHS3es11XV/VRK8+3q6I10nN3z3xs69MnTqMcbQ4Avo4IdF5L9zQmCT+Hfnq3j
         lcTQ==
X-Gm-Message-State: AOAM531+9T9mH1dTMux38/ybzrhAk3s8dVkAB3W+ELXbtikei+3aGIxH
        0/rH4IrLqKa7ZFKw63U9pkM=
X-Google-Smtp-Source: ABdhPJz8lCSxlpU2gTWtsb95Af8efpQtmsR2tHhV+IQube6i5js9MAmxEavCcn5UYksnXaHwSu/1Lg==
X-Received: by 2002:a62:19d4:0:b0:43d:1bb7:13ae with SMTP id 203-20020a6219d4000000b0043d1bb713aemr463450pfz.63.1632328278499;
        Wed, 22 Sep 2021 09:31:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3b9:da7d:f0c0:c71c])
        by smtp.gmail.com with ESMTPSA id g3sm3604098pgf.1.2021.09.22.09.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 09:31:17 -0700 (PDT)
Subject: Re: [PATCH 80/84] staging: rts5208: Call scsi_done() directly
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        20210918000607.450448-1-bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210921173436.3533078-1-bvanassche@acm.org>
 <20210921173436.3533078-2-bvanassche@acm.org> <YUrNok3NhgRygKbn@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <42ee3c28-6d6f-828f-2ab3-693ac6cedfae@acm.org>
Date:   Wed, 22 Sep 2021 09:31:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YUrNok3NhgRygKbn@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/21/21 11:30 PM, Greg Kroah-Hartman wrote:
> I do not see the whole thread of this series on any mailing list (or
> lore.kernel.org), so I do not know if you are wanting these to go
> through the individual subsystem trees, or if they have to go through
> the scsi tree as one large series due to dependancies.

Hi Greg,

Apparently the email service I'm using (gmail) does not support patch series
with more than 78 patches. These six patches are my (failed) attempt to amend
the remaining patches to the original patch series. Anyway, the entire patch
series is available here:

https://lore.kernel.org/linux-scsi/20210918000607.450448-1-bvanassche@acm.org/

Patch 84/84 depends on the previous patches in that series. Hence my request
for Martin to queue this series via the SCSI tree.

Thanks,

Bart.
