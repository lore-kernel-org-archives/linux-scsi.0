From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 1/9] scsi: ufs: Add support for sending NOP OUT UPIU
Date: Mon, 26 Aug 2013 08:41:32 +0530
Message-ID: <521AC764.5030001@codeaurora.org>
References: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>  <1375124765-4110-2-git-send-email-santoshsy@gmail.com> <1377281830.4147.61.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:34050 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HZDLi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Aug 2013 23:11:38 -0400
In-Reply-To: <1377281830.4147.61.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Dolev Raviv <draviv@codeaurora.org>

On 8/23/2013 11:47 PM, James Bottomley wrote:
>
> On Tue, 2013-07-30 at 00:35 +0530, Santosh Y wrote:
>> From: Sujit Reddy Thumma <sthumma@codeaurora.org>
>>
>> As part of device initialization sequence, sending NOP OUT UPIU and
>> waiting for NOP IN UPIU response is mandatory. This confirms that the
>> device UFS Transport (UTP) layer is functional and the host can configure
>> the device with further commands. Add support for sending NOP OUT UPIU to
>> check the device connection path and test whether the UTP layer on the
>> device side is functional during initialization.
>>
>> A tag is acquired from the SCSI tag map space in order to send the device
>> management command. When the tag is acquired by internal command the scsi
>> command is rejected with host busy flag in order to requeue the request.
>> To avoid frequent collisions between internal commands and scsi commands
>> the device management command tag is allocated in the opposite direction
>> w.r.t block layer tag allocation.
>>
>> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
>> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
>> Signed-off-by: Santosh Y <santoshsy@gmail.com>
>
> This signoff chain looks wrong to me.  The patch has quite a long
> history.  Originally, it was sent in by Sujit, then later resent by
> Dolev with his signoff, then Sujit did a V2 which incorrectly seemed to
> include Dolev's signoff (that's not correct: signoffs should follow the
> chain of transmission, so a new patch wouldn't have a previous
> transmission signoff).

Initially we had two patches -

scsi: ufs: add support for query requests authored by Dolev and
scsi: ufs: Add support for sending NOP OUT UPIU authored by me.

Based on a possible design issue with the former patch, Dolev merged
the patch into the later (NOP OUT patch).
http://thread.gmane.org/gmane.linux.ports.arm.msm/4202/focus=1505731

Since some of the contents are picked from the original patch during
rework, I have asked Dolev include his Signed-off-by as a co-author.


Then we got a V3 which was tested by Maya Erez,
> and finally a v4 which looks to have no testers.  In your last
> submission, you picked up this signoff, so I've changed it to a
> reviewed-by which seems to be the most appropriate (although I'm not
> entirely sure Dolev did review the v4 patch).
>
> If this is wrong and Dolev did rewrite the patch (so is one of the
> authors, which would explain the signoff chain) let me know and I'll
> edit it in the tree (rebasing is acceptable to get the correct history).
>
> James
>
>
>

-- 
Regards,
Sujit
