From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10486] kernel 2.6.24  4G FC arrays don't work properly with qla2xxx driver
Date: Tue, 29 Apr 2008 14:08:59 -0700 (PDT)
Message-ID: <20080429210859.528DA108061@picon.linux-foundation.org>
References: <bug-10486-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYD2VJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 17:09:03 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3TL8xgI011701
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2008 14:09:00 -0700
In-Reply-To: <bug-10486-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10486





------- Comment #16 from andrew.vasquez@qlogic.com  2008-04-29 14:08 -------
Can this bugzilla be closed out now that the patch is upstream
pending in stable?

Side note:  Andrej, the HBA you have (QLE220), has a hard-limit
on the total number of concurrent logins (8 target ports [PLOGI/PRLI]).
In many of your logs, there's more than 8 ports discovered during
SNS scans (fortunately your storage ports appear to be returned early
in the list, don't depend on this ordering), and the firmware will fail
PLOGI requests once the upper-limit is reached:

   scsi(9): Trying Fabric Login w/loop id 0x0087 for port 020100.
   qla24xx_login_fabric(9): failed to complete IOCB -- completion status (31) 
ioparam=1c/20100.
   scsi(9): Retrying 15 login again loop_id 0x87
   scsi(9): Trying Fabric Login w/loop id 0x0088 for port 020200.
   qla24xx_login_fabric(9): failed to complete IOCB -- completion status (31) 
ioparam=1c/20200.
   scsi(9): Retrying 15 login again loop_id 0x88
   scsi(9): Trying Fabric Login w/loop id 0x008a for port 020400.
   qla24xx_login_fabric(9): failed to complete IOCB -- completion status (31) 
ioparam=1c/20400.
   scsi(9): Retrying 15 login again loop_id 0x8a

Please keep this in mind when connecting more target-ports
to this HBA.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
