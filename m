Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE328C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 05:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiAYFlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:41:37 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42470 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235105AbiAYFjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 00:39:06 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P1CiPD022865;
        Tue, 25 Jan 2022 05:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ACcHNBDZJ4cse2E8YCE3u5L8UkoNxAl+PVEbofc096k=;
 b=EDnYYkDElWQBQQ0b9bLbGnH41A8aI2k25l2q+0jj/F1MnnMwMEa2Ki5cyXzuv5lWI5rF
 uIM+l7cvx9qEfYWaSw2/OpHD02zho9JLvJ9hWfFiCLGhP7Ko6Di22d5kalkeMXd3Cty7
 4hzn2kHwTwbbuWW5cwx0l4rDGIDOiHEYtoR9+y3FuzID2aEYc1TbbzYwBfWLaJzz5fDV
 g595b4U6JSlbKv+YR8yIKxgonfWo2qQMBBiPjA/ckMIXaGOGW5VH2N2bv5IUvpR8ii87
 auboH9b0hQVE601m+7viWNmJj1nU6UOoUF/IVGlORwNbdxRGfqpff4RZqb8K+YrEBCH2 tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsvmjad4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:38:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P5aiIn071821;
        Tue, 25 Jan 2022 05:38:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3dtax5rqxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:38:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHbdqTCmLo+5hotr81MjButuYr75BsG72d9QOLIhoRrfZ8ACpbrtyh5cANoi/kHrZ99w+Q3COcB0iFlvfzvdrGOEa1XVA7qu0KomOdEqXPjO4UYWoB7y4/oQ1auKmc2rOdqTbZojmmNcNlEFo0rRHo4uGsgMXTqxk5RVDTtvptXqv33GTJjiHOJyHBTrJpPMmDiAS2WBFddbgY2lMmK8WuHsVPiihxyb2ELmGUJ/lja+dj3CUC6t/uREJ80Q3mD0RqYeSdoi4nI280Z/KEaokb3/tp7Pr6H1qQ+ZvRwb7p5AeSTYDTnkleMccAT3UI1ZdeKWlFkXGxSIHvkCKKziSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACcHNBDZJ4cse2E8YCE3u5L8UkoNxAl+PVEbofc096k=;
 b=JPQuGoaZaU40x4IlueOqBU11giO4pTIqGUNjrSNsNErnULI+0EBA9kD/k2mEufox66x8znkzJwxjH/COkI/glDCPRSkCIyIxU2+nQE2X8TBg2BKyX1WOUATVLSFH24R2oFNMLCCDcO2UxhUvTmn8AArvFhBWwuGCZwFBo/SGDwIt4073tz17po+a6lMctAsCPvlu2tq+WqfsnTeLKWs2/1nyJOB5OBPMmYC6JErXxOOqwyzjkc5RY7LX7OPnVaKkTmgS+K3en/YMsBRKJKHv7FdUC7nh3P7TrqJxYuM8IOeM0Tw9Om/Qmm8Z++JiJhUy5nGSb216H0DZfKPbNG5J0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACcHNBDZJ4cse2E8YCE3u5L8UkoNxAl+PVEbofc096k=;
 b=boU1gk+Ixzxx9/SAXQudHe0xoRbMRr1YIQaCXIaFKUu8QDW9MeY1wTdrXW5g7heoX84+gRqkXrK8Zo6zyAPpdMzgQD+Lq5kZO9fEcNgRs6QQuAd8gxMG0UVZNvvpmK0FQrHIIgugGKYSAe66hIlkfZoGDycPIu1nyUZBR90sfmU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB3939.namprd10.prod.outlook.com (2603:10b6:a03:1f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 05:38:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 05:38:49 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v2 0/9] scsi_debug: collection of additions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k5sgz57.fsf@ca-mkp.ca.oracle.com>
References: <20220109012853.301953-1-dgilbert@interlog.com>
Date:   Tue, 25 Jan 2022 00:38:46 -0500
In-Reply-To: <20220109012853.301953-1-dgilbert@interlog.com> (Douglas
        Gilbert's message of "Sat, 8 Jan 2022 20:28:44 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:40::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfae5817-f6a9-4f66-36e5-08d9dfc4f657
X-MS-TrafficTypeDiagnostic: BY5PR10MB3939:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB393901544B6B796C0CCBDD6D8E5F9@BY5PR10MB3939.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hsPx3Mx/dF0R5WFi+9xyWQbEHlUbLLUCxWVWFuljvjfi0h7Bse6fjOCBvuqvrMy1bqPETz6D/04Qkx1z9wkqB+XMmUuS72MpTCkaX3w2dLTGOIQCUAd0AOs7xyyNCdGCgwdT7ebMmtvFh1PBidrg4SzphIk8H0xPg8FsaDkeBmNDWLBT0KnkwsKUg9r/LaTrdhpBr16X/lGzyhXwrRB/hwrmOiOR+zvvz1480TOSqrVRUsIyNJCzRGiOnZY7ozb9nVyTIJTJ2hk+So0G0a5WOF7/5WYrFCbF1grl6ejhW1cH8d5fB/MTqnUbpSDQuq3O6Yf4VKsebSKn5dh2lTgFij5g3cXJv6tRD1s7JIzdN7FTw/lHuQlUwgdq53qlPtebFRf4w02Bhc2ZJ2vazvLhP5XM3Pa+YBFVxDybOBitBrLCtXHPIyBuRe32VFpb7ptDOhtu5c7DYfyfyAoKn7Ml0VYVlYUlznn1TvH5TADQCqu7ynwXRToMtPFPOXztgoqAWSoR1xbGDJe0j6eLXWa2dzr4Wx6K/0fzNWP2UR4FY8Axv13ukRxGO9igrhGRg9fqz5PQzvu/QGPPB7uCvjaNcDo2NMuSgjf6TvWGN1srgpe9YqHTAmkfA5PYIU2kX4gULRtS1RGE/hx5TN4fXOP/6sdApy8ww5cClB/dmQnySELFnebHXF3FBA9R1T2WuC0XhejlKR40f7SSvwlLvMwLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(186003)(26005)(38100700002)(66476007)(66946007)(66556008)(2906002)(8936002)(5660300002)(558084003)(8676002)(4326008)(508600001)(6916009)(52116002)(36916002)(316002)(86362001)(6506007)(6512007)(6666004)(6486002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NvbGRAgV9P9pxsjSRfhmloJmgmrX2xns3C61+oM/fu2UyMGWvG2+GjhVd0iE?=
 =?us-ascii?Q?kmhIQ3mhs+qfnkx+WCbiL71iA/wjctIbPo/OIJX5ER5is7UUw14nnScHhjpZ?=
 =?us-ascii?Q?lc8SF5KmglXNHgMoCaG9K8KDG8Uc784UGfZ6+PCo9YgfNaIVBhw8Elx7F/eO?=
 =?us-ascii?Q?Mtvvv1w7CqOm4vIdJkMzO8NhnstXg5r6ymIIfXSNbPV9MQHnpUlGTgpUbJc7?=
 =?us-ascii?Q?PQc2f004BHtpkkV1/6t1MChhKrp+9VGRS2kfe4MS6O7WufMuJvsg77IYSSMX?=
 =?us-ascii?Q?O3FK6hU48obR39SVl0rXWyxtInFD5zI6GbBQZ4rfJW2QEd3kovzpLWAxL+o8?=
 =?us-ascii?Q?MRemei5eTGjzIWOyHogsumD09Q+KLxG3qfzYII9CnidBfnE9KMq9P2z3ikpa?=
 =?us-ascii?Q?AL6xJwBsSpaQymwL3g7xFrjSJfKAJVIbCvlGx2pgf0XDEOINs70bd/+BT+2v?=
 =?us-ascii?Q?7Q866BR/HTbXcaFDxVf6FnSUBWubfLbstKDQ3y1JPzOAHao5iuD7bHCug8mQ?=
 =?us-ascii?Q?Il3qJ4WsbEi55+x01/eEIUIE7v2MBaGBJF/czR/ToPpyjN8nhsKtjzMBA7hq?=
 =?us-ascii?Q?10iWjyKYrkpLbImN22ZBzrqRg0lxijaJt1s7ssogsv0/5OAtEvlTrijRNaGF?=
 =?us-ascii?Q?hslfi+fEuZNFiZBoPai8e9RhJ8xumPJQFNaUqnwpLSbVDNPHEJSy8qT5dLmX?=
 =?us-ascii?Q?SITIGYdzMSo7E2c1wg0gHk3Lr/7RIiCWXUtignj+YfhQVLJVo3DiTgIJMYtk?=
 =?us-ascii?Q?NK9VMe5TcbY5kT7u4DdGAwTCv4CAq29b/r5RV2gFXzvcMujQuWA5f1IrwQjh?=
 =?us-ascii?Q?edj3XlDelaolq2hcnAUeS8/UghA0rJ4EUW2gdTKdxZTWW+ZLeuH3d6LRa1DQ?=
 =?us-ascii?Q?Z/IwiRX4iAyRrwV6nSgxmxbkWzaz9AEt5narhnFsjIUkH3KXOr7oxBv9iHVr?=
 =?us-ascii?Q?7Tsvnc+ZcnNRan10Q7Th2G+CUXmMhtOQrJ59CoaipLmhGSbM+GL3rZJcu67k?=
 =?us-ascii?Q?cSJS0wRAHo864/PampjlGEMDUWF+Pzp+bX8dm19Th7pEvs16gE05Ou0SBiJa?=
 =?us-ascii?Q?Q8OOWe9SZUp3EQ+2SzJ+gIcMamC8ZcRwS9018ZkpWQXQF80OB7DDF1+6DoEl?=
 =?us-ascii?Q?/cmq479v1IUpPVtMe6T5PnlJpkTVyZ32Vt+wR7mnqlhDivOZT1iPbmfStj4j?=
 =?us-ascii?Q?UIJFoFYt7eJq/A39hlgr9pSv7iQHq8xazjvcy0dna47mbDx2Uc+SVRrFKSkl?=
 =?us-ascii?Q?10a0oU3BQ+05hjdrvypuMof3yi5T9sQmqtO/w4qdccxHl+9/cSIJckOoBIqM?=
 =?us-ascii?Q?6fl0GKvo3PQgNFZvZBWN5UP6lJxVZRmbuv1F7Yo5XuAWUcGhAhd3iX0ze/1v?=
 =?us-ascii?Q?tP8B6Ks2/c1oBTohpiI4DVRkACvoDRdi+igr3r7tmnxzaSpSLlJ76IZE9erm?=
 =?us-ascii?Q?AOmZtlSAFyRbIg3rPCHrSVjzSU38K0C19o9LgHNTFh+G2MJKlt8xt0FYl8gW?=
 =?us-ascii?Q?kQe1w0Ix15wdSv5oYaWjd3oIOxfth0MY4UMJ2jZUJVDEeH7o5/Ct7V1fPmSa?=
 =?us-ascii?Q?2V5/CNm+vC2TzhaIvxr5heYpNKaOGCmLiq+6PaGLFLbxS9i/9pY5dFEePjU6?=
 =?us-ascii?Q?MRBEYuJohMLOgyvXaQvQ1skMhnZn4mXn9qdTaelIGg8ZWv9v9mC1NTG+/scn?=
 =?us-ascii?Q?uNoJ0w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfae5817-f6a9-4f66-36e5-08d9dfc4f657
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 05:38:48.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNwmTDQeZJ9L+SOA9z+Rq3V6Dw4Bf3jA+ZOD5bKHFfNV0P0OdKUtORhexkSQo0grUIk1OWNKpb1LVaei89Jqk5zuJuMLpULxo5ccojZUTkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3939
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10237 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=951 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201250035
X-Proofpoint-GUID: 5x1JkSGh_OFAGY9PQWXIh20eyE1EjuRQ
X-Proofpoint-ORIG-GUID: 5x1JkSGh_OFAGY9PQWXIh20eyE1EjuRQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

Applied 1-6, 9 to 5.18/scsi-staging.

Patch 7 really needs to go into lib/scatterlist.c. Please revive the
effort of getting that approved. The patch can go through my tree with
patch 8 as justification but I do need an Acked-by:.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
