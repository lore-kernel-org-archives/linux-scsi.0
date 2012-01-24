From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 14:14:14 -0500
Message-ID: <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
References: <20120119094637.GA23442@quack.suse.cz>
	<4F1BFF5F.6000502@panasas.com> <20120123161857.GC28526@quack.suse.cz>
	<20120123175353.GD30782@redhat.com>
	<x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
	<20120124151504.GQ4387@shiny> <20120124165631.GA8941@infradead.org>
	<186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
	<x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
	<20120124184054.GA23227@infradead.org> <20120124190732.GH4387@shiny>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120124190732.GH4387@shiny> (Chris Mason's message of "Tue, 24
	Jan 2012 14:07:32 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chris Mason <chris.mason@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, fengguang.wu@gmail.com, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

>> All three filesystems use the generic mpages code for reads, so they
>> all get the same (bad) I/O patterns.  Looks like we need to fix this up
>> ASAP.
>
> Can you easily run btrfs through the same rig?  We don't use mpages and
> I'm curious.

The readahead code was to blame, here.  I wonder if we can change the
logic there to not break larger I/Os down into smaller sized ones.
Fengguang, doing a dd if=file of=/dev/null bs=1M results in 128K I/Os,
when 128KB is the read_ahead_kb value.  Is there any heuristic you could
apply to not break larger I/Os up like this?  Does that make sense?

Cheers,
Jeff
