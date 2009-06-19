From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13572] hdparm -W1 /dev/sda causes oops and hard lockup
Date: Fri, 19 Jun 2009 14:42:50 GMT
Message-ID: <200906191442.n5JEgoKa000775@demeter.kernel.org>
References: <bug-13572-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47761 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZFSOmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2009 10:42:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5JEgoJt000776
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2009 14:42:50 GMT
In-Reply-To: <bug-13572-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13572


Vladimir Prodan <vc@artstyle.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #2 from Vladimir Prodan <vc@artstyle.net>  2009-06-19 14:42:49 ---
James, thank you! You're right, it seems it was reproducible corruption of
device list caused by some IPMI code. Sorry, I am using IPMI patches from
http://openipmi.sf.net/ since 2004 (2.6.6) and have no problems with them until
now. Unfinished git bisection shows that problem is around here:

bad cced7d0 2009-05-19 21:51:07 +0400 [Corey Minyard] serial: Add a polled
interface to the 8250 driver
    9483290 2009-05-19 21:51:06 +0400 [Corey Minyard] serial: Add support for
doing a console using the poll interface
    5bdfc86 2009-05-19 21:51:06 +0400 [Corey Minyard] serial: Add a poll
interface to the serial core
ok  6acac9a 2009-05-19 21:51:05 +0400 [Corey Minyard] serial: Add circular
buffer helpers
    62ed3da 2009-05-19 21:51:05 +0400 [Corey Minyard] serial: Add a function to
abstract the tty code from the drivers
    6657022 2009-05-19 21:51:10 +0400 [Corey Minyard] ipmi_emu
ok  af85f59 2009-05-19 21:51:10 +0400 [Corey Minyard] ipmi_si_max_busy-fixed

I'll try find the cause and tell Corey about it.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
