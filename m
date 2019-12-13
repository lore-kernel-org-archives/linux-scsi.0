Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C1FC4D2E2
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D0124815
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 20:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfLMUFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:05:30 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:42701 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbfLMUFa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2019 15:05:30 -0500
Received: by mail-pj1-f66.google.com with SMTP id o11so167420pjp.9;
        Fri, 13 Dec 2019 12:05:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q6nTWJovcUs20rNjwQbvmvjiujOLC8p/4wdrf5F20gI=;
        b=EajW3C4mj357gmvgubXqdUalX07Wj93y7M0bel4C8aco50iX5ah1l3jwfEUbB8RvLd
         7LAIsrjIHjqrMMGesIe8VItflto/IK9rF+G1zsGiFyLlsINAHlVM+LLMPgZ2mBucCtFY
         t9WpEI5nMSZ+kOX0dpaeCX60e7z0XEHembcmcPThzyw2AqZyvz0DsOPzKorvxbwVrcnW
         Zjqg4GDmpjWYNU6ruIpWFHecffYp8Q5MmA9ZwqVYB+3IRZe59RnxqRScAesqufD7WdrP
         hAn7W6nloTzWv023oZlUlKt9+6VtdaMDIxn8cQc75mDQSdeFTHDUMf0eNKFer51NnxA6
         XHWw==
X-Gm-Message-State: APjAAAVrMCde3ejouyfSw9ZobgFZUIQ5ZrGtwfNRqJN0phiABPB/nDW6
        Dpbf/JiO1SzPgwb12flH6shRUu9q
X-Google-Smtp-Source: APXvYqzi/mGcCSwnApHnScndJoGpE3yjogqSSJvf/CLwzYIsTBXxgelBYtiemetuAJXhLkzKgfHnZg==
X-Received: by 2002:a17:902:5a04:: with SMTP id q4mr1236380pli.302.1576267529145;
        Fri, 13 Dec 2019 12:05:29 -0800 (PST)
Received: from [172.19.248.113] ([38.98.37.141])
        by smtp.gmail.com with ESMTPSA id e6sm12594667pfh.32.2019.12.13.12.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 12:05:27 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: ufs: Unlock on a couple error paths
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191213104828.7i64cpoof26rc4fw@kili.mountain>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <70d90cda-afe7-30bd-c871-c9d37bee98aa@acm.org>
Date:   Fri, 13 Dec 2019 13:04:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213104828.7i64cpoof26rc4fw@kili.mountain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/19 5:48 AM, Dan Carpenter wrote:
> We introduced a few new error paths, but we can't return directly, we
> first have to unlock "hba->clk_scaling_lock" first.

This may have escaped from my attention due to having swapped the order 
of the patch that removed that locking and the patch this patch is a fix 
for. Anyway, thanks for this patch.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
