Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10266C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344039AbiCGXuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344069AbiCGXuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:50:02 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED4722B38
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646696943; x=1678232943;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=OFmN811CwEBOyhUbY0uvSQICwH7isycEQM+uR5+NIlc=;
  b=m6R1BHfxnBMTcz0uwUy6mjYCDoQMzsQgXaexqY1+qyPODQYZzKBHsona
   mgtXS+ekQRTYJRqRA7Xm0wahwwYIVLO1KY9HpRdmImJarJDgjJgw8QdCi
   xmriY4uLOzZ8NBDBlZy2y16A1zGBJDyKeouHB05FgB9sAFChsXtqeupoV
   +lKv157DBctxw/HYNhEog5wpH/5wMBnoiXCk96WJbeWxgv/GFFFU+FFpr
   t6TyNYdZitkmX87dPJfPSJxesSDt+TmcoN7pb9fVy06X+fLmn7IjBWQqV
   VLbdBo45bQIBg79EypewUO/EM4RFWdKOrvQYiy0YYkFkYSINE5hvKOVzE
   w==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="195659152"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:49:01 +0800
IronPort-SDR: NWECyG3Nn1T+HMa5SS+1eHO27dv5DIzEM8xupbgKgIaijw9JbKfLZlv0N4NLfDFsKOpMSXAv29
 24Ks9CR58aEeCeB6ggZSpx8tpJ0KYTKJQHYd3OQ0crUxYsJkDZpnxuay/+X6VE3T9avudvMF4o
 LQ+WiORbBgu3Cmb7wxEUm20Np7Ss2OE7fFOKkb2e8ZsttBfoKholCF7HKUWKKhjzwuJdCHZr0+
 mSryCvUJIuYZloBapuliCa7tkbr5QgOI/DxGLfVUZEsT5pa1cIn5zkFavqUqDXxjIPsn/tPwEk
 qIjEiXoJ8NE7m0T/6F0aJWAt
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:19 -0800
IronPort-SDR: /U82Fxo06NeXyoU397EjndFH6rVVOi/OWreWW/+6+cUWgypo9exJ4vRMXakz+2nZgInRNzdk2p
 dpttYCucBJW/z0STVx6p1fpOhQC1ADUULEYVm3JxI07OR35P+HSJIof3+4nHd1GdlExCtQcyXM
 C9IXSPvDeFl13mln5mLIRJAO+VgoCS5jq2EpGBvhHkLt1djtxd7Fnmu4yYe2iXpgIZkbgQJQjY
 rfADLH9msVviH6J96f7woajPJ2/Su7yMRMVLZjdmmiNFbco0b9bMf5cQZSuPQWoKPA9t3mBIh8
 IxI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:49:02 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFXr6lNSz1SVny
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646696940; x=1649288941; bh=OFmN811CwEBOyhUbY0
        uvSQICwH7isycEQM+uR5+NIlc=; b=FKsbPsoohNBzqFHFLG6Pd8jyKy8TmRChTV
        Oh7bmu5HE0lAR1vejQtcc/XCZ/wsgdh0/EbNQ4f7lEr/IqP40+FDMMsvpRSyJjmU
        Xm3pknysVo4ntaCg3OCnFr9NLVe4zc0KdN5d9fNoaDleNB1cjgrWt1Mqb2nNbmUx
        ObcHszN+kw1xCA9t4X4g9rfaieiKn4UI7+9JU3ZhKLZY1EPBjGIHV2hACCthVEvF
        YTVeulKYoFPCKL7DzbbeY5E43Os3XQORi6LqYJJ+FTEO6BXwMDQqPPb+nOUcEe6A
        uJTflUDYpO0KFtkm9QLIbT6u7QgxwGwygRP9NUdjSAYgpVMVlPJQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F8hdbNFL0SLD for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:49:00 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFXq3fNsz1Rvlx;
        Mon,  7 Mar 2022 15:48:59 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 2/5] scsi: mpt3sas: Fix writel() use
Date:   Tue,  8 Mar 2022 08:48:51 +0900
Message-Id: <20220307234854.148145-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
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

