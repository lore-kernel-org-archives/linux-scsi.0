From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx panic on module load
Date: Tue, 28 Nov 2006 13:44:50 -0500
Message-ID: <456C83A2.8020507@torque.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58583 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1758744AbWK1SpB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 13:45:01 -0500
In-Reply-To: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, djwong@us.ibm.com

Mark Haverkamp wrote:
> I got this panic when loading the aic94xx module.  The adapter is
> connected to an HP MSA50 SAS enclosure with 3 72GB SAS disks.
> 
> Kernel 2.6.19-rc6-scsi-misc on an x86_64
> 
> ---
> 
> 
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
> aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:08:01.0
> aic94xx: BIOS present (1,2), 1673
> aic94xx: ue num:3, ue size:88
> aic94xx: manuf sect SAS_ADDR 50000d100045af00
<snip>

> sas: phy1 matched wide port0
> sas: phy1 added to port0, phy_mask:0x3
> sas: phy2 matched wide port0
> sas: phy2 added to port0, phy_mask:0x7
> sas: phy3 matched wide port0
> sas: phy3 added to port0, phy_mask:0xf
> sas: DOING DISCOVERY on port 0, pid:3524
> sas: ex 500508b300a27a2f phy00:T attached: 500508b300a27a3f
> sas: ex 500508b300a27a2f phy01:T attached: 500508b300a27a3f
> sas: ex 500508b300a27a2f phy02:T attached: 0000000000000000
> sas: ex 500508b300a27a2f phy03:T attached: 0000000000000000
> sas: ex 500508b300a27a2f phy04:S attached: 50000d100045af00
> sas: ex 500508b300a27a2f phy05:S attached: 50000d100045af00
> sas: ex 500508b300a27a2f phy06:S attached: 50000d100045af00
> sas: ex 500508b300a27a2f phy07:S attached: 50000d100045af00
> sas: ex 500508b300a27a2f phy08:T attached: 0000000000000000
> sas: ex 500508b300a27a2f phy09:T attached: 0000000000000000
> sas: ex 500508b300a27a2f phy10:T attached: 0000000000000000
> sas: ex 500508b300a27a2f phy11:T attached: 0000000000000000
> sas: ex 500508b300a27a2f phy12:D attached: 500508b300a27a2c
> sas: ex 500508b300a27a3f phy00:D attached: 5000c5000095f8b5
> sas: ex 500508b300a27a3f phy01:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy02:D attached: 5000c5000095d3b5
> sas: ex 500508b300a27a3f phy03:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy04:D attached: 5000c5000095c0b9
> sas: ex 500508b300a27a3f phy05:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy06:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy07:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy08:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy09:D attached: 0000000000000000
> sas: ex 500508b300a27a3f phy10:S attached: 500508b300a27a2f
> sas: ex 500508b300a27a3f phy11:S attached: 500508b300a27a2f
> sas: task finished with resp:0x0, stat:0x89
> sas: sas_discover_sata() for device 500508b300a27a2c at 500508b300a27a2f:0xc returned 0xffffff06
> kobject_add failed for port-2:0:12 with -EEXIST, don't try to register things with the same name in the same directory.

So this is an interesting expander setup within the enclosure.
There are two expanders (500508b300a27a2f + 500508b300a27a3f)
interconnected via a two wide link (0,1 <-> 10,11 (T-S)) with
a four wide link back to the 94xx HBA (4,5,6,7 <-> 0,1,2,3).
My guess is that 500508b300a27a2f:12 is virtual and contains a
SES target. That leaves SAS disks on 500508b300a27a3f:0,
500508b300a27a3f,2 and 500508b300a27a3f,4

The pain starts immediately after the sas transport layer
tries to process those expander SMP DISCOVER responses.
The trace seems to suggest the device at 500508b300a27a2f:12
is SATA: extremely unlikely.

Mark, do you have a LSI MPT Fusion SAS HBA handy? If
so you might connect the enclosure to it, get smp_utils
and do something like:
 # modprobe mptctl
 # smp_discover -p 12 -s 0x500508b300a27a2f /dev/mptctl

and post the output.


BTW Darrick, SATA disks connected to an expander usually
get SAS addresses like <expander_sas_address + n> where
"n" is small. The device attached to 500508b300a27a2f:12
is in that region: 500508b300a27a2c

Doug Gilbert


