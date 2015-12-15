From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on ppc64 host
Date: Tue, 15 Dec 2015 13:29:59 -0500
Message-ID: <yq1egenwons.fsf@sermon.lab.mkp.net>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
	<CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
	<20151215130631.GD19209@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45572 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbbLOSaE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 13:30:04 -0500
In-Reply-To: <20151215130631.GD19209@eguan.usersys.redhat.com> (Eryu Guan's
	message of "Tue, 15 Dec 2015 21:06:31 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Eryu" == Eryu Guan <guaneryu@gmail.com> writes:

Eryu,

Does the patch below fix the issue?

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3d22fc3e3c1a..d1eb7aa78b8d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2667,8 +2667,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
+		u64 max_ws = get_unaligned_be64(&buffer[36]);
 
-		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
+		sdkp->max_ws_blocks = (u32)max_ws;
 
 		if (!sdkp->lbpme)
 			goto out;
