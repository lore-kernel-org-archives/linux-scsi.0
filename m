From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Wed, 28 Aug 2013 07:57:03 +0000
Message-ID: <bug-60644-11613-nMPLhFoj9U@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40420 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab3H1H5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 03:57:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 452312035D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 07:57:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 36ECD2037D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 07:57:06 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #23 from Hannes Reinecke <hare@suse.de> ---
So the firmware does indeed wedge under high load. Given the issues I've had so
far with LSI SATL I'm not surprised.

Does the same thing happen when running on a single disk, ie without MD?
There have been issues with MD dropping any queue limitations (ie the 4k
physical / 512 logical block sizes you're having) so MD might end up spitting
out non-aligned requests. Which in turn might trigger issues in the firmware
translation.

Using the devices directly without MD would eliminate this problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
