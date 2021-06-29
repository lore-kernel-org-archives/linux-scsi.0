Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6763AC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E98613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhF2UpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:45:05 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32876 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234054AbhF2UpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 16:45:04 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TKajlj031362
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 20:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=p15pjzSQOVqMR1w+5WDbfczFCrzmAKlrGQdbFOB+qqI=;
 b=DTLC7jPJ1aHKnSbMnBz4s+GAm09BYzMv7mm8lqdHFFJ3Oa0XPm5gmFfaNLUs929dXeWN
 4CyDNJcL1HLErPvehnGiYupCP4ZxkIco/S3Fakl+YRcTTeYGDhosnYe/n432VUq5u47K
 bpRvbXFCHhrdZsZSpA7nalwIlzO4xUZsZUlgpqUbE15WnsHl8QPAaGC3MoPufCKQYOq9
 nHHJ9vog6FdjOsXhHGQ+kDPm+xcvlvSkdm/WvJfTvPHI+jc8q9wYQhbDic1WQtmKGy6F
 fZAlIFZTi+4ZzHbGElbJk34aWp95jXanapcyXZai69OFfHf9yCuDkMYQAj2E3/1ymyVG cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f174mqef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 20:42:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TKZrZ5049427
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 20:42:35 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 39dv26fk6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 20:42:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JN6luFLB0YwttliCEoXlknF0mO1SylClKFklImUZkoBsaBD5R26+QzXdHyv4vyaDlBnKHYlq3aydT/hXfn1Ni8VoywvMgkkjiz2Y8wO0vVeQhEqgwHPBO0kUNn25savNTqRGGJihDL0Tsp+xQqPPsqywSi/xiV8Wy+gawonaGKPbGakJRHxf8uCZJ3kILMGyYwMg4yOB6XFP+UQT9bHcE0moySyLrIwuT7pctMI6xbt6L8SSFWXQKLbeyMZZmPBdBP7D2Dw2wb5TafiW7NZEtHGHQ/WxkFtB23nGbt04NRdBmZ74KT+B6gESrX8cSl+N8V3xLawgOaDSv0wSIuwWLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p15pjzSQOVqMR1w+5WDbfczFCrzmAKlrGQdbFOB+qqI=;
 b=Io/cAIw46dCdPE2AFKGkcIbRHrqOvPcrvEGUkRyYVKFAhNDIlcLtOpufl1hefvQw7HPSffeYm5X0NnO+fJ/Kub2yHk5N4I/nbNs9jdhLO1LCwoMu1xMkjdCLhCrgivUuTUg6ATYrXJJyN9qR5GGFa31NFJ2wtPJwEdHmEIymdVtWnvKS/vCKsmrHR01Wd4csVQs3l53jF6JEx486HJLQIL5cmqmijkY8oRaEdjvJ6PufQbhsOb/I7cpgVaXsvyk6Y0+OFVD/lk8hTVBuuj36Y4UjIi7N0S7/s3zQtZ/aGBC1J291cUIKPqUmyYNU9yBwCzaiIs7nw8Qyo1jUFGbbxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p15pjzSQOVqMR1w+5WDbfczFCrzmAKlrGQdbFOB+qqI=;
 b=ad7y7oojOqVbBCdwNTw9prDH/iUmtfkMR6yQRBaaqrZLqmriYXrT5+gfjlt3ed8mv3ojFgZo26FaJmhSu4nlzejdr1MgbzZWA8/NE3zaXacCxklCwkOpKoW2UADIrAT5EJzanfwRg1oTzio0vnot6GnLSMLKm/RkOJD4+N2nWUQ=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5450.namprd10.prod.outlook.com (2603:10b6:510:ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 20:42:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 20:42:34 +0000
To:     Quat Le <quat.le@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Retry I/O for Notify (Enable Spinup) Required error.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r8kjtcg.fsf@ca-mkp.ca.oracle.com>
References: <20210629155826.48441-1-quat.le@oracle.com>
Date:   Tue, 29 Jun 2021 16:42:32 -0400
In-Reply-To: <20210629155826.48441-1-quat.le@oracle.com> (Quat Le's message of
        "Tue, 29 Jun 2021 08:58:26 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:40::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR04CA0029.namprd04.prod.outlook.com (2603:10b6:a03:40::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 20:42:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca525c32-1239-4dbf-ffc3-08d93b3e6c5c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54504B98BF15C7A356F63CD08E029@PH0PR10MB5450.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svumDNfyIvnie4Mv58KR4BaJFqpiVKy0GI+rfKtTfBE/o/AvTP6AjKk/ICbLPVNxaDy13DVMDAsA0E5iYRLY5WK/WLAy6AIQ78qbtGiX4gwknTDy56VU/aDh5vLtSOlc2HElvsq0Ezqs/vXlu4BYcM1P2rOfNaWZttj5OIgkLZiDurihompmDmDxydAz+yYfabzj4TOqaalX9YKU8VO/NFEXmcT/Mq8q3BHAJ4sCMuHms0WmDakQN+iU0FxGug4L3sh9qO9UKo+tJZiaOriXfsJKtHWM7rWNeWdDy5iIQTKUyQ/EGhoOSlAF6uDdfFlcShAqPv0A2ejTauB2bT8MJHiLR9tB9fEs91ILM9y5Gc3QNfAyd9a9bouyJuHxg5m8iaVYI1gvoPk+YF9JoclUDKOk5ZcevbYjgLEgQs2Flk4QDz0NQEtMtZUZwFP4gfX12HhuGv/TNPVsqjtWty166129YpFfDAFVRBZ2qYzsBIPA/82eglqobwpALX76TtHd4QlA/B58wFpNp9w7xpxrYY1g02IgnLe0atKIooc6OwvmxpjgwsIT+AAPE/E+meAw8pcyq50QyWDDn1vczPN2h6KM/gOiyeyYvs6W29TZA9W6IJyX576Qdsg1bJEynYzgkvdCmL1zfmlw3/TdDWBzpEA4Bt2xWTzWLeNe2YD/TjYoOTSfJi6uOEmaszXaimHbgagO+zG3LD9l1vznDZr35w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(7696005)(8936002)(316002)(26005)(6636002)(4744005)(186003)(6862004)(86362001)(38350700002)(83380400001)(38100700002)(4326008)(55016002)(52116002)(2906002)(8676002)(956004)(66946007)(5660300002)(66476007)(36916002)(478600001)(16526019)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1G/e8q7pCmr1m3Nj9Mnhr9qiFZ3G+fms8AbwvGQwH5cuuI9FHRFdmJDJkRt?=
 =?us-ascii?Q?tlglYwogYSrS9Smi+CJcmD4fOlQuQR1U+roniWGt52VQHlHVqKdT1zPDyULs?=
 =?us-ascii?Q?O1zMjpPucQV26iKl4llY0bp9stTV9cANnwuu3jvgl3SX12tDA6P4d0pezEZe?=
 =?us-ascii?Q?C/Tvkg1ZPJobZZVfqA55f3GFc+6j6HyWIj3VQ74lUiAf0tUXGwYL7IhU6RKN?=
 =?us-ascii?Q?BKdBDPKmV017GbKa4TLTTm1ADShgG2Hwbd7TA/NaVL9ffuXqKyQ2eKrv9d/o?=
 =?us-ascii?Q?iHbFmFuuL2x6VeVebIBEZaYSOuTR8Vh+Hsekj9Jufhc4j7MN6/9tSVAGBNi7?=
 =?us-ascii?Q?6zO3MQJfX2CFnBwTOC4yDY0qXrckIdQvkxavtYuLAZrc7X29J79yDGUUHfJp?=
 =?us-ascii?Q?dloU1AzUVt9e9gD6wBs4g9KEbvtsHbPufJGlP14CjuteJbiILW7PrtBUH4UQ?=
 =?us-ascii?Q?YgbHLQ5I9j/Z5hwFXjuj02R2GSLzIAIvGFqCpOj7o2GlnAMzH2iqq9Jw1xAn?=
 =?us-ascii?Q?AjnX79MFbOz5rmoqxu/yQxAsHGAJ7v1/6Zcav6uJVtStbc6o18pE7nZfI0Dh?=
 =?us-ascii?Q?diUa2tXYEQoJlHTRL7K0igVXWQrjIPjHfdPsCLAtO36KQXQhQvXNkWzGTIui?=
 =?us-ascii?Q?4rUkMd/LU6Vu+lIH0XEjD8Mdhrq+s1cy/d8A4Domv7FRbQL4pWwk78pyyJ3N?=
 =?us-ascii?Q?SFoAeueUyFru49HTygyvBq6oIYy+JLqQtTdd9O5zBJnWkPgx2XcJSAgjKxQ+?=
 =?us-ascii?Q?KPMFBwp3i7j+TYrRt6tLEB7GOtr7IpNyDR9sl4IATr866v8GHLn0KNI9w6aK?=
 =?us-ascii?Q?5xdHlnqNqFDjic5mUKmeAOf2C7faSHo4h7RDcRrWmErufQzI8bfjXnsozppi?=
 =?us-ascii?Q?vpYnGAs+c6yU2Wazf2xwUJy6bgZNqdb8Jc3bBkLqJja1zJvKQ6gL6FFxFLvI?=
 =?us-ascii?Q?iABbw+0p1exH382ZTxH8XOdd3iFxyv8FAdVXqmkHRt/3GN5J7aVDkPxr944w?=
 =?us-ascii?Q?N2bvM8QGykay9Xnu0U2Hm5dzpD93mfg/PmrCLSH0RcJaW2gansBQN3nJ8Umo?=
 =?us-ascii?Q?Qj1uyf1Dh2gXGjs5iDzZa0SyiMSQ7k/OTYX1rFNVOOIfO/oiz2xXZWNR/wh8?=
 =?us-ascii?Q?P7k7C3oZpWhFrBu9tO5OJzAUG6QNIKA3jxWcELO+Fg+frVJVkDT0pkcwKuWm?=
 =?us-ascii?Q?x9NTMU473EhnvS9aXA72NKBLQjBCzw+QWALkzwSTeIF579eonmDkopZoJNBI?=
 =?us-ascii?Q?qrQD03ut61HmKlTyW53N7lTsaaK+YIWo4slK7ZYBbYWmF71ycvaWe+2P2Aug?=
 =?us-ascii?Q?srLNbc65iKHlf8V6bojZiFci?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca525c32-1239-4dbf-ffc3-08d93b3e6c5c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 20:42:34.4070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XxQWDB17WxIguHnb7D7faMdGD9mf1SN2AfFwKoG0tf1J0BDShoPu3rXuBpDSiaTVTkJaEcJvbR4xmxeLpPKbKG0EZ7Zs8FEO3hJ4rw8cm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5450
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10030 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290128
X-Proofpoint-GUID: 86zOIf-7vvH72ie6htJjFCPFDIxIW6Gl
X-Proofpoint-ORIG-GUID: 86zOIf-7vvH72ie6htJjFCPFDIxIW6Gl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Quat,

> If the device is power-cycled, it takes time for the initiator to
> transmit the periodic NOTIFY (ENABLE SPINUP) SAS primitive, and for the
> device to respond to the primitive to become ACTIVE. Retry the I/O
> request to allow the device time to become ACTIVE.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
