From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 10/13] dm: add core functions for
	request-based dm
Date: Tue, 28 Oct 2008 12:00:31 -0400 (EDT)
Message-ID: <20081028.120031.71084925.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104612.115643090.k-ueda@ct.jp.nec.com>
	<807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nikanth@gmail.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, knikanth@suse.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, j-nomura@ce.jp.nec.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Nikanth,

On Fri, 24 Oct 2008 13:14:50 +0530, "Nikanth K" wrote:
> On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda wrote:
> <snip>
> 
> > +static int dm_make_request(struct request_queue *q, struct bio *bio)
> > +{
> > +       struct mapped_device *md = (struct mapped_device *)q->queuedata;
> > +
> > +       if (unlikely(bio_barrier(bio))) {
> > +               bio_endio(bio, -EOPNOTSUPP);
> > +               return 0;
> > +       }
> > +
> <snip>
> 
> Why not add barrier support in the beginning itself, so that targets
> can be developed with barriers in mind? At least can we make the target
> to return error, instead of the core?

Currently, there is no barrier support in dm, not only request-based.
Barrier support is a different feature in the next step, I think.

As you noticed in the PATCH#11, current request-based dm has
the limitation that multiple targets are not supported, so it may
look barrier support in request-based dm is easy.
But we may be able to remove the limitation in the future, so
depending on it is not a good idea.

Thanks,
Kiyoshi Ueda
