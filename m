From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Fri, 20 Aug 2004 12:05:15 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408200305.AA03495@fukuchi.jp.fujitsu.com>
References: <0E3FA95632D6D047BA649F95DAB60E5704DE6953@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:7134 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S266188AbUHTDFL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 23:05:11 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i7K35AwH003291 for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 12:05:10 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s4.gw.fujitsu.co.jp by m5.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i7K359mZ017527 for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 12:05:09 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail506.fjmail.jp.fujitsu.com (fjmail506-0.fjmail.jp.fujitsu.com [10.59.80.106]) by s4.gw.fujitsu.co.jp (8.12.11)
	id i7K359o3008811 for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 12:05:09 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan501-0.fjmail.jp.fujitsu.com [10.59.80.120])
 by fjmail506.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0I2Q00K725WKW3@fjmail506.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Fri, 20 Aug 2004 12:05:09 +0900 (JST)
In-reply-to: <0E3FA95632D6D047BA649F95DAB60E5704DE6953@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Eric,

I applyed your patch and tested it, but the patch didn't work well.
I didn't met Oops. 
But after read command finishing with fail, keyboard and mouse click 
didn't work.
And also I couldn't login from other server.

The message was almost same as Fusion MPT driver 3.01.15.

Masao Fukuchi

Moore, Eric Dean wrote:
>Here is a patch to apply against 3.01.15. It will have a small
>fix in mptscsih_abort which should work with Christoph's suggestion
>of removing the "is the device is offline" check in 
>mptscsih_flush_running_cmds.  Pls test and let me know if you still 
>hit the oops.
>
>Eric
>
>
>On Thursday, August 19, 2004 7:15 AM, Masao Fukuchi wrote:
>> 
>> I tried fusion MPT driver 3.01.15 and I didn't met Oops.
>> (Eric fixed Oops problem by Fusion MPT driver 3.01.04)
>> 
>> Masao Fukuchi
>> 
>> Message:
>>  18:19:01 kernel: mptscsih: ioc3: >> Attempting task abort! 
>> (sc=e00000007c205080)
>>  18:19:01 kernel: mptscsih: ioc3: >> Attempting target reset! 
>> (sc=e00000007c205080)
>>  18:19:01 kernel: mptscsih: ioc3: >> Attempting bus reset! 
>> (sc=e00000007c205080)
>>  18:19:03 kernel: mptbase: Initiating ioc3 recovery
>>  18:19:28 kernel: mptscsih: ioc3: >> Attempting task abort! 
>> (sc=e00000007c205080)
>>  18:19:28 kernel: mptscsih: ioc3: >> Attempting host reset! 
>> (sc=e00000007c205080)
>>  18:19:28 kernel: mptbase: Initiating ioc3 recovery
>>  18:19:52 kernel: mptscsih: ioc3: >> Attempting task abort! 
>> (sc=e00000007c205080)
>>  18:19:52 kernel: scsi: Device offlined - not ready after 
>> error recovery: host 3 channel 0 id 1 lun 0
>>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 2
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 3
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 4
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 5
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 6
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 7
>>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
>>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
>>  18:19:54 kernel: mptbase: Initiating ioc3 recovery
>> 
>> 
>> Christoph Hellwig wrote:
>> >On Thu, Aug 19, 2004 at 12:01:11PM +0900, Masao Fukuchi wrote:
>> >> Hi Christoph,
>> >> 
>> >> I applyed attached patch into latest fusion MPT driver(3.01.15) and
>> >> tested it, but I still met Oops.
>> >> Then I also applyed your latest patch(it gets rid of the 
>> fusion pendingQ
>> >> in favour of using the scsi midlayer queuing), but I met 
>> Oops again.
>> >
>> >Can you try the patch Eric posted instead?
>> >
>> >-
>> >To unsubscribe from this list: send the line "unsubscribe 
>> linux-scsi" in
>> >the body of a message to majordomo@vger.kernel.org
>> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
