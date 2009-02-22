From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH (resend)]: SCSI: fix /proc memory leak in the SCSI core
Date: Sun, 22 Feb 2009 13:46:03 -0600
Message-ID: <1235331963.4531.61.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902221431170.30449-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51311 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbZBVTqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2009 14:46:08 -0500
In-Reply-To: <Pine.LNX.4.44L0.0902221431170.30449-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2009-02-22 at 14:34 -0500, Alan Stern wrote:
> On Sun, 22 Feb 2009, James Bottomley wrote:
> 
> > OK, but resending a patch you expressed reservations about putting in
> > without testing doesn't really help me.  I need a way to get comfortable
> > with its safety.
> > 
> > So, what about this alternative fix instead: if the removal were moved
> > to scsi_host_put(), that would address all the problems and have the
> > advantage that everyone will test it ...
> 
> I thought of doing it that way too.  It has the disadvantage of
> exposing part of the proc interface to userspace before the host is
> registered.  Now, since all we're adding is the host's directory, maybe 
> this doesn't matter.  But it didn't seem like a good idea.

It's current behaviour (and has been so for all of git history) with no
reported bugs.

All it's doing is creating a proc dir ... it's not exposing any
interfaces within, so from a theoretical standpoint it's perfectly OK.
The necessity for finding a legacy system to test was precisely because
you moved it.

James


