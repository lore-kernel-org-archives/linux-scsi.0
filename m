Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44605C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21BF32178F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfKGR7D convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 12:59:03 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33677 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730216AbfKGR7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 12:59:03 -0500
Received: by mail-pf1-f194.google.com with SMTP id c184so3095607pfb.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 09:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ckE9CM000r0tKry0dfgn9Li7p57O9xZooASjwzc5j9c=;
        b=YVtnlD1XH0ivhQhlop2C9NCJgNObAXyFroy3lQJja3TmngxGnCt/QL0dasXqQBLjxo
         Ch9Y7/5JLjfwt5+E01KlNFnF0mNW0++fm8mh3yosa1IcdcHt31m+r7D8DSaHn7ywNop+
         8o4tJl0QBwu9mZbCglZIJ4NS85yYRt2mMrIJf4evdfW++Mne3IrlsD939ZUxXk63hVIh
         6bhiA2VC9opmm7OKAi7fxoOzgDbtzgs48342abWT9QeUs5U8EQTvTI33oZkTaf3AM/If
         79F4tgr2vFCnCs0TiYgheduUt9xXlvQ/DlNp99WgVUUZT3TZytV0JyzsEZQ/B8nfYzGJ
         jDOw==
X-Gm-Message-State: APjAAAV6z4sevjM3HR8lQgJB+hKmlqUU35k2HoDh6xVH3X5LN3tg/C+U
        4KhlsdJiSg1f882ExrrOZRBZJDji
X-Google-Smtp-Source: APXvYqwyPLYmkCKI4hh2DJerPfhKjTKLAZSfh94xCJXVJduwilVVfMPJlAHnQsta9pdaT1uK6JvLmQ==
X-Received: by 2002:a65:66c7:: with SMTP id c7mr5836989pgw.407.1573149540899;
        Thu, 07 Nov 2019 09:59:00 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id m68sm3206532pfb.122.2019.11.07.09.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 09:59:00 -0800 (PST)
Subject: Re: [PATCH 4/8] qla2xxx: Fix driver unload hang
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     "<James.Bottomley@hansenpartnership.com>" 
        <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20191105150657.8092-1-hmadhani@marvell.com>
 <20191105150657.8092-5-hmadhani@marvell.com>
 <f4c6df6c-f1b1-d465-dc41-dc8e63df56e2@acm.org>
 <83CC0DDF-4907-41A2-91EC-1569A07A6BA9@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <10b38f34-128a-fd71-1542-9025dc107f62@acm.org>
Date:   Thu, 7 Nov 2019 09:58:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <83CC0DDF-4907-41A2-91EC-1569A07A6BA9@marvell.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 9:55 AM, Himanshu Madhani wrote:
> 
> 
>> On Nov 7, 2019, at 10:54 AM, Bart Van Assche <bvanassche@acm.org
>> <mailto:bvanassche@acm.org>> wrote:
>>
>> On 11/5/19 7:06 AM, Himanshu Madhani wrote:
>>> From: Quinn Tran <qutran@marvell.com <mailto:qutran@marvell.com>>
>>> This patch fixes driver unload hang by removing msleep()
>>> Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair
>>> functionality.")
>>> Cc: stable@vger.kernel.org <mailto:stable@vger.kernel.org>
>>> Signed-off-by: Quinn Tran <qutran@marvell.com
>>> <mailto:qutran@marvell.com>>
>>> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com
>>> <mailto:hmadhani@marvell.com>>
>>> ---
>>>  drivers/scsi/qla2xxx/qla_init.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>> diff --git a/drivers/scsi/qla2xxx/qla_init.c
>>> b/drivers/scsi/qla2xxx/qla_init.c
>>> index bddb26baedd2..ff4528702b4e 100644
>>> --- a/drivers/scsi/qla2xxx/qla_init.c
>>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>>> @@ -9009,8 +9009,6 @@ int qla2xxx_delete_qpair(struct scsi_qla_host
>>> *vha, struct qla_qpair *qpair)
>>>  struct qla_hw_data *ha = qpair->hw;
>>>    qpair->delete_in_progress = 1;
>>> -while (atomic_read(&qpair->ref_count))
>>> -msleep(500);
>>>    ret = qla25xx_delete_req_que(vha, qpair->req);
>>>  if (ret != QLA_SUCCESS)
>>
>> I think that an explanation is needed why that loop had been
>> introduced and also why it is safe not to wait until qpair->ref_count
>> drops to zero in qla2xxx_delete_qpair().
>>
> 
> commit d74595278f4ab had drawback in design for MQ implementation in
> qla2xxx. Now that we have been making this more stable with MQ being
> default on for 5x kernel. What we discovered that after heavy IO
> workload in a cluster environment, driver unload encountered hang and
> shows following stack trace
> 
> # ps -fax | grep rmmod
> 6029 pts/0 D+ 0:00 | \_ rmmod qla2xxx
> 
> [<0>] msleep+0x29/0x30 [<0>] qla2xxx_delete_qpair+0x2c/0x160 [qla2xxx]
> [<0>] qla25xx_delete_queues+0x14b/0x1d0 [qla2xxx] [<0>]
> qla2x00_free_device+0x31/0xe0 [qla2xxx] [<0>]
> qla2x00_remove_one+0x239/0x370 [qla2xxx] [<0>]
> pci_device_remove+0x3b/0xc0 [<0>]
> device_release_driver_internal+0x18c/0x250 [<0>] driver_detach+0x39/0x6d
> [<0>] bus_remove_driver+0x77/0xc9 [<0>] pci_unregister_driver+0x2d/0xb0
> [<0>] qla2x00_module_exit+0x2d/0x90 [qla2xxx] [<0>]
> __x64_sys_delete_module+0x139/0x270 [<0>] do_syscall_64+0x5b/0x1b0 [<0>]
> entry_SYSCALL_64_after_hwframe+0x65/0xca [<0>] 0xffffffffffffffff
> 
> Removing this msleep() help resolve this stack trace. 

Hi Himanshu,

Does your answer mean that this hang has not yet been root-caused fully
and hence that it is possible this patch is only a workaround but not a
fix of the root cause?

Thanks,

Bart.

