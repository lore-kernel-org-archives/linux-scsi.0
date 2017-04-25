From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] nvme/scsi: Consider LBA format in IO splitting
 calculation
Date: Tue, 25 Apr 2017 13:27:46 +0900
Message-ID: <267a4710-3a71-c08c-8e03-19bd2e73d056@wdc.com>
References: <20170425000243.2019-1-jonathan.derrick@intel.com>
 <20170425040025.GA23572@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170425040025.GA23572@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jon Derrick <jonathan.derrick@intel.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, keith.busch@intel.com, hch@infradead.org, sagi@grimberg.me
List-Id: linux-scsi@vger.kernel.org

Jon,

On 4/25/17 13:00, Jens Axboe wrote:
> On Mon, Apr 24 2017, Jon Derrick wrote:
>> The current command submission code uses a sector-based value when
>> considering the maximum number of blocks per command. With a
>> 4k-formatted namespace and a command exceeding max hardware limits, this
>> calculation doesn't split IOs which should be split and fails in the
>> nvme layer. This patch fixes that calculation and enables IO splitting
>> in these circumstances.
>>
>> Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
>> ---
>>  drivers/nvme/host/scsi.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvme/host/scsi.c b/drivers/nvme/host/scsi.c
>> index f49ae27..988da61 100644
>> --- a/drivers/nvme/host/scsi.c
>> +++ b/drivers/nvme/host/scsi.c
>> @@ -1609,7 +1609,7 @@ static int nvme_trans_do_nvme_io(struct nvme_ns *ns, struct sg_io_hdr *hdr,
>>  	struct nvme_command c;
>>  	u8 opcode = (is_write ? nvme_cmd_write : nvme_cmd_read);
>>  	u16 control;
>> -	u32 max_blocks = queue_max_hw_sectors(ns->queue);
>> +	u32 max_blocks = queue_max_hw_sectors(ns->queue) >> (ns->lba_shift - 9);
>>  
>>  	num_cmds = nvme_trans_io_get_num_cmds(hdr, cdb_info, max_blocks);
> 
> Patch looks correct to me, as we always consider the hw sectors settings
> in units of 512b blocks.
> 
> Reviewed-by: Jens Axboe <axboe@fb.com>

May be replace 9 with SECTOR_SHIFT ?

Jens,

I just realized that this macro is defined in linux/device-mapper.h,
which does not seem like to best place to have it. Why not blkdev.h ?
Any particular reason ? This leads to some strange include dependencies,
like many nfs/blocklayout/ files including device-mapper.h just to get
that definition.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
