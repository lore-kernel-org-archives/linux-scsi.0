From: Cameron Harr <charr@fusionio.com>
Subject: Re: [ofa-general] iSer and Direct IO
Date: Thu, 15 May 2008 09:25:10 -0600
Message-ID: <482C55D6.2010803@fusionio.com>
References: <482B7FE4.9070502@fusionio.com> <694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from slc.fusionio.com ([70.102.37.203]:61289 "EHLO mail.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbYEOP0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 11:26:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.fusionio.com (Postfix) with ESMTP id 5B22C566F4C
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 09:26:08 -0600 (MDT)
Received: from mail.fusionio.com ([127.0.0.1])
	by localhost (xserve0.fusionio.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wyWl+h1T+rOE for <linux-scsi@vger.kernel.org>;
	Thu, 15 May 2008 09:26:03 -0600 (MDT)
Received: from CamsmaC.local (unknown [70.102.37.202])
	by mail.fusionio.com (Postfix) with ESMTP id EBD77566F3F
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2008 09:26:02 -0600 (MDT)
In-Reply-To: <694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>



Eli Dorfman wrote:
> On Thu, May 15, 2008 at 3:12 AM, Cameron Harr <charr@fusionio.com> wrote:
>   
>> My problem though is that I'm a
>> little suspicious of some of the iSer numbers and whether they are
>> really using Direct IO. For example, you'll see below in some of my FIO
>> results that I'm getting a write B/W of 799.1 MB/s at one point. That's
>> way above what I can get natively on the device (~650 MB/s DIO) and is
>> more along the lines of buffered IO. If the IOP numbers are also using
>> some kind of caching, that could possibly taint them also. Does anyone
>> know if specifying DIO will really bypass all buffers or if something is
>> getting cached in the agents (iscsi, tgtd)?
>>
>>     
>
> Your question should be posted on linux-scsi.
> See the following link that explains about DIO
> http://tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html
>
> Please check with sgp_dd to avoid any caching.
>   

Well, I posted here because I was looking more at iSer characteristics 
than DIO. Things seemed to behave differently on iSer than what I'd 
expect and what srpt shows. Also, I have trust issues with sg*_dd. On 
the local box, they give me impossible numbers, whereas dd is where I'd 
expect it:
----
[root@test05 ~]# sgp_dd dio=1 if=/dev/zero of=/dev/fioa bs=512 bpt=2048 
count=16777216 time=1
time to transfer data was 5.556115 secs, 1546.03 MB/sec
[root@test05 ~]# sg_dd dio=1 if=/dev/zero of=/dev/fioa bs=512 bpt=2048 
count=16777216 time=1
time to transfer data: 5.565360 secs at 1543.46 MB/sec
[root@test05 ~]# dd oflag=direct if=/dev/zero of=/dev/fioa bs=1M count=8192
8589934592 bytes (8.6 GB) copied, 12.7761 seconds, 672 MB/s
----
Using iSer, with the small transfer chunks, sgp_dd has numbers that are 
in line with what I'd expect for DIO while sg_dd doesn't:
---------
sgp_dd: 200.64 MB/s
sg_dd:  735.42 MB/s
dd:     62.3 MB/s
--------
But for larger transfers (with 1M block transfers), both sgp_dd and 
sg_dd show well above what I think I can be getting:
-------
sgp_dd: 882.43
sg_dd:  819.89
dd:     731 MB/s #Which is still high, and which makes me suspect iSer
-------

The page Eli linked states "Direct IO support is designed in such a way 
that if it is requested and cannot be performed then the command will 
still be performed using indirect IO." So I'm wondering if for some 
reason here DIO can't be used with iSer? (BTW, /proc/scsi/sg/allow_dio is 1)
Cameron
