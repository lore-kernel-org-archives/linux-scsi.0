From: Douglas Gilbert <dougg@torque.net>
Subject: Re: no INQUIRY from userspace please
Date: Tue, 19 Feb 2008 15:53:38 -0500
Message-ID: <47BB41D2.2070209@torque.net>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>	 <20080124003203.18871.52040.sendpatchset@localhost.localdomain>	 <1202151498.3096.84.camel@localhost.localdomain>	 <1202156151.13537.14.camel@linuxchandra>	 <1202156914.3096.112.camel@localhost.localdomain>	 <47A8C14A.3030207@cs.wisc.edu> <20080205215657.GA20963@linux.vnet.ibm.com>	 <47AAD898.30004@s5r6.in-berlin.de> <1202396490.3171.8.camel@localhost.localdomain> <47AB3A53.2030907@s5r6.in-berlin.de> <47AB3C47.6060805@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <47AB3C47.6060805@s5r6.in-berlin.de>
Sender: linux-hotplug-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
>> James Bottomley wrote:
>>> It's all very well to say this, but I think if you look at what udev
>>> does, you'll find that it uses scsi_id to send a VPD inquiry to the
>>> device so it can populate /dev/disk/by-id, so the point is already
>>> conceded
> 
> PS:  Alas we don't have a practicable way to know how many of the
>   - doesn't work with Linux but works to some degree with Windows,
>   - doesn't work with a 2.6 based Linux distro but did work with a
>     2.4 based distro
> kinds of devices are those with this INQUIRY bug or similar bugs.
> 
> While non-udev distros slowly went out of fashion on the desktop, there
> was a certain frequency of reports of the latter kind of FireWire
> devices, but this was before I became aware of that kind of firmware
> bug, therefore I don't have any data whether it played a role for these
> cases.

Just a small point here. To my knowledge all devices
that understand the SCSI command set will accept a
36 byte INQUIRY (i.e. an INQUIRY with an "allocation length"
of 36). That is a practical consideration since they would
crash on Windows otherwise.

Now scsi_id (and probably other programs of that ilk
(including some of mine)) get excited when they get a
response to a "36 byte" INQUIRY and go onto ask for
VPD page 0x80 (serial number) or page 0x83 (device id)
via an INQUIRY command with the EVPD bit set.
Now if they were clever they would make sure that
the "allocation length" of the _first_ such VPD inquiry
was 36! That way they could have a close look at the
response and if it wasn't valid for a VPD page
(e.g. requested_VPD_page_num != response[1]) then
they would leave the damn device alone **.

<<< Special case: removable media >>>
Since response[1] of a standard INQUIRY has RMB (removable
medium bit) set in its top bit and the rest of the byte
reserved, 0x80 is a possibility. That could give a
false positive when the serial number VPD page is
requested. So try looking for VPD page 0x83 (with
alloc_len=36) first.


** The logic here is that a brain dead SCSI target
interpreter doesn't look at the EVPD bit and can
only handle an "allocation length" of 36. So if
it receives an INQUIRY cdb with the EVPD bit set
it will just respond with its standard INQUIRY
response.

Doug Gilbert
