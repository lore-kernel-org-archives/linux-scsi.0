From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH][SCSI] scsi-mq: fix requests that use a separate CDB buffer
Date: Fri, 22 Aug 2014 20:52:47 -0400
Message-ID: <53F7E5DF.3090809@interlog.com>
References: <53F79FC3.6040907@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53F79FC3.6040907@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14-08-22 03:53 PM, Tony Battersby wrote:
> This patch fixes code such as the following with scsi-mq enabled:
>
>      rq = blk_get_request(...);
>      blk_rq_set_block_pc(rq);
>
>      rq->cmd = my_cmd_buffer; /* separate CDB buffer */
>
>      blk_execute_rq_nowait(...);
>
> Code like this appears in e.g. sg_start_req() in drivers/scsi/sg.c (for
> large CDBs only).  Without this patch, scsi_mq_prep_fn() will set
> rq->cmd back to rq->__cmd, causing the wrong CDB to be sent to the device.

Still looking at this one. 'sg_write_same --32' is my
tool of choice. The target is scsi_debug which needs
dif=2 (because mkp read the draft and only allows
WRITE SAME(32) when the protection_level=2). Turned
on command tracing and this is what I saw:

sd 7:0:0:0: scsi_debug: cmd 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
sd 7:0:0:0: scsi_debug: cmd 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 
24 6b d3 00 88 ff ff 20 00 c7 e8 00 00 00 00

So the WS(32) command did get through, it is the second
command that arrived on its tail that is a worry. So yes,
IMO it is broken.


Now the >16 byte cdb length in the sg driver
introduced in lk 3.17-rc1 was copied directly
from the bsg driver which has had that capability
for some time. Since your patch touches two files
in drivers/block I'm wondering the bsg driver's
 >16 byte cdb length capability is broken in
lk 3.16 ?

Doug Gilbert
