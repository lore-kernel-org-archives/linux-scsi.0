From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V6 3/4] sd_zbc: Fix report zones buffer
 allocation
Date: Thu, 11 Jul 2019 20:27:37 -0400
Message-ID: <yq1wogo85c6.fsf@oracle.com>
References: <20190701050918.27511-1-damien.lemoal@wdc.com>
 <20190701050918.27511-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190701050918.27511-4-damien.lemoal@wdc.com> (Damien Le Moal's
 message of "Mon, 1 Jul 2019 14:09:17 +0900")
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Damien,

> During disk scan and revalidation done with sd_revalidate(), the zones
> of a zoned disk are checked using the helper function
> blk_revalidate_disk_zones() if a configuration change is detected
> (change in the number of zones or zone size). The function
> blk_revalidate_disk_zones() issues report_zones calls that are very
> large, that is, to obtain zone information for all zones of the disk
> with a single command. The size of the report zones command buffer
> necessary for such large request generally is lower than the disk
> max_hw_sectors and KMALLOC_MAX_SIZE (4MB) and succeeds on boot (no
> memory fragmentation), but often fail at run time (e.g. hot-plug
> event). This causes the disk revalidation to fail and the disk
> capacity to be changed to 0.

Probably easiest to funnel this through block with the rest of the
series.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
