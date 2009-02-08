From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] Kernel crashes on login
Date: Sun, 08 Feb 2009 15:58:55 +0200
Message-ID: <498EE51F.4060800@panasas.com>
References: <20090202131502.GH30821@kernel.dk>	<49872DF3.3060401@panasas.com><20090202185345.GM30821@kernel.dk>	<4987E55F.4000606@panasas.com>	<593CDB54C2F1144FB3E10F1D80057621163F47@hanvsmail04.eu.thmulti.com> <498E9A40.6050404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3430 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752117AbZBHN7A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 08:59:00 -0500
In-Reply-To: <498E9A40.6050404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fuerst Lars <lars.fuerst@thomson.net>
Cc: osd-dev@open-osd.org, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> Fuerst Lars wrote:
>> Hello Boaz,
>>
>> I try to use your kernel initiator in combination with the OSC osd2
>> target. The target (FC 9, 2.6.26.5-45.fc9.x86_64) works fine with the
>> user space initiator from osc, but when i use your initiator (in tree
>> build 2.6.29-rc1-9) i get a failure after login:
>>
>> # iscsiadm -m node -p 141.11.96.100 -T render01crh --login
>> Logging in to [iface: default, target: render01crh, portal:
>> 141.11.96.100,3260]
>> iscsiadm: got read error (0/0), daemon died?
>>
>> iscsiadm: Could not login to [iface: default, target: render01crh,
>> portal: 141.11.96.100,3260]: 
>> iscsiadm: initiator reported error (18 - could not communicate to
>> iscsid)  
>>
>> kernel log says:
>>
>> [..]
>> Feb  5 14:29:16 render02crh kernel: osd:
>> OSD_ATTR_RI_VENDOR_IDENTIFICATION [<NULL>]
>>
>> Feb  5 14:29:16 render02crh kernel: osd:
>> OSD_ATTR_RI_PRODUCT_IDENTIFICATION [<NULL>]
>>
>> Feb  5 14:29:16 render02crh kernel: osd: OSD_ATTR_RI_PRODUCT_MODEL
>> [<NULL>]                                                             
>> Feb  5 14:29:16 render02crh kernel: BUG: unable to handle kernel NULL
>> pointer dereference at (null)                                     
>> Feb  5 14:29:16 render02crh kernel: IP: [<ffffffffa3114aa3>]
>> _osd_print_system_info+0x177/0x29b [libosd]
>>
>> Feb  5 14:29:16 render02crh kernel: PGD 6ad4d067 PUD 785d5067 PMD 0
>>
>> Feb  5 14:29:16 render02crh kernel: Oops: 0000 [#1] SMP
>>
>> Feb  5 14:29:16 render02crh kernel: last sysfs file:
>> /sys/devices/platform/host5/scsi_host/host5/scan
>> [..]
>>
>> Complete log and kernel config is attached. It seems to be a problem
>> during the osd auto detection. Do you have an idea?
>>
>> Thanks in advance
>>
>> Regards,
>>
>> Lars
> 
> Thanks Lars, It should not crash, I'll fix that ASAP
> 
> But please use the OSC's target from the open-osd.org
> git trees. Please follow the instructions in this page:
> http://www.open-osd.org/bin/view/Main/OscOsdProject
> Specifically the "How to get started" section.
> This will also automatically fetch the tgt module with all
> the right patches applied. So it should be easier to use.
> 
> The original version is missing some mandatory attributes
> and other incompatibilities with OSD2 been crafted on draft
> 01, when currently we're on draft 04d.
> 
> But sorry I should have checked that. Code should not crash
> ever.
> 
> I'll send a fix today.
> 
> Boaz
> 

Nice things about having some users is that they get to find
your bugs ;) . Thanks Lars

Some project History:

  At git://git.open-osd.org/osc-osd, our OSC's osd-target git tree,
there are a couple of fixes and enhancements over the latest source
code from OSC's internal SVN.

  Prior to that when we first started to use OSC's target we sent to
Pete and Anath fixes regarding none conforming behavior with regard
to attributes. The tar balls that where public on the net at the time
had these short comings. 

Lars are you using the old tar balls, I thought they where removed
from the net around the time Pete left OSC. (By accident)

The latest SVN code included our fixes, (and did not fully compile).
Are only publicly available on above git in the "osc" branch.
I have tested with that version and it does not crash so it might
be that you are using the old tar balls. In that case even with my
patch to fix the crash, attributes will not work at all and you will
not be able to work with open-osd initiator. :-(

It is strongly recommended that you upgrade to the open-osd version of
OSC's osd-target. (It also includes a matching OSC's osd-initiator)

I'm sending a patch as it's own email thread to James for inclusion
into 2.6.30.

Thank you for trying out and helping with the open-osd initiator.

Boaz
