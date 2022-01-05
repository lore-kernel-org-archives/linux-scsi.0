Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4E2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 05:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiAEFXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 00:23:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4382 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbiAEFXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 00:23:24 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204NiAlD025093;
        Wed, 5 Jan 2022 05:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2ItPOPXfNeZV60gTxjgPYQNVPNLt6gQ7EKvDLQmP0Pc=;
 b=VEOInbAteUCSqt71JLms32F98uu0uiE/kfNpapHH6j5YCuzjqhliyLTIqtdoevj5dohY
 8tupt3d7ac9CMDzxxXSVNTDO69FN65C9hCSArGkxtAekSJV3jXJtGrnU+WYm9z3EOkrt
 2hTT4/9i76+AhS1PmzHlk4lQvWO9m4FKQrcZ0nq0UlC4Xj2fQaEyuCDc+rLik4TQcFcr
 qpQXz7DBxwyQ/vX1h5kfw/tnqjIJhZKu3j00I740kBf9QXKrEMJLjGbBAfALD02hh/7h
 843aBzeQRGyL4epQXPNUgSbLdBnXg90aFIU3XidAdvchjzakQPEaR/7F3AX7AGjausUl aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc43gbxc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:23:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2055BGMY120920;
        Wed, 5 Jan 2022 05:23:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3020.oracle.com with ESMTP id 3dagdpsa5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:23:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bp0Y0hoFGKj83DsbfGxJicgwulOi9j1AQZjUZMhT2VmRPq9ILprStUUoeLqeLYAe3wR0Bn/I4Z9r6q6fZGj4VZaIWaKXzlqbJTfReTPWhIsCjkt/61OXzr4sWSAJqQCidEsinZm7KsEl3mbZfA2GHZDPcwyWvnWsz/EJ3uWO8WdexcmSEX6dyEWBNYxaq88v/kuo64eEqoqKzza9Co2BIURCRYXbdozvkq5NLOLc1OSudQr5R2q3M4Q5Hx7dGL76Zbqdg5r3n6v0JVnn8gQ9z1dFH0AX+fJrkp/jkd/D2rZLajViFTT4h3JPi0R02JbmdYbsu+Awo5QwwwUvS7i3vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ItPOPXfNeZV60gTxjgPYQNVPNLt6gQ7EKvDLQmP0Pc=;
 b=UtRdM7NwEmDpm/JZlzNDY095j5oCN5n5b3V7ufe2MPRcoKvq13bVO2D0H0HlG9+NRl4MqHi21ryIT8i8HA48hXH3ty+PawvtW4+L3oISmL7M3rJDpRbXOCHYc+aM/PDoKvgB4jPuTO97hS6cV1Of62cE9YurI/55914QLCn3DcrJO7e5Bt+3rU8b182DyT+QKYARDZcewmwt3LfzT0oREusvGlHHnfFjhdFa9TPgi/XyHejz0IhrX0H4z20VX5WAKBXN/5O3PhYwSeYPPKgAW6yKqnqyPWV2sjtmyvC4RgfHGv9ozNvZFppsYp8j3fIztizfJLZxyJ3H9XWTTICDng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ItPOPXfNeZV60gTxjgPYQNVPNLt6gQ7EKvDLQmP0Pc=;
 b=ajiH1DVuQPhFE8v1MiZ8wtKYsURcOIJwldePGqssTk9p26XTPO82TOUQE8tcFL1d5ZbG+5NiuQStX1386CWEfYj0eN6q/62QqhL46CrfxqF9yTI114hJODWxOOolSRDad7U42Pj8wJTDlUbHLjcF+RGCXrLVpIcONkOYJZ2pFYQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 05:23:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%5]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 05:23:06 +0000
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        it+linux-scsi@molgen.mpg.de,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fusion MPT SAS Host: scsi 0:0:32:0: Wrong diagnostic page;
 asked for 10 got 0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8yyzrj9.fsf@ca-mkp.ca.oracle.com>
References: <68b68394-f244-c839-0207-456ebfd3acf2@molgen.mpg.de>
Date:   Wed, 05 Jan 2022 00:23:04 -0500
In-Reply-To: <68b68394-f244-c839-0207-456ebfd3acf2@molgen.mpg.de> (Paul
        Menzel's message of "Wed, 22 Dec 2021 16:00:25 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0013.namprd06.prod.outlook.com
 (2603:10b6:803:2f::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5cabe70-5322-45b4-e49d-08d9d00b742f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB461676247C01AE6BF99607528E4B9@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9ME8QVoWVkI7zHKQikyOSiAxbzQ0OaJrZo7s8I9ICAbPL1DaMm8Um081CZPE7u7vs4MtvMdkYtR5qSoh3jMNJgSJB4QcwJV41SQ5LW2Vh/FZrwhlSbQoImNT32Pblf5AvrkSj4hlMVQMFvYVMhTvd35QIa1MoRlrRVcFGtwgjo96Sz+DBZgBLrvnKMdZSaHezWpLX/AjcQFW9p9MGq7kt2UJpnqXDywyFcR4A2WTtRxYlGIKaTBjvZx/sOmlmqgGwcJJOZZ3R5iC37uZ5bG3ioRTV9CkyzduZWIgnhArtNJFRNUcZVzmaPoTUGvVF1mnJvJQyiHS8cS2PgkIC+IlRYCZIs5rWFWv81QSLJKt05gs4fqGWGRqZT6QrZ6eaPhoPIHP0vIpaN9MKcY2bVbQy2AULQB6pYnzhpvjOwQiyrpt7VBWZYXCbkrqAVqUhOtfgQcn3tJ4CuIM4AGVhRumTX+JAWBmd0hWElniNG2yH9OL9a8Nwku2qq2Jd6nvnfdYkKWbBPfrulGh5mTPWWKtTGG01gkOVabF0YklOPj8n/+nBptMik1bWuDr8wdJhYZmVulVk6Pn/xuQaB74nvpVJpNeLB1vN8GYYJJw4NIxpwXJGieDHXtoTsG0/tpMFt5h5sZofXHNrNEbID6DYsIWqHw4TETR84wIYUxnTT5uH/39HKW+xa+z+a7Qg5se/UaBxrvfF01GXy0Mzy1LfTTVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(5660300002)(8936002)(4326008)(54906003)(52116002)(36916002)(6486002)(4744005)(6506007)(6512007)(2906002)(508600001)(6916009)(38100700002)(316002)(38350700002)(26005)(186003)(86362001)(83380400001)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VNoxC2Pseu00rVrY1fjFwQUJ4Qb1esbjCcNwHN2DVJGD1Zq3pfu/72QtLs7J?=
 =?us-ascii?Q?jDOWPhvT++e0z5N8yEXyepQWCqp/Qjjx31uHeaITtpwl+4CXfgBgXvSBkHyr?=
 =?us-ascii?Q?OW0SLxbF2y76mbyoYsFRtkumEVuMAf7JOv+riT8ZK0+XNd9PbluXPy4JZDO+?=
 =?us-ascii?Q?DYSUbRmJjn89Ujcq4QXTtjskdl7Qf8YHoHECWUKRnIYGgVhJ8v6iPuLQftdR?=
 =?us-ascii?Q?RhfPfbFAFdNjstXCpJgYHDdZzzM1T9uhDSe2skycXJqfbuXmvo1ndRwSQtNZ?=
 =?us-ascii?Q?YQ6+ujgcH2QbAMYZ6eDEU2TMGo51qUisCHlwT6IdebrKBdGZfN4RAHBCAavq?=
 =?us-ascii?Q?9qVZycMltj1NQ+3IZ6YUJV3p2OoO+uF9O+SiVO6Ovur3XIedkwE0xBa0jpKD?=
 =?us-ascii?Q?2OjCeRKmD6RJ0sWDXlSyiu2y2Zxp6XnS4DE5QVFVG4i+nQUwz0KyZR/iIDoO?=
 =?us-ascii?Q?5MPp3hdxsQSMaqqJ+YiiRpF4CLm1mNKj3AMXPSIsy8H6FvIJw8Px1TOAjF9N?=
 =?us-ascii?Q?rPNrKSydomAQ6gRL4k8yqRCpvB7/haGaCyx66kUEUqfp+SmUzn/8Z1MfPG+j?=
 =?us-ascii?Q?EwukEe3azzwKoV60Mdf/9iyVdIZTW3ehQYBrjKOsiwwFe/bCOeLNgvdV/PFB?=
 =?us-ascii?Q?waFBeWzRR0ZeX2t0cUm7Unz/nhEPRVCPe2+DkLJYINkfLkrd/PVlgH03YsI2?=
 =?us-ascii?Q?+FkfvApxxIl+IZ7kZ6mx+3ZuntTFAYLfduj1CsxmZVoIlcc+JXhSa1IeevBy?=
 =?us-ascii?Q?9GJdhxpb11ksAZnbAbwlhR1Uo+ADkb5L5yvykWkM+IufIbykmHp7IH2jTLXw?=
 =?us-ascii?Q?0ctysC7O8SUpU6AxxmpXh9APo9zeF3iEFZxYwFNjjW2zmLaHwSrZq+5xGeYH?=
 =?us-ascii?Q?bmVweaVZlbkmdkWNfN7tjchs74mWt/8A3SUMlgGSfLlO+yrKqLrlZvE2aFCI?=
 =?us-ascii?Q?mNp/dFWjCSPyLtx/wlCsLDz/VT0JgUHGDVj/yx4bKqXzNfPtu55PwsjaJ8S7?=
 =?us-ascii?Q?gTRyXDfLgCuKIysMl2mLytSPI6GMDGQLXdSRkS38ByAkAlScCO6BMZFwfO7/?=
 =?us-ascii?Q?/lyHfky/B8ckSkdSrNpMn57+wnB+fykDpObayagC8j+30/vK9a9pJlL5GczS?=
 =?us-ascii?Q?XZfk5mfTxs44mHVU9SIHhwJSovfx4G8f/llTm56odXHx5cBLien7MbIuJ4EM?=
 =?us-ascii?Q?nQ4DQaX1pKNE0aEiNTS/4eQp2QkboLj6HecXZ9gjE/ooIEydUV7zPXQwiv4x?=
 =?us-ascii?Q?D6N1v2dTRVmvpQYzI0c3ouw7FTxB/8lNtEBzCloi1kwWp8rmbFNWRPaWWpxo?=
 =?us-ascii?Q?u29zg1WnsFja0LO53OFjQMPACZuQHFF1zJWHv7OlQyPZlzZ7BYPkTVQhxbWv?=
 =?us-ascii?Q?zYzRHv4+cGFm8xUN/mir2PFzGUI+KjKvZo20rwO6LrMDRCTrlMyrCC8isvuD?=
 =?us-ascii?Q?tgswdH+qDLwv/Li+HpRk0CXBZjxwzIAp8UUwM0xM7vyI6b256jOhDAny1aM9?=
 =?us-ascii?Q?TCtLzUQIeoQBFSEilUTGAjp2oBoxoxNJtxTZaIv2u61vHLqoVgphsZM55a9n?=
 =?us-ascii?Q?nOEB8UMb+/fT+YcxJBdGGc1IEPHqIFqi/zjiIl+EZI4PnC3sr7picQk+vt2V?=
 =?us-ascii?Q?BSkRpqBQOb8IIi+IPdV7fP7rsNCX+k0qce7xUwEfVZ2fXiRWRQMDWG/0/Gqx?=
 =?us-ascii?Q?KqRA/A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cabe70-5322-45b4-e49d-08d9d00b742f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 05:23:06.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLi0F+lNqnkcY7vTTrBKQ4tHG7vOv49fkTSK5LW6EsXD7qJ6Dg4LeV3oUjwTqSCh445zlplSAHE7XkkMGKtHhv+SSfXpMmqTkVRI6Sx1vys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050035
X-Proofpoint-GUID: d1yn7Kd7DMSh1LUlLyYlZTIzkot4qIJW
X-Proofpoint-ORIG-GUID: d1yn7Kd7DMSh1LUlLyYlZTIzkot4qIJW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Paul,

> [   12.629672] scsi 0:0:32:0: Wrong diagnostic page; asked for 10 got 0

> Can this error be addressed somehow?

This means we asked for a diagnostics page for the disk enclosure but
got a different page than we asked for.

Not sure if the disk backplane or SES firmware can be updated?

-- 
Martin K. Petersen	Oracle Linux Engineering
