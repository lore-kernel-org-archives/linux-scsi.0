Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C678CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 10:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiBXKMJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 05:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiBXKMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 05:12:07 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65561AF1F
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645697497; x=1677233497;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=OFmN811CwEBOyhUbY0uvSQICwH7isycEQM+uR5+NIlc=;
  b=Ybma6puu6QZZQLaAw17e7ahdc58CK9Vc5EY5alyXh0c9hYe9ZN4mNS4s
   ZylgbltIqSIKa2TiJ5S8PzVyH/XCGqmjam0ORXF1Msj3pVEZz2UU2BPky
   2AWkJ7unSVQv470/mtlMV7KNtIwfkVOinzA5c2EG3EEo+PMzRV3xGOiHL
   tpIywaPimVRkuQupEDbv/nLW05CHyolMENdtIM9hBCENXIFHeE3isnBaS
   tXdfrfKDGzYwS8Gvm3IsJ7/Jpf+VWEV/O2Q6BrlH1jEzhesCH0vdoE1CS
   KoGnV9zrOvABfI0qtmsvaoegJ4SI830hPMsQad0VRD1f+Qqrbpkky0jgh
   w==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297965115"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 18:11:37 +0800
IronPort-SDR: wGEj/qBKUbBnxef/nSWhbgXl8L50fxlmp7IaMM9bBtMx78vWMF/d1ZQfDccDLAQumwpQirju/f
 n7ruNuBAQi3q5P9cWApLeiLi+a+cUpcNYlNExlwsG792nohC7BEQQ5DoMN2QhbVgu1rxL6bhxH
 SDP5uQwS2EjjmMTTCEsgepFGih7zKW/y9Y1wJdKNruTEsN5IBDekRoffJxmcdI2GXvW2+1yZJw
 4vRRsLbQ5ENm1mEvtPrjxXzSnfcbh7rEz4iTw1cIF2hAWFPWG2v7OAIUZ7hH94Ly8yrsHF59JY
 M8fB6hbwBst6/0LQfEPD9mdI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 01:43:07 -0800
IronPort-SDR: LR7UA6+qvZJz7AR3+g3aEBip9wtOfkuisBLCYIb+TC8cNJnV9hythiNyrnQnCJpBjKs1LYW+KH
 hgJvvslLk7QWJnysS73hZPBVUAyM3Bj9tPesisKNXJPqnvipg8ZbhACHQVgJKY9yNBs2BOYMKL
 XZv87oFSyYww/QGZn1NhxxBhkFg4mkD6eVUZQqN0oZlNqgZRXIYoYec3qHjoF8TbtL3VnoeiwF
 aTbYJR03GytS3TJr2TzHkrwJNcfRSghznPHHR/2RVA4XGhfHqPUDznHG8nPhms5Mj49loThlyO
 EVU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 02:11:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K47wm6KwRz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645697496; x=1648289497; bh=OFmN811CwEBOyhUbY0
        uvSQICwH7isycEQM+uR5+NIlc=; b=Tl1gV3v+A/l9p83QPf+BFwN2q0OjnHmrVC
        ydejjTGWNt9Th4oKiL3HP0fDdOCqApxrpIDsOAPjFY31SGtsayyuqEnFkISNr6Ap
        wdYifVYTRL+/cu2GUUdNcb3uMo98rxS6kH09KqEcjfEucxhA9RTOAcJcXw+8K+X4
        utYcnc5Qkf0GkLUyqP3Py+rL1MzWiglt8WnGwmTO2L0pWQlS/XHOAcibVdiNbsyL
        Si5GS1ysr4kcTafhTXGBZAGbvRMgcIm4KO5nHE+6K4XXvk128bXYVjqgduIlrs6x
        scsl43AwcfpyIpc74CIThP8R06RScgN61CQ787o+bPkXHEPi7poA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h_K8PrwJXyaq for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 02:11:36 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K47wl2HD4z1Rvlx;
        Thu, 24 Feb 2022 02:11:35 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 2/5] scsi: mpt3sas: Fix writel() use
Date:   Thu, 24 Feb 2022 19:11:26 +0900
Message-Id: <20220224101129.371905-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

writel() internally execute cpu_to_le32() to convert the vale being
wrritten to little endian. The caller should thus not use this
conversion function for the value passed to writel(). Remove the
cpu_to_le32() calls in _base_put_smid_scsi_io_atomic(),
_base_put_smid_fast_path_atomic(), _base_put_smid_hi_priority_atomic()
_base_put_smid_default_atomic() amd _base_handshake_req_reply_wait().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 511726f92d9a..6ebdfedd84f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4323,7 +4323,7 @@ _base_put_smid_scsi_io_atomic(struct MPT3SAS_ADAPTE=
R *ioc, u16 smid,
 	descriptor.MSIxIndex =3D _base_set_and_get_msix_index(ioc, smid);
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -4345,7 +4345,7 @@ _base_put_smid_fast_path_atomic(struct MPT3SAS_ADAP=
TER *ioc, u16 smid,
 	descriptor.MSIxIndex =3D _base_set_and_get_msix_index(ioc, smid);
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -4368,7 +4368,7 @@ _base_put_smid_hi_priority_atomic(struct MPT3SAS_AD=
APTER *ioc, u16 smid,
 	descriptor.MSIxIndex =3D msix_task;
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -4389,7 +4389,7 @@ _base_put_smid_default_atomic(struct MPT3SAS_ADAPTE=
R *ioc, u16 smid)
 	descriptor.MSIxIndex =3D _base_set_and_get_msix_index(ioc, smid);
 	descriptor.SMID =3D cpu_to_le16(smid);
=20
-	writel(cpu_to_le32(*request), &ioc->chip->AtomicRequestDescriptorPost);
+	writel(*request, &ioc->chip->AtomicRequestDescriptorPost);
 }
=20
 /**
@@ -6906,7 +6906,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPT=
ER *ioc, int request_bytes,
=20
 	/* send message 32-bits at a time */
 	for (i =3D 0, failed =3D 0; i < request_bytes/4 && !failed; i++) {
-		writel(cpu_to_le32(request[i]), &ioc->chip->Doorbell);
+		writel(request[i], &ioc->chip->Doorbell);
 		if ((_base_wait_for_doorbell_ack(ioc, 5)))
 			failed =3D 1;
 	}
--=20
2.35.1

