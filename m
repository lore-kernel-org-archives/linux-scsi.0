Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4733C61DA3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 23:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBUXZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBUXZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 18:25:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F66211FD
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 15:25:07 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMi4Fm003985;
        Tue, 21 Feb 2023 23:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=T+R5smfKj9amFsrZNheeDaj1KhL0QqDGo3jUqux66IY=;
 b=C5/rGWXPNyKI+7ztoqy6nB5RKGmJb3OWzvfC3vhR4+irYER35PQaXmksfGtTJKudQM0W
 epNk2R/8Y1wZD6TsC0kbSmyRo6F759zeP463f/SHXAT7PT9lpUUxQyEWb9gnji8xKgdz
 f3UTaT8M2qk65IG5LzM4KUcrpLPPZNSDl+X9FHRkiIRqE5R8AVvsYT5a3Dhsh3S6GJCg
 VebTNkIHzKND8Bx/d6ciPafpUT4YFoqBmw6ZCskijculliiiuT5SyUo8YZPIPgkuTewA
 OKIzMgsZnzZed1HPcKaMFb0sxPctAm65aWWzmqxFlpWcK2XYoZObhRw83NqviXi3BAXn pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tpmu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:24:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LMQSbb031471;
        Tue, 21 Feb 2023 23:24:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45tvj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:24:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJZGxkUNYBRDsELmPXrV97LkWX9XWssPyrxWckt3Oe9DBKUQZ8iiJ/bOhdjOZw1WmfYE6cwJykk4P/SbDSUglDSuBGoJwzHoSK5dJYf0p4qHuDqOVfZhA7zcN3KtQK6yg2uiB0eMufyQ5vtkt2MmAwr/DZiZfEHzPcA3hGR6h/4ceobJwkNijfiqbjiKKZsLrW2XbdO+PStRhNajjgJDN/muRbQ2yk9Zjh46tKhnURuJ4tGWx9/ahRXRqoKrf0APm0+1EosngeJFEmESKeKEr8z8dJzm2MlQpqYPFzyBNPqTD/KRwjL3KSorQlI80Q3jAs3eKr0ZIyGXnGn9yid0eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+R5smfKj9amFsrZNheeDaj1KhL0QqDGo3jUqux66IY=;
 b=VLPKBG8Lj+gM4+87FTirQ9vLIoniBO93EiObp3DpwrX1WjUpEyE4EUKkEgf0QHRSObpO+mWNiTHUlhVwnpvBUi2yvwM8ByoLRTU/7wvVscaQA4wapf7xStip8kwpctySzNEqSpcmw/93VNFqIs3eu/lRMQpV5b+TQUbDv7LgcCR4DNG9aQyL8TfjOKgpTUg57n/Gkbl5UPq6FK04bWWghOt013v1rTswsn1U4p/vIg1GBFUWTOZgBrpSYpYeaPwGYGaGYyM97SZE9V63cJd35JguFzjmVRhfX02IqvKmKfdJBnYjtcAeV8exeDE/EgeF5C/MFtXsaXaOvlbirW8uvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+R5smfKj9amFsrZNheeDaj1KhL0QqDGo3jUqux66IY=;
 b=fM85lJhuS/es/R9bFmlSaPldC6dkIEoGnvBxbozAXtAUHo38LVCe/hBUd6EuWlYrxAjK5IpGiRgzUJMi/jeKGSrDBPAX42t870aivYHjUVPIpnoUaSNSTI0RDaKd8WgysBbPmNN/UlRs1eJK+VctOio42ySaasLe2BWR+c/sI3E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5071.namprd10.prod.outlook.com (2603:10b6:5:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Tue, 21 Feb
 2023 23:24:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6134.017; Tue, 21 Feb 2023
 23:24:50 +0000
To:     Fengnan Chang <changfengnan@bytedance.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2] scsi: remove unused sd_cdb_cache
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt56r496.fsf@ca-mkp.ca.oracle.com>
References: <20230221115340.21201-1-changfengnan@bytedance.com>
Date:   Tue, 21 Feb 2023 18:24:47 -0500
In-Reply-To: <20230221115340.21201-1-changfengnan@bytedance.com> (Fengnan
        Chang's message of "Tue, 21 Feb 2023 19:53:40 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:2d::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5071:EE_
X-MS-Office365-Filtering-Correlation-Id: 00770d19-c6e5-4f2b-9291-08db1462d3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBlc9f84fF1X1Py5OV4pF++4CYA3IcxziJZHktVINupp9ADPtv1PTE0Hzr4jYeJ3OHvYOjINoDGUWOl2WMYzEI/Z5j4KKSzxgPXfurUxVts8VERXPazAg0+LVC8jAT5Ff6MIC1N/z1eYJFW8OiUO6/ZZncJtm6HpQdAVZ+zg7/xyPqwt7YufFE6h6TbEJRaNaYXw/S85Z3jI+fpTcXtsjU6+AjSrfONe3k3fN/JCV1Da+80i6QLxTvOUyRrHZLNu9IMY6mwU0v0+L5ehPlQMr5sWSte8hxgMy++fBnElza/wQNBx/11N0nzxkuZy34yqSyIjSAH/c2KVJR2Xgty/GmVBAWOuk7iHeGnWdboUqubFUj2HPUUv1w7pM9mA+V75wv69IacHSbrzjlloG7ENXjPLx16aVQJqXfejeYW1X1WytvbpYl2f53B5R4spUBVsAGCqH45eE7zjMuHImr+OLWJQmz9Lh4yT42jhppUaqHW18FpLyAUnA65h+gUk14J5Xgp4eh6oY/l4vGx+2e+C1adEvslmBCR6VxVxnCA0l1BV1Ecd+4tEb7d+5RNZszX4V/MbgGD9nXgR0B5wcs19sAg/shsQ4sl2iiz/UPFXAkUQIswduSBzXi/hDEVXiUun7LhKyfMz8Cenh+/tloSElQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199018)(107886003)(6666004)(83380400001)(2906002)(558084003)(66476007)(66946007)(66556008)(316002)(86362001)(478600001)(41300700001)(8676002)(36916002)(6916009)(6486002)(8936002)(26005)(186003)(6512007)(5660300002)(4326008)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B6vhQ5V9YurORak/C05ofGbEYeFKaE3G8EK2xppf3ac39FZggb2MQEU9f9CW?=
 =?us-ascii?Q?WHKL5dFGORdN/ywHWTFuufNS2/OzNxFfNqyBJxHtaUQ9U4b8bw1BOXRaMyLv?=
 =?us-ascii?Q?sfsH6krqEWPr3RhQ01BiyYq6PgvJ8Gi67TeN4NSqM4fEbCaey0YHs5wmm6nz?=
 =?us-ascii?Q?LaYSL2SivTv7G7OphptfdK+qKnsoAAZgM0LxeNK8GCjzkWWiXq6mnR8JPrVs?=
 =?us-ascii?Q?xnJeEo2J9U8k/oEgh3mDRMRD6l5feqm9o7jhQuFbGwVHLpTketdkEMBDiFTz?=
 =?us-ascii?Q?DEdZg55doSjDrpPwipfeKQwKbbNnRbdf0apeC+jh4qo12mJk9beEGTfsm20J?=
 =?us-ascii?Q?tylCQ/RxpIogwg8uvdUR9rK0MM+K1Tsqicxo4cP5C8Em4T2kaOqjuXLXLD7U?=
 =?us-ascii?Q?7zAfUUFOSyQHe2giJELyAzma+7ed1gF1RCHnBVBlnUY7XloT+V0JUxmMV6sL?=
 =?us-ascii?Q?tgisu0Dw9L0WjMyh9BTFxF96IUbgKPWLYwyePtGf/xYoRyeF/Y9NE5ax5rNP?=
 =?us-ascii?Q?z1dEMtMIseD9AmR3sBa1ATjTRMT/MbhosckMRuRLnjlQCg4h7GBJrMBuuXgc?=
 =?us-ascii?Q?3dOrax0vTWFQ7fOb3XUA1cMJFEbLabq8HUpQW9eBXZQotPoL8SZl+BAYA+kv?=
 =?us-ascii?Q?2F9DHiY49zUO4jedW3h9K9ItnDpKHu51SrQDwx9JE/lKzeRCLFaYtq3+8w9Y?=
 =?us-ascii?Q?Je2N4W68JAx8Ti8BB6XMG3tyQ8agGHO5/1oEV9M4Dz779uZYCtM8TkOGpAm9?=
 =?us-ascii?Q?r4+qcBu7TzfsbrntiQM3LsE6ZFaG+5fwoOTkhWuhsVo8t58ymH51sdEKuScW?=
 =?us-ascii?Q?ZnkRxH4cKjqzL1B5TD3Pk4Yp2wGGJ10taG/3XLSQHERrJixivohbDi/rEluQ?=
 =?us-ascii?Q?rNY6xWrn27qo918BJdGEtZVetRWG8W7MtvDrwKBXWVT58KyOoKbjbHsl7tct?=
 =?us-ascii?Q?u9CJ0vMtLSyAIX+hGcrKrnuJgF/msImurY4aWj7mJ4Aa37zsKHzj/rdrplMY?=
 =?us-ascii?Q?Tm1vu0+7yCCT/cKbS1dORYPSYB7uq4uEMe/J+hwnxOMSNgpAe3A5f5I9xeJu?=
 =?us-ascii?Q?LoRd0l9TqzkTeL1ucCbsBlSDwkRD3oHtpB6IKHxV4WeSYqdA0JGDwqb45L/p?=
 =?us-ascii?Q?cmYimsro6U/9kTNcjTdItylFHuOlLvxNFTcLJvWwWh1haRO8sPIK36r0Blg1?=
 =?us-ascii?Q?EQxB28jQ0L9A88Yuy+zL/7ml0quSSboWp+OuVGVHqFXBnQz9SEvfN+SY4nqm?=
 =?us-ascii?Q?/T0Esi5gPhaK++ehnkN8quSxWKCjcdKlIeIsg4LHmn/Mk+YUzSEMJOWRoKBE?=
 =?us-ascii?Q?sv5gsiuL7AGMji72aGMN3GlXxkhidUQ/7ihOqG8QhPANzbU2eiOwxPHat0CU?=
 =?us-ascii?Q?Oz29H8mnnwU2kMD4ln43MkANFFw4hxAQZpKeA3Z9M4DLMKadHRacQktnpfbr?=
 =?us-ascii?Q?ZbZdzo8MUTRL++MJpcFhT9DsCOn42557arlJQUNYZXcCHLF6cGLURL7Hsebf?=
 =?us-ascii?Q?POFhNik50nerOOQ8Smrz2GDaT/wasYWXaX3JBB0FtIPhWaBptZ3bDoOb+yrL?=
 =?us-ascii?Q?Whf+dV3hxRkeY00HXmR4YxHRV1ZeF85fWghrAZLB+jgCOIwahvg11/LdogHT?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2EXQ7axFzvSiYe5yJzlE3mWXceUgQ2DXC+zhhNIM6KQu720cyId6C8tHBTskMmoVh4EGCNwljwtAX+BfFJ8wR4WuRUJbQK9LWAgEWx3KNhsiulWnna1HePhrSkbyfAJ4N2Loe3bfaXU/CK5Ju7IIB+rQB4jgJsJ6CwOxwVr4T2OT2HomQTTou1R98yJFnYAqaLIVtdUAnhBqZ0JxP8II2CO5qU/f/hY6GjoHF67HuXqtmSvROcmRZ9jhVNqbxi9XBmOyCnUdr10c80XQv6lB+UElP8iK/quT8nnoJOK+0nQYXvJd0eFXGc8Z36I99ojBu7wOo/AQWU8RMOrlIx6hWRmyrPcsBDg8IuRXkkYOf+yviFejjQ0gUxAQFDKsLwxTeOTcdB0vG55hQLeauqjtE/IpqBr+uzsc/pHsthFUZjgcLYJT7AmCZqLz1qQ/998Buz+/bsT3tHmHF/3fy4eqJkCf0/kXWsDLOl39FPctm8EYYRHu+VP/mdcIfpv7JWIEWmlLtpUTBT2AiZWizPHbJFGCPmZhvPQmGhd5kdyK3TZtyjiz/tp77sUmzvpUhzWYSR/4r8P6Kaq5nHH+mKOrWIqgECSh1u1+ZgzsF9fO4MgR3URIpRClSTjwzCQdx6SUiuBBPZ1TFYd4YXE1gT1AC/kh3QKKLrLxH+lRV4W7g04rRPMDC7KLI9+BE8d2Ry8x0U5G/bfWQaC2tahulLwCCHvKiXQvOWtpIadPGLR0+6xRWJSqCPNTCCXaNct8rWz7PSO/hyxN975WPmaDj5+dH+uBozHGofuD4WW2LDhjuYr6RLgnKQB6pimlgPPWW85yWHkHkuju0064JI3KivtC/w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00770d19-c6e5-4f2b-9291-08db1462d3dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 23:24:49.8952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xmoEQ/ZrCi6kfgnbBmjjM4Yehp6Df24PKfILspW83/ByEY7A0VYudrsX89e67NCxE8T9CYNnXDzDzJXPfRzwcw4po1cs5DgflmPa95OslA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=943 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210200
X-Proofpoint-GUID: CfsWfCOAy6eB5gLvQ7B1bdR_JX_SPKtM
X-Proofpoint-ORIG-GUID: CfsWfCOAy6eB5gLvQ7B1bdR_JX_SPKtM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Fengnan,

> since commit ce70fd9a551a ("scsi: core: Remove the cmd field from
> struct scsi_request") stop use sd_cdb_cache, sd_cdb_cache is unused,
> just remove it.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
