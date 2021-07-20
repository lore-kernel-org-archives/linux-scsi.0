Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC4BC64995
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 16:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 280826100C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jul 2021 16:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhGTPba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:31:30 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:42698 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239738AbhGTPVO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2021 11:21:14 -0400
Received: by mail-pj1-f45.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so2708072pju.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2021 09:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=46C4IWqrWyR5qyJte4yy/LNABCP3MNuxTfw+EkoTt0A=;
        b=PMk7vWyrcfc4ijwQ6pz/KwM7oyXLAbI8n6MESzZICaVMBcN0A1WAsu8XmQ7DoVA5Ln
         Ps4o/deRrCKa7ZxYPifhng9XRScz/hMST3ixGt+NoPbNxLBSYiZhjv/ez0qWCGFQh5PW
         hxd7HpkBTg2+6JSM3XVAI59Lkr2xemVmFEtO213EFw09RzYR3ycRMzVVTk4H9SRPZjDD
         oldpIBUgomX6cazUhYMWxyveSlABPTl3yKKgqN/9ODcgAf6ldfwHAblMzQPHwWvfFn78
         jRgjDIsPO1FkDmxuFIgKapf2hBoZcDfNUmdsIcrjB8MPtAspzMvvdO1O/EsnmC2oQpV2
         cxCQ==
X-Gm-Message-State: AOAM532QqQG2zAtkQsLIbvaWeHF9uDIGAl1/gS5omsYkF+EmVC4+HZyk
        vEtYW5VvoWkapbxaSs8+dL4=
X-Google-Smtp-Source: ABdhPJxEEJTPH4kGqcSL/bhsdjVj38DlFEKWBO7jQvTBfmDL/AMiPzTCpCwiaAbS0POlzrssoJ9xuQ==
X-Received: by 2002:a17:90b:190:: with SMTP id t16mr7092520pjs.221.1626796909879;
        Tue, 20 Jul 2021 09:01:49 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9fa9:39d2:8b59:76ce? ([2601:647:4000:d7:9fa9:39d2:8b59:76ce])
        by smtp.gmail.com with ESMTPSA id ie13sm3208891pjb.45.2021.07.20.09.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 09:01:49 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210719231127.869088-1-bvanassche@acm.org>
 <DM6PR04MB657554CAD101CEC0FB71E68BFCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a5d3b7f8-0916-742f-4763-65b313e2dac3@acm.org>
Date:   Tue, 20 Jul 2021 09:01:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB657554CAD101CEC0FB71E68BFCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/21 11:45 PM, Avri Altman wrote:
>> If param_offset > buff_len then the memcpy() statement in
>> ufshcd_read_desc_param() corrupts memory since it copies
>> 256 + buff_len - param_offset bytes into a buffer with size buff_len.
>> Since param_offset < 256 this results in writing past the bound of the output
>> buffer.
>
> param_offset >= buff_len is tested in line 3381?

Hi Avri,

That's correct. However, a few lines lower there is the following code:

ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
				desc_id, desc_index, 0,
				desc_buf, &buff_len);

That call may modify (reduce) 'buff_len'. Hence, a second check is needed.

Thanks,

Bart.
