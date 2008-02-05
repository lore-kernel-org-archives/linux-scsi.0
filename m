From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Tue, 05 Feb 2008 18:54:41 +0200
Message-ID: <47A894D1.30307@panasas.com>
References: <Pine.LNX.4.44L0.0802051037040.4167-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24063 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbYBEQzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 11:55:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.0802051037040.4167-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Feb 05 2008 at 17:42 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 5 Feb 2008, Boaz Harrosh wrote:
> 
>>> However the interface to usb_stor_access_xfer_buf() will have to change
>>> slightly.  Right now if it sees that *sgptr is NULL, it assumes this
>>> means it should start at the beginning of the s-g buffer.  But with 
>>> Boaz's change, *sgptr == NULL means the transfer has reached the end of 
>>> the buffer.  So I'll have to go through and audit all the callers.
>>>
>>> Alan Stern
>>>
>>> -
>> No it does not, this as not changed. Please look again.
> 
> You look again.  Your patched code goes like this:
> 
> 		struct scatterlist *sg = *sgptr;
> 
> 		if (!sg)
> 			sg = (struct scatterlist *) srb->request_buffer;
> 
> Hence if *sgptr is NULL upon entry, it is taken to mean that the 
> transfer should start at the beginning of the s-g buffer.
> 
> 		/* This loop handles a single s-g list entry, which may
> 		 * include multiple pages.  Find the initial page structure
> 		 * and the starting offset within the page, and update
> 		 * the *offset and *index values for the next loop. */
> 		cnt = 0;
> 		while (cnt < buflen && sg) {
> 
> Hence if sg is NULL, it indicates the end of the buffer has been 
> reached.  And then down near the end of the routine:
> 
> 		*sgptr = sg;
> 
> Hence if the end is reached and the caller makes another call to try 
> transferring more data, the additional data will get stored back at the 
> beginning of the buffer.
> 
That behavior did not change. In the likely event of sg-length matching
bufflen the last call to sg_next will return NULL, and will be returned 
in *sgptr. The end condition of an outside caller is either sum of 
returned counts reaching some target count, or *sgptr return to NULL.
The code before the sg change would have *indexptr >= some_sg_count, but 
now we do not have an index we have a pointer and the termination condition 
is *sgptr == NULL.

So I guess you are afraid that calling code that was converted from index
to pointer, was done wrong, and where something did  *indexptr >= some_sg_count
before, does not do *sgptr == NULL now.

So I guess, yes you are welcome to check. I did not do the conversion so
I can not comment.

>> Note that this patch was tested and working. It is a bug
>> in v2.2.24 and it should be accepted already. One way or
>> the other.
>>
>> Callers of usb_stor_access_xfer_buf() need not change.
>> Matthew Dharm should decide if he wants the WARN_ON in 
>> usb_stor_set_xfer_buf() or not and be done with it.
>>
>> I have found and fixed the bug, but it is not a SCSI
>> related bug, and it is not do to any scsi changes. It
>> is a bug from the SG changes of early 2.6.24. Please
>> take it through the USB tree. Feel free to change it
>> the way you like it, and submit it.
> 
> I will post a new version of this which handles all these issues.  
> Expect it in a day or so.
> 

Please do. Thanks, that would be better.
Don't forget to also submit a patch for current head-of-line. It's exactly
the same fix but has diff conflicts with surrounding code.

> Alan Stern
> 

Boaz
