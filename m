Return-Path: <SRS0=vR/u=Z4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD4BC2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 04:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 494F12467F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 04:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="iFAH3XJQ";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="LC5bdss0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfLFE1k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 23:27:40 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46578 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbfLFE1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 23:27:40 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB64NP7v002147;
        Thu, 5 Dec 2019 20:26:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=vi5cTY/hiypVuexohgFhs7tPdOHaWK8001RGeYNn5/M=;
 b=iFAH3XJQxC3qKrgA33+1Ab+/wE09fybz7rDkqOGylUqM8JnUaUktoRpqWW5vd1OEZ0q1
 A+vYbLQxT+fD3OXn0Aa1H9ANxyF5+Slhta9Zd6xEXqFejhvk8HL2BEnGdqHzaVND+QSX
 0NXpABso/ywsKtpdxjjAzFrRUYBdhti4NQj8TrHAzqw2QlGVU++lW5fSptfts9mH3zFg
 +Shx4fdC0jnxxdBNgP2dN5KCIEx4Tk3F7dOA/ZRdgLUvsjmcO4nLlNEH2H7KkBjYT1r9
 FOAGr8mkgAjpBUadrM+egDdCdusiVZrUbOB1hfeZoxq9NOC/E1jZ9TPtfWuD+SayKR3M pw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wkmw0952u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Dec 2019 20:26:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KABpu/Twh37fHtpDxGxxHCKD08CxLGBqKHkbBf3OqigdsS9aILieYzvzuij3hxMP232E/pi2ZkgXf0nawk9KNsycwGyderESo0FQd3raSVY9aAqktAGsmAubgGf6iUlwKo8Pu2v7nUbeswJE9Tftd/HYMKqbKGhfmBC5mBSot5dk8PMLOpimxVqhw4KGLOYXqgVZfEDyQCAq0NS0v605ZPhpE8X2puYSaOQJYI29T78Ok+kzAoUS4khRNPkKtHu0k+WCnx8udjUpRaZXsisUfjSGr04YLMnnYhs2Vl6re8QACIKMM9gbJqKeVgRpc4C31QaIZa3LSx3StLbRx+LfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vi5cTY/hiypVuexohgFhs7tPdOHaWK8001RGeYNn5/M=;
 b=RR7bs3ftoQ9pdD6Aw88pKJxrOOQxVPpc/s9zSZa6XF87b9kru9U1IZS+MPgILNw3WXveSOkXsvLV6IDwJhvYufq3kauWINvtqzYQvpG74j21+gL6ZciSd01DHjXLWL5Ag3M4LGSzMHn4z76X5FMHmxAJdLKrfZWIv8pced0kaiiE0MvLFoi3DS/e5AMkDWTdNAy9QWGS2PX8wtGIVd/wZ56koDPxgIarHWrbclutpqoTrLIBRKWt0OkhLFOQ49nxS+8RK6zfCssSk3FKgSto6hsqKjABgbPO0VMrxYD+fNOqAO43XEke968ctXapBCoL7Q8u8ZBJyw7vyq3STO9zPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.28) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vi5cTY/hiypVuexohgFhs7tPdOHaWK8001RGeYNn5/M=;
 b=LC5bdss0KLmf4Xqb28vpCp0kSbac8RuikPdzPN1FJYi7wA36VZ8hJn52CUARSutCoQdVUG6I+XJwDi52j0B3ZFBi+ilsTn28igdjJ931kgPffRRewWU95MXzDkGjTnwxnajwRDu2otMhSfetiqhikrM2Q4Ti7ZtRMjy3qXu10yo=
Received: from CO2PR07CA0065.namprd07.prod.outlook.com (2603:10b6:100::33) by
 CY4PR0701MB3715.namprd07.prod.outlook.com (2603:10b6:910:93::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.22; Fri, 6 Dec
 2019 04:26:10 +0000
Received: from BN8NAM12FT041.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::208) by CO2PR07CA0065.outlook.office365.com
 (2603:10b6:100::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.12 via Frontend
 Transport; Fri, 6 Dec 2019 04:26:10 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.28; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BN8NAM12FT041.mail.protection.outlook.com (10.13.182.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Fri, 6 Dec 2019 04:26:09 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xB64Q2Wf018969
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 5 Dec 2019 23:26:04 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 6 Dec 2019 05:26:01 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 6 Dec 2019 05:26:01 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xB64Q1WG011747;
        Fri, 6 Dec 2019 05:26:01 +0100
Received: (from sheebab@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xB64PwT8011723;
        Fri, 6 Dec 2019 05:25:58 +0100
From:   sheebab <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>,
        sheebab <sheebab@cadence.com>
Subject: [PATCH v2] scsi: ufs: Update L4 attributes on manual hibern8 exit in  Cadence UFS.
Date:   Fri, 6 Dec 2019 05:25:03 +0100
Message-ID: <1575606303-10917-1-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(39860400002)(346002)(199004)(189003)(36092001)(186003)(86362001)(14444005)(70206006)(76130400001)(7416002)(5660300002)(107886003)(26826003)(54906003)(26005)(110136005)(16586007)(70586007)(316002)(4326008)(42186006)(8676002)(36756003)(51416003)(81156014)(87636003)(8936002)(336012)(305945005)(6666004)(2616005)(426003)(478600001)(50466002)(81166006)(48376002)(50226002)(356004)(2906002)(921003)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0701MB3715;H:rmmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98f1e7da-0a25-4149-532a-08d77a046b50
X-MS-TrafficTypeDiagnostic: CY4PR0701MB3715:
X-Microsoft-Antispam-PRVS: <CY4PR0701MB3715911F955F82E5F132F140A45F0@CY4PR0701MB3715.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0243E5FD68
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GfDVWHUpgmjJmB/dkIazMpoX65C9nPCEZafPLs72oA0ochuLsvtdB7ZAxeDoEnJIEixPAB35dCFQoUFY3n2G2n5HY4UeFK7CHiu8sO/j8uTNgtXXpJ5pPYdTDAYXuCXV/sZc7mLqzi3PBSdw4BaRuDVjTR3ADez4vxq5WAUhVcg6xgSsTFzJJUaYoQP8adyZs6H6vbnnYbZh1zLcFEQZ3NKXfml7K9ufCWXDQyMXNTdeAQhVoTsvJRF7NDOXL7vwSzCmOsKURp14eI63BSyZRmZQCpKLVjsD1jKn79wJhtnlRkbvspfZT44nmRWAaqmIi7ddL3OyJDtZWihySjC53SXjAzeLB67u7QY6fofCkUQdlZkiZgR/eyAT2i5pfZUKp8YYbVH2tTTQvyYNW/FI2Y1pj6GfYGGH3jo+4JYzYfykV3wnAmVl8+RrErRfA5kgNoE6j7tTlh6mPraaTnKxIblpe0lxa92x0+HiZSDr3T9Hh6fLEXzfeCq/Bz5GARexY9IPZxwk67Sild3/DTFHcnETy7UEb70G4egD2bTEkpuBGpFeec9UXjFBJD4MVcp0NJyG5DJEnpjhu5gZxQ8lWw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2019 04:26:09.4808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f1e7da-0a25-4149-532a-08d77a046b50
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0701MB3715
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_10:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912060037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Backup L4 attributes duirng manual hibern8 entry
and restore the L4 attributes on manual hibern8 exit as per JESD220C.

Signed-off-by: Sheeba B <sheebab@cadence.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
---
v2:
Dropped patch 1/2 for this series and rebased to include only manual hibernation fixes
---
 drivers/scsi/ufs/cdns-pltfrm.c | 106 +++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index 6feeb0faf123..1c80f9633da6 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -19,6 +19,85 @@
 
 #define CDNS_UFS_REG_HCLKDIV	0xFC
 #define CDNS_UFS_REG_PHY_XCFGD1	0x113C
+#define CDNS_UFS_MAX_L4_ATTRS 12
+
+struct cdns_ufs_host {
+	/**
+	 * cdns_ufs_dme_attr_val - for storing L4 attributes
+	 */
+	u32 cdns_ufs_dme_attr_val[CDNS_UFS_MAX_L4_ATTRS];
+};
+
+/**
+ * cdns_ufs_get_l4_attr - get L4 attributes on local side
+ * @hba: per adapter instance
+ *
+ */
+static void cdns_ufs_get_l4_attr(struct ufs_hba *hba)
+{
+	struct cdns_ufs_host *host = ufshcd_get_variant(hba);
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERDEVICEID),
+		       &host->cdns_ufs_dme_attr_val[0]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERCPORTID),
+		       &host->cdns_ufs_dme_attr_val[1]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
+		       &host->cdns_ufs_dme_attr_val[2]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PROTOCOLID),
+		       &host->cdns_ufs_dme_attr_val[3]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTFLAGS),
+		       &host->cdns_ufs_dme_attr_val[4]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
+		       &host->cdns_ufs_dme_attr_val[5]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
+		       &host->cdns_ufs_dme_attr_val[6]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
+		       &host->cdns_ufs_dme_attr_val[7]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
+		       &host->cdns_ufs_dme_attr_val[8]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
+		       &host->cdns_ufs_dme_attr_val[9]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTMODE),
+		       &host->cdns_ufs_dme_attr_val[10]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
+		       &host->cdns_ufs_dme_attr_val[11]);
+}
+
+/**
+ * cdns_ufs_set_l4_attr - set L4 attributes on local side
+ * @hba: per adapter instance
+ *
+ */
+static void cdns_ufs_set_l4_attr(struct ufs_hba *hba)
+{
+	struct cdns_ufs_host *host = ufshcd_get_variant(hba);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID),
+		       host->cdns_ufs_dme_attr_val[0]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
+		       host->cdns_ufs_dme_attr_val[1]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
+		       host->cdns_ufs_dme_attr_val[2]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PROTOCOLID),
+		       host->cdns_ufs_dme_attr_val[3]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
+		       host->cdns_ufs_dme_attr_val[4]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
+		       host->cdns_ufs_dme_attr_val[5]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
+		       host->cdns_ufs_dme_attr_val[6]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
+		       host->cdns_ufs_dme_attr_val[7]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
+		       host->cdns_ufs_dme_attr_val[8]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
+		       host->cdns_ufs_dme_attr_val[9]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE),
+		       host->cdns_ufs_dme_attr_val[10]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
+		       host->cdns_ufs_dme_attr_val[11]);
+}
 
 /**
  * Sets HCLKDIV register value based on the core_clk
@@ -77,6 +156,22 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
 	return cdns_ufs_set_hclkdiv(hba);
 }
 
+/**
+ * Called around hibern8 enter/exit.
+ * @hba: host controller instance
+ * @cmd: UIC Command
+ * @status: notify stage (pre, post change)
+ *
+ */
+static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
+				    enum ufs_notify_change_status status)
+{
+	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
+		cdns_ufs_get_l4_attr(hba);
+	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
+		cdns_ufs_set_l4_attr(hba);
+}
+
 /**
  * Called before and after Link startup is carried out.
  * @hba: host controller instance
@@ -117,6 +212,14 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
 static int cdns_ufs_init(struct ufs_hba *hba)
 {
 	int status = 0;
+	struct cdns_ufs_host *host;
+	struct device *dev = hba->dev;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+
+	if (!host)
+		return -ENOMEM;
+	ufshcd_set_variant(hba, host);
 
 	if (hba->vops && hba->vops->phy_initialization)
 		status = hba->vops->phy_initialization(hba);
@@ -144,8 +247,10 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
 
 static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
+	.init = cdns_ufs_init,
 	.hce_enable_notify = cdns_ufs_hce_enable_notify,
 	.link_startup_notify = cdns_ufs_link_startup_notify,
+	.hibern8_notify = cdns_ufs_hibern8_notify,
 };
 
 static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
@@ -154,6 +259,7 @@ static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
 	.hce_enable_notify = cdns_ufs_hce_enable_notify,
 	.link_startup_notify = cdns_ufs_link_startup_notify,
 	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
+	.hibern8_notify = cdns_ufs_hibern8_notify,
 };
 
 static const struct of_device_id cdns_ufs_of_match[] = {
-- 
2.17.1

