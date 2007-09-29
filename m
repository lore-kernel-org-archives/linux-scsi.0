From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Some plans for scsi_cmnd
Date: Sat, 29 Sep 2007 07:17:19 -0600
Message-ID: <20070929131718.GE12049@parisc-linux.org>
References: <20070925133733.GT10625@parisc-linux.org> <664A4EBB07F29743873A87CF62C26D70A0A205@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44437 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814AbXI2NRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2007 09:17:20 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70A0A205@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

On Fri, Sep 28, 2007 at 04:15:56PM -0600, Moore, Eric wrote:
> On Tuesday, September 25, 2007 7:38 AM, Matthew Wilcox wrote: 
> 
> > As I said, it's ambitious.  But it'll let us get rid of scsi_pointer
> > and host_scribble entirely.
> 
> Are you serious about removing the host_scribble?     In fusion we
> currently are hanging our per request message frame pointer there.

Yes.  But you snipped the explanation about why we wouldn't need it any
more.  You'd not be allocating scsi_cmnds, you'd be allocating a

struct fusion_scsi_cmnd {
	struct scsi_cmnd scmd;
	... everything currently in host_scribble ...
}

Of course, if you need the message frame pointer to be separated from
the command, you can just do:

struct fusion_scsi_cmnd {
	struct scsi_cmnd scmd;
	struct message_frame_pointer *host_scribble;
}

Or call it something more useful than host_scribble ;-)

> Its used for two reasons:
> 
> (1)  Old fibre channel firmware bug.  The bug is the same message frame
> completed twice.  1st completion is okay and the scsi_cmd is reallocated
> to some other IO.  Meanwhile the driver receives a double completion of
> the same message frame, and the driver attempts to complete the
> reallocated scsi_cmd to some other IO.  The sanity check on
> host_scribble avoids this.
> 
> (2)  error recovery threads decides to complete a scsi_cmd before its
> been returned back by the scsi lld, and the scsi_cmd is reused for some
> other IO.  Meanwhile fusion firmware finally  decides it wants to
> command the command, then the driver is completing the  reallocated
> scsi_cmd that is mapped to some other IO.  Again, host_scribble sanity
> check makes sure we finish off the scsi_cmd that its intended for.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
