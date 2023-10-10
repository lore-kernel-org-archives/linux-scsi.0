Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76BB7CD68E2
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 01:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379250AbjJJBYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 21:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379259AbjJJBYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 21:24:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57C2DA
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 18:23:57 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399Nwrc7004679;
        Tue, 10 Oct 2023 01:23:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Et17Vhi8QxKfrvwlJws+ipkodpLlhd4p9buNT8ynACY=;
 b=Ru3FzHYfoJ8aUX1hD4j5h0v548f6tbci4wDncv0h4QigHHmue30a4alBsjOyBpw0zeMi
 aR/OIjQRYMwfV7KMX4A6Iwr9ODwVwH8BSe+3+LxboOQMUgS0O1Gst1LXZCc8GusrCM9N
 27sHyqNwv+N/YQt012MIf1eijMkS9omhuZtpOr1X+ZDxcv1xFXcYADx/09Hv3h+RuOFP
 SgW0ibEe3m9tPMr6/KLvBGR/oos09Wr609WLi94+8lR3Ik5M5Rw0Mby0brx2N/YWZV/V
 aJSF57DPiQKwCpljFiKOkn/kXsDpP1w1YwYiyRodBP0GtOvIeF8t3gJ4jm1ABNtSukMu 6g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjx43m003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 01:23:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39A0W2Ve032250;
        Tue, 10 Oct 2023 01:23:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tmfhp5k1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 01:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL6K8FoLvtj0XiPcCDb9MVSWRGPreucZs0Fr8eAlKsQu33oVn6AWhdnzajp+KYcMHs1ndx59NynU0Xt4S+J9gXxUc1o/ETmk6EkgdWX7RSWXYTSU8SqslHv3Fx6ICdlMD0G/tDNbyYXJHELrEXTF1+hsx9It+s2V7/5I7zu764UM3/j3BoKBAQnydRV6v/8ksC8dZc27iPK8wR6uhQUnUyWQjDwf96KJR4hqj5EMfi2Un9GOSisks3Yq+b/+haEj4/KxdulQJdadCxLp7s0jBj9GxKMCEn9EYxQZa12RKgsc46KlqZ1taZWZk5kxdkIDafAsHtAlS+M+/h+0Ne8WyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Et17Vhi8QxKfrvwlJws+ipkodpLlhd4p9buNT8ynACY=;
 b=kIsNdEJqKHiFBgo3yBKaahTp7vE6X7ja4r5lIHria/yh7h8KWNeriVn2Ja6kcHHetIphZ9x9uoO/un0fPlpDW6uphDK1t/0P2DD+fMcIpYFyYSEXi/SmHE2OAoeuOQQf3pQnQpYAOPJI4bOIICAE/rT0iE7h0XZNoGYD5XHCWYUgXD9WMxnl5ur6KdXGC7TdT0WAa56BczbSmxIKYTHJhSEUkMqJJIgugRnt9uFQTS7qHH4seokbEUAYGnRHLu/5ktWqX53YVH2H9FXtk/6FSHZfUMEpxuMgIJi9+UDNeA+rGBnYsHhFUsza0IT0LdaJ0ZKgVxAnFDUey3NMnU/tSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Et17Vhi8QxKfrvwlJws+ipkodpLlhd4p9buNT8ynACY=;
 b=FYLx0kHRC6p2DVLbcQmAZWUYw2s9IyZihFQaXJhUFLEZivw73p9+lfQBG33zsgoORWn93SCq0PHT2KopRWkrR8TjEFewpZZhm8HuM5wObS/BvXhnIc4uKF7LZztJCFxetbWhydE4f39gYIIGnp1MT+8iDkExhixLp8zbqxwcAtM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5165.namprd10.prod.outlook.com (2603:10b6:5:297::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 01:23:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 01:23:40 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>
Subject: Re: [PATCH v5] ufs: core: wlun send SSU timeout recovery
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edi3p8xr.fsf@ca-mkp.ca.oracle.com>
References: <20230927033557.13801-1-peter.wang@mediatek.com>
Date:   Mon, 09 Oct 2023 21:23:37 -0400
In-Reply-To: <20230927033557.13801-1-peter.wang@mediatek.com> (peter wang's
        message of "Wed, 27 Sep 2023 11:35:57 +0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0035.namprd12.prod.outlook.com
 (2603:10b6:208:a8::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5165:EE_
X-MS-Office365-Filtering-Correlation-Id: 01de1b07-71f9-48b3-ea6e-08dbc92f88e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUl9PXGIMXfsYSMeCpa04dPjQ0VBNfIHb11eWxMek1fYSwAWnbsJbnenzuTK8tZcdB5+IymWb68KwTPABsQERV7riJ+CDMImieIVBvEcPKC0j3fiMusRXKWBYvh5cx9+EgfkbtX4SNtVKQG5TvDUY1cG/vk5lw50sFGFxGxVaGG5JD9ZWD64M11EZJ/hBOib5os0wHHUwpbtTm3fGyiDJ8P0obVo3yYcT1tcT345yvf+qN9IAbmwa8kR+lsy3qN6i9Q/gT4K53ezEVCMMOjbNmcKiqznIUUibFA//cWEX6EVWb88zi1RbNrZJvqint8Mmbahvp7yFJC2lFY5l3aZw733wd1zC4/A1C++QCmFhuDvN61pUB99FzlsuvAwlsOoBMn3oL0+EOollFMukaGXcMcXPU/rqAzihXwjOzVgrNPA8yuTv7qyvSq5CG9blqZkWW3Py5DiH/2avnGacYMVCigyrbnJE803xdYu7k2nbTr1GP76WEDaY+FoRoJiV8dPYxkYj35dmZZGRkVPaxI3N5fb2XKuaml+128rdatyhgPCIGPXzByXxK7qXKTvGcFg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(366004)(376002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(86362001)(38100700002)(6512007)(2906002)(478600001)(4744005)(6486002)(8936002)(4326008)(8676002)(41300700001)(6506007)(5660300002)(6666004)(36916002)(316002)(66946007)(66476007)(66556008)(6916009)(54906003)(7416002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i3dLs4P5YEFMGOMhnfwmR3Xq7bJLe8Sd8/jKwR+o9yt2/8DUmAgiZWGRCcKT?=
 =?us-ascii?Q?ez9pz+K27C//VIZnYPreuUMtEbG8WbFz7VuBgzxMmSrhAS3WhQuoYRMI1iAJ?=
 =?us-ascii?Q?WknixjuloWjSM2GYPrkktrzevrPGTxw+4y+JayA9mLFfWw3AEFHFuRR6E106?=
 =?us-ascii?Q?PmsiLvQ2pOSYhAH204puSvEj01RjSt5pqYRXxr0i1kp/FRju9lzjPvLUpaWF?=
 =?us-ascii?Q?i4bpUvzPZjx59yJDHHM3Lm6OnZ3nZeyo2ea9tUh7m+0ZeW8bsu4sj/T+r3nx?=
 =?us-ascii?Q?KQ+XyNJ4+85NvAfEYnGnqSCZLbOZCkc5ahXiN41F4eqaJr16nfPo3f1ZHdHT?=
 =?us-ascii?Q?MG924JJG17P4mvtHEjA5gaqVrFWFDB1LGXgQlTri5HVQy4AE8BDZzkw791gj?=
 =?us-ascii?Q?anacvIItlC8E+XXHL2ONmods1G/PAsPE3Lytpyl3RdqCGCj2iV0TSD69IQjg?=
 =?us-ascii?Q?U0Z1LSRaImrcKpxU/inta+r7L6Y9hwqxp8JYIQci2gFFalVzceUtPb7wLwjS?=
 =?us-ascii?Q?HXkct3mRa6jSZbiw7G5vlGzutcuTlRDLEOUVLZ1JI4nkYRQxu8+6H1PW0r8F?=
 =?us-ascii?Q?r0SIHRAOzxeZUcjXPL3NNSzciCVw/vYzuiNnPw9FVq17TM9C79vrLJxtiT5V?=
 =?us-ascii?Q?aYegNXSZRdjGi5OhSA79hIqpCLLRUsq1LlVJH4NR840sYlw0NKN30KQzohhb?=
 =?us-ascii?Q?b2KAFBTqtNIfDrcIsvW1vQrZplC1qB/DYVUtSFr/GKn1LDq8aZu39E/iI8Sb?=
 =?us-ascii?Q?Zw762ShDgrOUtoi6VGNEKFX67Nh+LUvStZ5cC4kGycjo4vO3JDJZz9/qg7o/?=
 =?us-ascii?Q?8sE4af34K9gUZm3BI4kBiR5TX6SiyTbzr1SuCFlHXxaa8yCV+5I1JJGenFN3?=
 =?us-ascii?Q?S28KaAEaA+N63ikTNaYsSPI7DDqTXWGbCJUMGShhruKlHIws4Kgi90zsSGJN?=
 =?us-ascii?Q?XkLFiehw1AKFlpikdBCudttxwowkijBlDiE+qWuMCiws7gRpXDDomkFnHQpg?=
 =?us-ascii?Q?+GIPZLIAxi1aumBOTs9oLMJnFsyrkveW60Wx/X6jQwPcxeVMbttFmcvPgpQi?=
 =?us-ascii?Q?h0QdIOvCsena1dEQmje8LxBkRO23X0CllJtfixuuWAFVZ3lx8jv8fhBLHRdc?=
 =?us-ascii?Q?lhoKABsKx5axwe4gIpB7TJN4URcI5NYbzjZONGqIMekT7HexJdhOGYT1JaAC?=
 =?us-ascii?Q?EtUp6VDioTFLuLOrqUMTdj/8/c8H00L14kBp5c9jtU9Pu+31K9FbW1hdGGhc?=
 =?us-ascii?Q?har4DRGq2ybGe8fvpJDUiVhUQ8fY1HI7pY2Y0PFz1OUxdrr/4tbwVe0u4NKw?=
 =?us-ascii?Q?HtNfsXatUxcXJIQhc8v7I3ADhgHMBxsQ6E0FL3YpF74SZL2ceT0pBbB0YmpW?=
 =?us-ascii?Q?YPZNq6WV4nIe469sAR8EUYst2h+F2jaAy7koL4Dk/ZQ1stVhatqNEkWrGKLP?=
 =?us-ascii?Q?Z/ATzRMrnHz8h1ElAOgK/PhjORIkufluJ9D4ixx/57ycP4oM+2PUEy1IFqt0?=
 =?us-ascii?Q?Ehxfw6gz3Y0cYa/d4zrzNfzCerYKFbRbflfm8m0+uVfUKsYs74kbfdbQdilB?=
 =?us-ascii?Q?kCu7YDOBYwY6IGlrGt1EAL1ClYZFW1YjROqs88jSp1xdGCQzrGsjOwF8UFtH?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Ao9sm1ts5MhYY7rFGB02CzK+R5m/uaVe+SNPVfObFXFdLjU4/g/MCQP9+aAp?=
 =?us-ascii?Q?ycMUyWN9hDR54O1Z27IXGeMh2Euo5YG/qY/AXxkiuJIhBR/KlLp6cGQI3fvm?=
 =?us-ascii?Q?Cdehc5E6ywJCERU5ww3jwezMVJyMdK1DA/iZj9ICvtEprmMR6/+SYjrcB1pp?=
 =?us-ascii?Q?npO1DsBq+heJMmr51TbhrRXpZsKBU97I1pt1fFJT5lPw6T0RS9v+OnwUzKds?=
 =?us-ascii?Q?rcayxbifxyEFj/HLP2AcuuXUCAq2TFgksrf1yHkug+Sz2vuOeCvPKRbu2tv/?=
 =?us-ascii?Q?db27vUAIOU6h5PPn09JCZQ0vX5lSUt3NGvOjURMH0x57sHDvWCuqmMXoli8M?=
 =?us-ascii?Q?u66R2Tx2L2ybF1d1ijzNFF7uJzgqMp61SZ8oVOCxc2j0lyzYyybxO9wJF+G2?=
 =?us-ascii?Q?iVZQgNPpVaHPTsM+WkI+Dphpj+nPjMfUqpB+8rAYtfG08z3hvY21gF6DVX2R?=
 =?us-ascii?Q?E8HCuxNvUT8iqMGElxsJPBtTiRMH199bMHK+Bpn98R7l/r65rMSL9L2cb++L?=
 =?us-ascii?Q?ce2cJkklha5a4FLCPQEnt/FNN6CYKVR2hu6UpIP7h4j6yYD29KaNWeNo5h+B?=
 =?us-ascii?Q?EK2SKJWl+Z43CZuA1B1tMwhep5pwvk4kwbPf4gSh8FapM+8P/eWj2BYPfjcH?=
 =?us-ascii?Q?Th8FbEsQSWeEDrIWdvwopH0uuSWYXlWIH1u5DkVKoWZo24jFqAyvR+5XeJ+T?=
 =?us-ascii?Q?al17jF2dpXhtTvmbIvIbVsJbojzjh3bZGOP7K4eWHeZy4HOgoRNtudqhWRq6?=
 =?us-ascii?Q?3H/DGDlBpZV4fEAN7QhdkiZkRY7NyFo899nBYxSewO9SOhC6lt5VfoTx7ayo?=
 =?us-ascii?Q?MUG3V1U5pVUBJIf43D4Gq3dhDt+2jx8TdaOGHDuR9Gv/v8aMTGkmisomfXFg?=
 =?us-ascii?Q?kq8yA8NC0F+55EuVVf7byx62KafUIk67Y8af0tIIPvHZ4/tobb41nno8nt3y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01de1b07-71f9-48b3-ea6e-08dbc92f88e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 01:23:40.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WeLa2XhAcV2qPK57RVgx99Jx3+Va7HEhUrcbWdTwPsNiw/4pB23RuR1ecUDGUCqCqVlGRRXL2xhxTmr7+Uk1uay6GxeU6+sIfshE6L0EiWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_01,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=944 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100008
X-Proofpoint-ORIG-GUID: 7rtMwsH7gt76eREGeJOrkgYagKHmPTqq
X-Proofpoint-GUID: 7rtMwsH7gt76eREGeJOrkgYagKHmPTqq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Peter,

> When runtime pm send SSU times out, the SCSI core invokes
> eh_host_reset_handler, which hooks function
> ufshcd_eh_host_reset_handler schedule eh_work and stuck at wait
> flush_work(&hba->eh_work). However, ufshcd_err_handler hangs in wait
> rpm resume. Do link recovery only in this case.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
