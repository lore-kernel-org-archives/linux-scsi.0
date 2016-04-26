From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH]sd: Don't treat succeeded SYNC as error
Date: Tue, 26 Apr 2016 12:57:48 +0200
Message-ID: <CAMGffE=cen-7VAr9nX2t5fDMzo+YeN2NOVuCXM6Bo3vV8kDfqA@mail.gmail.com>
References: <CAMGffEnAYXdYNfN7aHZHLjnhxY2T2V6m4tPNi4eT4kDuarrYxQ@mail.gmail.com>
 <571E7DEF.2090005@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35560 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbcDZK6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2016 06:58:08 -0400
Received: by mail-ob0-f171.google.com with SMTP id n10so4352474obb.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2016 03:58:08 -0700 (PDT)
In-Reply-To: <571E7DEF.2090005@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, Sebastian Parschauer <s.parschauer@gmx.de>

On Mon, Apr 25, 2016 at 10:28 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 04/25/2016 03:36 AM, Jinpu Wang wrote:
>>
>> We hit IO error on fsync, it turns out was because sd treat succeeded
>> SYNC as error. From what I checked in SBC spec there is no indication
>> we should fail IO in this case, so we create this patch.
>
>
> Please follow the rules in Documentation/SubmittingPatches and submit
> patches inline. Regarding the patch itself: why is the switch(op) needed?
> Can it be left out? And regarding (sshdr.asc == 0x2a && sshdr.ascq == 0x09):
> which other unit attentions should cause SCSI commands to succeed instead of
> to fail?
>
> Bart.

Hi Bart,

Thanks for looking into this.
Sure, I can resubmit inline.
Because our test only cover this, unconditional treat other commands
without test may break other application.

At least for READ/WRITE operation, ML will requeue it because not all
bytes transfered:
[ 1794.236001] sd 1:0:0:0: Capacity data has changed
[ 1794.236141] sd 1:0:0:0: [sdb] tag#0 Done: SUCCESS Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[ 1794.236381] sd 1:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 00 00 00 00
00 00 01 00
[ 1794.236609] sd 1:0:0:0: [sdb] tag#0 Sense Key : Unit Attention [current]
[ 1794.236725] sd 1:0:0:0: [sdb] tag#0 Add. Sense: Capacity data has changed
[ 1794.236839] sd 1:0:0:0: [sdb] tag#0 scsi host busy 1 failed 0
[ 1794.236981] sd 1:0:0:0: Notifying upper driver of completion (result 8000002)
[ 1794.237096] sd 1:0:0:0: [sdb] tag#0 sd_done: completed 0 of 512 bytes
[ 1794.237210] sd 1:0:0:0: [sdb] tag#0 1 sectors total, 0 bytes done.
[ 1794.237325] sd 1:0:0:0: [sdb] tag#0 Inserting command
ffff88022b9d4780 into mlqueue
[ 1794.238631] sd 1:0:0:0: [sdb] sd_open
[ 1794.238745] sd 1:0:0:0: scsi_block_when_processing_errors: rtn: 1
[ 1794.238864] sd 1:0:0:0: scsi_block_when_processing_errors: rtn: 1
[ 1794.238989] sd 1:0:0:0: scsi_block_when_processing_errors: rtn: 1
[ 1794.239107] sd 1:0:0:0: unblocking device at zero depth
[ 1794.239224] sd 1:0:0:0: [sdb] tag#0 Send: scmd 0xffff88022b9d4780
[ 1794.239338] sd 1:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 00 00 00 00
00 00 01 00
[ 1794.239592] sd 1:0:0:0: [sdb] tag#1 Send: scmd 0xffff8802296af380
[ 1794.239675] sd 1:0:0:0: [sdb] tag#0 Done: SUCCESS Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[ 1794.239677] sd 1:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 00 00 00 00
00 00 01 00
[ 1794.239678] sd 1:0:0:0: [sdb] tag#0 scsi host busy 2 failed 0
[ 1794.239679] sd 1:0:0:0: Notifying upper driver of completion (result 0)

But for SYNC CACHE:

[   84.450906] sd 6:0:0:1: [sdc] sd_open
[   84.451008] sd 6:0:0:1: scsi_block_when_processing_errors: rtn: 1
[   84.451084] sd 6:0:0:1: [sdc] tag#1 Send: scmd 0xffff880210357080
[   84.451143] sd 6:0:0:1: [sdc] tag#1 CDB: Synchronize Cache(10) 35
00 00 00 00 00 00 00 00 00
[   84.456081] sd 6:0:0:1: [sdc] tag#0 Done: SUCCESS Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[   84.456209] sd 6:0:0:1: [sdc] tag#0 CDB: Read(10) 28 00 00 00 01 10
00 00 08 00
[   84.456295] sd 6:0:0:1: [sdc] tag#0 scsi host busy 2 failed 0
[   84.456374] sd 6:0:0:1: Notifying upper driver of completion (result 0)
[   84.456438] sd 6:0:0:1: [sdc] tag#0 sd_done: completed 4096 of 4096 bytes
[   84.456498] sd 6:0:0:1: [sdc] tag#0 8 sectors total, 4096 bytes done.
[   84.456595] sd 6:0:0:1: Capacity data has changed
[   84.456612] sd 6:0:0:1: [sdc] sd_setup_read_write_cmnd: block=280, count=8
[   84.456616] sd 6:0:0:1: [sdc] block=280
[   84.456620] sd 6:0:0:1: [sdc] reading 8/8 512 byte blocks.
[   84.456628] sd 6:0:0:1: [sdc] tag#0 Send: scmd 0xffff8800ca41ed80
[   84.456634] sd 6:0:0:1: [sdc] tag#0 CDB: Read(10) 28 00 00 00 01 18
00 00 08 00
[   84.457003] sd 6:0:0:1: [sdc] tag#1 Done: SUCCESS Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[   84.457090] sd 6:0:0:1: [sdc] tag#1 CDB: Synchronize Cache(10) 35
00 00 00 00 00 00 00 00 00
[   84.457211] sd 6:0:0:1: [sdc] tag#1 Sense Key : Unit Attention [current]
[   84.457272] sd 6:0:0:1: [sdc] tag#1 Add. Sense: Capacity data has changed
[   84.457331] sd 6:0:0:1: [sdc] tag#1 scsi host busy 2 failed 0
[   84.457387] sd 6:0:0:1: Notifying upper driver of completion (result 8000002)
[   84.457445] sd 6:0:0:1: [sdc] tag#1 sd_done: completed 0 of 0 bytes
[   84.457503] sd 6:0:0:1: [sdc] tag#1 0 sectors total, 0 bytes done.
[   84.457562] blk_update_request: I/O error, dev sdc, sector 0

It completed with error directly.
We don't have failure case with our UA yet.

Thanks,
Jack
