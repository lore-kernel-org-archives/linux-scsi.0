Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CF5C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 01:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCGBnv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 20:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCGBnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 20:43:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6E21FC1
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 17:43:35 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwwsV006105;
        Tue, 7 Mar 2023 01:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BoZMrjD3GVxjwPZ9QAE0PZsbv8EzQwBnMC7jDW4bEt0=;
 b=qbzKXVuUK+DqGgLwF7PzifkL84WeGwovBUkh+loalgubBWOoW+sdd4D836gJ87OHO/sq
 hvr314Rxt+8dpxd+izsNXRR1wiOAkE23rHZypNFXGw33XM3P+rW2Uq9C+/e8GXP2r/SX
 eNz1J3cJpifmG6YcnKYfBvylFU0GB1tNXvJGJHLV1T5ZvuHRKUCIpao3LuCTHneWAYw1
 Cjf8IuQGUUBbc5Fc5e5hyTX2VnloXsAQ4mSdxXFUtLS+xPpP6qM2TWEN49Mqls/f0Qvm
 3b3JiLRDSMpYjHtInF5NKASDFVkcPb2APwJi6jm8Dr74ecI4VssIZg8Po5rif1r4lyLj GQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4161vd9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 01:43:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326NHm37009559;
        Tue, 7 Mar 2023 01:43:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u2h3e3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 01:43:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODh7OaD2oxKhrZlEo+YdrRTYDV1VRFrlxMVooelre3zhqfLmkMT/MR+mX6g3LM61A0dpr4FUQ0kPBUg2D0L29XTA3uP8I2Hk15EfIoUBYUsyLyKeP50rxCec7hHqVL4lFqzh/MOsMBRKU0eQmapQDkCUmqNODZxCMzlomSaMdrfxO4bcSDogzCbqWldJX9Y2GVsmEccOE9TvjXxksFiplUNCvrZB1kqwPxcNSFFaijbw+yA5QRp2tncx5dZioYNCJXJJIl0T8gv+QGFV0Cr5uED7iONBT7anOpU33rskqU6SCLN4T69ZbhZtUO9mvdYbpjb8CZWrzRmWdIM1MxNydA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoZMrjD3GVxjwPZ9QAE0PZsbv8EzQwBnMC7jDW4bEt0=;
 b=Uz+tlr9hFkXlZVx59WQRzWfowH97YmhQFXd80EVMnYQXccaJtbOFXA0Xyn/+2WMQaNNFkjQk7Hs3Zrih5TBeyLvXUYGDSOMtpX3clpgP86w/4h/jPxATDvSiYza3EAKqcKJgLSG3ovrEn472i4FmiGb/KfiPBsowciWPr4J9VlOLiMGPV2l+p8+OdvQbhXJ1cEIBWIrSmAQSMFjMhYQKomScuuinZJUd0hQABQh2m7H470E4+JH6E9r1w/sFxhRivWlzAIafXOU12gTpoIK88LV8+L3qunwm3wDm3DvxTNU+yXNp37IBajCXzu84u6Jd3FrkYIAUeRYPeSjBiEqC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoZMrjD3GVxjwPZ9QAE0PZsbv8EzQwBnMC7jDW4bEt0=;
 b=tfeZ5Vdk4JYcXF99+u+6dsoLUlR6iLZFVY++ps+SEBPmFjpn2zJUed10+YSulqSnht9wAUW8ACVYQORfD+NZUgqO0kSZO9eBTjYeDbdApwRSyBFgmeXQz0hEqM2BArlVW0KqkEiRuqOySj6S48nXrXnjI3RzXTtXj6Lw5rQaLKI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5265.namprd10.prod.outlook.com (2603:10b6:208:325::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 01:43:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 01:43:29 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH v2 0/6] scsi: mpi3mr: fix few resource leaks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6uxmj5s.fsf@ca-mkp.ca.oracle.com>
References: <20230302234336.25456-1-thenzl@redhat.com>
Date:   Mon, 06 Mar 2023 20:43:23 -0500
In-Reply-To: <20230302234336.25456-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Fri, 3 Mar 2023 00:43:30 +0100")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0514.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5265:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3d0764-0b3d-4036-ab47-08db1ead5a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRky1jrTqTziMfil9zDroZxF9IjWRnPwHEKVklkelrg5icI4F+b/RjTClmpwgXWkDFUGJMpPqa0xr7y+SCH0BIZgWNoXE90I3ui+NwBObgUMe2MjYN/mkqGD8wpcVtu5cUb1l72SjHcT/BCsvdn9wvWL4boU5bqXGhOJXXjgirDdPBV2Gsi9LKBl8qjcUGLKQREfaGYnnTXf8oqwpajmtMXYq+sCiJtpA9wyaokbWJIszh0ZdttgB+kgLgqHBNH5jj0PBFT8hF2FH6aBqZSPWs2S6rVsd+uVTx2dyNT1Ft/03qtndq/wblr/qfmGlSGEeZQEhGdJu+yzRGPuAjXQ0mi3IMrGF0zjne0VnUmrvZTZh8VnD6any7Uyd+LweqLfeQlRaYv+279pnEOCzbcBPNC9DKnrdQPXXfp6T52p5uiPzWkvvehFSzf3lEDTJL0m67kYa274d0UE4MXa7pWY1mY/1y8Mt5dRdGLKn+DOwRH2zap1OMwBexS9GFNZt08LEjCohuIrFlIBcV3g2ucth3yweLlsnYMgf8bJOmbaE8A2wPGnExlspi2cJrQeXIKkT+/4f/iOqxeUouwBV6TK447MtcHN4QsIoHFXqQrLklEGggiCZxX3oGBxmXJBxFQMA0Ipjza0/Ph9GXEe5SgFqYu33d6DsAnbwvcp6LF9Vi/GarBdJyuhjPw+NqBIGmz2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(396003)(39860400002)(346002)(136003)(451199018)(66946007)(66556008)(66476007)(8676002)(36916002)(6486002)(478600001)(110136005)(316002)(5660300002)(41300700001)(4326008)(86362001)(6512007)(6506007)(186003)(26005)(6666004)(83380400001)(2906002)(8936002)(4744005)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9IZtKJpCBzxrfI7d66XZc+J/qIFmUjDyVPCH78avZmpb3+MVgiU9V4Bb04if?=
 =?us-ascii?Q?ILv3xUBoBrbtSTky5SlGDsbgFY9mzJQqA0KS7qae9Pb7tXrTy3jC/haEO6cs?=
 =?us-ascii?Q?RVuJMFIPvmaFJQwhLDjM+bF/cncSnEwdMi3uP/pQpZF0m6xXtWpa2s0r5LNQ?=
 =?us-ascii?Q?dZm8TO9FCCEiCFhLfniRLrW9cAlftZzN2J9F13qP+LXh9A3EoKhoDPIztnDj?=
 =?us-ascii?Q?k8dpr5L2QUsMIS9lxA9UROjsKM1kaN2KHG2WpdW2TgZz3Rqvo/LbuKwcXfRZ?=
 =?us-ascii?Q?Fe8i76WsewekAU+Bf9+oXjp0NX5/JHKCk9rsZ+Lk/RBlddJG4SJaZNYsJKHZ?=
 =?us-ascii?Q?0LQj9MpmvdiVXRmCngL0aQdSQyoctlF0K1MyxBjViveqtUWNQsmj9fpXfIgi?=
 =?us-ascii?Q?z/GBrKe8BzCjuKUPcSWOpnRHDJo2T5lJoixngIJKsAwTEsVs5i71NwrLBqGp?=
 =?us-ascii?Q?fW7DC6Esv15dq9zH0HU1qMEcM1shC8Kv6Kvf3E/3ZtBbeUt2+4fM5F2TjxCI?=
 =?us-ascii?Q?Y4FdDBTVaW9wdQXi02DqUFfORe3hC1ThwisPj8/9alp0QOC8/o/YK3mP++b9?=
 =?us-ascii?Q?DXGyiS8stClGMRC+2td100N4AoXFRl0EjVGJQjMTouRFChXAK/mSfRQiQe5a?=
 =?us-ascii?Q?xrcw8EaMKKnbvHdb5Vif+ll/d9eAoq+BLccTVPgaETTULqvojTgjzttE7OsE?=
 =?us-ascii?Q?ocf3SEeTLXftgkxD/JscsQn1p+hvGV6agEPwEK7RVRjuRKQe836WazLvLwXn?=
 =?us-ascii?Q?pyQ8j/wwJKZ+dnXNn9UmbXjbgp6o3ksjVa080pLIkcc3F9uksaEM0v8hzUd7?=
 =?us-ascii?Q?CAxSr6SQUzn2MzyZpXHyqkAY1xYgU2yJJvH/wqdZ9Q6vi/wJwkwhFae8+aGX?=
 =?us-ascii?Q?rAEPimyuY9YR4p40jXSGiZP0lsTKpv4Vlo/Ex7wE1DOWYqga7Lt4j2sQu7pq?=
 =?us-ascii?Q?JjF74B8b9dmSeUmrAM2Qlei7K7IfSu8O2vCVjDZUuhQZ9DrZ5/CKSXKGe0yO?=
 =?us-ascii?Q?Fp2opDhJEGqSf4Z3VWFsmqbetneArSp+eyhYjIi2F1xjEWWrXsJFH+u7oeGp?=
 =?us-ascii?Q?5LJRDmebrrOWRb/m6oldckUJzKJQ+dKeruVUhWMtBU/5N1Bk3mjeb5nGDxTI?=
 =?us-ascii?Q?diIckcW67k16iQ0uxJ87kF0SN1rgtF7CKA6IaafpC0Kdw1Os49JQHc9chRUA?=
 =?us-ascii?Q?1ECcJ93BW5bMKURVoceQnB2aBfuQR0MCMX6xkmdo7+/DCH51HerYOv7t3Zwm?=
 =?us-ascii?Q?xeATS64szm06VisWL51WG9HhR3VjceyMJ4JKFhTYWNH0m/fqAJdPGaLugpOv?=
 =?us-ascii?Q?dNijJO4qXcy1OgcYPjiiKA3ipy0qMRmjkHHw4YNw2QM7DQ9uNC9l/lP6y1w7?=
 =?us-ascii?Q?HgN6VdBrItDg+fERxJCj9sOwbjUgjAEP5eY7juo0VKGjtASt4fj8fuNfD4oL?=
 =?us-ascii?Q?7d4YXI/olFu8sWkSBc0JoyLFwKOCu3lXrwCJqj+4fNACJrGPngpOSovmOGTr?=
 =?us-ascii?Q?SK9zhfeu7skZiC8JRzny6YDFt62DNljR6VeWkN/KMashroeGn421jj5ZP269?=
 =?us-ascii?Q?LKwnFiXeb1XxGjG4d+rTM11Y2/ppJHVhrkBdXX7PliTTAzjIaEq0uJoyq/H1?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: P2aOAYmoxD6RtJvUcUv804cXDzxXIQ6MCRZOkcGbdsF0f0raS3AjGHzz3MpuyHTGyaAUubq3xTnI3vGkz9eZg4sCLjQbT6S8avUU1alhcTXHqPwO5w1q6ldVuXRAa/t1fNJBjKHODYdSU9sGNWZb26e4tZmdKW3TAYE5YIXUygBtft7f6T2ugNPjVlww2b6OvpsraSL8e+zEvkw9oJeAk84Pad3U/vsH60l5aJ0gYqx0gjfXr+6bllrzEzeOpMTZxBFCtnH7uzzOc5GnVPjX4nRSImpzjNMVRcGHpStI30qlyV5wrHhAPpLYKloAM95Dc6eWaumSe+L0DkAIrB1/iKShNSi//zsxmRdz2erW3XCvMzcoXxWK/xrcaVJRNYAvBDLpB60KkPQG0FOJGYmTx8uX831QdW08hiQagXtVBtRwXC6dDzYFEQ1LF6XiSW2aMlTosj+BK+ff0ItxW4bTZKeBYLycElD/3zAQCuP6noaSBk51Q7G0WlL/vk7fIbiWUY4MOlv+sNvs7biau/uNmJoAf7ZNksJ3atnRBYN3Mj/vDzn4YfO7yKW0o4tBZJswEZJQLSyRBj1GdheJ+W3G9o4QMEqx6Sag8/IVbJl/XkbqZr3S+xg9UIaPj+zJZw6rKqqceKOF4UlWVCsJm3zqD/0br4F73nGCbYKdF4sPYLPW3uc4NfIP0UzjBFNc3oRXwsVRmaEsJCXGi5jneTkb6ZmAIfWehH5fhhbcuJFs1lF8mJi5Gb8as6NMtYK/uBVw3xeL5vy4Lipuf+5AUYNjVJY4vjO/Q2TrAdI3i56s95ifxJloKQiLEdypBD2+j4A3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3d0764-0b3d-4036-ab47-08db1ead5a22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 01:43:29.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+h2lWipKapjsW/ldzw8X2+jCuFcy7tYlv0uKnmRrR8LXGPDsbEkfnrRULXE61rj5NP4Vhy14RYpokbo1vG/Pu7cLlnzXdCM7FMMjQrVBvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=703 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070014
X-Proofpoint-GUID: rHWGusORfAE0ubuAmOHZIIB-cA6Grm0s
X-Proofpoint-ORIG-GUID: rHWGusORfAE0ubuAmOHZIIB-cA6Grm0s
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan/Sreekanth,

> The series applies on
> [PATCH 00/15] mpi3mr: Few Enhancements and minor fixes
> from 2/24 posted by Ranjan.
>
> V2 - fixed a bug in [PATCH 5/6]
>
>
>  drivers/scsi/mpi3mr/mpi3mr.h           |  2 ++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c        | 50 ++++++++++++++++----------
>  drivers/scsi/mpi3mr/mpi3mr_os.c        | 24 +++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_transport.c |  5 +--
>  4 files changed, 58 insertions(+), 23 deletions(-)

Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
