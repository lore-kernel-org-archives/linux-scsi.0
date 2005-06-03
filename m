From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Fri, 3 Jun 2005 12:37:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506031218380.6451-100000@iolanthe.rowland.org>
References: <20050603160921.GA32212@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:62955 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261382AbVFCQhJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2005 12:37:09 -0400
In-Reply-To: <20050603160921.GA32212@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

[Now on-list]

On Fri, 3 Jun 2005, Patrick Mansfield wrote:

> On Fri, Jun 03, 2005 at 11:04:28AM -0400, Alan Stern wrote:
> 
> > As for lost Unit Attentions, what about events like media changes?  I can 
> > easily imagine those sorts of notifications getting swallowed by the error 
> > handler.
> 
> Yeh ... that sounds bad.
> 
> And the scsi_eh_tur() losing the media change looks broken! See
> drivers/scsi/scsi_lib.c, search for "->changed". I am thinking there are
> other similar cases, probably search and compare handling of other UNIT
> ATTENTIONs and checking of sense result.
> 
> scsi_eh_tur() should do the same things as scsi_test_unit_ready(). We need
> some helper function(s).
> 
> And we have to handle sd and sg both getting the media change, again
> might be true for other UNIT ATTENTIONs. 

Actually it looks like media change is the worst case.  The use_10_for_rw 
stuff in scsi_io_completion() and other various retry pathways shouldn't 
be invoked for sg.

> We might be able to pass back the data to sg by conditionally (just UNIT
> ATTENTION, or all cases???) not clearing the sense data (as per current
> code) and marking the sense data as present, prehaps just "scmd->result &=
> CHECK_CONDITION".
> 
> This seems a bit tricky. I have not thought this through, and don't have
> any patches :-)

I don't have any patches either, and it's not clear that simply passing
the sense data through would work.  Other status bits would lead the
client to believe that the original command aborted without returning
Check Condition status (although the error handler's TUR did get CC), so
the client might not bother to look at the sense data.

> So we should verify all command completions in scsi_error.c are OK, and
> add a helper function(s) called for all scsi IO completions to check UNIT
> ATTENTION etc. And then maybe keep sense data from the TUR for use with
> the timed out command.

Maybe.  It might work if you can fool the client into thinking the
timed-out command failed with the appropriate status.  Making up fake
return values like this doesn't seem to be a good idea... but perhaps for 
Unit Attention it's acceptable.

Come to think of it, the error handler doesn't stop when it sees Unit
Attention, does it?  It sends another TUR, looking for valid status.  (As
a side issue, this behavior needs to be fixed as well.  TUR will always
fail when no medium is present; the error handler should accept such a
failure and not try to do any further error recovery.)

Alan Stern

