From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [patch] [SCSI] qla2xxx: handle default case in
 qla2x00_request_firmware()
Date: Wed, 22 Feb 2012 10:17:36 -0500
Message-ID: <alpine.WNT.2.00.1202221017110.5728@N5102REMCQXM4BS.qlogic.org>
References: <20120221072939.GB6896@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45597
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751921Ab2BVPRr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2012 10:17:47 -0500
In-Reply-To: <20120221072939.GB6896@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Mon, 20 Feb 2012, Dan Carpenter wrote:

> This silences a static checker warning.  Also we're always adding new
> types of firmware, so it might fix a bug in real life some day.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 094af74..a2f9992 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4058,7 +4058,6 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>       struct qla_hw_data *ha = vha->hw;
>       struct fw_blob *blob;
>
> -     blob = NULL;
>       if (IS_QLA2100(ha)) {
>               blob = &qla_fw_blobs[FW_ISP21XX];
>       } else if (IS_QLA2200(ha)) {
> @@ -4079,6 +4078,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>               blob = &qla_fw_blobs[FW_ISP2031];
>       } else if (IS_QLA8031(ha)) {
>               blob = &qla_fw_blobs[FW_ISP8031];
> +     } else {
> +             return NULL;
>       }
>
>       mutex_lock(&qla_fw_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

