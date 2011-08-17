From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mpt2sas: /sysfs sas_address entries do not show individual port
 sas addresses.
Date: Wed, 17 Aug 2011 16:50:51 +0100
Message-ID: <4E4BE35B.8030504@mpstor.com>
References: <4E4B9B04.10302@mpstor.com> <4E4BDFD7.3060109@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay4.blacknight.com ([78.153.203.207]:37989 "EHLO
	relay4.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1HQPuz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 11:50:55 -0400
In-Reply-To: <4E4BDFD7.3060109@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian Caball <bc@mpstor.com>

On 17/08/11 16:35, Douglas Gilbert wrote:
> On 11-08-17 06:42 AM, Benjamin ESTRABAUD wrote:
>> Hi,
>>
>> I am seing a bug with the mpt2sas driver from the "Release 2.6.35.11" 
>> kernel
>> (commit d6c90f5b218c1ddf1496045e3939b1c960c7cb9f, tag v2.6.35.11, 
>> long term
>> support kernel).
>>
>> I have a system that has both a LSI 1068e B3 (3G) based HBA (a 
>> SAS3801E) as well
>> as a LSI SAS 2008 03 (6G) HBA (a SAS9200-8e). They both work as 
>> expected, but I
>> am seeing a major difference in their respective /sysfs structure, 
>> especially
>> regarding their phy's "sas_address" field, which seems to be a bug.
>>
>> The 3G HBA's SAS addresses are associated to a specific port in 
>> sysfs, while the
>> 6G one are associated to the actual HBA.
>>
>> The 3G HBA is configured to have two wide ports, made up of 4 phys 
>> each, port 0
>> and port 1, and same configuration applies for the 6G HBA.
>> The ports are not in "auto" nor in narrow.
>> There are only two enabled ports on each HBA.
>>
>>
>> I get the following sysfs entries regarding the 3G one:
>>
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:0/sas_phy\:phy-5\:0/sas_address
>> 0x50015b2a2000060f
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:1/sas_phy\:phy-5\:1/sas_address
>> 0x50015b2a2000060f
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:2/sas_phy\:phy-5\:2/sas_address
>> 0x50015b2a2000060f
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:3/sas_phy\:phy-5\:3/sas_address
>> 0x50015b2a2000060f
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:4/sas_phy\:phy-5\:4/sas_address
>> 0x50015b2a20000613
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:5/sas_phy\:phy-5\:5/sas_address
>> 0x50015b2a20000613
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:6/sas_phy\:phy-5\:6/sas_address
>> 0x50015b2a20000613
>> # cat 
>> /sys/class/sas_host/host5/device/phy-5\:7/sas_phy\:phy-5\:7/sas_address
>> 0x50015b2a20000613
>>
>> And these ones on the 6G:
>>
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:0/sas_phy\:phy-0\:0/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:1/sas_phy\:phy-0\:1/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:2/sas_phy\:phy-0\:2/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:3/sas_phy\:phy-0\:3/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:4/sas_phy\:phy-0\:4/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:5/sas_phy\:phy-0\:5/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:6/sas_phy\:phy-0\:6/sas_address
>> 0x500605b002c99150
>> # cat 
>> /sys/class/sas_host/host0/device/phy-0\:7/sas_phy\:phy-0\:7/sas_address
>> 0x500605b002c99150
>>
>> As we can see above, the 3G HBA's phy "sas_address" sysfs entry 
>> displays correct
>> information: A single SAS address for phy 0-3 and a single one for 
>> phy 4-7.
>>
>> As we can also see using LSIUtil, each phy is numbered from a base 
>> address and
>> incremented.
>> Also, the port sas address corresponds to the address of the starting 
>> phy of the
>> port.
>> Port0's sas address is "0x50015b2a2000060f", which corresponds to the 
>> HBA's phy0
>> sas address.
>> Port1's sas address is "0x50015b2a20000613" which corresponds to the 
>> HBA's phy3
>> sas address, the starting phys for each of these ports.
>>
>> Output of menu "16" from LSIUtil on the 3G HBA (1068e):
>>
>> B___T SASAddress PhyNum Handle Parent Type
>> 50015b2a2000060f 0001 SAS Initiator
>> 50015b2a20000610 0002 SAS Initiator
>> 50015b2a20000611 0003 SAS Initiator
>> 50015b2a20000612 0004 SAS Initiator
>> 50015b2a20000613 0005 SAS Initiator
>> 50015b2a20000614 0006 SAS Initiator
>> 50015b2a20000615 0007 SAS Initiator
>> 50015b2a20000616 0008 SAS Initiator
>>
>> However, when looking at the 6G HBA's sysfs information above, we can 
>> see that
>> all phy's SAS address are identical, like if there was a single port 
>> made up of
>> the entire 8 phys from the HBA.
>>
>> When looking at LSIUtil below, we get more strangeness, where all 
>> phys have
>> exactly the same SAS address:
>>
>> Output of menu "16" from LSIUtil on the 6G HBA (2008):
>>
>> B___T SASAddress PhyNum Handle Parent Type
>> 500605b002c99150 0001 SAS Initiator
>> 500605b002c99150 0002 SAS Initiator
>> 500605b002c99150 0003 SAS Initiator
>> 500605b002c99150 0004 SAS Initiator
>> 500605b002c99150 0005 SAS Initiator
>> 500605b002c99150 0006 SAS Initiator
>> 500605b002c99150 0007 SAS Initiator
>> 500605b002c99150 0008 SAS Initiator
>>
>> But looking at LSIUtil's menu "13" on the 6G HBA proves that we 
>> indeed have 2
>> ports on that HBA:
>>
>> PhyNum Link MinRate MaxRate Initiator Target Port
>> 0 Enabled 1.5 6.0 Enabled Disabled 0
>> 1 Enabled 1.5 6.0 Enabled Disabled 0
>> 2 Enabled 1.5 6.0 Enabled Disabled 0
>> 3 Enabled 1.5 6.0 Enabled Disabled 0
>> 4 Enabled 1.5 6.0 Enabled Disabled 1
>> 5 Enabled 1.5 6.0 Enabled Disabled 1
>> 6 Enabled 1.5 6.0 Enabled Disabled 1
>> 7 Enabled 1.5 6.0 Enabled Disabled 1
>>
>> Somehow, on the 6G HBA using mpt2sas, all phys from a HBA seem to 
>> have the same
>> SAS address, and all ports on that HBA, whether narrow (1Phy) or wide 
>> (4Phys),
>> will seemingly have the same SAS address.
>>
>> This is causing a good few issues with our system scripting, as we 
>> relied on SAS
>> addresses to identify ports.
>>
>> I searched on Google extensively before posting and couldn't find any 
>> mention of
>> this issue.
>>
>> Is this a known issue? If so, will this be resolved in a later 
>> version of the
>> driver?
>
> Ben,
> I noticed something similar when comparing LSI 3 Gbps and
> 6 Gbps SAS HBAs. I was looking at the same thing but from
> an expander's perspective. I'm not so sure that the newer
> 6 Gbps HBAs are incorrect. IOW the older 3 Gbps HBAs might
> be playing some tricks with the HBA's SAS addresses so that
> it is not possible to set up a wide link spanning the
> lower and upper 4-phy banks (e.g. a 5 phy wide link).
>
Hi Doug,

Thanks a lot for your reply!

It is very possible indeed that this was done so that nobody would ever 
try to have an 8phy SAS port (possible because it couldn't handle it?), 
or as you said, a port spanning on 5Phys or spanning phys from two 
different physical ports.

Because we worked mainly with these HBAs (the 3G ones), we assumed that 
this was the norm in SAS: one port is issued a unique SAS address. We 
therefore assume that a port always has a unique SAS address and work 
that way, which, I find today, is probably a wrong assertion.
> Do you know a reason why it is not preferably for every
> phy on a SAS HBA to respond with the same SAS address?
>
No real reason here, we just were working with a wrong assumption (that 
port sas addresses had to be unique) before. We need to update our 
scripts to work with ports having the same SAS address.
>
> As a practical matter a SAS HBA needs a single SAS address,
> preferably printed on the board or its box. Then if you
> manage to wipe its SAS address (e.g. by erasing its flash
> to move from IR to IT firmware) then you know which SAS
> address to re-instate :-)
>
LSIUtil's "Set new WWN/SAS Address" menu (and even on 6G HBA!) will 
request the input of a single sas address, and will set each sas phy's 
address differently by incrementing the user-inputed sas address. This 
could also be happening because LSIUtil might not have been updated 
fully yet.

In fact, LSIUtil and the MPT Fusion driver used to find a HBA's sas 
address by doing something in the like of ioc->port->phy[0]->sas_address 
(low and high), rather than reading a single ioc->sas_address value.

Thanks again for your reply, you helped me clarify some bits here.
> Doug Gilbert
>
Regards,
Ben.
