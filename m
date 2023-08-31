Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCEFC83F14
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbjHaBQq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244134AbjHaBQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:16:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8202BCFE
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:16:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0Dv1O025899;
        Thu, 31 Aug 2023 01:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=U7TpOrPV9FoEXMxJWYEuWY/xQB1C4qUzI1ZaFyyPrYo=;
 b=fQ23A34znAC5d5n+0o1wvTXkeV95a31uGRD20g65gza9C21nLcGmHLfCblpY3Hb/2CEu
 9iAr9R0ud6W472aHHDCZ+uBYSeMKGLz9qvdv11BSZHrpD6qCCtyB3yBJ73EaHCErUkcZ
 Mt1TeXUQzVULjiNb75OuSaG7zN/AfUKgf3WI2dTPvz+i0WF4hzQ1XCbk3PBP4mdIg92O
 tIEll3pVJy5HGTZt7R09xSfnw75h6yOETo6CslchoGcGJXZ8mI0qH3RyodrONBTnbOYh
 9KOLGD9kIuFC4+qsG8ztN+nlIu0cNKoDMJd8n+rhL7rc/K3Bq/mJ8E9ZUTJorkPb2/AJ /Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9k68rgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:16:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37UNs35B014286;
        Thu, 31 Aug 2023 01:16:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6hqa2h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKFmmAhBpyw/gE0hanFIAWMmdBpUYR3tIKyNHFQoTB1nUxAB8LjhvSv5+uEab38QB9UL/5ZVGj9rE4BOO591FxwZAVaQfX56s6tV99E44IoWLScENowWtS7j93exJiiniq1xJCJmR13544iGGDcG0uSZbamFCnOEvBZ3qH1ZEZ6pT7iDQ82wI8Zk6CApCP8BwiBuD/+qy1teq7aEos8e5UwuDx+UDeyhq2A+eg00z7pvQ+Dum1sIKHanv/KPo6BKcE5wXnYs2/S1BQsXMnycP5eqSvV1XJ3+wkoXqoDcYFraiOQ9LD7mn1nPVA2MrO1GoXWfEDOfEgFAEbuaJ1ROgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7TpOrPV9FoEXMxJWYEuWY/xQB1C4qUzI1ZaFyyPrYo=;
 b=NBjpTbtIA0vY89g3dbJ7gXa7OfbdwdYY9VBohKPchGjsrCkILw53zJAefqffykgTG9VfSmzWP+jfCx0fHdx15SwrXT2bD9350umvTnYT6a6LvA0/Slt7iuidI3/t0VDdT9u+BmESwtejLf+0dWfeSaoaSeJ+kZj8h5IK8hEIfNKTbPMCCKCJh9K31F0lbmdXzMkfQJ7jNOg0Y+ytU0TiCC2VMrrhjOZIFRtwSgtCrMojjjxjDcfhGJRa6K1WUUYRMxRD3r3RIntJuzyd2oVUWXbmPOg8oxjwW1uCOTNYcmbnoIAKJV6mSgU4nwpBKqus+il6ae1F5ZufTs1twkLt/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7TpOrPV9FoEXMxJWYEuWY/xQB1C4qUzI1ZaFyyPrYo=;
 b=zPoi98jVas/gI6tCQC5W2Qf6WHmf8uLS4v6IB/RtbcZkWyUte1v2aUj40wJDZj8y3QPRHNWc0gff5v9V45pq5xzz3rbPQaoxWLrmPlPPadopZyM0nzjpRcwzO4chk0ZPcn433b+poWIFEZOg2yUEz/4NtcqWx6qNV0YLDrQqdQ4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6316.namprd10.prod.outlook.com (2603:10b6:510:1cf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.36; Thu, 31 Aug
 2023 01:16:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.035; Thu, 31 Aug 2023
 01:16:21 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Fix the build for the old ARM OABI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15y4wui3p.fsf@ca-mkp.ca.oracle.com>
References: <20230829163547.1200183-1-bvanassche@acm.org>
Date:   Wed, 30 Aug 2023 21:16:18 -0400
In-Reply-To: <20230829163547.1200183-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 29 Aug 2023 09:35:42 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0285.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be38aa3-d7eb-4d97-7498-08dba9bfe296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PwhlvhdtFRDmgs7ZVQK5UI0GS8yxzIYDHgUryXvnHkwOOlc5IeJvOX93iifJMpiIIPI/6F2ZfORbb65Q56V1XjmQg8kmbHRox9bnhOw0yTMMgjOxa9Mazcai0yfOPMKlQq8xpAJi7GBnEvP71mClxpPMjn6YBSABPRRTUhaaAkI6o+jVSdp8p1XVAVdPum3cPKpF+qXY2fPGfNujR2xde2yUdDoz7XPFWvggRika5GrxPbIyfkBBUxy5CDkAg1Jay/9q4edTIbEVTc99RIJm2QB2G0b05BX26BDOzsOR607olMu9gCoq+MAvD+XcCAh+cfIRWw8djBcA7v0G1bdc4TQVheiax93244grA6olmztaE06mdU2bcRP2QesfdtUwMWmj/MQKi55A2mzBsfAr0vGakgDoTT0Py2cI08IeyxZ2R3izbvk9vhwQp9bg015U3PMvGcklsYMKVWPS3eppttTtJOJzcePZaqGvmUM5mOehpuqWXZwavwrkJIz0VkVHlhFLTXIraA6+FeuIMr5Nn8Fa6tCXUaO5HGqfSy3jJwBCmETzRfy2TktrM9ZmISrV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199024)(1800799009)(186009)(6512007)(38100700002)(41300700001)(316002)(4326008)(2906002)(86362001)(8676002)(558084003)(5660300002)(26005)(6916009)(8936002)(6666004)(66476007)(6486002)(6506007)(66946007)(66556008)(36916002)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XPlrRnmAp7JfE3mseiVz6aE6br+BI0NYKeLr65nj9YHrxcShfqFQEBNlch0S?=
 =?us-ascii?Q?6SyQ+hAObeJ5+UzVTaP9TenATvgsvEpYYvzKV7wLLp/x5EbzH5BRCy0RGauq?=
 =?us-ascii?Q?PLCCgTCR2Vbg0vU/TavOtf5RNyifeEEwCi7wK5ST/I6/FJdx4TyEOgteA3YW?=
 =?us-ascii?Q?xjXlzJJT14HKKNnowAA/7yaG8G+HVcvaG+/bBY3vucEOFGnaRCAhGjhhj+C+?=
 =?us-ascii?Q?mIWZlO/gVU+Dnpxz6vE4/qGSG8hZEpToequrApE986S08/SLtr7OAs2SzfK6?=
 =?us-ascii?Q?PmMP1WJHuMPYIhZ5a8pAAzizvv06WvPhvFg/AId0iYHxUWgezqasbT8BPj4M?=
 =?us-ascii?Q?6BNw0IW7G9INho0QgC60OwHNBubQzv4sAHnAtF263pd3kQZfyyhqd8K3/N4e?=
 =?us-ascii?Q?F5lsFMlvVWi53OPRUQ3d2EeyJ1syHt/3xFCK5cGmzLRmytvFkIAeLvSmWBiF?=
 =?us-ascii?Q?daCh2QE9Xa5lNvNVBssaVHAzZ1vaWVyVD0dD0T0e/JhWaZigZp5N7UTrjFA5?=
 =?us-ascii?Q?7DuygmhX/h8I8LesJjB6oeo7QUaIWRxlg0ykGmKKoA5Fp8Si1gDvawXyEUpW?=
 =?us-ascii?Q?E6L30NGx7IdDh+j2/NzTtwhNWqartnYZu92jakQ7iigDP8/MC6J7C9GSvtNd?=
 =?us-ascii?Q?YW0UgGe0AO0ERF21eusjXfw/zLqD/H/qNRuli9RYjzyMKMFtgFumXP02kfcM?=
 =?us-ascii?Q?00qd9jPVaClCpIPkozcBFqv4zhikPwTF+mQp3D5YeQRcayLHWLvwfDD9arJd?=
 =?us-ascii?Q?IbPPBmWTHZIeU3E5T1mC3ekD/eKJ65EOONP/5rc1XD5dM3cMgS3F7mzt5hUf?=
 =?us-ascii?Q?cqYxpen1uToaOFJ4bfjeRZl4fnGNBId/eIsPLuUxfA/+zDGhYeSZkIzhDrST?=
 =?us-ascii?Q?1A1aTDJrwXU8ks4AfjRB5WbtAw0keY1YPC2ox0+kl8GiLoJWg2mAm7jOptca?=
 =?us-ascii?Q?HNDuvgDMg9bYq65g8QzvdVd4D3IaWn9u8lNe5ulTD5i7ogn5ErcZplMnjarq?=
 =?us-ascii?Q?fBSepuLozUmP5hWSNJi/0SWSNiv3W3HcM+sTXcSLgdTBxtiePNoZ6AzCO60N?=
 =?us-ascii?Q?0Q4ej9nYGmFOb2SPkcVrmiR30Y+zCE/oiT+LAyYr3hx+GOSo4nvF17SwFbKe?=
 =?us-ascii?Q?2UIZZRx4ks4ozBqvJz6d4Qsup8KjSqtIZQPxVCxhvWUc/GNEkhCqwk1jHs0K?=
 =?us-ascii?Q?IWeKqC48s+nCtRnJzLRlXSvTBle6RuxNfp8+9I7yoiEGiO5rl13mbbfBd0yu?=
 =?us-ascii?Q?ZjTX4BskWhPVUV2xRa9jOc9718hLlRmYJZ5QL4pokCaAQed95vac/C5zPISF?=
 =?us-ascii?Q?+52sNy1HT36dsAfnJ0XjLXqohoDXvNPiftc4qRJQK0g+gbYccDf3kQ05m8N0?=
 =?us-ascii?Q?wxVuSClS+LXe3EftkcguOrtU1ZgfILs851crVahXDUZtGyzUFpR2EJaesGM9?=
 =?us-ascii?Q?dfpJ11sdjLxMllNyA+6eV6MRNiCJGnAoivPwLHbDWU95ZGkaxVkvQy6wEj9j?=
 =?us-ascii?Q?STMSxeNBlGGrn/zQd+NdO7YtTcA1ap0S3+XlkpYVmKgonvpI0F6SRj6N0lPE?=
 =?us-ascii?Q?XsA+Ob7JAWsiK5eEms1MQTpOPl9011dw9y/rCrGqyHKioEQ4jV1DbZMXv7j+?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YqYUEz8nKy6NcjGq9UGYB/HPx23MYpVlDZj6NzU9joxmognZMPt5OA7hrzk7Qc1G1X3Yx3Rw3WH4oFzF+YfDcgQ1+pN5fPhl00lB5PFmrfP1iaBX00jeZ4tMfVZuPJl9rkNNfLVwsw4IcT4C2dPIPGK15NyJBELjuLUwsRacIFnQxuJvYqzm8niRGyoPIqwob8gQ0IGjrJ6hTf2H4tSQrAMtPl2Y2mGrA//B6g5DDSAS9lzdzknyGe5fd1iam8Whb0JTlzWSIOtV/o8VXnipDV/k3/6eaPt18xboByZG6L4ngogsNp/J7cLmj1bCJVy6INRaxg8z+I6tOZL+PFdNzsffmUovgZKEk5EQ3EFHMgRP5k3n/pUEBnmtLI7l77/9TL/NGVid/hV2iUFeHPSKqKn8ooHhWDlNqJ5NAGjeBiKDNaEfP6Sn++GQC2csTinnTla8kIepQCn/D80y0r5KmN1+Fugo/x8pExqjwqGXdHJe+DqhXmDYIXW4fu14UfzfemDcuTIySJdPKAdfW1PIG74nZlda2kAQ0g9+Gwr1K/1UC9yVTbYBalPVN7gIB5p+bjknKAmngJVX15ltO+jYpFJE1glAJjCgk+X0QQNeiTCV71MiGAxKEQCS05cT51A0J+fTFwNBWc+0t953Hampa3R0z32masT5lUs507I4FJtKhzYuhI/KD4XJE0B4rL2RI+Mg4OywVNDNGQ4ULrv5HDm9Sg7ppszn/ZbXD4oEKy2leW3qzEUaPc8QrAOZdBB24XP1Ahhmj5iwkza+lpho2H88n4BPBMvGQepm96Eiu8M+mC5UqsVZEypyccENTt01WSrpudPnX8XibYjnZvZM7km9ZbD5osJwl90KDWoIRqe1glEYjXwBvyOLYHlpL4nS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be38aa3-d7eb-4d97-7498-08dba9bfe296
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 01:16:21.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwoanaCdUDbEJLXCXP8UtQLAV2X6Q2j9yfQUZLx6dRaLqAbCUY8SqS01skWz8CKxz/7wAVHAM7fZeuxjMPT2eoKldoPgH2/dtwwaNNrDG5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6316
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-30_20,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=700 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308310009
X-Proofpoint-GUID: NUVt-g0b9JsCLatKM2TLCLJ35ZlLg8mn
X-Proofpoint-ORIG-GUID: NUVt-g0b9JsCLatKM2TLCLJ35ZlLg8mn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> All structs and unions are word aligned when using the OABI. Mark the
> union in struct utp_upiu_header as packed to prevent that the compiler
> inserts padding bytes.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
