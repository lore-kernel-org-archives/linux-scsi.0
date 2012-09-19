From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix endianness of task management response code
Date: Wed, 19 Sep 2012 00:43:56 -0500
Message-ID: <CC7F593D.E135%saurav.kashyap@qlogic.com>
References: <1348006256-23551-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:17413
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab2ISFoF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Sep 2012 01:44:05 -0400
In-Reply-To: <1348006256-23551-1-git-send-email-roland@kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>



>From: Roland Dreier <roland@purestorage.com>
>
>The qla2xxx firmware actually expects the task management response
>code in a CTIO IOCB with SCSI status mode 1 to be in little-endian
>byte order, ie the response code should be the first byte in the
>sense_data[] array.  The old code erroneously byte-swapped the
>response code, which puts it in the wrong place on the wire and leads
>to initiators thinking every task management request succeeds (since
>they see 0 in the byte where they look for the response code).
>
>Cc: Chad Dupuis <chad.dupuis@qlogic.com>
>Cc: Arun Easi <arun.easi@qlogic.com>
>Signed-off-by: Roland Dreier <roland@purestorage.com>
>---
> drivers/scsi/qla2xxx/qla_target.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_target.c
>b/drivers/scsi/qla2xxx/qla_target.c
>index 5b30132..41b74ba 100644
>--- a/drivers/scsi/qla2xxx/qla_target.c
>+++ b/drivers/scsi/qla2xxx/qla_target.c
>@@ -1403,7 +1403,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct
>scsi_qla_host *ha,
>       ctio->u.status1.scsi_status =
>           __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
>       ctio->u.status1.response_len = __constant_cpu_to_le16(8);
>-      ((uint32_t *)ctio->u.status1.sense_data)[0] = cpu_to_be32(resp_code);
>+      ctio->u.status1.sense_data[0] = resp_code;
>
>       qla2x00_start_iocbs(ha, ha->req);
> }
>--
>1.7.10.4

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

