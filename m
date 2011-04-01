From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Fri, 1 Apr 2011 14:43:03 -0700
Message-ID: <20110401214302.GB25355@noexit>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <1301445210.2731.14.camel@mingming-laptop>
 <20110330021742.GL3008@dastard>
 <E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
 <4D9313E2.6080006@gmail.com>
 <20110401151907.GG21075@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab1DAVnS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 17:43:18 -0400
Content-Disposition: inline
In-Reply-To: <20110401151907.GG21075@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.>

On Fri, Apr 01, 2011 at 11:19:07AM -0400, Ted Ts'o wrote:
> The closest place that we have to any official documentation about
> O_DIRECT semantics is the open(2) man page in the Linux manpages, and
> it doesn't say anything about this.  It does give a recommendation
> against not mixing buffered and O_DIRECT accesses to the same file,
> but it does promise that things will work in that case.  (Even if it
> does, do we really want to make the promise that it will always work?)

	No, we do not.  Some OSes will silently turn buffered I/O into
direct I/O if another file already has it opened O_DIRECT.  Some OSes
will fail the write, or the open, or both, if it doesn't match the mode
of an existing fd.  Some just leave O_DIRECT and buffered access
inconsistent.
	I think that Linux should strive to make the mixed
buffered/direct case work; it's the nicest thing we can do.  But we
should not promise it.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

			http://www.jlbec.org/
			jlbec@evilplan.org
