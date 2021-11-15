Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0107FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 09:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA71563217
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 09:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhKOJcv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 04:32:51 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:46193 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbhKOJco (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 04:32:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636968589; x=1668504589;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VAdOrRT0DNNhPdb7LOZzJiS0gTpM8rkpkjL/dbqp7Ic=;
  b=eWEUlAnZwlKYahpcU1Y9DZzEmbjzBhW9D0EY5HrEnokEvKKBvyh62JAQ
   uzFgkkwSlpMcZh0LwlzJMFjkiLkp3N2FE48KtG8n4nAJs4iv7XMrntUeg
   bMajouvUCsjcuZpfkJIfkOWnjV9ifu/RO7TbRdIaXU2XyiUSYpJ9Hu+Mi
   oVvejkdN1EryNG9HtPlZYO+o9VPRA9jJxegduq1h1TXykk4L8dXk/41/c
   6vpVdwYrcSNZ6cTLewwHpi/la/79SMz+j7JbYFUYEO0vTla47GN3qR1Fu
   czubvJMsYh2fcsrQlUM8ylCc7gqy9Ys8ShQI/4z2JmaWvlb69fqAA9H1Y
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631548800"; 
   d="scan'208";a="184613131"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Nov 2021 17:29:30 +0800
IronPort-SDR: k3HcApD876bBvMxGHnPaHmNmMEqSALc2oM/q6NMcLb1110hbTr5v7GKVC/dPmT5Rhn/RWu5Qo6
 T9BIqtxnVz9Fm6HOfCsQNLsZs/zM9f/Z/RkBJrAoSJB2mvuD3wSbEGe2nHj1hMrcgS/3ecbnWA
 Hybqt9L3D7M60Qmz62EWvmHPwJNcKW4gzHcd4V5NmSyZoOVsSsHu8rOJcehTkEA63km6oG7jda
 pzZHDkvXSvigzo14qEpWEMmucXgVxZQRb4VrG7UWjLDT3cs+7icgaIBt3oabp0AJv2zwDYeTld
 3N0Frjl+YuYurEgT9nn/Tc7I
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 01:03:02 -0800
IronPort-SDR: /NztMPdapfY2Flmo55MCnCQ6hwhNqIh8Nh6Vdb5Jrl+Oz5fcxZY+WBFjPCQ39bEmlCmWpxhdm7
 u+t2nvIWyUoPTtgPN1kv1HtOUHnoX8l9GYkDP/0Vu3SFfKVCxjVJpJykqnpLUp2Xj2bMF77XCv
 bqXrprf42bpYMxU9iHhIZSN1qP2LL9xx0tL2Xs6vhKGOkoUI/XuOCMt9DVDajNK51ihepP7/aS
 wX6y1OPeY6wngrB0wCOuiv7ihvMW268GjEbXOoIiy4MGLseBagOB1XpFGsv72H4Lcv8TTO+dgx
 dHY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 01:29:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Ht3mp1sCsz1RtVm
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 01:29:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1636968565;
         x=1639560566; bh=VAdOrRT0DNNhPdb7LOZzJiS0gTpM8rkpkjL/dbqp7Ic=; b=
        ticb0NHwdjm8fG2t2yReNKqK4+Rv6/8ofhbGth30MutmJGGiZ9Xb0ES40pqHbiB1
        VdXPFVQZjdL5ngFN+0zjwATRMX9yT+c3WiKSyh1tDh7uB23bV8zrdulo1DIwfQF5
        +UrbKsSSilbvuY2Tc/wmU+p1V94/BLr8I3xHCi5ThnnBN22xHQX62mTA1V9U7U0f
        HlYBLIFuiCejJZ9MsVL5NrbQz2+vVKsW5cnIjFExor58i92jADBjwUci4I+mbKTd
        /H58HoVsqCT4EwcIRpk3NA17xaJM8Y+RECPrwzYi41s6FBv71FBiYMh0uhKSQSOy
        aVUGlSGXFGcQyAZu/EK5SQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2s5pdOVaMKRP for <linux-scsi@vger.kernel.org>;
        Mon, 15 Nov 2021 01:29:25 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Ht3mh3X4Cz1RtVl;
        Mon, 15 Nov 2021 01:29:24 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: simplify registration of scsi host sysfs attributes
Date:   Mon, 15 Nov 2021 18:29:22 +0900
Message-Id: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similarly to the way attribute groups are registered for a scsi device
using the device sdev_gendev, a scsi host attribute groups can be
registered by specifying the generic attribute groups using the groups
field of the scsi_host_type (struct device_type) and set the array of
host attribute groups provided by the LLDD using the groups field of the
host shost_dev generic device. This partially reverts the changes
introduced by commit 92c4b58b15c5 ("scsi: core: Register sysfs
attributes earlier"), avoiding the for loop to build a size limited
array of attribute groups from the generic attributes and LLDD provided
attribut groups.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/hosts.c      | 15 +++------------
 drivers/scsi/scsi_priv.h  |  2 +-
 drivers/scsi/scsi_sysfs.c |  7 ++++++-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8049b00b6766..c3b6812aac5b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -359,6 +359,7 @@ static void scsi_host_dev_release(struct device *dev)
 static struct device_type scsi_host_type =3D {
 	.name =3D		"scsi_host",
 	.release =3D	scsi_host_dev_release,
+	.groups =3D	scsi_sysfs_shost_attr_groups,
 };
=20
 /**
@@ -377,7 +378,7 @@ static struct device_type scsi_host_type =3D {
 struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int pr=
ivsize)
 {
 	struct Scsi_Host *shost;
-	int index, i, j =3D 0;
+	int index;
=20
 	shost =3D kzalloc(sizeof(struct Scsi_Host) + privsize, GFP_KERNEL);
 	if (!shost)
@@ -483,17 +484,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_t=
emplate *sht, int privsize)
 	shost->shost_dev.parent =3D &shost->shost_gendev;
 	shost->shost_dev.class =3D &shost_class;
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
-	shost->shost_dev.groups =3D shost->shost_dev_attr_groups;
-	shost->shost_dev_attr_groups[j++] =3D &scsi_shost_attr_group;
-	if (sht->shost_groups) {
-		for (i =3D 0; sht->shost_groups[i] &&
-			     j < ARRAY_SIZE(shost->shost_dev_attr_groups);
-		     i++, j++) {
-			shost->shost_dev_attr_groups[j] =3D
-				sht->shost_groups[i];
-		}
-	}
-	WARN_ON_ONCE(j >=3D ARRAY_SIZE(shost->shost_dev_attr_groups));
+	shost->shost_dev.groups =3D sht->shost_groups;
=20
 	shost->ehandler =3D kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index a278fc8948f4..f8ca22d495d9 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -144,7 +144,7 @@ extern struct scsi_transport_template blank_transport=
_template;
 extern void __scsi_remove_device(struct scsi_device *);
=20
 extern struct bus_type scsi_bus_type;
-extern const struct attribute_group scsi_shost_attr_group;
+extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
=20
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 55addd78fde4..c3b93d2de081 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -424,10 +424,15 @@ static struct attribute *scsi_sysfs_shost_attrs[] =3D=
 {
 	NULL
 };
=20
-const struct attribute_group scsi_shost_attr_group =3D {
+static const struct attribute_group scsi_shost_attr_group =3D {
 	.attrs =3D	scsi_sysfs_shost_attrs,
 };
=20
+const struct attribute_group *scsi_sysfs_shost_attr_groups[] =3D {
+	&scsi_shost_attr_group,
+	NULL,
+};
+
 static void scsi_device_cls_release(struct device *class_dev)
 {
 	struct scsi_device *sdev;
--=20
2.31.1

