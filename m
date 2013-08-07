From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Wed, 07 Aug 2013 12:31:30 -0400
Message-ID: <52027662.6060103@interlog.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com> <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com> <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54009 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab3HGQcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Aug 2013 12:32:18 -0400
In-Reply-To: <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: David Milburn <dmilburn@redhat.com>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Jeffery <djeffery@redhat.com>

On 13-08-07 11:50 AM, Roland Dreier wrote:
> On Wed, Aug 7, 2013 at 7:38 AM, David Milburn <dmilburn@redhat.com> wrote:
>> I was able to succesfully test this patch overnight, I had been experimenting with the
>> sg driver setting the BIO_NULL_MAPPED flag in sg_rq_end_io_usercontext for a orphan process
>> which prevented the corruption, but your solution seems much better.
>
> Very cool, thanks for the testing.
>
> I actually looked at using BIO_NULL_MAPPED as well, but it seemed a
> bit too fragile to me -- it had the right effect of skipping
> __bio_copy_iov(), and skipping the __free_pages() stuff in there is OK
> because sg owns its pages rather than the bio layer, but all that
> seemed vulnerable to being broken by an unrelated change.
>
> Out of curiousity, were you already working on this bug?  Because if
> you had fixed it a few weeks earlier we might not have spent so long
> wondering WTF was stomping on the memory of one of our processes :)

Roland,
So what kind of signal was leading to your "stomping on the memory"?
Was it user generated or something like SIGIO, SIGPIPE or a RT signal?

To get around the SG_IO ioctl restart problem (for non idempotent
SCSI commands) could we replace a -ERESTARTSYS return value
with -EINTR ?

As I noted in a previous post, for robust user space code using the
SG_IO ioctl, masking signals during the IO may help.


And what about bsg? Is it any better or worse than sg in the case
of interrupted SG_IO ioctls? Apart from the interface (sg_io_hdr
v3 versus v4) it should be a drop in replacement for sg.

Doug Gilbert


