Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C577C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240891AbiBQNaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbiBQNaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:18 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712722AE2BE
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104604; x=1676640604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDPQos9blKV8Oo0LcYELhApb03Psw+soVXabs2uNE4Y=;
  b=BuwZ9FNVjU9afuxjWNQIwkIqdymJMlIe43xI8u3RtcvJ662lp6EDCsJL
   fhJ7k+3yTfjompgmBydFfR4V0VigQOavkgBVSL75o2/c6eDZuZS4YeoGy
   u77M7S0t72jbm/sM/poNd7mbhjk4s0FV0XSJl1M4NIo7kN/W6egCDGWot
   oICU5oJpHcixzKWs2ehl0QVA7hLftXfUjHV6z7xZ10+dlwubaqSbgx0xY
   BemiVqf2u1Vchuctlf3gVv0mVhDvQxorWKVSMIWRqNkTb2Pcqi4ufGkhz
   xSUb5fWI34zQgTduVnd7p3AOo6Cy+LKtNAphJtKlNieTpoutVzu4BKwZt
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303134"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:04 +0800
IronPort-SDR: KRlqNIpfDWHhDbAhfuzijtkC6wl4pJ//wGE06Eqfy2ZC7/EwQW4C9V8wlbqmd9k93Ic8qiJxiV
 DQ60NWzqRRK67E7Slzm/MWDps2IUiqUXocbvKpRSlKIbO4taYv9itaI7RZ4grQvR0spBROtTUw
 /ZMIS1OwyAnTGLLOY//NPkQItuhcpi5gpfVJrXIE/uVVH/yrR58krCAm61aHwVUKsSEriOzChO
 OYc94Lm2FAFW1RRVM25Hh9hLnktY6OUh2QsqyzjrFRUvR0ADPl5LhzzT3VxUnylnGgPirjhK4q
 /tDBwuJ/4RI8Y/z87LJOedRk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:43 -0800
IronPort-SDR: P2SbA1bCaDKhDWfuYmdvNYXq+erYkt4U1y6cbsMxeoX4aLjkCVlDaup9UEdfqc34rzR9AUjBUM
 eX5dqCYZkiTdkLAWed8xtYK52Se//JD0QfMmXgr1s6tDftc0QTJun+uV3WVqgZt29VoTVKfR6N
 sQ8R/Rml2qt0lT+QdZtyDZPag40dFh53bWbhNwJ8eFjIgGeviEaoNec8tWweLpEUcnbu89Gjix
 uyVaFf6slqf/jDXKjL2D0M6B5P/gJuNXiht8XSIFimrD/P00d9kz/QrmD7uZbuKzGRqGRU8u+M
 bI0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwfz5z0cz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:03 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104603; x=1647696604; bh=MDPQos9blKV8Oo0LcY
        ELhApb03Psw+soVXabs2uNE4Y=; b=rgrHs4rMupliXBa1TlJbshmn6HBAz4c7jl
        dOPfD+dUm+PtzZ/jOTiqDfWJv27pbMhM/SqXAfhBcGyvqRRgD8XRkwf9sxeMFrE2
        pEOKwbDuzsK3q1jGexCIc4P+9xYKaEbvSiRhcvZHVcwEmjF7AEjWWw4ZOjuMpPC1
        R/liIlRLtdVmWZS6/I/7pW/+s3pNXI+XCXotgH1jkFy3rejDKqMLxsVco6iThMBM
        wx/6t+00i+9Qc9LvOMufUVFjyTOCaSHohxixyjEtWZOLT/uuPEx5FQa9VYdvxkNn
        uwFwIuZpW4bgol5wNBwqNWrg+NQUQ1MfaDnc/zDH2WGdb3NloAPw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l_963ByZinZU for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:03 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwfy1G2Tz1SHwl;
        Thu, 17 Feb 2022 05:30:01 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 03/31] scsi: pm8001: Fix pm8001_update_flash() local variable type
Date:   Thu, 17 Feb 2022 22:29:28 +0900
Message-Id: <20220217132956.484818-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the type of partitionSizeTmp from u32 to __be32 to suppress the
sparse warning:

warning: cast to restricted __be32

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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

