From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Sat, 27 Feb 2016 22:15:43 +0000
Message-ID: <bug-111441-11613-UsDdAHVPHu@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56989 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbcB0WPr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Feb 2016 17:15:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DF688203E5
	for <linux-scsi@vger.kernel.org>; Sat, 27 Feb 2016 22:15:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2223F203DA
	for <linux-scsi@vger.kernel.org>; Sat, 27 Feb 2016 22:15:44 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #19 from nab <nab@linux-iscsi.org> ---
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

-- 
You are receiving this mail because:
You are the assignee for the bug.
