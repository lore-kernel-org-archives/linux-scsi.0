From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Wed, 17 Dec 2014 19:49:06 +0000
Message-ID: <bug-81861-11613-Y7Ip9a6Pkg@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51938 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaLQTtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2014 14:49:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2709220A29
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2014 19:49:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 66BC620A24
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2014 19:49:08 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

Christian Vilhelm <christian.vilhelm@univ-lille2.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |christian.vilhelm@univ-lill
                   |                            |e2.fr

--- Comment #19 from Christian Vilhelm <christian.vilhelm@univ-lille2.fr> ---
The problem was introduced with this patch :
commit 7c237c5f6d5c62724ccd82aecdcd1fd9bd71dc75
Author: Xiangliang Yu <yuxiangl@marvell.com>
Date:   Wed Jan 30 00:25:53 2013 +0800

    [SCSI] mvsas: fixed timeout issue when removing module


The offending line :
    (MVS_PHY_ID << TXQ_PHY_SHIFT)
was before :
    (sas_port->phy_mask << TXQ_PHY_SHIFT)

Reverting the patch corrects the problem for me (kernel 3.18.1)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
