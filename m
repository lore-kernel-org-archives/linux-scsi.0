Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2A4C35E04
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 19:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85D3B2084E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 19:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgBYTkf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:40:35 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54643 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgBYTkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2020 14:40:35 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so153866pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2020 11:40:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lx4f6GGIACCeSV57ZWmO3DYEXTsQr0JtnbN+rxvEido=;
        b=YCUrorkW/id0JZHJ49hjXnLyeMUW4ruk5Wg+ev1mYU/w6m8imNkIk7WzAzjSFF5SJf
         jFke9c5v7T6tddi+rje8MCvx1rQzmSnfVRlyi/KJnNV0FUYwnpsZCbCQiLfYUdeVZ9Q4
         y6YCngQRxnk0QzYlzDbwSsR5kO+pEEJQPEntcYJFuIqdcCSo33aVrmWS3CH2Hd+KaIPK
         3wNKxJ/5Lo10rS8o83qE4WVCuxYdL1ZNEsIuYaT/G72xX2pwg7bO9s14EEwINJve9iIL
         H/+EJLKHbajk6VX9o87eX4iEv7JJqVcXXj+oUTHo5GtiXjL9PpgKvVk8X8I8lCyb+eRs
         l4VA==
X-Gm-Message-State: APjAAAW8MAWz26KmXIrC+g7GKY6ooq7vCDVuNxyviCrPXcMjEmXBrnEu
        dxN5iaE0g+f+3yr7tGkQ6Cw=
X-Google-Smtp-Source: APXvYqwwHOvM18eLPABTRHqy2bRxtHaLQf5jipfbnn9f4Z6LBKwuUFCGh96Y7ar8QOEz4c3H2Bw76A==
X-Received: by 2002:a17:90a:3603:: with SMTP id s3mr660793pjb.61.1582659634178;
        Tue, 25 Feb 2020 11:40:34 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id ci5sm4179849pjb.5.2020.02.25.11.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 11:40:33 -0800 (PST)
Subject: Re: [PATCH v2 6/6] qla2xxx: Fix the endianness annotations for the
 port attribute max_frame_size member
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-7-bvanassche@acm.org>
 <20200225184351.yoxxziqq6mwxyycz@SPB-NB-133.local>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <111704b6-3a9d-b7a7-2f5c-7b7a0728659b@acm.org>
Date:   Tue, 25 Feb 2020 11:40:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225184351.yoxxziqq6mwxyycz@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/20 10:43 AM, Roman Bolshakov wrote:
> I'm not an expert of FDMI feature but it seems to introduce an
> inconsistency with regards to structure definition. IMO, All multi-byte
> binary fields and bitmasks in RPA request should be made __be32 rather
> than only one. Probably that should go into one patch series where all
> fields in the structure are fixed patch-by-patch or one patch that fixes
> all fields at once (the latter is harder to review though).

Hi Roman,

I agree with what you wrote. I have a (huge) patch pending that fixes 
all endianness issues in the qla2xxx driver. I plan to post that patch 
after agreement has been achieved about this patch series.

Thanks,

Bart.

