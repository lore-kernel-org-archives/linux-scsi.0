From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Tue, 02 Feb 2016 23:21:30 +0000
Message-ID: <bug-111441-11613-0pA4LV25Nz@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43028 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbcBBXVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 18:21:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D294C20266
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 23:21:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 35DFC202E9
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 23:21:31 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #14 from Serguei Bezverkhi <sbezverk@cisco.com> ---
Here you go, same output to compare for 4.4.1 and 3.10.0

Linux 4.4.1 #1 SMP Tue Feb 2 16:15:36 EST 2016

[root@sbezverk-osp-3 ~(keystone_admin)]#  sg_inq -Hi /dev/sdc
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
    designator header(hex): 01 03 00 10
    designator:
 00     60 01 40 56 5f e9 25 e7  94 a4 20 69 2c 0c b3 c6    `.@V_.%... i,...
  Designation descriptor number 2, descriptor length: 60
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
    designator header(hex): 02 01 00 38
    designator:
 00     4c 49 4f 2d 4f 52 47 00  73 61 6e 2d 64 69 73 6b    LIO-ORG.san-disk
 10     2d 32 3a 36 35 66 65 39  32 35 65 2d 37 39 34 61    -2:65fe925e-794a
 20     2d 34 32 30 36 2d 39 32  63 30 2d 63 62 33 63 36    -4206-92c0-cb3c6
 30     39 61 35 33 34 39 61 00                             9a5349a.
  Designation descriptor number 3, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
    designator header(hex): 51 94 00 04
    designator:
 00     00 00 00 01                                         ....
  Designation descriptor number 4, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
    designator header(hex): 51 95 00 04
    designator:
 00     00 00 00 00                                         ....
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
    designator header(hex): 01 06 00 04
    designator:
 00     00 00 00 00                                         ....
  Designation descriptor number 6, descriptor length: 80
    transport: Internet SCSI (iSCSI)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
    designator header(hex): 53 98 00 4c
    designator:
 00     69 71 6e 2e 32 30 30 33  2d 30 31 2e 6f 72 67 2e    iqn.2003-01.org.
 10     6c 69 6e 75 78 2d 69 73  63 73 69 2e 73 62 65 7a    linux-iscsi.sbez
 20     76 65 72 6b 2d 73 61 6e  2d 31 2e 78 38 36 36 34    verk-san-1.x8664
 30     3a 73 6e 2e 33 64 66 63  66 66 62 64 66 66 34 33    :sn.3dfcffbdff43
 40     2c 74 2c 30 78 30 30 30  31 00 00 00                ,t,0x0001...
  Designation descriptor number 7, descriptor length: 72
    transport: Internet SCSI (iSCSI)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target device that contains addressed lu
    designator header(hex): 53 a8 00 44
    designator:
 00     69 71 6e 2e 32 30 30 33  2d 30 31 2e 6f 72 67 2e    iqn.2003-01.org.
 10     6c 69 6e 75 78 2d 69 73  63 73 69 2e 73 62 65 7a    linux-iscsi.sbez
 20     76 65 72 6b 2d 73 61 6e  2d 31 2e 78 38 36 36 34    verk-san-1.x8664
 30     3a 73 6e 2e 33 64 66 63  66 66 62 64 66 66 34 33    :sn.3dfcffbdff43
 40     00 00 00 00

Linux 3.10.0-327.4.5.el7.x86_64 #1 SMP Thu Jan 21 04:10:29 EST 2016

 [root@sbezverk-osp-3 ~(keystone_admin)]# sg_inq -Hi /dev/sdc

VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
    designator header(hex): 01 03 00 10
    designator:
 00     60 01 40 56 5f e9 25 e7  94 a4 20 69 2c 0c b3 c6    `.@V_.%... i,...
  Designation descriptor number 2, descriptor length: 60
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
    designator header(hex): 02 01 00 38
    designator:
 00     4c 49 4f 2d 4f 52 47 00  73 61 6e 2d 64 69 73 6b    LIO-ORG.san-disk
 10     2d 32 3a 36 35 66 65 39  32 35 65 2d 37 39 34 61    -2:65fe925e-794a
 20     2d 34 32 30 36 2d 39 32  63 30 2d 63 62 33 63 36    -4206-92c0-cb3c6
 30     39 61 35 33 34 39 61 00                             9a5349a.
  Designation descriptor number 3, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
    designator header(hex): 51 94 00 04
    designator:
 00     00 00 00 01                                         ....
  Designation descriptor number 4, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
    designator header(hex): 51 95 00 04
    designator:
 00     00 00 00 00                                         ....
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
    designator header(hex): 01 06 00 04
    designator:
 00     00 00 00 00                                         ....
  Designation descriptor number 6, descriptor length: 80
    transport: Internet SCSI (iSCSI)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
    designator header(hex): 53 98 00 4c
    designator:
 00     69 71 6e 2e 32 30 30 33  2d 30 31 2e 6f 72 67 2e    iqn.2003-01.org.
 10     6c 69 6e 75 78 2d 69 73  63 73 69 2e 73 62 65 7a    linux-iscsi.sbez
 20     76 65 72 6b 2d 73 61 6e  2d 31 2e 78 38 36 36 34    verk-san-1.x8664
 30     3a 73 6e 2e 33 64 66 63  66 66 62 64 66 66 34 33    :sn.3dfcffbdff43
 40     2c 74 2c 30 78 30 30 30  31 00 00 00                ,t,0x0001...
  Designation descriptor number 7, descriptor length: 72
    transport: Internet SCSI (iSCSI)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target device that contains addressed lu
    designator header(hex): 53 a8 00 44
    designator:
 00     69 71 6e 2e 32 30 30 33  2d 30 31 2e 6f 72 67 2e    iqn.2003-01.org.
 10     6c 69 6e 75 78 2d 69 73  63 73 69 2e 73 62 65 7a    linux-iscsi.sbez
 20     76 65 72 6b 2d 73 61 6e  2d 31 2e 78 38 36 36 34    verk-san-1.x8664
 30     3a 73 6e 2e 33 64 66 63  66 66 62 64 66 66 34 33    :sn.3dfcffbdff43
 40     00 00 00 00                           


Let me know if you need any additional info.

Thank you

Serguei


-----Original Message-----
From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org] 
Sent: Tuesday, February 02, 2016 5:56 PM
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>;
bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Christoph
Hellwig <hch@infradead.org>; Hannes Reinecke <hare@suse.de>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On Mon, 2016-02-01 at 10:55 -0600, Mike Christie wrote:
> On 01/30/2016 01:38 AM, Nicholas A. Bellinger wrote:
> > On Fri, 2016-01-29 at 17:32 -0600, Mike Christie wrote:
> >> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
> >>> HI Mike,
> >>>
> >>> I tried your patch and it is has eliminated first traceback but I still do not see my remote targets.
> >>>
> >>
> >> That is sort of expected. Your target is not setup for ALUA 
> >> properly. It says it supports ALUA, but when scsi_dh_alua asks 
> >> about the ports it is reporting there are none. Ccing the people 
> >> that made the patch that added the issue and own the code.
> >>
> >> Hey Christoph and Hannes,
> >>
> >> The dh/alua changes that added this:
> >>
> >>         error = scsi_dh_add_device(sdev);
> >>         if (error) {
> >>                 sdev_printk(KERN_INFO, sdev,
> >>                                 "failed to add device handler: 
> >> %d\n", error);
> >>                 return error;
> >>         }
> >>
> >> to scsi_sysfs_add_sdev are adding a regression.
> >>
> >> 1. If that fails, then we forget to do device_del before doing the 
> >> return. My patch in this thread added that back, so we do not see 
> >> the sysfs oopses anymore. But.....
> >>
> >> 2. It looks like in older kernels, we would allow misconfigured 
> >> targets like this one to still setup devices. Do we want that old behavior back?
> >> Should we just ignore the return value from scsi_dh_add_device above?
> >> Note that in this case, it is LIO so it can be easily fixed on the 
> >> target side by just setting it up properly. I do not think other 
> >> targets would hit this type of issue.
> >>
> > 
> > Btw, what does misconfigured mean here wrt target ALUA..?
> 
> [   25.833195] sd 6:0:0:4: alua: supports implicit and explicit TPGS
> [   25.833360] sd 6:0:0:4: alua: No target port descriptors found
> [   25.833363] sd 6:0:0:4: alua: Attach failed (-22)
> [   25.833365] sd 6:0:0:4: failed to add device handler: -22
> 

Strange, this hasn't changed in forever on the target side..

> He has LIO configured to report it supports implicit/explicit ALUA, 
> but the ports do not seem to be configured.
> 
> For the LIO config side, are his LUNs just not in a the default_lu_gp 
> or any other group?

So every non-PSCSI backend device becomes part of default_lu_gp +
default_tg_pt_gp and automatically shows up in EVPD=0x83, without user needing
to do any additional configuration.

Here's what the output looks like:

root@haakon3:/usr/src/target-pending.git# sg_inq -Hi /dev/sdb VPD INQUIRY:
Device Identification page
  <SNIP>
  Designation descriptor number 3, descriptor length: 8
    transport: Serial Attached SCSI Protocol (SPL-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
    designator header(hex): 61 94 00 04
    designator:
 00     00 00 00 02                                         ....
  Designation descriptor number 4, descriptor length: 8
    transport: Serial Attached SCSI Protocol (SPL-2)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
    designator header(hex): 61 95 00 04
    designator:
 00     00 00 00 00                                         ....
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
    designator header(hex): 01 06 00 04
    designator:
 00     00 00 00 00                                         ....
 <SNIP>

So AFAICT, the relative target port, target port group, and logical unit group
being returned from target on v4.5-rc1 code looks correct.

Serguei, can you confirm with 'sg_inq -Hi /dev/sdX' output on your side with
the v3.10 based target..?

AFAICT the parsing in scsi_vpd_tpg_id() from commit a8aa3978 looks correct too.

Hannes, any ideas..?

-- 
You are receiving this mail because:
You are the assignee for the bug.
