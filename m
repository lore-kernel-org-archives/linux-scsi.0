Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EE0C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D12206BF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="RICz3GlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgD0PIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:08:40 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.112]:45014 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727010AbgD0PIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 11:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588000116; i=@ts.fujitsu.com;
        bh=hhdndVHek54RMTdFxOSkrFch+MGToNeHqu/zEHcd718=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=RICz3GlQBKo+7Vdw1+8OBF0vp9Y4jauNnyuHkxyesoozcqeRuxdS7DU1jLwK8/zWm
         e8RnRVPBAflS7EvfHSdEgt/hsT9kgljvcmZF+2hSDnxLa4ohVG1AgFeaTEVeG3qR3U
         72rfiASEM0qVbKvm3joeSPlhHkrrT4tTTj9WQi6g+6roLX7M3v4aLaMErElQf9KXUc
         1rwmbMs4q/U35O+UuvyByPYrVb7pllhAwZy14c+IUVbK3GiqIIq8Ve/+7CbvWSpfii
         iAMkoDjoGX23QHMOjVGqjQGFdRg6fYvrmTS3lV4ZjmZkh/fYU2uxb0hb8HZYq/MG2H
         z7mm3agBiWwDA==
Received: from [100.113.6.103] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-central-1.aws.symcld.net id FD/77-39489-475F6AE5; Mon, 27 Apr 2020 15:08:36 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRWlGSWpSXmKPExsViZ8MRqlv8dVm
  cwZJFqhZf/09nsVi5+iiTRff1HWwWy4//Y7JYf2QDo0Xr0rdMDmweu282sHl8fHqLxeP9vqts
  HptPV3t83iQXwBrFmpmXlF+RwJqx8fdD1oKjkhUH/jexNDAuFOti5OIQEpjMKDHx10pWCGc6o
  8SCZ6eYuxg5OdgEDCRWTLrPAmKLCNhI9B1eygRSxCzQxChx69V6NpCEsECIRN/q42BFLAKqEv
  Me/QWzeQXsJA4eu8IOYksIyEt0HJgMFucUsJc4c/E6UC8H0DY7iY8P9CYwci9gZFjFaJFUlJm
  eUZKbmJmja2hgoGtoaKxromtkpJdYpZukl1qqm5yaV1KUCJTUSywv1iuuzE3OSdHLSy3ZxAgM
  q5RCFrEdjLPWvtc7xCjJwaQkynty9bI4Ib6k/JTKjMTijPii0pzU4kOMMhwcShK8Uz8D5QSLU
  tNTK9Iyc4AhDpOW4OBREuFN+AKU5i0uSMwtzkyHSJ1iVJQS57UDSQiAJDJK8+DaYHF1iVFWSp
  iXkYGBQYinILUoN7MEVf4VozgHo5Iw7yyQ7TyZeSVw018BLWYCWlwlvxhkcUkiQkqqgUn11Tu
  35q5zNrUOtZJzrz6cO0sm3O8Q8xTNp8F3+dKeLJi5Vnn1vH93T21vv3Zn4rMzEnHPzi8WWvq9
  x+LXN9u8PyJnuXYdON5+VOB53NSfspfSgmYzC4WdaGn5Wf8reW3wQbVPm7xm77wYlFnDv+LAV
  +WNHxPz3rw169JaKPz4mg/Hrqkbm3dpmlgu/3qN6eOOxg9/ZCLi921Jip3Tnbf48//vlxbzKJ
  slmKan73fznb4v68zLEqcXQa9fVmn9eGB8uHS2wdy2a1yOXmulXvHtkuTQTS/6H6lYaqSuUr3
  toWjgC7Ha1pTdu/lqOj3CDqlGn29cqpQw/zt7mLlh6BxJx+2hyT5/uBYotS8JSLNVYinOSDTU
  Yi4qTgQArlRA2iYDAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-23.tower-245.messagelabs.com!1588000115!1029317!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 9044 invoked from network); 27 Apr 2020 15:08:35 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-23.tower-245.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Apr 2020 15:08:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 03RF8XOS025009;
        Mon, 27 Apr 2020 16:08:33 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 01D7420722;
        Mon, 27 Apr 2020 17:08:26 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, ddiss@suse.de, hch@lst.de,
        martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 2/4] target: tcmu: add attrbutes enforce_pr_isids and force_pr_aptpl
Date:   Mon, 27 Apr 2020 17:08:21 +0200
Message-Id: <20200427150823.15350-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tcmu has not set TRANSPORT_FLAG_PASSTHROUGH_PGR. Therefore the
in core pr emulation is active by default, but there are some
attributes for configuration missing. So we add them now.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 11 +++++++++++
 drivers/target/target_core_user.c     | 19 +++++++++----------
 include/target/target_core_backend.h  |  1 +
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d8589bb39c53..efa92d836946 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1210,6 +1210,17 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 };
 EXPORT_SYMBOL(passthrough_attrib_attrs);
 
+/*
+ * pr related dev_attrib attributes for devices passing through CDBs,
+ * but allowing in core pr emulation.
+ */
+struct configfs_attribute *passthrough_pr_attrib_attrs[] = {
+	&attr_enforce_pr_isids,
+	&attr_force_pr_aptpl,
+	NULL,
+};
+EXPORT_SYMBOL(passthrough_pr_attrib_attrs);
+
 TB_CIT_SETUP_DRV(dev_attrib, NULL, NULL);
 TB_CIT_SETUP_DRV(dev_action, NULL, NULL);
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index f769bb1e3735..8adde343182f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2753,12 +2753,12 @@ static int __init tcmu_module_init(void)
 		goto out_unreg_device;
 	}
 
-	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++) {
+	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++)
 		len += sizeof(struct configfs_attribute *);
-	}
-	for (i = 0; tcmu_attrib_attrs[i] != NULL; i++) {
+	for (i = 0; passthrough_pr_attrib_attrs[i] != NULL; i++)
+		len += sizeof(struct configfs_attribute *);
+	for (i = 0; tcmu_attrib_attrs[i] != NULL; i++)
 		len += sizeof(struct configfs_attribute *);
-	}
 	len += sizeof(struct configfs_attribute *);
 
 	tcmu_attrs = kzalloc(len, GFP_KERNEL);
@@ -2767,13 +2767,12 @@ static int __init tcmu_module_init(void)
 		goto out_unreg_genl;
 	}
 
-	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++) {
+	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++)
 		tcmu_attrs[i] = passthrough_attrib_attrs[i];
-	}
-	for (k = 0; tcmu_attrib_attrs[k] != NULL; k++) {
-		tcmu_attrs[i] = tcmu_attrib_attrs[k];
-		i++;
-	}
+	for (k = 0; passthrough_pr_attrib_attrs[k] != NULL; k++)
+		tcmu_attrs[i++] = passthrough_pr_attrib_attrs[k];
+	for (k = 0; tcmu_attrib_attrs[k] != NULL; k++)
+		tcmu_attrs[i++] = tcmu_attrib_attrs[k];
 	tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
 
 	ret = transport_backend_register(&tcmu_ops);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1b752d8ea529..8177667eba6d 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -94,6 +94,7 @@ int	transport_set_vpd_ident(struct t10_vpd *, unsigned char *);
 
 extern struct configfs_attribute *sbc_attrib_attrs[];
 extern struct configfs_attribute *passthrough_attrib_attrs[];
+extern struct configfs_attribute *passthrough_pr_attrib_attrs[];
 
 /* core helpers also used by command snooping in pscsi */
 void	*transport_kmap_data_sg(struct se_cmd *);
-- 
2.12.3

