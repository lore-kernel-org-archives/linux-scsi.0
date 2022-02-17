Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29493C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbiBQNbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240927AbiBQNbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:31:02 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41FD2782B3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104647; x=1676640647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yb073H/xn2vfr5A6/39r8qdOpwiU1394jDeekoBnKmQ=;
  b=Ycwa5yIG/kLQXrngi45gCMC/6ef/JyIag2jJWjW1w0C8NnF45mrmR0Po
   GIuhjXZB4/97top8jaSkg4+gjbpStM2AY0NFW6CXTRrUbjVScLXghWVdk
   Aq6UaTQ5FlhHO6A0VA1TsLg9Q/Jr93hNLjOh0G14xxLwYtesjUhKtSOEf
   VVrpiYOUN12Tzbxt8PmHBfIEihup4clc/1FykFpWIpH/3Gefp6S1RUG0c
   UAs+Tvs4lP7z4emZolM0wliEHLc8lfQjAdww32QmO61XtY7JcyjJHfDdg
   scV7g5M6kd2sk3Zu8t6gSxhfHrWaDX7oJ08R2nEX5IZdroFf4NGmoT6U9
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303254"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:47 +0800
IronPort-SDR: NvGhJiprfgqNyCloW4buZrpDj68mijR3MchI8SEXY4L7wR4vTUr2z3FhhoFmghcA4zRGCtJbFd
 FuGpycfeLD9UGqhoEPWFczhFypEhu15eSQOj0hyRwx2Dm7zmop9JmNhvkzyStLYsfdJeWscCmx
 Cb3+a59qsH+tJEC4QPFT9jOTGdabBQfm/2DvXCcAqUTbIHqSbfaJm5DElSU8r2AuXE+5fS82BD
 vVDhIOd4Af3v5+118y9tfhZP9Zj+VEXJy4UeU2LN0K9iw7XmAWKQ+DB+mTveWVQJDq2Yvfwsl6
 qctifPN1KY7UerCbXMLOadeq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:26 -0800
IronPort-SDR: gB7VIVOLmf/Auv4H4RPHJ5I4usaVqAFESCP6rfRzuPmwfdXyDsj3/fUJ0Zs6p2+sF9kscyLiSo
 qkAJzsIOOiWQ4Jn1DFOkVFOZozKWD/KRSiq0wbKP0b0xI7pLM65F5YqVy592bqDD584nuN2acu
 IW5hkP/jemYHCYO9lebyd4skEGmDxsg32HiEoMW+OpQG7ey3niq0YpFao/HBRLCGU/KX8lOy6l
 3AGENPpFWm2AQlm7vDoU9HgVd6hUFATqQMLRP8kkM72lHhZ7nw1J64yf6pmdtKLENVSCS4wh+f
 tFo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwgq0VXgz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104646; x=1647696647; bh=Yb073H/xn2vfr5A6/3
        9r8qdOpwiU1394jDeekoBnKmQ=; b=Q/75K0RkZzBvJUSMBd2KG5ajgdYesTx9uC
        YuIJNz3wW9upHcQA9D7DEpbrbLnX3rfdTvGOAncPE/xGwDJVH7QBGKF7d/bryDPn
        wdQpOx8YJw8u71c0eXt8U6B52SnbQ2QnLp9whpLLha+WmVAkgH0qzci3PqJstWsG
        2qkAOAonoRgQ2GDjVqQla34fcjICd6dWaOI7sfsoWi8v6E3BAnkKLJtu7dV5Q/+d
        ECdokV0U2/xkmTh/HikL4ActEGrM754lsx8dr+vyZ/w5GSp+nEiBzTsZapkoNf9t
        OGwnbIao9oubwjJNVqFPPQInM5M1R3mGPP8cR4N93XGwQGlxFqHA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id N-aZ7Z4HuHgM for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:46 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwgn3Xjsz1SHwl;
        Thu, 17 Feb 2022 05:30:45 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 31/31] scsi: pm8001: Fix pm8001_info() message format
Date:   Thu, 17 Feb 2022 22:29:56 +0900
Message-Id: <20220217132956.484818-32-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the driver messages more readable by adding a space after the
message prefix ":" and removing the extra space between function name
and line number.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index 2aab357d9a23..d78e6690333f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -71,7 +71,7 @@
 #define PM8001_IOERR_LOGGING	0x200 /* development io err message logging=
 */
=20
 #define pm8001_info(HBA, fmt, ...)					\
-	pr_info("%s:: %s  %d:" fmt,					\
+	pr_info("%s:: %s %d: " fmt,					\
 		(HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
=20
 #define pm8001_dbg(HBA, level, fmt, ...)				\
--=20
2.34.1

