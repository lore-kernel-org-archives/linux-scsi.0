From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] [RESEND] megaraid: use ktime_get_real for firmware time
Date: Thu, 18 Jan 2018 20:08:08 +0530
Message-ID: <caab2d1d01798c79e62dd034ca3eafd5@mail.gmail.com>
References: <20180117144859.2382521-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117144859.2382521-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Wednesday, January 17, 2018 8:19 PM
To: Kashyap Desai; Sumit Saxena; Shivasharan S; James E.J. Bottomley;
Martin K. Petersen
Cc: Arnd Bergmann; Tomas Henzl; Hannes Reinecke;
megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] megaraid: use ktime_get_real for firmware time

do_gettimeofday() overflows in 2038 on 32-bit architectures and is
deprecated, so convert this driver to call ktime_get_real() directly. This
also simplifies the calculation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Sent originally in Nov 2017, no comments. Please apply
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0a85f3c48ef6..97fae28c8374 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -983,7 +983,7 @@ megasas_ioc_init_fusion(struct megasas_instance
*instance)
 	MFI_CAPABILITIES *drv_ops;
 	u32 scratch_pad_2;
 	unsigned long flags;
-	struct timeval tv;
+	ktime_t time;
 	bool cur_fw_64bit_dma_capable;

 	fusion = instance->ctrl_context;
@@ -1042,10 +1042,9 @@ megasas_ioc_init_fusion(struct megasas_instance
*instance)
 	IOCInitMessage->HostMSIxVectors = instance->msix_vectors;
 	IOCInitMessage->HostPageSize = MR_DEFAULT_NVME_PAGE_SHIFT;

-	do_gettimeofday(&tv);
+	time = ktime_get_real();
 	/* Convert to milliseconds as per FW requirement */
-	IOCInitMessage->TimeStamp = cpu_to_le64((tv.tv_sec * 1000) +
-						(tv.tv_usec / 1000));
+	IOCInitMessage->TimeStamp = cpu_to_le64(ktime_to_ms(time));

 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	memset(init_frame, 0, IOC_INIT_FRAME_SIZE);
Looks good to me.

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

--
2.9.0
