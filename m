Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3331C77B76
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 03:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjDSDLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 23:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjDSDLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 23:11:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2EA46BA
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 20:11:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ILbnh9023398;
        Wed, 19 Apr 2023 03:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=g+J3sgLC3PO8WhzyKj14CnCY+4OdV8gWXN09WZEFDJI=;
 b=TchLnGqHI5plnHkDZIyOaOJjtkSt8J2ohTzYEZiDShAPjL2+CIt3m48scBVqYHpJk2/o
 Q8zb/sQ9ypAdKb4eH28KmCnDoXG3zwi9MEI3uxj0FpKLYkDsy1NiAWqSJj8J9uWGkWZ7
 EB7tQviLpBqZS7wfzyFgS8C5zMDSI3co9uF7PsubhNqsoTkO9l+pzTuBqFHC87VCT+mJ
 uewsiPEZGzmqeRiYOWJxyma8JlksVExuTGtx7dU4zJuql4LB/NQ65bZrguY3wAygcEs0
 gUAEXIxj6J4Y7Sbn3mvA1RDQ9gmhTEsB9TaOolTFYVTBhKVlXMzUyCI9foFO8fNVkt8F GQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyktaq6fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 03:10:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33J1d28e015624;
        Wed, 19 Apr 2023 03:10:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcccdq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 03:10:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hapyIPb3GccWOQLmhWkABPmjjz5YnjjarckE/M6PV7Peo4lvZJR2Zn+LqIXgS3w6o0hbFltNpKS1WKxE6OVCfdnQO5g0yZbmVA/1h+2Zl2tmKDPQpvXfrEbbbYupqpG9wialcYz+cqbKz6am1YnrRh+VZy5PWAzgiJQhAmgsvCJ8lCC1y5jAxDaE3zraR5bG/taMJw/i+BxMX46U0LWAvG6yRtO+mtvc9pYJrqje4j1bS5eL/xLV4LS2mIREhJPcKNOBbQd6OrseqlK8HoTJUBoxIXl1zh1vWZSXVAd2Xy97DEUdfyX+n7pV82ai2OuGW8ckVsSxAPq8eQVJvvCDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+J3sgLC3PO8WhzyKj14CnCY+4OdV8gWXN09WZEFDJI=;
 b=hl3h9Bxyr4gqyHksHw0a41R7aDvb/9NGNOG68KQSSkWH4wcGP1gYBpPZ+opyuWQE+u9PpJXW9fjBakFEKWrrBrNgroMaJzt7D7YWE5RyxeXC+6Fy5poWpL6Xc4yNe46d9aj9BR8aswGw+kGq8MGA1YLfC7SVNWRcSphUhm7pGeJip6khFnlCNjY6Z0gLC6YpjdKmDzqD+/Abjhaw/JgznIgb273JdhX7BKr6kfx7fpYcUWNgsPaxJjij2fLwHmJk/ngyYpHg1BlbXXaUdTdZp9QTxrTMzvEOuIFc/iznif4zD7n5+Vie3CEx3ndsc2IvqGH15t8ELnDq5g1rusSz3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+J3sgLC3PO8WhzyKj14CnCY+4OdV8gWXN09WZEFDJI=;
 b=S9uvMdmCbqWQW7eIAR4IDGRWevuTvnnjvhoyrbkNJgr+jcA0B7VIszT/R0MMznO8aLaFVAEDmYhBL1LWcvW/XsS9ceEXWngP00/YXa8jXstwE0JAPBWmn26bvmsJ7ZNw583UDMRzAxcT0gDkUjWiQM99Jrl2ekiuixuUqgEjgoc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB7410.namprd10.prod.outlook.com (2603:10b6:610:190::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 03:10:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%6]) with mapi id 15.20.6319.021; Wed, 19 Apr 2023
 03:10:53 +0000
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        john.g.garry@oracle.com, wenxiong@linux.ibm.com
Subject: Re: [PATCH] ipr: Remove SATA support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8hspnww.fsf@ca-mkp.ca.oracle.com>
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
Date:   Tue, 18 Apr 2023 23:10:50 -0400
In-Reply-To: <20230412174015.114764-1-brking@linux.vnet.ibm.com> (Brian King's
        message of "Wed, 12 Apr 2023 12:40:15 -0500")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:8:54::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: f519c877-05d6-4d1d-09a2-08db4083af5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSd9PRsKOHfB10ypW1idm9ylFZLWCIqmmmMtFEndljz4id3SfOprDEHTvhUYRd84lM1IhhK+mf036wZEJmfhopO3iaAMna5ggyKgNh/tru0TLcuwVjwlEOBQ0NDnLhhLSDFu3SwT7FswERkLZedlXhpd6C5fzXScqs5oO7o3PAla8irRnWbnt8nuniqJJuFNvnrfd8gT0SMEgoMKs9ucIJt4bpFAd+0XgTAprSEMTKj8T8Qpcpny4VmlVsFXOFt77CpLQDafEsxnkGBouTNe1oZdzJ92hD0nhGG/e7rtRjKpLdnM/Bcrh9nv9T7Y8heVFhVuzTCOPo+1U1iolxJHoKkoZmbdLSqGUwSKduEGLgdgzgJeOHKWO3ZRyfJBNhC3c/jT7AXLesa1lTosYt/NCoVYkHlst/4kBX9ZWiEmcr7/iDyPWO03ij9o/5TfLYUlnn6nsD65MN5mQ2iDX4pkx6R7Vf3J6DilLsnToHh7hVCGclE6PfRJsft3c1YmJUu/kkhSCvtKEyiAP6dPx4wAtffMf6enudY9oFEoQBI+nQE9XRs0ePCRrV0FR3mOZ2WW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199021)(8936002)(8676002)(66476007)(66556008)(316002)(6916009)(4326008)(66946007)(36916002)(86362001)(38100700002)(478600001)(6486002)(83380400001)(41300700001)(5660300002)(2906002)(4744005)(6506007)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i3mtQESqn9h0tZud4seUULAxaEey1cSEOz9ntYVH631u3prYAZBQ51K3DMdA?=
 =?us-ascii?Q?ms7dwB1SFMEymLVeMItWrqHGMw3QiWPIJrCXjmkhdBTDEp8pLOW6Zx/d6X+i?=
 =?us-ascii?Q?HXydcLTpeqWpHTNLMWa4JfwsFgUIi6/l598ckRpwXX03MznhUbzNvfxbmSUk?=
 =?us-ascii?Q?JdobW+U/a2otp9VogrSW1zYA5gugzn13EDSQcaUcTx3bQZTAQfEJbE/ETw9O?=
 =?us-ascii?Q?7eoAhKEXhVVgjy6aNp9YK3NuvOsNjURQ3L3OMVvXvr/jVNDcUaoId75SP3Pk?=
 =?us-ascii?Q?UmJVdP5wvBj7Xv/BAIyoSi/r6VUOEnxrNZvwhQNeY+tWNmTda8Htt1jBlw4a?=
 =?us-ascii?Q?CvlM1DJKiKz1qVWsrlepRzz36UnHnJgmHsNXpRBEeDfvJxjUnOSmJyXtD11c?=
 =?us-ascii?Q?dc2Sa9XreoRb0df2gmptf0e5+freAJQnnHfQ6XqtH77lOmP9paN1xwGaDNAh?=
 =?us-ascii?Q?+8HCnwdn2g+UvdqvMe2aNZzvKDAICtLl+u4wBddcm92CtgALJXpBhnUmKj23?=
 =?us-ascii?Q?c9gHPvNEkdmZK3Jb4zof3AxdJrojgvaQYF1PH3SGdEDVgjX3OM/DIvCIrnq1?=
 =?us-ascii?Q?294v01q9BPvT9Ve1FSlqDmDBTjcpUKt3hGh6AVEHlm6l4zSkeSJT/mYs/rUq?=
 =?us-ascii?Q?i/jjCmoigpkjWzXZpuu6SHKg/pa9/wp7PbiG6MKk5nj59AYGzH4w1VAwvPoC?=
 =?us-ascii?Q?9tFQRWFEk+J5Px8a3MdhQI3m2YskVLFfNK9XNK/yqOW5fqC1askt42LIl4mw?=
 =?us-ascii?Q?Vl5DCVnd1yV0yrj6fEfa8R67KlFmdq4OPjKSb1uuBWqgg35n8Z9KZ7CYFDyb?=
 =?us-ascii?Q?bQN7mQUmuqkrPUFVdTbKa2EGhV82r2RavY8veWoYpAh2RNAOzVz2DFGWaUQg?=
 =?us-ascii?Q?u6xowDxL2PVf9ULn+yLPl8LZ3XOt9d9a+eyYXyDbiZtohk6q3qBxyRFRGy42?=
 =?us-ascii?Q?hLapvW9mk/HzTbSPnUng40oQpF26LJHMwfrGFSs2sJ5iuZddpAUO5lvZQZbe?=
 =?us-ascii?Q?GB9Ww28e4z8n1dlVopF9itYwQyoSo+f8HIOYZ+xRTQCd2lr8v+Sy55UflokE?=
 =?us-ascii?Q?FTH5xDNJg20BrPGNsioacirKLJ4HazT5JWLOk0CqXwsudeYS1aBIO49K7WqA?=
 =?us-ascii?Q?CY1ZwhxO/2hCtYafzZvCrBNrsbo0IYp2rWisi3aUxJtMF2atiQ9UD7jFnwYe?=
 =?us-ascii?Q?6YMWcCfGBzDa3tx/4O4LwBUijAeS2p+AmWVZEPx9FsyfVQe9Hf58xDEPHnXX?=
 =?us-ascii?Q?KOJ9k2nYNzfEXQTJoXrUz4RDlbcrgv6zrlBRkU+q/3iaAeFBtm+35NF61jVI?=
 =?us-ascii?Q?Xi/1n8YO0qCms52vPL0KuwzvFJa4PSmCbXioeZt0Jd6QoTcbbxvrNVgobcWw?=
 =?us-ascii?Q?NvBGRUvRL5nhsWoha7HPU0ACPY8/CBHKm3O4uOG3h6Qpwp9Fv/gqJY2edV/m?=
 =?us-ascii?Q?KfxojayTx13IwZJ2KoxYGC5ISNcoAmc2KeDmxv3/bq/IdlsqSx97LoBmm/rG?=
 =?us-ascii?Q?ZteZsQIoXOtxmGEkwGXJmXWcsMnDlJtq/ABwQPgB8bYIjsyLLgRCYjVxvsdX?=
 =?us-ascii?Q?KQEZnHcr5kl5wOBFXGHGuv8a9A1uzQqGxMzgbMDI4BzKxYO1E4XVnHm3UR0g?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Uy+4WWUg/TG/ea9IRogEteFd6BWOSML1VMuvVMK+a67cxDlCckWQeTbNig6DuRNTlmcmyAF5fzMo8Zxd3xIXrYXINdTqMfVcWCTfVLNUpCNYb3RWSIHGon3YjMbGWQVt6SVX7WLrnOGSgl+BpWl00IL4SCBn8E+HmGx/Nx7ic5ll1y3+GA2MaALUuwW21X6nyLp4qVC/pK59qPasMfIQ6KmXMmUbh0Uoc3kxHZEMQOMEHS63vU3kxDGVawb6zpj4eR79ywxHKQvkkPLDB12ilDzrl1gIKxN4cN/lc6NNb+dPiNSDrAcXWCTtmcEyhVuYRcUJE0gZkS3rmHizjGkxMgSgMu+o9n8cgpo1NzONVS8e5GYlVw8Vww75voXfS7udzJJO9HcepPHuDqodeUU9uJE+W2hOHExNEvzP0A//Af3lQh6wYfGCCIGVsdjOuaRj+6cb1D4qhZxOylGjUYqO7W0mhTJnb1vrSGyuSHn7HMCqf7zLG6xzppNrDukuw+xLT37BCS77c7mtFeWhS2caRXejP5wDbUMKkhr9DHHkdoJiUIjjJUhyE1OO0Tqm+krpO1qpHlKT6t7ywi36faWI3w5wBfgJpRac6v0xYUDjL0yWukUAYHvrGSCj3cHt1kQ4UmjLnuSEiIJIO+WVDvKbQvPBAbPHdkq/5LINmtuI0a1bM3LsCchwgfN0TYFszu2zzdojbydUuz6EWU+KQLPxHzxIhDAfufNvkKW9dGTVNgOD2pJBZCXXcdHR/s65cvnFMZhO8okevIrYNipa1/etTdC3o1+wsVTfQjtoybD0wDyy4jBU+ikX/C+3EgmsrX1dKpsMrgv5895hA4uiLzooLxn6qW/J1ox3wR+RxhieVZvVp7yjhB6R8bel4ildRPKmAA+JtDv7rh6u9NuAaR9MxQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f519c877-05d6-4d1d-09a2-08db4083af5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 03:10:53.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAq1fudv06mbiTQ52prx+vfUih2CMoNy6enPZWU7hIJluIM1sHgjOm9Q5CPhPQqHJ7r10MSnbc9Tyxlf/fPKeUklxXgEevSeKkJCEs9jGIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7410
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_17,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=877 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190027
X-Proofpoint-ORIG-GUID: l3vY-zP0v248EvNsR2NF9yyqiLOzyYVt
X-Proofpoint-GUID: l3vY-zP0v248EvNsR2NF9yyqiLOzyYVt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> Linux SATA support in ipr has always been limited to SATA DVDs. The
> last systems that had the option of including a SATA DVD was Power 8,
> which have been withdrawn for sometime now, so this support can be
> removed.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
