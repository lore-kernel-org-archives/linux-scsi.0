From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Fri, 1 Apr 2011 14:46:52 -0700
Message-ID: <20110401214652.GC25355@noexit>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <1301445210.2731.14.camel@mingming-laptop>
 <20110330021742.GL3008@dastard>
 <E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
 <4D9313E2.6080006@gmail.com>
 <20110401151907.GG21075@thunk.org>
 <AANLkTinZCx3gq-iDjPLzkvSFQNqAc1-bGN8xgzRz_=yj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinZCx3gq-iDjPLzkvSFQNqAc1-bGN8xgzRz_=yj@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Yongqiang Yang <xiaoqiangnk@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 01, 2011 at 09:30:04AM -0700, Amir Goldstein wrote:
> when writing DIO to indirect mapped file holes, we fall back to buffered write
> (so we won't expose stale data in the case of a crash) concurrent DIO reads
> to that file (before data writeback) can expose stale data. right?
> do you consider this case mixing buffered and DIO access?
> do you consider that as a problem?

	I do not consider this 'mixing', nor do I consider it a problem.
ocfs2 does exactly this for holes, unwritten extents, and CoW.  It does
not violate the user's expectation that the data will be on disk when
the write(2) returns.
	Falling back to buffered on read(2) is a different story; the
caller wants the current state of the disk block, not five minutes ago.
So we can't do that.  But we also don't need to.
	O_DIRECT users that are worried about any possible space usage in
the page cache have already pre-allocated their disk blocks and don't
get here.

Joel

-- 

"Under capitalism, man exploits man.  Under Communism, it's just 
   the opposite."
				 - John Kenneth Galbraith

			http://www.jlbec.org/
			jlbec@evilplan.org
