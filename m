From: "Oelke, Mark" <mark.oelke@hp.com>
Subject: RE: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 18 May 2015 13:57:39 +0000
Message-ID: <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:37952 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbbERN6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 09:58:20 -0400
In-Reply-To: <20150518124058.GH21418@twins.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "don.brace@pmcs.com" <don.brace@pmcs.com>
Cc: ISS StorageDev <iss_storagedev@hp.com>, "storagedev@pmcs.com" <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The P212/P410/P411 firmware was recently spun to address an issue that sounds exactly like this problem.
Which version of controller firmware are you using?

-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org] 
Sent: Monday, May 18, 2015 7:41 AM
To: don.brace@pmcs.com
Cc: ISS StorageDev; storagedev@pmcs.com; linux-scsi@vger.kernel.org
Subject: [BUG] hpsa: Controller lockup detected: 0x00150028

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

With linux 3.16 the whole kernel came down with NMI watchdog timeouts / RCU stalls in the detect_lockup() worklet.

On linux 4.0 those appear to be gone, but the controller isn't coming back either.

It this a known 'feature'; is there anything I can do to help diagnose/fix this issue?

 ~ Peter
