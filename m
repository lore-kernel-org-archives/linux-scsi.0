From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Infinite retries
Date: Sun, 19 Oct 2008 12:47:55 +0200
Message-ID: <48FB105B.20409@panasas.com>
References: <Pine.LNX.4.44L0.0810161359560.2180-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:12388 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbYJSKsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2008 06:48:00 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810161359560.2180-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Alan Stern wrote:
> We do have a problem with infinite retry loops.  I'm not sure which 
> kernels are affected, but there's a good chance 2.6.27 is and an 
> excellent chance that 2.6.28-rc1 will be.
> 
> The problem is caused by buggy USB devices that return the number of 
> sectors in response to READ CAPACITY, rather than the highest sector 
> number.  Thus they appear to have one more sector than they really do.  
> We can create blacklist entries for these devices, but they constantly 
> appear and the list is never up-to-date.  So we need to handle them 
> robustly even when they aren't on the blacklist.
> 
> When the system tries to read the non-existent last sector, the devices
> send back no data.  In addition, the stupid devices return no sense
> information (even though they often do return Check Condition status).
> 
> The question is: What should usb-storage report to the midlayer when
> this happens?  Setting scmd->result to DID_ERROR doesn't help, because
> sd_done() sets it back to 0 in the NO_SENSE case.  We end up calling
> scsi_end_request() with error = 0 and bytes = 0, thereby requeuing the
> request.  There's no counter to limit the number of times the same
> request can be requeued.
> 
> I actually saw this happen to somebody in the log accompanying a bug
> report a few days ago (Bugzilla #11768).
> 
> What's the proper solution?  Should usb-storage make up some bogus 
> sense data (HARDWARE_ERROR sense key maybe)?
> 
> Alan Stern
> 
> P.S.: What about my proposed changes to scsi_io_completion()?  There 
> hasn't been any response.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Alan Hi

Do you have the scsi_io_completion patchset on a public git somewhere?
I would like to re-test them and review them again.

Did you try them with above problem and do they solve the issue?
Also have you looked farther into the retries/timeout issues from
block layer?

Thanks
Boaz

