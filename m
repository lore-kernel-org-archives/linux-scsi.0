From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Mon, 25 Aug 2014 20:12:49 +0000
Message-ID: <bug-80711-11613-aBrbCTHibI@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbaHYUMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 16:12:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33ABB201C7
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 20:12:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D7D0E201CE
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 20:12:49 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #19 from Alan Stern <stern@rowland.harvard.edu> ---
On Mon, 25 Aug 2014, James Bottomley wrote:

> On Mon, 2014-08-25 at 10:44 -0400, Alan Stern wrote:
> 
> > James, can you explain how the INQUIRY command in scsi_probe_lun()  
> > managed to work back in the days when multi-lun SCSI-2 devices were
> > common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
> > initially contains 0, so the LUN bits won't get filled in when the
> > first INQUIRY command is sent.  Then how could the target know which
> > logical unit the INQUIRY was meant for?
> 
> Best guess, some patches over the course of time altered the way we do
> this and no-one noticed.  I think it was probably the introduction of
> the unknown SCSI data level that caused the breakage.

Heh.  The change was made by commit 4d7db04a7a69 ([SCSI] add
SCSI_UNKNOWN and LUN transfer limit restrictions) back in 2006 -- the
2.6.17 kernel.  If nobody has complained in all this time then it's
probably not worth changing.

> Historically, the LUN in CMD bits is left over from SCSI-1; it was
> incorporated into SCSI-2 for backward compatibility (even though SCSI-2
> moved the LUN specification to the identify message).  In SCSI-3 and
> beyond, those bits were obsoleted and transports took sole
> responsibility for LUN handling.  I'm fairly certain all the SCSI-1
> devices relying on this behaviour have long ago migrated to the great
> data centre in the sky.
> 
> Alan's fix looks reasonable because we probe LUN 0 first (for SCSI-1 and
> 2 which has parallel scanning), which is why it doesn't matter (the bits
> are set to zero) and once we have LUN 0 we propagate the data to the
> target and make it the basis for future checks.  I'd like to see a
> comment explaining this in the code, though ...

If you think it would be a good idea, I could put it into a separate 
patch with an explanatory comment.  At the moment, I'm inclined to 
forget about it.

Alan Stern

-- 
You are receiving this mail because:
You are the assignee for the bug.
