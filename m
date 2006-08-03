From: "Scott Lowrey" <slowrey@nextone.com>
Subject: Performance Problem with LSI Logic 53c1030 RAID
Date: Thu, 3 Aug 2006 13:49:50 -0400
Message-ID: <8812D8156467224C9E9739E513037EF101302868@moe.nextone.local>
References: <44CF9EDD.7070309@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.nextone.com ([209.125.86.105]:8104 "EHLO
	mail2.nextone.com") by vger.kernel.org with ESMTP id S932561AbWHCRt5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 13:49:57 -0400
Content-class: urn:content-classes:message
In-Reply-To: <44CF9EDD.7070309@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Problem: 
      Deteriorating disk write performance with large files.  
      
      The problem *disappears* completely if RAID is disabled or if the
array
      is put into a degraded state by pulling the secondary array drive.
The
      problem *remains* if the primary array drive is pulled.

Setup: 
     Intel TIGI2U Chassis (carrier grade)
     Intel SE7520JR2 server board
     Dual 3.2 GHz Xeons, 800MHz FSB, 4GB RAM
     No PCI cards, 2 builtin E1000 NICs
     Integrated LSI 53c1030 Dual Channel SCSI HBA with integrated RAID
     Two 72GB Fujitsu drives in RAID 1 Configuration

     RAID array state optimal

     SUSE 2.6.11.4-21.11-bigsmp kernel with mods:
	  LSI MPT 3.02.68 SCSI modules
	  Fix to include shared memory in core dumps

     test command:    cat /dev/urandom > junk
     iostat command:  iostat -d 2 -x -t

The condensed report below shows what happens:  the test command was
executed
shortly after the report begins.  The average wait time (await) jumps
around
erratically as does the write speed (wkB/s).

Then the weirdness occurs.  The test command was stopped with Ctrl-C
just
before 12:34:00.  A few seconds later, the CPU pegs and average wait
time goes
through the roof.  The activity LED on the secondary array drive is on
solid;
the primary drive appears to be quiet.  The entire system becomes
sluggish and
seems to hang.  After about 40 seconds, all returns to normal.

Does anyone know what's wrong?  Is there any other data I can post that
would be useful?


  Time      CPU  wrqm/s  w/s   wkB/s  avgrq-sz  await  svctm
12:33:20   18.85   72.7  1.6   297.2      8.7  2498.9   54.0
12:33:22    5.30    8.0  9.5    70.0      0.3    29.9    5.6
12:33:24    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:33:26    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:33:28   59.45 1766.0  0.5  7138.0     21.5   240.0 1189.0
12:33:30  100.05    0.0  0.0     0.0     36.0     0.0    0.0
12:33:32  100.05    0.0  0.0     0.0     36.0     0.0    0.0
12:33:34   72.30   10.0 24.0    64.0     18.7  4669.8   30.1
12:33:36    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:33:38    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:33:40   80.00 6151.2  0.0 24817.9     85.3     0.0    0.0
12:33:42  100.55    0.0  8.0     0.0     99.4  2590.4  125.1
12:33:44   99.55    0.0  0.0     0.0     90.6     0.0    0.0
12:33:46  100.05    0.0  0.0     0.0     91.0     0.0    0.0
12:33:48  100.50    0.0  7.0     0.0     88.7  9213.2  142.9
12:33:50  100.05    0.0  8.0     0.0     69.1 10613.7  125.1
12:33:52  100.05    0.0  1.0     0.0     59.1 11652.0 1000.5
12:33:54  100.05    0.0  0.0     0.0     59.0     0.0    0.0
12:33:56  100.05    0.0  9.5     0.0     51.9 16857.8  105.3
12:33:58   99.55    0.0  6.5     0.0     32.3 18442.2  153.9
12:34:00  100.05    0.0  0.0     0.0     27.0     0.0    0.0
12:34:02   66.78   15.1 17.6    76.4     16.5 17605.2   38.0
12:34:04    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:34:06    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:34:08   84.63 7825.4  2.0 31568.2    110.1   358.2  425.2
12:34:10  100.05    0.0  0.0     0.0    130.1     0.0    0.0
12:34:12  100.05    0.0  0.0     0.0    130.1     0.0    0.0
12:34:14  100.05    0.0 10.0     0.0    121.3  6831.0  100.0
12:34:16  100.05    0.0  6.0     0.0    102.1  8369.8  166.8
12:34:18  100.05    0.0  0.0     0.0     98.0     0.0    0.0
12:34:20  100.05    0.0  0.0     0.0     98.0     0.0    0.0
12:34:22   99.55    0.0 14.9     0.0     85.6 14898.2   66.7
12:34:24  100.00    0.0  2.0     0.0     65.2 16302.0  500.0
12:34:26  100.05    0.0  2.0     0.0     61.0 18192.8  500.2
12:34:28  100.05    0.0  4.0     0.0     55.7 20619.6  250.1
12:34:30  100.05    0.0  4.0     0.0     47.2 22506.1  250.1
12:34:32  100.05    0.0  4.5     0.0     39.0 24579.6  222.3
12:34:34  100.05    0.0  2.5     0.0     31.9 26468.8  400.2
12:34:36   77.79   21.1 27.1   132.7     19.2 16093.9   28.7
12:34:38    0.00    0.0  0.0     0.0      0.0     0.0    0.0
12:34:40    0.00    0.0  0.0     0.0      0.0     0.0    0.0

--
Scott Lowrey
