Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D527C636D7
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 00:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBVA5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 19:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBVA5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 19:57:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C741E10253
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 16:57:31 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMiLKu027234;
        Wed, 22 Feb 2023 00:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=MpF4E6F2RB8VAk0QqzCvvvz1lnpJvI9vVsfxbXIuZ30=;
 b=GTJ8gSJvodP7IaBpzRNWWCtPbLrTSAQ6YWoPLx+Z3TQkT4bU+t58UMaRq/yoYnNwcPQn
 PS48o+YwjCg3/OKHihtC5QyclKcfSGhno9PX9tqE23bn3eMFek3OrbKMie5Ufi9D9+2h
 r1uoB03GQ2nSWIeBDpN27cVczEuRmaYQB9h8F5wr7Y/XHHTJ4lYiK4tw8uoRcnjugUjU
 XmZdXBWUfLMu1lLkDvjSHnaqrCMkMnXp+u/W/5nDplBGn/EWKx4Sx4roemCI8I96WWDZ
 re2aLXxDpLco89/cwwSzbLQ6xaI6fiWjXtl/vbgp9LYPIPVlqdG2r0sN7L0jqoUm6M9T zg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnkbpq87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 00:57:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LMiKwM023177;
        Wed, 22 Feb 2023 00:57:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45yc8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 00:57:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIQVlPgL1fSzBi2pKBhAlBMM2RTw7/PpPa82UoSn3/5qchaa7LA+UgKRT4Avvy62B1waXEU+ORB8LdrtH5QOn/TVostbkbX2A3b8g1g+DZxbASbqd2W3oxHiH82igOgHHdX8k+zmh3lV9rPdwOgOGA2B2xwREmRmA7XFk8T0YVCyTPk5c6ojdvEvk9Fn/Bpd6UdUM3R2XwD+u9YKRsGhc0qbHMiewaxYhQG2/euo5Ll0TP1+PwVrgEuMErttnc043zAnx5bRBUwzjqbkoSh7pm7NoMj0DxOE9gGnDrVigHIs/LGG/hs698u3vfiGrYVzJKBz4u2IS6dUO3Zp6FtEfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpF4E6F2RB8VAk0QqzCvvvz1lnpJvI9vVsfxbXIuZ30=;
 b=Ms0zC7btK/KQoxCypkH6vOdtzM86JS2Dj7NgnpXdi4R5uDMY4i8Yu1jqkwtkghndAgaVx3VNsi01Ap6H9DwcvD4T8R5EzD83ALc3tax8u6W6R6eFetMMXjXhB2JMGoUz6aorj+IqANSVnpY12J5QsqJWKH813BUSZrX3D6upr8DggmCai/BJZYhBXFIEqD94epnGas20aj8bhJ+xRr03UbOLFfD8KIjwtoixvkkGm3XjJglnp/X85pybq4WfR3R9DMSu8WRWxyIAXo5WvmZh/gKHyTDtKaMDK2boIywtAytvocskBITsgiw0lP/K/as6wMXZeEzVDOxK09i8Ce3SYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpF4E6F2RB8VAk0QqzCvvvz1lnpJvI9vVsfxbXIuZ30=;
 b=UNilbVhfRhdjcQ7f+Tbh6teaM6JbJIcnvVO1FXJkQ2dSIEkEKYjhYGGxlEwVztIbmVfXGMWVojTMDrpiSaEjgFGsw9NO8ZUR59veT//M+X7QLqQ+/C/2x+uctpdw+V1Cs8C4wPDhFZkVPU/fDaqQCWsjybkFDzs6HbRrWfqGwR0=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by PH7PR10MB6129.namprd10.prod.outlook.com (2603:10b6:510:1f7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 00:57:24 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::768a:9658:9df:701]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::768a:9658:9df:701%5]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 00:57:24 +0000
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v5 0/4] scsi: mpi3mr: fix issues found by KASAN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zg96pleg.fsf@ca-mkp.ca.oracle.com>
References: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
Date:   Tue, 21 Feb 2023 19:57:18 -0500
In-Reply-To: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
        (Shin'ichiro Kawasaki's message of "Tue, 14 Feb 2023 09:50:15 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0408.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::17) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 175b0a86-6b82-4495-57fe-08db146fc28b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbHaqQITGmfxF4e4qNCfuHmIe00NUWe8PnJXdfnonCB1oJrfidmP18QgiCVumKO9CB++UpYOVh1amqvFSpWcJ9RXryn2cKq7p79JdO2gjpi+hGlWej+AxiqyKpumAVvZm8JYr3oQenesXkryZXIErq5vfnKhfjPv7jNjdAkutAQUGD2DU1jbfUqb3CDDuUVaCy0mlQ8/gNZfmUqtEJCfKnKxT4+tnkpnl5h3iC4eFMj2feVWFAcMiLPjdBJsr3rsXvHo1JxLJPu/nnJxdfdxVLtYVZeoLP4m9Dx/32tuoVE82NlbLrWWBEWpoRXG6NCqqokhkxY7LQ73aslBgwGwyiDyGQLRuO6s9SF1YLsmz9Ivx9GYHXDsMqLotaOmF510OXXgCz/fnmqWRx5cJIXK++x5/Z+Iumnh6KukNtSFSz+OQU3KjGRTfeNq8i9fKmbjCrsQaLj+iXZyVwQ2IKE19qGyJEs5Eg96L7M6YDixLDSy0KnlMG9yt7ZDKR3wLR5C0T+gqe/tVIvWHXGnfRb5CbU/ft48AUACUSlBVN8vP+kXvMBkXJM37oFmbRGyx870amf9mIkXF8yumA559gquqJkLsy5y1wEsuMj5+obrZ8nP12FuN/aj4k0oBKX3XZHxMhg6mwiKk2ODrtH1g3700itPK5CqyPVnZ9o66SnuJ31wMUtFDw6UxZjcb5+SDaI3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199018)(83380400001)(66476007)(66556008)(26005)(66946007)(8676002)(478600001)(316002)(4326008)(6916009)(6506007)(6666004)(6512007)(186003)(38100700002)(86362001)(2906002)(41300700001)(4744005)(8936002)(5660300002)(54906003)(6486002)(36916002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ct6oyZyOxvqD7nCO2aXVMcvvwSRT1rE/usyXi0+0Fxq/GyDVliK6xb97oqnm?=
 =?us-ascii?Q?NcnIHxjxr9Fr7cecBHFW4NhmOgxf1lVUZsZLdXGNmp2hV6bIPRpmp9j9mJhj?=
 =?us-ascii?Q?GrWbkuXN4XgyHzQjn1RDkcDfSGCzo7VJ/IVSZnwJfPJKHkmOPlN2nLe80DiE?=
 =?us-ascii?Q?bDWegp+yd0f9cNBfwAmnKnfLwSIBdZW7G8/jpbEvuu4z5DkLG+zPc1+CXHht?=
 =?us-ascii?Q?iiO2f9gKxgjOJf+e+lYzUZ2FU8ypzWbA0YLgryH0bn/B2CUu1uGLIa+v9FQK?=
 =?us-ascii?Q?cG5VU0B58WjFwoFgzxP52Z+2OfoJozPYp2hka1FCWoAfB7W2jwHEbAZxj8TM?=
 =?us-ascii?Q?dMUsTCWRn5ycseuIsrsxJJGXm48xWSTvhkj6oSi+MqSAZk15ChSq0k2grle3?=
 =?us-ascii?Q?mu7QJhJrGuWey+TQEE9hvN8tsATzx9GEZBCmi1wrdHlOQtLG1bQtySXS5Gl4?=
 =?us-ascii?Q?Yr8xSm2svFCktRI6Lt/aX/DCNZ4QEUjKBgDHcFidNEUeyNP18TbIE5QoyVOE?=
 =?us-ascii?Q?uwIdPPgtHD8odFL9OIRNJ48lyqSbOY3wDBU9P0U6NHCSAIHgeZgre1+IHBd6?=
 =?us-ascii?Q?Qct13kaBBzZUY85HJXR6weZwV1guaG87mXHVuaoej1s6LhEBwzWRzL56KcgW?=
 =?us-ascii?Q?PTipMOFo6oUyVT7A47gmuDBgk6zb7lxpqL8oYZq/d/rcFLs+oeQ6gvr13na9?=
 =?us-ascii?Q?EDoHD4uNDjkwi38hVRlVPJV9p795teWjquvUmp43p2Canx9nZvGCwuxG6dzT?=
 =?us-ascii?Q?sLhekYQX8NSvOpnCoIpNlABDILpJceAD+Ze8NF7YaKDrv3Cy9cgRM56Tv01o?=
 =?us-ascii?Q?8ZybSdDZbHZRIxz/MngYQM85LQi2ZEDwRUfvkxkSQT6mYHSPxqMmPb1Za3YQ?=
 =?us-ascii?Q?uO3MmRwSmlS9SLPE7Kp7y8FjAXEZA1iZ3dsO2PZuZzfb/0TBKeii1BpsBOz1?=
 =?us-ascii?Q?fJ0FYV7WSuNK5tSGFafUba/77HVjulSf+C6f/Zb9yx/MA0AwVvBC1oFB2blG?=
 =?us-ascii?Q?t74cAntCFpl4OvzBlSg1V4Pg/w5VZzFjmY71NIxWUsdR7GlKl88Bk866U9Wo?=
 =?us-ascii?Q?YGl1aeQ3X0K2485J2frPRQ/LrmZyh7Fjhc+R6qyznUewg4bjlEyf5w6mxoM0?=
 =?us-ascii?Q?ORY+42lQXXMnEW5u/r8sYM3/EtMcVLfUBktqn81hiJZkY1m+jrD8/eLweMXb?=
 =?us-ascii?Q?Zrv9a55VlUtP4/PmxUnd5B8AlblL3N+qc5GogMl3VWcua6jKg46XhvvCh9mt?=
 =?us-ascii?Q?MfR1rE5vW3rtHrRUbfRRZHYCZAsB4OJfYOQ/4ZeHJTdH/1j1O3Y2iVsFNWIc?=
 =?us-ascii?Q?WSnjowSJFiuFfG6CYh9mzE07VpF1FAX/0m3QhIO8fKuSxdEwHrF9wipbhiHr?=
 =?us-ascii?Q?V6+jSStid/REOssUgmBr4BWtjdS79fzW7RTxZYX2l/TGDXMekTQNlahNax9j?=
 =?us-ascii?Q?HBDZG6qHflj1lARbwAhyY6uCxAiIKjuyJP+zHStmWuPvx9PBBb/RuVLAf/62?=
 =?us-ascii?Q?+nIQB4qbov3fyF9uSAWdMbdHWDI/57+jbsn2Q/Xr8TIZI8dMA4YGWvHpifzS?=
 =?us-ascii?Q?biNKslmru/PWzCnN6Xgmp9blxtF1PL3yhTYpXTPe03QZ9nM+uh9OVmLVW4ZB?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: th689yJrIwdyQ8ADMY7IgX8P5WHNey8pq0tEXNTcW7P2fyEdd27AE3nxtCideCohS0IqMrFAdFOBFQdurOY9iND2Fj3EQFAAI3jq084voOtdVRIt/BskDxwjcqBQPkwM9jfzO9DyMJTLbPekjaju9UtbhfWuQj/aZea4kv1XlpjZYRJTqp0sA1k3NDe2XpOYLwkNVaS/KlM2lFIQWr0fdGKlLy8ce6/RRX4FgURTd5X0VB6etaLmIdicrh1uLA/WTInpD8vQ90KybmEPcIuLr98F4ImM4T6iKF2vlsZSZlp7kB81RHugSIB7F/yJSkoLLKJgX42XkWLdE9uOsiCqpTvmKUmUY1UObPVmvgrrA4AcKdqt6OVg+Vu6bZBA3Uek0HBlTYK0aTCB5lsrAQO8DCAn/8SpW+oLELUzDX3r75wirH9qsL847G+eVD51DDYOClYS0NjhQV/yg41bAOnJyF935M1fIakPn+6Qyc887qLQDfNrqswvHxKLN7dvuqYWnQe6y1TvYt9fwZdVUrnLM/4PA87siKwqSLeAgGmg6q9WYbKMR+KKzzkIGa7aCQcXLBTcEoqAJHEUK5d+l/FHY2Y6sDE7y0N0Wq/gWIoiFyUZRH7ZZHkTqZkF46vbXOb6Vp6N5WkPGssoYL1YaAycaSmvSdxF4eFOdhj6uvHlLWc2jYQ0Sr2OJDudYeu2EYABJDATFElHzBtMrR4TFEUpEOs5CaCqCeSBmjnLnaHYbIDcByf5w8oDenNgN8GgOZOkQZY6ZGCoGL8EE864zQPVkGdR4whAqh+P6GeO0X2EQ+ddQaU6h9ZRzKq1LzRjolrgeViztc6ToHWHMAwtmn82JFh8SBMv3sutQayWoKQ86PgiKTFTfNBPoHE0a50XSWk8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175b0a86-6b82-4495-57fe-08db146fc28b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 00:57:24.4487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A93Pd3MGPueiwW4fD2vOhCbgg/ZfduiljQw/2U+Egq9dYO3GDta7N7Fz47GSd2NtqRyV1EXArBD55tHWT772YgDC56LlR7q4Kgw7g0WM0zU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_14,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=792 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220004
X-Proofpoint-GUID: PGq02MLq7_7xi5eAVXxayOqYON9iDogu
X-Proofpoint-ORIG-GUID: PGq02MLq7_7xi5eAVXxayOqYON9iDogu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Shin'ichiro,

> While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel,
> I observed three BUGs. The first two patches resolve one of the BUGs
> and related issues found during the review. The last two patches
> resolve the two left BUGs respectively.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
