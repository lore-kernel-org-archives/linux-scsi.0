From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Mon, 20 Dec 2010 17:05:57 GMT
Message-ID: <201012201705.oBKH5vw2022071@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:52823 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab0LTRF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 12:05:58 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBKH5vvj022075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2010 17:05:57 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #12 from Adam Radford <aradford@gmail.com>  2010-12-20 17:05:52 ---
Matt,

You can prevent the crash from happening by commenting out or removing this
line:

printk(KERN_WARNING "3w-9xxx: scsi%d: Firmware %s, BIOS %s, Ports: %d.\n",
        host->host_no,
        (char *)twa_get_param(tw_dev, 0, TW_VERSION_TABLE,
        TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
        (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
        TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
        le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
        TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH)));

I was a little over-zealous in assuming the controller would be responding
here, or you would have already hung the system in POST.

At this point, since your card won't work in little-endian mode, I am guessing:

1. Your card is bad, which you could test by trying another 9500-S card.
2. The PCI slot you are trying is somehow incompatible with the 3ware hardware.

-Adam

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
