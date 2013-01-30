From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [patch] [SCSI] qla4xxx: don't free NULL dma pool
Date: Wed, 30 Jan 2013 12:41:06 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD03422B@avmb3.qlogic.org>
References: <20130130070731.GC12396@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:39588
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851Ab3A3MlZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 07:41:25 -0500
In-Reply-To: <20130130070731.GC12396@elgon.mountain>
Content-Language: en-US
Content-ID: <F8876F43FB811C47A1E01DFB8077E809@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Ravi Anand <ravi.anand@qlogic.com>
Cc: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>


-----Original Message-----
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wednesday 30 January 2013 12:37 PM
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas <vikas.chaudhary@qlogic.com>, Dept-Eng iSCSI Driver
<Dept-iSCSIDriver@qlogic.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>,
"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: [patch] [SCSI] qla4xxx: don't free NULL dma pool

>The error path calls dma_pool_free() on this path but "chap_table" is
>NULL and "chap_dma" is uninitialized.  It's cleaner to just return
>directly.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c
>b/drivers/scsi/qla4xxx/ql4_mbx.c
>index 1c57c22..887e409 100644
>--- a/drivers/scsi/qla4xxx/ql4_mbx.c
>+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
>@@ -1404,10 +1404,8 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha,
>char *username, char *password,
>       dma_addr_t chap_dma;
>
>       chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
>-      if (chap_table == NULL) {
>-              ret = -ENOMEM;
>-              goto exit_get_chap;
>-      }
>+      if (chap_table == NULL)
>+              return -ENOMEM;
>
>       chap_size = sizeof(struct ql4_chap_table);
>       memset(chap_table, 0, chap_size);

Thanks for a fix.

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

