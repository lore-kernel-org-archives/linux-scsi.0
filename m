From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qedf: fix wrong le16 conversion
Date: Thu, 23 Mar 2017 10:19:03 -0400
Message-ID: <yq1r31odqjs.fsf@oracle.com>
References: <20170320084947.1031363-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170320084947.1031363-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 20 Mar 2017 09:49:27 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Ram Amrani <Ram.Amrani@cavium.com>, Chad Dupuis <Chad.Dupuis@cavium.com>, Tomer Tayar <Tomer.Tayar@cavium.com>, "Mintz, Yuval" <Yuval.Mintz@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> gcc points out that we are converting a 16-bit integer into a 32-bit
> little-endian type and assigning that to 16-bit little-endian
> will end up with a zero:
>
> drivers/scsi/qedf/drv_fcoe_fw_funcs.c: In function 'init_initiator_rw_fcoe_task':
> include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
>   t_st_ctx->read_write.rx_id = cpu_to_le32(FCOE_RX_ID);
>
> The correct solution appears to be to just use a 16-bit byte swap instead.
>
> Fixes: be086e7c53f1 ("qed*: Utilize Firmware 8.15.3.0")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/qedf/drv_fcoe_fw_funcs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Dave: Since you queued the firmware patch, mind taking this fix through
your tree?

-- 
Martin K. Petersen	Oracle Linux Engineering
