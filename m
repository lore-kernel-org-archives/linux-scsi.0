From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 3/3] blk_end_request: caller change
Date: Thu, 11 Jan 2007 12:01:51 -0500 (EST)
Message-ID: <20070111.120151.71083168.k-ueda@ct.jp.nec.com>
References: <20070110.180859.78702215.k-ueda@ct.jp.nec.com>
	<20070111083430.GD11203@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070111083430.GD11203@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

On Thu, 11 Jan 2007 09:34:31 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> > +static int cdrom_newpc_intr_dma_callback(void *arg)
> > +{
> > +	void **argv = (void **)arg;
> > +	struct request *rq = (struct request *)*argv++;
> > +	ide_drive_t *drive = (ide_drive_t *)argv++;
> > +	spinlock_t *ide_lock = (spinlock_t *)argv;
> > +
> > +	rq->data_len = 0;
> > +
> > +	cdrom_newpc_intr_callback_common(rq, drive, ide_lock);
> > +
> > +	return 0;
> > +}
> 
> And this is why, down right horrible. The callback should be correctly
> typed, pass down a request pointer ALWAYS.

OK.  I think everything such callbacks need can be obtained through
struct request.  (e.g. ide_drive_t can get by rq->q->queuedata and
ide_lock can get by rq->q->queue_lock.)
So I'll change the callback to pass a pointer to the request
instead of void *.

Thanks,
Kiyoshi Ueda
