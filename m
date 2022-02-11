Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAABCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347721AbiBKHhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbiBKHhL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:11 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CEF10B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565029; x=1676101029;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZTSQF503bBL6mXectoHacnuN4dK31inuZeg8aphpWpY=;
  b=pa3RywprcIvHwaoAf6GMstDlrZA4hz5h6u7su4isrBXvguVECV/2x/ax
   nnnGOsRJTeER2iNHuGrRpVJ36WotoU0ihmmAkk+Scqmy/e8MNUEvXReg3
   ZMuSk0LqwsTX8G1I2KYjopO82MTLtwUthbAt1hLWymL8b1t0NpLg3pzTZ
   aTRE5vzKxMT4w6XqDTulU+HsSP7oBe7aDRQ3j0+hKEq1m4/kqbrHb/G9t
   +Luv3obTTWmHgmSaBRA7ROsgbfKvh5OOjUoxqKXJp89iOKtQ3X02Q/QyS
   4kmIYLiiw5YxfG8SmHDRAa7CsAYrjaXIsUvTQBy7bfpvt/Tz74lkhXC7C
   w==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675119"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:09 +0800
IronPort-SDR: c+K+HrXBAvyElHBYBFirYzA/GlBhuBPxkz9B/ylXrRM5vmNN2c+0sHfJj1ExrYvpr18UYLcAQs
 ZQY5pRZiYD+hBGu4dC6sWxwMwyxxEH6NgLnmEdIaJFDqCO5vcy1cspj920CrrAuf5tAUJdUrrh
 7HG3xkJm5w2sLfQEjntUMJhnBT+reOAGq5NUaEdaOC2T1bxm/I64gTLLCM02qUlmco4XUvPphN
 N7TEc/U225nX03B8JIPLBgBwOi+z8L2cKYHnRcO809f7djUPACKLwtAa8x0WskdTLDm8R0zedM
 RvkWLXguchzXNTaSwe8Vljft
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:08:57 -0800
IronPort-SDR: mp59CLTI+bBVwSreyrYssN32vQwkqXEScUc6MBb9yj5vwQQ+hWD2/5D4+3/pCM++5DhB0bwZSV
 PsnJ8EdcuiUR4O2uKQ+W3qbWcUXaoh1RcqTn28A1LkfTlmt8AQNdQhGijn7rhgKjpmuEd3q+ZZ
 WG9OTSPrbcIt9Z9BXhWdj+v7wsBhhB77cLpWxa3OYiLt79nvcp42Q4Y5xQyYgDnpp81hRA1rdk
 4qYzBP46CMMa2iOvQWzmBuofb98gLu3zvikSVkA89wcPrs+wI5QdvwZ4QutFW8H4V49Wehwyph
 N6Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:12 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56b00pQz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565030; x=1647157031; bh=ZTSQF503bBL6mXecto
        HacnuN4dK31inuZeg8aphpWpY=; b=N8bt9En1Ls6B3IOWXNskQvH6OEbtLtqL2A
        fXe2YWJ0XCD37ZzFaajLyjL4M5mexAQ0fMPgOIurht9rtN0o/wFP3VKAr7ZF0cO9
        62J10M6ro+rGbHQ2H2lAs4Rg9kqu1EDUkPajkpw7drWjAFEeQCrraTkm0UD0hscc
        z/GMGIIq11flvzl8KYvx/1XaM8hmQHTFZ0qn55ptOl3EUjVRhujVdlJdxe5otJBf
        ELKPZApSJChkxH6dEiTuVlj7TjPKyTB+NC8gVpRMZ89hMyM6CPg84XoQ5EkZ6s+y
        w97p9MNTWMSeDUhYOvnCcCIldpm+qPEjxNucm+FXY1HnlKL9dGkw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id m54BHDL6EINr for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:10 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56Y3kKvz1SHwl;
        Thu, 10 Feb 2022 23:37:09 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 03/24] scsi: libsas: Remove unnecessary initialization in sas_ata_qc_issue()
Date:   Fri, 11 Feb 2022 16:36:43 +0900
Message-Id: <20220211073704.963993-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_task_alloc() sets the state flag SAS_TASK_STATE_PENDING for any
new task allocated. So there is no need to set this flag again in
sas_ata_qc_issue() after the task allocation.

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index 99549862c9c7..a03a841921db 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -204,7 +204,6 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
d_cmd *qc)
 	}
 	task->scatter =3D qc->sg;
 	task->ata_task.retry_count =3D 1;
-	task->task_state_flags =3D SAS_TASK_STATE_PENDING;
 	qc->lldd_task =3D task;
=20
 	task->ata_task.use_ncq =3D ata_is_ncq(qc->tf.protocol);
--=20
2.34.1

