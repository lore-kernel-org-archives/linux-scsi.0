From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Sun, 22 Jan 2012 13:31:38 +0200
Message-ID: <4F1BF39A.6090709@panasas.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz>
	<4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz>
	<20120119150849.GD8316@redhat.com>
	<20120119205211.GB3629@quack.suse.cz>
	<20120119213958.GJ8316@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120119213958.GJ8316@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 01/19/2012 11:39 PM, Andrea Arcangeli wrote:
> On Thu, Jan 19, 2012 at 09:52:11PM +0100, Jan Kara wrote:
>> anything. So what will be cheaper depends on how often are redirtied pages
>> under IO. This is rather rare because pages aren't flushed all that often.
>> So the effect of stable pages in not observable on throughput. But you can
>> certainly see it on max latency...
> 
> I see your point. A problem with migrate though is that the page must
> be pinned by the I/O layer to prevent migration to free the page under
> I/O, or how else it could be safe to read from a freed page? And if
> the page is pinned migration won't work at all. See page_freeze_refs
> in migrate_page_move_mapping. So the pinning issue would need to be
> handled somehow. It's needed for example when there's an O_DIRECT
> read, and the I/O is going to the page, if the page is migrated in
> that case, we'd lose a part of the I/O. Differentiating how many page
> pins are ok to be ignored by migration won't be trivial but probably
> possible to do.
> 
> Another way maybe would be to detect when there's too much re-dirtying
> of pages in flight in a short amount of time, and to start the bounce
> buffering and stop waiting, until the re-dirtying stops, and then you
> stop the bounce buffering. But unlike migration, it can't prevent an
> initial burst of high fault latency...

Or just change that RT program that is one - latency bound but, two - does
unpredictable, statistically bad, things to a memory mapped file.

Can a memory-mapped-file writer have some control on the time of
writeback with data_sync or such, or it's purely: Timer fired, Kernel see
a dirty page, start a writeout? What about if the application maps a
portion of the file at a time, and the Kernel gets more lazy on an active
memory mapped region. (That's what windows NT do. It will never IO a mapped
section unless in OOM conditions. The application needs to map small sections
and unmap to IO. It's more of a direct_io than mmap)

In any case, if you are very latency sensitive an mmap writeout is bad for
you. Not only because of this new problem, but because mmap writeout can
sync with tones of other things, that are do to memory management. (As mentioned
by Andrea). The best for latency sensitive application is asynchronous direct-io
by far. Only with asynchronous and direct-io you can have any real control on
your latency. (I understand they used to have empirically observed latency bound
but that is just luck, not real control)

BTW: The application mentioned would probably not want it's IO bounced at
the block layer, other wise why would it use mmap if not for preventing
the copy induced by buffer IO?

All that said, a mount option to ext4 (Is ext4 used?) to revert to the old
behavior is the easiest solution. When originally we brought this up in LSF
my thought was that the block request Q should have some flag that says
need_stable_pages. If set by the likes of dm/md-raid, iscsi-with-data-signed, DIFF
enabled devices and so on, and the FS does not guaranty/wants stable pages
then an IO bounce is set up. But if not set then the like of ext4 need not
bother.

Thanks
Boaz
