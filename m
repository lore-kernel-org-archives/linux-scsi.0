From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
Date: Wed, 07 Aug 2013 11:17:21 -0500
Message-ID: <52027311.9060904@redhat.com>
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com> <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com> <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDW_nPZPBH=X-fOM4sddhVNkojEp4gUQseSJJaJAxfNqqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Doug Gilbert <dgilbert@interlog.com>, James Bottomley <JBottomley@parallels.com>, Costa Sapuntzakis <costa@purestorage.com>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Jeffery <djeffery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Roland Dreier wrote:
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
> 

Hi Roland,

Actually, I was waiting for confirmation from the field which I
recently received, I was getting ready to bring this up on linux-scsi,
sorry I should have brought it up sooner. I wasn't positive that setting
BIO_NULL_MAPPED flag from sg driver was the fix. David Jeffery
came up with a reproducer which I ran overnight on the latest
upstream kernel with your patch.

Thanks,
David
