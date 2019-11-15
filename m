Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFC3C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 11:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77082072B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 11:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cadence.com header.i=@cadence.com header.b="gDIaJJXM";
	dkim=pass (1024-bit key) header.d=cadence.onmicrosoft.com header.i=@cadence.onmicrosoft.com header.b="C+SFIOAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKOLBr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 06:01:47 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:9478 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726983AbfKOLBq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 06:01:46 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFAwrw2029296;
        Fri, 15 Nov 2019 03:01:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=7VZK0rJdJUI5nEomTCEJDaDX4CTV8qq7hoUqJe2pcg8=;
 b=gDIaJJXMwk89RF7kNAp3LIeAynj8WUmqQ50BnxbFDa+DG5hf89qU0XdBIF0RMqYKKJWv
 iECq//F2o50ki4CuKwLqMQJJryC+Mgo+35pifRgnCuPkI5nsjh7zWayH6oQ6vhuZ66kL
 mBdRthMUs44+WY+XL194yxKoZMIsZ8KVVN0hdxum3GpybfIb8ovuxb2uY0KQcud1ThVZ
 Me8PFcmcKwsERVgf5dnDvnkEdFILmw1jPyszKlmZmCKJ6yp0G6k9lG0RtTspkaiEcxgZ
 l8qr2NK3AwbtzvC8S12BgtNR8mC2Ecdne96LlyCGCPTrETG+AGEYuPIJF29NSo1t59jS NA== 
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2056.outbound.protection.outlook.com [104.47.33.56])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2w7pryekgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Nov 2019 03:01:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpv7YlQKbTIFCL0yCOmW99OsyCxVF3PiCJONXuWWnpVO7x4cp7oRV5vu8YVlkSsI9Y/P5GJp99YQz1nu79F1smOyAj/vu8tZXi1huxF8uJxDWkbu7U46ikwlVpIbniSda5YXzQnxnQCihv6/REiyja7rHb0cydd3nbCSgpWz4f5U80H1GfhxkcsMwTUSgz2gVd7XOCLsQntGX9YgvFjyryBzzy5XqJKs6eY/kbEY50czTD42BXO8k8iIWWJsFI65ZvuX1Ur3PBO1Xl77DGYiVQgFWPNSHaM7WgpdWiH4we+cC7B4DZqeB3XC7HGck2D+CuguQlsFHkrBD1pmPWvjXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VZK0rJdJUI5nEomTCEJDaDX4CTV8qq7hoUqJe2pcg8=;
 b=U0Mp7g8GFyHAqZvrOIVsdN2X2KwLXxip6UnXNT3e3+WUnz5K1bSTZz8qmJ3A0cApcrtkdxl2KIRPdrll29vvPOk6aFdWuCf/O5UNKwzo30VcDd75Up7ys2goYLi1qHM0tw08zqA2n3cPVaYyyVE95Ba+Pugug0g3gTZ0LEjEsMZ9KTNwZSEgjVeIzKDVF+aY1mEbLlen8fz3h6K/VAx38g4brcZsj+huRTrsDKMbWysp/2bc3MT0BtDMUI/fgibZ0v7guBQi4+8496qvsRwdGhDibsalsebqUiGXxbxMZxKU0Ocx1AQ/6a9reJFvA6yWcq5fyYCjBxdKkofbrfoNmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 199.43.4.28) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=audio-dts.cadence.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cadence.onmicrosoft.com; s=selector2-cadence-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VZK0rJdJUI5nEomTCEJDaDX4CTV8qq7hoUqJe2pcg8=;
 b=C+SFIOAUn75iOAe5IeVM/U7sqNd1clMzL1hZEpkQg/XrugM6uEPxUIFNfqC/yl4XoxAfCodTdgUtGexzYsg0R/kQ+T8zIw+biSzpXfz7eftC2syp0HtoCLpdReOL/HFirOkBSXgt6AiSVL1ehy2eav+TcfOQDcSQf2sQeUuDc7Q=
Received: from DM6PR07CA0063.namprd07.prod.outlook.com (2603:10b6:5:74::40) by
 DM6PR07MB4188.namprd07.prod.outlook.com (2603:10b6:5:c3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Fri, 15 Nov 2019 11:01:43 +0000
Received: from MW2NAM12FT032.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::208) by DM6PR07CA0063.outlook.office365.com
 (2603:10b6:5:74::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2451.23 via Frontend
 Transport; Fri, 15 Nov 2019 11:01:43 +0000
Received-SPF: None (protection.outlook.com: audio-dts.cadence.com does not
 designate permitted sender hosts)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 MW2NAM12FT032.mail.protection.outlook.com (10.13.180.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2451.23 via Frontend Transport; Fri, 15 Nov 2019 11:01:42 +0000
Received: from mailin3.global.cadence.com (mailin3.cadence.com [172.23.38.39])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xAFB1bmC021628
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 15 Nov 2019 06:01:39 -0500
X-CrossPremisesHeadersFilteredBySendConnector: mailin3.global.cadence.com
Received: from mailin3.global.cadence.com (172.23.38.39) by
 mailin3.global.cadence.com (172.23.38.39) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 15 Nov 2019 16:31:36 +0530
Received: from cadence.com (10.244.128.39) by mailin3.global.cadence.com
 (172.23.38.150) with Microsoft SMTP Server (TLS) id 15.0.1367.3 via Frontend
 Transport; Fri, 15 Nov 2019 16:31:35 +0530
Received: from audio-dts.cadence.com (localhost [127.0.0.1])
        by cadence.com (8.15.2/8.15.2/Debian-3) with ESMTP id xAFB1X6r011941;
        Fri, 15 Nov 2019 16:31:33 +0530
Received: (from root@localhost)
        by audio-dts.cadence.com (8.15.2/8.15.2/Submit) id xAFB1TNG011939;
        Fri, 15 Nov 2019 16:31:29 +0530
From:   sheebab <sheebab@cadence.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <vigneshr@ti.com>,
        <linux-block@vger.kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>,
        sheebab <sheebab@cadence.com>
Subject: [PATCH RESEND 0/2] scsi: ufs: hibern8 fixes
Date:   Fri, 15 Nov 2019 16:30:43 +0530
Message-ID: <1573815645-11886-1-git-send-email-sheebab@cadence.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: mailin3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(136003)(346002)(428003)(36092001)(199004)(189003)(35382002)(336012)(107886003)(426003)(70586007)(6666004)(356004)(36756003)(450100002)(305945005)(4326008)(26005)(51416003)(498600001)(5660300002)(87636003)(81156014)(2906002)(47776003)(8936002)(81166006)(70206006)(50226002)(2201001)(8676002)(486006)(16586007)(2616005)(54906003)(126002)(476003)(50466002)(316002)(110136005)(14444005)(42186006)(48376002)(921003)(65672002)(2101003)(83996005)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB4188;H:rmmaillnx1.cadence.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:0;MX:0;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 648404cb-aa64-4276-63d5-08d769bb32e8
X-MS-TrafficTypeDiagnostic: DM6PR07MB4188:
X-Microsoft-Antispam-PRVS: <DM6PR07MB4188AEC949759FA14911DB27CE700@DM6PR07MB4188.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02229A4115
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lqiEGpS+B7HHWve8nSFM+tqkiqiWZkGqBJEUkh3Wcvw5Br7qLIcz24xOzLzv9eKuhel128Urv6JfJwSgEsBYgI/ABiTMME79QNXehwANbfSgEcgdcmbU+4FUWBAzp5ou4BuH3kuSbwhpRsDsy1XFciMcnhsPjIrPNSMwSeP+hxl1OoqidYAurSqDM4HdUJ5t8xsvfW2iTQtQRVBu65vuLxnf/VaUQ3QE87u59R1T0OCf8FjujFBjcYUvF8icEGe3D3OQsy6VPpp43P1lggLMgSyb6aH4768mfZX04+jNT2xWwq2bSx1QCZpWM3UVPDyYM6pto+R6ENe5tWLDl3I+BkjP4cmoTMj7kbxfY41ECGQqBzkqFAE/Zig6tERv06n/7m2Tllu9Z8m78/VtLhigsQFBXkeNId++06wj2Q3h0Zfy21/P2DLgTwvbNPvBvMg
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2019 11:01:42.7964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 648404cb-aa64-4276-63d5-08d769bb32e8
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB4188
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_03:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 clxscore=1011 suspectscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=596 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Resending this patch to include 'mailing list' which I missed in
first release. 

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

