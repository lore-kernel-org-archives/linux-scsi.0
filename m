Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674AAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3077E64F96
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCQDWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 23:22:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCQDWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 23:22:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H3AR3J033507;
        Wed, 17 Mar 2021 03:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/sZ0S/5GZ29pOC8frD8tOQfAVvTB7qdDlZCLLkHK8/w=;
 b=sEAxDAHysiQjbKHI+bn13zM4Oh9V8fw0JjAwAHxXHOfTlHu7GZYZbocMhzqRuf841PKs
 qh9MwQIEB2Tjjgg2doHi1LGqSjVF8UC/nica2Rz58TzGx6HKjDnw6hk+vGiUL7L1sg0D
 3u640HcP27vDOiOMJ0AHyoqNqm9GyFmdx5Nl56fZf0ktp3uvaZQZFSHB9lAB03HEZavu
 0633vpInqgCF9bP3+jo/CXfsgdm5vxp5H4qC7xDu69e/rnXrxZxj5HTsm7vidOFyehm9
 8Oo8xoSna7of4ObkkgtU1A2pnds7xlii58PV1+U3NrlkzXxXEftcvEzDlclBIC948xNt 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37a4ekqktm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:21:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H35li6010864;
        Wed, 17 Mar 2021 03:21:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3020.oracle.com with ESMTP id 3797a21u2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:21:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5LJwQiWsnvf0rinpgYqNBfAL0zOjqNL0CB4syt3JXNxKPQcXHVsDt2IQwzTFNVHDCOzIh8tMIaWjuVjw58dRVQYJK3wV4M32F7p1SYcdmRJICvCfalGphk8ZY9YwxtPvm8xMQQkvaqqiNK24D9mI3stHzu3g05GoLmp6bu4gQKdph0RsyKzsYQJ+WK30ov/CB11qoSMvKAPgtCXE1DLDAIJt4I3r3WEkR7l31sIoJzSSO5j4AdnseN9oFiY/r8B1L7zZ7fhsCjY62+QpOWtShYPGSksK8TDJakJ37k6IiR+A+W2wBOjnYk8tACPuFSe5sEMyfdEsfHobejep7FmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sZ0S/5GZ29pOC8frD8tOQfAVvTB7qdDlZCLLkHK8/w=;
 b=HkvixxD5kgOYSWVs/GuAFHOo1vF6NyQdQ0l9zz7748eDt1XVKKy2yZnEXP/SRtIedm8cI4omCjYhzAC/KNCMAZbqbqFP7+6jCS13awhmnG8ukEa6c5l5ekN3cvPSjBxzvbZNtavnonIyZsnWBJ68n21qFrITznErB72BknqFdAKIaqL3slJEYmu/IE39C5nwk80akrwgeY6D2D/W4/bbr1jig4u5GGdh4SIffnYSzvpoRWFwKrCFH3bQ6GGtJp1g3mIj2i9sXSdiczUhwoMQdtn7HHGRRmbs5rzOcs+/ClZBfI4Bj0N3zbhrZTbKuR+KF7PG7F+RAC/QevFdGKHtsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sZ0S/5GZ29pOC8frD8tOQfAVvTB7qdDlZCLLkHK8/w=;
 b=I/DZoYNeAc9nd2//ltU2ybEgpih8OVepDQ4/sXRnDDJ+hgQ9vd8UursezsmWR43+6DoyZWueLQG6voXZ/btyEM6qZWflP2qd+Kgc9QeQXZYCT0oYtRFtG3/nSTyEfYPj1K2c/S6hwAZ5ccFr7xZwge9m1A/2MGMKHENVvywCe2Q=
Authentication-Results: connolly.tech; dkim=none (message not signed)
 header.d=none;connolly.tech; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 03:21:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 03:21:56 +0000
To:     Caleb Connolly <caleb@connolly.tech>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, ejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, beanhuo@micron.com, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3: scsi: ufshcd: use a macro for UFS versions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0q61n3q.fsf@ca-mkp.ca.oracle.com>
References: <20210310153215.371227-1-caleb@connolly.tech>
Date:   Tue, 16 Mar 2021 23:21:51 -0400
In-Reply-To: <20210310153215.371227-1-caleb@connolly.tech> (Caleb Connolly's
        message of "Wed, 10 Mar 2021 15:33:30 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 03:21:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f65e9ca-e56b-4564-c2ab-08d8e8f3d13c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45025E6575DA851DF1515A518E6A9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmw0biwZuK+3W+pUoeILXKyOf0tUdbVBIU5IkYSXKUskcmyxH+/bq776TAMEOXU24JGwYzpEgTojRl9xyzGuQMzY7G4cY6q7FdciQIpXN1GrNTbbvF2lIz46vRwqu9MOIH2CBMhhLg+EJSpQEggmTmUQcaQTdBfJjW6icCS51fSwL85XFC+uJeLO3O1P1GKCOll2lFEe2BwVZ14VFB0bJ71n0w3ihXct89GcMaD7OmX0r6O6v9F3acKqX5rKYxs4ZFPUM0nrwYaQLPN+bpQM0Eirhqzrem0xJxny844jDbQTeobFIEzBgdTq0w4Bt4p2jHeXpN4LwyuBxzPBBlddOV7r/ZZ9Z0WTndiPRZVVox+16027R0nFNAygUi3JyaZU3agaD6GCTvZ1yNDdgtVG+ae4rhnu+m4mpkbdC299pTsnntm6puQl4LRs2bv76m1n2wZA1xyz7TCKeby7Z3JFjiOA8UNehfqgS9j9MTKkXrZqi4kQC91FUnn0v+2RcwvnBi+ekXlunxdxG0JiVf+/4Cf+3kPreXcAnI2nxI1S4Dz02nz+ioKN4/41HXHvakox
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(136003)(366004)(7416002)(2906002)(956004)(6916009)(8936002)(16526019)(66476007)(66946007)(478600001)(66556008)(4326008)(26005)(8676002)(86362001)(558084003)(5660300002)(52116002)(316002)(6666004)(36916002)(7696005)(186003)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6ulv0ILHP41mL7wzGyROSlVksvnuvQngsRT6cHn1mvy8VBbKe6uH+7iSWGsN?=
 =?us-ascii?Q?BpC7+o7xYmmEMo103Aqb5oxYryYVOd4hP9KECesN9rlKOWb+XUCrfsifOGKs?=
 =?us-ascii?Q?hS634d7rLJNxA6gvVnXp1LSM4rwYE8eNQixok+yXe52AcFu0hcSn+T1HMvPv?=
 =?us-ascii?Q?fdPpyP0++2IEXS9yeRvQ9s4F89zs6xL9tloNeYO6aDq+a0+5P8CguQ0OSAa8?=
 =?us-ascii?Q?zF4PBEw1f4oTit6a8VgT6vMvEMIuBoQKq/ck+jtt1u7qAmBZstFHrRzYme22?=
 =?us-ascii?Q?K4aQd5K46HFsxYzjuYZAaJu9N9yIKZbSjg0RIG2D0UXtFZ7K4BVvRKl/BfNL?=
 =?us-ascii?Q?nmpr2cBNh2usvCAf5uy0ElbqyPYxaPBJ9s2gAbXKtNS1koIbWOr4Ii76jMNo?=
 =?us-ascii?Q?YaUWjxvEQGbtt4tifUK8kmgKkXvgONLpISyToBWjxMkYWMRUYnMqzQ0UjQWR?=
 =?us-ascii?Q?UQYwzyGgZZBAcZHzjYWuRwRtjS4OrmSTvja1wYtKGoQ1/eNRSbY35eJXyUKx?=
 =?us-ascii?Q?9szpiXHZ8gExgzQ3Vv5VbGC9IchlzEZNaJ4C9TTxAumxUbYmC7pUgcNg8M8y?=
 =?us-ascii?Q?9zLInYiJX1Lx29MC3R1dx0ZjkUmsGMj3YqBHSsKNNB2zQP6nEUAUexeTLojZ?=
 =?us-ascii?Q?dyas0Kqgii/vl0rJd38pFKs795eSvO5E3x2FUhwNcimRBrPK9N1UUWeVDT8+?=
 =?us-ascii?Q?canrTBDOrVh5MbOYALEs+6AX4DPc1YUAh+BahXg2KnCg8Nz4pqC0t4vmAWrL?=
 =?us-ascii?Q?Og2UmuXMUbII/TRwqTnJgclQFRFHy6pJ6251gJ3moSIhyLfFSDRzZqKPyo4O?=
 =?us-ascii?Q?jld8xDhyUyvXUVtAXcgyo1D4Wql2TC+nbiyWbyoh5DUtrGQY/R0SfteeK+kp?=
 =?us-ascii?Q?qb7i2HrumCJtKZXstKapqd0w4G26bX1MFflYpkfhfXYbUb65Jw0f6BE9URC4?=
 =?us-ascii?Q?bfNcoi5dsExrYkD9zmwShNIH4WbnzDsLCk4OA7wPNoRpnXWlPtP3ZkOf74tX?=
 =?us-ascii?Q?UTli9ORcxU5E9zXr/A/rUmNkRH68eCEpHW56vHhxQSdaB9/Komp6OyRHYZ2O?=
 =?us-ascii?Q?VqNh6R6I3a0ZkUA5mXBTxt7btlUM3M109c/goNRUHVtBHEcI36yzjZJNj+xQ?=
 =?us-ascii?Q?ZjDGHmv0i9XlIqjAuIxsp0BjGchKO7y0yx/xoO2OK+1JadpBVjG5bdIA6D5g?=
 =?us-ascii?Q?RwbzdDhjsoSUdkwa2KU/UJ4JPJ6e2c05jcinXfsS4JuRpbQa39aMdxlY8Upo?=
 =?us-ascii?Q?ev6oLH1yjz9eyQWoZv++VusD+/R9tb3KqZr49MB46p0YruQptBzPfrygO7+5?=
 =?us-ascii?Q?fcodUmz8+dtKuymsOpJiUCUk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f65e9ca-e56b-4564-c2ab-08d8e8f3d13c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 03:21:55.9087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRfjxCE76yc/e627cATHMR5JdbB5CbynbChRVQ8qn7IIQ4uufzvxJEE9Q1Bs7VvLRIIsGXk+XpXRWvX+pWanz5ifxYVYvg2J01YOyg6vsS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170024
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Caleb,

> When using a device with UFS > 2.1 the error "invalid UFS version" is
> misleadingly printed. There was a patch for this almost a year
> ago to which this solution was suggested.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
