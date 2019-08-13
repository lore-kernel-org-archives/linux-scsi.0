Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9F9C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20684206C1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="Ttvq6B75";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="mkWntboT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfHMHnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:43:45 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:58158 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726489AbfHMHnp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 03:43:45 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7D7bGLs029977;
        Tue, 13 Aug 2019 00:43:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=3gPzBNxlmaU1Gg3uNHgZi3NTdISovTOMND2EkpF5yiQ=;
 b=Ttvq6B75pel0fSfYP9sf5wwOAhrdldqWLm2OjHybp4qzSNT/vD6ij80whbtNXvlopaKv
 YLlzJ3j2j4iCGWfyhrMzDB4qE9XqbYLTCh6WSReYlJVAxE7M0jq23/sK/x9JWPOo0cyw
 q7lDgQJ0pdXxXCN19RNABMMKsg4Zn5sx7m7LRrGgfYAHwNxvZLw1lagh/bTtwpgbgWsV
 t2qA7CZrO0CsuTAyNe1bPL5GD4FBA8s7EAlDWyNuoG1AAwIiNlF7joZxqSliBu4dGo45
 4W1C8Brl9NHzZUOda/EOdFYKZI7l0K5VF19FudkUBMN1KQ2c1BwrshHOsTW984KUqWR/ Yw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=aniljoy@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2056.outbound.protection.outlook.com [104.47.42.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2u9tfs94xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 00:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyaXYO0zghu2gq78s7HBX2GiSny9oE50ClW/vvErVebq+qbyaXN7EYJ7OI54uEM7QPdMCQJkpjtw3eEzZC5wOLDCjR2K95zs6zxPOdq+PXmGBrus+NszbZzgITrGyq1IO1UjnduiNqpHIClAAT6Tm5SEwcpi9kuz8git1CbHQQmLAYpLRe8rf7sBeyc1kDJ1Exk7QRCHywHvi4bhY6Ab0ZmpEVHl5VrbiGWzjVeFSbm8dTjfKWAhbGBE/6NfkEDQfuS82NeGwKeQ2PsqFmLb7cAtsz4gB+g3bd4YUsfcbxRMuuQ4P49jPRgapsfzJQx9G7vTFG02UHM+iiKtkdV8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gPzBNxlmaU1Gg3uNHgZi3NTdISovTOMND2EkpF5yiQ=;
 b=gjrmpnI3CaKNdiF4zegPBFrGofaDDyPLazKicwrwV92yktDtJrwGXkgFjrvZ7bl3YDMD0+fI/4sxk4x7191yyzxDy+obkUKRmhQNiC/zxeekO6nuIPp+Q+unradSj/vLtJgeino+zBeDq5C5WOrIHJ7P2t2Pu0Gl5pJ2dDpas6ImMgPXHwFNCauB/6GxD0SeA/UI/OqwscjJncBhGEw9Y1alU8hI7G22kf4EnXtl2+rypPiO9p5fqD49Kb5gUI8I0lHBFfUnHE8ViJlo1q+RUuX+DCDbfEA+Um8cx8rNh7chZL7BwF1hGNTt0gctNskoU3AjTxzCnIeJZDabcbFPdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 199.43.4.28) smtp.rcpttodomain=synopsys.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gPzBNxlmaU1Gg3uNHgZi3NTdISovTOMND2EkpF5yiQ=;
 b=mkWntboTC0JNlQfxwSL8MqmkhsEwZtC+f0DggDoiNzSs98ByrQ8mkfx0oRXjROTqBCRlXTuuFh+2EVYu2j45lI64e0E4VGdUfOUelGtRWmv3vCZAt3/Gr0aHSQeDVWedJNTSQRTZIi7MrCIeyWwPnrii2Gq12FbNEUhbubrtz6A=
Received: from DM5PR07CA0044.namprd07.prod.outlook.com (2603:10b6:3:16::30) by
 DM6PR07MB4348.namprd07.prod.outlook.com (2603:10b6:5:c1::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Tue, 13 Aug 2019 07:43:22 +0000
Received: from CO1NAM05FT058.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::204) by DM5PR07CA0044.outlook.office365.com
 (2603:10b6:3:16::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Tue, 13 Aug 2019 07:43:21 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT058.mail.protection.outlook.com (10.152.96.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2178.6 via Frontend Transport; Tue, 13 Aug 2019 07:43:21 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x7D7hG9c030480
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 13 Aug 2019 03:43:18 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 13 Aug 2019 09:42:13 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 13 Aug 2019 09:42:13 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x7D7hFew028822;
        Tue, 13 Aug 2019 08:43:15 +0100
Received: (from aniljoy@localhost)
        by lvlogina.cadence.com (8.14.4/8.14.4/Submit) id x7D7hAxo028730;
        Tue, 13 Aug 2019 08:43:10 +0100
From:   Anil Varughese <aniljoy@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <hare@suse.de>,
        <aniljoy@cadence.com>, <rafalc@cadence.com>, <mparab@cadence.com>,
        <jank@cadence.com>, <vigneshr@ti.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] scsi: ufs: Disable local LCC in .link_startup_notify() in Cadence UFS
Date:   Tue, 13 Aug 2019 08:42:50 +0100
Message-ID: <20190813074250.28177-1-aniljoy@cadence.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(376002)(136003)(2980300002)(36092001)(189003)(199004)(70206006)(476003)(70586007)(2616005)(186003)(426003)(47776003)(126002)(48376002)(336012)(2906002)(26005)(54906003)(486006)(50466002)(76130400001)(51416003)(1076003)(86362001)(26826003)(14444005)(16586007)(8676002)(81166006)(81156014)(42186006)(4326008)(305945005)(316002)(110136005)(53936002)(50226002)(478600001)(8936002)(87636003)(356004)(6666004)(36756003)(2201001)(5660300002)(142923001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB4348;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bbe1237-c500-4cee-d513-08d71fc1ea56
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR07MB4348;
X-MS-TrafficTypeDiagnostic: DM6PR07MB4348:
X-Microsoft-Antispam-PRVS: <DM6PR07MB434874AFF3C8ABEE325CB1E5A8D20@DM6PR07MB4348.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 01283822F8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 2g+YsreDelWvDzEupcsM+0UVL7dUryAdTzD9KlOGPuiTsKfadoeY5Pu57y9fkMtdm1uAjvGngIokhWZ+9Y16MhNrxjkeyXPYmbff1mPqGh1Y+Fyrqxg18jg2G0YwbH+aK+dkUduvccFjOgIzlwKBBMQIECuor7CpSbi1XGYgSVWGDY9i55xPjGOtjRI0IBwsyRkHvA9xEowZ4G7clKFJN2KIXr9XUtcaOkxgUTafSnq5P4cUqnHNGi/zGVESEYivde02+U1tS18k1lKygZOSZz/6N5PTA8v6+XXTTouP7+uooYCSlbi7mfSu54JrgBggZRAVVl0zBoFZEb97JLMfDLMRYccZpDaydd5STTOkFDpY2yD0ovtVz9ZkLMqtRNQ1qjZMz5hPERe65MG/Ws4rbLlx6Wd06Ub7X2WdbrFEKI8=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2019 07:43:21.2599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bbe1237-c500-4cee-d513-08d71fc1ea56
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB4348
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=874 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130083
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some UFS devices have issues if LCC is enabled. So we
are setting PA_LOCAL_TX_LCC_Enable to 0 before link
startup which will make sure that both host and device
TX LCC are disabled once link startup is completed.

Signed-off-by: Anil Varughese <aniljoy@cadence.com>
---
 drivers/scsi/ufs/cdns-pltfrm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
index 993519080..b2af04c57 100644
--- a/drivers/scsi/ufs/cdns-pltfrm.c
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -77,6 +77,31 @@ static int cdns_ufs_hce_enable_notify(struct ufs_hba *hba,
 	return cdns_ufs_set_hclkdiv(hba);
 }
 
+/**
+ * Called before and after Link startup is carried out.
+ * @hba: host controller instance
+ * @status: notify stage (pre, post change)
+ *
+ * Return zero for success and non-zero for failure
+ */
+static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
+					enum ufs_notify_change_status status)
+{
+	if (status != PRE_CHANGE)
+		return 0;
+
+	/*
+	 * Some UFS devices have issues if LCC is enabled.
+	 * So we are setting PA_Local_TX_LCC_Enable to 0
+	 * before link startup which will make sure that both host
+	 * and device TX LCC are disabled once link startup is
+	 * completed.
+	 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
+
+	return 0;
+}
+
 /**
  * cdns_ufs_init - performs additional ufs initialization
  * @hba: host controller instance
@@ -114,12 +139,14 @@ static int cdns_ufs_m31_16nm_phy_initialization(struct ufs_hba *hba)
 static const struct ufs_hba_variant_ops cdns_ufs_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
 	.hce_enable_notify = cdns_ufs_hce_enable_notify,
+	.link_startup_notify = cdns_ufs_link_startup_notify,
 };
 
 static const struct ufs_hba_variant_ops cdns_ufs_m31_16nm_pltfm_hba_vops = {
 	.name = "cdns-ufs-pltfm",
 	.init = cdns_ufs_init,
 	.hce_enable_notify = cdns_ufs_hce_enable_notify,
+	.link_startup_notify = cdns_ufs_link_startup_notify,
 	.phy_initialization = cdns_ufs_m31_16nm_phy_initialization,
 };
 
-- 
2.15.0

