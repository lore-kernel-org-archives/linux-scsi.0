From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Wed, 13 Aug 2008 14:13:57 +0300
Message-ID: <48A2C1F5.6000708@panasas.com>
References: <Pine.LNX.4.44L0.0808121648190.3153-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:15225 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbYHMLOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Aug 2008 07:14:04 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5445406wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2008 04:14:04 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0808121648190.3153-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Antonio Ospite <ospite@studenti.unina.it>

Alan Stern wrote:
> On Tue, 12 Aug 2008, Boaz Harrosh wrote:
> 
>> What you are doing here is changing the semantics of what used to
>> work.
> 
> Yes, and I don't want to do that unless the current code is truly
> wrong.  That's why I wasn't certain this was the right thing to do.
> 
>>  Now I'm not saying it's a bad thing, but You must audit all
>> scsi ULDs to make sure they are not now broken because of  the new
>> assumptions. Let me explain.
>>
>> This is what happens now (before the patch):
>> A request comes in with some size. And gets prepared by ULD.
>> If the ULD does not like the size for some reason it will
>> chunk off scsi_bufflen and will submit the command with
>> bufflen != req->size. The midlayer and drivers will only
>> respond to bufflen. Until ...
>>
>> Until this loop magic in scsi_io_completion(). Since the
>> request is not done it will be requeued, the ULD will inspect
>> new size, adjust scsi_bufflen and so on until done.
>>
>> In case of an error the request goes back to the ULD and the ULD
>> should decide what to do with the reminder.
> 
> I don't understand this point.  _Every_ non-BLOCK_PC request
> automatically goes back to the ULD via the ->done callback, not only
> those which get an error.  This callback does not get to decide what to
> do with the remainder of the request, as far as I can tell; all it can
> do is return the number of bytes actually handled.
> 
>> scsi-ml until now
>> did not see any-other size but scsi_bufflen. So in theory it is
>> sd.c job to check for errors on split up requests and decide if
>> to complete the reminder or re-submit. The scsi-ml did not make
>> that policy.
> 
> How can sd.c decide whether or not to resubmit?  It doesn't know 
> whether scsi_io_completion() will go ahead and requeue the request 
> anyway.  And besides, you can't resubmit the request until the current 
> portion has been sent back to the block layer, which doesn't happen 
> until after ->done returns.
> 
>> If scsi-ml decides that it wants to set a new error policy here, then
>> you should audit other ULDs to make sure they did not rely on the
>> old behavior.
>>
>> sd could check for errors in it's drv->done(cmd) function. and return
>> the reminder of the request size in case of error. look at
>> scsi.c::scsi_finish_command(). ULD has control here.
> 
> The ->done function does not return the remainder of the request size; 
> it returns good_bytes, which is the number of bytes that were handled.
> 
> I agree that since the decision to split the request up into multiple 
> commands was made in sd.c, the decision of what to do about the 
> remainder should also be made in sd.c.  However the current structure 
> of the code doesn't seem to allow this to happen.  Requeue decisions 
> are all made in scsi_io_completion() or scsi_end_request().
> 
> Alan Stern
> 
I agree with all of what you said. Even if drv->done(cmd) would magically
guess what scsi_io_completion() is going to do and will return not good_bytes
(It's just a name) but lets call it bytes_to_complete. It will still be a
bug in the requeue case.

But now that I stared at the code harder. Current code is a complete bug.
the: "this_count = scsi_bufflen()" Has nothing to do with anything. 
Maybe it was meant to be: "this_count = scsi_bufflen() - good_bytes"
That is the count left over after the first complete. But after we
have completed good_bytes, the second complete is never scsi_bufflen().
(It used to work because most of the times it is bigger then the reminder
but then we can just use: "this_count = ~0")

Also what you did is not enough. What if the error is one of the known cases
above, where the "complete and return" is inside the case. They will hang also. 
Here is what I think should be:

---
git diff --stat -p drivers/scsi/
 drivers/scsi/scsi_lib.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..36995e5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -852,7 +852,7 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = scsi_bufflen(cmd);
+	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -909,9 +909,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
 
-	/* good_bytes = 0, or (inclusive) there were leftovers and
-	 * result = 0, so scsi_end_request couldn't retry.
-	 */
+	this_count = blk_rq_bytes(req);
+
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:


