From: Peter Zijlstra <peterz@infradead.org>
Subject: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 18 May 2015 14:40:58 +0200
Message-ID: <20150518124058.GH21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbERMlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 08:41:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@pmcs.com
Cc: iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org

Hi,

On my HP-DL180-G6 with a HP Smart Array P212.

I can reliably trigger a controller lockup by running smartctl.

I'm trying to monitor my HDD temps using:

  for ((i=0; i<8; i++)) ; do
	smartctl -d cciss,$i -a /dev/sg0 | grep ^194 ;

  done | awk '{t=$10; if (t > T) T = t;} END {print T}'

After a few of those runs, I get:

[ 1540.277776] hpsa 0000:06:00.0: Controller lockup detected: 0x00150028

And my disks are gone.

With linux 3.16 the whole kernel came down with NMI watchdog timeouts /
RCU stalls in the detect_lockup() worklet.

On linux 4.0 those appear to be gone, but the controller isn't coming
back either.

It this a known 'feature'; is there anything I can do to help
diagnose/fix this issue?

 ~ Peter
