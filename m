From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Sat, 20 Mar 2010 03:28:40 GMT
Message-ID: <201003200328.o2K3Sens022419@demeter.kernel.org>
References: <bug-15565-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53395 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0CTD2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 23:28:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2K3Sex2022420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2010 03:28:40 GMT
In-Reply-To: <bug-15565-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15565





--- Comment #9 from Mike Hayward <mh-linux-kernel@loup.net>  2010-03-20 03:28:33 ---
 > Great so see the problem confirmed and it's going to move! I and other 
 > people have been asking this for 3 (or 4?) years and have had a silence 
 > in reply. It hasn't even been confirmed, so I'd prepare a patch.

I obtained more evidence today that not only is it reversing arbitrary
subsets of commands nonsensically, but it is a starvation queue as
well (no reasonable deadline to drain the LIFO).

This time I ran sg queued io on a wimpier arm machine via usb to a
real hard drive with only one drive on the bus to eliminate the
possibility that the usb bus could be unfair between devices.  The
slower cpu also helped quantify kernel cpu burn and latency issues.

Blocking writes to a drive with the write cache on ran at 20MB/s, only
10MB/s via sg with the exact same io load.  Not sure why it's so much
lower bandwidth on an arm kernel but it seems it must have additional
latency, mem copy, etc. going on.

Regardless, it took over 33 seconds to complete a write to a drive
which was bypassed by hundreds and hundreds of subsequent writes,
starving until finally there was enough of a lull that the LIFO
'queue' must have drained.

A starving task queue is definitely not a SCSI task queue.  I must
conclude that there isn't even a need for a "works correctly" flag to
be added to support forward compatibility if someone fixes this.

1. It is the SCSI target which should manage task ordering according
   to command attributes, not the initiator.
2. If an existing app can cope with starvation and arbitrary
   reordering of commands, then simply fixing the queue to send
   out commands in the order submitted shouldn't break it.  In all
   likelihood it could speed up a simple target if command order
   matters at all.  Am I missing something here?

- Mike

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
