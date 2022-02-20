Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C06FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbiBTDSp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiBTDSj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:39 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E2B340D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327098; x=1676863098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qwEC/HAHMVugj2YgjUkTAgDhC0DdmBvV/+2YVPjh/G0=;
  b=R8HLHpToLq0Jqugn2CmmpoBf/tXC2wOonsvRNuQz31Adidrn/2PIvqiw
   kakzQrHz63Sxe7z8xTvocm8Ab920ad0MUMl3egbVT5b4rIuGk6TFhv4G2
   4CmuYpZveblg81+sa08L7BwoJq7okxwnQCCbbSqLtPxuxVnvH62MHpRm3
   peNNubcqSmZq3QVttTtpLbu1ywbHXSQX216I8F/XdrxAlxZ5yk/DPRtdC
   mb0/MCvWKqiUI5ZVD3Ghd6nzbPH7diphtn7ak8wx7pqKErvGELyvpF7t9
   k/Ixki6xFTCyC+L40WQ9gwheKf1toJVKZQ4wI28qfwNF0uG5dRdkopcGc
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405731"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:18 +0800
IronPort-SDR: eiiCcTgx9/QX4gNobxRggcyslURUh7zrCdSpirpNRqN9+5aSIqnrORgGZ3lIXxJDLJG+Mx6bfW
 e/iYlS1OV96Z4HxgM/voyRHw/oHJZqlICjUfxKiiRNNQzL5Rpqsf0YbefA6AGEgr+qVjhekHt8
 hWrpneodUX14MF1KvPB+IIRz0Q9BnJWOcvwMWnkqkCZ8vQTiButTeFs9TtMwMmBe1TH5ZU0/ql
 puNZ8Soap6CTuKMU4hJ9UASWXe1BI3a9bAPSvMfciiPxqt+5DwyVEanhqjLSgXy/lU5DTIwvfQ
 OLInnDsLzo6ayzqoVW1NmLfF
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:55 -0800
IronPort-SDR: Fr2NkmUPpUvF5QIrRgw6STsFB2bQy2U6WGUBT5JS0AkK5iFTnvrkC3LISv/VIUhR23snGa022x
 sV5QWKIfQOWcVAjw5qriHj+z1a2ns3hxhKUiRV7Hs38s9JVSZOWgPvXdHGDDO34NKCeGtBGCgo
 RlOe6F8gRAi/XHby54ZIHpDdnA27pSGecB1MBKJ1T5vxv5dB66wdGtnx05nRP5k8ObhGo31caS
 HxoryALT4OR7XBSl9TJvyjpZY4JUbVcV6mVeIgqm70WO2XS1FRlRqQqN6KMUi6wE5RLv19tbNr
 X48=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxl11SBz1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:19 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327098; x=1647919099; bh=qwEC/HAHMVugj2YgjU
        kTAgDhC0DdmBvV/+2YVPjh/G0=; b=qlMVZxqfRim40AbedjGHMjmbm6lQKhk8Of
        fVnFb+tgswEx66VbQabVb9Mpxw2cj6p0ogKr4bmsfujyenMYJYQxE+oDaoFkVXJI
        2UHrVtzJKeRKJjdmjS8bvwcSvh/pnSTTC0d9yCmZx6NucljdzEUgIBasQ/m1OVXN
        rqvAJ0DyE2srpXERoFwYN9//5h/WU8CO2bw7F42q9N9AacIIlWs0hPhItehpret4
        vCDhICsSKCzV5wbYwhi1SC+XkcrbXfTMRbHHEDIOeLHJvg1RTx3oK85A93l45bpy
        vJQCwOAMArqVEF1eU/xAkare4SUd9maIHAPO/8pwLKXOIes766YQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CrrSn7ENbT6f for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:18 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxj4LvKz1Rwrw;
        Sat, 19 Feb 2022 19:18:17 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 03/31] scsi: pm8001: Fix pm8001_update_flash() local variable type
Date:   Sun, 20 Feb 2022 12:17:42 +0900
Message-Id: <20220220031810.738362-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the type of partitionSizeTmp from u32 to __be32 to suppress the
sparse warning:

warning: cast to restricted __be32

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
index 66307783c73c..73f036bed128 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -721,7 +721,8 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
 	struct fw_control_info	*fwControl;
-	u32		partitionSize, partitionSizeTmp;
+	__be32		partitionSizeTmp;
+	u32		partitionSize;
 	u32		loopNumber, loopcount;
 	struct pm8001_fw_image_header *image_hdr;
 	u32		sizeRead =3D 0;
@@ -742,7 +743,7 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	image_hdr =3D (struct pm8001_fw_image_header *)pm8001_ha->fw_image->dat=
a;
 	while (sizeRead < pm8001_ha->fw_image->size) {
 		partitionSizeTmp =3D
-			*(u32 *)((u8 *)&image_hdr->image_length + sizeRead);
+			*(__be32 *)((u8 *)&image_hdr->image_length + sizeRead);
 		partitionSize =3D be32_to_cpu(partitionSizeTmp);
 		loopcount =3D DIV_ROUND_UP(partitionSize + HEADER_LEN,
 					IOCTL_BUF_SIZE);
--=20
2.34.1

