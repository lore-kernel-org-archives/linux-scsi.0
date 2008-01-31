From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Thu, 31 Jan 2008 21:53:40 +0200
Message-ID: <47A22744.7010201@panasas.com>
References: <Pine.LNX.4.44L0.0801311425540.2502-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24370 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763480AbYAaTxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 14:53:51 -0500
In-Reply-To: <Pine.LNX.4.44L0.0801311425540.2502-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Glines <mark@glines.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jan 31 2008 at 21:34 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 31 Jan 2008, Boaz Harrosh wrote:
> 
>> On Thu, Jan 31 2008 at 19:49 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
>>> On Thu, 31 Jan 2008, Boaz Harrosh wrote:
>>>
>>>> @@ -228,9 +228,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
>>>>  {
>>>>  	unsigned int offset = 0;
>>>>  	struct scatterlist *sg = NULL;
>>>> +	unsigned int count;
>>>>  
>>>> -	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>>>> +	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>>>>  			TO_XFER_BUF);
>>>> -	if (buflen < scsi_bufflen(srb))
>>>> -		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
>>>> +
>>>> +	/* Check for underflow */
>>>> +	if (buflen > scsi_bufflen(srb))
>>>> +		count = buflen;
>>>> +
>>>> +	scsi_set_resid(srb, scsi_bufflen(srb) - count);
>>>>  }
>>> This last "if" statement doesn't look right.  And since you know that
>>> count will never be larger than scsi_bufflen(srb), you don't have to
>>> check for underflow at all.  Just leave out the "if" and call
>>> scsi_set_resid() directly.
>>>
>>> Alan Stern
>>>
>> I was thinking about that hard. And I disagree. It could be that we have
>> sg-list length (The total of all sg->length) that does not match
>> scsi_bufflen() - More or less.
> 
> If that ever happens we'll be in big trouble.  Not just here but in 
> other places as well.
Other places is other places, but you cannot put a BUG_ON here for other
places. This place here should be correct.

> 
>> The code in usb_stor_access_xfer_buf() will 
>> now correctly attempt to transfer according to buflen and what ever is available
>> at the passed sg's. Now this can be less or it can be more. SCSI standard defines
>> this as underflow/overflow. When overflow should be reported as negative values.
>> and an error status. (BUT not CHECK_CONDITION)
> 
> I don't understand.  How could you ever transfer more data than the 
> requested amount?  The host won't expect to receive it and won't be 
> able to handle it when it arrives.
> 
> (Furthmore, the USB mass-storage specification does not permit more 
> data to be transferred than requested.  This fact isn't relevant to our 
> discussion because we're talking about situations where the data was 
> transferred via a non-standard protocol.  But even so...)
That's fine then the transfer will abort with an error condition and will
be handled correctly.

> 
>> so the code is actualy
>> 	if (buflen > scsi_bufflen(srb))
>> 		scsi_set_resid(srb, scsi_bufflen(srb) - buflen); /* Negative overflow */
> 
> Okay, let's assume that both buflen and the sum of the sg-list lengths
> are somehow greater than scsi_bufflen(srb).  You still don't know that
> they are equal to each other.  All you know is that the amount actually
> transferred is stored in count.  Hence the negative overflow value
> should be
> 
> 	scsi_bufflen(srb) - count
> 
> and not
> 
> 	scsi_bufflen(srb) - bufflen.
> 
> Alan Stern
> 
No, it is possible that sg-length was good and count == bufflen,
But the CDB contains scsi_bufflen(srb) and this is an overflow
condition. with your code resid will be Zero.
Also the standard say that we should return the expected overflow and
not the actual on-the-wire overflow.

We could check and truncate beforehand, and mark a flag for overflow
and set negative resid. But since usb_stor_access_xfer_buf() properly
handles that and returns, then this form saves cycles for the common 
case and waists cycles for the very rare BUG case of overflow, but is
still correct and safe.

Boaz
