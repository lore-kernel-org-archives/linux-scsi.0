Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE41C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18F12070B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgG2ONB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 10:13:01 -0400
Received: from comms.puri.sm ([159.203.221.185]:48446 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgG2ONA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 10:13:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 98206E01AF;
        Wed, 29 Jul 2020 07:12:29 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id myurcYJZk0Jy; Wed, 29 Jul 2020 07:12:28 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <20200706164135.GE704149@rowland.harvard.edu>
 <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
 <20200728200243.GA1511887@rowland.harvard.edu>
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Autocrypt: addr=martin.kepplinger@puri.sm; keydata=
 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
 ekMtxgNYb/8oDry09UFHbGHLsWn6oBo=
Message-ID: <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
Date:   Wed, 29 Jul 2020 16:12:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200728200243.GA1511887@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28.07.20 22:02, Alan Stern wrote:
> On Tue, Jul 28, 2020 at 09:02:44AM +0200, Martin Kepplinger wrote:
>> Hi Alan,
>>
>> Any API cleanup is of course welcome. I just wanted to remind you that
>> the underlying problem: broken block device runtime pm. Your initial
>> proposed fix "almost" did it and mounting works but during file access,
>> it still just looks like a runtime_resume is missing somewhere.
> 
> Well, I have tested that proposed fix several times, and on my system 
> it's working perfectly.  When I stop accessing a drive it autosuspends, 
> and when I access it again it gets resumed and works -- as you would 
> expect.

that's weird. when I mount, everything looks good, "sda1". But as soon
as I cd to the mountpoint and do "ls" (on another SD card "ls" works but
actual file reading leads to the exact same errors), I get:

[   77.474632] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x00 driverbyte=0x08 cmd_age=0s
[   77.474647] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
[   77.474655] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
[   77.474667] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 60
40 00 00 01 00
[   77.474678] blk_update_request: I/O error, dev sda, sector 24640 op
0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[   77.485836] sd 0:0:0:0: [sda] tag#0 device offline or changed
[   77.491628] blk_update_request: I/O error, dev sda, sector 24641 op
0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[   77.502275] sd 0:0:0:0: [sda] tag#0 device offline or changed
[   77.508051] blk_update_request: I/O error, dev sda, sector 24642 op
0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
[   77.518651] sd 0:0:0:0: [sda] tag#0 device offline or changed
(...)
[   77.947653] sd 0:0:0:0: [sda] tag#0 device offline or changed
[   77.953434] FAT-fs (sda1): Directory bread(block 16448) failed
[   77.959333] sd 0:0:0:0: [sda] tag#0 device offline or changed
[   77.965118] FAT-fs (sda1): Directory bread(block 16449) failed
[   77.971014] sd 0:0:0:0: [sda] tag#0 device offline or changed
[   77.976802] FAT-fs (sda1): Directory bread(block 16450) failed
[   77.982698] sd 0:0:0:0: [sda] tag#0 device offline or changed
(...)
[   78.384929] FAT-fs (sda1): Filesystem has been set read-only
[  103.070973] sd 0:0:0:0: [sda] tag#0 device offline or changed
[  103.076751] print_req_error: 118 callbacks suppressed
[  103.076760] blk_update_request: I/O error, dev sda, sector 9748 op
0x1:(WRITE) flags 0x100000 phys_seg 1 prio class 0
[  103.087428] Buffer I/O error on dev sda1, logical block 1556, lost
async page write
[  103.095309] sd 0:0:0:0: [sda] tag#0 device offline or changed
[  103.101123] blk_update_request: I/O error, dev sda, sector 17162 op
0x1:(WRITE) flags 0x100000 phys_seg 1 prio class 0
[  103.111883] Buffer I/O error on dev sda1, logical block 8970, lost
async page write

> 
>> As we need to have that working at some point, I might look into it, but
>> someone who has experience in the block layer can surely do it more
>> efficiently.
> 
> I suspect that any problems you still face are caused by something else.
> 

I then formatted sda1 to ext2 (on the runtime suspend system testing
your patch) and that seems to have worked!

Again accessing the mountpoint then yield the very same "device offline
or changed" errors.

What kind of device are you testing? You should be easily able to
reproduce this using an "sd" device.

The problems must lie in the different other drivers we use I guess.

                             martin


> Alan Stern
> 
