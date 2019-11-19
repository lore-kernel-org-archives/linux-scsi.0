Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F433C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BAFD2230D
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:05:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="NWSRVy2G";
	dkim=pass (1024-bit key) header.d=cadence.com header.i=@cadence.com header.b="uMak6FbU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSHFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 02:05:45 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:13734 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbfKSHFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 02:05:45 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ724f6030539;
        Mon, 18 Nov 2019 23:05:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=803thjegLTotHqNYFRW3V1bqkE9iCLy2jpG2DZKC1pY=;
 b=NWSRVy2G3lXbzEBm65WtEjl4g0zmQpvInNLSFWuE4vP9zdff/JhRTSl/U0QxLTbNnvDx
 SjET+QsAYp04wJTs9AY5/qV1yHUd0j57bVIDLdX3QfO0+IkZrPogfWTzY3v3GAYf4CV9
 lNN0ynnrktvFlkZ5fYE1K93XUdRPJ0RqvXGlAEG46SkCf6/zmhqaMQhxI1eXVSl6cDUc
 mXxY17B6UpyRMZiqD6wAP/X4IzTJ+uZBrKYj2vQQlhgy6wEnDUAztuccRGRRcvi0xgwh
 MDNqSlqXdQfBSeto88t0BKumXv7NL68xJRJfhJXuv8qxlI7ZsQVYeJt/0qkG9O1zgxeg IQ== 
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2059.outbound.protection.outlook.com [104.47.32.59])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2waehy9caf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Nov 2019 23:05:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHvgX6m9SH1zP7Mh7CWiMQee4+Uk5qkwFTvHCsIsWlWhtQcfjwdEyJP4nT9lCi5oT9yyEi6w3V0xfbsofChAmHc0SAuNJmNBs/xhwjjskng+2iOnnTM2l2hZqxyFvg1y7Rr5Ens48VJKc6bhJmdB4QA8FK8h6sL/WchM4oUDit/mPyN3QqMXyFSxU6oiK98Bh9S17YLmiAYj0fC8+WfkJGhAj9LBsYRM6S9PMq3/8VUwZaoFJwZXXnG3pC4PVAgxd9OZAG468ITTon5Oh7foUWwJUn3x7gsjhODBU6CzHusdSt9QManCRXTUfLenusmZBgmzeGn4ecxz9qHgXgYBMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=803thjegLTotHqNYFRW3V1bqkE9iCLy2jpG2DZKC1pY=;
 b=J15jqAaWF9IM2HdDqSADpcGGO2YjRsVPXCbAWIa4C64UbzZPc4j8KAPLu8VE0B3sJ5Ox2f5GAovTnMU2vzwCyarFw+EwKsuv2CKwUdAf9S6VIezMG3V+iVfIxIlQLdM5zKeHs5HYvzEM6SZeB2oOHE19X7aJkXtT5+ioeanvaNrj4QRGy6N7mkfwe3AFXEXYXNoU93o20Kdy2joNJynUMirDDUjXLLlUCqM9mJvCLkiUvV6iu0Pzh6P4aOdsO3KrI8y2nZysDIPMJDxMMx0jwsWcd6Z0T2ARb0LGTAV0nbO1c+2vyNnHsVMlPtAUjz0L58HxyROdi4VaRMkuUSel2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 199.43.4.28) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=803thjegLTotHqNYFRW3V1bqkE9iCLy2jpG2DZKC1pY=;
 b=uMak6FbUU95rTB5iAqd02FGizd7WDZXmFfHh6HseaF1ve1v5gPiQ0yWuopfV93jj7DQJRDTZ3tgZPdOQ4GchuEtydHYsR6s+u8DHTCnMjV33i+4PfaBVOYaRoxvoXxJUpGlo5+/iYrAFK4NPiuphR7H5bj333AZ0LEAYqRjfSSQ=
Received: from SN4PR0701CA0005.namprd07.prod.outlook.com
 (2603:10b6:803:28::15) by SN6PR07MB5741.namprd07.prod.outlook.com
 (2603:10b6:805:f0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23; Tue, 19 Nov
 2019 07:05:18 +0000
Received: from MW2NAM12FT054.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::204) by SN4PR0701CA0005.outlook.office365.com
 (2603:10b6:803:28::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 19 Nov 2019 07:05:18 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 MW2NAM12FT054.mail.protection.outlook.com (10.13.180.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2451.23 via Frontend Transport; Tue, 19 Nov 2019 07:05:16 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xAJ75AQs006987
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 19 Nov 2019 02:05:11 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 19 Nov 2019 08:05:09 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 19 Nov 2019 08:05:09 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xAJ7590c024037;
        Tue, 19 Nov 2019 08:05:09 +0100
Received: (from sheebab@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xAJ756IL023794;
        Tue, 19 Nov 2019 08:05:06 +0100
From:   sheebab <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>, <linux-block@vger.kernel.org>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>,
        sheebab <sheebab@cadence.com>
Subject: [PATCH RESEND 0/2] scsi: ufs: hibern8 fixes
Date:   Tue, 19 Nov 2019 08:04:40 +0100
Message-ID: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(36092001)(50466002)(110136005)(316002)(186003)(26005)(14444005)(47776003)(87636003)(70206006)(336012)(7416002)(356004)(6666004)(5660300002)(4326008)(51416003)(26826003)(107886003)(81156014)(81166006)(16586007)(42186006)(8936002)(8676002)(86362001)(48376002)(478600001)(305945005)(2201001)(2906002)(76130400001)(50226002)(54906003)(126002)(486006)(36756003)(426003)(476003)(70586007)(2616005)(921003)(1121003)(2101003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR07MB5741;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:ErrorRetry;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c62d2af-6fa2-48e9-ba23-08d76cbed49b
X-MS-TrafficTypeDiagnostic: SN6PR07MB5741:
X-Microsoft-Antispam-PRVS: <SN6PR07MB57413BB5C56CE84FB0E5FE62A44C0@SN6PR07MB5741.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 022649CC2C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yB+ZZlC63QT8OP/trtmDbUJBGAi0jOAyzDUbqZnGeo1sSmL5kytdsZm0kAWmOxz8yXPpEhGmrYo3XFyzvv4FfjPKnlsGVVyAanWMrr3/+hjfb48wJrwEjhFUpi78+zLUtPiPXpAPu3y776/rkv/Z49+UQGn4K62S+BOPxaDmvlHuD17GDzIlfNZSmD6T6GqmIzKVp887XnSkPVx+kuul/vM1iHuIYiz1GOZT+7XQgsmIKOISkXfcTQe/+9K5OfT3zKxd+4AduMw9QCGJwsBSz0yc3TnKO60ZI54CiPi1HvD4RJFPx6HYSefjWzF06mhLXlFAMAEF72SFxjnbgstNr4RkBXr10AgroKBqUPXQV4y5e9fVpn6J4TtLqzSwUMYBTBnGYr2pL0ZjZDDVuoaCgpQjcXZ9SO/T6LUO98/DXIrx5CHQiwFfzUYbldc2z5h1
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2019 07:05:16.1215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c62d2af-6fa2-48e9-ba23-08d76cbed49b
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB5741
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_01:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 mlxlogscore=892 spamscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190065
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Resending this patch to include mailing list and miss out patches.

This patch set contains following patches
for Cadence UFS controller driver.

1. 0001-scsi-ufs-Enable-hibern8-interrupt-only-during-manual.patch
   This patch is to fix false interrupt assertion during auto hibernation.
   In this patch, hibern8 interrupt is Disabled during initialization
   and later the interrupt is Enabled/Disabled during manual hibern8
   Entry/Exit.
2. 0002-scsi-ufs-Update-L4-attributes-on-manual-hibern8-exit.patch
   This patch is to update L4 attributes during manual hibern8 exit.
   As per JESD220C spec, L4 attributes will be reset to their reset value 
   during DME_HIBERNATION_EXIT. This patch will take backup of the L4 
   parameters before DME_HIBERNATION_ENTER and restores the L4 parameters
   after DME_HIBERNATION_EXIT
   

Thanks,
Sheeba B

sheebab (2):
  scsi: ufs: Enable hibern8 interrupt only during manual hibern8 in
    Cadence UFS.
  scsi: ufs: Update L4 attributes on manual hibern8 exit in Cadence UFS.

 drivers/scsi/ufs/cdns-pltfrm.c | 172 +++++++++++++++++++++++++++++++++--
 1 file changed, 167 insertions(+), 5 deletions(-)

-- 
2.7.4

