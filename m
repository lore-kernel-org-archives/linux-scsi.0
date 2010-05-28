From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 16070] New: Fail to issue Start/Stop Unit
Date: Fri, 28 May 2010 11:20:10 -0400
Message-ID: <4BFFDF2A.1060404@interlog.com>
References: <bug-16070-11613@https.bugzilla.kernel.org/>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38731 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631Ab0E1PUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 11:20:14 -0400
In-Reply-To: <bug-16070-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On 10-05-28 10:55 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=16070
>
>             Summary: Fail to issue Start/Stop Unit
>             Product: IO/Storage
>             Version: 2.5
>      Kernel Version: 2.6.34-rc5
>            Platform: All
>          OS/Version: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: SCSI
>          AssignedTo: linux-scsi@vger.kernel.org
>          ReportedBy: ian@beware.dropbear.id.au
>          Regression: No
>
>
> I am attempting to save power by spinning down idle scsi disks. These are old
> fashioned parallel (U320) disks on a SCSI storage controller: LSI Logic /
> Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07).
>
> I do:
>
> sg_start --stop /dev/sde
> echo 0xfffffff>  /sys/module/scsi_mod/parameters/scsi_logging_level
> dd if=/dev/sde of=/dev/null count=1
> sleep 10
> echo 0>  /sys/module/scsi_mod/parameters/scsi_logging_level
>
> I get:
> dd: reading `/dev/sde': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00536828 s, 0.0 kB/s
>
> If I manually spin up the disk with sg_start --start /dev/sde, then things work
> again as expected.

<snip>
>
> After getting: "Add. Sense: Logical unit not ready, initializing command
> required" I would expect a Start/Stop unit command, but it appears that none is
> ever issued.

There is a different design philosophy between SCSI and
ATA disks (and has been for a very long time) reflecting
their different markets. When a SCSI disk is spun down, then
it will return errors on any command trying to do IO
until a SCSI START STOP UNIT command (start) is sent and then
time is allowed for the disk to spin up.

What you report as a bug is the long standing behaviour of
SCSI disks which Linux has not tried to modify.

Doug Gilbert


