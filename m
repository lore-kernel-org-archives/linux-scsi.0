Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56535C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 22:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D8060FC3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 22:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243422AbhJOXAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 19:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243393AbhJOXAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 19:00:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FE3C061570;
        Fri, 15 Oct 2021 15:57:57 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y4so7312402plb.0;
        Fri, 15 Oct 2021 15:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hgvK29WL+pvpN0yEVZsVdwSfijkxOwSkGHIbnUFY7u4=;
        b=Z/vykFjzOvSxapnRki6GjQS7FXkLOPk/rFsHc2GD+RQ8a2S9IAMVTBmxxlKmYDSEKB
         5ZR3mfVdDW5TCdYetmdl0EKV7wuE0GwEmvypNqZZ5yqzaOfrPlbs1q04cgiLXWSAChAW
         UjtGfjgV9Zr6dAVCld0NHjXzMpo5ifavD2D585itudCGjLCdeix4lIJVLb74bEAgxrrt
         2WHbOold7CCvjdsE9dENYm8jcJasHc6wNqPOVq1KdA1z7c0sUcN1VVT7YRkzTcN1Vl0j
         JC+SYwKt3ZJNX1EgiNdFSk5C6AHz8AH3dn5teUw6lqGSj/1FckD2V3Q9QacH39HwGjgr
         sJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hgvK29WL+pvpN0yEVZsVdwSfijkxOwSkGHIbnUFY7u4=;
        b=5eJLK9ADgswzyxTE4kXkUdrHKS6BNSaKJmDsI9NMvQ3x7IYPMhev4xmBQLvYsgKVVo
         q0n8YgrclPVKG+OdiEWkj94tmanvob1GyHfVdiS/RZnI2moHpo4nLEaHAxwBvoex/Bpu
         aG+c6OrtYeL2YD/1lyym2SS2fDovec4JDt70t2mpmd2Y6RhoR2Gt8FlCbrcho0b3pQ2Y
         88KUBC0q/Ulu5+YoTJ+hakG9COMBYSbGwD28Z3E3KcMnWB9dGkVCAfjZNv2ny2w8xOOZ
         7hS3ELJApl6XTS+EvTQCLL9IXUgFZcnW8AGw+9HezwJ7Y2j0I8+aCVroDgEqGP/W6pew
         kR0A==
X-Gm-Message-State: AOAM532IoHDd5R612Hxf2EhPlNMys4nGbtSUNdBoC4Cd7Ki4WrScu54E
        PcLcPoS4BP2n5CZEqRSFN7A=
X-Google-Smtp-Source: ABdhPJw3WDw5x15bLS8EH+FhmVq1yo3I4NQCS3AOiT09IG7bA6PSaGqwYiaC0H5TS5QzPP5NQi8iNg==
X-Received: by 2002:a17:90a:d801:: with SMTP id a1mr30605776pjv.109.1634338677088;
        Fri, 15 Oct 2021 15:57:57 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w125sm5806038pfc.66.2021.10.15.15.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 15:57:56 -0700 (PDT)
Message-ID: <7a721ee3-2a71-ffda-a818-796ebc81d288@gmail.com>
Date:   Fri, 15 Oct 2021 15:57:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: lpfc: Fix the misuse of the logging function
Content-Language: en-US
To:     Zheyu Ma <zheyuma97@gmail.com>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1634279621-27115-1-git-send-email-zheyuma97@gmail.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <1634279621-27115-1-git-send-email-zheyuma97@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/2021 11:33 PM, Zheyu Ma wrote:
> When the driver fails in lpfc_enable_pci_dev(), it will call
> lpfc_printf_log(), and in a certain case the lpfc_dmp_dbg() is
> eventually called, this function uses 'phba->port_list_lock', and at
> this time this lock is not been initialized, which may cause a bug.
> 
> Fix this by using 'dev_printk' to replace the previous function.
> 
> The following log reveals it:
> 
> [   32.955597  ] INFO: trying to register non-static key.
> [   32.956002  ] The code is fine but needs lockdep annotation, or maybe
> [   32.956491  ] you didn't initialize this object before use?
> [   32.956916  ] turning off the locking correctness validator.
> [   32.958801  ] Call Trace:
> [   32.958994  ]  dump_stack_lvl+0xa8/0xd1
> [   32.959286  ]  dump_stack+0x15/0x17
> [   32.959547  ]  assign_lock_key+0x212/0x220
> [   32.959853  ]  ? SOFTIRQ_verbose+0x10/0x10
> [   32.960158  ]  ? lock_is_held_type+0xd6/0x130
> [   32.960483  ]  register_lock_class+0x126/0x790
> [   32.960815  ]  ? rcu_read_lock_sched_held+0x33/0x70
> [   32.961233  ]  __lock_acquire+0xe9/0x1e20
> [   32.961565  ]  ? delete_node+0x71e/0x790
> [   32.961859  ]  ? __this_cpu_preempt_check+0x13/0x20
> [   32.962220  ]  ? lock_is_held_type+0xd6/0x130
> [   32.962545  ]  lock_acquire+0x244/0x490
> [   32.962831  ]  ? lpfc_dmp_dbg+0x65/0x600 [lpfc]
> [   32.963241  ]  ? __kasan_check_write+0x14/0x20
> [   32.963572  ]  ? read_lock_is_recursive+0x20/0x20
> [   32.963921  ]  ? __this_cpu_preempt_check+0x13/0x20
> [   32.964284  ]  ? lpfc_dmp_dbg+0x65/0x600 [lpfc]
> [   32.964685  ]  ? _raw_spin_lock_irqsave+0x29/0x70
> [   32.965086  ]  ? __kasan_check_read+0x11/0x20
> [   32.965410  ]  ? trace_irq_disable_rcuidle+0x85/0x170
> [   32.965787  ]  _raw_spin_lock_irqsave+0x4e/0x70
> [   32.966124  ]  ? lpfc_dmp_dbg+0x65/0x600 [lpfc]
> [   32.966526  ]  lpfc_dmp_dbg+0x65/0x600 [lpfc]
> [   32.966913  ]  ? lockdep_init_map_type+0x162/0x710
> [   32.967269  ]  ? error_prone+0x25/0x30 [lpfc]
> [   32.967657  ]  lpfc_enable_pci_dev+0x157/0x250 [lpfc]
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Zheyu,

Thank you for the time and effort on this. Your points are all valid. 
However, we'd like to correct this using a slightly different method. 
We will post a different patch shortly for the issue.

-- james
