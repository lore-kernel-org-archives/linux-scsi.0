From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Mon, 25 Aug 2014 14:44:21 +0000
Message-ID: <bug-80711-11613-pvmcIGOIaU@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53542 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863AbaHYOoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 10:44:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D071920166
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 14:44:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7675520138
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 14:44:21 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #18 from Alan Stern <stern@rowland.harvard.edu> ---
On Sun, 24 Aug 2014, Christoph Hellwig wrote:

> On Fri, Aug 22, 2014 at 01:29:32PM -0400, Alan Stern wrote:
> > > Other than this, I'm fine with the code ... you can add the acked by
> > > from me when we resolve the above question.
> > 
> > Okay.  It's true that this issue is only tangentially related to the 
> > main point of the patch.  It could be removed and addressed later.
> 
> Just make it a separate patch and send it along..

All right.  But I still want to know first whether the patch really
fixes the original problem.

Tiziano, do you intend to test this patch?

James, can you explain how the INQUIRY command in scsi_probe_lun()  
managed to work back in the days when multi-lun SCSI-2 devices were
common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
initially contains 0, so the LUN bits won't get filled in when the
first INQUIRY command is sent.  Then how could the target know which
logical unit the INQUIRY was meant for?

Alan Stern

-- 
You are receiving this mail because:
You are the assignee for the bug.
