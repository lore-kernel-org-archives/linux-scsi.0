From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 7 Jan 2003 17:36:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107173633.A17825@beaverton.ibm.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E1B513B.2090409@splentec.com>; from luben@splentec.com on Tue, Jan 07, 2003 at 05:14:19PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 05:14:19PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:

> You must agree that the tuple (COMMAND, (lun, target, channel))
> doesn't say as much as (COMMAND, DEVICE). 

Yes, but the current code simply sends a scsi_cmnd to the LLDD, and the
LLDD need only reference the scsi_cmnd.

> Anywhich way you look at it,
> this is a better abstraction. 

Having the LLDD use more data structures does not imply a better
abstraction.  Again, a better abstraction would be to use interfaces to
get the host/channel/target/lun. This could add overhead depending on the
implementation.

> For this reason you might consider the suggestions by Doug, or research moving
> multipathing higher up into the char/block layer, or thereabouts.

I have looked into putting multipath in the block layer, I've looked at
md, at the T3 code, and at the qlogic multi-path code. Code in the block
layer would be interesting, but might not solve problems with char
devices, and would need further abstractions on top of some multi-path 
in the scsi layer (someone has to find and represent the devices and
paths, the block layer will not want to know about host/chan/target/lun,
nor will the block layer want to know details about scsi device or
transport errors).

> Somewhere between write(fd, buf, count) and scsi_request_fn(), multipathing
> will have to have already occured (ideally).

Putting the multipath abstraction into scsi_request_fn is IMO the best way
to go (as I've argued before) at least until other non-scsi block and
character devices support multi-pathing (maybe there are already
multi-path SATA devices, I don't know).

> > For scsi_device yes, but the LLDD does not have to look at scsi_device to
> > send a command, it can currently use the values found in scsi_cmnd.
> 
> You see, by abstractizing this way, you get rid of redundancies,
> which let's you do all those nice things which Doug mentioned.

> 
> Getting rid of redundancies in data design and code design is important.
> 

As mentioned, using a scsi_device both for a list of paths and as a
representation of scsi device duplicates data in multiple places.

-- Patrick Mansfield
