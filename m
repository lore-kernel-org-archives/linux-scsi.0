From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 1898] fdomain module crashes on load in 2.6.x
Date: Wed, 04 Jun 2014 02:21:05 +0000
Message-ID: <bug-1898-11613-wM8O2NFJmF@https.bugzilla.kernel.org/>
References: <bug-1898-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaFDCVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 22:21:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AB77D20179
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2014 02:21:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4643D201D5
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2014 02:21:06 +0000 (UTC)
In-Reply-To: <bug-1898-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=1898

Andreas Hartmetz <ahartmetz@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|---                         |No

--- Comment #4 from Andreas Hartmetz <ahartmetz@web.de> ---
For historical interest: relevant history is available at
https://archive.org/details/git-history-of-linux and the commit that most
likely fixed this bug is aa98a175adc4165908817b7b9881b60be659d0cc which fixed a
few things that were very fishy in fdomain.c.
... I probably don't have that hardware anymore though :)

    [PATCH] fdomain screwup

    | From: Andrew Morton
    | To: linux-scsi@vger.kernel.org
    | Subject: fdomain screwup
    |
    | - fdomain_setup() is marked __init, but is called from non-__init
    |   fdomain_16x0_detect()
    |
    | - fdomain_setup() is declared in drivers/scsi/pcmcia/fdomain_stub.c as
    |   taking two arguments, but is implemented in fdomain_setup() taking a
    |   single argument.
    |
    |   Please, never ever ever put extern function declarations in .c files.
    |   Put it in a header file which is visible to the definition and to all
    |   callsites.
    |
    | - fdomain_setup() is declared static, hence the linkage fails.
    |
    | - fdomain_16x0_bus_reset() is implemented in drivers/scsi/fdomain.c but
    |   has static scope, so the call from drivers/scsi/pcmcia/fdomain_stub.c
    |   doesn't work.

    [I didn't find this to be the case, so I didn't fix it.]

    | - fdomain_16x0_bus_reset() has an extern declaration in
    |   drivers/scsi/pcmcia/fdomain_stub.c.  This should be moved to a header
    |   file which is visible to etc...    [PATCH] fdomain screwup

    | From: Andrew Morton
    | To: linux-scsi@vger.kernel.org
    | Subject: fdomain screwup
    |
    | - fdomain_setup() is marked __init, but is called from non-__init
    |   fdomain_16x0_detect()
    |
    | - fdomain_setup() is declared in drivers/scsi/pcmcia/fdomain_stub.c as
    |   taking two arguments, but is implemented in fdomain_setup() taking a
    |   single argument.
    |
    |   Please, never ever ever put extern function declarations in .c files.
    |   Put it in a header file which is visible to the definition and to all
    |   callsites.
    |
    | - fdomain_setup() is declared static, hence the linkage fails.
    |
    | - fdomain_16x0_bus_reset() is implemented in drivers/scsi/fdomain.c but
    |   has static scope, so the call from drivers/scsi/pcmcia/fdomain_stub.c
    |   doesn't work.

    [I didn't find this to be the case, so I didn't fix it.]

    | - fdomain_16x0_bus_reset() has an extern declaration in
    |   drivers/scsi/pcmcia/fdomain_stub.c.  This should be moved to a header
    |   file which is visible to etc...

    Builds and loads.  No hardware to test.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
