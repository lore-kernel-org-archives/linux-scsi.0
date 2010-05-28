From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16070] Fail to issue Start/Stop Unit
Date: Fri, 28 May 2010 15:36:14 GMT
Message-ID: <201005281536.o4SFaERX002951@demeter.kernel.org>
References: <bug-16070-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37946 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab0E1PgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 11:36:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4SFaEK1002952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 15:36:14 GMT
In-Reply-To: <bug-16070-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16070





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-05-28 15:36:13 ---
Reply-To: brking@linux.vnet.ibm.com

On 05/28/2010 10:20 AM, Douglas Gilbert wrote:
> On 10-05-28 10:55 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=16070
>>
>>             Summary: Fail to issue Start/Stop Unit
>>             Product: IO/Storage
>>             Version: 2.5
>>      Kernel Version: 2.6.34-rc5
>>            Platform: All
>>          OS/Version: Linux
>>                Tree: Mainline
>>              Status: NEW
>>            Severity: normal
>>            Priority: P1
>>           Component: SCSI
>>          AssignedTo: linux-scsi@vger.kernel.org
>>          ReportedBy: ian@beware.dropbear.id.au
>>          Regression: No
>>
>>
>> I am attempting to save power by spinning down idle scsi disks. These
>> are old
>> fashioned parallel (U320) disks on a SCSI storage controller: LSI Logic /
>> Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07).
>>
>> I do:
>>
>> sg_start --stop /dev/sde
>> echo 0xfffffff>  /sys/module/scsi_mod/parameters/scsi_logging_level
>> dd if=/dev/sde of=/dev/null count=1
>> sleep 10
>> echo 0>  /sys/module/scsi_mod/parameters/scsi_logging_level
>>
>> I get:
>> dd: reading `/dev/sde': Input/output error
>> 0+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.00536828 s, 0.0 kB/s
>>
>> If I manually spin up the disk with sg_start --start /dev/sde, then
>> things work
>> again as expected.
> 
> <snip>
>>
>> After getting: "Add. Sense: Logical unit not ready, initializing command
>> required" I would expect a Start/Stop unit command, but it appears
>> that none is
>> ever issued.
> 
> There is a different design philosophy between SCSI and
> ATA disks (and has been for a very long time) reflecting
> their different markets. When a SCSI disk is spun down, then
> it will return errors on any command trying to do IO
> until a SCSI START STOP UNIT command (start) is sent and then
> time is allowed for the disk to spin up.
> 
> What you report as a bug is the long standing behaviour of
> SCSI disks which Linux has not tried to modify.

If you set the allow_restart sysfs parameter on the disk, it should
automatically
spin up the disk when scsi eh sees that sense data.

Thanks,

Brian

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
