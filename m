From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Lsf-pc]   [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 23:15:13 -0700
Message-ID: <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
References: <20120124151504.GQ4387@shiny> <20120124165631.GA8941@infradead.org>
	<186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
	<x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
	<20120124184054.GA23227@infradead.org>
	<20120124190732.GH4387@shiny>
	<x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
	<20120124200932.GB20650@quack.suse.cz>
	<x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
	<20120124203936.GC20650@quack.suse.cz>
	<20120125032932.GA7150@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120125032932.GA7150@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wu Fengguang <fengguang.wu@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 2012-01-24, at 8:29 PM, Wu Fengguang wrote:
> On Tue, Jan 24, 2012 at 09:39:36PM +0100, Jan Kara wrote:
>> On Tue 24-01-12 15:13:40, Jeff Moyer wrote:
>>>> Maybe 128 KB is a too small default these days but OTOH noone prevents you
>>>> from raising it (e.g. SLES uses 1 MB as a default).
>>> 
>>> For some reason, I thought it had been bumped to 512KB by default.  Must
>>> be that overactive imagination I have...  Anyway, if all of the distros
>>> start bumping the default, don't you think it's time to consider bumping
>>> it upstream, too?  I thought there was a lot of work put into not being
>>> too aggressive on readahead, so the downside of having a larger
>>> read_ahead_kb setting was fairly small.
>> 
>>  Yeah, I believe 512KB should be pretty safe these days except for
>> embedded world. OTOH average desktop user doesn't really care so it's
>> mostly servers with beefy storage that care... (note that I wrote we raised
>> the read_ahead_kb for SLES but not for openSUSE or SLED (desktop enterprise
>> distro)).
> 
> Maybe we don't need to care much about the embedded world when raising
> the default readahead size? Because even the current 128KB is too much
> for them, and I see Android setting the readahead size to 4KB...
> 
> Some time ago I posted a series for raising the default readahead size
> to 512KB. But I'm open to use 1MB now (shall we vote on it?).

I'm all in favour of 1MB (aligned) readahead.  I think the embedded folks
already set enough CONFIG opts that we could trigger on one of those
(e.g. CONFIG_EMBEDDED) to avoid stepping on their toes.  It would also be
possible to trigger on the size of the device so that the 32MB USB stick
doesn't sit busy for a minute with readahead that is useless.

Cheers, Andreas
