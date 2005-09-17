From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sat, 17 Sep 2005 18:57:01 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0509171840110.10503@kai.makisara.local>
References: <1126845599.9276.44.camel@max> <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:35672 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751128AbVIQPvl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 11:51:41 -0400
In-Reply-To: <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, 17 Sep 2005, Kai Makisara wrote:

> On Thu, 15 Sep 2005, Mike Christie wrote:
> 
...
> This is not a real solution though. There should be some control over 
> retries from the scsi ULDs but I did not directly see how to do it. 
> Looking at the tests I did a couple of days, the number of retries seemed 
> to be variable (i.e., the number of retries I saw in the same test today 
> and a couple of days ago didn't match).
> 
I have looked the retries more and there seems to be several problems 
somewhere, not necessarily in your new code. I don't have any answers but 
here is data from one of my experiments. I had debugging enabled in 
st and added a printk to st_sleep_done to see what results st gets from 
the requests.

The tape contained four files, 10 10240 byte blocks each. The drive was in 
variable block mode and reading starts from the beginning of the tape.

The first command was
dd if=/dev/nst0 of=/dev/null bs=10240 count=10
i.e., read the data from the first file. The system log contained the 
following

Sep 17 14:04:03 box kernel: st: cmd=0x00 result=0x0 resid=0 sense[0]=0x00
Sep 17 14:04:03 box kernel: st: cmd=0x05 result=0x0 resid=0 sense[0]=0x00
Sep 17 14:04:03 box kernel: st0: Block limits 1 - 16777215 bytes.
Sep 17 14:04:03 box kernel: st: cmd=0x1a result=0x0 resid=0 sense[0]=0x00
Sep 17 14:04:03 box kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
Sep 17 14:04:03 box kernel: st0: Density 24, tape length: 0, drv buffer: 1
Sep 17 14:04:03 box kernel: st0: Block size: 0, buffer size: 4096 (1 blocks).
Sep 17 14:04:03 box kernel: st: cmd=0x08 result=0x0 resid=0 sense[0]=0x00
Sep 17 14:04:03 box last message repeated 9 times
Sep 17 14:04:03 box kernel: st0: Number of r/w requests 10, dio used in 10, pages 30 (0).

This was correct. Now the tape was positioned before the filemark. The 
next command was the same as before
dd if=/dev/nst0 of=/dev/null bs=10240 count=10

Sep 17 14:04:29 box kernel: st: cmd=0x00 result=0x0 resid=10240 sense[0]=0x00
Sep 17 14:04:29 box kernel: st: cmd=0x05 result=0x0 resid=0 sense[0]=0x00
Sep 17 14:04:29 box kernel: st0: Block limits 1 - 16777215 bytes.
Sep 17 14:04:29 box kernel: st: cmd=0x1a result=0x0 resid=0 sense[0]=0x00
Sep 17 14:04:29 box kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
Sep 17 14:04:29 box kernel: st0: Density 24, tape length: 0, drv buffer: 1
Sep 17 14:04:29 box kernel: st0: Block size: 0, buffer size: 4096 (1 blocks).

The first SCSI read command of 10240 bytes should have terminated with 
sense data showing that a filemark has been detected (sense code NO 
SENSE). What happened was that the system attempted to retry the command 
six times. This retry did not happen correctly because the sym53c8xx_2 
driver printed the following:

Sep 17 14:04:29 box kernel: st 1:0:5:0: extraneous data discarded.
Sep 17 14:04:29 box kernel: st 1:0:5:0: COMMAND FAILED (87 0 1).
Sep 17 14:04:29 box kernel: st 1:0:5:0: extraneous data discarded.
Sep 17 14:04:29 box kernel: st 1:0:5:0: COMMAND FAILED (87 0 1).
Sep 17 14:04:29 box kernel: st 1:0:5:0: extraneous data discarded.
Sep 17 14:04:29 box kernel: st 1:0:5:0: COMMAND FAILED (87 0 1).
Sep 17 14:04:29 box kernel: st 1:0:5:0: extraneous data discarded.
Sep 17 14:04:29 box kernel: st 1:0:5:0: COMMAND FAILED (87 0 1).
Sep 17 14:04:29 box kernel: st 1:0:5:0: extraneous data discarded.
Sep 17 14:04:29 box kernel: st 1:0:5:0: COMMAND FAILED (87 0 1).
Sep 17 14:04:29 box kernel: st 1:0:5:0: extraneous data discarded.
Sep 17 14:04:29 box kernel: st 1:0:5:0: COMMAND FAILED (87 0 1).
Sep 17 14:04:29 box kernel: st: cmd=0x08 result=0x70000 resid=10240 sense[0]=0xfffffff0
Sep 17 14:04:29 box kernel: st0: Error: 70000, cmd: 8 0 0 28 0 0
Sep 17 14:04:29 box kernel: st: Current: sense key: No Sense
Sep 17 14:04:29 box kernel:     Additional sense: Filemark detected
Sep 17 14:04:29 box kernel: Info fld=0x2800, FMK
Sep 17 14:04:29 box kernel: st0: Sense: f0  0 80  0  0 28  0  e

The result shows the correct return data from the first read command. The 
retried commands should have succeeded (well, the first one).

Sep 17 14:04:29 box kernel: st0: EOF detected (0 bytes read).
Sep 17 14:04:29 box kernel: st0: Number of r/w requests 1, dio used in 1, pages 3 (0).

OK. Next I tried
mt tell
to see where the tape was.

Sep 17 14:12:10 box kernel: st: cmd=0x00 result=0x0 resid=10240 sense[0]=0x00
                                                    ^^^^^^^^^^^
The resid here seems to have been "inherited" from the previous command.

Sep 17 14:12:10 box kernel: st: cmd=0x05 result=0x0 resid=0 sense[0]=0x00
Sep 17 14:12:10 box kernel: st0: Block limits 1 - 16777215 bytes.
Sep 17 14:12:10 box kernel: st: cmd=0x1a result=0x0 resid=0 sense[0]=0x00
Sep 17 14:12:10 box kernel: st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
Sep 17 14:12:10 box kernel: st0: Density 24, tape length: 0, drv buffer: 1
Sep 17 14:12:10 box kernel: st0: Block size: 0, buffer size: 4096 (1 blocks).
Sep 17 14:12:10 box kernel: st: cmd=0x34 result=0x0 resid=0 sense[0]=0x00
Sep 17 14:12:10 box kernel: st0: Got tape pos. blk 16 part 0.

The tape is positioned after the sixth block in the second file, i.e., the 
retried commands have moved the tape.

So, the retries did not happen correctly. One can also say that apparently 
the first read command returned sense data and it should not have been 
retried. I don't know how old these problems are because earlier the SCSI 
subsystem has used the retries parameter and not even "thought" about 
retrying the tape commands.

-- 
Kai
