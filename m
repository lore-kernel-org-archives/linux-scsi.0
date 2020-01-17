Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4EDC33CB6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E90D82083E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:53:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t2YIul1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgAQDxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:53:51 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51669 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbgAQDxu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:53:50 -0500
Received: by mail-pj1-f66.google.com with SMTP id d15so2555431pjw.1;
        Thu, 16 Jan 2020 19:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f0CpFBRgTSpSHqh2qxHh8dF2T+jWA4ebI3e9GQKOUfA=;
        b=t2YIul1P+9P+NNySuURdDX/pnuGRgUCb+7bb5CHQQbykOUsSNt6n8p1sYw7G2krdif
         7ELfKASe5hK8rDXEQoq56nze3q+v82cthQcfFfNjI+aCWZLTMapFHmEA7tVGpqHewDx7
         Zesbrumz+SBu8Bjgf+azX+vW66YrT3jtDEJy4OABHVgn2apQufHQ/QbHHpsQiGuTzuiA
         C6mUts4PAWlwPeX8toCQTuFJIFXJYlyEIEdvWc2orCbT7TCF0EqigqZvrYCs3Wc/xxrA
         D5XHHsCDJVyBUxr/4jfcPGQ8y6a8/y5I1S6KfcPlHFFDIPCT2WFznD2X0ZZ1r+hFAqAF
         p1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f0CpFBRgTSpSHqh2qxHh8dF2T+jWA4ebI3e9GQKOUfA=;
        b=LURaxRxuT1knhsR60ZOdZLl4vZCV10vdqICUPh/7coRtrOLnimPbO4WAZAWNMzepz1
         iuBKoW7LKZVbl7guE2YcBICB59VpKSpzM1mLSW90VSvU+qQlFVMDwmtG+u20L4wYlUjM
         CPlfaajlYgqCcRAx193PQGubqVu7Cdz/15hNm9SpOqLsxjJOgdokcZTJUi+ZpSg8+9lc
         5gB1TPfxNaJEDKah8aS0vAHUkTJuhS/5YpQWrEW1Nh81USFC7WawM2kHxoBztByzQ/N8
         DC+YOJUqd5biDl0Eb279HR97Mgr75hQIYzjLFvquCtvGcO8ztpfZUvOwSN8nojQKADzD
         36qw==
X-Gm-Message-State: APjAAAXqkKYYPnLaQD1qyJdamml7JXtyOPoikdu2G1kF6ccZcSaTYJ67
        +Efsq2VpjF/lOs6+nliyU0o=
X-Google-Smtp-Source: APXvYqwl9QSjdzurBW5ySak6XiDPzigdspaQ9CYNf8nBtoOFr53QFa1WMt2beNVp79QHHXOCgIj+Zw==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr29744217plo.220.1579233229322;
        Thu, 16 Jan 2020 19:53:49 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23sm28799687pfg.82.2020.01.16.19.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 19:53:48 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net> <yq1r211dvck.fsf@oracle.com>
 <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
 <yq1r202spr9.fsf@oracle.com>
 <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net>
 <yq14kwwnioo.fsf@oracle.com> <20200116174703.GA7850@roeck-us.net>
 <yq18sm6n9hp.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <87a7372c-702c-091a-ab3f-b589e68a1ecb@roeck-us.net>
Date:   Thu, 16 Jan 2020 19:53:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq18sm6n9hp.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/20 5:43 PM, Martin K. Petersen wrote:
> 
> Guenter,
> 
>> Can you by any chance provide a full traceback ?
> 
> My test machines are tied up with something else right now. This is from
> a few days ago (pristine hwmon-next, I believe):
> 
> [ 1055.611912] ------------[ cut here ]------------
> [ 1055.611922] WARNING: CPU: 3 PID: 3233 at drivers/base/dd.c:519 really_probe+0x436/0x4f0
> [ 1055.611925] Modules linked in: sd_mod sg ahci libahci libata drivetemp scsi_mod crc32c_intel igb i2c_algo_bit i2c_core dca hwmon ipv6 nf_defrag_ipv6 crc_ccitt
> [ 1055.611955] CPU: 3 PID: 3233 Comm: kworker/u17:1 Tainted: G        W         5.5.0-rc1+ #21
> [ 1055.611965] Workqueue: events_unbound async_run_entry_fn
> [ 1055.611973] RIP: 0010:really_probe+0x436/0x4f0
> [ 1055.611979] Code: c7 30 69 f8 82 e8 ba 94 e5 ff e9 60 ff ff ff 48 8d 7b 38 e8 cc d9 b4 ff 48 8b 43 38 48 85 c0 0f 85 41 fd ff ff e9 4f fd ff ff <0f> 0b e9 66 fc ff ff 48 8d 7d 50 e8 aa d9 b4 ff 4c 8b 6d 50 4d 85
> [ 1055.611983] RSP: 0018:ffff8881edb77c98 EFLAGS: 00010287
> [ 1055.611989] RAX: ffff8881e1f8fb80 RBX: ffffffffa033a000 RCX: ffffffff8182e583
> [ 1055.611993] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffff8881dec506a8
> [ 1055.611997] RBP: ffff8881dec50238 R08: 0000000000000001 R09: fffffbfff09629ed
> [ 1055.612000] R10: fffffbfff09629ec R11: 0000000000000003 R12: 0000000000000000
> [ 1055.612004] R13: ffff8881dec506a8 R14: ffffffff8182eca0 R15: 000000000000000b
> [ 1055.612009] FS:  0000000000000000(0000) GS:ffff8881f8900000(0000) knlGS:0000000000000000
> [ 1055.612013] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1055.612017] CR2: 00007f957884a000 CR3: 00000001df5ec003 CR4: 00000000000606e0
> [ 1055.612020] Call Trace:
> [ 1055.612038]  ? driver_probe_device+0x170/0x170
> [ 1055.612045]  driver_probe_device+0x82/0x170
> [ 1055.612058]  ? driver_probe_device+0x170/0x170
> [ 1055.612064]  __driver_attach_async_helper+0xa3/0xe0
> [ 1055.612076]  async_run_entry_fn+0x68/0x2a0
> [ 1055.612094]  process_one_work+0x4df/0x990
> [ 1055.612121]  ? pwq_dec_nr_in_flight+0x110/0x110
> [ 1055.612127]  ? do_raw_spin_lock+0x113/0x1d0
> [ 1055.612161]  worker_thread+0x78/0x5c0
> [ 1055.612190]  ? process_one_work+0x990/0x990
> [ 1055.612195]  kthread+0x1be/0x1e0
> [ 1055.612202]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> [ 1055.612215]  ret_from_fork+0x3a/0x50
> [ 1055.612251] irq event stamp: 3512
> [ 1055.612259] hardirqs last  enabled at (3511): [<ffffffff81d2b874>] _raw_spin_unlock_irq+0x24/0x30
> [ 1055.612265] hardirqs last disabled at (3512): [<ffffffff810029c9>] trace_hardirqs_off_thunk+0x1a/0x1c
> [ 1055.612272] softirqs last  enabled at (3500): [<ffffffff820003a5>] __do_softirq+0x3a5/0x5a8
> [ 1055.612281] softirqs last disabled at (3489): [<ffffffff810cec7b>] irq_exit+0xfb/0x100
> [ 1055.612284] ---[ end trace f0a8dd9a37bea031 ]---
> 
>> Either case, I would like to track down how the warning happens, so any
>> information you can provide that lets me reproduce the problem would be
>> very helpful.
> 
> The three systems that exhibit the problem are stock (2010/2012/2014
> vintage) x86_64 servers with onboard AHCI and a variety of 4-6 SATA
> drives each.
> 
> For the qemu test I didn't have ahci configured but I had my SCSI temp
> patch on top of yours and ran modprobe drivetemp; modprobe scsi_debug to
> trigger the warnings.
> 

Interesting. Looks like your system performs asynchronous probing.
No idea how that can result in that kind of problem, but who knows.
Can you send me the qemu command line ?

Thanks,
Guenter
