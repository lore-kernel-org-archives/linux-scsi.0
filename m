Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EFCC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 06:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379746AbiFQGBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jun 2022 02:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFQGBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2022 02:01:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F1C25C64;
        Thu, 16 Jun 2022 23:00:58 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0HhDR032716;
        Fri, 17 Jun 2022 06:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=wPMwbWbpftMtVZKxp4WNWnpvgGPoBBStB27LVikU2Ng=;
 b=ucxAO56qvUAle/MwPe4/SbUUZUXUuvSkbouRSL8sJEzd3R9w4y4sLgCn0aX13ur6tRLD
 jsgbK/EQF7tofO6JzflO/QoMo+sjJ4avSG+iY3BMKLqOyI3C70fm5P5aFvpYgp94UucJ
 0mjhAXGzmxhp/kqLpoEUOc3/Yd2wk+FaB91vVPESHVmlAyna6RllMrsJ8r8td9vKr/EE
 mubUmyeN98eo52LW8HSjeZ4pbuykXbRmOy4DQVtNYBivcYd6+lHm27d+MLYoVTVDTG8q
 YyvdNNhD1Of8zepM3SA7cBC+locvspVLYXKqeK7dbuBUaRC/j01Bligrhf/o7AGqpi5D EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2w3vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 06:00:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H5tgYR006848;
        Fri, 17 Jun 2022 06:00:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwctms5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 06:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0rA1GY4WgX7uYpTw7Ef3xr6SvrklpjlSsB1uVAFtANGsQLcsf+58FNCpM+KraEZJFDH9OEO5lNhp3Y7eyrV802RE75A7D02R2xJR1qIp7yCiW9apuZfXAMAUa/cUnSjyBN3+P5LVTWp8ePaIFCHnLQ68z0u/CXTTzg1o86pJ3sDpvUavdWNnTsaXUCEAPIfe2xNwYfwWl+kE4MRnSZ207r+TJO/1fE5eetAvT+Rg2XozhTK5ecQlLpg6hkOUpvxWKvm5o8mIM0IYszEuJrLjElGq0icNJ55JnPPg+RJI/fTrNRrwzNTNZJWdhR2OWQppSViDHuB9TKnfbABrf+sWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPMwbWbpftMtVZKxp4WNWnpvgGPoBBStB27LVikU2Ng=;
 b=ZIqSiZfaUpZM0ttoYGxcLRryoO0tnXsRPRLd7+njjnwd/xesnw8It1jMIo/Q2GxpppsERD/7ywt9U9FbqOHUX7Bu6Bm/3iP0Rmwn/W2DCHoQG2hF+/ys0Ikv51UTokhBgusleopQeUXo+wJW0Mx2PdGhjMtZQEmaoEj76UMyss1Gn9F3MFAss7Tr2OJSST8bwmO/yaxL/KyUXcF+20daEz2gfI1wdgrayP2zRuSfWT2lHJA03JX7Ppyl9hS2UoN4GNB8ODl+Ag/PsoimPrpE1UsrVc4caaJevLHRook7JDR9cefOn9JUP7D7WADEu9f/Mno0DzvQYwNaYTM5MeCI9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPMwbWbpftMtVZKxp4WNWnpvgGPoBBStB27LVikU2Ng=;
 b=Qsh5UtwHSBagbRrQyt26T9m+XsVCkcsgmvPn20SQOJ9tDSvG0SKMwLbvz8RNRO7XioQzJAIVS3O8ITCalck9ESyny5ro8PGUFiLkbCbYl4QLdwGem7omJuD1ulGMFoj90HqjvNn09m07ehUnPCCsuAVnGQlz6gP4x8U5z024B3I=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3233.namprd10.prod.outlook.com
 (2603:10b6:408:c9::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Fri, 17 Jun
 2022 06:00:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.020; Fri, 17 Jun 2022
 06:00:52 +0000
Date:   Fri, 17 Jun 2022 09:00:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: check correct variable in
 qla24xx_async_gffid()
Message-ID: <YqwYikYF4Ye6hpqy@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c4db223-9c35-4f6a-f8aa-08da5026bc65
X-MS-TrafficTypeDiagnostic: BN8PR10MB3233:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3233F9EEF8CE0403E755CC658EAF9@BN8PR10MB3233.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWkEN/NDPWxv782ZA1djs3Gv+9M1NwnsKFrqenTAAHJIs+O3P7Imls1O/rpd3Jj647YYKd9b/iolZT9Fyg98on2M0SvG6Tt/U71y/1v5XDX6YCd6bKpG02vizIzqqM9V43P+iD3JeN0H5Z0WOVr6IMMNj+S5lZFdrLqhwSGdO9wXf+oi4moznH9nBc/rDQ4UlM/J7GF95QqF+XD98RlKo/yY9Wf+iTKK3d1BqnRDwJD5mL31dXaiTz+I6su8iCgoMOKCybO9cVjTyuR7+P12yzd7kLwYPXUtsZhFofQ6ndGsVs43Nf+FCQmoWHsl2CBVclSUSXf6ENLWXsJ3y82Js0/PIdkHM2/TlSHUVuTDC/u4Pso0V3P4KduQnSjhGCoR622a2m60OClmGOjeEwbmuogHHRgrtusNwQ/01oVRiJC3ZH9bilyjT3qED1EXXx/YI7mxOWDhBjcuU4vAJ6syJ7ThO5N96PiBOJiOnJBGkbb89sqQFUl+fJT2AhLTtu3W2100XzDIGE8lDuRQXgkDb5Gycx/74Y0nMszdr+cgikalnp6QFlAjZGNYDAp0r0UEu76Ieec6K29DN8Xh+UU6osMZbTKxR5NRxtt/ZuTnD/edObjKuOmC96/XzzE6tJV5nl9/TOOlL9qr59eBwAivRo//416VbF3+v1MT4jFcHBrBMfD1DcpzAzhJ8a+2xRIQfIPCPK891vUeW14nrkzbKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(8936002)(44832011)(4744005)(6486002)(9686003)(498600001)(33716001)(83380400001)(5660300002)(186003)(6512007)(6666004)(110136005)(2906002)(54906003)(6506007)(38100700002)(66556008)(4326008)(66946007)(38350700002)(8676002)(52116002)(66476007)(86362001)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O4fz+xtUktgQjGEOsTevNz6q5AEs5dOrnTF1AaQLwWPOl+7yLlUGKriDeOE1?=
 =?us-ascii?Q?7lOnPUszx7hDTUVto9bhkAkc5BSr9+dyUHK+swrGpsS4PzTf9K8IA2sjz5sW?=
 =?us-ascii?Q?EJn3ix+XsloBrRIejJmCRbVWSsepj8WUPWGrgNFEcsR/PjqKSMvCX98QIGtn?=
 =?us-ascii?Q?mIR1uiWeEoEOKG/ph/73WMZ4S+STlXF+u4Z5vV199hGQxFeMtNPdnyEx7bpq?=
 =?us-ascii?Q?27+Gz9fPv3dT+KvcQ7BH1qntqto5Wi5SmDpWLijW2ys1/r22uObEHlX8L/uM?=
 =?us-ascii?Q?G1vxKMqkKKCqgUKD5Dbf3fVv3Nh/8ODPouuj5phVy84/kaRLHNmnLA++7MM9?=
 =?us-ascii?Q?ojJSAvzoCHgbPF+PySFRvc0Na9+vk8VlY5+RbOqo3I+vCJLvSu6vab9HuyhC?=
 =?us-ascii?Q?42NDw5ABmcDQrVGHfx1GIStSZIFf+8QeiYubXFOMvD3S+S0sfvDPRhgN27Yk?=
 =?us-ascii?Q?GZG4kNuCmRM5SORc+L8PgYpbmuJzTyUZnOVF+561lDjtQg1YrHke/nzGOj3w?=
 =?us-ascii?Q?rhsQDyWMUNPVpRnaTk6VLINx6LTLU2pU7ToduB7twhR61n1NxCK7FMRz6H0D?=
 =?us-ascii?Q?hjlu6wjiYtyEkrJdtPEd7XRXVvAZqWMJX8po1VPVCx4n2b5VBZ2hVL4jvmtv?=
 =?us-ascii?Q?E9W+sy0p35o4HfyZbow186/VTKkZkL2GZMfAetQqihafqSM/OlL2YSpP6WWg?=
 =?us-ascii?Q?MJl7oEq/+Uayy4bh4cH0UbVNTg/vm7LDmohZEVc25IP7h8hQYBPIDW0w8Z4z?=
 =?us-ascii?Q?XNJdRZaY4ynVS69eY9PB7r8LAFi/IS7jSAa4i2XKFSGp3Q601Q3gHbSFduY8?=
 =?us-ascii?Q?xnpiH1NVXFWiuCk6gZkp0F4YTKPYWkIhClLE95X+KjOoUPdsH9r1ZZBZmmoU?=
 =?us-ascii?Q?GQolfsr/nc3WYiqWJJjUqmPYDnMeV3ry/nHUPnTew3CEYo4NUpwFW+m7OyXT?=
 =?us-ascii?Q?0oN3CvtFGYHKJAIAPn4xTfJ78NVrCYfi8LojEtl70ZLmFhR5JOrZzZhzcdgl?=
 =?us-ascii?Q?EeHrIlWy3ORsMYivh8Uuy+awb35TaIZ0tQsg2pPfuHk7x5/2Kk4qdDPkaba/?=
 =?us-ascii?Q?XIa3TROZW6YLTTJYPLT4HpabEKLMQu6mf6AD/gWDrAVbOJhiA05dzJohH91X?=
 =?us-ascii?Q?FHJyLefrNL6pYMyNc8AKc9qrHeQGpqG8U28cYZsl41fH7VbsYDeE9WqiG0YM?=
 =?us-ascii?Q?yvCr9r89gTCyhAY7NLk2aT/sTYJaerciJ+hA27jkXkN0lcoRVjPO2ZKUKpdd?=
 =?us-ascii?Q?0nXiQtwlHL70ZR8igav1TgbQScZYj5D1Qcq8Ci1mta8yjZrMwy4tvWpA94a2?=
 =?us-ascii?Q?uAJcQRmApu2ekV0dvzEpqrbqt9EAmK8P27Y7WxzFaN+mnOK53mYa75XY1C+h?=
 =?us-ascii?Q?qIvJQNU7OwFwDkmZFCPZ9DOapn41moh1BdUBQdXmTKJfTHcsk8mOor6FvLjz?=
 =?us-ascii?Q?eN59EfCxRnCnz5D+24XLl8pF3wseZXlpGBIkTXmqPM+oiOGLiZfsVLMy7kEV?=
 =?us-ascii?Q?C83pIqQXDxiFnr6d0QFQI7gSCvLOqbLQ2MQJFFF8GGw+v3hsgJBCVwipUGOz?=
 =?us-ascii?Q?/NjMtlLlROIHltvVupdnyZ4gO1onPO/Z79hUV6GQG9g42GfHYlYn3QuZEJaK?=
 =?us-ascii?Q?M15fTGlyxP0L6TNP4l+Au0I3/vWW4AWzjQaltLXlkKu214oydh0KExe8uKm7?=
 =?us-ascii?Q?cXD4cR0v4OH6ihSpB2j9gfBiPWqzR9XYEvxKB24oA0TZEtdTC1TE8qFLiglZ?=
 =?us-ascii?Q?CuFcaho8zuRnrWtthdfuMdzLe6Pv3mk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4db223-9c35-4f6a-f8aa-08da5026bc65
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 06:00:52.8156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPo203IGdeHp/BeWTLXBe8XWyBgp0aTxUTAEMXZO6/7SRByKOWPUiJdnPOP1roYmBQihXBKH9FBD16ioZxr1MqAECTSZbZzjcvUHgN3HfkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3233
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_04:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170027
X-Proofpoint-GUID: ZGVgzxK_YeXhUK4tpoNZZgAPXdLztl5a
X-Proofpoint-ORIG-GUID: ZGVgzxK_YeXhUK4tpoNZZgAPXdLztl5a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a copy and paste bug here.  It should check ".rsp" instead of
".req".

Fixes: 9c40c36e75ff ("scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 350d7c22ac79..cd0c3c703786 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3389,7 +3389,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool wait)
 				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 				&sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
-	if (!sp->u.iocb_cmd.u.ctarg.req) {
+	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd041,
 		       "%s: Failed to allocate ct_sns request.\n",
 		       __func__);
-- 
2.35.1

