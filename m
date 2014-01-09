From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Thu, 9 Jan 2014 23:26:40 +0200
Message-ID: <CA+QCeVQXbZO4-G4E22hPwd8u62PEhT46mNw1GxmNYZNvd1+RFg@mail.gmail.com>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <52CC6A53.9010508@emulex.com>
 <CA+QCeVSruYZCQOGapU_y613ucaptkzQN34X83DmYiPXTkWFVzg@mail.gmail.com> <52CEFE62.7070009@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:47822 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbaAIV1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2014 16:27:01 -0500
In-Reply-To: <52CEFE62.7070009@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Smart <james.smart@emulex.com>, Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>, Christoph Hellwig <hch@infradead.org>

Hi Duglas,

On 9 January 2014 21:54, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 14-01-08 08:57 AM, Sergey Meirovich wrote:
...
>>
>> The strangest thing to me that this is the problem with sequential
>> write. For example the fnic one machine is zoned to EMC XtremIO and
>> had results: 14.43Mb/sec 3693.65 Requests/sec for sequential 4k. The
>> same fnic machine perfrormed rather impressive for random 4k
>> 451.11Mb/sec 115485.02 Requests/sec
>
>
> You could bypass O_DIRECT and use ddpt together with
> a bsg pass-through (bsg is a little faster than sg
> for these purposes).
>
> For example:
>
> # lsscsi -g
> [0:0:0:0]    disk    ATA    INTEL SSDSC2CW12 400i  /dev/sda /dev/sg0
> [14:0:0:0]   disk    Linux  scsi_debug       0004  -        /dev/sg1
>
> # ddpt if=/dev/bsg/14:0:0:0 bs=512 bpt=128 count=1m
> Output file not specified so no copy, just reading input
> 1048576+0 records in
> 0+0 records out
> time to read data: 0.283566 secs at 1893.28 MB/sec
>
> bs= should match the block size of the storage device and
> the size of each SCSI READ is dictated by bpt= (so 64 KB
> in this case).
>
> Such a test should show you if your performance problem
> is in the block layer or below, or above the block layer
> (at least the point where pass-through commands are
> injected).
>
> Doug Gilbert

Thanks for an excellent idea!

Seems like this is not Direct IO issue.Just tried it against
fnic/XtremIO.   4k over via bsg is still 17.278 Mb/s for write.
.
[root@dca-poc-gtsxdb3 bsg]# /tmp/ddpt-0.91/src/ddpt if=/dev/zero
of=/dev/bsg/0:0:4:1 bs=512 bpt=8 count=1m
1048576+0 records in
1048576+0 records out
time to transfer data: 31.076487 secs at 17.28 MB/sec


[root@dca-poc-gtsxdb3 bsg]# /tmp/ddpt-0.91/src/ddpt if=/dev/zero
of=/dev/bsg/0:0:4:1 bs=512 bpt=16 count=512k
524288+0 records in
524288+0 records out
time to transfer data: 8.511421 secs at 31.54 MB/sec


[root@dca-poc-gtsxdb3 bsg]# /tmp/ddpt-0.91/src/ddpt if=/dev/zero
of=/dev/bsg/0:0:4:1 bs=512 bpt=32 count=256k
262144+0 records in
262144+0 records out
time to transfer data: 2.426037 secs at 55.32 MB/sec
[root@dca-poc-gtsxdb3 bsg]#
