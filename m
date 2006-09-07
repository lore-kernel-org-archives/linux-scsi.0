From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_transport_sas: make minimum and maximum linkrate
 settable quantities
Date: Thu, 07 Sep 2006 11:56:31 -0400
Message-ID: <4500412F.7040805@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18667 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932228AbWIGP4h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 11:56:37 -0400
Received: from ip-9.59.99.216.dsl-cust.ca.inter.net ([216.99.59.9] helo=[192.168.48.80])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1GLMF1-0000tH-85
	for linux-scsi@vger.kernel.org; Thu, 07 Sep 2006 16:56:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I meant to cc this to the list ...


James Bottomley wrote:
> On Wed, 2006-09-06 at 23:38 -0400, Douglas Gilbert wrote:
>> James Bottomley wrote:
>>> According to SPEC, the minimum_linkrate and maximum_linkrate should be
>>                         ^                    ^
>>                     programmable       programmable
>>> settable by the user.  This patch introduces a callback that allows the
>>> sas class to pass these settings on to the driver.
>> There are also "hardware" variants of min/max_linkrate.
> 
> hardware rates represent the max and min capabilities of the hw ...
> they're not settable.
> 
>> Hmmm. I get a bit confused reading the above. Are you talking
>> about a SAS initiator that this machine controls (i.e. a "host"),
>> an expander phy in a visible SAS domain, a visible SSP target
>> (e.g. a SAS disk) and/or a visible SATA device? All of them?
>> Will all levels (i.e. initiator, expander and targets) have
>> these fields (if they exist) represented by an attribute
>> in sysfs?
> 
> I mean for all of the phys that are visible in the sysfs representation
> of the domain. Non expander end device phys aren't visible in our
> representation. 

I'm still confused. An attached phy either identifies itself
as an expander phy or an end device phy. So what is
the difference between a "non expander end device phy"
and a "end device phy"? [There can be SAS (virtual) phys
within an expander (e.g. associated with an enclosure
service target) but each SAS virtual phy is paired with
an expander virtual phy.]

Dropping the double negative I read your last sentence as
"Only expander phys are visible in our representation."

> However, this is irrelevant really, since it takes two
> phys to make a link, so if you force one side to a specific rate, the
> other must follow or fail the link negotiation.

True, as long as a phy at one end of the link allows
its programmable linkrates to be changed and a
link or hard reset to be instigated.

>> The SATA device is easy to rule out (as is a SATA port selector).
>> There may be some way of doing linkrate changes via the
>> SATA command set.
>>
>> SSP targets (e.g. SAS disks) have the "phy control and discover"
>> mode subpage. The SAS disks that I have examined (all from
>> one manufacturer) do not allow the programmable min/max_linkrate
>> fields to be changed by the user (i.e. the changeable
>> mode page bits are all zero). Worse still, their product
>> manuals say that both ports (phys) will negotiate the
>> same linkrate which will be the linkrate first attained.
>> Looking at the spec (sas2r05b section 10.2.7.2.3), it just
>> says all _other_ fields in that mode subpage shall not be
>> changeable. So your "should be settable" statement above
>> is a bit strong. How about "might be settable for SSP
>> targets".
> 
> The same one end follows the other should pertain even to SSP targets.
> I can't validate this, though, since I don't have any SATA-2 disks
> (SATA-1 can't negotiate speed, being fixed at 1.5GB).

I can connect a SATA disk that claims to do 3 Gbps
(Seagate 7200.9 series) directly to a LSIL HBA phy
and I can see:
# cat /sys/class/sas_phy/phy-4:0/negotiated_linkrate
3.0 Gbit

My 48300 (aic94xx based) HBA says in its BIOS that it
negotiates with all SATA disks at 1.5 Gbps. I believe
the SASx12 expander I have has the same restriction.

<snip>

>> Also folks playing with these fields should realize that
>> link reset is the appropriate type of reset to issue to
>> cause a linkrate change. A hard reset will do it as well
>> but may cause additional collateral damage. For example,
>> if any phy on a SAS target device does a hard reset
>> sequence, then all LUs within that target device receive
>> a LU reset: clearing out all SCSI commands in progress and
>> those pending. The idea with link reset is that only the link
>> layers and below are impacted, as longer of the renegotiation
>> succeeds in a timely fashion. Setting the prog_max_linkrate
>> to 1.5 Gbps at one end of physical link while setting the
>> prog_min_linkrate to 3 Gbps at the other end will cause
>> the renegotiation following a link reset to fail.
> 
> Yes, the setting algorithms do a link reset, if you look at the code ...
> and there's logic to prevent silly things like min going above max.

However the user may not want a link reset sent immediately.
For example, in SAS-2 with 6 Gbps available, to force 3 Gbps
the min_linkrate needs to be increased to 3 Gbps and the
max_linkrate needs to be decreased to 3 Gbps, then a reset
sent. It is also possible that the user may want a
(expander) phy's next negotiated link_rate changed but
the phy left disabled.


Building SAS discovery into the kernel SAS transport layer
might be a necessity now but it could cause problems down the
track. Consideration should be given to having a switch to
turn it off. SAS discovery in SAS-1 and SAS-1.1 does not
scale well with every SAS management client (i.e. the SAS
kernel transport layer) thinking that it has to do a full
or partial discovery of a potentially large SAS domain
every time a BROADCAST(CHANGE) event is received.
[BTW a link reset causes a BROADCAST(CHANGE) event so sending
more link resets than necessary will impact performance.]

In SAS-2 there are several improvements:
  - higher level SMP commands that move more data
    in one function (e.g. DISCOVER LIST)
  - much smarter expanders that can
     - self config and configure other (older) expanders
     - indicate to management clients when the are finished
     - more efficient routing tables (expander based rather
       than phy based)
     - support expander based zoning which will control the
       accessibility of end devices to one another.

Together these changes could relieve the burden of the SAS
discovery process on the SAS kernel transport layer. However
there seems nothing to stop such a kernel layer ploughing
ahead and doing discovery in the old inefficient way
making the worst case assumptions.

As ever finding the boot disk and root file system could be
a problem, but hopefully folks will soon be using flash
cards for that!

Doug Gilbert

