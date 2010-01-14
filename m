From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] SCSI host adapter's scatter-gather list size Issue
Date: Thu, 14 Jan 2010 08:25:28 GMT
Message-ID: <201001140825.o0E8PS9e010991@demeter.kernel.org>
References: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47935 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0ANIZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 03:25:29 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0E8PSpM010992
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 08:25:28 GMT
In-Reply-To: <bug-15007-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-14 08:25:25 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Fri, 8 Jan 2010 11:07:49 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15007
> 
>            Summary: SCSI host adapter's scatter-gather list size Issue
>            Product: IO/Storage
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: nick.cheng@areca.com.tw
>                 CC: akpm@linux-foundation.org
>         Regression: No
> 
> 
> I found if I set scatter-gather table size as 1024 Areca's RAID controller,

You mean that setting sg_tablesize in scsi_host_template to 1024?


> ARC1680, and then execute "mkfs.ext3 /dev/sdX" on a sas/sata volume which is
> formated as NTFS, it will kill the controller and let it restart.
> This issue pops up easily on Intel server board with multi-processors and so
> far can not be reproduced on a volume with a original Linux filesystem such as,
> ext3.

Can your controller hardware and firmware handle 1024 scatter gather
entries?


> I also found the issue is on the write command with 128 sg entries, each with
> 4K byte in length. As the command comes from the upper layer, it lacks data in
> the 128th sg entry.

The device driver really get 128 entries?

How can you issue a write command with 128 sg entries?

Even if your user-space application issues a write command with 128 sg
entries, the device driver could get less sg entries.

If the device driver gets a command including 128 sg entries
(cmd->sdb.table.nents is set to 128) and 128th sg entry doesn't have
data, then probably we have a bug in scatter gather or block layer
code.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
