From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Mon, 25 Jul 2005 14:54:42 -0500
Message-ID: <42E54382.5050408@us.ibm.com>
References: <92952AEF1F064042B6EF2522E0EEF437348377@EXNA.corp.stratus.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:64141 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261505AbVGYTyp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 15:54:45 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j6PJshSa532306
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2005 15:54:44 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j6PJshRi413000
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2005 13:54:43 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j6PJshVF022536
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2005 13:54:43 -0600
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF437348377@EXNA.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

I just tested out your patch on the latest git tree and this patch
fixes the scsi tape hot unplug problems I was seeing as well.


Brian

Dailey, Nate wrote:
> I've attached patches against 2.6.13rc2. These are basically identical
> to my earlier patches, as I found that all issues I'd seen in earlier
> kernels still existed in this kernel.
> 
> To summarize, the changes are: (more details in my original email)
> 
> - add a kref to the scsi_tape structure, and associate reference
> counting stuff
> 
> - set sr_request->end_io = blk_end_sync_rq so we get notified when an IO
> is rejected when the device goes away
> 
> - check rq_status when IOs complete, else we don't know that IOs
> rejected for a dead device in fact did not complete
> 
> - change last_SRpnt so it's set before an async IO is issued (in case
> st_sleep_done is bypassed)
> 
> - fix a bogus use of last_SRpnt in st_chk_result
> 
> 
> Nate Dailey
> Stratus Technologies
> 
> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> 
> 
>>-----Original Message-----
>>From: Kai Makisara [mailto:Kai.Makisara@kolumbus.fi] 
>>Sent: Tuesday, July 12, 2005 4:08 PM
>>To: Dailey, Nate
>>Cc: Brian King; linux-scsi@vger.kernel.org
>>Subject: RE: [PATCH] drivers/scsi/st.c: add reference count 
>>and related fixes
>>
>>
>>On Tue, 12 Jul 2005, Dailey, Nate wrote:
>>
>>
>>>I'll try porting my changes to a recent kernel, verify that 
>>
>>the bugs I
>>
>>>found are still bugs, and get back to you with a new patch.
>>>
>>>In the meantime, responses to your comments:
>>>
>>>- using a new kref in the scsi_tape structure: I've given this some
>>>thought, and I think using a new kref is defintely the best 
>>
>>way to go.
>>
>>>If nothing else, this is the same way sd and sr do 
>>
>>reference counting...
>>
>>>seems easier to maintain if the code in st is as similar as 
>>
>>possible to
>>
>>>these other drivers.
>>>
>>
>>st is a character device and it should use the character device 
>>refcounting if convenient. However, I now agree that the new 
>>kref is the 
>>simplest solution.
>>
>>
>>>- my changes to how last_SRpnt is used: I'll add a comment 
>>
>>documenting
>>
>>>when last_SRpnt is valid (it's valid only for async IOs 
>>
>>that have been
>>
>>>issued, nulled out by write_behind_check when they complete)
>>>
>>
>>Good.
>>
>>
>>>- Here's why I think the use of last_SRpnt in st_chk_result 
>>
>>is bogus:
>>
>>>one of the inputs to st_chk_result is "struct scsi_request 
>>
>>* SRpnt", and
>>
>>>it seems like this is the SRpnt you want to use, rather 
>>
>>than last_SRpnt.
>>
>>>This input will be the command that st_do_scsi or write_behind_check
>>>just waited on. This might not cause any problems with the 
>>
>>current st
>>
>>>code, but it will definitely cause problems with the 
>>
>>changes I made to
>>
>>>last_SRpnt. Let me know if I'm wrong about this, though, and I can
>>>change my last_SRpnt code.
>>>
>>
>>OK. I now see your point and it seems that the solution is 
>>simple: use the 
>>SRpnt argument of st_chk_result(). The reason why the 
>>function is using 
>>last_SRpnt is moving code from one place to another and not 
>>being careful 
>>enough to change everything (I knew that in that code 
>>last_SRpnt was valid 
>>always and so this did not look like an error ;-).
>>
>>-- 
>>Kai
>>


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
