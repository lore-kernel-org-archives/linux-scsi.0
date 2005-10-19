From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi_eh: BUG in __schedule (was Re: Trouble installing 1394...)
Date: Wed, 19 Oct 2005 08:50:35 +0200
Message-ID: <4355ECBB.9070504@s5r6.in-berlin.de>
References: <20051011163832.49397.qmail@web54611.mail.yahoo.com>	 <5bdc1c8b0510110943reb9c49fu8428f6d4f67d5d75@mail.gmail.com>	 <434C2D25.3050403@s5r6.in-berlin.de> <5bdc1c8b0510111609y1309484au7893f4c154922af@mail.gmail.com> <434C5848.4010107@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47761 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751556AbVJSGwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 02:52:33 -0400
Received: from [192.168.0.41] ([62.180.98.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j9J6qT7Y024647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2005 08:52:30 +0200
In-Reply-To: <434C5848.4010107@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wrote on 2005-10-12:
> Mark Knecht wrote to linux1394-user:
>> scsi4 : SCSI emulation for IEEE-1394 SBP-2 Devices
>> ieee1394: sbp2: Error logging into SBP-2 device - login timed-out
>> prev->state: 2 != TASK_RUNNING??
>> scsi_eh_4/7835[CPU#0]: BUG in __schedule at kernel/sched.c:3326
>>
>> Call Trace:<ffffffff80132221>{__WARN_ON+97} 
>> <ffffffff803e79f0>{__schedule+608}
>>       <ffffffff801342bf>{do_exit+1007}
>> <ffffffff801467c0>{keventd_create_kthread+0}
>>       <ffffffff8010e5ed>{child_rip+15}
>> <ffffffff801467c0>{keventd_create_kthread+0}
>>       <ffffffff801466b0>{kthread+0} <ffffffff8010e5de>{child_rip+0}
>>
>> sbp2: probe of 0050c504e0006463-0 failed with error -16

In other words, a spinlock is held (in sbp2 or in the scsi core?) while 
the eh is fired up (or teared down?). As mentioned, this is 
2.6.14-rc4-rt1 but I consider it possible to occur in unpatched 
2.6.14-rcX too. I will investigate further but it may take me a while.
-- 
Stefan Richter
-=====-=-=-= =-=- =--==
http://arcgraph.de/sr/
