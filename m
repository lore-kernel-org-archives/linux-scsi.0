From: Colin Walker <canford@btconnect.com>
Subject: 2-4-19 ATAPI reset when using multiple IDE CD-Writers
Date: Thu, 19 Sep 2002 14:20:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020919134930Z269269-685+50574@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When using multiple ide-writers with cdrecord there is a problem
with bus resets.

>From my tests so far writing with two scsi drives will work ok.
two scsi drives and one ide works ok
but with two ide drives one drive will fail randomly, the other will complete.

partial cdrecord output-
 Last chance to quit, starting real write in 0 seconds. Operation starts.
 cdrecord: Turning BURN-Free on
 cdrecord: Input/output error. write_g1: scsi sendcmd: no error
 CDB:  2A 00 00 00 5A F1 00 00 1F 00
 status: 0x2 (CHECK CONDITION)
 Sense Bytes: 70 00 06 00 00 00 00 0A 00 00 00 00 29 00 00 00
 Sense Key: 0x6 Unit Attention, Segment 0
 Sense Code: 0x29 Qual 0x00 (power on, reset, or bus device reset occurred) 
Fru 0x0
 Sense flags: Blk 0 (not valid)
 cmd finished after 0.057s timeout 40s
 write track data: error after 47679488 bytes
 Sense Bytes: 70 00 00 00 00 00 00 0A 00 00 00 00 00 00 00 00 00 00
bash-2.05$

/var/log/messages yields
Sep 19 10:18:45 hamster kernel: ide-scsi: CoD != 0 in idescsi_pc_intr
Sep 19 10:18:45 hamster kernel: hde: ATAPI reset complete

cdrecord appears to be correct as there was an ATAPI reset occured
this seems to point to ide-scsi as the culprit.

This occurs on both machines I have available using 
 cdrecord 1.11a11
 cdrecord 1.11a15 
 cdrecord 1.11a30
linux kernels
 Mandrake 8.2 kernel version 2.4.18-6mdk 
 Mandrake 9.0b1 kernel version 2.4.19-5mdk 

As ide-scsi.c from 2.4.20pre7 contains changes to ide-scsi.c can anyone 
confirm that it is a fix for my problems.

I can supply additional information if required.

-- 
Many Thanks

Colin Walker

