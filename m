Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF9FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiBXXbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiBXXbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:31:35 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF2F2763C1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645745465; x=1677281465;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fy482iV7TvYo4Oi9JfCYtzCX6QbrjUioqGVwAf3nVMc=;
  b=P6ZDBse9gxUYj78NG8pli55+nPBfWHEm19GvKbAbkWModFQLjPuaCsRe
   Tt2Xm+HsFAz/gSY1xlKYDTWvdaYyp9opk/HE+O5MHwC9YbbKpVn/ms4pH
   sdryREA96WJ7lLjkulcei9Q6i9lIwaBcOWEh3J23JSZ/f4cXvvF9/okqu
   9zBvsjN41F4yioaNGCT9Dd1fiekpQVHerMESk7f6ydRYEsd2ZAQ/xuamm
   J/qiJkmhvMeHYCTdn2HGtWfNj0esLmG13Udrpxr0+PCwv8+XF2sVRagAw
   nknh7epBxzMM2K1nWnfMew2CjBtJpnQjYxdiTxi0an9CU3NaFI5DScOtM
   w==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="192821982"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:31:04 +0800
IronPort-SDR: lWlVbOoJ7gp6n1Wa17OE0eQb8DHKdkADh8/Sg1T+LobVIquAN/6A44v08n1mJMmcKkC7BO2JNc
 tRfU7+LwfpeeN0KBg6sEfEV4mVJorhF0Q1aTbszjzDrAJsG2TFb/XTl2Mnbdb3oHGGtl9wyyx3
 BV8f8abJE69h/cQlAJiPKXrCy37kqu6xIzdd2yjibe5OqxjwcnD9WJ8MNuS3j7DpIcVGojxXI4
 8mLA//8CAbWr3/fBlLCxJCzhgxiCIAsdPW/ULNnu7w0FPvn7qDeWxoJwIpoaLzSr/Xl6dLMgeI
 U+Rxpnf8qisRQxl02hJloliY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:02:34 -0800
IronPort-SDR: 9FDdxW8UBqikvL+ja/aDj1UELfFLJvDY9NfUq6ueIhdgiE18V9yAa0RWU8PN+abXY8ThUCNk9b
 VndqLxrBJYrMfH9gV8WJIyNnTkkW109yYBNvlm7HP3rU7OVn9nx39WHkBAI/87fNSvDmCtYkiU
 UX+L6yiOAwZy02ujGBZT+JFZneTqM7U6wk8CdsEVOPXUd6cxcw95m6SFW7QS1GTNYVmK3FgBdI
 JIjOkxwltVZ5l0oH6kEn6JSPlRU+TKYGc1F0Wi80MW3LGvRBzPZQ4A7YFeQvDOYlls5izuTyYm
 Yos=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:31:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4TgD293jz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645745463; x=1648337464; bh=fy482iV7TvYo4Oi9Jf
        CYtzCX6QbrjUioqGVwAf3nVMc=; b=uVSnCoM5l/T/wxgAsNCkw3SUR4qgOa9Kvk
        PGd804WTZpaEhoZh7QdZsO0lpg5ANGRnVDqB+j5zcuMFQMsp/bYEq3jhlVGyxdxH
        drJtetiC2CHZT2BubdSv+spTYvw5EvtE69jhs0QpNKUgfNeeuZxk71+c7R/h6XSJ
        NvAZA11Ck6zbQ8cbHwIc4mSr///yV6jvogBU78gbLJKFKrqswpncR6z4NtUZXK9f
        onH2iQqPzp4Eu+r2u90J0mGANQ0B7iPDpJn1jZcnGlKYTmZ6VT6Jzgd9e0KXVxyL
        8XWZGuweRvMOMipEfy828qOwCMHfRanwYjFfnP1kwLeESE/6etFA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IK25Hqebsh85 for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:31:03 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4TgB6MVYz1Rvlx;
        Thu, 24 Feb 2022 15:31:02 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 4/5] scsi: mpt3sas: fix event callback log_code value handling
Date:   Fri, 25 Feb 2022 08:30:55 +0900
Message-Id: <20220224233056.398054-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
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

