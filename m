Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244CDC432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 10:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E54072073B
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 10:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="NxSgFEvp";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="qaQTVPpf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfLCKJj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:09:39 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:49308 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbfLCKJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 05:09:39 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3A2coa011638;
        Tue, 3 Dec 2019 02:09:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=50YHPMnClc61y8E3qh+3v63XznlfGECyAICWaX5OsL8=;
 b=NxSgFEvpFkQE0pfwi0S2zOsQ7Kp5OywBjdntmVMR5LSNs9+UxlY8IORLUw5gxDjGVXe+
 puse0yjeZzhyULeYjEhUz1YuHBwZrpLTBOfWLr0kaqc6DaM8r/LVTsjnrfU2YogXSajT
 OyILl8wGJN8MZPIR2AWbBngGHCFcaTcD3Us0aKFcUZXSqqtUovv8o0UUzI5ALYKiTWKx
 Qqu2blFJkV+gQF8FthNOQW7OGfnW1IGKd8z4bCE6X4I8PiSN7lcw3dWnFHpNO1HRQn+Y
 9t2lF09AeCZ3cwXe3a9hFPntde6gZSyuA0yxvDBsZPwiI8k4nzQQxJG6lZWdfqXMFsTO yg== 
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2056.outbound.protection.outlook.com [104.47.48.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wknv0ujrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 02:09:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIujyRhxPgc1CNnZrBXvp2VTyzG1c3qdeovOU/FaO/VWwUmxXJJPnFjL7hYCi6WRuLhzz62rnaPULgRE5nDnrIpAQpx0V0yxqz7VPvlN2fl4eiTd+72cfX8S48YIIgQ+Xi8OLwCauhMejPA3sEbCWd9xbzZJpFXl0kbav4QhxQfyBaWhH5E9yWLw9cx2Ef1AOq23AY8Bafqc81pYeAlHxCDwcqWww5wYChhflDAzXSrIRspOid8+XtZHuv5v0FEA40w8EI2ExR0B05AC4+Wk9ls39c0Y60ui5WG3iN9+pTVa/jEhBA2WfBVSYc4O2oDJkv2tgFCBFe5R8inGNkSoJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50YHPMnClc61y8E3qh+3v63XznlfGECyAICWaX5OsL8=;
 b=Eyo/pnO89MdLrRwEUfe2DYMyHu2KbfBaqXG+pUnSp3E8gFI/NKVrCpWlTggFJEZLgznjLHV6lmlcqFD9Zt5wHUT8vMJEDcIRiaLPaG0fwlppnm/B1GoXEb/2nW5DeWUdBUVQzFw0zxtN0yFYHsnPL7HnNNll14Rcn7qRYJjqDJV0XSKpwI28UBuJ4Kp6YyZRGS/HGajg0ifnS3GktLjs/cH4yHqYcnAJ7Ks633B1W/roAwWoUeO4OlTz/+lwYIyHxKsx+gziPtr7NETmT5ndkFmm0V0oi3WX2RVcLHPAELmBvNeNNFAvsxrX6f1CZeTydgUvyWXCAU+/RZpkd/8SMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50YHPMnClc61y8E3qh+3v63XznlfGECyAICWaX5OsL8=;
 b=qaQTVPpfmFranOx4hY9tQmxpRhh/71Hxb9qLtV6TT89Jo77AxgHTwbD/MQqX/799TSfvbHnMqoaC3JLI55b+CQHiKVbjLKwwVclXEvbIHHh29TnszCpjlmN8/xxWoWMr2ZI/nQsBZA2TlQrUbrdgpFY/LNotavrdrxSvNBLJMnM=
Received: from CY1PR07CA0018.namprd07.prod.outlook.com
 (2a01:111:e400:c60a::28) by BY5PR07MB6754.namprd07.prod.outlook.com
 (2603:10b6:a03:195::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.19; Tue, 3 Dec
 2019 10:09:07 +0000
Received: from MW2NAM12FT019.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::203) by CY1PR07CA0018.outlook.office365.com
 (2a01:111:e400:c60a::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.19 via Frontend
 Transport; Tue, 3 Dec 2019 10:09:06 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 MW2NAM12FT019.mail.protection.outlook.com (10.13.180.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Tue, 3 Dec 2019 10:09:06 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xB3A92Au016941
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Dec 2019 02:09:03 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 3 Dec 2019 11:09:01 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 3 Dec 2019 11:09:01 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xB3A91h2024901;
        Tue, 3 Dec 2019 11:09:01 +0100
Received: (from sheebab@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xB3A8vUW024826;
        Tue, 3 Dec 2019 11:08:57 +0100
From:   sheebab <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>
CC:     <mparab@cadence.com>, <rafalc@cadence.com>,
        sheebab <sheebab@cadence.com>
Subject: [PATCH] scsi: ufs: Disable autohibern8 feature in Cadence UFS
Date:   Tue, 3 Dec 2019 11:07:15 +0100
Message-ID: <1575367635-22662-1-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(376002)(36092001)(189003)(199004)(2616005)(2906002)(426003)(51416003)(356004)(6666004)(4744005)(36756003)(16586007)(316002)(336012)(186003)(26005)(54906003)(110136005)(8936002)(2201001)(8676002)(76130400001)(70586007)(42186006)(86362001)(246002)(50226002)(4326008)(107886003)(5660300002)(7636002)(305945005)(478600001)(87636003)(70206006)(26826003)(50466002)(48376002)(7416002)(921003)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6754;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba5795fa-6b1a-438d-03af-08d777d8d4bd
X-MS-TrafficTypeDiagnostic: BY5PR07MB6754:
X-Microsoft-Antispam-PRVS: <BY5PR07MB67543CD08BCABE862B997801A4420@BY5PR07MB6754.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 02408926C4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K07IJPSn8a7kXgxz6racdf4gEl58V7gh+GZrCDW0BbH31tLX6HLlug1JjitZe5zcupDvKtKS2c32/aMn/8qSXD5H7j6iQmohjiriaH21ZUwLR2JgExOM6qh+hBtfrFq1qMZUevM8WwivhWOLX29g2kv3dPMZ9LC4DARiKhq0Rxra6mrEdzP/j2QtEZGz32RVw+yjLmuFsc7rfkV8ET6NWYwq/zYF6lcOfPFWvezmUtaZS82nX9F1JTIQGUuStUaUTQK2o88ER3nipxIGX6znBrdJe7kZlgpZ6bivk/S6gLhziiAhsjFRjeJ8mj2rO6S/F6eUEBH5pMj4MMOwjgY/lnES1jOrOoB61YCeu+Ai1uO7/8bNXaGNKTRLr03vVJ0+lCcVcTG6/YYQwq6dhQX2O1wIU93Qp+q9gfD5hO4trzPWoIwaBTbXrPkq1OzO7e8+
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 10:09:06.1442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5795fa-6b1a-438d-03af-08d777d8d4bd
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6754
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_02:2019-11-29,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 spamscore=0 suspectscore=0 clxscore=1015 mlxlogscore=853 phishscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912030081
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch disables autohibern8 feature in Cadence UFS. 
The autohibern8 feature has issues due to which unexpected interrupt
trigger is happening. After the interrupt issue is sorted out autohibern8
feature will be re-enabled

Signed-off-by: sheebab <sheebab@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index b2af04c57a39..882425d1166b 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -98,6 +98,12 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
 	 * completed.
 	 */
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
+
+	/*
+	 * Disabling Autohibern8 feature in cadence UFS
+	 * to mask unexpected interrupt trigger.
+	 */
+	hba->ahit = 0;
 
 	return 0;
 }
-- 
2.17.1

