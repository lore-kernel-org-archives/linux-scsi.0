Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774B5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 04:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45D6122CA2
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 04:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAFEVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 23:21:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43580 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAFEVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 23:21:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1064DSFa160206;
        Wed, 6 Jan 2021 04:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=un0epo6bN0em3f/UE7dpIGLGveDgyB0omRQVZI/u0EY=;
 b=D3KHwAe2nCa5r3zTWyAFeSSRersq5XS29/rCPMVvfMqtLHy8PNtIDxvslCMpCjdZJZFO
 +0xL0hAaflrhqWzBL0Je0Fv/grDiMcPDNjR4mm/q+cQaJOVMpvOCXnHECMZGoN3/YbN7
 6RzpgbKre3hkQB+IONYbI8+QuD4f5fmSNskMej/ogRISnb6uzHHAOsSqNCDAbXOGPAv8
 z5igHR8Mk+SuPVnts2rsql7dsGsfwT5FDoKoFEFwOtysl65GKiAcvzSSpLhxRGH4dp3M
 UAdPv4frhWu3PofpjYd/P5hNNzmKJDzqyP31SzSvKbIk/TvRfDin7etnJUG7hT8xsI+h Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35w53b03qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 04:18:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1064Eod9057556;
        Wed, 6 Jan 2021 04:18:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by aserp3020.oracle.com with ESMTP id 35v1f9exxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 04:18:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKABHQ2jHtfl2+yuiliTS83Ft24YyUUiguimyQVO99VNrCftUjep0Ba09P/8zDuxktUT8E9C2pwSziMQT7b76Ik+jzu5YkbKkE0p5WDQ/9d2ea/hMC42EWxkVSpbVLDLQ/kZ2ddHT3XdSoKX+vU+01i/b+b7SCVhn/Yw6WOqbdrOSV8VZrRg8RBFZDU1RWdjZgkb+9yJvIZtUs1o0OsAhsvvdiVL6sEi81HCcQ9rhuIUcDgqsr+t+NiXb4MfaG/LWv+ZLQHJMRGOlIWZJFr3/NT919FHcDnzHaRfS1LRJmROtIRpGTTT/A7VQYrywam7+ByHR38HvkFQKixdAgHTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=un0epo6bN0em3f/UE7dpIGLGveDgyB0omRQVZI/u0EY=;
 b=cqlBNXTQphCrmgCVy1gyvMfQrsrqTUzINSC8V9X6Pf7McA6wTuVaFsfCX/XVKpVEnLbwBUXsxPhSI3kuuDG6ENOUJI9Dq0b4CasJL7cORLUFbe0JvPDlTyMCJgGr1A4QP3qtp8wrF7+XfqHGkYZbWPmSNUKAbfZdPvD96OXRvLFBemU2PEj6DwhBXXKaM70gEkSk7dQFdkm0xJ2ER7z3vjINTllQ+obnrFMZG7x1QuIALKBlsKZO3VUQpAHfn1KLdO9i+e+vEah9f7LhhkEg7+jiiVpbDnKIlv0PVCVZj8yQv55sKaGznhYUN1wGRo6lVA8PR+Z0Pi8uQK/2w4Meng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=un0epo6bN0em3f/UE7dpIGLGveDgyB0omRQVZI/u0EY=;
 b=bqdAMM2UauTqZmsog5crCx7/Yd1IczgcwjQ15Gh5hQQuPAf8Bq+FzL6wj59IW0unrlro/P6OEC9gxCRCPxNB+EbJFdWKhDm5vigUuZeuljB5WRgJdEwOjPvstJ2UH2TcMZgOpL4o6o0dfv714etBJTzxeWE42urF6qodnKC7tPA=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 04:18:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 04:18:12 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <maz@kernel.org>,
        <kashyap.desai@broadcom.com>
Subject: Re: [PATCH 0/2] hisi_sas: Expose hw queues for v2 hw and remove
 unused code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11reyg0uc.fsf@ca-mkp.ca.oracle.com>
References: <1609763622-34119-1-git-send-email-john.garry@huawei.com>
Date:   Tue, 05 Jan 2021 23:18:08 -0500
In-Reply-To: <1609763622-34119-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 4 Jan 2021 20:33:40 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR1401CA0014.namprd14.prod.outlook.com
 (2603:10b6:4:4a::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR1401CA0014.namprd14.prod.outlook.com (2603:10b6:4:4a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 04:18:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b09d5b6f-12ae-468e-dd4a-08d8b1fa14fc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4661DC26F0722E82077B380B8ED00@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PhU0lYfoolgiOYS82vI0jOeaKXDaO7zZJ/zYXCZrcUMH4u5LLicRk11Qqd47oqSlUmbR9Q0JPrbg74yMpAf0kklSxSAlSJrRZoA4LHeRJDGu+ktErvzSkfr8cVYPbNYk5TTeqDuPdPiCXDtCayTAkVvIdbPHkGdljpKFoyTB+UMHBBqUbTNSfR87tg6RRVqaU0DaX5RoHSIw/kSNsQ2GbbJbmGrQnQRMxJkJ+jUcukZoIlCjhKXYqPmzdUd38eOAESm3c2HEZ/CSTepVm/mVx2HLGacv4E0TMNFsMVjGElWMa/UQVu/0Aj0NAnXutP9r29xdgOzNjvKG4GzlBJ4BYDBvZNyTM8qR8ID/xwTnNG9SPPHFuO9z5eq/5frErUXdbxlGJNYCKiuwG1hpkpyZDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(39830400003)(376002)(366004)(558084003)(2906002)(316002)(6916009)(66476007)(4326008)(66556008)(54906003)(52116002)(36916002)(7696005)(478600001)(5660300002)(6666004)(8676002)(8936002)(16526019)(26005)(186003)(55016002)(956004)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cAKaiwdmYz8ve6xbWj7j8S3y9ad2yx2HH4E3Jzl3ErwIzHMBNRhX9Xgcz/ga?=
 =?us-ascii?Q?pwPdOhbhWPUGt5eNjMBoRq4mY4r7dx741wa134bsWM2MHoOXpjR2zzdNLRKP?=
 =?us-ascii?Q?DZNy9kooBqFJYhNLuX7ddse2NBG1D4MX/HJdyWgBu3Dy5ikBdvxqTDsykz/z?=
 =?us-ascii?Q?9ZmCMTNYza9Drmpk+noFUOpbwJZxp7iqKcqrQfkN4hfclYtFeqOG2ToZqlPg?=
 =?us-ascii?Q?jP+yEj9aBx9dVRS9dfF1Lc1OtMYz1BYOXrlxN80FOusKqKruQfb9qVDKch3j?=
 =?us-ascii?Q?riU6HumTNCwl08cuH7E/U3YbNRfzDwJjuTkafcSlS6idF7crCfp8To9BXOyd?=
 =?us-ascii?Q?YtNnUhEWlhzT+2XHeA1Jn9Y3cbN1qYrOOoEIpg74FiGygF/IzxBwY/4YfMLl?=
 =?us-ascii?Q?a7CroX+jFXhjPdjD5mi5B+lnuXU2zCmyTF4qjn4xNC9h7FncpZ4xlGVqSj3a?=
 =?us-ascii?Q?D6Jhk4eMKFoqSSs1O1coy5T2nCSe+tUoKgampcneKmunZGOjB1QhY/Nv0Xfq?=
 =?us-ascii?Q?/nButcJkmrxqfjO3k9IIR1ccRyd1RWYdAM5/+31d4DtLhivfgWdfFQCi6Z1w?=
 =?us-ascii?Q?1miFl8ST0mNnnsoWkYNP34YzMeBtUIkalUW6u72YBV2zXxuJ8Y/PFYtLhB41?=
 =?us-ascii?Q?yYkKQCBUFxC/6wJE922cpgM2OPNh+hC8O8LrPzvgnJP+4DqG4KUAf4qdYmYO?=
 =?us-ascii?Q?UBBW2L33eRiDDE6TkYsa5KnCLWouwIwxf3CEmwaikpw/V1G8VGtG47dKs7Eg?=
 =?us-ascii?Q?jsNyvGefYPOmTN7Azbo7SmZUetiFb0w+jELvaUYmvl3RaGdI4KpLqEwpUl2v?=
 =?us-ascii?Q?AiNXYvlEgjjm/3wsebhHCMQxEt2lc7TFX3s5ENa4wk6nCYNCFc//qKP07pO+?=
 =?us-ascii?Q?cZ7Pn2979kyE8vGTQ+P5lrHZfj3RKwhr/SNLFJG2NjuFOZ4CVVJzfCJyyJYv?=
 =?us-ascii?Q?/emo6Ml2QYAv51/5IOw3irwW0uYvcY9PtNsfR44ik3c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 04:18:12.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: b09d5b6f-12ae-468e-dd4a-08d8b1fa14fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCzuuAy5wBvXj+hNcyzLvUSM42K/t2iYbY4ksZXIoPwWqwBtpYjuNosuyTO61dotli7JfAodgQsS6plfXoyigAJ8PDWadSzx55P2afYvQBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=819 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 mlxlogscore=994 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Patch "scsi: hisi_sas: Expose HW queues for v2 hw" was not merged for
> v5.11, so resending for v5.12.

Any changes to it? 5.11/postmerge is sitting in my fixes branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
