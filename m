Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B61EE49A0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjHUUWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHUUWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:22:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BF0E3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:22:51 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxTqE014063;
        Mon, 21 Aug 2023 20:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=pJmO9ObOj0RZ8s+acxbufCbgOg8mdfDZZRHV6xulpk0=;
 b=woWQzrF4ZeHn0rzefNCx63js7imoRAes/ZDRElwNHxibW15kCxaRpTwOw+lpEEfrFjyR
 K1pgHymv8oWvoZeHR5UyP50nSYrVVG5zxc8TST+VrQ7nBbD6g7pptmZjYCPR2c/dlkxA
 gX/4vAPakoA7YhyMAnadRRfQ3EoNGEPqMx3mLzdP5WKLjIw81rPCng8yGMI0jeIUNJC7
 kd7RsWiv3Y1NS9mBa0wsTcQXcMqSfG/Jfw8zKsaE/JmcAXt/LVNEXifUPxx+TovCLKuQ
 mt1VCGLCvjkycoLbqNOu7ynyfoFonn9ZLCrUKYifFY7qDIVdonDND9mk0+KIUntphxf4 +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnbtut0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:22:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LJCVjn007769;
        Mon, 21 Aug 2023 20:22:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm63xwjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S58h10aWkVCKHpXkEfja8zHNWBg9u3to+tQtGZTcS0lQkQrZ8VDxsmenYoqDIgfmOtkZd5FEWEVf5TI0qhSQPH7UzdM0XQH/2lTk2geq86zA4ntgnUm55nQ1PSeZoyxuGoNfi0XDJqhvQ3BXz+7w3aaOyrx90vQt49JOa+Q4KsPmswT5TbDKgYF89VFmYvGrlI048Q+dDH8Jhi+wsgC62Bfs8lYhRSr2LzsBJqYacvheVtb+UK7nRNlPcMmCLK7mOe35/CM9dbcKT7k0NCntZ+HxOreK/iPKTfLjb6AI8KCsp/KEGMQuatILsa6orjnsVK7ebzQwilatfJ7tnJhGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJmO9ObOj0RZ8s+acxbufCbgOg8mdfDZZRHV6xulpk0=;
 b=JztYZfm77OziewFBLgmBL7nrUj5RqX6POeB2xjkwpHU8kNz+aTyUEMReTi7+Z3iHvHooXhMM10zuGB9Yk8TEtd63uY+gVpP38KYC0JpcuNCzl55DyouOwnJZyPEmpuUEYQcoRt436WO25tQIZI28nk/DiiQ5pygJ2nkVzOCN+qZgWOja3RNrLvrmwT/r+Xnk1MvK24P6xjQ6RhljSqbdAvqdZCf/wrz22WrNFbNQj5IguTd9s0adjFeO1gmQnA4da5Vlyd2TerqjFgWT4QY+uiNZYzDxJdIwqBFTKhzQI8iNqQcoXsOyDzaRr0BoFDjFNrjlRV8NIE/YWuYjl12zyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJmO9ObOj0RZ8s+acxbufCbgOg8mdfDZZRHV6xulpk0=;
 b=ZvD4VZKeYew9sFT/OLfXOJfCgaYeaacjGo0Y6wKkI6tACUNUemSjXysKhZJK3nMe2obOdkg4v83hk8muGWpp1pWEcOOJiFf3hJ1SyfNpkx73RT6MARdHFrgzpC+bhK2hYDgu/1RrEzBbyJSbR3d3XJcu6f7C2EOKod6Br9+NQv0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 20:22:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:22:40 +0000
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: libsas: Remove unused declarations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7j09md8.fsf@ca-mkp.ca.oracle.com>
References: <20230809132249.37948-1-yuehaibing@huawei.com>
Date:   Mon, 21 Aug 2023 16:22:38 -0400
In-Reply-To: <20230809132249.37948-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Wed, 9 Aug 2023 21:22:49 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:806:130::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: f476b80b-dc8d-4a81-4a9f-08dba2845e48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bb3bh8SfIWPc5ZyO6rBXoAD00oDEWleegJcUsrO1jFQ8ezsiLWzXjRVnPX+KlWw4iY7dzs/iKN97GRZ/3Sp9R4aO/TkTEbJjpNr199cGFxRTk6qF+W51SStuHp7cTl6KHHoikFxJMmqbagNkZBjZQQxo+JjadcQosBwwuocp3M1PT1W0kpx5v1dE2iSNtoxU6f9EJVJw6RWfA5gBFdAEYDDgI1Gu0P6G+C9zNS58a8daZkTD9Tuy8+Jz5a2SkoDho3pFKE7XB+gp5+CfN+uXMGI5pTSdo9CrkWHYmzB0qj7dGjB+IA/HdtcbOhzZrZC8ltIC770KRE5mwSroqKg+ffrupZDlmCdz+U7etEIxlhl4LRRPxdBOCf60ECyzCzbmQaOUTuBRQr+LX1v+bt7mrxO16WWwpd4ZTl9bcgNJHbN9yEXrPZCKd3VKuaQy8Tl7cf9zl6zuvA+mX88651hnTpA+a7eROTOF1Ss6W0DSOLiZuc0h/zB5RjEC0wOKBie4vvL3r9MMaSNAbbcuRwzsQqtLB6pUtWh3olg8raFrb24aMhQhbblrBbLxjlnFcvQp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(66946007)(6512007)(8676002)(8936002)(4326008)(41300700001)(478600001)(38100700002)(36916002)(6506007)(6486002)(4744005)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/P2McP/zc8xXQHbUC7S5tKg/4kmWNmB5jEVy4z0nwHD0U73Y+UWoUOs9Gxmg?=
 =?us-ascii?Q?BeI60+dc0ThLrfpzwsGhgviSL3UP97aOhFQI94ybGOh/te/lB/eJLIvRV287?=
 =?us-ascii?Q?9Ak7gFukLoNNAiVXRaDwckwGU/aFQNeSoRpy1Kxm+Fo64HaF/zrk3zKCR18/?=
 =?us-ascii?Q?TSumDoTC5LPPFKdH5UC/dkEClRKGYJhdzgSrJEzSDFYwYwjxuhwb7sa6lIzF?=
 =?us-ascii?Q?3LkQFg/WiOdx1fyimwqBGqo4xgfl3my+/OHxoiWUKltlvbDJIPSbTgyVqONQ?=
 =?us-ascii?Q?3GsgfiDRXoEUtOTLkORqqp659iN8Jtmm3TXSDgoJOsXrdf3/hVBNy/QHDLo4?=
 =?us-ascii?Q?8N5p84eOOR8XvSh2XM1lrfajTILspqZtuFeh5isA+IrT34CSjfHksVoNumTl?=
 =?us-ascii?Q?g3qH0vA+pATc+OPO4UJs78IT9/j3Vp6IMI5OUZf+YfzKXLEvHkvHqS4r3GBH?=
 =?us-ascii?Q?W8d9OoljGM+LiGMw7jQI6RKEsESmkbvBNxUJBNWrNzWYtYVcdDiUgpXgOmuB?=
 =?us-ascii?Q?47+gCWLOMLYToWKoF3L7ddqHTH8Go9oFweyxBYZHy+DF7VFlY0RpaLxD4e51?=
 =?us-ascii?Q?NFixSHxeqTgX0Jl5WQZ41L+1NXuEb69K3OLPrOgRzzXUCKQe3c8CPqYi20qI?=
 =?us-ascii?Q?USon/Cu+BDdSkyyJUEYAl5ZgfmL9k815M1kXkZ0MDk0F8g9XY7RvfTyszHDy?=
 =?us-ascii?Q?ln4hUECUN2u/UvE1vLR4cLRUBhISOOddbel9rJgra+B4g/INuCTreG3fjPIK?=
 =?us-ascii?Q?s7pzL8HotgQpS2dmPprjQa99Y/ixVixhRDzRvTt5OhLYfpsPRXf0AESHkvca?=
 =?us-ascii?Q?mLWGZvwURuN8InR3+WeN3tEo8EXVa+xG9A3ft+Mxg3l095CspVx1oMc0W8yD?=
 =?us-ascii?Q?/mKQgeGybeSJyCqCZLU/41PYRqcUn9IwFC0i8zL/kbuBivRLAKA8y22R0F3N?=
 =?us-ascii?Q?/VNnelZYm6I+kCxHzaoLZndArsk/rVG++uG1Ig9GdQ9309o85EgSraycuTuy?=
 =?us-ascii?Q?53iaj0DIU+p3PDTGeE44mtypO+aU3/F72U21c66BS4znyVtXx9bD+7VTtv48?=
 =?us-ascii?Q?wBgn1587hWw9RdNCo6giMT95owHe7pfJBxXXxa2h4SFI44ggedd/gGaYv68X?=
 =?us-ascii?Q?9UNsYktaq7g5aAKYAUGRf6cgX2XABXIHVBCQNy9X3TJuH2WJvGlG2v7hHKYh?=
 =?us-ascii?Q?K+5t/87GCKPrabpyFrkjv86xg6Gu0lsb59rrsqtkIIkFR+ieZ2ZBFbhxqr9y?=
 =?us-ascii?Q?Su5EKWUQnXAu9xRkGA33DDgofx2md2tlO7g9bivNl94qLWQsHh3lxWVeckLu?=
 =?us-ascii?Q?ucgUJRuNpCImcDMFiuzWQjdST6gC82VtM0Oq6vXAdDNtjasbyb4Ho6Uwzr9f?=
 =?us-ascii?Q?fTWLoME5oK6c71b6CVvol4hbZ+FEsPvsFMojMsC3zJpyPqR5jCIqBQiwQg+P?=
 =?us-ascii?Q?JM5TCzWcXdvny4SIWFdB9IVCWfilEtJY0lnEI4W+NUrUKYgD6IbqxuNUH+2p?=
 =?us-ascii?Q?y6376wL912dRtnenlhB+50d3ZSEOMx47uKv+pXJL+qdwXv0bRdgC6VOAerTX?=
 =?us-ascii?Q?OMpMTPaBniDEEzu3rE3VT/1N0fkIigPFJlCZHvXQV85dH6CdaQBf8rzbIFHW?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bplBNt3/Sgysi0ijYJZv/lBJ61xpnZMSN0jQSTCckvUVYbetvgAAyY33E03tVpWB3oW/f4pZa1zZAsntt6dA2C0LJokvFp/79vf4URSX5DQfJkr5BdMB2kCHp2FtLe4YWMPdGcxajHRI5iYCo+Syl2ROph2JypNkken/xGzZ+CByuv17gKqP1qQ2czMnV1igcJsUkgnQPMZuPGBp1NIeHhyI2aYPFIqcS3Hc+tn3cwsWM96UzxTsFsMjNvFPnHk2IIaqkJodEH4hclx8+v2wn1IkRmXxa+q19V64z09aLjatS1MyKRLIAf6lDzSB2zZGfIICX8+zUtvAPi7SQDD9o/LSC85+3UJrWqtLk5SNsKG1bqzsiSM4CT8A0YJvPUsPINY7Glacerv/ve6sbzMXTPxsbGgUHA35utsw6CrRBsRp2ZyJUfP/w1xpSpgUUbodEsYrtsSZhb0Vs0BGSr5MVX/UlZyY5i93eQa6/tcOILjQ4kRHSSkPvWyFQHTdBtbfVQ72G9dT6sTgH8Mi17hk9K4mgXuf3VOrRD5NZwkGDW0HKTfN/OrlP1SPCirwYzM3oNQnDlkIcjRq7DD1hwWOPrSZrKCQeSKAEZ2hKQAr5qvJzgWIZaEaZFa1Q245i4b2vVv2bZI4PcHisbxOeuUf9XTzcD7XGGyg3RQz/Y3YAE0ZKLND+VZuKg4MajeFdsibSuzqJw5o6Hs2bpJ64b7Wp/9U2ntYEQlGBhKbxrA443dAdJ/Fc0CtiUP53d0SwkLqOgJylndeGbd7HyoRfuP5kIR4b2IizeP3BaN0lybvcLVciAXIFK9841boSA6v8doAWWkjzRLv6B5GtKQU0BgkoA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f476b80b-dc8d-4a81-4a9f-08dba2845e48
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:22:40.5325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iivwCS3t9m3XZubk3LHSiyqVYU1kjDwI07su742FXvvJJZ8ruNVeRc8MHBX1miVwu3HtXNjOeqV70po7mhK2HTcd6YB2GbfbJw3tEuzTss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=839 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210189
X-Proofpoint-GUID: jz7Hu4F2SIiNxDlz5-MJdP_EeFJ8BRmL
X-Proofpoint-ORIG-GUID: jz7Hu4F2SIiNxDlz5-MJdP_EeFJ8BRmL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue,

> Commit 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some
> cleanup") removed sas_hae_reset() but not its declaration. Commit
> 2908d778ab3e ("[SCSI] aic94xx: new driver") declared but never
> implemented other functions.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
