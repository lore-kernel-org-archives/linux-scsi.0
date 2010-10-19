From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20712] mpt2sas and SATA drives
Date: Tue, 19 Oct 2010 18:21:13 GMT
Message-ID: <201010191821.o9JILDqr001124@demeter1.kernel.org>
References: <bug-20712-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56983 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0JSSVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 14:21:14 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9JILEVo001125
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2010 18:21:14 GMT
In-Reply-To: <bug-20712-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20712


David Zeuthen <zeuthen@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |OBSOLETE




--- Comment #3 from David Zeuthen <zeuthen@gmail.com>  2010-10-19 18:21:11 ---
(In reply to comment #2)
> Oct 18 15:25:55 rhea kernel: mpt2sas0: LSISAS2116: FWVersion(03.00.00.00),
ChipRevision(0x01), BiosVersion(07.01.00.00)

OK, inspired by James' reply here

 http://www.spinics.net/lists/linux-scsi/msg42367.html

specifically

  So this is likely a firmware bug inside the mpt2sas.  All of the mpt
  cards use a fat firmware model meaning they take in pure SCSI commands
  and do the translation to SATA if necessary all within the firmware, so
  the first step would be to make sure your card has the latest firmware.

I've updated the card to the latest firmware

 Oct 19 14:11:45 rhea kernel: mpt2sas0: LSISAS2116: FWVersion(07.00.00.00),
ChipRevision(0x01), BiosVersion(07.01.00.00)

e.g. from version 03.00.00.00 to version 07.00.00.00 and suddenly all the
problems go away. So I'm closing this bug.

(And I also note that there's a lot of low-hanging fruit here - we really
should make it easy for users to a) know that there is a firmware update; b)
make it easy update the firmware... could maybe do this in the
udisks/palimpsest stack -maybe start by just support a couple of vendors. I
don't know.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
