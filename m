From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Thu, 19 Aug 2004 22:14:34 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408191314.AA03492@fukuchi.jp.fujitsu.com>
References: <20040819101433.GA20353@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:1261 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S266065AbUHSNO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 09:14:29 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i7JDERJB011308 for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 22:14:27 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s0.gw.fujitsu.co.jp by m6.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i7JDERqA027441 for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 22:14:27 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail504.fjmail.jp.fujitsu.com (fjmail504-0.fjmail.jp.fujitsu.com [10.59.80.102]) by s0.gw.fujitsu.co.jp (8.12.10)
	id i7JDEQKw008130 for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 22:14:26 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail504.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0I2P001CQ3G1PD@fjmail504.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu, 19 Aug 2004 22:14:26 +0900 (JST)
In-reply-to: <20040819101433.GA20353@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Emoore@lsil.com, linux-scsi@vger.kernel.org

I tried fusion MPT driver 3.01.15 and I didn't met Oops.
(Eric fixed Oops problem by Fusion MPT driver 3.01.04)

Masao Fukuchi

Message:
 18:19:01 kernel: mptscsih: ioc3: >> Attempting task abort! (sc=e00000007c205080)
 18:19:01 kernel: mptscsih: ioc3: >> Attempting target reset! (sc=e00000007c205080)
 18:19:01 kernel: mptscsih: ioc3: >> Attempting bus reset! (sc=e00000007c205080)
 18:19:03 kernel: mptbase: Initiating ioc3 recovery
 18:19:28 kernel: mptscsih: ioc3: >> Attempting task abort! (sc=e00000007c205080)
 18:19:28 kernel: mptscsih: ioc3: >> Attempting host reset! (sc=e00000007c205080)
 18:19:28 kernel: mptbase: Initiating ioc3 recovery
 18:19:52 kernel: mptscsih: ioc3: >> Attempting task abort! (sc=e00000007c205080)
 18:19:52 kernel: scsi: Device offlined - not ready after error recovery: host 3 channel 0 id 1 lun 0
 18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 2
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 3
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 4
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 5
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 6
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 7
 18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
 18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
 18:19:54 kernel: mptbase: Initiating ioc3 recovery


Christoph Hellwig wrote:
>On Thu, Aug 19, 2004 at 12:01:11PM +0900, Masao Fukuchi wrote:
>> Hi Christoph,
>> 
>> I applyed attached patch into latest fusion MPT driver(3.01.15) and
>> tested it, but I still met Oops.
>> Then I also applyed your latest patch(it gets rid of the fusion pendingQ
>> in favour of using the scsi midlayer queuing), but I met Oops again.
>
>Can you try the patch Eric posted instead?
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
