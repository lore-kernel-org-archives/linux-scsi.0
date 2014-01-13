From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 13 Jan 2014 17:27:49 +0000
Message-ID: <bug-60644-11613-iBsRRFvzOM@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35257 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbaAMR1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 12:27:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4608E20125
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 17:27:52 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B8C8720149
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2014 17:27:50 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #37 from Jeff Johnson <jeff.johnson@aeoncomputing.com> ---
I can confirm Tommy's observations about disabling PERR and SERR solving the
issue.

The motherboard I am using (Supermicro X8DTH-iF) does not have those exact BIOS
settings to control. In my case the following BIOS changes and kernel command
line arguments eliminated the issue:

MB BIOS: BIOS->Advanced->Advanced Chipset Configuration->North Bridge
Configuration->ASPM=Disabled

Linux boot command line options: pcie_aspm=off disable_msi=1 

With these changes a very intense fio run has gone four days without a single
error or issue on a Linux-ZFS filesystem.

Before these changes I could not go four hours without multiple HBAs
disappearing (in my config there are three HBAs). Sometimes the HBAs would
disappear within 15-20 minutes of benchmark runtime.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
