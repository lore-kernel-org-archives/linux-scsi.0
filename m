From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Mon, 08 Feb 2016 08:01:46 +0000
Message-ID: <bug-111441-11613-fUNr7649hp@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58785 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbcBHIBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 03:01:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7AEEF201EC
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 08:01:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A7BB5201F4
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 08:01:46 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #15 from nab <nab@linux-iscsi.org> ---
On Tue, 2016-02-02 at 14:56 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2016-02-01 at 10:55 -0600, Mike Christie wrote:
> > On 01/30/2016 01:38 AM, Nicholas A. Bellinger wrote:
> > > On Fri, 2016-01-29 at 17:32 -0600, Mike Christie wrote:
> > >> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
> > >>> HI Mike,
> > >>>
> > >>> I tried your patch and it is has eliminated first traceback but I still do not see my remote targets.
> > >>>
> > >>
> > >> That is sort of expected. Your target is not setup for ALUA properly. It
> > >> says it supports ALUA, but when scsi_dh_alua asks about the ports it is
> > >> reporting there are none. Ccing the people that made the patch that
> > >> added the issue and own the code.
> > >>
> > >> Hey Christoph and Hannes,
> > >>
> > >> The dh/alua changes that added this:
> > >>
> > >>         error = scsi_dh_add_device(sdev);
> > >>         if (error) {
> > >>                 sdev_printk(KERN_INFO, sdev,
> > >>                                 "failed to add device handler: %d\n",
> > >> error);
> > >>                 return error;
> > >>         }
> > >>
> > >> to scsi_sysfs_add_sdev are adding a regression.
> > >>
> > >> 1. If that fails, then we forget to do device_del before doing the
> > >> return. My patch in this thread added that back, so we do not see the
> > >> sysfs oopses anymore. But.....
> > >>
> > >> 2. It looks like in older kernels, we would allow misconfigured targets
> > >> like this one to still setup devices. Do we want that old behavior back?
> > >> Should we just ignore the return value from scsi_dh_add_device above?
> > >> Note that in this case, it is LIO so it can be easily fixed on the
> > >> target side by just setting it up properly. I do not think other targets
> > >> would hit this type of issue.
> > >>
> > > 
> > > Btw, what does misconfigured mean here wrt target ALUA..?
> > 
> > [   25.833195] sd 6:0:0:4: alua: supports implicit and explicit TPGS
> > [   25.833360] sd 6:0:0:4: alua: No target port descriptors found
> > [   25.833363] sd 6:0:0:4: alua: Attach failed (-22)
> > [   25.833365] sd 6:0:0:4: failed to add device handler: -22
> > 
> 
> Strange, this hasn't changed in forever on the target side..
> 
> > He has LIO configured to report it supports implicit/explicit ALUA, but
> > the ports do not seem to be configured.
> > 
> > For the LIO config side, are his LUNs just not in a the default_lu_gp or
> > any other group?
> 
> So every non-PSCSI backend device becomes part of default_lu_gp +
> default_tg_pt_gp and automatically shows up in EVPD=0x83, without user
> needing to do any additional configuration.
> 
> Here's what the output looks like:
> 
> root@haakon3:/usr/src/target-pending.git# sg_inq -Hi /dev/sdb
> VPD INQUIRY: Device Identification page
>   <SNIP>
>   Designation descriptor number 3, descriptor length: 8
>     transport: Serial Attached SCSI Protocol (SPL-2)
>     designator_type: Relative target port,  code_set: Binary
>     associated with the target port
>     designator header(hex): 61 94 00 04
>     designator:
>  00     00 00 00 02                                         ....
>   Designation descriptor number 4, descriptor length: 8
>     transport: Serial Attached SCSI Protocol (SPL-2)
>     designator_type: Target port group,  code_set: Binary
>     associated with the target port
>     designator header(hex): 61 95 00 04
>     designator:
>  00     00 00 00 00                                         ....
>   Designation descriptor number 5, descriptor length: 8
>     designator_type: Logical unit group,  code_set: Binary
>     associated with the addressed logical unit
>     designator header(hex): 01 06 00 04
>     designator:
>  00     00 00 00 00                                         ....
>  <SNIP>
> 
> So AFAICT, the relative target port, target port group, and logical unit
> group being returned from target on v4.5-rc1 code looks correct.
> 
> Serguei, can you confirm with 'sg_inq -Hi /dev/sdX' output on your side
> with the v3.10 based target..?
> 
> AFAICT the parsing in scsi_vpd_tpg_id() from commit a8aa3978 looks
> correct too.
> 
> Hannes, any ideas..?

Ping.

-- 
You are receiving this mail because:
You are the assignee for the bug.
