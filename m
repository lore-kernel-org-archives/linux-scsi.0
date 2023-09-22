Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838F2E7D0BC
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjIVByN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjIVByM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:54:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52361E8
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 18:54:06 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsTse005949;
        Fri, 22 Sep 2023 01:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=5OkPMNQBC5bAnvO7OrURfRX/ZFyAjdohSbwr7QHsz0g=;
 b=rtXa2YC52nFiRgQTkr0x1I3ljBE3wJqblWP5vQJotjU/V24bTXlJW3CugzLR64E53KnU
 rA1u67R59YodyqQKN7mdtpzblLmFe6Pzs4TC/NZnuHIcLW2Wl/Cgnn3yzFAZ6BGZwoOL
 efBEVgywiUP5pikSK2UCOHVgvEQE2gPr2/oP3HgW8/MPfB5eVbIdyNwZ9RpJImsDgYZO
 7YrtFyjXM7/n0SUPEECACPi+DIAcyZfw9QjIdR6/hMFRxdCqn2xa0uhbfbpsVDG94RDo
 Zpmwu++wV+Q1m48b2IuF+v/2OElvB91JLdJgLM//b9MXgdIbplWEFO5cm0HkaAF/MJ73 ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsv0m40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:48:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38M1QFcP033835;
        Fri, 22 Sep 2023 01:48:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8tt7d2h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPgrGWGQGscCSQeywHBxH5X+W5xVlxBAuRmVEMlM98w82a1JtefSuX8pcFdKxGZ0Q9gzwXuVHBQXR+5LfY/unz3+OHc9g4rtGWkhFj7kF5ly2D7OkSSfIKIQ4mrthg+QTgT9bOmfEL/6s1FBHOxy6uG+m7A9taM/bbou2MWt0MiKexaWW2C2+X/Hf6ReDOqGxZanS/O1wJvll2ABMIgQlgp2ioNfVmP54TLCAQ9EEbvUdg/ljZCMe6zuVD3F1WC3N6u1as3zfWz1d28tb8kTxtT3f5Ig28FI0UsIb5NtauEGWAiN6q5ENi9S2OnWJL/STZ+N8D9lg7IXoUdq+Tgq9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OkPMNQBC5bAnvO7OrURfRX/ZFyAjdohSbwr7QHsz0g=;
 b=oYBieyvsuCHvjP7ffoGqsWuz6+hj1pabj519wkbVuyOr/ud1NXmmLN3sCLB3T9DnVGd/JLYVrZzNL+slFFZvg6FZ7PSA4fwxhXcwtpuLVcOyDjFMpXJd07z4yaGZVkkt6JVkTF8Ovyf/GS69IQ6j1rXu/WzmzHT0Od6ea5aQ8BF/Alb70mFvLvrzCH6uKjzFwRIcPQJX4M9+E5B1lvN0F01tdKCjyQZPBA+tu2Jr2/1MK9sFBQ7bZ1WEclJEt2Ja6JuwvK4HZ6P9rOVrN/3oLgsr9C35cJvlv9e2EOda3XkkeN5G0xe160IpT6nHWuAqJTHmYWy30KdplLgrKaKCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OkPMNQBC5bAnvO7OrURfRX/ZFyAjdohSbwr7QHsz0g=;
 b=hOm9w58hfmc2t88LZzZJnYUAHKUaIlSEYX0Y8l7MEfh9uixzOALCrICOTB1QcqnUbzilq5tpv6rjTptHvKJnrY+IZz6GhbFaoKZ+Tp8R1rbeWSH7KEViPJCY468X2I1gC/K2J0shIuzdFMrzZHOspvTMnOuRITHW137EI/AP6Ag=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB5965.namprd10.prod.outlook.com (2603:10b6:8:a1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 22 Sep
 2023 01:48:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 01:48:34 +0000
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] scsi: ufs: Convert all platform drivers to return void
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0mr3rmk.fsf@ca-mkp.ca.oracle.com>
References: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
Date:   Thu, 21 Sep 2023 21:48:32 -0400
In-Reply-To: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de> ("Uwe
        =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Sun, 17 Sep 2023 16:57:22
 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:806:24::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 5505dfe5-1016-4883-b8a0-08dbbb0e0812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t3nfFIjGmgaEF4JD8e61zKqhLzMvqVuP3WGKxeVlRabt2haU95ph635UgTWj8OFwbQZd1CLhrddCxCs19s0cPmYoUV33Set91j7X9mj3pku31k+R3WL8IFIDkSFvlIHHAyB/WduVgdnwcJPDZG/7sNF8UgKj/17DIHkY/Oc7r4/9nvg4DA5QC/Wg7wcE3auefAGt47qsN6fcS4ZNSjrrvUs8M/0gUb7Ni/trebpGmkWlPu7AyPFTXRZpmbHRW03xSbsJ1YffRDuM7JgtunHjzAbAUirvOtXb2IsG3mliBpaIef3ve0a0gB9RSK7tCSjb8z4ZKDLKZ5QucgvdWL6DipDckcUUngPabBOoRu6DiVdirpNyLNvPt5c9np5kiUiYasvXzKBe1ZQiad/hpj93Rz98VCMlHH4mBiJi25Apb3gNuJIeFVWQfrnDD1qVoFHW+sxMF7/Q2N2hZ18Ne9hEmWDuR2sXiYCvYhQXjTiLU7Gfqe2FpXT848uBnBu6aB59Zyl9lIBMYGDglqSbj/zqDwcvB+3kHJn9wDg0W96ggE/hji+/PiuzLivqQZ2W29NH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(366004)(346002)(186009)(451199024)(1800799009)(4326008)(83380400001)(86362001)(66946007)(54906003)(66476007)(316002)(66556008)(2906002)(478600001)(6916009)(38100700002)(36916002)(4744005)(5660300002)(8936002)(41300700001)(8676002)(6506007)(6486002)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b46R0SvHMtxvLRd5BK2PmyD4f4GxO+pXa5wlS2zktRMVX5lmBrywosqCcs46?=
 =?us-ascii?Q?IxJlxzgpgC9MbClZ4nWeu44jYn53dlDrwCsdrO77ceeKTnlpfWoeuuscCiAB?=
 =?us-ascii?Q?+U26EjdUfB9fZ6S5dSjT4pJXWkZmELTsDW8BwaHZtcyemO3yIpJFl6agHpgh?=
 =?us-ascii?Q?vE/HEhHcr1i17IN8kNiksqtYuyTuPTBKh/k2HqtIEyZsU5yE/AYe3nu3r3ga?=
 =?us-ascii?Q?A95w7QlAwOKIFiKxRGHkcUFL3SS+B9Ki9fiUE5mOe9IWSTagohfI1Q4CbE+u?=
 =?us-ascii?Q?Bkx0J2lbnBqnpzEenA1PSmtBV0mWMq4kYUco3IiQPk80avrhp7wuoRbp70en?=
 =?us-ascii?Q?EQ9A3rsYqHgBMe6jovH42r8ivWCGvwaMSOjJFh0KLDrUSlU/Qk5nigVVtdvQ?=
 =?us-ascii?Q?pBuEZ4iFu+aV2HeuHsoRUey5kMGsje0WLU7PTNHbfyjNp2dbeTcRQz5FKKRy?=
 =?us-ascii?Q?3mBrREZNe66vA2XR8j6wtRkADucWeq6v0o3ycsf623e+mOGlPlJvrGjQZyfW?=
 =?us-ascii?Q?t6Vv+2yfkv5AmUA5IJZi7Ewk+CUdXO8nS9NN0TaR2oQ9esc3Dclf9X2kLjsi?=
 =?us-ascii?Q?LRa2OePVV3L/lAcsDFei1F5gdpWyB+W525H2Fbnh6BecmDEtxeytpAmxyqzD?=
 =?us-ascii?Q?+cUkmTOfhS6KX4bomK//PKoq6TfAEsjYILHTGC0Cst7KZNx+udyHwz7yFlqm?=
 =?us-ascii?Q?5TxTuF4mBNNJUqyjR7pp7z942MCbxuVNnJ1LJheZ7yA9puUE7Wrz6OgTYZtM?=
 =?us-ascii?Q?IdMD+B3KIxXST1boeDGkNC6G7ZiYuUmDY14nOqn21Rcqv+0yQvML+DCzTtOa?=
 =?us-ascii?Q?MQ3AaW238Jy/skTTvTJ/k7DYkXTV1BSS2MRlJiw0EeZQjfC/BWi5S2AagpCG?=
 =?us-ascii?Q?9Pq+aOrEWmsOOzhVTgu/M+uZh1vXUm1uT932pIO/t/nmhgLMQL+IVnW3A6ps?=
 =?us-ascii?Q?Sxcp7IGMi84aAEkAhMHPcEEAwja08YCBOpZfrMmGetmZvsGWdYB6Au/nzh6v?=
 =?us-ascii?Q?yNpMVIBmExh4B3qccE/9ukqljgOaZKrmiFTDKHDVCBTuc3Xf8Gup8rKc1XnX?=
 =?us-ascii?Q?zVPJEgF/FFxvU4CGP5uOALteTgQm61OiZckRQON0EWP+oFAwbTYtcpN94SY7?=
 =?us-ascii?Q?CKgnkW5gkAqMsIWNvqqtjE16B+jGuCamxq3bYSzauooumhAfIdQ6n5PBG1fZ?=
 =?us-ascii?Q?0Z3/XDjMC/q9O3I7OMmRTHdmzx1CQ2sSCKWSJDGRJrntJhCeUn+9w4IuKzeu?=
 =?us-ascii?Q?WyAuFCvvCHBTp6yqgqyPRQEqVhHl19PYztw0eq6FazmEYcCWaTiVFAtiKVov?=
 =?us-ascii?Q?D8i6XbmyIMR8PBALcljI6k52tE+iCP+8RJVrH8ENxCrBhiSqRaV/KeIhpcHR?=
 =?us-ascii?Q?/eAm0hxtkPwDZYVj5HgSu+Th6TIEc9ib4A+RJAdQnMyDgQ9GbNbHTvxG4wjw?=
 =?us-ascii?Q?UkC4kYVrORheZWWseb6NJGQSRzIfVR82qcR4OhkfdtoLOwYOdxOtbR0b0wd3?=
 =?us-ascii?Q?QoGF1isUbUmjANrfZ9QcFYy90/SvEclWsFCIRDbEwPrwkUmxgHyLNxX6IHZC?=
 =?us-ascii?Q?wnQZw96JDBVMcj5nSy0J556Ult2OFOyEsgM/7yi0TM6+AUglQRlFIyhZOThf?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?9wvQndIvqETGML5iPOsImcHsJdXgf6seyt3zjiSgiTsQ7DgnkFazj05mO5Yv?=
 =?us-ascii?Q?ea9FlRcJJLQ925chslWh39TUgjbtOwiWG0s3Igozh+8rzVWBXO3rBjTOrrcM?=
 =?us-ascii?Q?h+lS5Q2OTjrpZ3ZoWXlRm3u51DcmdWiuh4Y/Dxg6bdjodH20ztDsH568encD?=
 =?us-ascii?Q?iU01JdxvpeGUMvngR89K6oPk3hV0yBAzj3DlJEkUDsDBrzp67eT9L8eEm4+v?=
 =?us-ascii?Q?aTMZao1aK9vfDmoNJoskLIjIFFqmVoj2PnWIwMRaXvAKDbhUCkVM/kv4fGHj?=
 =?us-ascii?Q?/HYq/3NQ89hb3bHjCWlrhyvCJyWdr86vbtlZTXymVgyCq9Pe6V9vlBzDiK3C?=
 =?us-ascii?Q?oZcUTWIciOplyqb2Z6uDEstsMLd1bPZtwSWBIU8Mcr9jtsMiyZ2147lUycHd?=
 =?us-ascii?Q?g1Ra0IDni5KZtDLIdQAMb64qkL+SGZqn3Ucob0uoQVShGnbwXXvRZG16RqHa?=
 =?us-ascii?Q?w8b+10XCmnPi1lHyXP/oLFnzjljt5gADltKLODsZY3QZMXMxy8AI5ai+JXG2?=
 =?us-ascii?Q?kQk7qbnAcmUIpmqY0LwQwBX1Aj1UlM0SFkfEo70bszw4mVA5IBIBSJcBmIrL?=
 =?us-ascii?Q?L5q0LVqFNd1lg6CjwpFei/jSA5nVLPCs5c1xWWWjmKgRLRnSEbuLm7MItEJC?=
 =?us-ascii?Q?hDbdPpiGsjXtPLTe50+FYLWGVy7gnpin3Ht92097UycivagQvnd1J8q7S45c?=
 =?us-ascii?Q?AnGkr432Ws7zyB+9X7R/juXd66/ulp3CaARdaY7SjMRZ41QYxJkx4omZZVFC?=
 =?us-ascii?Q?OJbPUJsbh6mYnEzEAlEbk6w/wXAYjwBO2RebazSgLP704JVHkXPcBvpQx5fx?=
 =?us-ascii?Q?qWJIbh4x/49KUzg5qyhNw0tEO/tyb+8i1/honFovUpalMvF6g6PaKZPoR18m?=
 =?us-ascii?Q?viNPiizt39MfxKkFboZSsezEfdXmIle8kwWM81/xhXtWk4SebneRsYDceCcD?=
 =?us-ascii?Q?DmLDCkiMYFbkrVrCURvfyQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5505dfe5-1016-4883-b8a0-08dbbb0e0812
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 01:48:34.4664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCl1EVd/8Z88uOU9WBT2VGJwwRgww8I/s5f06cH+wJGnmVibONDjNc3LiFZ8FJYjvTMNVL4HX0ZqJjh/Tqcw3Ba2Req5cDHecRiDuV95Ze8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=814
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309220014
X-Proofpoint-ORIG-GUID: vfSnF9Z2Hxrb7QdtrqGmgelg0Fx5rHVL
X-Proofpoint-GUID: vfSnF9Z2Hxrb7QdtrqGmgelg0Fx5rHVL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Uwe,

> The .remove() callback for a platform driver returns an int which
> makes many driver authors wrongly assume it's possible to do error
> handling by returning an error code. However the value returned is
> ignored (apart from emitting a warning) and this typically results in
> resource leaks. To improve here there is a quest to make the remove
> callback return void. In the first step of this quest all drivers are
> converted to .remove_new() which already returns void. Eventually
> after all drivers are converted, .remove_new() is renamed to
> .remove().
>
> All platform drivers below drivers/ufs/ unconditionally return zero in
> their remove callback and so can be converted trivially to the variant
> returning void.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
