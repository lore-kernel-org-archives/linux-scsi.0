From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Sun, 03 Feb 2008 10:59:09 +0200
Message-ID: <47A5825D.2030901@panasas.com>
References: <Pine.LNX.4.44L0.0801311546450.22845-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0801311546450.22845-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 31 2008 at 22:56 +0200, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Thu, 31 Jan 2008, Boaz Harrosh wrote:
> 
>>>> The code in usb_stor_access_xfer_buf() will 
>>>> now correctly attempt to transfer according to buflen and what ever is available
>>>> at the passed sg's. Now this can be less or it can be more. SCSI standard defines
>>>> this as underflow/overflow. When overflow should be reported as negative values.
>>>> and an error status. (BUT not CHECK_CONDITION)
>>> I don't understand.  How could you ever transfer more data than the 
>>> requested amount?  The host won't expect to receive it and won't be 
>>> able to handle it when it arrives.
>>>
>>> (Furthmore, the USB mass-storage specification does not permit more 
>>> data to be transferred than requested.  This fact isn't relevant to our 
>>> discussion because we're talking about situations where the data was 
>>> transferred via a non-standard protocol.  But even so...)
>> That's fine then the transfer will abort with an error condition and will
>> be handled correctly.
> 
> I still don't understand.  Can you explain exactly what an overflow 
> condition (negative residue) really means?
As far as the protocol it is an error condition. But it is an error
condition that should be handled and io should continue. What it usually means
is that either target or Initiator had, like you said, more data then
expected. Usually an encoding error of the different stages of transfer
like sum of R2Ts or DATA is bigger then CDB length and so on.
The important thing is that the system should continue, and that this
is not a check_condition error.

> 
> Does it mean that the device had more data available than the host
> asked for?  If it does, then you don't need to change the isd200 code
> at all.  The changes to protocol.c will be enough.
I do in the sense that the target should return correct information requested.
overflow is still an error. A recoverable but none-standard error. The INQUIRY
has 3 flavors based on requested size. The target should comply.

> 
> However you should realize that usb-storage, as it stands, won't work
> properly with negative residues.  Look at usb_stor_Bulk_transport() in
> transport.c.  The residue variable is declared to be unsigned int.  
> There's also code later on in the routine which assumes the residue is
> never negative.
> 
> Alan Stern
> 
> -
I will change that, but if you don't mind with a FIXME: comment next
to it. I will set resid to 1 and set the cmnd->status. Setting of command
status is ineffective as it is, most probably, been set afterwards.
Should I also put a WARN_ON()? I would say yes.
I'll send a patch.

Boaz
