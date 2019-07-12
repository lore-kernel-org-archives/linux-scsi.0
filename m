From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V6 3/4] sd_zbc: Fix report zones buffer
	allocation
Date: Fri, 12 Jul 2019 00:52:05 +0000
Message-ID: <BYAPR04MB58168DD2A9F429D515E377A1E7F20@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190701050918.27511-1-damien.lemoal@wdc.com>
	<20190701050918.27511-4-damien.lemoal@wdc.com>
	<yq1wogo85c6.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Martin,

On 2019/07/12 9:28, Martin K. Petersen wrote:
> 
> Damien,
> 
>> During disk scan and revalidation done with sd_revalidate(), the zones
>> of a zoned disk are checked using the helper function
>> blk_revalidate_disk_zones() if a configuration change is detected
>> (change in the number of zones or zone size). The function
>> blk_revalidate_disk_zones() issues report_zones calls that are very
>> large, that is, to obtain zone information for all zones of the disk
>> with a single command. The size of the report zones command buffer
>> necessary for such large request generally is lower than the disk
>> max_hw_sectors and KMALLOC_MAX_SIZE (4MB) and succeeds on boot (no
>> memory fragmentation), but often fail at run time (e.g. hot-plug
>> event). This causes the disk revalidation to fail and the disk
>> capacity to be changed to 0.
> 
> Probably easiest to funnel this through block with the rest of the
> series.

Sounds good to me.

Jens,

Could you please consider this series for 5.3 ? We have been using it in tests
since 2-3 weeks ago (5.2-rc6) without any problems. All revalidation problems
disappeared and with no side effects detected.

Thank you.

> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks !

-- 
Damien Le Moal
Western Digital Research
