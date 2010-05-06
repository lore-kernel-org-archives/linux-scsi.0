From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Testers needed - Maxtor performance degradation
Date: Thu, 6 May 2010 12:15:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1005051433080.30185@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab0EFQQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2010 12:16:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org

Hi

When I was examining a reported performance degradation, I found out that 
the reason was buggy firmware in Maxtor Atlas 15K2 SCSI disks. If the 
requests are larger than 256kB, read rate drops excessively, even to one 
half of the normal read rate.

Performance on these disks improves if the request size is limited with
echo 256 >/sys/block/sdc/queue/max_sectors_kb

I remember seeing similar problem (increased transfer size => decreased 
performance) with IDE and SATA Maxtor disks some times ago, but I don't 
have any such disk to test currently.

I'd like to ask other people with Maxtor disks to run this script (with 
"sda", "sdb", etc. as an argument ... without "/dev/" prefix). The script 
measures read rate as a function of request size. Report the results, so 
that it can be determined which disks are buggy and which not and the 
default transfer size could be reduced to 256kB for the buggy ones.

My results are:
MAXTOR ATLAS15K2_146WLS HPM5
64 kB: 96,1 MB/s	448 kB: 54,3 MB/s	832 kB: 69,3 MB/s
128 kB: 95,9 MB/s	512 kB: 61,6 MB/s	896 kB: 72,8 MB/s
192 kB: 96,2 MB/s	576 kB: 63,4 MB/s	960 kB: 73,6 MB/s
256 kB: 96,4 MB/s	640 kB: 43,0 MB/s	1024 kB: 73,2 MB/s
320 kB: 47,3 MB/s	704 kB: 59,0 MB/s
384 kB: 47,5 MB/s	768 kB: 55,3 MB/s

MAXTOR ATLAS15K2_146WLS HPM7
64 kB: 95,8 MB/s	448 kB: 54,3 MB/s	832 kB: 67,7 MB/s
128 kB: 95,5 MB/s	512 kB: 60,2 MB/s	896 kB: 73,1 MB/s
192 kB: 95,8 MB/s	576 kB: 62,8 MB/s	960 kB: 72,8 MB/s
256 kB: 96,3 MB/s	640 kB: 44,3 MB/s	1024 kB: 73,2 MB/s
320 kB: 47,2 MB/s	704 kB: 58,3 MB/s
384 kB: 48,3 MB/s	768 kB: 54,2 MB/s

Note: fiddling with caching mode page (chaning DPTL, MAPF and MAPFC to -1) 
improved performance for large requests somehow (to 70-80MB/s), but I 
couldn't find a combination of settings that would restore 95MB/s rate, as 
for <= 256kB request. Thus, the correct workaround for these disks is to 
never send > 256kB requests.

Mikulas


#!/bin/sh
DISK="$1"
echo 1024 >/sys/block/$DISK/queue/max_sectors_kb
echo `cat /sys/block/$DISK/device/vendor /sys/block/$DISK/device/model /sys/block/$DISK/device/rev /sys/block/$DISK/device/firmware 2>/dev/null`
for i in `seq 64 64 1024`; do
	blocks=`expr 200000 / $i`
	echo -n "$i kB: "
	dd if=/dev/$DISK of=/dev/null iflag=direct bs=$i"k" count=$blocks 2>&1 | sed -n 's/.*s, //p'
done
