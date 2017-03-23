From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] qedf: fix wrong le16 conversion
Date: Thu, 23 Mar 2017 11:56:30 -0700 (PDT)
Message-ID: <20170323.115630.1600544123792478571.davem@davemloft.net>
References: <20170320084947.1031363-1-arnd@arndb.de>
        <yq1r31odqjs.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1r31odqjs.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, arnd@arndb.de, Ram.Amrani@cavium.com, Chad.Dupuis@cavium.com, Tomer.Tayar@cavium.com, Yuval.Mintz@cavium.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 23 Mar 2017 10:19:03 -0400

> Arnd Bergmann <arnd@arndb.de> writes:
> 
>> gcc points out that we are converting a 16-bit integer into a 32-bit
>> little-endian type and assigning that to 16-bit little-endian
>> will end up with a zero:
>>
>> drivers/scsi/qedf/drv_fcoe_fw_funcs.c: In function 'init_initiator_rw_fcoe_task':
>> include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
>>   t_st_ctx->read_write.rx_id = cpu_to_le32(FCOE_RX_ID);
>>
>> The correct solution appears to be to just use a 16-bit byte swap instead.
>>
>> Fixes: be086e7c53f1 ("qed*: Utilize Firmware 8.15.3.0")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/scsi/qedf/drv_fcoe_fw_funcs.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Dave: Since you queued the firmware patch, mind taking this fix through
> your tree?

Ok, applied to net-next, thanks.
