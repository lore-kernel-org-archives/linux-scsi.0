From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 30 Aug 2010 16:42:16 GMT
Message-ID: <201008301642.o7UGgGms014547@demeter1.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59955 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0H3QmR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2010 12:42:17 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7UGgGjv014548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2010 16:42:16 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #42 from starlight@binnacle.cx  2010-08-30 16:42:08 ---
Kashyap,

Thank you for looking at this problem in depth.

Since it is different, I certainly can create a new bugzilla for 
it.  I'll do that in the next day or so.

Do you have any ideas about what might be the cause?

One thing that crosses my mind is that the drives here are not 
enterprise Seagate Constellation drives, but are Seagate 
Momentus drives that have more aggressive power saving features 
intended for laptops.  We chose them because at the time they 
were much less expensive and the sequential read/write 
performance was the same.  Now the price differential is much 
smaller and we would have gone with Constellations.

Is there any chance that the Momentus drives require the 10 
second command time-out in the LSI BIOS config to be extended? 
This is just a random idea.  The drives were all active at the 
time of the event and so would not have been in power saving 
mode or been responding slowly to commands.

Another theory I have is that there might be a memory leak in 
the firmware and that when all free memory is exhausted, the 
controller "goes insane".  Is such a memory leak something that 
would be apparent in the tracing?

Finally should mention that I believe the configuration is 
unusual.  A large, identical partition on the eight drives is 
configured as a software RAID0 volume.  I doubt that many people 
configure systems this way.  It might be stressing the
firmware/software in a unique fashion.

Thanks,

David





At 03:18 PM 8/30/2010 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>https://bugzilla.kernel.org/show_bug.cgi?id=14831
>
>I have taken a deep look of all the available logs for below 
>configuration.
>
>In summary, this can be a completely different issue. Can we move this issue to
>new bugzilla, so that I can have a fresh look on it ?
>
>Thanks, Kashyap

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
