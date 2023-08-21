Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144F4EE49A5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjHUUYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjHUUYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:24:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C48E3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:24:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxinj013579;
        Mon, 21 Aug 2023 20:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=6ypacR0AOxZE4gNO9m+uj9p/QiW9zfcxygEKGM+fBzw=;
 b=ifWhWmdiCmWQ7XVGDeNwaSRrIK3dVeJ98rb7d6l6ea4xxqkGrth1OsOMap4Rrhq7SKTh
 puX4bd5pn2qBi/pILKI7KQopCTEmwCpHduaY+cUqRlopcgRUAj9V14q2iMu259b5Xuw8
 t/AMKfZtsc82AZvuM0a7FUk09FuzrJqKC+APKWLnwM7864w/LeL/oW2fcgXd9jpDTvm3
 hwOMd1mb/4boPVplv0kmkjMJoeRm2VQRZGiQFzPz58jCapeRD/3WmOUo72IKpFLOshRg
 QmlAwkauDQi7ZGZBwhS/l52u3U9dzqTXtWfwyyRvogH8xN4GQtiQtyl40kHW4gUSaXs2 Sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmb1uu9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:23:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LK70uP007684;
        Mon, 21 Aug 2023 20:23:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm63xxh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:23:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGkBin/cgWTau+bcUolQHJ3LQVxRDMnZHHrH1JpJbw00C7IqUGwWAe6VA1ro9csc5iIeY18iCRokFrd9J28UjtjkJCX1oK/a0iaip9ONcoODRra1ySWitGFzDZ2vb03Orf43eUP9+VvuzzQx7U2j3s2+IW0NqK4gT69tPh8eI1ywoS12Lza7s1kuk2nrsQq2tOKmCyEwQfMM4soea9IbCLnr8onZDBh8CZIgf4puRGloBu6L4WWlNqS/TzC35AgLcNDCLWUjRMM95FH6k9XGi7nrFTj5nUgVumAHOY79k0x8kzAArvmvwDqOC3Lx0Kq0sfwxc853/7cN4pXYDmECRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ypacR0AOxZE4gNO9m+uj9p/QiW9zfcxygEKGM+fBzw=;
 b=WzVejhRiJL80jdmm5Gb8VeFYHfq2hhv5/9Z1AG50m3ZAzrfZ/amppNDKoHQnrMUL+XPcg9tfPtyuztXXwy4jFrQB8SoLoDOoKcDom7cGovmAPTsLhFFjd8jNUTyXRcKY0ot/LI06cWFvR9altQPYHc0nM3O1e8BsKGa5W5YA7kZ5kqVDjZjp/bR0d6eD5j/W6LALX2AT7vIzaW+0VJPDfSJn77BAjPw47yyqz+DC0w8UutZX37/Eey21WV/ju0dsSIuvPWs74kLs5pIliXqaWdLdWk46bBWJshhavgWnaOeggZLp5gaYkbNppfED54zpsDYq470HVFoZ2CNWN76cLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ypacR0AOxZE4gNO9m+uj9p/QiW9zfcxygEKGM+fBzw=;
 b=jGanCt5xtJYdHfdY4JzstMXTeiGfA4ulSboNsa9mnlA8IhHZFG7HGwRLcuJHLjADcE0wRcs5XCENuZ89iRGRpZBa1pKR+qHh4XG4AhbVgJlmMLUeVSSdo9Z0Xtl8M3Cky+N12OKt78Nk1iDnz4eTg2MvNwN+gosEcL0bhm6/Do4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB6769.namprd10.prod.outlook.com (2603:10b6:208:43e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Mon, 21 Aug
 2023 20:23:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:23:53 +0000
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: Remove unused extern declarations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1il989mb2.fsf@ca-mkp.ca.oracle.com>
References: <20230809142107.42756-1-yuehaibing@huawei.com>
Date:   Mon, 21 Aug 2023 16:23:50 -0400
In-Reply-To: <20230809142107.42756-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Wed, 9 Aug 2023 22:21:07 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: e85785da-aae0-4a58-9e9f-08dba2848975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x88++GX0mgwmjWcCxBYAws2OmywtvyYDqFc1udsA92sztV6HH/RVWpXgKdj7kRphOVhFBbAXwc1f+KcC9h22x+mMnhhpnVpt2nhtuVu91nnz4Ic1ZsCgosN0+7NIk48o5S9g7OZMl1CTa9O3UD0/zDzcNGjEa/Sbc1asCWA2JXR/3i6fRP9AJY5LI2ngmAblLvKk0a0WoJwLhOMLRycJc4ZSAghkGWGcoGpQWjWrFQjof2uUsrAoSVABsZS3G8iXUTTH3OMzVUaedzu/oP8XMvyH4BWpBbvMy5eiEBC/jI8/Ke7vtdHSc4NIwt2e5z3ZY4E9+ygY4sCfAGWI66DpF9jSnuo8y+G0WC4MM1VgcXc454kKu01EDKW4pwcoe2PCzctAIXVFPMHy5l4EOg2kIWDOXmHWhtydKiQEVpnHiuU/AJNf0feybAYST/zACq/YPtczfjjZayJdvXY4JtT2NjtuFtGPxNaXsDqaUbEr0HcbRRdx2M2ikG7JgqR6L2Cg6zVki9N0mkd6je+NyTdMxnnHKQPbKbb8BjRqQnUqJVfCWS6vpngwyNfDlTvXJGT6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(66946007)(6512007)(8676002)(8936002)(4326008)(41300700001)(478600001)(38100700002)(36916002)(6506007)(6486002)(558084003)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?00z691WLdvbEZrFgwji1vYDZdmW0+kDYzmrFUU9tKb+RgK108XdJmBaxMHNJ?=
 =?us-ascii?Q?RfHulhAifKj8C6LdJv9y8TPCC7KDBDFLzyTygHMMS2CASYYWhcCphlRsBBcB?=
 =?us-ascii?Q?UUPgC+EbjgZneXrA0yZVfsjxMeTsYu9EjemSMTrlym3cRQCqIaWFuxjurpyR?=
 =?us-ascii?Q?2jcSgaA7bUuNSHbwJoukTVU4qCP/UgowgE+vcFJEkcwCJifsx6GiwZnd5XDW?=
 =?us-ascii?Q?hFiuXu5Ft+AfshMuBcONx4RTC87VzeIxAmh+Z11R3bMxzx7UDKtUa5YhAQXJ?=
 =?us-ascii?Q?jTLsDzsi9ezCKFaGuu8ncDVvSeHxEuU2bsaCe29G4PJlDpUIdqbeoQcLMYJa?=
 =?us-ascii?Q?7aktyyf2XdT0HA74fXtypAnSGeCVhVEjSLFLNhfGgYZeC4rZtRljQcB4Tua3?=
 =?us-ascii?Q?NqgJaLkMtF6S/UT/eFmUAl9K6lMTRnw0rKUnKMU4QcWp3l0YEqqv4uWaAiMN?=
 =?us-ascii?Q?Nby7MXkrKNZHwDQRK8I4XFCpWKfw+4k+wJ2rIo78eivYORSzIdwC9OEhtxQ8?=
 =?us-ascii?Q?9tdTqqSiupbF3yb3evNHFnasTzUIxLNi/fdixtX6goSwDWBGUrI/kxM7yfi0?=
 =?us-ascii?Q?ElzSidumS2p8jngwWBQuOpxuMmDQFAYvF5/XjqXv1gafJYPI0HJmCJhJYJ6y?=
 =?us-ascii?Q?yinwoTYQqe5Xh7IAbdb4mJIewu0W5ks1NSZL4ZrDTS8VrGYOa4hy2mW9i+k2?=
 =?us-ascii?Q?yj0EfLAbT4tBvlbQcX+qBRO9cjOckBfAvuSnw+N568+mp9g1WE2oVL7U1zoo?=
 =?us-ascii?Q?2I2c1DLiqFd1oaJFF51wn/3E2rK1Jay1kyssdTSJmpVX4ESne6TRd8St6cw0?=
 =?us-ascii?Q?WUj8haEyOm7Vio/R8zI3HgcH/OA4UISOfdktlIDtzIw3S4eUFT4yL1SvYW+4?=
 =?us-ascii?Q?iMb70W23xD84rCYsER0iv60Ej0imi2xo5+YIEqVnp4vc+pVgXs85Q+exSUFV?=
 =?us-ascii?Q?XMW6nuMHBrDxGwbLr1Z5rsHX1biYIGUTjNQ8+b2ctLsGv8ry/vHDvPAa4f/o?=
 =?us-ascii?Q?DuGV+bHJnlaBKUH7edY2SIwfwwxMhmXuXYkMVx/JSF/sbe+ackiebwcbmXfU?=
 =?us-ascii?Q?4ShshDLSxCjSKANRjIjXxDgZKCRKU3sEjc4PrWq0yZSnou+yMx67OImJ4AqQ?=
 =?us-ascii?Q?qvMmd1bVw7jmXYXrkWt+BotVGPigdMnLZdQR3BKAx2kIFNS7WIGtPb87WtDx?=
 =?us-ascii?Q?WuOfq0nPWIFE3LVQq5wVEvWMW5dayOqp+omhp8bMln3sWXb2qQ10wfpxVviT?=
 =?us-ascii?Q?uejdq3X8yDWU4ryGy1QuCNKeTAzqVgh8qTAPWTsIU1nVXow7udS6CgXjfZH+?=
 =?us-ascii?Q?6bACAOgn3z8QHc9f5Lm8cL/Liali2YV8fw7iX2lRA2reu4rq77yn5h87+tFa?=
 =?us-ascii?Q?MSGT5zuAgo1rAyBM8dRwIqUE8ZmUwlb/qri9SZIYyyp57hAJdOSwjlsZ/vAa?=
 =?us-ascii?Q?J9vwJoqA1N9H8vCGnwEis44wnHmeQMX6re4AN7nGPHi8g9nic0zzUTFUbktf?=
 =?us-ascii?Q?blrxvwU/PBmYdxA4Xtmer3pvY2A/CrR0ytlLcdH/OEvhE5lGikKLYBzy4wjY?=
 =?us-ascii?Q?cLkAmmsi465g8Avw5CJ1iNrHy96JdAzOztDmUTMkgALzsq/095TFvXS5yNGm?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lHhOiXC0rN1SEYYrL/bstB/jq3ArLefntLtnk89l+7BstRgF5jO1B67Zj/+A2LgwwsxmciK7XQVJnmrX0uXv+LQnIyXsGykHr7PUmgKLLC5OZBTo+7yoaRnDA7J4ieeuuIwt10NbB0vvZHtSbWCryoU970org6z4/G+OdQ5D38A761GjPIQ7WhZJjFRdwLxYIZZhhcqGMhghU7SyZzQZ5jiJI3ZVRvnTyI22Wtvi0GMj1JWxV6hUh+lYPxUzrYL80CCwxZFc+ZmG+foipox54cykQzdeNLXLyU1SqMsnafUNCFNguHP/RtZjEuSjrreV4k/pEn5utZcXT1+kM9Fi8BJTp1h0hk5XiJe8QCbExNixvcp8sE+kLhCgDTQ2B2vTdooqYr4Wezf6NL5AXKWqFckIh0oBMtR2/0XR0KVwe8mE4qtglD8ModLqP+fFGBdQou3pjJiDAhtoWeFREGRJsADZpCtFKQFDXrADCZ5tpJrJ3GDygxSCJoS1zG1x0UwBCD7pcdJClTOZ6cOjvvpbY0KMmV0VdyXKXNdsfQoOOTvLraU8DFe5JG2S3l7z8PkpEfraaK0W8CmEqyGFuSbV0ztEVoLX+aH3LbWo0h6xjyHU6D4x9DRgR2rmmPLZ8sZMmeuWskqSkbV9sc9kml2Zy9iDdqqhuUImvsoVCtA0RUrey8d68phTFhubxauLOwJOGkOG1mitcH95+PLZlo/u9g3vhemzk9MoBfHLQfE/HyY3mxUIZHEocEpQgjCMMm1uXeVACCGqtrJVNaSrSfWJK4NpxC5Wxwlw0HaiAr8r6WtHb6pawhH0qEl+ETvlwzfuu7pPGNfZ3ahPM2xzb7ZiiucouXeWBGVK2KA5eAxLDxo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85785da-aae0-4a58-9e9f-08dba2848975
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:23:52.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9ahlgKsrMqblD1RpDfFlAyn5GUcs7KLAubBEcaUodnkCnnpCLtEp1uWVZsiispHVpfZAhkG+K+A/QuoYqDYeeKjeTxd6Ks+xjXPNQvl3Mo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=744 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210189
X-Proofpoint-ORIG-GUID: r4J23L4b4KUY_YhkFNS9lk4dlpJk4FvY
X-Proofpoint-GUID: r4J23L4b4KUY_YhkFNS9lk4dlpJk4FvY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue,

> These declarations is never implemented since the beginning of git
> history.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
