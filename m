From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Fri, 17 Mar 2017 19:29:46 -0400
Message-ID: <yq160j7lbx1.fsf@oracle.com>
References: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
        <yq1r31yf5ie.fsf@oracle.com>
        <3f08ece0-531e-6853-d47d-a860e81e55d6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48053 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdCQXbq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2017 19:31:46 -0400
In-Reply-To: <3f08ece0-531e-6853-d47d-a860e81e55d6@huawei.com> (Kefeng Wang's
        message of "Thu, 16 Mar 2017 13:21:01 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>

Kefeng Wang <wangkefeng.wang@huawei.com> writes:

Kefeng,

> root@localhost ~]# sg_modes -p 0x2a /dev/sr0
>     QEMU      QEMU DVD-ROM      0.15   peripheral_type: cd/dvd [0x5]
> Mode parameter header from MODE SENSE(10):
> Invalid block descriptor length=512, ignore
>   Mode data length=36, medium type=0x70, specific param=0x00, longlba=0
>   Block descriptor length=0
>>> MM capabilities and mechanical status (obsolete), page_control: current
>  00     2a 12 00 00 71 60 29 00  02 c2 00 02 02 00 02 c2
>  10     00 00 00 00
> Unexpectedly received extra mode page responses, ignore

That looks pretty broken.

Could you try the following patch?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f41e6b84a1bd..51a4ce094450 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2485,6 +2485,10 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		goto retry;
 	}
 
+	if (data->length > len ||
+	    data->header_length + data->block_descriptor_length > data->length)
+		return 0;
+
 	return result;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
