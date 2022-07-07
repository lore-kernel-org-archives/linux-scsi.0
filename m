Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EDFC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiGGVB5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbiGGVB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:01:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558501F612;
        Thu,  7 Jul 2022 14:01:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCYXo015405;
        Thu, 7 Jul 2022 21:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=utXuQ+8cw5CZSeFlsi9aG/dtOw298+MyNNswTokozNk=;
 b=qlHC80WJPNJi/X0FJGgQIZMUpeaVV3bukhteSTCJcQIVjQdYdwBDDQTr57dUmVHoNYC+
 0tM+6ZfOJwttNOTLBWyl84imF2ZQfPaiC89j5fisfDZQZIpqEAHh3HLRSvHd4ND7inX3
 ULnvnLg2ZB5cE/yqSi33hYk7NNuNUDQblVDLKZq0B66G6hC0Gg1/D+AOP1TJyDojzwML
 BL4PJvT7b6EDEVgjGco5MIiKTmbGYe3i3GGOrDtZcTG2Jrz5ma9Mzvg0jcKJbbgrwPhb
 Kprm8rU9C6Kxz4c4wwy4Na+gDn3v0pRa4pDBQel7IK0BGHnHZ434mjRt+sOlWgvyqx/k 6Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyx8s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:01:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267KxuWx035241;
        Thu, 7 Jul 2022 21:01:42 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4udfsxbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:01:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fzg83uqnNRj/ZIVzqIVVfGKNYRgNXgHEUSJ0oaNPSLV+4/fnHV2IFVoYH+Z7Byew7yqqMh40ci6igUrTYyFXMpJFymL9Y3dIo7bkEfo0N+qnB0npi1P4NNlcjUeI10G8Noo8EFObDOJ5FDPKNfEikpA6RcwXbW4FAuil9PHvyXuNzmJah9l6trpK4vTRGjX35hJEecmdefw13SGW/S75kVqxCmy6WfH5g2mLO011tbJ7PPGo6nqXfWC0yJQVEw5OZ4eC5zIbc9Jsd/BUxAE6b6LVh0mNM88/+hN/uCpKfsqmPY1ZNYPio5F7/XTHpfT4s9GlAR25wK+QI+HsrZRMTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utXuQ+8cw5CZSeFlsi9aG/dtOw298+MyNNswTokozNk=;
 b=MTvC6p3fN9f3nFmXIy84ZtnHonhAjC8J8yA1ygPjTCXvbps0EegzqJCXOFpJRS59QTRDbsrbqdu8K6TrCW7B1W6SvU/1Mpa0gsQsglOvamhasrQeX6MHY1uwWkr3yHRoGJQ3Yd4+5j7y5FKCTE2kcG+x8dwq3OFCANgfzrB8QZ3Ze6EdPlAn/LrbCgyd+dBndLV1S1DU7aq0tg8d8eHIjwfyTTD3BoJC/nNC7v53jZDp8XCKjhxDM+c9APe119g1yQR9tWQYBelEX8z6UFmluc2fSLIvO93kQj5OoEXeKHQ0JXg52PGuTnamTL271Q7aRvzdLnBf3RV7PzHW1psHHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utXuQ+8cw5CZSeFlsi9aG/dtOw298+MyNNswTokozNk=;
 b=siJWFtohaFIVnUqOIf3l7ONhfDZD+rwNsWc9puAHaiwR56QLG3DsUVDe/vt3lBraxGaRj261/0/s0pJFu3HZt+Ya758zQxz0KCFl+nFuE7EqZ6Fv2NWXzhKndVXDYf0zyBWmuqJGXm9sBD3+zxA7xHnPWYodGmX/NMdRCyWY3ww=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB5506.namprd10.prod.outlook.com (2603:10b6:303:161::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Thu, 7 Jul
 2022 21:01:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 21:01:40 +0000
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     linux-m68k@vger.kernel.org, arnd@kernel.org,
        linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH v2 0/3] Converting m68k WD33C93 drivers to DMA API
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zghk63iv.fsf@ca-mkp.ca.oracle.com>
References: <20220630033302.3183-1-schmitzmic@gmail.com>
Date:   Thu, 07 Jul 2022 17:01:35 -0400
In-Reply-To: <20220630033302.3183-1-schmitzmic@gmail.com> (Michael Schmitz's
        message of "Thu, 30 Jun 2022 15:32:59 +1200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:a03:80::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7f4f603-dee4-4c66-ea34-08da605be34f
X-MS-TrafficTypeDiagnostic: CO1PR10MB5506:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPX1BEphiqeA4EnTY3PBt/l+mTR0KjqANefsrGlhdj18WENiNqDO0lJFyp7FQGXeRehXe4od3ovx2Wnz1T1L6E/KPpV+PEOTtHhhh5NJVf72alG9YzoPbbqgbMk1Z86Nnv9vLwtV3BUNQ5EiIWl/N5YhVyG2HTh8ddgWpOGOk5ObAgFy2WKI6Vy/2COi0GmJP0eTChVjZF5fH3McSk4RA2FzI2YIZyvMfABFVnRS7SLDnn7C7b4E3n/sQZnvUSyfK+rl8RP8FRrJ/Z55GWJywYw85IZnAeTdBRkIm1wm+eNAYylcovJAsIo0vAkatqUMiF03DY3FOQh+TKlzkVziwaGkfe+c+pg2u0u4Ik/6RbF2fUxstQnNgZUD1F+pzB13hIEpMns5JQifTvU6KQsRVTyh/+zdogaiKTzCHTj6eSVCiElC4YhoR1chLprMFifCeSzH1xByV0b6Tg/PjzJpQTaX5VYckU2RBpeGX+whAoa7C4AMtGgh0fzPsHkTskQywbE6EHWQbIQkercsx+XjNxnanM/T5FA57iiFShi29SFHB1Da13wvmLHbOLz+VsIglYH4T8eWDBQUwoTPdSsLsWIXbbn0Jdf/4Ibj0JUKqAGapr6g+5369Cy15lfUZD+OKot9jUMy6lW+CBcc7Iur6PwVzZsN9DUHqHFNxFLApIi9Dg96VgW4eVpsLF33ptgyvvirvIIEN9rgxEgTsxLEoaPaJ9cXPdxMDlMxOe1Yd2PxoM0b2xZMEog/DqA5mffTqdezx+uusk73uWzvIqAY5o8N4+9XZGC00GpY58E0EB6g3uuak32oFw5AtSkareeU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(346002)(136003)(6506007)(86362001)(478600001)(26005)(36916002)(41300700001)(2906002)(52116002)(6666004)(5660300002)(6486002)(8936002)(4744005)(186003)(38350700002)(38100700002)(6512007)(6916009)(316002)(8676002)(66946007)(66476007)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e15K5VyzZ4XYASNNAr+0ZlXfLQNibvjobz+PzH+x4JaqgxhQfgvCaEqCaRUR?=
 =?us-ascii?Q?ymHKqtuS5S9/Yl/+rKtdU4c8CCoax8LOcrYnhzGcuJlrv4QcmhGw3r9lafi9?=
 =?us-ascii?Q?rDFvjrNX27KwCVwGJb/jMV5vW5SS5bfSgbA7Ky+IYNCeQKOiR8Dt95XQdJAw?=
 =?us-ascii?Q?605vU5dQurO3lqSWs8KubGD6AnA8XAOG0aLqF+7uFCE/ndr7XMZPDzMhPvbI?=
 =?us-ascii?Q?eZ2u10GJJrc79AUFO5t5aj1Ku2pkVDkn/aHpwSgcKbL1S/DGDoUfq03Aw0x2?=
 =?us-ascii?Q?IcVNzhfZKTiXP9p4CmPFV6KYw6K3CG7Jg5cN238piJ5q+zyzFcV1w3YEpwv/?=
 =?us-ascii?Q?ZMwBXsw9PliH2mcLPwvB+H1jleUq+UJoOh7EkwYspFriGHtvosdnaL3Z/kDd?=
 =?us-ascii?Q?e6c25MLcH85/3tdVWZAvo8FVEMnvuHqkHgHzhe5hO5ngf3E3FO5BNab8qIjy?=
 =?us-ascii?Q?oanz2iqzlZf/0vijMmuzCfOnFdRMOtxqc1SihYmxphKxB1zif0ViMaRiIo9k?=
 =?us-ascii?Q?s73BWzyPSwBfcuu9+oHfcdJ4Q+sn5DsCgAV2N2xHxi6r/S5TUwC+z/+nozPJ?=
 =?us-ascii?Q?TaNPkBw4c7F/5/qwfjSclNo7sfLGekjsf6/HweBKlnfZsE7TMvJriWi6f0pW?=
 =?us-ascii?Q?IRb8SjjXj2DNHIrqV9n+dzVUO3ZHXvo/BfTdegquIEyG9AlssPQM9qnNPR8s?=
 =?us-ascii?Q?GetVoucgiC+cUgwxaO4qJtoWFEZG4PWRD7e1AUfDepuc+f0nayGz90Mso9Gh?=
 =?us-ascii?Q?d0W2KQU0/ST7xsriYo+zjN4ZQfMZntZB7j+EJsC/RSF0Lvm1MOpZfBgdjWYp?=
 =?us-ascii?Q?2zW2V0rbrgKgOgzRPQ3feO5f9fYHPrOOx/q6QjXDVqIpR9TfQ2b8nXXvJNKl?=
 =?us-ascii?Q?cGiUFvOaxwp7Hc5G8KdhW7YuJlUqD8przSLCbOFMl1ZBvm2Hw1kpMB6R1Kpw?=
 =?us-ascii?Q?+q1gZuiPwqMggtyUfZpnTrLbe0jY4UKU+vPzTsqpBs3WHcGZfcZmPF9qdM95?=
 =?us-ascii?Q?XYoyWXe2KZcUBu/1KJ4+dPYQURWW3s7/+njzU1BIYSs/I1aFKTj6bcjo/8/l?=
 =?us-ascii?Q?DHoFLbAFTTmRB3sZiars1jggF4myaRANS2lAh/BF2yqXNmhzyGqwbNH92UmN?=
 =?us-ascii?Q?/OPFRNGe/Oc6iCkm1JRbbw73cjPTjACK/rEaB6PkMQFAssfmBpUD1/vBFzbk?=
 =?us-ascii?Q?dSZ8mVIqcoZkc0KheC0+g1Vg5FJCqaQW3UUKhIgQ5IUimp3jGvQNvULjPtFd?=
 =?us-ascii?Q?XOzxvV5CGeuydw9VjHVuqzsgvlER2K6lxBRsFvck2N5QL7oNgt8uHnM+fAXR?=
 =?us-ascii?Q?gSstmEl2EbKtHJ+EXTUXtTdxZ+gZNWH19EzIbvZLb3Aa+nE/AAYUa4TNbFVA?=
 =?us-ascii?Q?aDZ7DQ2oJHdYJJP/zlu9qKdlk9bu0mfo7QtJGfTBGNvUpDmGsLKNsoRz0x2V?=
 =?us-ascii?Q?SzA/bIR9cKnKFb3Jtuv7XyzSEZHyUPppm/G+7HxLKHg3eMjfUJTNYwTNMgcL?=
 =?us-ascii?Q?IJRTXuIZoLshqu4o3Lu4hnGiNrRWNhbioU8u0zMRiR8DhC0WAUcrykV0ed5g?=
 =?us-ascii?Q?iSocZu2KznsErdqkpzvSXTCz3mzSjpDmnGq/UV9IgreB1D17cJXbYA7ljULO?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f4f603-dee4-4c66-ea34-08da605be34f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:01:40.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 586BnjOdKOHFF2nvnUy073s552l32wdxiv/EgDwhku3WtCxVnSFN+fxl3C3kBFcLLQwiq+yPXZEtZ6N0vX7TYCW6QElWBWDChEK5vFoOops=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5506
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=701 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070083
X-Proofpoint-ORIG-GUID: hitTVscuk5sfz-XVNE1w5MVmO2_TkOWk
X-Proofpoint-GUID: hitTVscuk5sfz-XVNE1w5MVmO2_TkOWk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Michael,

> This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
> m68k WD33C93 still used virt_to_bus to convert virtual addresses to
> physical addresses suitable for the DMA engines (note m68k does not
> have an IOMMU and uses a direct mapping for DMA addresses). 

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
