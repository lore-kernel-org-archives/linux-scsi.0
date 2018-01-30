From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 11:42:13 +0800
Message-ID: <20180130034212.GG17176@ming.t460p>
References: <1516726653.3339.20.camel@wdc.com>
	<20180124033109.GA15945@ming.t460p>
	<20180127190920.GA24759@redhat.com>
	<1517091161.3055.7.camel@wdc.com>
	<20180127234151.GA21710@ming.t460p>
	<1517244510.2687.10.camel@wdc.com>
	<20180130010701.GC17176@ming.t460p>
	<1517274681.2687.68.camel@wdc.com>
	<20180130033118.GF17176@ming.t460p>
	<1517283456.12842.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1517283456.12842.2.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 30, 2018 at 03:37:38AM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 11:31 +0800, Ming Lei wrote:
> > Please take a look at drivers, when BLK_STS_RESOURCE is returned, who
> > will call blk_mq_delay_run_hw_queue() for drivers?
> 
> As you know the SCSI and dm drivers in kernel v4.15 already call that function
> whenever necessary.

We have concluded that it is generic issue which need generic solution[1].

[1] https://marc.info/?l=linux-kernel&m=151638176727612&w=2

[ming@ming linux]$ git grep -n BLK_STS_RESOURCE ./drivers/ | wc -l
43

Almost every driver need this kind of change if BLK_STS_RESOURCE is returned
from IO path. And the failure can be caused by kmalloc(GFP_ATOMIC), DMA Mapping,
or what ever.

Thanks,
Ming
