From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [Bug 16070] New: Fail to issue Start/Stop Unit
Date: Fri, 28 May 2010 10:35:22 -0500
Message-ID: <4BFFE2BA.6030307@linux.vnet.ibm.com>
References: <bug-16070-11613@https.bugzilla.kernel.org/> <4BFFDF2A.1060404@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46972 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0E1Pfb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 11:35:31 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o4SFIx6O027769
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 11:18:59 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4SFZNit067446
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 11:35:23 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4SFZNpE019222
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 11:35:23 -0400
In-Reply-To: <4BFFDF2A.1060404@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

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

If you set the allow_restart sysfs parameter on the disk, it should automatically
spin up the disk when scsi eh sees that sense data.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
