Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E4AE810DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjI1CJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1CJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7752AC;
        Wed, 27 Sep 2023 19:09:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL6YER020316;
        Thu, 28 Sep 2023 02:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Kc+/XZ1WWwXyybA4FYsqvs0AntzLGDFrUSw0x9M1Y+o=;
 b=xzq8WJYi+HJovoQWLN4GUdbgPKMIlr1auqP9DL330nZa2PBfrzCSlvGDdYjRDKMrM4K1
 FLGsBzu+tYP2R2xuJpWlPgkW6NiHzsm2jKtLrtsN5hn4B1L/zK3Rlve6CLOUMWKwlmta
 EGjUbkklVswFRePyaiEZdGlNc4jSGffvHaUexxO3kdt2vT8NPmlGo2ps3RswqcntHRdp
 xC96oG/JnRc1gsWkgH7dtKc8pKueX1y3Ip2+fIWJbWLLjYn17HnoYLmSxd16OZfwDEYu
 XCjIAVjC7uLiULpffrN+v/hRKauRWoSBdyP95DFDA6BShHpq+dKwWDhK1K0CuOZHbKuq 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qmuk385-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38S10Emt034957;
        Thu, 28 Sep 2023 02:09:12 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf977xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmpSiy4NmFb6HjI4/vSSrhiORclTKx+48WrJmfMt3nwtm5cla/1gLX7AQJgAzf38+iI1OY4uhI9Tmhj/BUxul1aCA2zap+OH5mGgTyK868hic424FVZgHknD7EqbjrzoJzKttTu+D2duP+/IRCDBWi4vAarmO/wvHZ6VX/BQhLY6a6IObKRMxKbryjzeuJLBEENdTBQxHHTjWok6sfWg/QTqrcjTEekSWCC/fpnxU5225k/qKSMR3RCunfZlgK8UyAE0kz2WQh6NMr4IhgyRoYLgloEKv0j9aN2bt1LCqDIPcgnLMOHDBl1Dgx2CXig/DE0y24ySc60ChvgJO1kQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kc+/XZ1WWwXyybA4FYsqvs0AntzLGDFrUSw0x9M1Y+o=;
 b=kA8tLHLDHvVkrIBkJiwK9M9JGa14dBZcP/wVer0pwE8MOCZXeKKkxeXdY/MihbMpvaMuPGD4dhLI/kXc/B451ia0ZjOvribFCdXOk/SCDCYSwPU05KwjplRDwE+4eSFT62XFn238HEQ08EFuQHXGzKRpCgPNOcfviTBloHNbJMeAYVRYNMlDYVpTVtn8NBJKTMEwHbS3FdRAvwQkVwR1t41PXFU5YZ7ayyQXaZyl4jdVmihDokbJgQEX6miyH9FE5imB+bDg3yEePRSoyxgw9fMhp1s81A6+AnFunAgdbQc4hTQiI0XGzTxqtceqRbiQYGDXeG7RGzAjqgadB2dHLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kc+/XZ1WWwXyybA4FYsqvs0AntzLGDFrUSw0x9M1Y+o=;
 b=Ngh/PXicNMOiIST8tWStTd0TqXQ0c7bYfsWtHGvejDj1S/BRsH9Ep2BdZz8bORxA2GhHCdVzZSJlHL0FrTnGbkKzK2h4EMzknm37VP538kAGZTxwmgRvqWBU6RnzGD4XzZkuneskbFlMai1MxQcjSUcewqzemU1ApiCqWS+UEGY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/8] scsi: target: Have drivers report if they support direct submissions
Date:   Wed, 27 Sep 2023 21:09:01 -0500
Message-Id: <20230928020907.5730-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: e5583d2d-33c9-4ebd-28fb-08dbbfc7e761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/v491z20gm6ZC05X0ghPInbghYgKJCroZUrBh566QVU6R4nyn2sRJt4+cVQPErQmm8fr5snZ+7+7tAD9fopusLYwjTpmxzOeG6rLGpP5H2VhRefl4AqPqI7o7bIPXJn7QMzCkCMtyOSNPJ9l70X6b5byCU2cfNi5mfndNTnUjt9Xvxe/6KCTX1nx9WavF2+C22xtW4AdnYuv4073drzNF/mUff5ZYOilWLJb+PqcHFQPRRHWA4yQ/L4uve/d1FvIABhaGfWBYEVwmXWUyIgTrK2Uc1LUAEe1qgQa/7MBuCdRLpctuolw7WennGiObR4V5CnF5rznCQzdcyL09PkltqXyMjy2e7EP4zX32TghRiozAY5w65Cj8Ss6ErT1LmOehC2gH/2R/gEbpzJhmpXIswImc4abQSkEYAn6cO61+yzo/rQs9UNgh9WV4vKhZTDqB/rWz1hE9reYP4+60ku1N6B9hoJxx5cmIbuiTEi6N79TvJV4//rDa/wEHqdISM05ikBUnUKuxV424guhK7FauNyshTeVJKidx703APdS/kZBbeZD5/ovbomUPTgKbpE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gFQTgLd2j8vTdhMHje+rLaC7SoMf4aY4mwgBnc0IL33eIgdFcGboOUkur5TG?=
 =?us-ascii?Q?iA04PQaWKSlfFFXywxCV44ZgzWCj1T0saRFZ0dtzibIhpZ+BT0BYPvbHkG8Z?=
 =?us-ascii?Q?UUniJ0TMXgXfA4G48lKt89HcxfXTCe6z1+PyLGw5/numnzLnAPSwSXfy7rV0?=
 =?us-ascii?Q?aDgc6O5/8sGEdZ+5gTIcj9fc8yPnznMS7y8vubV7zvsN9JtKpox67cpYwTeO?=
 =?us-ascii?Q?3bYVWWqvYp8N7pD8Pt8xMYQcqEvn6BDLuE4kDc8Hk7ulp8cJfuWb1i46JTz2?=
 =?us-ascii?Q?zu6AK0rWAnELGHl35AzcQwrl59tcGdj+0jRO2reZGOBwrWLhpDD/CTctwubq?=
 =?us-ascii?Q?CmP+4Kc4Z4Lv86of8qslTTTq205hjlC51XdcLrsNNl9xYSHPKTpIwgASD3OU?=
 =?us-ascii?Q?tQNT8wGMRliO9DWEO5jkALRJ6iOv/2o5B1uO4wNLXWdkwKTgcacffJ7QJPOY?=
 =?us-ascii?Q?k4fFU+cj4g/6mqNGnqDvucDrkmwonbvi+4fFo7hxWLwgkhYsxEO6TBNf0j4K?=
 =?us-ascii?Q?3JSAOgOxBM2CzVLJPPfuiH1QkEa9l64rrvXIZ+iEaFD5dlBLsCtlVaRqBCnf?=
 =?us-ascii?Q?aK0Rc+wCODtK1zugjf6f79sXybVhrIRjdlkPd41q9Ngi/1P2BTis20WQR6CW?=
 =?us-ascii?Q?JMIEU/5qYZIhPqhd9qRQgogTztk2DnlS3rm2MgJ4xpOT/qBJjCHJp05ARc2+?=
 =?us-ascii?Q?bZhkZZSBjKaddLeYBsLTMFfxi4JjaPd5vMgJn/zzxSSNgDnB/G/tLh8ZUEHX?=
 =?us-ascii?Q?hSIfKth6k+cuuo4l51sWIVtJpJ9PwdOyRuH0iK/w0sqUw3CovaZwwmhNu6pp?=
 =?us-ascii?Q?APoVAjWqyG4Hf23V/vOsxUII40d4h2/JyPlENeLGazVk5Zf+Y4L8X8aex8n4?=
 =?us-ascii?Q?+BcxK4bcJPxOJYyYc8ll5+zENuLjqip/TcqJDdDFsLV6rOXVmjs2vMimiw4S?=
 =?us-ascii?Q?ll/w/kfP05fXrAipKffEa5CjoF+sYFIjrFYCoyGQL4X4YYDC/X+kWEfUOvER?=
 =?us-ascii?Q?xZ+YINW+mOUzlPXaVQBQA4f1JFLOMg1B42rNUVftKhAhtW8w1ngi+M/Bq2KG?=
 =?us-ascii?Q?sqRcasxVpk+HNwqWD3D3FF5eOx5gLz9ztpuyNZTQj6m/N+AWtxo7BrPg8z7A?=
 =?us-ascii?Q?Ef2yzTqrh0/jJdQJfRysCpzidiu+OVlHeVKGVB/LHGsJ+HAFvAiOG45WzssE?=
 =?us-ascii?Q?eSFRyagdtnzHEJXxU2JXwearQq5tc3uGA7r/TFWej8ll7QYxOYrmEFzWhr9H?=
 =?us-ascii?Q?EwpC04WP81uJVCzg1BUZw6P7iRPkR/WHLBuJ7YpLE8nmeCl4bDN9JDxvgODa?=
 =?us-ascii?Q?nw5q0HNFPWbsGQNarNXxHqmvXo5KNm+TeGHQkjo2YW4puwgYiIMNTqvzeuoi?=
 =?us-ascii?Q?gMpSVXhqehi4kYN/KjMJ/3gAe4DTXGVUuEsXlpjNaC0e2ii8IWzFPcrqbVJv?=
 =?us-ascii?Q?74UV+UKmU22wO4HD/4ZNMTkSslD80sknYqAe/hHxaPaJf9hqRS0pJw6WiSQz?=
 =?us-ascii?Q?HoJiIdssIQ9zU1xOSX1hV00SZnrSCrBASB16uL8/Sx4mMFZxK0HsSVnkoYHv?=
 =?us-ascii?Q?d3WV/Lgeyt95KziEw53uJrEJW9/waxQ6WzSkNqfD9EVurDHS3vuLrfNGr4wC?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1Rea2UJFk+AsqdKnwhCgLx6S7u7Qa4vpKl06Wu5Wl7U6XBl+mc07sFCg5/Z5jzblF6yIeiyyFLrLcaWp5Ls2ADomrgU/s4CL0scXQeUk1OnxBIppSHnzVsnHJjUej9IR6eREOp7MT3Z9Zz/UmsPYzDG6mJQmOIsmRg6rHbIV3cY/8N26jlM12FJFT3pH0H4KWDwYF67EB5mz4T57iHk24NUEHC4x72mPc+TUXJ8LgQRjYzJcmGfmFURLO+iEPErWGDWuW4jQJO27dwRz8OT/OfoqEFXx9ZoXAtcYpfqQI5y1qKN+pNaJ14Afp1yaOK0kKi8ih1xdR8Yovh6dQOKAs3IL36m3LvmtnVPL/D9GVi1Yl1NwxmI9Z3XCoDWjlMpkblSqcuOBta51PFlAJM6dFjZQTocQbY6dVY8YqExtURIzBm21sjxJADx19MWzSJY9oYw+bQx2W+84tqf6WmtRmKaXjYGlbyWTXf5EeSpMrA15vYoqNePfxKGbPSUgU0i+fMIDANsjrhTPSqpdXhI/kp/eqpAdr8scwHTalM7joBRRHGRvYuhvXJUsxZ8dZ96FqLUPp3QT3jPlvhCbEaLFHRo1gUf3BQfebcoFDmb8SFB0GoyN+bZxQOoR+SoHJW481nnd3/es07KoGBKRoC2PFr/UAVAoOAij1kYs5Uk9NibhcnYnA/hNTzw0/wi5byoMfODoWG3SC2n1IJhBbMFg3X61Iv4UwsCM/uyryHidr6Ek5yGAlc6ACCae2zmMqOSl5slAuS6OkYYneViRWsrjJg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5583d2d-33c9-4ebd-28fb-08dbbfc7e761
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:10.5653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVLzLMn2jl969y1psbEXFNdHSRxAq3csJ2NwtilZTie6DeXD8Ei7na4mdiRKueRxNOGGCytooO5eco58POa4igMYL9VCq6XdY9pEfSaofKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280018
X-Proofpoint-GUID: yRG0oUBb43mCvYcSKE_hsvQrZta0HAH6
X-Proofpoint-ORIG-GUID: yRG0oUBb43mCvYcSKE_hsvQrZta0HAH6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In some cases, like with multiple LUN targets or where the target has to
respond to transport level requests from the receiving context it can be
better to defer cmd submission to a helper thread. If the backend driver
blocks on something like request/tag allocation it can block the entire
target submission path and other LUs and transport IO on that session.

In other cases like single LUN targets with storage that can support all
the commands that the target can queue, then it's best to submit the cmd
to the backend from the target's cmd receiving context.

The next patches will allow the user to config what they prefer, but
drivers like loop can't directly submit because they can be called from a
context that can't sleep. And, drivers like vhost-scsi can support direct
submission, but need to keep their default behavior of deferring
execution to avoid possible regressions where the backend can block.

This patch has the drivers tell LIO core if they support direct
submissions and their current default, so in the next patch we can
prevent users from misconfiguring the system and initialize devices
correctly.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 3 +++
 drivers/scsi/elx/efct/efct_lio.c             | 5 +++++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     | 3 +++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 6 ++++++
 drivers/target/iscsi/iscsi_target_configfs.c | 3 +++
 drivers/target/loopback/tcm_loop.c           | 2 ++
 drivers/target/sbp/sbp_target.c              | 3 +++
 drivers/target/tcm_fc/tfc_conf.c             | 3 +++
 drivers/usb/gadget/function/f_tcm.c          | 3 +++
 drivers/vhost/scsi.c                         | 3 +++
 drivers/xen/xen-scsiback.c                   | 3 +++
 include/target/target_core_base.h            | 9 +++++++++
 include/target/target_core_fabric.h          | 9 +++++++++
 13 files changed, 55 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c12005eab14c..58f70cfec45a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3867,6 +3867,9 @@ static const struct target_core_fabric_ops srpt_template = {
 	.tfc_discovery_attrs		= srpt_da_attrs,
 	.tfc_wwn_attrs			= srpt_wwn_attrs,
 	.tfc_tpg_attrib_attrs		= srpt_tpg_attrib_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 /**
diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index a982b9cf9870..6a6ec32c46bd 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1611,6 +1611,8 @@ static const struct target_core_fabric_ops efct_lio_ops = {
 	.sess_get_initiator_sid		= NULL,
 	.tfc_tpg_base_attrs		= efct_lio_tpg_attrs,
 	.tfc_tpg_attrib_attrs           = efct_lio_tpg_attrib_attrs,
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static const struct target_core_fabric_ops efct_lio_npiv_ops = {
@@ -1646,6 +1648,9 @@ static const struct target_core_fabric_ops efct_lio_npiv_ops = {
 	.sess_get_initiator_sid		= NULL,
 	.tfc_tpg_base_attrs		= efct_lio_npiv_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= efct_lio_npiv_tpg_attrib_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 int efct_scsi_tgt_driver_init(void)
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 385f812b8793..4dc411a58107 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3975,6 +3975,9 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
 
 	.tfc_wwn_attrs			= ibmvscsis_wwn_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static void ibmvscsis_dev_release(struct device *dev) {};
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 68a0e6a2fb6e..7e7460a747a4 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1822,6 +1822,9 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.tfc_wwn_attrs			= tcm_qla2xxx_wwn_attrs,
 	.tfc_tpg_base_attrs		= tcm_qla2xxx_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= tcm_qla2xxx_tpg_attrib_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
@@ -1859,6 +1862,9 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.fabric_init_nodeacl		= tcm_qla2xxx_init_nodeacl,
 
 	.tfc_wwn_attrs			= tcm_qla2xxx_wwn_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static int tcm_qla2xxx_register_configfs(void)
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index bf190dcb9eee..88db94f382bb 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1590,4 +1590,7 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.tfc_tpg_nacl_param_attrs	= lio_target_nacl_param_attrs,
 
 	.write_pending_must_be_called	= 1,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4ec99a55ac30..fbacccdd2ff6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1102,6 +1102,8 @@ static const struct target_core_fabric_ops loop_ops = {
 	.tfc_wwn_attrs			= tcm_loop_wwn_attrs,
 	.tfc_tpg_base_attrs		= tcm_loop_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= tcm_loop_tpg_attrib_attrs,
+	.default_submit_type		= TARGET_QUEUE_SUBMIT,
+	.direct_submit_supp		= 0,
 };
 
 static int __init tcm_loop_fabric_init(void)
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 2a761bc09193..b604fcae21e1 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2278,6 +2278,9 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.tfc_wwn_attrs			= sbp_wwn_attrs,
 	.tfc_tpg_base_attrs		= sbp_tpg_base_attrs,
 	.tfc_tpg_attrib_attrs		= sbp_tpg_attrib_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static int __init sbp_init(void)
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 6ac3fc1a7d39..5ee03d1cba2b 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -432,6 +432,9 @@ static const struct target_core_fabric_ops ft_fabric_ops = {
 
 	.tfc_wwn_attrs			= ft_wwn_attrs,
 	.tfc_tpg_nacl_base_attrs	= ft_nacl_base_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static struct notifier_block ft_notifier = {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 79ed2e6e576a..ff33f31bcdf6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1687,6 +1687,9 @@ static const struct target_core_fabric_ops usbg_ops = {
 
 	.tfc_wwn_attrs			= usbg_wwn_attrs,
 	.tfc_tpg_base_attrs		= usbg_base_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 /* Start gadget.c code */
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index abef0619c790..dc274463bdf0 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2598,6 +2598,9 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.tfc_wwn_attrs			= vhost_scsi_wwn_attrs,
 	.tfc_tpg_base_attrs		= vhost_scsi_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= vhost_scsi_tpg_attrib_attrs,
+
+	.default_submit_type		= TARGET_QUEUE_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static int __init vhost_scsi_init(void)
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 8b77e4c06e43..0c51edfd13dc 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1832,6 +1832,9 @@ static const struct target_core_fabric_ops scsiback_ops = {
 	.tfc_wwn_attrs			= scsiback_wwn_attrs,
 	.tfc_tpg_base_attrs		= scsiback_tpg_attrs,
 	.tfc_tpg_param_attrs		= scsiback_param_attrs,
+
+	.default_submit_type		= TARGET_DIRECT_SUBMIT,
+	.direct_submit_supp		= 1,
 };
 
 static const struct xenbus_device_id scsiback_ids[] = {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 159567359bbb..401abdf8a9ef 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -108,6 +108,15 @@
 #define SE_MODE_PAGE_BUF			512
 #define SE_SENSE_BUF				96
 
+enum target_submit_type {
+	/* Use the fabric driver's default submission type */
+	TARGET_FABRIC_DEFAULT_SUBMIT,
+	/* Submit from the calling context */
+	TARGET_DIRECT_SUBMIT,
+	/* Defer submission to the LIO workqueue */
+	TARGET_QUEUE_SUBMIT,
+};
+
 /* struct se_hba->hba_flags */
 enum hba_flags_table {
 	HBA_FLAGS_INTERNAL_USE	= 0x01,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 2a6c4c935666..dcd7d76d2f30 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -118,6 +118,15 @@ struct target_core_fabric_ops {
 	 * its entirety before a command is aborted.
 	 */
 	unsigned int write_pending_must_be_called:1;
+	/*
+	 * Set this if the driver supports submitting commands to the backend
+	 * from target_submit/target_submit_cmd.
+	 */
+	unsigned int direct_submit_supp:1;
+	/*
+	 * Set this to a target_submit_type value.
+	 */
+	u8 default_submit_type;
 };
 
 int target_register_template(const struct target_core_fabric_ops *fo);
-- 
2.34.1

