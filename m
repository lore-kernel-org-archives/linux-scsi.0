Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF67AC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 10:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiBXKMZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 05:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiBXKMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 05:12:10 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EFE33A29
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645697499; x=1677233499;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fy482iV7TvYo4Oi9JfCYtzCX6QbrjUioqGVwAf3nVMc=;
  b=eMGqINQchYtORAAcQ/Eik59+11H7zld4xcEDfqdxwl+YAtmHsINycq+y
   FMtpbyeocJLln8M1QIHcv/NQWGNa7PRuhtRqJaZaA4SnzBwSl2/WsU1G8
   bu815WzLBzFMXL/s9ZwYbCdc8TGCSgsHDm1sIo1jEzRId1clAxd/LcRx4
   Ys7QbzfdHjnHwsZYuAEi884FvJry+3OkKUMQ/w1tzTJ54pka5bZRcX88K
   mMCRh/34Z+pU6+Pfwk76TWs3mmWP6/htdqPl7KywAhFHtb+KJ5pvGD4NV
   QVPsXZjCFoOP/1X6257r20wbchryzsB70Vijil6jQISyYzKfViiLd7e4G
   w==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297965121"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 18:11:39 +0800
IronPort-SDR: 7DF9abao0wW4ESOKJrxZL5DK+GPkzKehN/Fuxd581sxPdXL+MYpcq5Kso5RMPpyBV3v5e/v11O
 cojjp/hD0p0PyRouahdrxd2+7VAtudNb7QYpGa9HGXl43gS57JamE4E0lsY6T5qatbbqeOldjP
 k9Abu1FUth8PYhrH+1KbSCEtkkSLBxhGgaj68nuz+KN2pC8a9L+h8uAt7iYolhdbOZq9111zqy
 f6m9QkLcencwD0cV+Gsn8n9tFQhjyTo8r+3RWAOxQvONgReWKa7NYzm6Q2U6HgJk9qtJowfg7b
 2wW6N78iKzw1TCIrmOXX1xiO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 01:43:10 -0800
IronPort-SDR: K27F23flgpvLp9UpxBwsHmDMQJbveFoSSMWCz2t4/9pbmxIaky/XDdqXNzeVrzYX7xTMStvxqS
 xv7LETa70k8S1Aiu9OnpplZ48bF3AWeRTHLkS/Jbhoz6hO+ZSMF1uf/9IwsASG8bLgFhRyCwiG
 zuCSkBaLxNr3h4QYNtUnKFg9iynoXdfdmBg3MlabkwMBzit8+RufAL+pMuCc3DzrTkLQ5Jdi3b
 CxNTzFsqpCpHIbsWVFEUD86Vdkpnbaku3KbWX1aD05bmzsi4N70K3c5+ir158PcjSjotoRX/LE
 U5k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 02:11:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K47wq2mYXz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645697498; x=1648289499; bh=fy482iV7TvYo4Oi9Jf
        CYtzCX6QbrjUioqGVwAf3nVMc=; b=fWdeRlXwEz6tKu1K1307Hn3IYCTUtDImqj
        nay3htdjqZkhFM/nJzGjLpuu6D836FzvTBS0us6w3CuAX+6emlL7HdAVUGwhmrdM
        QOSl7Z41t6Q+tD9fi6Y464wtf6yQTOW0A4/V1a9zug8M2QO6rTxA/nAstNjSx5Cy
        CrVZp5a2Mq3fCHLx7B/FzR4Tw3Dl0PVUPwLY7PLgFqmfDrZ15pkFAYzbgjKi1vUj
        s6knKCVl2jWf90IEwX/jEP4CP8/A0+mQ1QRKOSlvoxdOi4YlTWEtum71WYSNzoGX
        gD2JJkEDK5SAqL16eny4VfoE4bdJjLz+wtR+OVAHJm3hiwaH1ImA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XKYfdgPIGIog for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 02:11:38 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K47wn6VG5z1Rvlx;
        Thu, 24 Feb 2022 02:11:37 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 4/5] scsi: mpt3sas: fix event callback log_code value handling
Date:   Thu, 24 Feb 2022 19:11:28 +0900
Message-Id: <20220224101129.371905-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mpt3sas_scsih_event_callback(), fix a sparse warning when testing the
event log code value by replacing the use of a pointer to the address
storing the event log code with a log code local variable . Doing so,
le32_to_cpu() is used when the log code value is assigned, avoiding a
sparse warning.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 00792767c620..a355bc145577 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10926,20 +10926,20 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADA=
PTER *ioc, u8 msix_index,
 	case MPI2_EVENT_LOG_ENTRY_ADDED:
 	{
 		Mpi2EventDataLogEntryAdded_t *log_entry;
-		u32 *log_code;
+		u32 log_code;
=20
 		if (!ioc->is_warpdrive)
 			break;
=20
 		log_entry =3D (Mpi2EventDataLogEntryAdded_t *)
 		    mpi_reply->EventData;
-		log_code =3D (u32 *)log_entry->LogData;
+		log_code =3D le32_to_cpu(*(__le32 *)log_entry->LogData);
=20
 		if (le16_to_cpu(log_entry->LogEntryQualifier)
 		    !=3D MPT2_WARPDRIVE_LOGENTRY)
 			break;
=20
-		switch (le32_to_cpu(*log_code)) {
+		switch (log_code) {
 		case MPT2_WARPDRIVE_LC_SSDT:
 			ioc_warn(ioc, "WarpDrive Warning: IO Throttling has occurred in the W=
arpDrive subsystem. Check WarpDrive documentation for additional details.=
\n");
 			break;
--=20
2.35.1

