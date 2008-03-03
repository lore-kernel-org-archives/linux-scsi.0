From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for
 request stacking
Date: Mon, 03 Mar 2008 14:04:27 -0500 (EST)
Message-ID: <20080303.140427.39152329.k-ueda@ct.jp.nec.com>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
	<47CC2652.1080601@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47CC2652.1080601@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

On Mon, 03 Mar 2008 17:24:50 +0100, Hannes Reinecke wrote:
> Hi Kiyoshi,
> 
> Kiyoshi Ueda wrote:
> > This patch adds ->complete_io() hook for request stacking.
> > Request stacking drivers (such as request-based dm) can set
> > a callback for completion.
> > (The hook is not called in blk_end_io(), since request-based dm uses
> >  it for clone completion in the following appendix patches.)
> > 
> [ .. ]
> I would rather have rq->complete_io() to be pointing to blk_end_io in the
> default case, this way rq->complete_io() would always be valid and we
> would be saving us the if() clause.

Thank you for the comment.

I'm thinking about an idea come from Mike and Jens after the session
at LSF'08:
  o stacking driver clones both bio and request and uses
    bio->bi_end_io and rq->end_io
  o stacking driver uses blk_complete_request() in rq->end_io
    so that stacking driver can work without queue lock
With this idea, we don't need to add the new hook to request,
and we can use request stacking on drivers using __blk_end_request().

Currently, I'm trying to convert request-based dm to use the idea above.
I'll post the new version as a RFC in the near future.

Thanks,
Kiyoshi Ueda
