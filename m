From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Sat, 27 Feb 2016 14:15:39 -0800
Message-ID: <1456611339.1750.41.camel@haakon3.risingtidesystems.com>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
	 <56AAC605.1080707@cs.wisc.edu>
	 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
	 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
	 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
	 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
	 <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
	 <56ABBCFF.9060003@cs.wisc.edu>
	 <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com>
	 <56ABF6A6.8070506@cs.wisc.edu>
	 <1454139533.12686.3.camel@haakon3.risingtidesystems.com>
	 <56AF8DEC.5000002@cs.wisc.edu>
	 <1454453785.25549.20.camel@haakon3.risingtidesystems.com>
	 <1454918501.10001.117.camel@haakon3.risingtidesystems.com>
	 <56C373B2.2010200@hannes-reinecke.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55843 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbcB0WPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2016 17:15:41 -0500
In-Reply-To: <56C373B2.2010200@hannes-reinecke.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <mail@hannes-reinecke.de>
Cc: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>, "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

Hey Hannes,

On Tue, 2016-02-16 at 20:08 +0100, Hannes Reinecke wrote:
> On 02/08/2016 09:01 AM, Nicholas A. Bellinger wrote:
> > On Tue, 2016-02-02 at 14:56 -0800, Nicholas A. Bellinger wrote:
> >> On Mon, 2016-02-01 at 10:55 -0600, Mike Christie wrote:
> >>> On 01/30/2016 01:38 AM, Nicholas A. Bellinger wrote:
> >>>> On Fri, 2016-01-29 at 17:32 -0600, Mike Christie wrote:

<SNIP>

> >>>> Btw, what does misconfigured mean here wrt target ALUA..?
> >>>
> >>> [   25.833195] sd 6:0:0:4: alua: supports implicit and explicit TPGS
> >>> [   25.833360] sd 6:0:0:4: alua: No target port descriptors found
> >>> [   25.833363] sd 6:0:0:4: alua: Attach failed (-22)
> >>> [   25.833365] sd 6:0:0:4: failed to add device handler: -22
> >>>
> >>
> >> Strange, this hasn't changed in forever on the target side..
> >>
> >>> He has LIO configured to report it supports implicit/explicit ALUA, but
> >>> the ports do not seem to be configured.
> >>>
> >>> For the LIO config side, are his LUNs just not in a the default_lu_gp or
> >>> any other group?
> >>
> >> So every non-PSCSI backend device becomes part of default_lu_gp +
> >> default_tg_pt_gp and automatically shows up in EVPD=0x83, without user
> >> needing to do any additional configuration.
> >>
> >> Here's what the output looks like:
> >>
> >> root@haakon3:/usr/src/target-pending.git# sg_inq -Hi /dev/sdb
> >> VPD INQUIRY: Device Identification page
> >>    <SNIP>
> >>    Designation descriptor number 3, descriptor length: 8
> >>      transport: Serial Attached SCSI Protocol (SPL-2)
> >>      designator_type: Relative target port,  code_set: Binary
> >>      associated with the target port
> >>      designator header(hex): 61 94 00 04
> >>      designator:
> >>   00     00 00 00 02                                         ....
> >>    Designation descriptor number 4, descriptor length: 8
> >>      transport: Serial Attached SCSI Protocol (SPL-2)
> >>      designator_type: Target port group,  code_set: Binary
> >>      associated with the target port
> >>      designator header(hex): 61 95 00 04
> >>      designator:
> >>   00     00 00 00 00                                         ....
> >>    Designation descriptor number 5, descriptor length: 8
> >>      designator_type: Logical unit group,  code_set: Binary
> >>      associated with the addressed logical unit
> >>      designator header(hex): 01 06 00 04
> >>      designator:
> >>   00     00 00 00 00                                         ....
> >>   <SNIP>
> >>
> >> So AFAICT, the relative target port, target port group, and logical unit
> >> group being returned from target on v4.5-rc1 code looks correct.
> >>
> >> Serguei, can you confirm with 'sg_inq -Hi /dev/sdX' output on your side
> >> with the v3.10 based target..?
> >>
> >> AFAICT the parsing in scsi_vpd_tpg_id() from commit a8aa3978 looks
> >> correct too.
> >>
> >> Hannes, any ideas..?
> >
> > Ping.
> >
> Please try with my latest scsi_dh_alua patchset posted to linux-scsi.
> That should solve the error attaching devices.
> 

Just to confirm, this was not a target side issue, right..?

Also, since Serguei is seeing this on v4.4 we'll still need some hack
for stable, assuming you're entire patchset won't be in 4.4.y code.  ;)

Are you OK with Mike's original patch, or do you have something better
to submit to Greg-KH..?

