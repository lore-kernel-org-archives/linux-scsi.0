From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/9] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Fri, 23 Aug 2013 14:17:10 -0400
Message-ID: <1377281830.4147.61.camel@dabdike>
References: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
	 <1375124765-4110-2-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51224 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755794Ab3HWTcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 15:32:53 -0400
In-Reply-To: <1375124765-4110-2-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>


On Tue, 2013-07-30 at 00:35 +0530, Santosh Y wrote:
> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
> 
> As part of device initialization sequence, sending NOP OUT UPIU and
> waiting for NOP IN UPIU response is mandatory. This confirms that the
> device UFS Transport (UTP) layer is functional and the host can configure
> the device with further commands. Add support for sending NOP OUT UPIU to
> check the device connection path and test whether the UTP layer on the
> device side is functional during initialization.
> 
> A tag is acquired from the SCSI tag map space in order to send the device
> management command. When the tag is acquired by internal command the scsi
> command is rejected with host busy flag in order to requeue the request.
> To avoid frequent collisions between internal commands and scsi commands
> the device management command tag is allocated in the opposite direction
> w.r.t block layer tag allocation.
> 
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Santosh Y <santoshsy@gmail.com>

This signoff chain looks wrong to me.  The patch has quite a long
history.  Originally, it was sent in by Sujit, then later resent by
Dolev with his signoff, then Sujit did a V2 which incorrectly seemed to
include Dolev's signoff (that's not correct: signoffs should follow the
chain of transmission, so a new patch wouldn't have a previous
transmission signoff).  Then we got a V3 which was tested by Maya Erez,
and finally a v4 which looks to have no testers.  In your last
submission, you picked up this signoff, so I've changed it to a
reviewed-by which seems to be the most appropriate (although I'm not
entirely sure Dolev did review the v4 patch).

If this is wrong and Dolev did rewrite the patch (so is one of the
authors, which would explain the signoff chain) let me know and I'll
edit it in the tree (rebasing is acceptable to get the correct history).

James



