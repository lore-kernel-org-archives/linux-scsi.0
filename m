From: "Adam" <adam@luchjenbroers.com>
Subject: A few issues with aic7xxx driver (2 problems, 5 servers affected)
Date: Sun, 15 Feb 2004 21:17:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200402160217.VAA29761@m1.name2host.com>
Reply-To: "Adam" <adam@luchjenbroers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from name2host.com ([64.35.113.46]:65033 "EHLO m1.name2host.com")
	by vger.kernel.org with ESMTP id S265328AbUBPCRn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 21:17:43 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There are 2 seperate problems, affecting 5 different servers that I am
trying to solve.

All servers are Redhat 7.2

Problem 1:
All 3 affected servers are running kernel 2.4.9-31
All 3 affected servers are using the aic7xxx driver for the SCSI card.

Server has a kernel panic, and from the messages there is a cycle of
timeout/resets on the SCSI bus. My research has turned up disscusions about
this on driver initialisation but this issue occurs after the server has
been running for awhile.

Rebooting the server restores it to operation.

Apr 26 03:55:26 server kernel: SCSI host 0 abort (pid 0) timed out -
resetting
Apr 26 03:55:26 server kernel: SCSI bus is being reset for host 0 channel 0.
Apr 26 03:55:28 server kernel: SCSI host 0 channel 0 reset (pid 0) timed out
- trying harder
Apr 26 03:55:28 server kernel: SCSI bus is being reset for host 0 channel 0.
Apr 26 03:55:28 server kernel: st0: Error 26030000 (sugg. bt 0x20, driver bt
0x6, host bt 0x3).
Apr 26 03:55:31 server kernel: scsi0 channel 0 : resetting for second half
of retries.
Apr 26 03:55:31 server kernel: SCSI bus is being reset for host 0 channel 0.

Server kernel panic with error message
<b0114f90>[schedule[kernel]0x100

Problem 2:
1 server is running 2.4.9-31, the other 2.4.20-13.
Both are using the aic7xxx driver.

This problem was first beleived to be linked to ejecting the tape from the
server, but has also occured once without it.

Rebooting the server restores it to operation.

Sep 19 04:38:29 server kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
Sep 19 04:38:29 server kernel: scsi1: Dumping Card State while idle, at
SEQADDR 0x9
Sep 19 04:38:29 server kernel: ACCUM = 0x4, SINDEX = 0x7, DINDEX = 0x21,
ARG_2 = 0x0
Sep 19 04:38:29 server kernel: HCNT = 0x0 SCBPTR = 0x0
Sep 19 04:38:29 server kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Sep 19 04:38:29 server kernel: DFCNTRL = 0x0, DFSTATUS = 0x89
Sep 19 04:38:29 server kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0 =
0x80
Sep 19 04:38:29 server kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
Sep 19 04:38:29 server kernel: SCSIPHASE = 0x0
Sep 19 04:38:29 server kernel: STACK == 0x3, 0x175, 0x160, 0x34
Sep 19 04:38:29 server kernel: SCB count = 4
Sep 19 04:38:29 server kernel: Kernel NEXTQSCB = 2
Sep 19 04:38:29 server kernel: Card NEXTQSCB = 2
Sep 19 04:38:29 server kernel: QINFIFO entries:
Sep 19 04:38:29 server kernel: Waiting Queue entries:
Sep 19 04:38:30 server kernel: Disconnected Queue entries: 0:3
Sep 19 04:38:30 server kernel: QOUTFIFO entries:
Sep 19 04:38:30 server kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10
11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Sep 19 04:38:30 server kernel: Sequencer SCB Info: 0(c 0x44, s 0x7, l 0, t
0x3) 1(c 0x0, s 0xff, l 255, t 0xff) 2(c 0x0, s 0xff, l 255, t 0xff) 3(c
0x0, s 0xff, l 255, t 0xff)
4(c 0x0, s 0xff, l 255, t 0xff) 5(c 0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s
0xff, l 255, t 0xff) 7(c 0x0, s 0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255,
t 0xff) 9(c 0x0, s 0xf
f, l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l 255,
t 0xff) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255, t 0xff)
14(c 0x0, s 0xff, l 255,
t 0xff) 15(c 0x0, s 0xff, l 255, t 0xff) 16(c 0x0, s 0xff, l 255, t 0xff)
17(c 0x0, s 0xff, l 255, t 0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 19(c 0x0,
s 0xff, l 255, t 0xff) 20
(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 0xff, l 255, t 0xff) 22(c 0x0, s
0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t 0xff) 24(c 0x0, s 0xff, l
255, t 0xff) 25(c 0x0, s
0xff, l 255, t 0xff) 26(c 0x0, s 0xff, l 255, t 0xff) 27(c 0x0, s 0xff, l
255, t 0xff) 28(c 0x0, s 0xff, l 255, t 0xff) 29(c 0x0, s 0xff, l 255, t
0xff
Sep 19 04:38:30 server kernel: 30(c 0x0, s 0xff, l 255, t 0xff) 31(c 0x0, s
0xff, l 255, t 0xff)
Sep 19 04:38:30 server kernel: Pending list: 3(c 0x40, s 0x7, l 0)
Sep 19 04:38:30 server kernel: Kernel Free SCB list: 1 0
Sep 19 04:38:30 server kernel: Untagged Q(0): 3
Sep 19 04:38:30 server kernel: DevQ(0:0:0): 0 waiting
Sep 19 04:38:30 server kernel: (scsi1:A:0:0): Queuing a recovery SCB
Sep 19 04:38:30 server kernel: scsi1:0:0:0: Device is disconnected,
re-queuing SCB
Sep 19 04:38:30 server kernel: Recovery code sleeping
Sep 19 04:38:30 server kernel: Recovery code awake
Sep 19 04:38:30 server kernel: aic7xxx_abort returns 0x2002
Sep 19 04:38:30 server kernel: (scsi1:A:0:0): Abort Message Sent
Sep 19 04:38:30 server kernel: (scsi1:A:0:0): SCB 3 - Abort Completed.
Sep 19 04:38:30 server kernel: Recovery SCB completes

Any information regarding the these problems or related to troubleshooting
the aic7xxx driver would be appreciated.

I apologise if this appears as a double post, but it doesn't appear that my
previous message went through.
