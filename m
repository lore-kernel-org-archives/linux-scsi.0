From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 4 May 2010 09:16:03 GMT
Message-ID: <201005040916.o449G3C7021763@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45759 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab0EDJQI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2010 05:16:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o449G3W5021765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2010 09:16:03 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #17 from Brian Sullivan <bexamous@gmail.com>  2010-05-04 09:15:45 ---
No way, issue is fixed!  After waiting for months I lose hope and order a
mpt2sas controller.  The next day issue is fixed.  Argh! lol :)

Without patch, running hddtemp in loop on 15 drives would last maybe 5-10
seconds before controller would crap out.

With patch its been going for at least 20 minutes now without issue.  I put
a load on the controller too (~600MB/sec reads total) & still stable.  I'll
let this go overnight but really, this issue is fixed for me.



On Mon, May 3, 2010 at 10:16 PM, <bugzilla-daemon@bugzilla.kernel.org>wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=14831
>
>
>
>
>
> --- Comment #16 from kdesai <kashyap.desai@lsi.com>  2010-05-04 05:16:28
> ---
> (In reply to comment #15)
> > Take a look at my diagnosis here:
> > http://lkml.org/lkml/2010/4/26/335
> >
> > It includes a rough-draft patch.  I'd be very interested in hearing
> reports of
> > whether this fixes this smartctl issue in others' environments as it has
> in
> > mine.
> I am doing my analysis and meanwhile also in touch with our Firmware folks
> to
> understand this issue.   Using Ryan's diagnosis tool I am able to see LSI
> controller is not able to DMA for particular alignment. I will update this
> ASAP.
> Thanks, Kashyap
> >
> > The reason I haven't proposed it as a real patch is that there's probably
> a
> > better location for that code.  Where I have it, it'll apply to every
> SCSI host
> > using the MPT Fusion framework, and if it's a hardware bug, perhaps we
> want it
> > to apply only to this specific LSI 1068 controller.
> >
> > That said, I expect most requests hitting the device are already
> well-aligned,
> > so this wouldn't affect many requests even if it did apply to a
> > broader-than-necessary collection of hardware.
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
