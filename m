From: Ravi Shankar <ravi.v.shankar@oracle.com>
Subject: Re: mpt2sas: /sysfs sas_address entries do not show individual port
 sas addresses.
Date: Fri, 19 Aug 2011 12:06:42 -0700
Message-ID: <4E4EB442.20903@oracle.com>
References: <4E4B9B04.10302@mpstor.com> <4E4BDFD7.3060109@interlog.com> <4E4D529F.9090908@oracle.com> <4E4D6D78.6040106@interlog.com> <4E4E5780.5000705@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:43040 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1HSTG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2011 15:06:56 -0400
In-Reply-To: <4E4E5780.5000705@mpstor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>, dgilbert@interlog.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


>
> Hi Douglas, Ravi,
>
> According to the SAS specs, (ISO/IEC 14776-152:200x, sas2r15.pdf), on 
> page 45, they state that that a port is formed by a unique tuple of 
> the SAS Phy address and the attached SAS Phy address.
>
> For instance, if you take 2 * 2 phy wide ports, where all 4 phys from 
> these two ports have the same sas address, let's call it "A" and 
> connect them each to another port that each has a different address, 
> "B" and "C", they state that two ports will be formed, one connecting 
> "A" to "B" and one connecting "A" to "C".
>
> This is what Douglas is saying with the SAS disks for instance, that 
> are typically given two separate SAS addresses to avoid forming a wide 
> port with the expander (since the expander will have the same sas 
> address on all phys), and to allow for dual expander multiplexing for 
> redundancy.
>
> But what I don't understand is that, in the context of two HBAs 
> connected together, things seem to be different:
>
> I configured a 9200-8e HBA (8Phys) and changed all its SAS phys 
> addresses from being the same to being incremental, therefore the last 
> byte of each SAS phy address changed from:
>
> 0   1   2   3   4   5   6   7
> b0 b0 b0 b0 b0 b0 b0 b0
> to:
> b0 b1 b2 b3 b4 b5 b6 b7
>
> I also changed the "ports" setup from "Auto" to "Wide", making two 
> 4*phys ports:
>
>     Port 0       |      Port 1
> b0 b1 b2 b3 | b4 b5 b6 b7
>
> I also set all these ports to Target.
>
> I then connected this HBA to another 9200-8e HBA, which was left setup 
> as default:
>
>               Auto
>               Initiator
> 0   1   2   3   4   5   6   7
> 10 10 10 10 10 10 10 10
>
> However, when I looked up the SAS topology on either side in LSIUtil, 
> I saw that there was two ports connected on each HBAs, one connected 
> on phy 0 and one on phy 4.
>
> On the second (Initiator) HBA, the two ports appeared as b0 and b4, 
> with two separate handles.
>
> On the first (Target) HBA, both ports appeared as 10, with two 
> separate handles.
>
> What I don't understand above, is since all phys on the Target HBAs 
> have a different SAS address, and all the ones on the Initiator one 
> have the same, 8 narrow ports should have been created there.
>
> However, there is a separate notion of "port" in LSIUtil, does that 
> mean that agglomerating 4 phys with different SAS addresses in a 
> logical LSIUtil "port" forces the HBA FW to transmit the same sas 
> address on these 4 Phys, to make them look like a single port? Or is 
> there an extra separate notion of "port", that does not rely on the 
> phy SAS address and its attached SAS address?
>
> I guess my question is: Is there an extra information ontop of phy sas 
> address and phy id that is transmitted in SAS, like a "port" id or a 
> handle?
>
> Also, in the above case, if we assume that the HBA FW was transmitting 
> the same phys for phy 0-3 and phy 4-8 on the Target HBA, it would make 
> sense that we have two ports, since there is two pairs of SAS 
> addresses / attached SAS addresses here.
>
Ben,

Port 0       |      Port 1
b0 b1 b2 b3 | b4 b5 b6 b7

In above configuration you are assigning different SAS Address for each 
PHY but over riding with WIDE port clause. After
individual PHY are reset, it transmits IDENTIFICATION address frames as 
part of identification sequence so down stream devices
know the attributes of the attached devices.

PHY 0-3: Transmit Identification frame with SAS address xxxxxxxxb0

PHY 4-7: Transmit identification frame with SAS address xxxxxxxxb4

The second HBA (with SAS address xxxxxxxx10 with Auto mode) receives 
above identification frame on PHY 0-3 and 4-7 respectively. So this
essentially forms x4 wide port instead of narrow as you expected.

As far I know there are no port id or handle transmitted on the fabric.

Couple of interesting question regarding wide port. From bandwidth 
perspective, x4 port are termed as 24 Gb/sec ( 6 Gb/s * 4). But do we
really get 24 Gb/sec bandwidth ?. I see questions being raised that SSD 
disks need wide ports for bandwidth aggregation. SAS protocol
and Expander has following limitation which could be problematic 
depending on topology.

1) Unlike FC, SAS is a connection oriented protocol (full duplex Class 1 
vs Class 3 FC)
2) Flow control primitives (K words) are transmitted inside connection 
(without being packetized).
3) When connecting through Expanders, typically only x4 or x8 physical 
links are used. If there are hundreds of Initiator/Target exist in such
     fabric, the number of active I/O transfers across devices are 
limited to number of links between Expanders (due to Class 1 protocol).

My understanding for SSD disks with wide ports the HBA and Disks can 
queue several commands using Tagged Queuing. This way we can
maximize number of  commands and data frames across devices.

Wondering has anyone measured performance under such scenario ?. It 
would be great to see Expanders terminating SSP frames to over come
some of above limitation. Links between HBA and Expander and Expander to 
Disk can be still Class 1.





