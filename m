From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Thu, 19 Jan 2012 22:39:58 +0100
Message-ID: <20120119213958.GJ8316@redhat.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
 <20120117200609.GA7933@redhat.com>
 <20120117213648.GA9457@quack.suse.cz>
 <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
 <20120119150849.GD8316@redhat.com>
 <20120119205211.GB3629@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120119205211.GB3629@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2012 at 09:52:11PM +0100, Jan Kara wrote:
> anything. So what will be cheaper depends on how often are redirtied pages
> under IO. This is rather rare because pages aren't flushed all that often.
> So the effect of stable pages in not observable on throughput. But you can
> certainly see it on max latency...

I see your point. A problem with migrate though is that the page must
be pinned by the I/O layer to prevent migration to free the page under
I/O, or how else it could be safe to read from a freed page? And if
the page is pinned migration won't work at all. See page_freeze_refs
in migrate_page_move_mapping. So the pinning issue would need to be
handled somehow. It's needed for example when there's an O_DIRECT
read, and the I/O is going to the page, if the page is migrated in
that case, we'd lose a part of the I/O. Differentiating how many page
pins are ok to be ignored by migration won't be trivial but probably
possible to do.

Another way maybe would be to detect when there's too much re-dirtying
of pages in flight in a short amount of time, and to start the bounce
buffering and stop waiting, until the re-dirtying stops, and then you
stop the bounce buffering. But unlike migration, it can't prevent an
initial burst of high fault latency...
