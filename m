From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Mon, 13 Jan 2003 12:33:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113123306.A16718@beaverton.ibm.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com> <20030107173633.A17825@beaverton.ibm.com> <20030111181224.B3178@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030111181224.B3178@infradead.org>; from hch@infradead.org on Sat, Jan 11, 2003 at 06:12:24PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

On Sat, Jan 11, 2003 at 06:12:24PM +0000, Christoph Hellwig wrote:
> On Tue, Jan 07, 2003 at 05:36:33PM -0800, Patrick Mansfield wrote:
> > Having the LLDD use more data structures does not imply a better
> > abstraction.  Again, a better abstraction would be to use interfaces to
> > get the host/channel/target/lun. This could add overhead depending on the
> > implementation.
> 
> Not having the cmnd replicate information in the device implies a better
> abstraction :)  The LLDD knows about struct scsi_device anyway.

I'm not against removing the replication, but a scsi_get_lun etc. does
not imply one implementation or the other.

This is _not_ just for multi-path. The current scsi code does not properly
size the target and lun based on the transport. For SPI the target and lun
need only be one byte; for FCP they are 4 and 8 bytes; for iSCSI I don't
know what. (Our current four byte host-ordered lun does not match anything
in any SCSI spec.)

Having a scsi_nexus or such that is host adapter specific (something like
Mike A. posted about) possibly with common transport code (for FCP, SPI,
and iSCSI) would be useful, and would make it easier to add multi-pathing
or support for future transports. The scsi_device current_tag, sdtr, wdtr,
and ppr would be moved to a scsi_nexus since they are SPI specific.

The abstraction of the channel should not even be part of scsi_device or
the scsi mid-layer.

> > > For this reason you might consider the suggestions by Doug, or research moving
> > > multipathing higher up into the char/block layer, or thereabouts.
> > 
> > I have looked into putting multipath in the block layer, I've looked at
> > md, at the T3 code, and at the qlogic multi-path code. Code in the block
> > layer would be interesting, but might not solve problems with char
> > devices,
> 
> Scsi character drivers _do_ go through the block layer.  (through
> scsi_do_req).

Okay - the only blk code the char drivers use is the blk_insert_request
call, the char drivers never call the generic_make_request. So any
implementation that relies on make_request (like md) won't currently work
with char devices.

-- Patrick Mansfield
