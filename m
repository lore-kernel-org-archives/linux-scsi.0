From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] megaraid_sas fills dmesg with megasas: Failed to copy
 out to user sense data
Date: Fri, 15 Jan 2010 12:09:45 GMT
Message-ID: <201001151209.o0FC9jFq000931@demeter.kernel.org>
References: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59942 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0AOMJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 07:09:46 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0FC9jUi000932
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2010 12:09:45 GMT
In-Reply-To: <bug-15001-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001


mi_whitebrook_13@gmx.at changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mi_whitebrook_13@gmx.at




--- Comment #4 from mi_whitebrook_13@gmx.at  2010-01-15 12:09:43 ---
This is a "me too" post...

I have a problem since the commit (SCSI: megaraid_sas: fix 64 bit sense pointer
truncation) with several Dell 2950 Servers. It happens both on the Perc 5/i and
the Perc 6/i controllers. All of these machines have 8GB RAM and are running
x86_64 kernels (currently 2.6.32.2). I always get messages like this in the
Kernel Log (plus on the console, which is VERY annoying:
[69274.972038] megasas: Failed to copy out to user sense data
[69274.972182] megasas: Failed to copy out to user sense data
[71168.206030] megasas: Failed to copy out to user sense data
[71168.206175] megasas: Failed to copy out to user sense data

It happens about 2-5 times per hour, most of the time several of those errors
(2-3) are reported in close timely vicinity, like within a few seconds. Other
than this these servers seem to be stable, so i guess it is a spurious message
caused by above commit. Replacing megaraid_sas.c with the version from Kernel
2.6.32 cures the problem.

I've also tried using version v00.00.04.12-rc1 of megaraid_sas.c (and .h)
from Kernel 2.6.33-rc3 and i can confirm that it shows the same problems
on my hardware:
[70120.567013] megasas: Failed to copy out to user sense data
[70120.576426] megasas: Failed to copy out to user sense data
[70120.576869] megasas: Failed to copy out to user sense data
[70120.587822] megasas: Failed to copy out to user sense data

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
