From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 10/11] block: add a report_zones method
Date: Tue, 16 Oct 2018 11:17:27 -0400
Message-ID: <20181016151727.GA26807@redhat.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-11-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181012100850.23316-11-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 12 2018 at  6:08am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> Dispatching a report zones command through the request queue is a major
> pain due to the command reply payload rewriting necessary. Given that
> blkdev_report_zones() is executing everything synchronously, implement
> report zones as a block device file operation instead, allowing major
> simplification of the code in many places.
> 
> sd, null-blk, dm-linear and dm-flakey being the only block device
> drivers supporting exposing zoned block devices, these drivers are
> modified to provide the device side implementation of the
> report_zones() block device file operation.
> 
> For device mappers, a new report_zones() target type operation is
> defined so that the upper block layer calls blkdev_report_zones() can
> be propagated down to the underlying devices of the dm targets.
> Implementation for this new operation is added to the dm-linear and
> dm-flakey targets.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [Damien]
> * Changed method block_device argument to gendisk
> * Various bug fixes and improvements
> * Added support for null_blk, dm-linear and dm-flakey.
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
