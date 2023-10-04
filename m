Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F40E936E6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244007AbjJDVC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243984AbjJDVCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE615F4
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ2BW028063;
        Wed, 4 Oct 2023 21:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=4BehMNM25HPiYjzmrTbBvlU+ugNxgLRhuXzqKHj0KOQ=;
 b=yqoMOTHR0qbWG+Km1aL6kZoRj9+zWnYysmrbSNiAawDtWoEQ9K3KIY27dwCuvQwY4NVA
 wsrcYj3O7YGYj9uiWemhSTwedimhD4UHaB/VCITGa5uXtnr1TkKyamKS1uvsvyKWrgK3
 m8Mda68Jnmw/Qaypj7evmtgouInZlKB/OpQB5atnIkoDB5rZ5GZsUC+V1jdHrSPz1GGg
 S55KeTDtEKYRv+EUk1ODB8vOLitBGlJdygEOVetBKgfpHBLmLiKTnh17Bk/dnlnsn0DX
 8mxRdiiR1DaZ+ACzd9Nundh8IhkvSZSNqqXdjq+FsI0h1hisxAVuvV+zWe68Xqtq+xSz MA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebjbyydk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394JbqWw010357;
        Wed, 4 Oct 2023 21:00:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3thcx5y4cj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUv0PaOAX+D3MIpoGCPJ72vZLogHBrvzV9slQKb4Hi+ecBYgANcFYUGc2Opuh5Y2+VT72G2xfnRhA6W9MdsHI8cWBfvHIlzFBaiV6cDaqsxLEqxxMp8PSnsCq1nTaPbnz1TgeU539pXYOb8emYBOHlC4K59eRlZfZs2H/0Of1MAKJv9BsoKNSlRqK11pkS5+NvAmmzi5KkffIia/KUwqnv9CgnoIqR7dC/RcSqRu9rm1eoOh2NVo0LQv0KwdKDFIsJEQz6f/7FB9zsR4kGaQNDer8ofsums8NF7UyFgZaGhoEc8/31FLBc8Oa4v4lavPPNVq0zHIj+iUrJG5IgivSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BehMNM25HPiYjzmrTbBvlU+ugNxgLRhuXzqKHj0KOQ=;
 b=C17YWTMXXh8u5j3vcuqsfVxt9pY4mIKeGWulokVYYIpMGn2ABiGlOHMmjvpymar3okscMeES32NxRrSkb8o+T81P91qVjr083P/FQBFMugFtlsIYNHCqALEkdvWCLC2C1AkYBLPR7K2AkZrR5kBHMn/STbxlFvDsYGUJ5qxTJ28q3pcAaJUHfBR2jruaxGOtXIueWDpvhVoPgN5TTXKO5B2jYC+xgMTHhhVW/aD9+uMUbXm2xoxv+92cyqG4lBPwlNIzs9cg7ElNgrJXzIpup59cz4AtG8wHYbCnWKaNefsYTc2X3jvoJoKA1WRgnLrt2cN+f2h8bh6/mxv55dXGpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BehMNM25HPiYjzmrTbBvlU+ugNxgLRhuXzqKHj0KOQ=;
 b=VkSzvPWq2Ewodqubfd3mqs9cEzxpv97XYEgnSkpBHXo2IXsrC+y+Iq80VB6/LLwXwFWd/SqaZ/gQFa1KyvKdlJoGSzHIpRZ/GsSed+14gCofGMvt4ZfE5n9AR7fJ+VQ+/IYc71Gz46iExIFdJw5mrgEtu4qx0HFh3VfvgGZaiXA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Wed, 4 Oct
 2023 21:00:36 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 10/12] scsi: Fix sshdr use in scsi_cdl_enable
Date:   Wed,  4 Oct 2023 16:00:11 -0500
Message-Id: <20231004210013.5601-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0029.prod.exchangelabs.com (2603:10b6:5:296::34)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b354dc7-785d-489f-ac3c-08dbc51cf4c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/iW+Slev+LWkpdCtc8ihYz1/1iJrmOdYgCRkJNCAQjOm6gwF08dafACIaVCuCGMW8HYRbyVmfIAMXE6IKx+xPO64g546UBXOeCE4aapfLl+lS8i+w488Bc4Ue/qhv3A31tY6WSAoB7buyX3+4bu5gBL9f43dW1PRQFDLxUDcq5JkopswTxVpzG6PHh0xbz9c781gLAu6OvVCAzIOxM9Rvj3n0ddLEW/+07MaehBLLA4VsrqeOyhXxm8LmyTezUiUKQB8bvqeQ6kkERJLtc6YBh41aIA8ca3m7AWmD2zewzKjenqSJorc/5meLNabcJMdkP/N7pAqPTUKmWzuEN0DpDl+4EO5ja2GKX/gSdM/Z1V8VJHm37ZTVxw11AhbQRe3HkH3LJUAmXGCRogsk71wfjQm7GAY17XqKdcZ/mZqzRjT3UPQ3Rbu9xfuyslo+T0IXc3Ogl8G81dXdCyTN1UdY22hVaVDQfjtA+qNMP0thGfzs3VfArHH77rqaoCmegque08CVlY6kNnEj4ziv4ad/QpYC+1mPHWThIEubaEmpyNX3V/jmxS+W7MW02EQl4l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(38100700002)(6506007)(6512007)(2616005)(86362001)(36756003)(1076003)(26005)(2906002)(83380400001)(5660300002)(478600001)(6486002)(41300700001)(66556008)(4326008)(316002)(8936002)(107886003)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WK4wjNGdQ8EQojd9jvpSQIPaXO0Bg5gVfnN2mfZDCUiy1udBTZMIIssOs6/Z?=
 =?us-ascii?Q?vW9PTieIAgyqJ5ADjT3jnh1BLChOlajApHz/6w5B4EYEdiBl1OmPvyNpZv2O?=
 =?us-ascii?Q?3PY6HN0mRwlt9CC7EKbwFcGK9xf33yZMRH2o1wI6mPeJ39y2U0RHhqQTnIM4?=
 =?us-ascii?Q?Z9hSIeBjM7j/Zdq2HGDGnekMw/lceXHnTnt7Ahqc23Sq+KJcdpT1pykjh3IQ?=
 =?us-ascii?Q?oNeMbZpOS2a7Uv8lfeSmn5hCLOD47AKPOvwD7aKHgcS1fd+J3Xnu5ldAIWx6?=
 =?us-ascii?Q?XJtocIpRMQhCzxCKrKjURXVUFRoGAR2mTJzcJxmrjrlPpxaqk1OLUN+32CxZ?=
 =?us-ascii?Q?eoADS1DM1rnwEj23uyrX9yU1V1at91sKDxVigEHzJc1xKqZ3GbdsNicQDaG1?=
 =?us-ascii?Q?OQzeCj3w5cyNMPAYgMP9He+9RbOXT/1mwLOgeh+U50/TZmuke9UoyKS0SFAq?=
 =?us-ascii?Q?QVAN61IzhdDd0rWcn2rxbcq9kIdIlNUFlfg6qt7/htdr+3RT4YyFcRWs4xSE?=
 =?us-ascii?Q?FWvUUaXrAV0QhrlCMa6+aIzXd1eRAmO/ZSzHcRkIZxFfGR7ba0D+IkFaIUW5?=
 =?us-ascii?Q?yZJo/J8nhmcCTlvReYKw0shJjrHU45kfC0JWbJzXapziEUtIFvY4lFmnA1xW?=
 =?us-ascii?Q?iFTBVtiFHVsbNCXycWm8GjRABSFeOBO7be1CW47wzgkkiXd44LVuB10L8Sov?=
 =?us-ascii?Q?ONA6IJarxVU+zHaEOK5nrzqb2flHT7FSuwC61/lb5uH1LLpB9OmaY3k4rxEw?=
 =?us-ascii?Q?wpukhF1FQt0AS44iJkXAFMqjY9lJUpBVehBxJ5RDAPHVKut1oUzBhQmfl0Np?=
 =?us-ascii?Q?b7cAvD/9su2lrELkyP+do/2XQtqd1zuKmJ8wQwRySFIX33uD2fGMf+LDxGbB?=
 =?us-ascii?Q?vob3hJgBY4Ou68yda1jkJ34dndY9H+lk8Txg/D0BjEkgssvWBTWrusRlcKum?=
 =?us-ascii?Q?kpYf2sJJ4ElWAZYZ4CIIqV9Qm2ZVnP4Tm1k1tXUdZhMXinjO4kOGhxw9Mjz4?=
 =?us-ascii?Q?MlVd95B4tT0Uljb9COUZNVZ/yaHvRThKpvr+c2jc2Ii7nvDX/pilssDL56IY?=
 =?us-ascii?Q?Oe7iWYNzgTYky3luvbpMfU8DN0jqtR2pRe+z57ZKs7ilzAuWrmGYlNDtLvwR?=
 =?us-ascii?Q?v+TRPZ6+Vl7KxpQzK3PchVtzhPtuWrs9LsLxVLKLtwB5AnkFzjYnBLHsVIvU?=
 =?us-ascii?Q?xEBC56NeFSe0OhmYyyB66TkfaXKqeYcNL2agZ6NbAU45Yd3yZJPaB+7owpq6?=
 =?us-ascii?Q?vcuitQ7ktD4Vkxv4rY1sVCyxBZf5g1tQz12Obca7L7RhHibMvFTNUpSM+K1g?=
 =?us-ascii?Q?ZrTx520TkEAtuC7NpXq+nhEgTCOHFmeiEtHBxFJQRfZCfjZ0A7ApqGQ0SqH6?=
 =?us-ascii?Q?McZOuG7n+ItLBOVWMzhPznfhY+9fw7WrNs9ougeTjm0jBQq6sPIo4aWeIIDv?=
 =?us-ascii?Q?FCj+/QKXq81So7HI8KhmbQdAR7s/3v04S5yNPAqxbkAggsjUtj4qCTJPhJcn?=
 =?us-ascii?Q?jbrw5KSQJmzyD0ejRMMms8n2HtzBMd6TQcwxluHDkhvGaPiHIPnYQhO9fgJJ?=
 =?us-ascii?Q?z+zzjZK4UCVL/6/3cMRpU+g/dZdCZb+sVx3P+vs0BAmdkHkefviocpMcXAiI?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sBXjGUp+olSBFkpFgSClo4DeFfUX9dc7Ix0Fgb5tGAU0PyHpGg2YGm24Ezk94ZZcvW6wuc/U8nq5JphbK9H/xyLwscQBDIcwHdbjoCXmY77x0+T6eFnMOIk47p/t4g4Ma5K8KsRw0E74fDCj2Dc3wXcSr4q4FCnS63LJ2KgSzbhXYMs5jUrNPWyiiV/vWDjdmpUD0Z1non7kw2JCZktFUfSqIuxGLAwUa5p9jlyyE30yFmZxIrIkpYsy7gTvHQgECdPLemCQBk9yzLnm4Xz0QkD6sQlOZCKjf50kz7Evz2STP8yrTskY2oxQgzXaAdDLfgkQ8FCCCMtRZgFAJuQbtNLNV9ded8v3MSiOK8X6af3ieraLYiPBi+l/hQ95yCMkeQRuKlLBWEwgb5l9IFgycWP3SSmPC8CqepBOa65Dihj6knQ55oFjAsOqswR9ge2cRGegPtYJ17pY95htgumZQonTWOCPtoplJuCFRH9QXBZsCb+L4v/39eCAdG9RrIk3jUM3thF6aY/r+30B2M95TjN/hvDg+4tQoK/pDnC6LEuem2Ukf9FwU/qGSym+HxijyXyXF1s7h0iPmV3vjXkhnrJ65L61MXU3tBqT+SfHIA6UXSnVL1kCC7MWLR/Uo/SiAKV8E00FqPSlt2Gng0ehtc1UrLWvwrzM1wmx9Jz1ZoAeCj3NEA5IQwOmHfZTqagJCgg5dz7Dt/sAbufl6IDUTYaxcXz7+OhSdn480wiVbFRZ8QTeOKU3B9ubr8U/7yTArgxd0DB488doXiFvx8ymYRd3gdzqekOUrvg1oQgIN9CitvZ7qVILosGzYW2B0fNrGMBSip1lfG4uKKHwUOGFONelQeYzA0Lj0u41a92sbeRKjXzX+hEJZorrBMrnKrsv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b354dc7-785d-489f-ac3c-08dbc51cf4c9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:36.0518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+R0rMJnOyMPM89v1V6oFBBRE/jlsuSB5LEJhRqNRpIC3sLdrxFo0ZZUoyQbfFrTKKKC4lZh7EI5MT4gKV3SlpZliDtXm2jzu48M540+LEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: a--9sXnlCmiFOEbI1LcFy_7D_gGxzwTM
X-Proofpoint-ORIG-GUID: a--9sXnlCmiFOEbI1LcFy_7D_gGxzwTM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 89367c4bf0ef..76d369343c7a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -703,7 +703,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
 		if (ret) {
-			if (scsi_sense_valid(&sshdr))
+			if (ret > 0 && scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdev,
 					dev_name(&sdev->sdev_gendev), &sshdr);
 			return ret;
-- 
2.34.1

