From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V4 08/16] scsi: sd_zbc: Limit zone write locking to
 sequential zones
Date: Sun, 24 Sep 2017 18:51:47 +0200
Message-ID: <ef17e904-b0a2-f51c-d144-bbc91c732848@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
 <20170924070247.25560-9-damien.lemoal@wdc.com>
 <20170924151804.GB16608@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53406 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752416AbdIXQv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 12:51:59 -0400
In-Reply-To: <20170924151804.GB16608@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>

On 9/24/17 17:18, Christoph Hellwig wrote:
>> +	if (q->seq_zones && test_bit(zno, q->seq_zones))
>> +		return BLKPREP_OK;
> 
> Isn't the check above inverted?  Also shouldn't it use blk_rq_zone_is_seq?
> E.g.
> 
> 	if (!blk_rq_zone_is_seq(cmd->request))
> 		return BLKPREP_OK;
> ?

Arrg ! Good catch. I tested only the scsi-mq case which does not use
this path anymore (same test used, but at the scheduler level). Silly of
me. I should have properly tested all cases.

Will fix this.

Thanks.

-- 
Damien Le Moal
Western Digital Research
