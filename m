Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F81C433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 21:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97AE52145D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 21:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgIGVcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 17:32:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:36823 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgIGVcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Sep 2020 17:32:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E247D204199;
        Mon,  7 Sep 2020 23:32:16 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ILuyja8IIbHM; Mon,  7 Sep 2020 23:32:10 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 51C02204194;
        Mon,  7 Sep 2020 23:32:09 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: take module reference during async scan
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
References: <20200907154745.20145-1-thenzl@redhat.com>
 <1599500808.4232.19.camel@HansenPartnership.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <a31b8640-307f-a14f-7cf8-7673fa8a4ff1@interlog.com>
Date:   Mon, 7 Sep 2020 17:32:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1599500808.4232.19.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-07 1:46 p.m., James Bottomley wrote:
> On Mon, 2020-09-07 at 17:47 +0200, Tomas Henzl wrote:
>> During an async scan the driver shost->hostt structures are used,
>> that may cause issues when the driver is removed at that time.
>> As protection take the module reference.
> 
> Can I just ask what issues?  Today, our module model is that
> scsi_device_get() bumps the module refcount and therefore makes the
> module ineligible to be removed.  scsi_host_get() doesn't do this
> because the way the host model is supposed to be coded, we can call
> remove at any time but the module won't get freed until the last put of
> the host.  I can see we have a potential problem with
> scsi_forget_host() racing with the async scan thread ... is that what
> you see? What's supposed to happen is that scsi_device_get() starts
> failing as soon as the module begins it's exit routine, so if a scan is
> in progress, it can't add any new devices ... in theory this means that
> the list is stable for scsi_forget_host(), so knowing how that
> assumption is breaking would be useful.

James,
If you think it is bullet-proof try using CONFIG_DEBUG_TEST_DRIVER_REMOVE=y .
John Garry reported that:

  # insmod scsi_debug.ko

Gave errors like this:

[  140.115244] debugfs: Directory 'sde' with parent 'block' already present!
[  140.376426] debugfs: Directory 'sde' with parent 'block' already present!
[  140.420613] sd 3:0:0:0: [sde] tag#40 access beyond end of device
[  140.426655] blk_update_request: I/O error, dev sde, sector 15984 op 
0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[  140.437319] sd 3:0:0:0: [sde] tag#41 access beyond end of device
[  140.443368] blk_update_request: I/O error, dev sde, sector 15984 op 
0x0:(READ) flags 0x0 phys_seg 1 prio class 0
...

Which wasn't the scsi_debug driver directly as it doesn't use debugfs. So
I suspect something is rotten in the mid-level.

When I tried to replicate John's config I couldn't even boot my Ubuntu
20.04 based system (with a MKP kernel). Seemed to fail/lockup before any
kernel prints came out to the serial port (yes, still useful), perhaps in
initrd. I'm guessing another, non-SCSI module caused the lockup. So I
gave up and turned off that config setting.

Doug Gilbert


