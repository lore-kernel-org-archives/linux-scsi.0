From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49461] scsi/bfa/bfad.c:1037: possible off by one in strncpy ?
Date: Thu, 29 Aug 2013 04:44:20 +0000
Message-ID: <bug-49461-11613-BVHvGKcJEq@https.bugzilla.kernel.org/>
References: <bug-49461-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55134 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab3H2EoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 00:44:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8F3DF20384
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 04:44:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A403D2033F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 04:44:20 +0000 (UTC)
In-Reply-To: <bug-49461-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49461

Jeff Zhou <jz.researcher@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jz.researcher@yahoo.com

--- Comment #1 from Jeff Zhou <jz.researcher@yahoo.com> ---
In 3.10.9, it is correct:
scsi/bfa/bfad.c : 1036
    strncpy(driver_info.os_device_name, bfad->pci_name,
        sizeof(driver_info.os_device_name) - 1);

scsi/bfa/bfad.c : 1014    
struct bfa_fcs_driver_info_s driver_info;

scsi/bfa/bfa_fcs.h : 672
struct bfa_fcs_driver_info_s {
    u8     version[BFA_VERSION_LEN];        /* Driver Version */
    u8     host_machine_name[BFA_FCS_OS_STR_LEN];
    u8     host_os_name[BFA_FCS_OS_STR_LEN]; /* OS name and version */
    u8     host_os_patch[BFA_FCS_OS_STR_LEN]; /* patch or service pack */
    u8     os_device_name[BFA_FCS_OS_STR_LEN]; /* Driver Device Name */
};

The copy length here is (BFA_FCS_OS_STR_LEN - 1), which should be.

-- 
You are receiving this mail because:
You are the assignee for the bug.
