Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A6DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiBODSi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:18:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiBODSh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:18:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D6920194
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:18:28 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F0pdFx032155;
        Tue, 15 Feb 2022 03:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=C2wEZMwuX5Oo2yc6Er2zB9FypaI7F4UKAWnXvnSuY34=;
 b=GhV1fuLxjVfzQfkenH153GxjwYSKlIx+T+P9TsMcalqMOJLkHsA8xDc72NniuzS+NlBj
 F/eOTGHt1BCdqyvVQnDM/ceCx/+D5+D1ZjyZp111wXEMX0zw6/rysOSDGdbVAsysEkpk
 GjvE+0KsfOVT+2E0GLNtOa77O7awj29H7u34T4oQhA2OWD9+FQPl4b5QEGXmrtr5zUfG
 8e4SM54gL+DlRM+14H9mHAjokfQ26pOa1EGAAHBfZsTAYGfwOVH5DE6dvDjvNE3KcIF5
 pFeBZ0s+CCbsdM+hjAFIrr32CFzFQ0SLtewppm07jxkcJIu/cFwWt0qZGPaoEvPxxYcR MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e820ng6ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:18:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3GUPr094017;
        Tue, 15 Feb 2022 03:18:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3e62xe049g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:18:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTzR6RnOx6VgsoHRMShTRE0xCuGgjzD36TMIKSPF0H5ETpCvR0cayGSKiT8WtsyEI/YKWuBEBD+/hWj16Eizmkwoo9DqTh8bqnFtH/ZQeJRnDC0hdAyI+OhInRljTnNV2VO5dYBD7ePgxcdixlZT3iVHVrYp8uM/OJDrWWOWgJ/x2m1tzrE7BgVL3hLc0U9rO+6sZOwdr8ddT8jMQFdiiPGn87Aw3LmLnACPjT9cs/MmpBhCxNuReSrNhz/zqxCxVHros8gN3qNjH43PZf1/tqJJg+VNKYgGab3gvyQ3GpDfjLjkCfYKyl0+ljsBf4qha0iRiTKbQk/Ebal4fkcqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2wEZMwuX5Oo2yc6Er2zB9FypaI7F4UKAWnXvnSuY34=;
 b=I9Glvh6AO7sOmE2kvoJxofGiTNOBF4M3pqUfKE1VoF3eF0dgGfqTMQ3f/FpEMcq33IfjniYJQq6F79alP0i3GJo3w3cqlqZGD2vkxUIhDzcYrA8owj/toWa1MXNG9aVa8OHq+Da3MAaT/LjZy+XNpwr0aY5nmJzP7kd/gQtc4e/D5CZUkIsdwFR3lWX7KoBAcIh41b1ariJzmHr6JahSgWke4HbaILEF/byxKs04fLgebOg3NJthZ5HeBsA5sWkkERK72ybb/DHoqrCMjkYmTLSXm+k3TQAGhk0IECi9dhTspANnIhAMJuv0ZzWtkBeKXmKVFTAQZO1MyQGqPJvnsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2wEZMwuX5Oo2yc6Er2zB9FypaI7F4UKAWnXvnSuY34=;
 b=I7ZDlGO2l2BrgjVuC2eyb8Js78T7MJ1/39IKEgd1gWcnWFxfKoYvFg2wBGz8qRFiDb4l8Ff18KdqaCbGwLbRD2Zpj87itJ8xNnwdsT2jq9B9dB4+dm3bTvE2QD/z39Zo7YdGF+Lt+ewaiQh1K1CBk++KGquVDGpihK4ONTSmG2s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB2973.namprd10.prod.outlook.com (2603:10b6:805:d5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Tue, 15 Feb
 2022 03:18:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 03:18:12 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH v3 00/31] libsas and pm8001 fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee44n7ni.fsf@ca-mkp.ca.oracle.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
        <f14056ab-56a3-0d44-fd51-5a6386c60e03@opensource.wdc.com>
Date:   Mon, 14 Feb 2022 22:18:10 -0500
In-Reply-To: <f14056ab-56a3-0d44-fd51-5a6386c60e03@opensource.wdc.com> (Damien
        Le Moal's message of "Mon, 14 Feb 2022 11:23:19 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:806:a7::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fabfc52-3a6c-4a90-72be-08d9f031cc40
X-MS-TrafficTypeDiagnostic: SN6PR10MB2973:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2973080677854998EFC0FEDC8E349@SN6PR10MB2973.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VKUsXJVZslZTYmkNqCEEuhMCC2WODL8/Z/drrrl1TVJJ/8rhVqs3F0z0TCQHM2utN2vWC93/QXjO00v1x04JtcYh+P9ZEvhSh3SQ7qv+G0Wdsevb8PGY2IMFpFGFAHIjfhhAZlJPO5UT5kU64vLAx/2pV+8HnsKvcW3jAYRH9kcGwNibA4OKvEsllNdB6sb8EZYAtV6YGxDg/R9OVZr5IGMJp6wY7IllmHneAvFb9MFf6TPGCNUEOKjyI8phxW0cCPhRMH4oFhzRE+qqy+Nl0L99sO4qC71m/pUEWHEM27fa7tlPtSgP+cRPztVObX38ptPv6FPIfKijOZ4obhvEoTfqZcpfFUvgLRZ6JilwTyH3W5w8U3NYIssBsyUF5rMzfR6esqSiwj5yl6pEN1Ybqp9zjc8jIuDtrXSSA1Hm2nUO2ImSoMqkbb6LQjBIg8rUbti8JIh57p3rFwz9BDWm+GhZivo1BtujI1WraOJm4sLfdOTIRB2h7c557JUuHAmF+QhDuE1tun6uyJnyiwA3ea9jqHOaWHQzlr/igEeGHEeahcTN26LJ+2F3KGo0deNGnaW93+UpsmvWqd8oBQt1ZtXYm7PIfWqR7p53NhOgMJ17DJWtv7hzyLsqC8D3ynspK4TQAyrmcbYlzv5f6CuZVwqdXwyMPyXzCUx74hE6YZV4lDVBaWb6KNGM6J/pU3YS/4XnIPd9zeypfs0T4eDSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(2906002)(6512007)(8676002)(5660300002)(8936002)(36916002)(4744005)(6506007)(52116002)(54906003)(508600001)(6916009)(66556008)(6486002)(66476007)(4326008)(38350700002)(316002)(66946007)(38100700002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ypdJ322pMQ6Q5CPP5pTgMiJkKjV63vd+s0DQ9xUjtdMxqvLCoF6lbZVxrZme?=
 =?us-ascii?Q?wpmotGq7Qu43WJ8VzXEhEdpk5mwHClROaNvocwLkfHdpjbiq1ytNBqWJtrZW?=
 =?us-ascii?Q?RNcXDchnuGt3gdfXG+KqGxClQlT1/Iz8ywS77UnsIkbRI6zjSIUqtJJnYWrG?=
 =?us-ascii?Q?atRNZpAE0RZekJ9r+lwsivs2TbJWToZGERptm6scfXP6qNZHjOzsSFEze3R9?=
 =?us-ascii?Q?U/mzY5z/tp9zvSPess6fESYQrmWFpY90xLJo4cZhcpZ9OVDEwpzvabqDARcg?=
 =?us-ascii?Q?tId+6uWeywSDQO7XppyQM3r1YvLgwSSqfkI5s8MopoiaFoevYmsWkLtyZyIQ?=
 =?us-ascii?Q?C1oUB+jYrrMPW1Eqfa4T2+66NaaCr0gGZURfx5Ge/+E0Lr9xckFUIoF8eQFP?=
 =?us-ascii?Q?jSD5H01eO3RPSfhQXRJ8DGexns2Qyc2b/9wANT6Zrnl9uHaC6ngiSmIK6kFK?=
 =?us-ascii?Q?jgzoSilFl8/kZ/pXOf2jBLf3EwS8XKZrDWhSTD2njsviD6r8OhYuJ53P4lCm?=
 =?us-ascii?Q?rk6/INkc6d0vBZc57gM9/+nrwkSgA3nAQr5Pvxrz5IWC6dKQ3ubXjUI7xUG1?=
 =?us-ascii?Q?rkrD8ZhWLJTc+Voh6QRsI/TGwEI4GzPPIW3acHX8Q8GQJ6qJ8Jo3yQZ99Ba2?=
 =?us-ascii?Q?ebWLZJZvJyJMEqx+KSVtULS5RDUONyEiz0eYo1+DUJkVXD6jXDNU8zOeOsqF?=
 =?us-ascii?Q?RiYf0hbNSRRxWqNqbA8B61XLmle+nI/zBLcW8MVPIjwvLYDZfOaDga482fnM?=
 =?us-ascii?Q?zFBEu915+/xX7b9r8FSne5gNwDt6FUv4q/2p8hHLoAOFVI/JfvqEDAjSyTzr?=
 =?us-ascii?Q?iojXptYPyKNidOzIAGPQVlbntRYLf4T7sDqfdWNOrhj8AivXJLnvA83CLy8G?=
 =?us-ascii?Q?Mnbvve/8bPjXL5XIMecJELyKgpTZSMoYNZouLt0lCAktXxITa3uLBr4mo7Gv?=
 =?us-ascii?Q?0GeXl8bp3Wk5tBDSRV5rwX/uM7+wSGYBRBfqA+17x7wukxpz8/ZNpoSJwsuD?=
 =?us-ascii?Q?LG6aKjVGomCHSn8yl4sHtuiI2Z5mSNPWgP9gubfJPaJuAdKhrhUhNGSShcTD?=
 =?us-ascii?Q?/lyfLH3DcvXgR2MXEsNox0rOxg+tCl3Yj7T9ypGOrz64WutE53IqWyRK2N1U?=
 =?us-ascii?Q?I+Jrl8Jy6EfP/g26yjXkzsq3g0WKUBOaSiw0zlJh4aLd73DcwNAB7XMtu9nK?=
 =?us-ascii?Q?/UNLvLsTCHCZw7Jn4p/qXbvXlQAy3WJ8VDsGKGrYt9rOcnsyGO2k9G9009sM?=
 =?us-ascii?Q?ZRicsZ0iBAH5MQf0AiNQJFy3qKJz2skeaWBWc7TI2/d7FQ1kwVntzSb3QHnW?=
 =?us-ascii?Q?hhUL4drYOI6g8oC6oHHXZ9Jw03cYETSbogqLXPIMuvBbCejpoCLq7czcKRXB?=
 =?us-ascii?Q?D2XiklJBm2ksyXM20fX0pTwNVPjbia2QooLqAkzwQr9e0y6hS++P9NcukzBA?=
 =?us-ascii?Q?ygEnumwGwCe8UOxkFyOO9urxbvWmF3Cua9OY2dJpzSn/rRGaYVZmlh2dH6Ox?=
 =?us-ascii?Q?B9wrLNJNDGoq0vqR106S3qSkQDbyRE7+VYSJDCkkDsfnbhn57xSoMBmlQMP9?=
 =?us-ascii?Q?z6X8jSc3YSPLA62Xok/bA51VTt4pqiC2PK+iPO0Qwya+Kc5zVoDw832tyeSX?=
 =?us-ascii?Q?yFQmu25fT2fn72JHZumLLdUq1LzVj+wWiZGj4huZmMC3n7pIrZvSR9dMblXX?=
 =?us-ascii?Q?AhAeJA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fabfc52-3a6c-4a90-72be-08d9f031cc40
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 03:18:12.4536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YjhutuQeSZFQyKjWAAnFarxv/31Xnh+PE2P0rs1eZo+0TEud3lrJ8Q8CewWerOhQOsQiRR/oCEuMQjaNzxMPM7mt/E7Cb4ZwA4LNtZQimCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2973
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=674 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202150015
X-Proofpoint-ORIG-GUID: VmGZXyRgrNMCEjbyh8N9Su9AOvKdk6tt
X-Proofpoint-GUID: VmGZXyRgrNMCEjbyh8N9Su9AOvKdk6tt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Damien!

> Note that there is a conflict between 5.18/scsi-staging and 5.17-rc3/4
> in the pm8001 driver. And I need to touch rc3/rc4 code too. Could you
> rebase scsi-staging ?

I pulled in 5.17/scsi-fixes and fixed up the conflicts.

I suggest you merge your -rc of choice when testing. That's what I do if
the baseline kernel has problems on my lab systems.

-- 
Martin K. Petersen	Oracle Linux Engineering
