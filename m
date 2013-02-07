From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] protection information and userspace
Date: Thu, 07 Feb 2013 11:19:59 -0500
Message-ID: <x497gmkgkpc.fsf@segfault.boston.devel.redhat.com>
References: <20130206195122.GA30652@sgi.com>
	<20130206202444.GA4771@blackbox.djwong.org>
	<20DAFDEA-0C44-478E-B406-C5B08BC67FBC@oracle.com>
	<20130207094012.GA28047@localhost>
	<20130207100139.GB4773@blackbox.djwong.org> <51138FA0.1080507@suse.de>
	<51139940.3000902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <51139940.3000902@panasas.com> (Boaz Harrosh's message of "Thu, 7
	Feb 2013 14:08:32 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Hannes Reinecke <hare@suse.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Chuck Lever <chuck.lever@oracle.com>, Ben Myers <bpm@sgi.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Zach Brown <zab@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> writes:

>>> I also pondered simply adding a new io_prep_* function + IO_CMD_ code to libaio
>>> and all the other plumbing necessary to make that happen...
>>>
>>> void io_prep_preadv_pi(struct iocb *iocb, int fd, const struct iovec *iov,
>>> 		       int iovcnt, long long offset, const void *pi,
>>> 		       size_t pi_count);
>>>
>> This is also what I've envisioned.
>> Updating io_prep / async I/O is reasonably easy as its been using a 
>> separate structure for passing in the I/O details.
>> 
>> Normal read/write calls don't really map as you simply don't have 
>> enough parameter to feed PI information into the kernel.
>> So for that you'd need to invent a new interface / syscall.
>> 
>> For aio we just need to add additional fields to an existing structure.
>> 
>> So yeah, I'd be interested in that discussion as well.

Sure, it's easy to start there, but then you eventually end up having to
add a non-aio interface as well.  Let's not take the latter off the
table.

> Me too, in multiple fronts. It's part of my general concern about
>    "things we would like for user-mode servers"
>
> I think that the current aio and libaio Interface is broken for a long
> time, for multitude of reasons. For instance the nested structure definitions
> are COMPAT broken

News to me.  I run the libaio test harness built with -m32 on 64 bit
regularly.  What, exactly, is broken?

> , and lots of missing pieces. (For example search in archives
> for why bsg does not support sg-lists.)

> And there are all these additions that everyone wants on top, that call for
> a new interface anyway.

What was proposed above does not require a new interface.  It's just an
additional IO_CMD_*.  I'm not saying there aren't reasons for a new
interface, it's just I didn't see any in this thread.

> So I would like to see a deep fixup of this interface, with an aio version2
> that can take into considerations, all of future needs including these
> above. Kernel code will be very happy to be implemented with the new, interface
> and a COMPAT layer could be put in place for the old interface.
>
> All interested parties should bring to the table what is the extension/changes
> they need. And we can try and union all of them together.
>
> (My addition is for support of sg_lists to bsg, in a way that makes Tomo happy
>  I know that qemu was wanting this for a while as well as the multitude of
>  user-mode servers)

I'm not sure how that's directly related to aio, but ok.  If we're going
to rewrite the aio code, I think Zach's acall would be a good start, at
least on the API front:
  http://lwn.net/Articles/316806/

Cheers,
Jeff
