Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD25AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiBXXbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiBXXbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:31:33 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C38186B82
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645745463; x=1677281463;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=OFmN811CwEBOyhUbY0uvSQICwH7isycEQM+uR5+NIlc=;
  b=f1YAX6n+iChaNUXDiGyCHzo3hq5+JJBjKpxSYhEPGODl8kXxf09E0yD6
   i9aBmBo2pf4MIOljg/IbuuWlfJKV7kaGMH9R/H1wFKXlOQAawmnporiBI
   +Ws9DwQmEh8MISuezhGNW/F9K8VyrBsdXkK2wpV5OFL1i+PMpdrYp0FHD
   4AG4rIVBJU8nOEfiUaWtPZRw2ygIUF2Y15ufymcIcctaOrSiU5UR2b4nD
   TDevlI+0qaNZmFQmhulhUkn1jL2xzSCDufiVashfSacVIG7D5SaZPRpzQ
   lEskwjAzQ+umlVXgWusEA6hliYImYpIgODDV89f4Knb7U0WWoesjCkhQD
   w==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="192821972"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:31:02 +0800
IronPort-SDR: Hy91g/kCdNWEJhBapU+aGt24SHNr1+HkAdQpu2kcMmFJeXsLBBI2pjR1M0tr4sGC3wjwT9b9tx
 UcX7wLCMUHgPPduZOEH3Gz10N6vQPZiKVIm5tzSNce2smzXADLZSZks/0g2+ZQavQ/wwm+YWxz
 8r5wmz8tauPCa3Q/+3Q97ejaq9NomGA+YEmOjrD1ch8aKFd5WvBOTMhbluGI3+BZcyWapkbLct
 TIzgFaRKhSE41az+7jf+dKyUheqMLv1wmHqsDJYNGP6FDu/AFz0YgPsgd5tz8SUF/xuNecO9Tc
 5dk8YfLEyBmciLS13kTBeZdd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:02:32 -0800
IronPort-SDR: RhGIJIWvx9QfPAJH9vYDb/FVNBinKwsiFTf8ymU3XhRc10SB0cH9qp/8N7A9UdX9YbfW5rYZML
 ktLsleB+pJamzYcSUsz9+XafFd9oFrNqT+NPCUMn+zFk1/zlNiSZ5oS8rSGXQFgDiXwSUZiCOV
 3zmeML3Za+/GgAmcdUTg5WCoiyolIajC0Tnq+zY84RKjYlaf2AVvLw3xRJiWXc/c9Kpg0fW4HF
 NHcIW6uen0TRRoonVuvhXmdAs9F+PuFI6OiC7stHnaYS4aRS9lWCcGiQty1QD+PaydBAfoIkpW
 iYs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:31:02 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4Tg973d3z1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645745461; x=1648337462; bh=OFmN811CwEBOyhUbY0
        uvSQICwH7isycEQM+uR5+NIlc=; b=nN2Lfxa/QhvkdQ8lXH8TluHHJ0s8m/8zS9
        yMPu1zSgleFzCKx36FjY1ptAUQG1oaErcdoJtFITuzKe09dV2aCcMTd8GHFgQ4dj
        OzJY4cwcBb7owORkyp3mN0FVz6qAMklK6kINZFvBCz2nYMC6UAQeia7I3PvLPRIO
        goPuQj2V4loT7gOpKEg53XftDcizKhJnESqSZ3WfLAKK7xEUGmGV/NGmTrpcopC1
        gMCcoF+m/1KFBiBoRrFV+WTk0Etyo9t1kt2fYiBya+jf2+GlaY7VUPui3jtMOA34
        /9MRAfyYMYypjjD9nBHaZLEnZY2oH9lUyw62Z2ICH8ShkqFrhqNw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YHFJNaNJCS2B for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:31:01 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4Tg8365zz1Rvlx;
        Thu, 24 Feb 2022 15:31:00 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 2/5] scsi: mpt3sas: Fix writel() use
Date:   Fri, 25 Feb 2022 08:30:53 +0900
Message-Id: <20220224233056.398054-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
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

