From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [usb-storage] Re: 2 PATCHES: fix request_tranferlength
Date: Mon, 29 Jul 2002 23:50:45 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207292313280.1307-100000@kai.makisara.local>
References: <20020729155059.A20905@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020729155059.A20905@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

On Mon, 29 Jul 2002, Doug Ledford wrote:

> On Mon, Jul 29, 2002 at 12:01:24AM +0300, Kai Makisara wrote:
...
> > My interpretation is that bufflen in the call should be 255 in this case.
> > Using 512 is a bug. Is it useful for the lower levels to know how much
> > excess space the caller has reserved? If it is, I take back my suggestion.
>
> No, that just confuses the issue needlessly and down that road lies future
> bugs.
>
It simplifies the issue. However, note that we are looking at the problem
from different sides of the scsi_do_req() interface. I am arguing that for
the _users_ of scsi_do_req() the current situation is confusing and adding
a new member to Scsi_Request only makes it worse. You are looking at the
problem as consumer of Scsi_Cmnds.

We are talking about 2.5. Perhaps the scsi_do_req() interface should be
cleaned. If you don't want to use function arguments, everything
necessary can be stuffed directly into Scsi_Request and the parameters
buff, bufflen, cmnd, done, timeout, retries can be removed.

...
> > I think we both agree that the information in dxfer_len must be passed.
> > The difference is that you suggest adding a new field to Scsi_Request
> > whereas I suggest clarifying the meaning of the existing bufflen
> > parameter.
>
> There really isn't a need to clarify the meaning of the request_bufflen
                                                          ^^^^^^^^^^^^^^^
I agree, but I was talking about the bufflen parameter of the
scsi_do_req() function taking Scsi_Request. request_bufflen is a field in
struct Scsi_Cmnd.

	Kai


