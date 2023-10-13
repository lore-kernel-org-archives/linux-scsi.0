Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAF0CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 21:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjJMVBd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 17:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJMVBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 17:01:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59829BE
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 14:01:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DKx08x024381;
        Fri, 13 Oct 2023 21:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=9k1BQpJZtURJdT4tJGC5Qfu7VbgPlDmJ9LtuOU8Nnj4=;
 b=miY6ymhD51TfckQzInFCvBPGgoDkQGDWAHoWbxHBD4+OALl+3Z/86TiG7lUPWvwE48xf
 nwifNt4GnP9HFV9tBPpSAWAPgD1DKWA7z7k+kymWNRGYvl8AHTujgniZbJYhu6dyUDEC
 GjiCJYfVrkBcov7dl+ZaTSRIyd0wxucfjwfxqN5OvqA+dcwFPlg8OUM4GiWR5VUefMbA
 OOMHD4xF6mUfc91XzTfsEmEEchTdw9nx0tJ3ySH9yBcEsoZiYTEFPdkbWSmHSQgG7W0s
 DU3BZ3xCSGqcZZmTKZbayJrjF28ke4uGvl4+O0knOQAf3WsON+trL42yu/8cvO0ya/7H QA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tmh8a36tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 21:01:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DJ89ZM006289;
        Fri, 13 Oct 2023 21:01:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tptcsy8sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 21:01:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj7osViguyi2J7vTuorTuYtdJ9oa6NWrhEwz4jk+36rdqqtCklbjdLB1mMqvhDU8hqxfmNn+QQ8iiyqumC4bTYkP7xH+7tFaQtzPXggafF73Ax9ppD25zNMtpSCTulzS529R3/ITCyGqORAo26YzEpEJssho219uddGpkI3ipgOqFm58mYApoowwyBKxUknDuARJbgqT5Ym0VPg21S4dYIuIy+sip2EjMeT2/4fGQqvzBYsaAOOrlRE5MWx29uTK9oysJVQwMeckjxjjNifmZIW6x+oQRvXwNI2qYLAZmnR+zLH7p+XKANty7yBN593rvao43mCr5oTew02iAbRH+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9k1BQpJZtURJdT4tJGC5Qfu7VbgPlDmJ9LtuOU8Nnj4=;
 b=OkixJ2bMFy1pH2xsmi5NzFD3oPiudjwWW7ihl+IWj1mg3OTghV7kqm0CJWmhvj9KDnRqcCxqOPgoiGK5TKkl6wxxyxuy2mmhCpidbl62y01s7Qu2922WjJGQciQRiGpj0JruGRiVXs2ZOivKuicXVVvuL3NAd2Mh66ImKn/InDCRg6GslbbDeczIUhfRSP9FLgkR6qGQ0gvuUjQDRPAvXHQCDxW6CstT8MNEDPAixXxVolTon76Yzud5Vn9HNgZzpN3HbJv3X3I0nm2kp0RM+smoABR8nptOp7+w2xg70Ph7K+q684ACb84U2Jinc4s+q7O4gEv/vEgYmggk9mF8rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9k1BQpJZtURJdT4tJGC5Qfu7VbgPlDmJ9LtuOU8Nnj4=;
 b=vEJhzX66j0VjYUogvUYUI+dSuGqKOzbpgKKFP+0elrPashLdqZ11kxDnyB27DP07gSxdYaqZA4DsoAKiUZJ0AO6Ltg5WQKDSRUddYhD3Nl8bVIbCaayiqMhYgwMhSZSMb5ZwVQsV0aFklaDy09VjM3Skw0134NlBgpvRnc75Qzg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4219.namprd10.prod.outlook.com (2603:10b6:5:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Fri, 13 Oct
 2023 21:01:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 21:01:25 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.2.0.15
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7h2jkz0.fsf@ca-mkp.ca.oracle.com>
References: <20231009161812.97232-1-justintee8345@gmail.com>
Date:   Fri, 13 Oct 2023 17:01:22 -0400
In-Reply-To: <20231009161812.97232-1-justintee8345@gmail.com> (Justin Tee's
        message of "Mon, 9 Oct 2023 09:18:06 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0019.prod.exchangelabs.com (2603:10b6:a02:80::32)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3daf8e-13d2-4040-68b0-08dbcc2f8fc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQHhyujO9ziszYxqsK78+a+7GTJ/fhmkJzxI9vebUmZRz3h8mo0+BeEK2gCs6tpFqviEaO0vNS1DCb7cNPkuyelNZqpJS3x6spiD/JsWxDLxwNjwKyhs6QZZhbaLl+QNw9GTRsXP1e3ANGZDuKpSD9M8KT3rF45tXk/BYQ28tNib5p8kcP7Dz5niCaUwAuEKmX4iYW+CYxDCxe63NyzZ6fesePItTzT99qv+A3vCKlpfO/piwXMFEcW7Fm80qKV1DhKjBdznY3NinTc3zLHIqkJMomIHUmHNXZVCPpO6XHDivN+o1vtX5Q1lUFjQJGORFAmeap28YFia6HYXKpaeB9skU5gZ5/4vNrEsYl6Iw9U7T9FezshKhY9Q1DnTA87Vp5wNzA6pLJNpVMDCoYa+5uaG3u+ImC9YhCZiDic3HFLsmjVg7ji0xwuzRfOubFLH5uCYINEFGPfpJpBtwE/Kx1JPX5ByGPXow8zXFWUDIz7U+5NWdTzMzCScqbIWWUPNxGUqtpXfvEy5A9ewv4uw9fQqhNcT+vjWgOMiySfsjUE9iiJBc9j5S6/v0dCMVplf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(136003)(366004)(39860400002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(6512007)(6486002)(26005)(36916002)(316002)(6506007)(38100700002)(6666004)(6916009)(4326008)(478600001)(66556008)(8936002)(8676002)(41300700001)(558084003)(66476007)(83380400001)(5660300002)(66946007)(15650500001)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LwKcuQzsUnJEXmBCF/d1o4NdLAAn6b8uO3UgULJXp3F8Y2y/fdza7MQN3Vzf?=
 =?us-ascii?Q?jIv5IJEj0a2zoeEJEWGHvuMNuqtzbIIabI6/rBro99hb4Mjit9tfii9l2746?=
 =?us-ascii?Q?09CVizqXAwswcpEvMs2iAAb+xlkEdg0D8rCLWBI1V7fNKKEnyt2IPCybMPGz?=
 =?us-ascii?Q?oLd4ViQuD1f7ogWO2vZ4hsXeGa9CI3K8O9BMfaIlovbM3vnLwR2kNGVKa74h?=
 =?us-ascii?Q?P6ttPF8WAxJaSsmmE/AX/088WTNq/Uc6t23OzJC7YfFm15BhsJEaH2Rczm2b?=
 =?us-ascii?Q?X2/SkqYXZWCcZy7KOjveFKrx3uaMt1G0qIRDUvSGM4yYA+Ok4l5V6035nG+e?=
 =?us-ascii?Q?K9W8COQIWXrBlHlMV/yUXoAMMaFPYNpVnJdIxATcW43yN+IcaWpeVtDTXw3s?=
 =?us-ascii?Q?p0Bip25FL29R2Kd+lfc8AKqJCrHhz26eavQbeDG+/2C60GMAXHapt8JpytHH?=
 =?us-ascii?Q?Y4CBbndNsx/sORHADJhtkEVmKxqmHHYYNekPSxpmZ4S4xPQchU1JPWsir/V+?=
 =?us-ascii?Q?oupI14mz7HUuvKIS84T4jLIUmU5BJKUVukFuZ8vQr/lSwtppLOZ7NnCgodOb?=
 =?us-ascii?Q?CiQh+Tp/sRoLbIou6mCAJAq7LZ1gBBsHKYGroaSgMCzfRE+dWwPdPKEcm0aI?=
 =?us-ascii?Q?78R8EDv9V2+HMbMwfbJfSslZDP+iSuFTbAnwqIzTtYckKiiBFAmVWM0txQ6r?=
 =?us-ascii?Q?EvE5PKm1Qfymnt0Tvhn1L/si9d3RF7MUQam21+Cegx9fiFXyYnU5snvGonWd?=
 =?us-ascii?Q?Hf73sNqp+BDJdQj+qZ5oqGJwfvD+TYmDDh2TkGEvSkjc4LDgtSAAHGxq0p2+?=
 =?us-ascii?Q?UYDwqLG/DRuvBB4avNc85rPCBM+GHGr1Py8aYpQfxH2I5W7MkqyegQ7UmVaL?=
 =?us-ascii?Q?7N6PC7nM2ABezWad8lIoofWIFetWRhPT1A1XKuAuuXcBqywE+7IYzcPUOqCR?=
 =?us-ascii?Q?uYZ3mRZ0RM8ywZDfcHNcU2CULiZk/M75O68944CXu1akcvZrntqcohPm+1L9?=
 =?us-ascii?Q?kR7JYpH/zDx6zcinVu16hNROuL7pgLr/gZFOGM2zeu8M2Tpm2mtjDq1mlMxL?=
 =?us-ascii?Q?9/hxZsRwLH6X44FRFc9M+z3joDAHryBLHrmUxS5RvSJychW9hQqPflJ3OGot?=
 =?us-ascii?Q?taUvfjch14FETgztVtm92Z1GBMG+iA+SaEkquzEqOAsi6tljS0MmAx05+ccF?=
 =?us-ascii?Q?JLqpOpgO318jw2UvKbUdqbzS5jbJNKrqmo1OmBos2x44hV3JcFOiwH4S48rb?=
 =?us-ascii?Q?CGPL8p5nfRxQFF4uwDsw2mnWOYwd2WOmk3yt9yEas7PEWVNL90e7Jec2ky62?=
 =?us-ascii?Q?VBoAoICeuYksk8w+FZbJg8YJCcE0HFVIX0LKKJObp9SrfCsR5u92DHH0CTDK?=
 =?us-ascii?Q?z5nqGCndHZfuAmxj4Lp0pU7265awVZqwObnCNQnAZsCP7g0Rer3nMDwdw/K5?=
 =?us-ascii?Q?b62ijQ6MOwOWGNeJu68AvN/pW/ejvKThuDB5BkV2zYFhY9w7uzf+RMX6k4t6?=
 =?us-ascii?Q?NgZcuCE3jFiRvRspKIYHg+6D6fjRutJ5tT4729fnQP3Sl5IynWDdFPxOYwq1?=
 =?us-ascii?Q?eI6hJjy1ZGji1P69KWIbyCjhvOw2yJWncVEQxdXU7P1TvQgLUS6t0igkOJku?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: z6IDSlolp6iUt6TE+ZvjlDi6AZX/1TX3kFqgOAKfDD2d1mXWJsX6xTM9TgOVxDoHqZD0o15hKwnF2TyMdHiGQPhUG8BWzi+JqZ6sDbz95Me4TcJGq39tzpNrq9N0/nV3ChBJb00ZIseMnQ2IWWpztiZXqbvUmwlMa0tfJFc60AM6EIhqNdqJo8C9mph7VAyCg2dtlAuvyRPGVqTX3LUuhdAAH1YWw7ha2eb3kFbegHQQwjYKbMY7vZtm6yGsnTdmZB4CbfdANiYXWvADhWsaGup3LyhymiDhi6zAzpfVcWZ4K/civ+AVcV+u5jjIDsPrU9Tb0zoVT2ZrU++fFKG1RqA34h0RMuAh+3vIC20hWQThIHNNAsqEIhcuUucdzXmw85/1AINJoqKhb3ajeOgI8WFed/4rd3eCj1l0Nxsojc/w+0U/sPGdxSUvWrQQZm7vX+bXKasvpCr8ectxVZFMhyOH/YkqQYkLGjkZBPpHNsebnpiVwgKLIBnqhPuQ7qvbsLnJtO8O/na9mW9e9s3aYUbe7MbmKjn+GsoHHnTjFuuF0f6pHN1FitNJk80y/kbiKeTO/dBuqjYXZVCDwDyVsGOM5FjdPcwcWTCbVXdR5GchQeKcJtGiZCHp8YmwkJ9BZWCoYiKceVjPUZGkZSKrEOgC28CZm1bZWeUdUr5sYFm+RTbKAzsbIdgz0UX4IjP8/XOOnCx5c/X3TEJzjduTNBhmbCiJlrxGjfdXML0/FUvGYvLNvWPNaPJqRP+7ZZnUkBSkTALBYxnn6dstcFBTuGEvwSSykFIAoa/+aY+Ve4nlnyExsEjv/lWs1J2F8vRyJwCZE+/p+gSNgYm7JZLTPQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3daf8e-13d2-4040-68b0-08dbcc2f8fc9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 21:01:25.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xaW98e9EfDBk14y8p1ogpFV7Y8MIeNgP6MlA9exne++MsrTTrfZV7oY9tWRH643wgKyZ30vi4OQJ24tdEhPUo5UtTMoNsOzT4LbQuiIbsy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_12,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=508 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310130182
X-Proofpoint-GUID: bz9_l485VXw3hlveDvmbRjo4awiL2kd9
X-Proofpoint-ORIG-GUID: bz9_l485VXw3hlveDvmbRjo4awiL2kd9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.15
>
> This patch set contains error handling fixes, ELS bug fixes, and logging
> improvements.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
