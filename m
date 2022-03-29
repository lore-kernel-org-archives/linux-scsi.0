Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2251C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiC2SKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbiC2SKd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD64F1ADA6
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:08:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsFjF029596;
        Tue, 29 Mar 2022 18:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8jeheR9kbf/rNG5zE3IYkGWahx+dVeGjBZAs7weoOnE=;
 b=fwtQvo3qWwdEcXaX4d40pXM0rJTf/04Gq7waQFHVXY5gFMaE4JOf42hpzUXdEa5p1kWO
 Lb/H4PBr7zV8CoZFAMqPBnOvTr6wcgLSL5VC76gYLwWortVLrTx81vye6s99Om15Wdcu
 e2afk/f4NcqNihoWrj5id9F+2KAu56gZNITg/zm7Qe4kSlDAzL+WJuaTth0y4/nNcDPc
 3v4lBnptLx3cLdLg4Xjw3pD3UgiICcU7a7Ht8pi8zuLyTAviOf2MVdmNVxkFlWafejho
 qg4JtYq7YkxN90OD09Z2QabALQpnq4uUjfDDYpFy9hIolAytBKzw4CAHCsAIbtqdXjfT pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0fcv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJN048570;
        Tue, 29 Mar 2022 18:03:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq7JvIM0ew17NjevD/Kuws1JDUFVcUegEG5R5BCeYu8aqc7tR6smbsO2MjIDyX8WxMax/6EZBFxQtw1d0dk3m4WrY1XZfQiSk/iSETQ1+coFYniLzEA9cuLapZL5OX/EQgnBRcqbGinVRDfoceH5f5mNbtUh54R1UQgnHSQOre9BIHMUVkFmgUlPfBOX0iBqCjXkBBQXx2gWRKjH+ozc7luGUGWT+I39LupzbiYGRTiycZnvN68zltL0qsS+xKZGpyAowctRmmhL6yKkzUOYRainlLYp5TfzEcgfKffMCMmHdLA1dHWoRCoGMbnKQyM+IUw65hiIxhnIsv/Hu4DhSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jeheR9kbf/rNG5zE3IYkGWahx+dVeGjBZAs7weoOnE=;
 b=l0wFDPpYKgfhr3hMpxUNpK7SKuVdCYGA1+erdQheOmUvMLEKl/lXugEihlYxBTp4GGHozTm7TNSgGkLJa5n54h46J3ejTdNsW7x8vma3IAlYQ3mLsgOmuogvS64lwFemffu0Hp76dRaiz4WxxNTMa33i2syamQghkuwfAGW/2Z4rBLQrV7eau7aN5dHPSxS+MIc0wZKo64jTUJe4CSuQgZTDNroEQYAdsTP7cLfCHzt7r6Ete3ZSA9INmwYZ/7cF2/pFcQbu85Agn2xguJ157SovDMxdW1YxY7Ny4+k5ysNMBySr3zejHiA1upe3V98LnzLHNPoGLo2vroz0XeSXHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jeheR9kbf/rNG5zE3IYkGWahx+dVeGjBZAs7weoOnE=;
 b=K7lwyq98HXgN31L8MbWFmyAMzhLdFFi7JEIYVctswQwGrCLVyye0aPsklWPW6J4rkcyAfsyD1RsMX0RmpVak4ygy1oZO1sR8uENuKm3Z4Pyz7dzLibH2PFhX94kohQgjdz1wHiJJW66yCl83izo9FRvXjx7JSYFDCFYS5XiiN/0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 09/15] scsi: iscsi_tcp: Tell net when there's more data
Date:   Tue, 29 Mar 2022 13:03:20 -0500
Message-Id: <20220329180326.5586-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 600e3423-8d7b-49a1-603e-08da11ae73c8
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB358462B3D210F8E8F2B77E9FF11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8UbqIH4opjrVKJx3VHBQxoqbZGOgSTWDoqIPPXeG8AERQMGYzxAcm2f7r/UnR/EJu+85+1KyMUrjvOsI96ZkiN5Btx7tuZfxKWfOrYhkdsbP1JjoxC0a94w6/Lpii7rD57Axn62bvsjcibwqyrFyqOAZnFg4tCN65ZStkB23Uii8fzFdYWFdo9Cf3rHulXD9c7sraNOcKE3hqFlzv5K/cAoK7LBnNekcaFx55hnqgBNomKVSw3PVjIkNZW3eTsUs0HM1Z/FJU4fqhS+/Klf7EmD6AuxRHXOK6lLmiVLuJxvoK0P9oSwv7v8iDG2l1L4kd8NHLjlhNL9SgAlrwiRGiyj16qnXqrwtnWTHMC7JnV6vagHjy8epFtEPSGLcjknGjUpcML9JUKQncMbsIwdiY2k2dHQvpFPSqrg3c/Caj/J+BB3n/nLAjmeHOmejjIW6HoH82KjifiFAlXd3Kk3BDsUq/uBClUBugw3/XQnfR7VPP+lP+jXyKWgMhLjkAnBCSh7Yd5LhYpWKxoHk9IX5nTHCg5HvcAl8SnTfalW5r3SI1liKKtW9BGTS7rEyO3Yl57PhhmsmCS6hf24DB0hhk6lMYAveWe3XSd44EaKdmSyTlh9WN46enBq4tcshgAjyp1OIoXj4JVH74NifyldnxFugt9CXzzugxzqdRS7l8A/oG7b+AiRZy4GwjnVmgo+zqpyYPMtXgZXfjZM+hfKlnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(4744005)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BzlMuxz73xe4oTTjvKqxEhJ0VkNBRtACkDJk/2UhfjbDvMn/zVtGjJorIj9G?=
 =?us-ascii?Q?lZVd+8ATBqb9JSFhJLsppKr3o7c8eEkmRMU1vvvYemuUpWKY58c3c4NKsOXg?=
 =?us-ascii?Q?jxfaYaZk2H6UO9JkjFM98aQ36UGjrOdKuZfKmXkus1NNLNEkEb/t7bZ2b7bz?=
 =?us-ascii?Q?fCgDztyeTalbaDO7RzCzoir24hFSEZ4Uta7GtdWbQTvXs3eH1xxC+TddTGf/?=
 =?us-ascii?Q?pd2+1oBqunlmBiC4yMHjuWC1LJXNaJOJ7yvAVbNrLDeGdBj+YHHxOkMmHqL6?=
 =?us-ascii?Q?C/7mrhspBWPvcH+EdftiyXEnjZSsa1ctRwfObLZEIzo4dDz3lvBBUa+W9L3S?=
 =?us-ascii?Q?UX5WBQJI0cVhey0gGVEuSQE8+WT/C2S9T5K7G+AS7AMFP5k8/qRtvj3iviX+?=
 =?us-ascii?Q?WNbZ38SUZxdk9PGmA8evAos8U/kADaZiQtCF8CpCRmxRaiGah5GPsRywO0t4?=
 =?us-ascii?Q?t7STXN3yry75N0kTYHQVx354hdKtez6L47aDXEI/+t0YGDBkznltrUsYdJhh?=
 =?us-ascii?Q?ruCs0b5B+L+FQReB+uDyGryGBiadcCMMB62NEl0rrmwYKYvn86WZ5xEThwpd?=
 =?us-ascii?Q?QUKiR8kELKTyXNoMM/gWmNFrb0+QBGIMpXFtahxMo4lAgD8Q3UtIPscRA0Aa?=
 =?us-ascii?Q?FQHjyNivQCVSEm2gTF8yE/Zv1coB4RvxRO2Pze2vO18d321EhIr5TKd4Vmzr?=
 =?us-ascii?Q?Yewtr9g2M0xI/I2aXdya6Nz/rMd1Ke0x1r8+Dsvq9DqBCHUyRYW1Cr1XLkH7?=
 =?us-ascii?Q?X3MaynYyuqn9R0AsaWUswY4ULtlLJ4lEE00TZSwnawHeyROaIu186vBpH1E1?=
 =?us-ascii?Q?DZ9B8OWWGKDV0DM8MGy0j9onu+mVA70+6tlhdM20sCKV69GXr28cBfmb2g62?=
 =?us-ascii?Q?MpBlwqHG2IS8n2LYxvr491mag3E3fjzPmYlwWNqNcqPALX+YFG6kKs45SIx4?=
 =?us-ascii?Q?tGYSCdG9zqWJR6e4K+1FY3A0afpFM+/HQJAJVpfF8fkLEvr5rmfIe47eX8Pf?=
 =?us-ascii?Q?1g+wtVNP//vruJwH/yV94yQz/boK2s1MWiaSBZ7rbiBIpcwKMAohbNWle1gL?=
 =?us-ascii?Q?cBiKnh/+82hg1SoT6MpKlcQz3KjUGCCuqwcftPbIBUPEd4VIZc/HpEkxiyYe?=
 =?us-ascii?Q?GMBznB4wAi+ZuZKjKLKNjs5yUIDUy4oMyWvteil2TNnzStXdhIkZrZ7V0An5?=
 =?us-ascii?Q?WYmunioUXhmpvkgQjoNtTQvPrLyC1+tWWxVTs5Js8xQ8ZnhWKT/bVSaVV+I0?=
 =?us-ascii?Q?PyCCrCyTzbQSyaWWW1T5+Ge1DAOy0IQd9bxFkKv4cNrrYPulIQWdGBCc7LJn?=
 =?us-ascii?Q?hdnnV3UVvvhWauSQiUop1NEbcl6iYjkM/NGmgqxZXRFX7oNAgsYSKkf9XLPa?=
 =?us-ascii?Q?j+ov12cAe8UDzypO2bGYws4s4Dw2ly2nQwgvk7LAmjckcdHAMcFmMjE09SHS?=
 =?us-ascii?Q?qcVSiCC5K4BEuUcY6g6w1Ig97TwbIPU89AO3qeHapLFRw/6MMXPSk83AzcWX?=
 =?us-ascii?Q?Ea5benzy5z7B+cAHE2q5OQRnKi5pIAPdBXkYoJPt3WdbRBzTuDkSkATODxwL?=
 =?us-ascii?Q?Zrvhm1rs6rpZoTzXrL89Y+MgLOliLujARnKx4eLzTPOOTjflmZJyxW/iFhTS?=
 =?us-ascii?Q?PSSo1mBjh2oqp0JRuFLeRDpqyqTonh70KwkBB6vEn7EPs+EEzaVJfHc9K8Nx?=
 =?us-ascii?Q?s58HQzXfrWIM4bgLpXYa/i78kkC1nmUmxgxjNvfaqZXlxwfXZKkK0HEAlocd?=
 =?us-ascii?Q?27iQWNblbJIiJT5ddsThHx0QhdY2UyM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600e3423-8d7b-49a1-603e-08da11ae73c8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:39.2714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmWfKHeMvQVjdG67mN7mJv6sMh2pmQtYhSpl/L69t7cjPRd9Ts68Lci0iLcgwNYk6kWTLxNa2D8cyHsCgoCgz644FNzEWL8UyCQnOWdRO7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: 5rkTW8vzHrteaSquTGnYDaOQqc8FFDQm
X-Proofpoint-GUID: 5rkTW8vzHrteaSquTGnYDaOQqc8FFDQm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have more data set the MSG_SENDPAGE_NOTLAST in case we go down the
sendpage path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dfca81d4e3ee..f50c00f2ef9b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
+			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		/* Use sendpage if we can; else fall back to sendmsg */
 		if (!segment->data) {
-- 
2.25.1

