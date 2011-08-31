From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42142] New: mpt2sas: Number specified in wrong base.
Date: Wed, 31 Aug 2011 19:56:41 GMT
Message-ID: <bug-42142-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60643 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1HaT4o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2011 15:56:44 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7VJugAQ011952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2011 19:56:42 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42142

           Summary: mpt2sas: Number specified in wrong base.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.0.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: daniel.kernel@the-cell.co.uk
        Regression: No


I think this is the right product/component combination, sorry if it isn't.

I was hunting through mpt2sas chasing unrelated hardware gremlins and noticed
an odd bit of code, I've checked the latest version on lxr and it's still
there.

http://lxr.linux.no/linux+v3.0.4/drivers/scsi/mpt2sas/mpt2sas_base.c#L611

 611        /* eat the loginfos associated with task aborts */
 612        if (ioc->ignore_loginfos && (log_info == 30050000 || log_info ==
 613            0x31140000 || log_info == 0x31130000))
 614                return;
 615

I'm assuming that the first of those log_info checks is meant to be 0x30050000,
as specified it is rendered always false by the bus type check a few lines
above.

It's a minor detail, but I thought I'd report it anyway since it's so trivial
to fix if you have the source to hand.

Regards,
Daniel

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
