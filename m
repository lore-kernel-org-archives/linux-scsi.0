From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Tue, 12 Jul 2005 23:07:52 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0507122251110.3436@kai.makisara.local>
References: <92952AEF1F064042B6EF2522E0EEF437348370@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:10849 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262562AbVGLUEM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 16:04:12 -0400
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF437348370@EXNA.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 12 Jul 2005, Dailey, Nate wrote:

> I'll try porting my changes to a recent kernel, verify that the bugs I
> found are still bugs, and get back to you with a new patch.
> 
> In the meantime, responses to your comments:
> 
> - using a new kref in the scsi_tape structure: I've given this some
> thought, and I think using a new kref is defintely the best way to go.
> If nothing else, this is the same way sd and sr do reference counting...
> seems easier to maintain if the code in st is as similar as possible to
> these other drivers.
> 
st is a character device and it should use the character device 
refcounting if convenient. However, I now agree that the new kref is the 
simplest solution.

> - my changes to how last_SRpnt is used: I'll add a comment documenting
> when last_SRpnt is valid (it's valid only for async IOs that have been
> issued, nulled out by write_behind_check when they complete)
> 
Good.

> - Here's why I think the use of last_SRpnt in st_chk_result is bogus:
> one of the inputs to st_chk_result is "struct scsi_request * SRpnt", and
> it seems like this is the SRpnt you want to use, rather than last_SRpnt.
> This input will be the command that st_do_scsi or write_behind_check
> just waited on. This might not cause any problems with the current st
> code, but it will definitely cause problems with the changes I made to
> last_SRpnt. Let me know if I'm wrong about this, though, and I can
> change my last_SRpnt code.
> 
OK. I now see your point and it seems that the solution is simple: use the 
SRpnt argument of st_chk_result(). The reason why the function is using 
last_SRpnt is moving code from one place to another and not being careful 
enough to change everything (I knew that in that code last_SRpnt was valid 
always and so this did not look like an error ;-).

-- 
Kai
