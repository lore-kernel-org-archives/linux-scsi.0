Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10466C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA5272186D
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="iGiGCmUj";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="1MnMJmOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKSHF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 02:05:57 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:52212 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727145AbfKSHF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 02:05:56 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ73hYn009047;
        Mon, 18 Nov 2019 23:05:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=qI6V5date5LOpgUANTAHpyiGkFplUbk4ChWLOvlSdmA=;
 b=iGiGCmUj2uUjcqzfkg7YiVPZukTBVpsZIFaIXjCkvjgSZyMIawX761pmrwlPST6natBC
 xkLV8ae7sfsZeAuvi0Sk7ev2egcB2aNuZbM+1oyWehMTy/4k6NiP6LYjb4pB3pggvWxk
 +IyiHIaoZkUVpOpBOObERjJvBZTqRckSP2a4D7cgt2jNYCf5uHadeOFe706JOW0hf/Ap
 /pjbEuG9iEzopGaP6JNY/TLu2XDyEF8pyDYPB8cad1PIhMm19vv9+rNMDsGb46b5pdUb
 JzA/cTUi8eEYwBdaWzv5LvgTEknh9ePCANHkzkX+jyzotXxRbWAWc0Q4cZRlQVt4tXWT Tg== 
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2051.outbound.protection.outlook.com [104.47.40.51])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wadjy9hhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Nov 2019 23:05:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=deFm+XWE/9KpxY7Nq7fywyV0l3+ScXO5rVxqle0NWolar+LYHQRxHEY5GWWu1FSzCQA22uC9OZa1bZGzXGmkZl0N8Tkw20jJlHLuz+DzZePOSK32jjgRtxHASCbFHTriXVQSqvP1/f+g6XoLN7r8xASibQuMkSQID5Utc4/NETrpvTrxccDsSFMz+lXe/hQMwoj6sqIkiBmFNq37BIX3RmDuy2x31wNSxieSIHFbfq6tN5/7/5pOxwvtJGlzPI8HEBHkaRu9QVBBh2XANKHGq8FRJXGhK4KC0asu77Lst+Mun413uatPFvjRESjCo1vq+cpvYVFOHvXhZMUTvPAt9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qI6V5date5LOpgUANTAHpyiGkFplUbk4ChWLOvlSdmA=;
 b=lOe+KpsiQa8WsMKHxca6eibrso5wEQBy7rew8RTHkWN7V/0awBjEDXgMtDTPeeRO/q1t3bjUpvrlUTbU6NAavXpJBaDBzDkhusRb3arx1mP+a9cUGqVi12JBOAeR6AP1QxhQzTvv9hqYau8/oxNjOhh/yJP9f0LnWuNDX9WiPuwH3XFsBNTIOc/h2+vXTJ2DxxgJ1HOjFNjptGXhgf9bocna5zzKv0V3RVMYvdPbUk78WDCkcH/qm1E1wL1vbZtMaFMJ+7tzEPb8BwSnLo5OUIKf5jesiLoA+F8kgBpMxwOCAP5ABYHaDUEfOJXJ2b68y/h931a3X2Kk0tlfA56UdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qI6V5date5LOpgUANTAHpyiGkFplUbk4ChWLOvlSdmA=;
 b=1MnMJmOAFfVLx5g0XMEsvThknnQh8t9LHy3cdXUYeb50JHU3HPxSP6qehE/HaPhumbJ/eeSVvqELxNmZOZv5yV27aun0RdVMuR9KN9WLleCsnMRdar2gb9Up0bf16sF5GwBd/mG0e+NKit5trbMpJ7zH+fos9Lq3hUXzA5Bvww4=
Received: from BYAPR07CA0057.namprd07.prod.outlook.com (2603:10b6:a03:60::34)
 by CY1PR07MB2587.namprd07.prod.outlook.com (2a01:111:e400:c60e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.27; Tue, 19 Nov
 2019 07:05:26 +0000
Received: from MW2NAM12FT015.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::206) by BYAPR07CA0057.outlook.office365.com
 (2603:10b6:a03:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 19 Nov 2019 07:05:26 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 MW2NAM12FT015.mail.protection.outlook.com (10.13.180.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23 via Frontend Transport; Tue, 19 Nov 2019 07:05:25 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id xAJ75LMB023874
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 18 Nov 2019 23:05:24 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 19 Nov 2019 08:05:20 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 08:05:20 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xAJ75KYc024629;
        Tue, 19 Nov 2019 08:05:20 +0100
Received: (from sheebab@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xAJ75Kks024628;
        Tue, 19 Nov 2019 08:05:20 +0100
From:   sheebab <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>, <linux-block@vger.kernel.org>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>,
        sheebab <sheebab@cadence.com>
Subject: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual hibern8 exit in Cadence UFS.
Date:   Tue, 19 Nov 2019 08:04:42 +0100
Message-ID: <1574147082-22725-3-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.4.5
In-Reply-To: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(36092001)(189003)(199004)(107886003)(76176011)(51416003)(478600001)(8676002)(26826003)(50226002)(36756003)(47776003)(4326008)(16586007)(42186006)(54906003)(316002)(14444005)(7636002)(5660300002)(7416002)(6666004)(86362001)(126002)(356004)(426003)(50466002)(76130400001)(186003)(26005)(87636003)(110136005)(2906002)(2616005)(8936002)(246002)(336012)(11346002)(305945005)(2201001)(70586007)(486006)(70206006)(48376002)(476003)(446003)(921003)(1121003)(83996005)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR07MB2587;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 015bca00-b35e-493b-79bc-08d76cbeda63
X-MS-TrafficTypeDiagnostic: CY1PR07MB2587:
X-Microsoft-Antispam-PRVS: <CY1PR07MB2587E6B19E9FCAD176B8B3E0A44C0@CY1PR07MB2587.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 022649CC2C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X/QFX0xrSda+crQPYtcg2+eVNP9XjjaUMqtItpSqnTApibSw4axrTKOolTzJxmjSjO4vv6GY4UvmexWpJlcTitusG9MeHbDVtjG/46edoJm3kyyIbKoJIngtAVbW9PK4pHj5BmBYAHKqE3xFZWPGi4h1NEJUqnB6H8Sj6wK9zewWETgMCrUv2H7MOkyIh5EKp0nalnWvWWI40RHGFmu/QZxds2hNoWwk/EHnn6xNDlPRjWuiOuHgxV1U7OHjK5QI/o91Ks0LWGabVh286UDL9zaCQJ+bBAYpO+2c5PU7J1KeaEbxtrpDiO9EOcSRtJ7VeYRXwi39Lm4j27y/4vcaNq+HAhY88gigMR+YhY/Adhi3UEwXntQlYKX/P1JIOLU9JSorAYRt+8fMxK2bGQDf6u8kBVJ6K5Zuvrtqea6m9qFOPcn7202V4oMiTI7dcvk1
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2019 07:05:25.9182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 015bca00-b35e-493b-79bc-08d76cbeda63
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR07MB2587
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_01:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911190065
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Backup L4 attributes duirng manual hibern8 entry
and restore the L4 attributes on manual hibern8 exit as per JESD220C.

Signed-off-by: sheebab <sheebab@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 97 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index adbbd60..5510567 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -19,6 +19,14 @@
 
 #define CDNS_UFS_REG_HCLKDIV	0xFC
 #define CDNS_UFS_REG_PHY_XCFGD1	0x113C
+#define CDNS_UFS_MAX 12
+
+struct cdns_ufs_host {
+	/**
+	 * cdns_ufs_dme_attr_val - for storing L4 attributes
+	 */
+	u32 cdns_ufs_dme_attr_val[CDNS_UFS_MAX];
+};
 
 /**
  * cdns_ufs_enable_intr - enable interrupts
@@ -47,6 +55,77 @@ static void cdns_ufs_disable_intr(struct ufs_hba *hba, u32 intrs)
 }
 
 /**
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
+
+/**
  * Sets HCLKDIV register value based on the core_clk
  * @hba: host controller instance
  *
@@ -134,6 +213,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
 		 * before manual hibernate entry.
 		 */
 		cdns_ufs_enable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
+		cdns_ufs_get_l4_attr(hba);
 	}
 	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT) {
 		/**
@@ -141,6 +221,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
 		 * after manual hibern8 exit.
 		 */
 		cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
+		cdns_ufs_set_l4_attr(hba);
 	}
 }
 
@@ -245,15 +326,27 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 	struct ufs_hba_variant_ops *vops;
 	struct device *dev = &pdev->dev;
+	struct cdns_ufs_host *host;
+	struct ufs_hba *hba;
 
 	of_id = of_match_node(cdns_ufs_of_match, dev->of_node);
 	vops = (struct ufs_hba_variant_ops *)of_id->data;
 
 	/* Perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, vops);
-	if (err)
+	if (err) {
 		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
-
+		goto out;
+	}
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host) {
+		err = -ENOMEM;
+		dev_err(dev, "%s: no memory for cdns host\n", __func__);
+		goto out;
+	}
+	hba =  platform_get_drvdata(pdev);
+	ufshcd_set_variant(hba, host);
+out:
 	return err;
 }
 
-- 
2.7.4

