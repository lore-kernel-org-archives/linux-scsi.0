From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH] scsi: Check if the device support WRITE_SAME_10
Date: Wed, 05 Jun 2013 14:53:52 +0200
Message-ID: <51AF34E0.3030609@itwm.fraunhofer.de>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com> <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com> <51AF0CCF.8000909@itwm.fraunhofer.de> <51AF232C.8060209@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:48874 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3FEMyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 08:54:03 -0400
In-Reply-To: <51AF232C.8060209@itwm.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Here's a rather simply patch for scsi-midlayer

checkpatch.pl complains about style issue, but 
I just did it as the other lines there.

> schubert@squeeze@fsdevel3 linux-stable>scripts/checkpatch.pl patches-linux-3.9.y/ws10 
> ERROR: spaces prohibited around that ':' (ctx:WxW)
> #48: FILE: drivers/scsi/sd.h:87:
> +       unsigned        ws10 : 1;
>                              ^

If someone wants me, I can send another patch to fix the other
lines first.



scsi: Check if the device support WRITE_SAME_10

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

The md layer currently cannot handle failed WRITE_SAME commands
and the initial easiest fix is to check if the device supports
WRITE_SAME at all. It already tested for WRITE_SAME_16 and
this commit adds a test for WRITE_SAME_10.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 drivers/scsi/sd.c |    6 +++++-
 drivers/scsi/sd.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 82910cc..368f0a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -742,7 +742,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int blocks = 0;
 
-	if (sdkp->device->no_write_same) {
+	if (sdkp->device->no_write_same || !(sdkp->ws10 || sdkp->ws16)) {
 		sdkp->max_ws_blocks = 0;
 		goto out;
 	}
@@ -2648,6 +2648,10 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	if (scsi_report_opcode(sdkp->device, buffer, SD_BUF_SIZE,
+			       WRITE_SAME))
+		sdkp->ws10 = 1;
+
+	if (scsi_report_opcode(sdkp->device, buffer, SD_BUF_SIZE,
 			       WRITE_SAME_16))
 		sdkp->ws16 = 1;
 }
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2386aeb..7a049de 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -84,6 +84,7 @@ struct scsi_disk {
 	unsigned	lbpws : 1;
 	unsigned	lbpws10 : 1;
 	unsigned	lbpvpd : 1;
+	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
