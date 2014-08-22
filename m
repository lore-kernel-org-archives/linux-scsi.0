From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Fri, 22 Aug 2014 15:26:26 +0000
Message-ID: <bug-80711-11613-mb8N9eQD8t@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59162 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbaHVP03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 11:26:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 84B52201BF
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 15:26:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D8A3B2017A
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 15:26:26 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #16 from Alan Stern <stern@rowland.harvard.edu> ---
On Fri, 22 Aug 2014, Christoph Hellwig wrote:

> On Fri, Aug 22, 2014 at 10:53:42AM -0400, Alan Stern wrote:
> > Good idea.  An enhanced patch is below.  If I can get a Tested-By: from
> > Tiziano and one or two Acked-By: responses, I'll submit this for the
> > current and stable kernels.
> > 
> > Sending the initial INQUIRY command to LUNs larger than 0 involves a
> > chicken-and-egg problem -- we don't know whether to fill in the LUN
> > bits in the command until we know the SCSI level, and we don't know the
> > SCSI level until the INQUIRY response is received.  The solution we 
> > have been using is to store the most recently discovered level in the 
> > target structure, and use it as a default.  If probing starts with LUN 
> > 0, and if all the LUNs have similar levels, this ought to work.
> > 
> > Except for one thing: The code does store the default level in the
> > scsi_target, but forgets to copy it back into each newly allocated
> > scsi_device!  I added a line to do that into the patch.
> 
> Looks good to me,
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> 
> Do you want to queue this up in the USB tree?  From the looks of what I
> have on my plate so far it seems like we could avoid conflicts with it
> in the SCSI tree.

After hearing from Tiziano, I'll submit the patch to the SCSI tree.

Alan Stern

-- 
You are receiving this mail because:
You are the assignee for the bug.
