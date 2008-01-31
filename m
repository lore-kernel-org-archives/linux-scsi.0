From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Thu, 31 Jan 2008 21:00:06 +0200
Message-ID: <47A21AB6.5060203@panasas.com>
References: <Pine.LNX.4.44L0.0801311244430.4373-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0801311244430.4373-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 31 2008 at 19:49 +0200, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Thu, 31 Jan 2008, Boaz Harrosh wrote:
> 
>> @@ -228,9 +228,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
>>  {
>>  	unsigned int offset = 0;
>>  	struct scatterlist *sg = NULL;
>> +	unsigned int count;
>>  
>> -	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>> +	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
>>  			TO_XFER_BUF);
>> -	if (buflen < scsi_bufflen(srb))
>> -		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
>> +
>> +	/* Check for underflow */
>> +	if (buflen > scsi_bufflen(srb))
>> +		count = buflen;
>> +
>> +	scsi_set_resid(srb, scsi_bufflen(srb) - count);
>>  }
> 
> This last "if" statement doesn't look right.  And since you know that
> count will never be larger than scsi_bufflen(srb), you don't have to
> check for underflow at all.  Just leave out the "if" and call
> scsi_set_resid() directly.
> 
> Alan Stern
> 
I was thinking about that hard. And I disagree. It could be that we have
sg-list length (The total of all sg->length) that does not match
scsi_bufflen() - More or less. The code in usb_stor_access_xfer_buf() will 
now correctly attempt to transfer according to buflen and what ever is available
at the passed sg's. Now this can be less or it can be more. SCSI standard defines
this as underflow/overflow. When overflow should be reported as negative values.
and an error status. (BUT not CHECK_CONDITION)

so the code is actualy
	if (buflen > scsi_bufflen(srb))
		scsi_set_resid(srb, scsi_bufflen(srb) - buflen); /* Negative overflow */
	else
		scsi_set_resid(srb, scsi_bufflen(srb) - count);

So this is actually code equivalent to above. Minus the extra call site.

The SCSI standard does allow these conditions and the system should cope
and go on. So a BUG_ON() is not accepted, I think.

But, ok, I mixed up with the comment I'll resend. underflow => overflow.

Boaz
 
