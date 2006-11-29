From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx panic on module load
Date: Wed, 29 Nov 2006 11:30:31 -0500
Message-ID: <456DB5A7.40503@torque.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>	 <456C83A2.8020507@torque.net>	 <1164750379.21827.26.camel@markh3.pdx.osdl.net>	 <1164755862.21827.28.camel@markh3.pdx.osdl.net>	 <456CE7D9.9000704@torque.net> <1164813403.32583.3.camel@markh3.pdx.osdl.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56014 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S967471AbWK2Qam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 11:30:42 -0500
In-Reply-To: <1164813403.32583.3.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, djwong@us.ibm.com, ltuikov@yahoo.com, Eric.Moore@lsi.com

Mark Haverkamp wrote:
> On Tue, 2006-11-28 at 20:52 -0500, Douglas Gilbert wrote:
>> Mark Haverkamp wrote:
>>> On Tue, 2006-11-28 at 13:46 -0800, Mark Haverkamp wrote:
>>>> On Tue, 2006-11-28 at 13:44 -0500, Douglas Gilbert wrote:
>>>>
>>>> [ ... ]
>>>>
>>> I don't know if this helps, but I found the verbose option.  Here is a
>>> little debug output.
>>>
>>>
>>> ./smp_discover -vvvvvvvvv  -p 12 -s 0x500508b300a27a2f /dev/mptctl
>>>     Discover request: 40 10 00 02 00 00 00 00 00 0c 00 00 00 00 00 00
>>> send_req_mpt: subvalue=0  SAS address=0x500508b300a27a2f
>>>     mptctl two scatter gather list interface
>>> IOCStatus=0x1
>>> IOCStatus=0x1 IOCLogInfo=0xA27A2F SASStatus=0x0
>>> smp_send_req failed, res=-1
>> Mark,
>> The iocnum may be greater than 0 (especially if you have
>> other MPT Fusion HBAs (any kind) in that computer).
>> Have a look in the log around where the mptsas driver
>> is registered and look for the string "ioc". The number
>> following "ioc" is what you need. If you find "ioc3" then
>> try:
>>
>>  ./smp_discover -p 12 -s 0x500508b300a27a2f /dev/mptctl,3
> 
> OK thanks, I do have an mptspi card too. 
>  
> # ./smp_discover -vvvvvvvvv  -p 12 -s 0x500508b300a27a2f /dev/mptctl,2
>     Discover request: 40 10 00 02 00 00 00 00 00 0c 00 00 00 00 00 00
> send_req_mpt: subvalue=2  SAS address=0x500508b300a27a2f
>     mptctl two scatter gather list interface
> Discover response:
>   expander change count: 0
>   phy identifier: 12
>   attached device type: end device
>   negotiated physical link rate: phy enabled; 3 Gbps
               ^^^^^^^^
A "heads up" here. the "physical" has now be changed
to "logical" in SAS-2. The idea is that up to 4
logical 1.5 Gbps links (e.g. to SATA disks) can be
multiplexed on one 6 Gbps physical link.

>   attached initiator: ssp=0 stp=0 smp=0 sata_host=0
>   attached sata port selector: 0
>   attached target: ssp=0 stp=1 smp=0 sata_device=0
>   SAS address: 0x500508b300a27a2f
>   attached SAS address: 0x500508b300a27a2c
>   attached phy identifier: 0
>   attached inside ZPSDS persistent: 0
>   attached requested inside ZPSDS: 0
>   attached break_reply capable: 0
>   programmed minimum physical link rate: 3 Gbps
>   hardware minimum physical link rate: 3 Gbps
>   programmed maximum physical link rate: 3 Gbps
>   hardware maximum physical link rate: 3 Gbps
>   phy change count: 105
>   virtual phy: 1
>   partial pathway timeout value: 7 us
>   routing attribute: direct
>   connector type: No information
>   connector element index: 0
>   connector physical link: 0

Mark,
Finally ...
So the above is somewhat strange as it indicates a STP target but
not a SATA device. The phy is also flagged as virtual which means
that target port is within the expander.

So my guess is that the mptsas driver (or firmware) skips that
device while the aic94xx driver tries to set it up as a SATA
target and falls off the rails (naturally it shouldn't oops).

Hopefully Luben chips in here with what should happen ...

>> To verify that expander SAS address, try this:
>>   find /sys -name "sas_device:expander*"
>> cd to any directory found and try "cat sas_address".
> 
> 0x500508b300a27a2f
> 
>>
>> BTW there is a smp_utils version 0.92 beta at
>> http://www.torque.net/sg
>> the error messages are somewhat clearer.

Eric Moore pointed out to me that the ioc_num can also be
found in /proc/scsi/mptsas/<host_no> and
/sys/class/scsi_host/host<n>/unique_id
so I have updated the smp_utils documentation.


So this is an instructive case of using one manufacturer's
HBA and driver to debug a driver for another manufacturer's
HBA.

Doug Gilbert

