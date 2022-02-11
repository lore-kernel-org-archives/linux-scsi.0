Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C58CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347771AbiBKHh7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347759AbiBKHhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:37 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31399272B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565052; x=1676101052;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=oQ2ji8IJZUHle9Y9hqNsyKJ4i2QjdaIMrbal2CVVGoM=;
  b=foqUKQa520LWaf/CqTikg/Gul/vTGJMN2ycS258jzVd0IYhCERKNcf79
   sihKHKoAB3UkPAq26XQ9gpUEpWbXCGFZ9Qhg8fuI0LMl4yY16nZn0W8sW
   DIBnLGWeG0on96hCKgYPisMwBKmeLj+eAxxfuCqCEgcOpDu8e/eYivuXX
   95vYcvTrINwTJTkWLtSD/jBUsU41AVl1I5P7X7tvNS7j+P4sdzRD1+/ht
   LxGGTKkE8/RNzSZVLMthXu27aamBUTYYLHmDE82HowQQbhP6paY6Cph91
   Kf5okX6UM5AdM/787QJzIw3mdScgPPV0pX/Gih1fXO+LhTcl7831xFQ6I
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675159"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:32 +0800
IronPort-SDR: 0pMA3GxDb4mDJAl9dXUu0mBiNt4//fH2v6Uqy8o3nJd48FAMKnjyhBYf1pdOGNp973dpJRN/0T
 1c2OHqDV0738+xLQVMqQ3Er0n6JtJ5/+HI+TW+AJDrXHZ6PZHg+IrjPS1GXmHJJXJOHVHFK7C2
 D/V6e67uSPimKpyRI/qxcdhidV1bP+4C2TRvO+kF2/hez3WLhtzXQOKQ5iF/fKzK7YVo+E9EUu
 KqCHceKTqsynMwhlmopQWK6j5OZuRuIrTVRp4gJzsmxhif8T/S6OURnAv+yAwfMVK/kTM7rOIs
 PYTR+z3KaQ9GW92YuEQAkwmb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:20 -0800
IronPort-SDR: 3twWOgTG16yL/lLtd8A67jqazkdwxc+TagOVuKex3txeh8/BxeVfTRvmXd//2ypsRTnz5dnnWV
 Ciioo84Ycshgt+2bQW8tACsg9AU93w4aP0qOLprFoG1Z8pvmpLUEPoUIl8jhV9UvN+Gy+tCmJp
 3CWWnuClLk5wOFPf7zx77cavcxelnfIvloZejdjk65XGGuuM9tHGboz3jFGfMqidTHxGZ6+RMz
 3rfxnsOL84A6rdxXImdPjkFDq+2sORSRkObjoeB+h6ipax46+w/IyIPcdeU5S04zqFA4WZJURI
 J64=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw5714HTTz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565053; x=1647157054; bh=oQ2ji8IJZUHle9Y9hq
        NsyKJ4i2QjdaIMrbal2CVVGoM=; b=LS5juentKpcEO0XrmCXDqaHUiwHgXRgJDX
        2kW94twbus9Zu1fH8VyP+ntGS0+7+0SxiDSyu628ricm86B10iV/E+jIrLMi4U30
        u39aqKXrK+04TZidfJD0SW7nPem+iQFuKEYCxetoyhPEm3EtZ6c0WSod4VC9P/Vp
        3aJcNn/ZqVoQQ+P6laiHt1W4O98WAD8RQghDHCt8Su2vY1MiCuKXAtCoA1OBG4IR
        o5KUCcU7dsckvo6EtyCdDEmcajzXIU66fLBfHgMjZWqTbpAe/rZ1NSDeQJwePWVg
        CK9rN5mSxyPuZUnL+jjY3UO+163duK5qnSpUFPJ3EzPtO7HNYyJg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id egH6V3ewhEMN for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:33 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw5701l76z1Rwrw;
        Thu, 10 Feb 2022 23:37:32 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 21/24] scsi: pm8001: Fix pm8001_task_exec()
Date:   Fri, 11 Feb 2022 16:37:01 +0900
Message-Id: <20220211073704.963993-22-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The n_elem local variable in pm8001_task_exec() is initialized to 0 and
changed set to the number of DMA scatter elements for a needed for a
task command only for ATA commands and for SAS commands that have a
non-zero number of sg segments. n_elem is never initialized to 0 for SAS
commands that do not no sg segments, potentially leading to an incorrect
value of n_elem being used for a task. Add the missing 0 initialization.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 7b749da82a61..8cd7e7837f41 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -383,7 +383,7 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct sas_task *t =3D task;
 	struct task_status_struct *ts =3D &t->task_status;
 	struct pm8001_ccb_info *ccb;
-	u32 tag =3D 0xdeadbeef, rc =3D 0, n_elem =3D 0;
+	u32 tag =3D 0xdeadbeef, rc =3D 0, n_elem;
 	unsigned long flags =3D 0;
 	enum sas_protocol task_proto =3D t->task_proto;
=20
@@ -440,6 +440,8 @@ static int pm8001_task_exec(struct sas_task *task,
 					rc =3D -ENOMEM;
 					goto err_out_tag;
 				}
+			} else {
+				n_elem =3D 0;
 			}
 		} else {
 			n_elem =3D t->num_scatter;
--=20
2.34.1

