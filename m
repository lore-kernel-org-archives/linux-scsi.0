Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB92CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbjIEXS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239411AbjIEXS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:18:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8C6D2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:18:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtjMJ029203;
        Tue, 5 Sep 2023 23:16:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+iUM8H9ZtCIQfa6hAvBbhKdk1G4xw8DfNi2Eg6GoXcM=;
 b=A2kLz1bTxVzdc+GMCbAz40NJMiHgW3ubBqpcc6WN2dzKN9T84s1YGmh/rDi4DSnDapg/
 TdaVOmtnUdJ0eGdTgKRBsYHE0LAciu1hxXdQgmifzwog2DfVpR3nn/uHc0Ku1E+pYXe0
 QuF2ZVjqtxgIAgkMxwdzKH0AZDwWKWXdbeY9LarJukDX3vQNzXd0mW2GfaDuNTK+si4N
 Ccyc3KcKIa6LidFvY2RYmOjmnepd8NUSnrFVB8X4aLxNH3LRc+fTt3oBfe9W5xUHNh5/
 AV5HlQF3HC+L0lOoguSShhZIIoMQpnZMpAq51JT6OApDF24Q1FtIiz3XxmXEXozhcono tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdj500vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MA0Xs007688;
        Tue, 5 Sep 2023 23:16:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5exhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bigd4AoAvfaLwWF9gLnRKFe8kBiBsIpb/JshQQ2CoJB9bUH0vRHVmXRqGpg+ZP7nmeSR51qbTll7tOt5pBHmRWmnMfA9KvAHrwqcR4cA+Wq4WHvLmjVI0lD0u6aaN/SNILu/Bj0CNe5ZGyqIVuae6TGt3HPWTzCAiA7uP+FDiCr85W14buAiblwkgR/Se5lVa46MgoWLk144IracHbKcfCnwk5wzxEKwTRVxtcACqET84lJ6UHu+CHOcq06RVT8pyGFktV20CROoPaRynVD/qLPeVCjINFIARpNVTToo1W2A2ms5cuDbWiyrCKlS924uZsZ10ZSNV/DnPiojp/lBJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iUM8H9ZtCIQfa6hAvBbhKdk1G4xw8DfNi2Eg6GoXcM=;
 b=hZI2qo04S13IgAg0b+FOpvch25i+ENxshhQQPvW9j+ZAi2Etzk7ItSS7AeouyJNWGW2gWZZN6nE6+RoQJNxui2L/ZtyiO1lue2zjYfLuq8ehryJnAxUZQ+OrBGCkKgBKy7sK2EpcDJI5QanF4mFoYN7tz2eK7szXsbMdQPRavCLt0J+xbsrdWVzoSnOzF+Yly18HrX5UfT2EmMxViTDFCiaagx6VnHs7JDTXH67qg3hlaz3ydlFNWHsNPgwZykrMwVVvJ5hWV40o9n9P8RyrmYQtvxVZ1jaJz6zvltjMTz9tD3uqPefgwWstTNdwZnG3D4Xcx1HI+AvjQBtIv4c0aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+iUM8H9ZtCIQfa6hAvBbhKdk1G4xw8DfNi2Eg6GoXcM=;
 b=lx1IziX57pGZTXzvrmTyTGDyyxCWdyWgnMohtc9haJf8+yVVJ9qdQAIsdJeNzSmxD8S1oI6ycT3/gvoPHNQW+PS//1p6kKm78P2xnIREHVMHU5qHtof9C+hxAj6g4AWVbGbJMaJXY7/2zs65T/tzGpZ7zxekIUT0B6kpzLiZx0k=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 12/34] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Tue,  5 Sep 2023 18:15:25 -0500
Message-Id: <20230905231547.83945-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:5:333::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dfaa8c8-9cb5-487f-fd94-08dbae6615c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4I6WnZwa45Ac0ljarHKadFmCa+C0ZZrP0C7vw4zQTtAeLDKRdYKfDyiXbzYM4D/8pJ3uObigZVlsqTErJy5/HAgB8gL1brE1wU/KN5p6pvJ61jEGXrDbpWBmmc98hDsV0UtnycPWyujq9jszVn7k/BSuvFIG9QtTXblSssl5RDvoQYgl729TZFEotC6AzDLsJzDSMOkESH6TEuSESktr8uuHXDc/cBA7RhoRlH+ewjf5ZAbEIQIE5O3bgamo5bWV8OTe4SFyP7fhRVW9HMLK0Pj81y8ZCE1EJv3eQZNtbGMY+0/ZSD+KvIjOg6HER6GV4usr/TqFXYfxbAawTMjdsq+Fu4UsYCVTKRMqsn10DWUfPMwtciccEJZUDG0+z+mvm7bXjvAtYHDiFD9tDzy1mjL88I2FvDDgIjgCYnv78NV8f7nBHNt8cc5NiA1Qi0vGJQSm6dE1uQZJucRr78AS1tx8e3xLFLz4VbmQGXwqxX3t01noqn0v1hcjjtDPpFLyWU0NvmIXnarybCABzlkpF9tWQN0YgnVm8Y0pH+PhvMhOgJ/JTMeMfPvReiCqDQr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pA5kh7dNX1R4Jg1joEp+l81wnBmjFLj9/lCNevU3ZggEQoFvoXd7VnqcW/rL?=
 =?us-ascii?Q?G6nWH7yhfBSmbshQYzHx0ZxzpHeacsuVwPQUOPGzuTIwaFGA5yLE4itCabFZ?=
 =?us-ascii?Q?H8En9Tv8r5KEre/5z8CyUqdxVLfLwMbaYUc6U3UDEa9PTcmXhQ1elbpvB/9u?=
 =?us-ascii?Q?NPWjA+L7eO+QP+C6+ppokDqlkZo3a+8Amnv6OcjcoBDUQC+DGuv2FU/Y69kF?=
 =?us-ascii?Q?fx1k6g38QWf1WJHB1sKFqn3Ap5xLrwVaNr1MELjaRnQ67MR2wcq0mszKm7kt?=
 =?us-ascii?Q?vHNtkMQOIzhuG3ni19ud0Q+/Ed10duPT/CigBVEsHJePX2oLQA//7K0lngYG?=
 =?us-ascii?Q?EsYKmNJt0e75M1Wq+aXaYHdzjghpnpvMeuiOiF5fWYVj67WYbKDfZ/QsD6IT?=
 =?us-ascii?Q?74I8W6Rj/ahC/XJqq3n0M5hJDqIAnKtZxcguw8CeWZKjFBBqpED+iEU5I0M9?=
 =?us-ascii?Q?9+hXJVsBepn31A3Fjo9mdRd/zQKv/IXmm7DmQGm44HRI8qBsJ0PlkaHMY0Ce?=
 =?us-ascii?Q?FKxTfK77ybq8WZ3UHenzkqeM07xYu1jCzFNH+BP6+iuNE3R5AbX45vh+rHvY?=
 =?us-ascii?Q?oVp7XTqy6IBtKneHGwKVHYKd+7bYYSrDkulbFbPotFf8RVtw07R5r6+cCu+1?=
 =?us-ascii?Q?T5dx2dEHw4q1FPxA5xRnXCet4loVOoSvtSPZL6UpOXWYwFrQm2IF6jYN3sgm?=
 =?us-ascii?Q?LxwvWhN0YkrGin+NKPUSkYxc6/Jg5z6XvYLbnX3QANXbcv+xzIMBRqGy4hCI?=
 =?us-ascii?Q?gEbgsLqWI93wmtCMIh2Wo0AL+S4MMxtfJJ1nvbWhD854Y0f395NFVCjX1cGZ?=
 =?us-ascii?Q?YxQ4dpa+ZtE04wCBcEhJCB3J3cDsAKBLdjPdWXghhuS0EE7U6rIWqbhXYHcX?=
 =?us-ascii?Q?nGwBVe8EL2vMIRQPY2KrjPr3JnPhKM32wuRRs5xmaAtIOO9cjT3YfFg+sNGL?=
 =?us-ascii?Q?VZwd/T/uDEXEfpXZod26XskmD5feSUc26ZMfqkTZW7LMm+UmFA6dZYJxbf4n?=
 =?us-ascii?Q?nPUSFTpQAVQHsP0HZe+gStduXgoU9r/qdViWcSvUbOW6fwqp5dFTFB8pQXHy?=
 =?us-ascii?Q?z6v4yPMdsQruKQTsLT1glCXQNF1563pXLBFismzHpKxFX/KvasZT/TT3/XiK?=
 =?us-ascii?Q?l9TmXWFMfPET1FWnqTaiG43I/fUKTVmC+MckLsmv/FAIH4yAHL+vKg+lejFk?=
 =?us-ascii?Q?KTeoWdm4VUul+KBa3lPa0ixOyHEgScT6GNq4l8I+c/LKNxDiXg1gQIUy82lm?=
 =?us-ascii?Q?jb/1wni06xv5Xt3Hx536euxnCNeF4Y0T0Vln3nK6/wiMiyqEY2sgwwBUoLqZ?=
 =?us-ascii?Q?ha8G/8vECO+VouxDemD0DUAqBrwel/s4VOysdxt6VjNMtzrzIDtL9gkM8aou?=
 =?us-ascii?Q?q8WV/YhWR/9SFOtVdi0crLdIPlkb8B+2M1hmcHiCSIEztwR2l7utZ0kD4rnP?=
 =?us-ascii?Q?0shMy8ATKss4y9G5s1DhzA2zq8JXz3pw4fLDJ4IYxldMb+tgY6gR9It41h+r?=
 =?us-ascii?Q?pxD3R9x6/0JDGSbFDEhy9jNCMrZQufetU2B5Z+J9dUynGdb4qnFJIfXQHb1H?=
 =?us-ascii?Q?Im21QS/0vvYg3KmH1mqMibgBLIou91/y4watt2/2a92jT3T2B+IKRAgpwXe+?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0HIUGQPgsxI5/Jq3yJR3d6thCQrK+b3rYofhvqj2TZ8sjbxLUKW5L4Fgr2VHZr1qggqJGKUxxFSt9QF9HCflMQsa42/DTBitfl3BZx902MxFjzDH/tVkQRiTnaF+z9iZh6YnWhPkWOKB63XZYFc+nUvICCaZN1N12lJLittOrS0vf+IqIJWVvw7H/dtXEI4tV1ISR98sEWYENnq8lW5Uoopa0Ktdpg0tHhLgohMZTRt47m6YHTX1OTZMVnVj2Kndg8GqU9O9/wx7OeWPZEz8DI0z8OFczQunCBa9es+NsYP06R5psFKxcvhezx56I/KYJVp7jGDco6P7SvowRFXTVColxKX4Jq5hT4h5dqbpYx0TKKBPaSR5RO/Q6b2n6wL76goPadaFvwK/WENbIzafxitOk/f02UZjhHB+0hL4UGpCnwmPPeLVcdPP4Ie8gUstJvvp8y9/4AkoDBdtSEmAVxDKzEX/CvcAfz3vbt+Avxg4jwYjNB1uQaeEwE+t4XPexGzfKG/XVk+qhgyKR41Gg1IghoBX3OnLN1XfYAevthWTWb17O/Kv/buVNWIjYxykCQAyGJo9XzhhzO3I0tC0HX7Gspt/ZF6Dv+MzuvFN8HY9cChhv8DA4ah4Vh+FvO1atbYM6KsZWBjh+f9oIyBqICFktkTdRBCTyt2S9qfzmUuyt6bzVCP5RFnrwg+bkdOA0iwhHJ1QiXNv2mKQcLMcaO1xMbIuGFsBjIJKyL74/6ieXcDDlpHYj48LqHQWOZCKxlW7ppLbmniEoBQvruIt4tXe8jmth5/is6SC8CafVamun5AMOuxVyuFIWMmTK3nEawSE+vhNDI/8Kz41HhqZrlYUFCN4t1O+ftv4yP+MY3gUaZf1nPUGmeWJZUmam5IV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dfaa8c8-9cb5-487f-fd94-08dbae6615c8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:07.9903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvW9bWIaPfwxcA8BCco0Pjd/F/rTBhqNxsYa1DDfQZfRGD1XmBjAKDolH/H6HuTDfmOKejHD6SSfYbM8cSY/2hFGMEKSotBbcCtK4+WSl2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: xM37i056xIXzCwTc-wCRW32zkuoyHjdB
X-Proofpoint-ORIG-GUID: xM37i056xIXzCwTc-wCRW32zkuoyHjdB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 43 +++++++++++++--------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 944ea4e0cc45..d31db178875c 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,21 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -104,9 +111,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		ret = SCSI_DH_IO;
 	}
 
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
-
 	return ret;
 }
 
@@ -122,14 +126,28 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (!res) {
@@ -144,13 +162,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	switch (sshdr.sense_key) {
 	case NOT_READY:
 		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-			/*
-			 * LUN not ready - manual intervention required
-			 *
-			 * Switch-over in progress, retry.
-			 */
-			if (--retry_cnt)
-				goto retry;
 			rc = SCSI_DH_RETRY;
 			break;
 		}
-- 
2.34.1

