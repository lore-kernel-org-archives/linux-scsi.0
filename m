Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E6CC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 23:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7033C206C3
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 23:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rGS0vMc0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgIKXzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 19:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgIKXzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 19:55:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30017C061573
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 16:55:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y1so1325860pgk.8
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 16:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PGp8V7lA33thgq6wYZnzeTKKlPIxa0Z4DbQaofUeBx8=;
        b=rGS0vMc0ou/RnjA1lqNR57NVPXGvamMszOcKxVV9rwZuKR8lTR9JrhGc/v6HqW6tt/
         blNpvHwxeNSLV+3nZOW63g3/nHWLPNEAHMUrSEU54hG/XuLicgTKF1g+VkJKAQ+IIR4f
         TOX25aiNLxdhQLqzrs+++NFOWNjwqtNdecd8/GjWMbrqUYbtB47aWXd94rgPHHA+ANuz
         5N99vPgJKojvklAwZK9d8pajfOk5iDhv7MqkKO5mnXX99kvJX2Ad2iM+mwla1fSwc0gD
         H7fw2SaMRtTuOleVgSZa3F9i5XhOgC1LM83lmVipxpvuKYqLdL4ExdJ1fjnK9u8GyyGM
         gb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PGp8V7lA33thgq6wYZnzeTKKlPIxa0Z4DbQaofUeBx8=;
        b=LHiEejLoksfJhK8EYgFok5oPlBAlcBP6lJF+IWplAOfQfM3DOZcNSh25jhaaW6TRb+
         2zi96z/fqiYjSwviGWnV8pKoFqcEc/Rniz2qe5Zj0wAXTvD0a1hMzw1GyYaZpB4yPbsH
         XLZ+YDBAKKb3+zcFK5rt9JKdlDEMuai2x1S+UL7RnFZIYS1R0poH5BnYrcmxFQZdurB2
         DuCNN36FP+VTtUsSLDF06+4J33zZNTW7Vixhzn7bAuKaQB3nNfTZAQ24GtXMFO3M7o09
         y9LUXgOyMfF7RTdbS82rBCDSmvIVkZwo6EfHQ7zXqatXAoHx2vogzp+yX9A9e/5Z2xCb
         hhbA==
X-Gm-Message-State: AOAM532+2qiFgWD4aaAHQtk7WLXpPAcFzgvAnrxDO5sPAdu2z3oTTQVq
        MrjbhhG+3kdMepK+A/DGRsxI8aEkiG8=
X-Google-Smtp-Source: ABdhPJzl5SuZZJTAbbbROWv/cpfEjN6GkobfvwnCqrKv9bKSvGqTQrvROPIzNfjqyYB+g5WTbbx0Hg==
X-Received: by 2002:a63:1342:: with SMTP id 2mr3263587pgt.214.1599868499084;
        Fri, 11 Sep 2020 16:54:59 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 204sm3179246pfc.200.2020.09.11.16.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 16:54:58 -0700 (PDT)
Subject: Re: lockdep warning in lpfc v5.9-rc4
From:   James Smart <jsmart2021@gmail.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org
References: <20200911083415.4k2rjgwbevkdkxis@beryllium.lan>
 <9e25d9ee-bcc2-3389-3d13-61aa94838c54@gmail.com>
Message-ID: <8ae6976c-76bb-547c-662d-b0c49ae001b5@gmail.com>
Date:   Fri, 11 Sep 2020 16:54:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <9e25d9ee-bcc2-3389-3d13-61aa94838c54@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/2020 3:49 PM, James Smart wrote:
> On 9/11/2020 1:34 AM, Daniel Wagner wrote:
>> Hi,
>>
>> I just hit a lockdep warning in lpfc. Not sure if it is a valid complain
>> or not:
>>
>>   ================================
>>   WARNING: inconsistent lock state
>>   5.9.0-rc4-default #80 Tainted: G            E
>>   --------------------------------
>>   inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
>>   kworker/2:2/264 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>   ffff9a726e7cd668 (&lpfc_ncmd->buf_lock){+.?.}-{2:2}, at: 
>> lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
>>   {IN-SOFTIRQ-W} state was registered at:
>>     lock_acquire+0xb2/0x3a0
>>     _raw_spin_lock+0x30/0x70
>>     lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
>>     lpfc_sli4_fp_handle_fcp_wcqe.isra.29+0xfb/0x390 [lpfc]
>>     lpfc_sli4_fp_handle_cqe+0x172/0x490 [lpfc]
>>     __lpfc_sli4_process_cq+0xfd/0x270 [lpfc]
>>     __lpfc_sli4_hba_process_cq+0x3c/0x110 [lpfc]
>>     lpfc_cq_poll_hdler+0x16/0x20 [lpfc]
>>     irq_poll_softirq+0x96/0x150
>>     __do_softirq+0xd3/0x47b
>>     asm_call_on_stack+0x12/0x20
>>     do_softirq_own_stack+0x52/0x60
>>     irq_exit_rcu+0xea/0xf0
>>     common_interrupt+0xa9/0x1a0
>>     asm_common_interrupt+0x1e/0x40
>>     refresh_cpu_vm_stats+0x20c/0x2a0
>>     vmstat_update+0xf/0x50
>>     process_one_work+0x2b7/0x640
>>     worker_thread+0x39/0x3f0
>>     kthread+0x139/0x150
>>     ret_from_fork+0x22/0x30
>>   irq event stamp: 2621
>>   hardirqs last  enabled at (2621): [<ffffffff91ff525d>] 
>> _raw_spin_unlock_irqrestore+0x2d/0x50
>>   hardirqs last disabled at (2620): [<ffffffff91ff5a38>] 
>> _raw_spin_lock_irqsave+0x88/0x8a
>>   softirqs last  enabled at (1420): [<ffffffff92200351>] 
>> __do_softirq+0x351/0x47b
>>   softirqs last disabled at (1399): [<ffffffff92001032>] 
>> asm_call_on_stack+0x12/0x20
>>     other info that might help us debug this:
>>    Possible unsafe locking scenario:
>>            CPU0
>>          ----
>>     lock(&lpfc_ncmd->buf_lock);
>>     <Interrupt>
>>       lock(&lpfc_ncmd->buf_lock);
>>      *** DEADLOCK ***
>>     2 locks held by kworker/2:2/264:
>>    #0: ffff9a727ccd2d48 ((wq_completion)lpfc_wq#4){+.+.}-{0:0}, at: 
>> process_one_work+0x237/0x640
>>    #1: ffffb73dc0d37e68 
>> ((work_completion)(&queue->irqwork)){+.+.}-{0:0}, at: 
>> process_one_work+0x237/0x640
>>     stack backtrace:
>>   CPU: 2 PID: 264 Comm: kworker/2:2 Tainted: G            E 
>> 5.9.0-rc4-default #80
>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
>> rel-1.12.0-0-ga698c89-rebuilt.suse.com 04/01/2014
>>   Workqueue: lpfc_wq lpfc_sli4_hba_process_cq [lpfc]
>>   Call Trace:
>>    dump_stack+0x8d/0xbb
>>    mark_lock+0x5e5/0x690
>>    ? print_shortest_lock_dependencies+0x180/0x180
>>    __lock_acquire+0x2d5/0xbf0
>>    lock_acquire+0xb2/0x3a0
>>    ? lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
>>    ? lock_acquire+0xb2/0x3a0
>>    _raw_spin_lock+0x30/0x70
>>    ? lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
>>    lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
>>    lpfc_sli4_fp_handle_fcp_wcqe.isra.29+0xfb/0x390 [lpfc]
>>    ? ret_from_fork+0x22/0x30
>>    ? unwind_next_frame+0x1fc/0x640
>>    ? create_prof_cpu_mask+0x20/0x20
>>    ? arch_stack_walk+0x8f/0xf0
>>    ? ret_from_fork+0x22/0x30
>>    ? lpfc_handle_fcp_err+0xb00/0xb00 [lpfc]
>>    ? lpfc_sli4_fp_handle_cqe+0x172/0x490 [lpfc]
>>    lpfc_sli4_fp_handle_cqe+0x172/0x490 [lpfc]
>>    __lpfc_sli4_process_cq+0xfd/0x270 [lpfc]
>>    ? lpfc_sli4_sp_handle_abort_xri_wcqe.isra.54+0x170/0x170 [lpfc]
>>    __lpfc_sli4_hba_process_cq+0x3c/0x110 [lpfc]
>>    process_one_work+0x2b7/0x640
>>    ? find_held_lock+0x34/0xa0
>>    ? process_one_work+0x640/0x640
>>    worker_thread+0x39/0x3f0
>>    ? process_one_work+0x640/0x640
>>    kthread+0x139/0x150
>>    ? kthread_park+0x90/0x90
>>    ret_from_fork+0x22/0x30
>>
>>
>> Thanks,
>> Daniel
>>
>
> It's likely valid, but rare. Most of the time, only one of these 2 
> flows are occuring. We'll look into it.
>
> -- james

Looking a little futher - it doesn't look like this can be hit. Although 
both the softirq and work element could be running, both call the same 
routine and only 1 callee will succeed in a cmpxchg() for the queue. As  
such, only one entity will process the queue and there would not be a 
way for both to be looking at the same io completion.

-- james

