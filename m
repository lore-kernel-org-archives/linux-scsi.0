From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Mon, 29 Jul 2002 00:01:24 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207282349430.1970-100000@kai.makisara.local>
References: <20020728123126.B12344@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020728123126.B12344@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On Sun, 28 Jul 2002, Matthew Dharm wrote:

> On Sun, Jul 28, 2002 at 01:22:40PM +0300, Kai Makisara wrote:
...
> The case of 'return short data' is a common one (INQUIRY, MODE_SENSE, etc.)
> and so is well handled.
>
Good. I just get worried when someone talks about the originator knowing
the length of the returned data :-)

...
> > The current interface is a little messy. The function scsi_do_req has the
> > following signature:
> >
> > void scsi_do_req(Scsi_Request * SRpnt, const void *cmnd,
> >               void *buffer, unsigned bufflen, void (*done) (Scsi_Cmnd *),
> >                  int timeout, int retries)
>
> Agreed.  Why half of these parameters aren't in the Scsi_Request structure
> is beyond me.
>
I like using parameters because they explicitly show what the function
needs. Passing the values in a subset of fields in a structure is somewhat
obscure. However, in this case I agree that everything can't be passed as
parameters.

> > Another interpretation (which I have used) is that the bufflen parameter
> > is always the length of the buffer _used in this transfer_. Whether the
> > buffer is contiguous or defined using scatter/gather list is determined by
> > SRpnt->sr_use_sg. (The lower level drivers don't have to know the actual
> > length of the buffer as long as it is long enough.)
>
> This is the interpretation I use in usb-storage.  Experimentally, it seems
> to be correct.
>
The st driver up to 2.5.27 has mostly violated these assumptions when
scatter/gather is used. The newest version sets the segment lengths sum up
to the transfer length. However, this is a byproduct of a future
enhancement.

> > The second interpretation has the transfer length in exactly one place. In
> > the first interpretation a complicated logic (or a new structure member)
> > is needed to get the transfer length. Do we need this or should we just
> > enforce the second interpretation (maybe change the name bufflen to
> > maxtransfer or something like that)?
> >
> > (If the new structure member dxfer_len is useful to lower level drivers, I
> > don't oppose adding it to Scsi_Request as long as it is set in
> > scsi_do_req. What I am opposing is to make the callers responsible for
> > redundant specifications.)
>
> Do you see from my explanation why dxfer_len is not redundant to any other
> fields?  One more example to try to make it clear...
>
> One code path in scsi_scan.c sends an INQUIRY with cmd[4] = xff.  This is a
> command to transfer (up to) 255 bytes.  The bufflen passed is 512.
>
My interpretation is that bufflen in the call should be 255 in this case.
Using 512 is a bug. Is it useful for the lower levels to know how much
excess space the caller has reserved? If it is, I take back my suggestion.

I think we both agree that the information in dxfer_len must be passed.
The difference is that you suggest adding a new field to Scsi_Request
whereas I suggest clarifying the meaning of the existing bufflen
parameter.

Whatever the result will be, I hope someone writes down the rules. (It is
also a good way to see if the definition is simple or complex :-)

> I can hear the objection "Why doesn't usb-storage inspect the command to
> determine the length?".  This is, in fact, what we do now.  It only works
> _most_ of the time, not all of the time.  Vendor-specifc commands are
> screwed.  Several opcodes have different meaning depending on what type of
> device they are sent to, so we're screwed there.  Commands which specify
> length in terms of "number of blocks" also screw us up, because we don't
> know what the block size is.
>
You don't hear the objection from me. I can just add a couple more:
- the new commands the standard defines during time
- why have the complicated parsing when the caller knows the address for
free

	Kai



