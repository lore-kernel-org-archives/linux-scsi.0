Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4DAC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D7262230E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="ZvWm/ZYV";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="v6OSWQ0q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfKSHF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 02:05:57 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:33670 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbfKSHF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 02:05:56 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ73hYm009047;
        Mon, 18 Nov 2019 23:05:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=BioGC8WlbvjXfEn5+C4X1gnBsnmzivwz8LyXyh7PC4w=;
 b=ZvWm/ZYVvo4eoZuGwVSYfTHS9uW52lyVhV3tKrNxFv5KOKcmHf0ZT8vIMFZQAVK2DwvU
 cN0yGo+6Kw89kTrZBAjzaUkxN85OP+1yeO1w3CTTYjAlzlLt/b5TNist4GiHUTXDe248
 WgjQCMXZ9p1OcqdLXfEb8N/9uoVpXvC04/vaqXRq/33IGPJ7eLo/xy8sHe9mnRc65cfZ
 yAOJb0pz2E73vwKtvoBehMxvpiFul4uMFlIQ6W+BeT8VITOgNbuXdLB7jaEprVLU29g3
 U5t4ykf2cGDrNbx5mTfqQiqPXBreWa9RL8qtRy0d+2/Lmj9uuYKUnfHpeG6BFu6egyi+ kg== 
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2058.outbound.protection.outlook.com [104.47.33.58])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wadjy9hhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Nov 2019 23:05:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bp7vbCqC8NlNoDNE0ECVaAj7aglPF0TZDk1wTnvB43f8NsKPRCheEL1+mBMHqgt+aiib29JBv40kLK5tzb+cNU3F5H9JiSqw1zE5GiCsWCzNpytm/FAAXzfCkrSFq5iYbI7TLb1EVcDueoTiQEJcyRHTn4a+LL6f0XUbRLs0R4M0DBF5a2LvlFhK9xl26qCmk2qyOczbw9vzaiUaecS8fKcGUs9kZpDfEJkyk6EuPOyeLHbHce5g7qz6NBPTcHCO6vwCjUN+jFNXUqMB01Zcg0okB5rY3QNpiZuKFHIJRMb7FYj84jM8hiED5gpBuynfFWnF9DuAFnR6/8h7vpzFYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BioGC8WlbvjXfEn5+C4X1gnBsnmzivwz8LyXyh7PC4w=;
 b=kTDm7b042YtbBa3sMS30h4U1SD+x7cqywAFjsc1kEb4SwvBS1/oZjnWlCIUu834yQk3KXpL6LWyg4HHvJCUQxFJ7QYSe2vWn4t963P/6FFJQ72K/EO4v8ZgFeaEmstZTW5MjJm/88dt1pijLHSdQOVQTVo3bq6Sh5kYYKbK17G0DZU2aM66oJS+p3vHRe65pgNvpXxSfG1Rw3ueMJTmV0Ej04aktwp8RoEX7DTwPNLzQftK0xa++JYL8QZoveWW+tX1V2Bc+4xpWauahwEbxCGdsM5PN1+Cs6sYVAgdVb6vjDpP9EM2Hy4KGJ1vygz3iuoc1N8CsLR9e/IC/L25Vtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BioGC8WlbvjXfEn5+C4X1gnBsnmzivwz8LyXyh7PC4w=;
 b=v6OSWQ0qF82G015zjUcxSIPacuj/ZmqN1xKUePmA4w5WDIJYcERDhfLwaAihJlJEb+r38VelD/L8ILHQciXO9DTTNT7y1G3hgsHoUd5IOZIbsdtWDdtdFByJgrFlauR+LuIetX3AMXBs2ws2gG3jscgKtK6kJLWrmHOdTx79YLM=
Received: from DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) by
 BY5PR07MB6484.namprd07.prod.outlook.com (2603:10b6:a03:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.28; Tue, 19 Nov
 2019 07:05:20 +0000
Received: from BN8NAM12FT039.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::204) by DM6PR07CA0065.outlook.office365.com
 (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 19 Nov 2019 07:05:20 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 BN8NAM12FT039.mail.protection.outlook.com (10.13.182.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2451.23 via Frontend Transport; Tue, 19 Nov 2019 07:05:19 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xAJ75GgU029207
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 18 Nov 2019 23:05:17 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 19 Nov 2019 08:05:16 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 08:05:15 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xAJ75F9D024379;
        Tue, 19 Nov 2019 08:05:15 +0100
Received: (from sheebab@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xAJ75F4J024377;
        Tue, 19 Nov 2019 08:05:15 +0100
From:   sheebab <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>, <linux-block@vger.kernel.org>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>,
        sheebab <sheebab@cadence.com>
Subject: [PATCH RESEND 1/2] scsi: ufs: Enable hibern8 interrupt only during manual hibern8 in Cadence UFS.
Date:   Tue, 19 Nov 2019 08:04:41 +0100
Message-ID: <1574147082-22725-2-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.4.5
In-Reply-To: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(396003)(199004)(189003)(36092001)(50466002)(47776003)(76130400001)(51416003)(356004)(6666004)(86362001)(2906002)(48376002)(26826003)(5660300002)(87636003)(4326008)(2201001)(36756003)(7416002)(478600001)(70206006)(7636002)(14444005)(110136005)(107886003)(486006)(426003)(305945005)(11346002)(16586007)(446003)(2616005)(246002)(476003)(26005)(336012)(42186006)(8936002)(316002)(50226002)(126002)(8676002)(54906003)(186003)(70586007)(76176011)(921003)(2101003)(83996005)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6484;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fae8e84-c7e4-4064-7762-08d76cbed6c1
X-MS-TrafficTypeDiagnostic: BY5PR07MB6484:
X-Microsoft-Antispam-PRVS: <BY5PR07MB6484727E7042B5A435978364A44C0@BY5PR07MB6484.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 022649CC2C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIBw3NKlbeUbm/sUONFziV0HdHRT2q4GRvq4dxk5ubp08s2DS28dL/HLhhz293u4Nw337zLp+qA+C7blznogM5QHiWWCrBzEjQviy9OWnTMfdbXHqv4FNVX8/33UUTb+UrWZ04aZ/8/jVy5r1jE24zEU/7DvHCqw2r3U8KxhXwvU0G2GFQ3ApONSU2pIZn1rkM35JgoXpnSabU8vkJiiUiPPpJP5KC9tJSbPZD4D7pftkUCFAjR3CHNMW+NE3Q7ejreEQxc5A10PaazjfiNXRsmsvtNxU4m2t0H767S9eNniZ9FOGZZCKivb8ZOE0e703JW2dqe0nYPExaRuPpWkVhJAIoJAqRLEhs9l6yHzRE4sNWuSaoBee+d6glUe6FcszZ864boFx2iK4NYFuBSvzUmLAwJCog8dxGFM1v+Je5A2p2pyY4BpRyUBRIKZ5otg
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2019 07:05:19.6932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fae8e84-c7e4-4064-7762-08d76cbed6c1
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6484
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

Auto hibern8 causes false interrupt assertion.
To overcome this, disable hibern8 interrupt during initialization
and Enable/Disable hibern8 interrupt during manual hibern8 Entry/Exit.

Signed-off-by: sheebab <sheebab@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 75 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index b2af04c..adbbd60 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -21,6 +21,32 @@
 #define CDNS_UFS_REG_PHY_XCFGD1	0x113C
 
 /**
+ * cdns_ufs_enable_intr - enable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void cdns_ufs_enable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	set = set | intrs;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+/**
+ * cdns_ufs_disable_intr - disable interrupts
+ * @hba: per adapter instance
+ * @intrs: interrupt bits
+ */
+static void cdns_ufs_disable_intr(struct ufs_hba *hba, u32 intrs)
+{
+	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
+
+	set = set & ~intrs;
+	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
+}
+
+/**
  * Sets HCLKDIV register value based on the core_clk
  * @hba: host controller instance
  *
@@ -71,10 +97,51 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
 				      enum ufs_notify_change_status status)
 {
-	if (status != PRE_CHANGE)
-		return 0;
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		err = cdns_ufs_set_hclkdiv(hba);
+		break;
+	case POST_CHANGE:
+		/**
+		 * Hibern8 interrupts(UHESE, UHXSE) disabled
+		 * during initialization.
+		 */
+		cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
+		break;
+	default:
+		dev_err(hba->dev, "%s: invalid status %d\n", __func__, status);
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
 
-	return cdns_ufs_set_hclkdiv(hba);
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
+	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER) {
+		/**
+		 * Hibern8 interrupts(UHESE, UHXSE) enabled
+		 * before manual hibernate entry.
+		 */
+		cdns_ufs_enable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
+	}
+	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT) {
+		/**
+		 * Hibern8 interrupts(UHESE, UHXSE) disabled
+		 * after manual hibern8 exit.
+		 */
+		cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
+	}
 }
 
 /**
@@ -140,6 +207,7 @@ static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
 	.hce_enable_notify = cdns_ufs_hce_enable_notify,
 	.link_startup_notify = cdns_ufs_link_startup_notify,
+	.hibern8_notify = cdns_ufs_hibern8_notify,
 };
 
 static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
@@ -148,6 +216,7 @@ static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
 	.hce_enable_notify = cdns_ufs_hce_enable_notify,
 	.link_startup_notify = cdns_ufs_link_startup_notify,
 	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
+	.hibern8_notify = cdns_ufs_hibern8_notify,
 };
 
 static const struct of_device_id cdns_ufs_of_match[] = {
-- 
2.7.4

