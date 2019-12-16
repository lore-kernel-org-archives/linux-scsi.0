Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE5CC43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 11:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67F4120700
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 11:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="LIXqOvG+";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="jVAsz9tq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLPLYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 06:24:00 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:51642 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727191AbfLPLYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 06:24:00 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGAISux013109;
        Mon, 16 Dec 2019 02:18:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=Fkye3Keb05tY50lbX0TCaB/Ibg2TKomNtPacAHLAHD8=;
 b=LIXqOvG+oNCTzQcJ7rAOvwhqCNlxQHljuq15l1kzc9iMJ3JjBo2IuxtbSksbhYnzbWvA
 MRH9bGT+4lSND0D/7vVT7GfDRSPNFFG8JsofTxOwpLuJ91vVwaYYENe2aAE3TfqThmpN
 mK//zSrndkhGlWdGFUTAGsUkvdxsc88mSF/pOknvrG5FdSMWRBq0qiFvUz6DfYjYKaLj
 CMhDRJeY8SjV3CA5/idYtZOchjtkX8eYFVeCQncG0foGp9aprOwcpMWv+gI9SvAFVIwX
 lm4HQbhsnKBPMlE/4WlZRyVVvyopHEuzUNtybw+gHI0gKxaisDmmG23DkovAk92vDFDS tw== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wvw645acb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 02:18:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAbV5Krp52/wK0wliG9DaLopH7xUM2TLjyzc2BujsUMtytDua1ZV077Hyl+6PA3rxg6q0FwCIVe9z8YuL/488Sy0DT8vlLqix1XEL3VLmU2j7yXNE+7NUZt5lvGKCkMrQ+egbFV+1VWg5gpTkzCy7sJ4uxyI8L5u3+shJM9Cro169wFGRnskvnNESKpqQ9vYRyco9TMaiDHzS/qLrzjX1FAwDfzacFrgWpuaLnYvG4iOWdq5gklPWArQGIZFDHF4ZhXyCvJoegjHKOE5AzhadWD9ZeDzKL4+omkKaM6lDRmITN4auDH56cwC3DOTghsIe/KIlTuBnVJw7OuE2bA1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fkye3Keb05tY50lbX0TCaB/Ibg2TKomNtPacAHLAHD8=;
 b=JynqZBaylsUrEgbJlDT1ZbBatjv+50XbFLtpXA30eXpBgvslNeLlzWNVD58ye+UwY+hoVgE7t7GAoe8LgGDFVySwig3LH58oqYzgRns1fFKG2mgL/mzFWIcDhpySt7GPExrUk1/1W3savUs/OVk0DwhumS4h1PRG2rg7nFhcgZfncfLBPIULcEZpPm4RCRpa/owSB5k0jlsSOZOU7LkfdraFXs9D4mTXnhWAvUoOBC1DAXwI/JsoNpgX7z+Rr0wIQXsFRv0jvndhFMV2f1MkHSSLykdCIpvllQjwP3e9PWcbnwwOfy8981y7iZE8awVN6UBZC8jmIBZjTZ2W1DCj0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.28) smtp.rcpttodomain=oracle.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fkye3Keb05tY50lbX0TCaB/Ibg2TKomNtPacAHLAHD8=;
 b=jVAsz9tqGAalY7ar5Pe9ct8Ky4rD3aKKONfHGlpEZsi2OmC9u6vroIbZtOLjtI5tVsQsvDQObmqf2oOzSsvUVKICp1AFhwbqo0TdWws1fmN5DKR1fhVEHesSuCkcj0kjnSLZSUhe8EpHpqX1hdB/VBDWrVhvTTWLrc8w7Z34zHU=
Received: from DM5PR07CA0053.namprd07.prod.outlook.com (2603:10b6:4:ad::18) by
 MN2PR07MB7134.namprd07.prod.outlook.com (2603:10b6:208:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.16; Mon, 16 Dec
 2019 10:18:18 +0000
Received: from BN8NAM12FT058.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::200) by DM5PR07CA0053.outlook.office365.com
 (2603:10b6:4:ad::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.16 via Frontend
 Transport; Mon, 16 Dec 2019 10:18:18 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.28; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BN8NAM12FT058.mail.protection.outlook.com (10.13.182.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16 via Frontend Transport; Mon, 16 Dec 2019 10:18:17 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xBGAIDhF019171
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 16 Dec 2019 05:18:15 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 16 Dec 2019 11:18:12 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 16 Dec 2019 11:18:12 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xBGAICjV000926;
        Mon, 16 Dec 2019 11:18:12 +0100
Received: (from sheebab@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xBGAI9ch000906;
        Mon, 16 Dec 2019 11:18:09 +0100
From:   Sheeba B <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <stanley.chu@mediatek.com>, <beanhuo@micron.com>,
        <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <vigneshr@ti.com>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>,
        Sheeba B <sheebab@cadence.com>
Subject: [PATCH] scsi: ufs: Power off hook for Cadence UFS driver
Date:   Mon, 16 Dec 2019 11:17:12 +0100
Message-ID: <1576491432-631-1-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(346002)(36092001)(189003)(199004)(336012)(42186006)(2616005)(8676002)(110136005)(107886003)(54906003)(478600001)(86362001)(81156014)(70586007)(4326008)(7416002)(36756003)(26005)(2906002)(426003)(356004)(6666004)(76130400001)(4744005)(5660300002)(186003)(70206006)(316002)(8936002)(26826003)(81166006)(921003)(2101003)(1121003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB7134;H:rmmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cb486c2-2f80-4c83-be11-08d7821144f9
X-MS-TrafficTypeDiagnostic: MN2PR07MB7134:
X-Microsoft-Antispam-PRVS: <MN2PR07MB713452409C62F191F04AE6D3A4510@MN2PR07MB7134.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-Forefront-PRVS: 02530BD3AA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPx/KQQYu9Ge3pqaYuq3kqtiguam2F+XTESo95GPYK7JU/LG9GzcpGuQuph6I+5noqzu4cHH1G9BW+Xl3AOh0TGfcDh5kD9VcRwTcTm5f1zSvEfoFdo8fuY+Zbxw/SrTupypw/J6rm2lcv9EktrNXhS690qqU3IxLYWU5aeikPbDN7Y5tRfZAFe+tz6nvyPKm/RwccyG+icYNiXOaGpLtuRIYXZEzk2v+ARlgRe3wVtgI0mj8kzwO2vZ4N1cw7z0SQu7jgJiQi4N/Lh+WdcwMhkB/aI9QgMVUcyKwqKD4sRfCCsDKJb+Qz4bXjesHVoo+dKQ+LzwZU82rib6rp0Rc2aBnhTpvBA/uLaOMaO1u07Vanm1iqi3w8ZS2je+Loshfkb3HlrUPa8nL1Orr1gUrzAaNy/5YYsajcRL9hBc2QkSnH3dpT9RK2vz/nHtIGbLxE1oFRgZlpdZw3wIYHIW2OvdKIGdntmrxKz+ZjT5aJMUJetZfTisRoeTkW3/5AzST8WLzr/5eXXq7nwwt8mfzk2AoxVrxQrektgrxVPveVNBvPXBZrNBfmZZDgLbudqT7xAH8mKTLqWxnPNrZBUjfg==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2019 10:18:17.9217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb486c2-2f80-4c83-be11-08d7821144f9
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB7134
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_02:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 bulkscore=0 mlxlogscore=797 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912160092
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Attach Power off hook on Cadence UFS driver

Signed-off-by: Sheeba B <sheebab@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index 1c80f9633da6..56a6a1ed5ec2 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -325,6 +325,7 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
 static struct platform_driver cdns_ufs_pltfrm_driver = {
 	.probe	= cdns_ufs_pltfrm_probe,
 	.remove	= cdns_ufs_pltfrm_remove,
+	.shutdown = ufshcd_pltfrm_shutdown,
 	.driver	= {
 		.name   = "cdns-ufshcd",
 		.pm     = &cdns_ufs_dev_pm_ops,
-- 
2.17.1

