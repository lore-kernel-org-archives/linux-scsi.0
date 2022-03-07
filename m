Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E621C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344044AbiCGXuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343986AbiCGXuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:50:04 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B52723BED
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646696944; x=1678232944;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fy482iV7TvYo4Oi9JfCYtzCX6QbrjUioqGVwAf3nVMc=;
  b=SyKj7jXDFX93IcDlkeVQ9Kko/pqzHOq1UKzcr7FLCxq16lhstWmQuLQT
   10L3tEOMjXb0Xr1tOAqVAW8tvP5fnWFey4SCH6QbFwQze9otWUOHyUC+r
   vyqQNwWieoEsSPkGLLG/MdISP2EDCLJlnK5VrwTnYNSt2ej+iWi5fjapZ
   wYIXp1cVI1SBFgEZ0EoOG+zuhCya06XCa4/kzWuyGL9LpwcpfhT9E4k5y
   rptt/JugtgYoG7TCahcab0lonxl2+Z9tAWDLRSix/M7vH6T6kY+VpLzQz
   P06Hx/XlLTRYuyMlyCOjOSu03JgEJUM9rfnSaYK3s6VmZJYanv/EGOdiQ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="195659155"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:49:04 +0800
IronPort-SDR: 6aUDIQ6/dt8lpbDIKClz0Xgdu2XCUYWe6GknCGAKbbbPGwuF+S+2hFEJJZN6aUArnAOjIb3eGW
 JjyrheGlHj7+QoeWNOrc8qld0FIs9s+h5BY8Xh6wAqU808f6f1Bu9Q+1yGXYYlSdIm22HrPTEX
 21kMUraJ1+TT4olKM3eLoFXmuTLQxHSwQ1F9fwb7MCAl4FWgz2JzBRUrCzKZ5FGFwAQemuOKOT
 IPRL028ej75AEqu+DTREYH141LM0JTHjxXuWwrsJjLO0lRrQXzvw9gjqj6eoONEb3nljZXj3Hu
 qTBQRkGdX5XrhLZtBt27ojfo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:21 -0800
IronPort-SDR: XoyLPNzbzdpzsCnRMGZe8LcyqYhQUBU7uA/VmLVyy6vI6rTDbR0QF6qVZrZpNZqzvxuabEgskx
 VEF0Idcbdt5qYI6gQy9lduogeeZhl9z4STVFytd3XE4YyXV1+h8dKzBdviDBhP4UOaoNErKwHr
 WMt+ojoMdcvbN9XpM+rHQiKeA0nO4sRELD5t0Vb6DAV9viWzpD+Xg78DB/De4AttOjSsnV9zf8
 ZNbgvMp67qC3q88ri4pkC2+jgU58PpqzZ2XYepSlQuhPeUeuQ0XzmgwotuSydyjngIYL1dV7XE
 O1w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:49:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFXv388Kz1SVp3
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646696942; x=1649288943; bh=fy482iV7TvYo4Oi9Jf
        CYtzCX6QbrjUioqGVwAf3nVMc=; b=DPtf6gHJBiyjJjIRB9pUvQatB0JrTqZb4C
        IxFnwc8rJRG6OyhlrnFoLZT2XH0VTw2brD1x1RgbuAH/qy5S35NhWDztWwyrEZRL
        B8bnydaxBzR9E+9v0pewMaCOoaua8bhtGznpg216CTg539wbY30xkaJ/nqcoShKU
        G8kH3cqQEGme/4x87HivWU0mkHsZaMWP6vck9jVcSbEnnYhrNTKBnzdo2sBx60a1
        sfb8bgUHrqAzBnOXWR+lARSyZc1MoDjlS350wfzlwNxiJul3couTt2YG0o+4Hl3S
        ake9RxP7zWraY3OnR6vhN4av90qlFy+xMMRvOgsZwyovKMcQOhNg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xXQ8lFPhnBaj for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:49:02 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFXt0Bsnz1Rvlx;
        Mon,  7 Mar 2022 15:49:01 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 4/5] scsi: mpt3sas: fix event callback log_code value handling
Date:   Tue,  8 Mar 2022 08:48:53 +0900
Message-Id: <20220307234854.148145-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
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

