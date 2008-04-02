From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Wed,  2 Apr 2008 09:07:27 -0700 (PDT)
Message-ID: <20080402160727.AC64310805F@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbYDBQH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 12:07:59 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m32G7RLq001654
	for <linux-scsi@vger.kernel.org>; Wed, 2 Apr 2008 09:07:28 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #14 from seraph@xs4all.nl  2008-04-02 09:07 -------
On Wed, 02 Apr 2008 10:49:19 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Reading the code for this, it seems that something fiddled with the
> IRQ_DISABLED or IRQ_PENDING flags when it came time for the ->eoi() so
> the gem interrupt is always held pending (because it's never ended).

So Andrew's first hunch that interrupts were somehow involved is right.

> Since the sym2 is on interrupts 16 and 17 and gem on 11 (and the
> descriptors are separate entities in the irq_desc array) I can't really
> see how sym2 would be doing this.

Yeah, that has me baffled too. Still, the fact is that I can only trigger the
bug by loading sym53c8xx before sungem. I have yet to find any other conditions
that trigger it. Loading sungem before sym53c8xx on an affected kernel gives no
trouble at all.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
