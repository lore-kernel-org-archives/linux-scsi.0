Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730CCC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344025AbiCGXuK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344041AbiCGXuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:50:02 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0211E22BF8
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646696943; x=1678232943;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=unaPc+bJDjDEi5zJ5BafAvJLsHIWC/zgKf9goBf7tAQ=;
  b=GHzfidKTHLg3C4Ct2lttJ5lIQ0ADs14HQWfs4yAHcVpDR8WKIiy+airf
   SfutWxJsN1XkbfpGdpq7Dn6ZHCaUIzOl7kfmkg131kfv1kdHHcgtYDTOc
   VTNygXxzbUWNU8egp9N1kIofciZ4buhVCLwMNHB85EiBCKj7bJfoxhKQc
   OI3SVApuQBIeg+rfo0P2i7eH/ObydlYX0oKvbX6Ys144ymfOeLh0LfMos
   wE8wN/Bt7owUJZA8C+S0aimR5C0MU8OKB6UTD2l0+X0HawARfuIHRFRYJ
   wX7pSQsCZFSV/EAAhAU4O+kUzZhznYxArIohmYq3kkdt5gyVMC9uu0wSY
   w==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="195659154"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:49:03 +0800
IronPort-SDR: 436NhMwR32QKC5zmQwWADTolJgrcQ/1irYcXlinD69xHS8SQYf7fprmx4sxfRGm2khPlPZ0Hu5
 OFHWbcO9q/qF5xwPEEbCHyEgbEr+y9KuH3s+cRKFKA0lafQ36ZIkJEB6t7LN/EqwNY05aTSasy
 PSJOeXSvhFMXfn+lT4REhdiPk+U7d05U1YELS2F4JDbkLfur/52X9+Zumk5f5WkmhCdLtM52dn
 Nvgp1l9F5y0JCfyCV7DtrbAa9I0DE5OPLZAjpg/r9Csso/5WwG6QoY9GWfetZq5M0ZrCjGNT1R
 vWBARh2eT1mL5gdNnns9qD6k
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:20 -0800
IronPort-SDR: VvowOAHTATsVmMGeLqOC/q3IbIibIRGqgSy3mc6Rqzb725emr6oCi4c2r8l99xvqJEwrQzT+94
 wQjwxYfacuj1ALLpefMVGU+3kRAoQOyeQLHdG4a4dDoVzyfvCw6IUsLLFHZ/kMKeEr7ptDzGhG
 tt+zlMhxzFPbxb+wzX9jWCJQlcAXG4QBYJkPKT70QZHXZ+i0HzWEUi6WSJ5fCwvjUYZ8hctU+w
 ZWY/0NLmOz7ssR6WsqnnfB2fTsNJ2RBgxEdxy3I3Xrji7Va17BVjygIbLHDeF/I/X9vuns7BOz
 ZG8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:49:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFXt1pq7z1SVnx
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:02 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646696941; x=1649288942; bh=unaPc+bJDjDEi5zJ5B
        afAvJLsHIWC/zgKf9goBf7tAQ=; b=LRXBfdvEbBSn6OSCfA3YwMHnC0wwRZbZ8j
        Trfha2zXEeD+Av7MPKTHJnLCHKtkEpjlUwY82TXEMVs2w/2RT7V+HTeOyQNIM/Jt
        SOb++TLRNooHt28VueqYpbCZI+uj1UYydHs/hlRTqYQRKNeVLTYs148cPNx4K2Ll
        hseMOu7/udCoSoA30kjoxOiNqJyOeZOoWKer46ZY5LGuXAi2sx3nibsc2Lsd4j70
        +JHaR+NsCVmnbbDbzKuhlLbvYmT2oWHQ/HCSiyQ8IHGGC8vojED6zSh6btZM8+Hq
        XfaYudBwiwDJM1JL8i+FukBunbPPV0r+mCT/fFhyXkiCi1b/bbLg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id C_4KcSShQxCy for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:49:01 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFXr5fc3z1Rwrw;
        Mon,  7 Mar 2022 15:49:00 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 3/5] scsi: mpt3sas: fix ioc->base_readl() use
Date:   Tue,  8 Mar 2022 08:48:52 +0900
Message-Id: <20220307234854.148145-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
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

