From: augustus@linuxhardware.org
Subject: RE: Fusion-MPT much faster as module
Date: Thu, 31 Mar 2005 13:59:50 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0503311359360.3702@penguin.linuxhardware.org>
References: <91888D455306F94EBD4D168954A9457C01AEAC93@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from penguin.linuxhardware.org ([63.173.68.170]:47056 "EHLO
	penguin.linuxhardware.org") by vger.kernel.org with ESMTP
	id S261680AbVCaSyw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 13:54:52 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C01AEAC93@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Andrew Morton <akpm@osdl.org>, Holger Kiehl <Holger.Kiehl@dwd.de>, linux-scsi@vger.kernel.org

Any word on this bug yet?

Thanks,
Kris Kersey (Augustus)
LinuxHardware.org Site Manager
augustus@linuxhardware.org
Gentoo Linux AMD64 Developer
augustus@gentoo.org

On Mon, 21 Mar 2005, Moore, Eric Dean wrote:

> Sorry for delay in responding.
> We at LSI Logic are looking into these reports
> of poor performance coming from the U320.
> I will report later.
>
> Eric Moore
> LSI Logic
>
>
> On Monday, March 21, 2005 4:27 PM, Andrew Morton wrote:
>>
>>
>> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>>>
>>> Hello
>>>
>>> On a four CPU Opteron compiling the Fusion-MPT as module
>> gives much better
>>> performance when compiling it in, here some bonnie++ results:
>>>
>>> Version  1.03       ------Sequential Output------
>> --Sequential Input- --Random-
>>>                      -Per Chr- --Block-- -Rewrite- -Per
>> Chr- --Block-- --Seeks--
>>> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP
>> K/sec %CP  /sec %CP
>>> compiled in  15872M 38366 71  65602  22 18348   4 53276 84
>> 57947   7 905.4   2
>>> module       15872M 51246 96 204914  70 57236  14 59779 96
>> 264171  33 923.0   2
>>>
>>> This happens with 2.6.10, 2.6.11 and 2.6.11-bk2. Controller is a
>>> Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI.
>>>
>>> Why is there such a large difference?
>>>
>>
>> Holger, this problem remains unresolved, does it not?  Have
>> you done any
>> more experimentation?
>>
>> I must say that something funny seems to be happening here.
>> I have two
>> MPT-based Dell machines, neither of which is using a modular driver:
>>
>>
>> akpm:/usr/src/25> 0 hdparm -t /dev/sda
>>
>> /dev/sda:
>>  Timing buffered disk reads:  64 MB in  5.00 seconds = 12.80 MB/sec
>>
>> That's a bit disappointing.  Running 2.6.9-rc2-mm2(!) with a
>>
>>  SCSI storage controller: LSI Logic / Symbios Logic 53c1030 (rev 07)
>>
>> controller on disks which shudl hit 50MB/sec.
>>
>>
>>
>>
>> And
>>
>> bix:/home/akpm# hdparm -t /dev/sda
>>
>> /dev/sda:
>>  Timing buffered disk reads:  114 MB in  3.03 seconds =  37.57 MB/sec
>>
>> with 2.6.11-rc4-mm1 using
>>
>> Fusion MPT SCSI Host driver 3.01.16
>> scsi0 : ioc0: LSI53C1030, FwRev=01030600h, Ports=1, MaxQ=222, IRQ=25
>> scsi1 : ioc1: LSI53C1030, FwRev=01030600h, Ports=1, MaxQ=222, IRQ=26
>> Vendor: SEAGATE   Model: ST3146807LW       Rev: DS09
>> Type:   Direct-Access                      ANSI SCSI revision: 03
>>
>> Better, but again I'd expect >50MB/sec.
>>
>
