From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 09/28] blk_end_request: changing ps3disk
	(take 3)
Date: Mon, 03 Dec 2007 17:55:44 -0500 (EST)
Message-ID: <20071203.175544.13775421.k-ueda@ct.jp.nec.com>
References: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
	<Pine.LNX.4.64.0712021032490.29349@anakin>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0712021032490.29349@anakin>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Geert.Uytterhoeven@sonycom.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Hi Geert,

On Sun, 2 Dec 2007 10:34:56 +0100 (CET), Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> On Fri, 30 Nov 2007, Kiyoshi Ueda wrote:
> > This patch converts ps3disk to use blk_end_request().
>                                      ^^^^^^^^^^^^^^^
> Patch subject and description are inconsistent with actual change.
> 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > ---
> >  drivers/block/ps3disk.c |    6 +-----
> >  1 files changed, 1 insertion(+), 5 deletions(-)
> > 
> > Index: 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> > ===================================================================
> > --- 2.6.24-rc3-mm2.orig/drivers/block/ps3disk.c
> > +++ 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> > @@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
> >  	}
> >  
> >  	spin_lock(&priv->lock);
> > -	if (!end_that_request_first(req, uptodate, num_sectors)) {
> > -		add_disk_randomness(req->rq_disk);
> > -		blkdev_dequeue_request(req);
> > -		end_that_request_last(req, uptodate);
> > -	}
> > +	__blk_end_request(req, uptodate, num_sectors << 9);
>       ^^^^^^^^^^^^^^^^^

Thank you for the comment.
The description meant the blk_end_request family, not actual function,
blk_end_request().  But as you pointed out, it is misleading.
I'll change the description of all related patches.

Thanks,
Kiyoshi Ueda
