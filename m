From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49241] New: Unsafe dereference of pointer after allocing memory
Date: Mon, 22 Oct 2012 09:35:47 +0000 (UTC)
Message-ID: <bug-49241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52257 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2JVJfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2012 05:35:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4167520273
	for <linux-scsi@vger.kernel.org>; Mon, 22 Oct 2012 09:35:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5BCB52025E
	for <linux-scsi@vger.kernel.org>; Mon, 22 Oct 2012 09:35:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49241

           Summary: Unsafe dereference of pointer after allocing memory
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.0.47
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: yangyeping_666@hotmail.com
                CC: linux-scsi@vger.kernel.org
        Regression: No


Vulnerability kind: Null-pointer dereference
The file path containing this vulnerability: drivers/scsi/mac_scsi.c
Line number: 290
Severity: medium
Code fragment (from line 270 to line 290):


 instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
#if NDEBUG
    default_instance = instance;
#endif

    if (macintosh_config->ident == MAC_MODEL_IIFX) {
        mac_scsi_regp  = via1+0x8000;
        mac_scsi_drq   = via1+0xE000;
        mac_scsi_nodrq = via1+0xC000;
        /* The IIFX should be able to do true DMA, but pseudo-dma doesn't work
*/
        flags = FLAG_NO_PSEUDO_DMA;
    } else {
        mac_scsi_regp  = via1+0x10000;
        mac_scsi_drq   = via1+0x6000;
        mac_scsi_nodrq = via1+0x12000;
    }

    if (! setup_use_pdma)
        flags = FLAG_NO_PSEUDO_DMA;

    instance->io_port = (unsigned long) mac_scsi_regp;

Description: The variable "instance" is defined at line 270 via function
"scsi_register" but is not sanity-checked.Then it is dereferenced at line 290.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You are watching the assignee of the bug.
