From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Thu, 16 Jul 2009 07:56:47 GMT
Message-ID: <200907160756.n6G7ul1i011389@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46853 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZGPH4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 03:56:48 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6G7ulgn011390
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2009 07:56:47 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Kay Sievers <kay.sievers@vrfy.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kay.sievers@vrfy.org




--- Comment #5 from Kay Sievers <kay.sievers@vrfy.org>  2009-07-16 07:56:47 ---
Something keeps generating media change events in a loop for the optical drive.

If you keep "udevadm monitor" running, but kill udevd, do all events stop?

The event for "sr" open()s the device. I guess, this causes a new change event
for the SCSI LUN (which it shouldn't), and that causes a loop.

Is there anything like HAL or DeviceKit-disks running which polls the optical
drive?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
