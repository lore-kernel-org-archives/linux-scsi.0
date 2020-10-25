Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7589EC2D0A3
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 00:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5C222281
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 00:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763076AbgJYAZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Oct 2020 20:25:21 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41286 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763073AbgJYAZU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Oct 2020 20:25:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id w11so2887194pll.8;
        Sat, 24 Oct 2020 17:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PO+THV4TS79PQTIxnHf/bm4WKDnSkSebwXEEUdOUSuE=;
        b=sQMiXlgQZlbE7uiUlVWXC1BgFpGTOJBe2Xj/dSULMngH2Jzo7kyBGe0GzM32Znu3lx
         aFttVKp1OouK9jY/5DS9yAFTX4aDoW0PTPqipjbeVN0tXUEpwAflBjRKGf9d2JgnePMd
         QZqmvZrglHdD/2WmEOiOUYFa5A11itP9s5oqOxOxWKgnXmMllD/2s+pR7Z9xRcf5pNQ1
         P/OusukZBSOjvjL6A5RwJJGpte0VvdFX6NokRHOKXIynlsh0thjh4+0H98d5vZOJ+s3V
         eqGJLiovJkKijxI57xpx4oteIRi+AjCd9Co7WDv8E/r1MJlDQyqFd0MIU5P4ZBkT/ror
         3U9Q==
X-Gm-Message-State: AOAM5309gBfGQj4nXS/nAXNeo0rd+AElyr8Sf/5E3QAbup0S39/sJNVm
        vEtSyiNKS6G9GKxPOmRRYqcwKu/R8PhxPw==
X-Google-Smtp-Source: ABdhPJzmYwMHhnAogfEhnmlsfF10TRVzM4AlYIcxeG7KwETjs18mBPZkHedu+ueMbbrKNgRLAXAwag==
X-Received: by 2002:a17:902:8c8b:b029:d2:42fe:370a with SMTP id t11-20020a1709028c8bb02900d242fe370amr5443628plo.83.1603585519890;
        Sat, 24 Oct 2020 17:25:19 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u4sm7632892pjy.19.2020.10.24.17.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 17:25:18 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
Date:   Sat, 24 Oct 2020 17:25:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201024121315.GA35317@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/20 5:13 AM, Roman Bolshakov wrote:
> iSCSI doesn't specify a specific code but mentions a possibility of CHECK
> CONDITION for residuals (11.4.5.1.  Field Semantics):
> 
>   Targets may set the residual count, and initiators may use it when the
>   response code is Command Completed at Target (even if the status
>   returned is not GOOD).

My interpretation of the above text is that it neither allows nor
requires to change the status GOOD into something else if there is a
residue.

>> Additionally, what benefits does it provide to report a CHECK CONDITION
>> upon residual overflow?
> 
> Typical use case for CHECK CONDITION in case of Underflow/Overflow is
> extra robustness against buggy initiators [1][2]. Failing both READ and
> WRITE is the most solid approach in that sense [3][4][5] as it prevents
> data corruption at all costs.
> 
> Suppose an initiator wants to WRITE 8 LBA. For 512-byte formatted LUN,
> 8 LBAs need a buffer of 4K bytes. For 4096-byte formatted LUN the
> command would need 32K data buffer.
> 
> An Overflow happens if initiator treats 4Kn device like 512n one but
> provides a buffer of 4K. i.e. to complete the WRITE target needs to
> consume 28K more data, otherwise only 1 LBA would be written and the
> rest 7 LBAs would have indeterminate content.
> 
> An Underflow happens if initiator confuses 512n device with 4Kn one and
> provides a buffer of 32K, i.e. target doesn't utilize all buffer for the
> command.

Thanks for the additional background information, this really helps. How
about only rejecting SCSI commands for which the data buffer size is not
a multiple of the block size? I'm concerned that flagging all SCSI
commands that have a residue as invalid will break SCSI tape software.

Thanks,

Bart.
