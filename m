Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7791EE7C4;
	Fri, 31 Jan 2025 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738343866; cv=none; b=SZRVzCQRTKI0XZyhiNsW87jN5Sd08KZrNyySzgCuMGn1zBw0xUt+yjRab1pps5XvzqEJ6GPWSfLYMCLpd5UnMnfr9/wE48Q4f/35lrL+SZlcU6M0N2RU3QP9cCCzkzQy8K0cp4Zwui6nHD5NfhjahA7c5aMCDbG4dtmK/olWckg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738343866; c=relaxed/simple;
	bh=r9CRj9uKB4ij1nf+1B29ONBvdTTVyuZzSsFzAtiGXhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f+XtHo89D184fcb8Ikq65FHLBX31N5JVVG45Nvgmlu0gneAOjLfXFE2StCGYQua8U3f4qk57gC+ohTlzu8DZ3XDK4qZAB+s+jAPcRsH0YsMVBZVm4YUoNX3riG6AiSRum8xaIj+ZS+RMLJzAl1xHp3RIBRPRVa0r6Qi/+JE1aPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from localhost.localdomain (ip5f5aef17.dynamic.kabel-deutschland.de [95.90.239.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 431E761E6479F;
	Fri, 31 Jan 2025 18:16:55 +0100 (CET)
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] scsi: mpt3sas: Reduce log level of `set ignore_delay_remove for handle(0x%04x)` to info
Date: Fri, 31 Jan 2025 18:16:40 +0100
Message-ID: <20250131171640.30721-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On several systems with Dell HBA controller Linux prints the warning below:

    $ dmesg | grep -e "Linux version" -e "DMI: Dell"  -e "ignore_delay_remove"
    [    0.000000] Linux version 6.12.11.mx64.479 (root@lucy.molgen.mpg.de) (gcc (GCC) 12.3.0, GNU ld (GNU Binutils) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jan 24 13:30:47 CET 2025
    [    0.000000] DMI: Dell Inc. PowerEdge R7625/0M7YXP, BIOS 1.10.6 12/06/2024
    [    9.386551] scsi 0:0:4:0: set ignore_delay_remove for handle(0x0012)

A user does not know, what to do about it, and everything seems to work as
expected. Therefore, remove the log level from warning to info.

Device information:

    $ dmesg | grep -e 0:4:0 -e '12)'
    [    8.857606] mpt3sas_cm0: config page(0x00000000db0e4179) - dma(0xfd5f6000): size(512)
    [    9.133856] scsi 0:0:0:0: SATA: handle(0x0017), sas_addr(0x3c0470e0d40cc20c), phy(12), device_name(0x5000039db8d2284b)
    [    9.366341] mpt3sas_cm0: handle(0x12) sas_address(0x3c0570e0d40cc208) port_type(0x0)
    [    9.378867] scsi 0:0:4:0: Enclosure         DP       BP_PSV           7.10 PQ: 0 ANSI: 7
    [    9.386551] scsi 0:0:4:0: set ignore_delay_remove for handle(0x0012)
    [    9.387465] scsi 0:0:4:0: SES: handle(0x0012), sas_addr(0x3c0570e0d40cc208), phy(17), device_name(0x3c0570e0d40cc208)
    [    9.387465] scsi 0:0:4:0: enclosure logical id (0x3c0470e0d4092108), slot(8)
    [    9.387465] scsi 0:0:4:0: enclosure level(0x0001), connector name( C0  )
    [    9.390495] scsi 0:0:4:0: qdepth(1), tagged(0), scsi_level(8), cmd_que(0)
    [    9.401700]  end_device-0:4: add: handle(0x0012), sas_addr(0x3c0570e0d40cc208)
    [    9.471916] ses 0:0:4:0: Attached Enclosure device
    [    9.480088] ses 0:0:4:0: Attached scsi generic sg4 type 13
    $ lspci -nn -k -s 41:
    41:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI Fusion-MPT 12GSAS/PCIe Secure SAS38xx [1000:00e6]
    	DeviceName: SL3 NonRAID
    	Subsystem: Dell HBA355i Front [1028:200c]
    	Kernel driver in use: mpt3sas

Fixes: 30158dc9bbc9 ("mpt3sas: Never block the Enclosure device")
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
If a more knowledgable person can also improve the log message to be more
useful for the user, that’d be much appreciated.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a456e5ec74d8..9c2d3178f384 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2703,7 +2703,7 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 		ssp_target = 1;
 		if (sas_device->device_info &
 				MPI2_SAS_DEVICE_INFO_SEP) {
-			sdev_printk(KERN_WARNING, sdev,
+			sdev_printk(KERN_INFO, sdev,
 			"set ignore_delay_remove for handle(0x%04x)\n",
 			sas_device_priv_data->sas_target->handle);
 			sas_device_priv_data->ignore_delay_remove = 1;
-- 
2.47.2

