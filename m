From: James Pearson <james-p@moving-picture.com>
Subject: LTO-3 read performance issues
Date: Wed, 07 Nov 2007 15:18:05 +0000
Message-ID: <4731D72D.5000404@moving-picture.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:57580 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934AbXKGPuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 10:50:22 -0500
Received: from minion.mpc.local ([172.16.11.112] helo=moving-picture.com)
	by moving-picture.com with esmtp (Exim 4.43)
	id 1IpmfN-0005zD-NM
	for linux-scsi@vger.kernel.org; Wed, 07 Nov 2007 15:18:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have two LTO-3 (QUANTUM ULTRIUM 3) drives attached to a dual Adaptec 
U160 controller (one per SCSI host) on a Dell PE2850 running a RHEL4 
based kernel (2.6.9 based).

I'm trying to read (with tar) LTO-3 tapes written on another system 
(possibly an SGI IRIX box), but I'm getting extremely variable read 
rates - from a few Kb/s to tens of Mb/s - while reading the same tape

After a bit of trial and error, it looks like the tapes have been 
written in variable block mode with a block size of 16Kb

To list the tapes, I need to set the block size to 0 (mt setblk 0) and run:

tar tvfb $TAPE 32

Running strace on the tar process shows that it does a number of 
read()'s then 'sticks' on a read() for a number of seconds, and then 
does a burst of read()'s - the number of reads it does in these bursts 
and the time if waits on a particular read vary.

My guess this is something to do the drive having to repositioning the 
tape between reads and breaking the tape streaming ...

I get the same issue on both drives with different tapes from the same 
source.

I am using the default st module options and not doing anything other 
than using 'mt setblk 0'.

Is there anything I can do to get a decent, sustained read rate from 
these tapes?

Thanks

James Pearson

