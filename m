Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A72AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 10:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiBXKMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 05:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiBXKMI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 05:12:08 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DC72C125
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645697498; x=1677233498;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=unaPc+bJDjDEi5zJ5BafAvJLsHIWC/zgKf9goBf7tAQ=;
  b=nuLTGHNBkFErfXzNhL1wbXnBAMWJrM2XA5RFbYi1byKmh2lH95IpRCsY
   V/wMmrFGpOypVxBlP/lViEy107R5iX05DZO4vJ2qXcZEYng3/Nk16Ej60
   RoiY2w4S6bnVI9l9ml5zXXFQx/84TTmHFmq/R8cjfaWVqxvoRlLfLctrG
   EkCEADgyCFq4StIrkC/n1Jxb9Gdi7U8tfmJHOifo/kR4I6zs4gA4Qb4wx
   Lgdl1VUVZar5oZ5WmPaQybgR+KI9axI5o4SfHVT5/aEsQ077Y3aSLdwbK
   u15s0wr9CEi7z7w2sOdoGeDNJYgvf0om0ufmdAAh7LVM7nkfhVvCXQYV5
   w==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297965118"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 18:11:38 +0800
IronPort-SDR: JqC8zctUljGBCLVKjtFLGQgbCPUOfN/oex92ZkFyOXotuv0BbdFX58viLQiZE+sPYEWmN1Ei2v
 o1uoyVm6RDm6SiUMo0JwR2Vtp6mpMihl041AsxKahZ3/0EdToUKK4OqeTclp9b1LSu5qEMUOQu
 Uq1JYJQ0WRHMSJ1gciCiabpnG2IdAZjC4lzGqW5RBYrPGH3DVCyCjeAR0qI8LsvzfwL3QwsZ1w
 1/X5PWoEpgP84kN8OZBEWOnO22sQkoBMGp18EXouUOsprhKyefNAIQpfnNWNUoXH7G8aXA9+L2
 KwFnYVa7tQzrdu4IVTTba1KE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 01:43:08 -0800
IronPort-SDR: Q9hOYozxcNegkiOmyp+xlF/DMnTvxT/B9B4lHplgveJhtP+8u0ic+DQum7rJ4Uj7vONfFHIo9Q
 cZ0T921vm3LIYMAQfeYevHBsSfzDSlcC0JvAwBP80ICZonqTFjfELLnVFNV5lEzsrL4jM5rlQf
 EEuzdUBJ36ZLYMovMliK6yfipFQP966sPM30cx39EI0U/HXibGekNpT1qz9EbmHgdfD++eEFXC
 kVSXK1+JWuKUqTjylhi5nonveLrG3Zh6emkVUJC2k9rRJS0vK2ATdINSfnp0+49v2tQ6Gju3gm
 lWg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 02:11:38 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K47wp0Pq8z1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645697497; x=1648289498; bh=unaPc+bJDjDEi5zJ5B
        afAvJLsHIWC/zgKf9goBf7tAQ=; b=hLp4XajfRCd+9vLZeBE1Puf/eYpUC4Dw1M
        ESyVtsg8brbjkvMmmEB9yL0A4pbrV4vEgDy7W/xFLPFVR+Gi1bth8TIXHtJQxiTA
        xqbKg+9wW2d37i69UQ20ZSVesjT8yTqS8O9Rb46Q9tmKD86s3EVtK1R9oi95EvzK
        vHk+63TGOCnIgzNCaCe5PYvHrI0lJhlKlmyIPoTBtX3fIIZjLlPaMMCHGsTjEhqr
        DX8wtu189O+QkT0DobuZXVrOoWv30+ZzMCnldzxAVecwmHbDIftb201PfVWmDrtH
        erY6NrxGe8XRz8JhKEVrvoHKjJpNValgwFMlVzmqwvNGIChGRQCw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cRhPaQwysYXe for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 02:11:37 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K47wm4kDPz1Rwrw;
        Thu, 24 Feb 2022 02:11:36 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 3/5] scsi: mpt3sas: fix ioc->base_readl() use
Date:   Thu, 24 Feb 2022 19:11:27 +0900
Message-Id: <20220224101129.371905-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The functions _base_readl_aero() and _base_readl() used for an adapter
base_readl() method are implemented using a regular readl() call which
performs internally a conversion to CPU endianness (le32_to_cpu()) of
the values read. The users of the ioc base_readl() method should thus
not convert again the values read using le16_to_cpu().
Fixing this removes sparse warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 6ebdfedd84f5..5efe4bd186db 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6925,16 +6925,16 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADA=
PTER *ioc, int request_bytes,
 	}
=20
 	/* read the first two 16-bits, it gives the total length of the reply *=
/
-	reply[0] =3D le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
-	    & MPI2_DOORBELL_DATA_MASK);
+	reply[0] =3D ioc->base_readl(&ioc->chip->Doorbell)
+		& MPI2_DOORBELL_DATA_MASK;
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
 		ioc_err(ioc, "doorbell handshake int failed (line=3D%d)\n",
 			__LINE__);
 		return -EFAULT;
 	}
-	reply[1] =3D le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
-	    & MPI2_DOORBELL_DATA_MASK);
+	reply[1] =3D ioc->base_readl(&ioc->chip->Doorbell)
+		& MPI2_DOORBELL_DATA_MASK;
 	writel(0, &ioc->chip->HostInterruptStatus);
=20
 	for (i =3D 2; i < default_reply->MsgLength * 2; i++)  {
@@ -6946,9 +6946,8 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPT=
ER *ioc, int request_bytes,
 		if (i >=3D  reply_bytes/2) /* overflow case */
 			ioc->base_readl(&ioc->chip->Doorbell);
 		else
-			reply[i] =3D le16_to_cpu(
-			    ioc->base_readl(&ioc->chip->Doorbell)
-			    & MPI2_DOORBELL_DATA_MASK);
+			reply[i] =3D ioc->base_readl(&ioc->chip->Doorbell)
+				& MPI2_DOORBELL_DATA_MASK;
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}
=20
--=20
2.35.1

