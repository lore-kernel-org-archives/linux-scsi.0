From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mpt2sas: /sysfs sas_address entries do not show individual port
 sas addresses.
Date: Fri, 19 Aug 2011 13:30:56 +0100
Message-ID: <4E4E5780.5000705@mpstor.com>
References: <4E4B9B04.10302@mpstor.com> <4E4BDFD7.3060109@interlog.com> <4E4D529F.9090908@oracle.com> <4E4D6D78.6040106@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay4.blacknight.com ([78.153.203.207]:53972 "EHLO
	relay4.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1HSMa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2011 08:30:59 -0400
In-Reply-To: <4E4D6D78.6040106@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Ravi Shankar <ravi.v.shankar@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 18/08/11 20:52, Douglas Gilbert wrote:
> On 11-08-18 01:57 PM, Ravi Shankar wrote:
>>
>>>
>>>
>>> Do you know a reason why it is not preferably for every
>>> phy on a SAS HBA to respond with the same SAS address?
>>>
>>>
>>> As a practical matter a SAS HBA needs a single SAS address,
>>> preferably printed on the board or its box. Then if you
>>> manage to wipe its SAS address (e.g. by erasing its flash
>>> to move from IR to IT firmware) then you know which SAS
>>> address to re-instate :-)
>>>
>> HBA SAS phy could have same SAS address when they are directly 
>> connected.
>> however when connected to expanders, each logical port/phy need 
>> unique SAS
>> address.
>
> No.
>
> SAS HBAs and expanders should always be trying to maximize
> the width of a link. By definition all physical ** phys on an
> expander should (must) have the same SAS address. So if
> you connect 5 phys from a SAS HBA to the same expander (and
> the HBA supports links wider than 4 phys) then those
> 5 HBA phys should have the same SAS address. Those 5 HBA
> phys then form a SCSI port.
>
> Just tested a triangular arrangement: a LSI SAS-2 HBA
> (9212-4i4e) connected to one SAS-2 expander (4 phy wide link)
> and one SAS-1 expander (narrow link). And the expanders
> where connected to each other. Two disks were connected
> to the SAS-2 expander.
> Both expanders reported the same SAS address for the
> 5 HBA attached phys. You might argue that is two
> separate SCSI initiator ports with the same port
> identifier (SAS address) in the same SAS domain.
>
> Anyway there was an interesting difference between the HBA's
> BIOS and Linux (lk 3.0.3): the BIOS reported those two
> disks twice while Linux only reported them once. That seems
> to suggest that the BIOS set up the routing table in the
> SAS-1 expander while Linux did not. smp_discover in Linux
> confirms that the SAS-1 expander's route table was not set up.
>
> The trouble with testing is that is raises more questions
> than it supplies answers.
>
>
> SAS disks have two phys which are typically given two
> different SAS addresses. This stops them forming a wide link
> if, for example, they were both connected to the same
> expander. Typically the two SAS disk phys would be connected
> to different expanders for redundancy. However if the
> interest was speed (e.g. with a SAS SSD) then both the
> disk phys might be given the same SAS address.
>
>
> ** SAS-2 expanders often have an integrated SES target
>    on a virtual phy in the expander chip, and that
>    virtual phy has a different SAS address.
>
> Doug Gilbert
>
>
> P.S. Why is my post cc-ing to "unlisted-recipients:;"
>

Hi Douglas, Ravi,

According to the SAS specs, (ISO/IEC 14776-152:200x, sas2r15.pdf), on 
page 45, they state that that a port is formed by a unique tuple of the 
SAS Phy address and the attached SAS Phy address.

For instance, if you take 2 * 2 phy wide ports, where all 4 phys from 
these two ports have the same sas address, let's call it "A" and connect 
them each to another port that each has a different address, "B" and 
"C", they state that two ports will be formed, one connecting "A" to "B" 
and one connecting "A" to "C".

This is what Douglas is saying with the SAS disks for instance, that are 
typically given two separate SAS addresses to avoid forming a wide port 
with the expander (since the expander will have the same sas address on 
all phys), and to allow for dual expander multiplexing for redundancy.

But what I don't understand is that, in the context of two HBAs 
connected together, things seem to be different:

I configured a 9200-8e HBA (8Phys) and changed all its SAS phys 
addresses from being the same to being incremental, therefore the last 
byte of each SAS phy address changed from:

0   1   2   3   4   5   6   7
b0 b0 b0 b0 b0 b0 b0 b0
to:
b0 b1 b2 b3 b4 b5 b6 b7

I also changed the "ports" setup from "Auto" to "Wide", making two 
4*phys ports:

     Port 0       |      Port 1
b0 b1 b2 b3 | b4 b5 b6 b7

I also set all these ports to Target.

I then connected this HBA to another 9200-8e HBA, which was left setup 
as default:

               Auto
               Initiator
0   1   2   3   4   5   6   7
10 10 10 10 10 10 10 10

However, when I looked up the SAS topology on either side in LSIUtil, I 
saw that there was two ports connected on each HBAs, one connected on 
phy 0 and one on phy 4.

On the second (Initiator) HBA, the two ports appeared as b0 and b4, with 
two separate handles.

On the first (Target) HBA, both ports appeared as 10, with two separate 
handles.

What I don't understand above, is since all phys on the Target HBAs have 
a different SAS address, and all the ones on the Initiator one have the 
same, 8 narrow ports should have been created there.

However, there is a separate notion of "port" in LSIUtil, does that mean 
that agglomerating 4 phys with different SAS addresses in a logical 
LSIUtil "port" forces the HBA FW to transmit the same sas address on 
these 4 Phys, to make them look like a single port? Or is there an extra 
separate notion of "port", that does not rely on the phy SAS address and 
its attached SAS address?

I guess my question is: Is there an extra information ontop of phy sas 
address and phy id that is transmitted in SAS, like a "port" id or a handle?

Also, in the above case, if we assume that the HBA FW was transmitting 
the same phys for phy 0-3 and phy 4-8 on the Target HBA, it would make 
sense that we have two ports, since there is two pairs of SAS addresses 
/ attached SAS addresses here.

Am I holding on to the right belief?

Thanks in advance for your reply.

Regards,
Ben.

PS: The "Undisclosed recipient" was because Ravi seemed to have replied 
with a hidden "To:" and CC'ed to the linux-scsi ML.
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

