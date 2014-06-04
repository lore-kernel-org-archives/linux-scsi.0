From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16490] "Assuming drive cache: write through" messages probably
 have wrong loglevel
Date: Wed, 04 Jun 2014 14:19:03 +0000
Message-ID: <bug-16490-11613-vR11V2gL19@https.bugzilla.kernel.org/>
References: <bug-16490-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43929 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaFDOTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2014 10:19:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E6DFD20328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2014 14:19:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BD4EE202E5
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2014 14:19:04 +0000 (UTC)
In-Reply-To: <bug-16490-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16490

Alain Kalker <a.c.kalker@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |a.c.kalker@gmail.com

--- Comment #8 from Alain Kalker <a.c.kalker@gmail.com> ---
I submitted a patch to lower the log level to the linux-scsi mailing list.
The patch was not accepted; James Bottomley offered this very insightful
explanation why the log level should remain high (quoted here for those who are
not reading the linux-scsi mailing list):

> [...] The condition may be an error.  We have
> some USB attached storage devices with writeback caches which don't
> supply caching information.  Treating a writeback device as writethrough
> is a potential error because you may lose data as a result of it.
> 
> The error is that we've made an assumption which may damage your data.
> 
> The problem for us is that we can't tell if the assumption is going to
> be fatal or not ... the message is harmless for older USB devices.

>From doing a little research, I would suggest these steps to mitigate the risk
(correct me if I'm wrong or have omitted anything):

- Find out if the device has write cache enabled by default, by consulting its
documentation, technical specifications, or by contacting the manufacturer.
- If the device does have write cache enabled, a quirk parameter can be added
to either the kernel commandline or as a module parameter for the usb-storage
module[1]
- Verify that the device works as expected.

[1] For more information on USB storage device quirks and how to configure
them, see linux/Documentation/kernel-parameters.txt in the Linux kernel source.

-- 
You are receiving this mail because:
You are the assignee for the bug.
