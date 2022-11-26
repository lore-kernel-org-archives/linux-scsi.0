Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3945CC43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiKZAVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiKZAV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:21:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03C550D68
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:21:27 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APMiQg3001271;
        Sat, 26 Nov 2022 00:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Fh9IEy4crEHNhC1qy5zSKEOxDpxAy3ChUwlor4dKta0=;
 b=eZ+BlMWAwua4s1F6sNXfm+qrnFir2r+lrCK77ZvGkZftdlSU9ZBg9Q7+rLTY8fYgbig+
 VCKH/tOQ076m596Ol0wan+gb4Df80emubuxKAQp1zChjgGMIgPcPjs3GzmZrFSeZePps
 U+Aq5Dwl0xSk+3meWm2dWev8PhZX6mTAw71C05Q+fpuzqusH5jf8BA93x1txzyz0rYpm
 VVVo2kLh4MjpzLvjLKYEaizOlBMrXDzN07QF0q9rUuEM3uXCN1Hw3rdqGVVVio9Q127W
 tqZOIqL9af43a4wsHSu3hp2ccF/zxA8M18X4lNF4/8K5pS5MYuhAdoIHGfJ6CjQSrFrL fQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd8dgwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:21:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKJuiK011488;
        Sat, 26 Nov 2022 00:21:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkgw866-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:21:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RT6Nx3MBWfl08bqBJZ+fAutSpHazJpyV8bOKAnnjsrGYe0HwoSHn0j1kBgB656Hxp92+V/IFhxcxRWSN02vy34OzmFar2d82KN46qhkIGtEDdz6cQ+Yl9mhhXP3uEaYQT9cf+9+Rg27wD71SS0zUmYDfE+y+7U/UuduHqYeLUfgEmXLFNMcFrT2J7FZ8OuoHDytlARiOox4nt9H0EX+oZNrGA5hz6DIKdCG5Kw/3Uat/vx7+rchr//ypiHNSYIA9jIPVfk9jorIvBNQD4LDOFWIgke0etX+fcyFNgsKfvw/JJeYii/KrxvxMJ5gRDwtDS1iM/wlGuFK9Q1Q6dXXSEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fh9IEy4crEHNhC1qy5zSKEOxDpxAy3ChUwlor4dKta0=;
 b=j73SRXQhRwTKyTGfjwt3G+hX8GTw3Lmbg8OPL9yjKpA4v0plhhSgzUgxgGrLKKs1nPHtxN8l+NI9/9Uzr4+iiCj6MSzz2C0teZKKC+LjDm8R5vUn+kBE/BHe5boKLggn8Nm5JlGIfT/TEk4QZ/PnBPvZjk/9nwAX0ug83PxqnUjy/83biOSNGQ23suL0LbB4eHNQ0dJB8J9qnX0zu+CA2awtAI5hRvgOJHr4H0qg+MTak0W9+y5SYtXg+A9f9r1QkW33CZThrPtyB1lpT2P40hSMbJLD4/xvUO/v7pfmK7e2hZpwZxbM17DvKot0eAJokZa/Imy5GVGQ4eWHK5Lj/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fh9IEy4crEHNhC1qy5zSKEOxDpxAy3ChUwlor4dKta0=;
 b=fMkJyp4Clxvnbih8ezPBzneCEZHUg/ZOC4Blw83sk9mOHigGJ+4eaoidWUeCu0DW0LlUrswLfPEF/wUEUzltB8pRZB7t/9ldQeXsRxFqOk2gpQRVX2Trtad6iQi61J2SaFMNocTL8euhreoY68vO4oKRJbsgbv+7NE8tiUqYj50=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6164.namprd10.prod.outlook.com (2603:10b6:208:3bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Sat, 26 Nov
 2022 00:21:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:21:16 +0000
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v3] scsi: sd: call SYNC 16 in place of SYNC 10 on ZBC
 devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0xqpnv9.fsf@ca-mkp.ca.oracle.com>
References: <20221115002905.1709006-1-shinichiro.kawasaki@wdc.com>
Date:   Fri, 25 Nov 2022 19:21:08 -0500
In-Reply-To: <20221115002905.1709006-1-shinichiro.kawasaki@wdc.com>
        (Shin'ichiro Kawasaki's message of "Tue, 15 Nov 2022 09:29:05 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db52649-77c5-49c7-4145-08dacf442220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9VFo7PX8iiUwEja04W2rFW+hxcYP+WHKjm7BwfImw2g9Tz1vPnZTQzCrVP1XBrgfXnuSpXg7YVXxr1tIX81YOoqxiAzNZlftv5iFc4wGxWpRFtv25goowpBGebDjn3C0yEILNrcXI2BUm8DOlKDhj2QXLlf7hwVhSiDLJOi/dHVkReRVmslRN7S9vdBfri4oTf1RcACUvrpentErWD3hmshvN7uKt1nw11aMfCdHR2AmSOY3wwfeGYsByq7zCe8/IU19vh8vmSx5N9AR9C5aHVvmO7X6GtdujbN1LYQCM/5G7NzWPVCw5DfQqJejaJsnngeHkb3PT17kzrpH23UdB7K7MiZr0ZF/6sMebfhZnT+qQxL31Ga2/LdjBrqMgPjHPKUsppLvC0B+7orI9DRyqe3pmz4bpn4YpRQbkqq/ohOj+dHTCmAWc8siS8y4PdJe4E/b3Rt5PulBlCPqL+NmvRxz1r4aSCxRa8pXN7ZqjK+FqCsXBa1RPXX1sWdHiF4x9vSqe+Cz51EzAOPAJz/UZcJ22EQLL9cH/1me44W7WmKZ5qdti2KSKVrtM55EgxdfwzKUVHsG1bjAZTuLWU9kgHldHQsDFAJnxt12pXeRCj4iwR23c0Twwa7Gb+tabUdGe7qVQecp7i+Fq2yXKg+8PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(83380400001)(86362001)(6506007)(6916009)(6486002)(36916002)(54906003)(6666004)(6512007)(186003)(4744005)(5660300002)(26005)(478600001)(66556008)(316002)(2906002)(8676002)(41300700001)(8936002)(66946007)(66476007)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vvGUwd/mxVUj6ODEJx/VDKU9IcN1oQjYEchbIr1fPMt0z4BHFWGdRwx01EwY?=
 =?us-ascii?Q?j/XWt7bT5Tc1dlN85RsFWaWNpoITDc6Gy0qkVcgRpm8dh5L1aL/lLoafFLPu?=
 =?us-ascii?Q?vyCp9d7hzLqrMeF1pKoTORRoQPOO5e3DseKLPUJNowtf6OzpOt7t3N/i+b5C?=
 =?us-ascii?Q?W3//Al+XZys6u4cmHikQlFIclGGsT8hF25yzvzqvkFRN4v6J3c8smytvi/+g?=
 =?us-ascii?Q?hqroOrx95zcgRSQzt6ItbM295R+lxxzGMKrCKSP8+SLvRaFGCrPocQOowCRL?=
 =?us-ascii?Q?DFhcU8IFetbzlCSZPcuvYA6W5aWtUTdcdX4y5/CleHOd8QgOMQG41fiXYUe0?=
 =?us-ascii?Q?mq2OkbLhW8SBTAa0qTH4mu65/CvXOZsGDjuBa5ZMGldggRFJCFxU/E66AdmP?=
 =?us-ascii?Q?DUZ6ASap2vqJhT4sXyPBbOQEuzaossb+AFgzmKyyRgxB7kbCpzcY3zkg6nGn?=
 =?us-ascii?Q?mKunc9NtZCeCGpoCLzCJTXuO0M6eHNlCGJbSyzMUOj16v8zWzd4hjQINW52s?=
 =?us-ascii?Q?Ju0R7M2Lcu07jhRl1RxHoh9rEksyH7XHbATbgtIp60EhCXBEUvHNsBtDzLGh?=
 =?us-ascii?Q?urMH7QJnAngCp2z83EnwQ5FsxkzqbRmxmEX608VngH/jJZArJfKMnk755hpg?=
 =?us-ascii?Q?hX+CBSwB5Ynst7EwOqnB4Q8KVykwFG7muY8BAeYhFuBAVRSdUxLUfYqUfkn8?=
 =?us-ascii?Q?+n1bUMmsKGRfI5z3KpvEKaUECv3CRts4ZOKX4lFLW8BrCPZFSDT2ANE+GBm1?=
 =?us-ascii?Q?l/PstVQOZrcCd5dPFvLbDqmwLL9lagYoWm6v4qqjB9zQ7EYP6y/kx7T6g3/i?=
 =?us-ascii?Q?JDYL551HEU/MVMsY8ybqJeowis4tY/jyMhFGJiCL9hssoDM9EMwDPY3Hednt?=
 =?us-ascii?Q?UmX6Pb/JLKg6gGW/AKgCS1D/zj2ZKN+W97F6YpBglfvW27EuyjZ7EpVnUicN?=
 =?us-ascii?Q?wf+ccXC4NUc/0LZMJ2awr7+O3d/Vz6wnVLXFWxW5WBdFC95TIm/g68nC/N/x?=
 =?us-ascii?Q?NzqcplqeRkpq+N/IwCe4k2nNTtn6PJmKkHuy7W9CiACB5T20gxM3HXT4Qd9/?=
 =?us-ascii?Q?DudSLF1bBPfG7m+ZC+JOPyBI2IrLoV1n8JTxZdawcJnEbeuOg8Exyn2WpibU?=
 =?us-ascii?Q?zWLI6xu+UpU6OKM9YUfPIFmLCTjtEQaPJbM1JelhIdecOMVbsXvPAIj38zoM?=
 =?us-ascii?Q?c1HeTZJrPDhn27wu6pNCqLzEkku+tmVh9CQQmg/ZCfQDGUdpUCYDWFe/XlKx?=
 =?us-ascii?Q?RLN+R6R+4CfTqpfnTr2cFxpDp06MPzRJMaoDOeNDhQlpVdyNJPPnLak/9Eyw?=
 =?us-ascii?Q?KOHoJPeJRf9pZi03C1hoKBSLFZ8ZYqaUXhco3I2aRbU2oLXh86ygxsNovXrB?=
 =?us-ascii?Q?N2sfK5lQJEsTlkc2aV9SAct1hNCceyQr+jPKwCQXJvNygfEWmjbL9c5lpuJ6?=
 =?us-ascii?Q?G/MnYVR31pjYuB0xh1onH7ggo2u1ujCMCnLhoVxGcJSkSOAc1QQu7srcpsyd?=
 =?us-ascii?Q?z0pssWdUzvFpuAdkXFaoJoUrbfbrjMCw8oFiR+p7idxJd44+6unq2gR9u5YT?=
 =?us-ascii?Q?Usiojhq+s11XzflGfldWwh0A7bujxSARwrxsgWH6tJ6kUoDb8oKI6ZkUGqKS?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ailR5Q83XZ8haX2/Z7L7nNO13aNhvDFhhXeoR4cIRz/EgKXLTgF/AbxQVnIZCXdD6vnICWTTa0zfVThI7z2hYC5JFMU/woMJ1fAVZfC0bPgMdBHnnaycFfPdBVWCAeV5Idyi9ItPIqkQg3UXzvIHEZ4V9vbDPiEmdYA/gjqk0asQcTNU7N5bcP1jbz3VyjrwlV4GwhZEFMwJ9lZmqzJCqvBU8huTOkyttroLUhH3lNnvArDMxWzcN7rFAPqM/KWMuRV/HM+1BkOeV0F0+feuK+YQCZuJl7amuKaDIrTeq9qbz/uE1iJ0R8Qjb3CNad8vFn+tHQL0nSM7XAtCHqE7TO/2IOFWsSVSfuNKA4r86BUZk2eCyvOQ+xDbeCDNEssKU0QwA4sNL2khLL6CQHvAZxOe8lWSmiQiU/+vqn6SuivRzb2e1S5bPRCKRfQ4FbDk6F26RZ2M6oYI5kuZvnY1bB5U5/guekh2hKkWH2kVOVwBeWH9exQWi5l6xegqZnkgp1KfFpDpOAIymIpeLYXQev3H6G+GKUTdA4prh1QtHSaSwPpI+0W57JQfv2JLQr2Jh95p7EvUC/mIBjCHLwO+k8fqBSit7ZiOVMVisGLMuMlaXn+AWnZl3LpCd1wZ4eoOFICkj9ZONCOHEsCEG8LAJHFx2HyCGTgE/QZ5mJev+cZ6nmq15kmAyFQbV8tWUv73Epef30uB6UvcKaIlb91pZXW+/kb6cOFGbktUP8BqdG+yothOL+OThFnzSq5AFPg+v7VExy3nJnRcXmKWTDNB4pHmpY3gXQzCKQ0e24MP/P3Ge2OuQtUI2CSyOy/NQDH8Eyha14xEgbjWmvf/PBDg6JsoP7bdHwhoBgXIj8z2oV//fm8AO6SXhMT/QWK+/wucN2pEaA5+4cIJ9Fv1UY+gZA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db52649-77c5-49c7-4145-08dacf442220
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:21:16.4705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXRzUmi6mlBRjR43DBhfNJyr/liKxZ3FJXNWs7r9AkK4tsIfWXGv7uEfuSIWwd1xqTvJ1NLpM5Foo7Fpqy6a96bf5mOAcsVQEg65lJMynaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260000
X-Proofpoint-GUID: ExBn6SLT5EzvzUcoFj-ep8HI5WrXHEvW
X-Proofpoint-ORIG-GUID: ExBn6SLT5EzvzUcoFj-ep8HI5WrXHEvW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Shin'ichiro,

> ZBC Zoned Block Commands specification mandates SYNCHRONIZE CACHE (16)
> for host-managed zoned block devices, but does not mandate SYNCHRONIZE
> CACHE (10). Call SYNCHRONIZE CACHE (16) in place of SYNCHRONIZE CACHE
> (10) to ensure that the command is always supported. For this purpose,
> add use_16_for_sync flag to struct scsi_device in same manner as
> use_16_for_rw flag.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
