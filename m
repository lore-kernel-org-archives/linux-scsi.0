From: ael <law_ence.dev@ntlworld.com>
Subject: st.c block limits
Date: Tue, 30 Jul 2002 21:20:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D46F4F4.1090703@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ntlworld.com ([213.105.148.22]) by mta01-svc.ntlworld.com
          (InterMail vM.4.01.03.27 201-229-121-127-20010626) with ESMTP
          id <20020730201952.HZRH16050.mta01-svc.ntlworld.com@ntlworld.com>
          for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2002 21:19:52 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a scsi tape drive:-

Host: scsi0 Channel: 00 Id: 00 Lun: 00
     Vendor: AIWA     Model: TD-20001         Rev: 0159
     Type:   Sequential-Access                ANSI SCSI revision: 02

It has worked perfectly for several years, but from kernel 2.4.10 st.c
started to report a 24-bit block limit: st0: Block limits 1 - 16777215 
bytes. I am now on stock 2.4.18 with static char *verstr = "20020205".

The above drive is a NS-20 drive with default block size of 512 and 20G 
blocks: so a range of 25 bits for the block number is needed.

So when I attempt to write to the tape beyond block 2^24,
I get an error like:

# tar -cf /dev/ntape blah_home.tar.bz2; mt  tell
tar: /dev/ntape: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now
At block 17832312.

With:
    kernel: st0: Block limits 1 - 16777215 bytes.
in the kernel log.


Now I *think* that I used to write to the end of tapes without hitting this
2^24 block limit. I guess that I can work around by setting a larger block 
size. But is there a fix? Or is the 24-bit limit built into the scsi tape 
protocol? Since I used to fill 2 tapes to complete a backup, I must have 
written beyond block (2^24 -1).

Sorry if this is an FAQ. I did google and found nothing directly relevant.
When did st.c change and why? I did turn on DEBUG, and I append a few 
entries, although I am not sure that it helps much:

Jul 30 16:49:28 conquest3 kernel: st: Version 20020205, bufsize 32768, wrt
30720, max init. bufs 4, s/g segs 16
Jul 30 16:49:28 conquest3 kernel: Attached scsi tape st0 at scsi0, channel
0, id 0, lun 0
Jul 30 16:49:28 conquest3 kernel: st: Allocated tape buffer 0 (32768 bytes,
1 segments, dma: 1, a: c01e8000).
Jul 30 16:49:28 conquest3 kernel: st: segment sizes: first 32768, last
32768 bytes.
drwx------    2 ael      ael          4096 Nov  3  2001 Mail
Jul 30 16:49:28 conquest3 kernel: st0: Block limits 1 - 16777215 bytes.
Jul 30 16:49:28 conquest3 kernel: st0: Mode sense. Length 11, medium 85,
WBS 10, BLL 8
Jul 30 16:49:28 conquest3 kernel: st0: Density 0, tape length: 0, drv buffer: 1
Jul 30 16:49:28 conquest3 kernel: st0: Block size: 512, buffer size: 32768
(64 blocks).

After switching to 1K blocks and fsf'ing past existing data:-
--------------------------------------------------------------


Jul 30 17:28:50 conquest3 kernel: st0: Setting block size to 1024 bytes.
Jul 30 17:28:50 conquest3 kernel: st0: Rewinding tape.
Jul 30 17:28:52 conquest3 kernel: st0: Block limits 1 - 16777215 bytes.
Jul 30 17:28:52 conquest3 kernel: st0: Mode sense. Length 11, medium 85,
WBS 10, BLL 8
Jul 30 17:28:52 conquest3 kernel: st0: Density 0, tape length: 0, drv buffer: 1
Jul 30 17:28:52 conquest3 kernel: st0: Block size: 1024, buffer size: 32768
(32 blocks).
Jul 30 17:28:52 conquest3 kernel: st0: Rewinding tape.
Jul 30 17:29:36 conquest3 kernel: st0: Block limits 1 - 16777215 bytes.
Jul 30 17:29:36 conquest3 kernel: st0: Mode sense. Length 11, medium 85,
WBS 10, BLL 8
Jul 30 17:29:36 conquest3 kernel: st0: Density 0, tape length: 0, drv buffer: 1
Jul 30 17:29:36 conquest3 kernel: st0: Block size: 1024, buffer size: 32768
(32 blocks).
Jul 30 17:29:36 conquest3 kernel: st0: Spacing tape forward over 12 filemarks.
Jul 30 17:32:28 conquest3 kernel: st0: Block limits 1 - 16777215 bytes.
Jul 30 17:32:28 conquest3 kernel: st0: Mode sense. Length 11, medium 85,
WBS 10, BLL 8
Jul 30 17:32:28 conquest3 kernel: st0: Density 0, tape length: 0, drv buffer: 1
Jul 30 17:32:28 conquest3 kernel: st0: Block size: 1024, buffer size: 32768
(32 blocks).
Jul 30 17:32:28 conquest3 kernel: st0: Got tape pos. blk 17832312 part 0.

Thanks in advance for any help

ael



