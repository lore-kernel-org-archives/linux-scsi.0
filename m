From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13547] New: Buffer overrun in FlashPoint.c
Date: Mon, 15 Jun 2009 13:46:21 GMT
Message-ID: <bug-13547-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49140 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZFONqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 09:46:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5FDkLbu000647
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 13:46:21 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13547

           Summary: Buffer overrun in FlashPoint.c
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.30
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: ettl.martin@gmx.de
        Regression: No


Hi,

i detected a possible buffer overrun in File
linux-2.6.30/drivers/scsi/FlashPoint.c

I used the static code analysis tool cppcheck to detect this. It printed the
following message:
[linux-2.6.30/drivers/scsi/FlashPoint.c:1222]: (all) Buffer overrun


Lets take a look at line 1222:
        // ...
    for (thisCard = 0; thisCard <= MAX_CARDS; thisCard++) {

        if (thisCard == MAX_CARDS) {

            return FAILURE;
        }

1222        if (FPT_BL_Card[thisCard].ioPort == ioport) {

            CurrCard = &FPT_BL_Card[thisCard];
            FPT_SccbMgrTableInitCard(CurrCard, thisCard);
            break;
        }

          // ...

The for loop terminates when thisCard <= MAX_CARDS. MAX_CARDS is defined as 8
in this file. Here there are 9 iterations made. This is one to much.  
A possible solution to avoid this:

    for (thisCard = 0; thisCard < MAX_CARDS; thisCard++) {

Best regards

Ettl Martin

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
