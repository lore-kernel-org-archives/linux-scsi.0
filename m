From: Doug Ledford <dledford@redhat.com>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Mon, 29 Jul 2002 15:51:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729155059.A20905@redhat.com>
References: <20020728123126.B12344@one-eyed-alien.net> <Pine.LNX.4.44.0207282349430.1970-100000@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0207282349430.1970-100000@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Mon, Jul 29, 2002 at 12:01:24AM +0300
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On Mon, Jul 29, 2002 at 12:01:24AM +0300, Kai Makisara wrote:
> On Sun, 28 Jul 2002, Matthew Dharm wrote:
> 
> > > The second interpretation has the transfer length in exactly one place. In
> > > the first interpretation a complicated logic (or a new structure member)
> > > is needed to get the transfer length. Do we need this or should we just
> > > enforce the second interpretation (maybe change the name bufflen to
> > > maxtransfer or something like that)?
> > >
> > > (If the new structure member dxfer_len is useful to lower level drivers, I
> > > don't oppose adding it to Scsi_Request as long as it is set in
> > > scsi_do_req. What I am opposing is to make the callers responsible for
> > > redundant specifications.)
> >
> > Do you see from my explanation why dxfer_len is not redundant to any other
> > fields?  One more example to try to make it clear...
> >
> > One code path in scsi_scan.c sends an INQUIRY with cmd[4] = xff.  This is a
> > command to transfer (up to) 255 bytes.  The bufflen passed is 512.
> >
> My interpretation is that bufflen in the call should be 255 in this case.
> Using 512 is a bug. Is it useful for the lower levels to know how much
> excess space the caller has reserved? If it is, I take back my suggestion.

No, that just confuses the issue needlessly and down that road lies future 
bugs.

> I think we both agree that the information in dxfer_len must be passed.
> The difference is that you suggest adding a new field to Scsi_Request
> whereas I suggest clarifying the meaning of the existing bufflen
> parameter.

There really isn't a need to clarify the meaning of the request_bufflen 
item.  It's meaning has been set for some time (1.x days).  However, 
documenting the proper use of those variables in a low level driver might 
be usefull.  So, here's a psuedo code example of how to interpret these 
data items:

if(cmd->use_sg) {
	struct scatterlist *sg = (struct scatterlist *)cmd->request_buffer;
	int i, length;

	{ walk sg table, build hardware dependant sg list, add length of
	  each sg segment to length, length will be total transfer length
	  when done walking list }
} else if(cmd->request_bufflen) {
	cmd->request_buffer is pointer to actual contiguous buffer
	cmd->request_bufflen is amount of data to be transferred (max)
	cmd->underflow is minimum amount of data we should transfer
		(your driver should return DID_ERROR if final transfer
		 length was less than cmd->underflow and it should set
		 the cmd->residual field to indicate how much of an
		 underflow we had) (note: I think it's cmd->residual you
		 need to set, I haven't look recently)
} else
	no data transfer expected (things like TEST_UNIT_READY)

> Whatever the result will be, I hope someone writes down the rules. (It is
> also a good way to see if the definition is simple or complex :-)

It's more complex than it should be.  My personal opinion, all transfers 
should use a sg table, period.  Even single segment transfers should 
still be set up as such.  The logic would then become if(cmd->use_sg) {set 
up sg list } else {no data transfer}.  Making this a reality would require 
driver updates though since there are some drivers known to fail on single 
element sg tables.  Getting the above logic correct is paramount to having 
a working PCI DMA API driver BTW.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
