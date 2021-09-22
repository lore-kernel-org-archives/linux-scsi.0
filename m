Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12599C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E07A261107
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhIVEKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:10:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64738 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhIVEKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:10:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1nCO1013119;
        Wed, 22 Sep 2021 04:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/UpZcEk1Trb2cwQATjOuzEKoDRSqIbUJ1MFEBZ7J7eQ=;
 b=C8IbPsEfVwvWLFVo2Ld6BAA4wjeO1Kzi3mvbugDpetmhm0Fgw8IbEpCSZPtR5q4D9WrA
 sLh4jNdk6PfiZSuxGecaaQwo1I+8zxCBANHbMjD899HughSnhMVtfgIn7Ny0+FV4flch
 HcGoJqpwHtlUdZMvbh8evWnBWcM60eq8bH+rXQERBGzBaa99c6PvA67Yz479zL+SYuzE
 nKqfTr7a7RWPgG0cmhFiGi0XlfaWSPYf4ll6/gLgMFV8ap7ySL5okUq7FHeFz2mYKlPX
 QhZpjPpgk+1ULd4tJ4OSpSuqV9iTNZ5t89D34fuRTKMXBBw3PnFgVU0N42LQurl3Nyks Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4qh99p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:08:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M461me187903;
        Wed, 22 Sep 2021 04:08:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3b7q5vke6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1BACGr0woDhvT8fF8lL+foiIC0zzzFGWOyWjPHp1v+X5IsVaGhF/qdXBkdD+HezTzlouAkh+XO2cNRKv+kFjvYCk20M88szqmtmcdkzztxoAZeVQn9NX/31eOjLd4XQS33QYByWx/GUBsL8Oysh0gjfDrXkNK3ESKLK805/+Hn0h6c48djlHa7Kqx4q1tDJFBzBa2If58HggVQj5AFbqxGQDGiMYrKwiBhOz3UGuA1/9JhlL+8puiwrG9sz524mVHIP9S2KASrvVzrrJ8m/nj7XrKn0H5TR7Em+CTqR5J4izl0fSK8fFQUVKW7joEkr4+Rle7IuDkEJRcLUuKYnRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/UpZcEk1Trb2cwQATjOuzEKoDRSqIbUJ1MFEBZ7J7eQ=;
 b=lBGa/zKULAIO13Wti8inwvvkPdGvkqc9Je4XIiTm4siDcvxEqbvCefBq7X9WRtoM5iPQLdr3L/60Qas/GLPVXWrSuVUL+bbauXM/4h4pSKUkxmzCTU2IhNnU+cOTGoV/zwSbd6aZSlpoZjFUuuABPxBr+c7IV+0BAYGDsLgioL8V7Q6O28cKZ//p2zxSYqq7dawW5IG70TOqm1LI//arD7rIIIUq0Z9kXsrLSQESWvIYGklBW7E6Mp5BJi9ram+gppX56GpfKIOvCapACxePA8SM2k5OJWQ09GquK6MO1uUtD/X5ymhjtlxpJNDXzot/Ogi6klKQHHnFRO4QGywZdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UpZcEk1Trb2cwQATjOuzEKoDRSqIbUJ1MFEBZ7J7eQ=;
 b=TVaf35+kvXKve06jlBSuKII4nMzsI1j5AVbAY/3imEBVmkXXARMjiRgJggOv0x94ns4QfO91S6DXN5ORqlY5f4i+HlZCdMdWPR4OVimxHH/GYrUleO6HWleGRXjY0rQJIiqve1PFHlPAyKZocE8NX9nt4kbio/UnpT5IwVhA9Lo=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 04:08:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:08:21 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v7 0/2] Add temperature notification support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rzpp80n.fsf@ca-mkp.ca.oracle.com>
References: <20210915060407.40-1-avri.altman@wdc.com>
Date:   Wed, 22 Sep 2021 00:08:19 -0400
In-Reply-To: <20210915060407.40-1-avri.altman@wdc.com> (Avri Altman's message
        of "Wed, 15 Sep 2021 09:04:05 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0065.namprd02.prod.outlook.com
 (2603:10b6:a03:54::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.33) by BYAPR02CA0065.namprd02.prod.outlook.com (2603:10b6:a03:54::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 04:08:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3557ef8-0242-4f87-ef35-08d97d7e9dda
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662575AD556D55227F81D168EA29@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RCoWscwMRaVtf8PgFhpO9F51hSlZBzKXNSxWzNcjIEwF5Eun4EQLHscRtCTV78Jqw0GJFAp90OIHnRADgDB5p7erIJTztQCnIu2e44NQEEzSnLNekEc/Zj5uE0RaPMLzrTSTdnPSYrgsNk8/HfCqUp3R1jSVZLDnP18FfH92fj+zmhLUhvX/2BsMz8TSXR0QxS5icZvP1CC2DrGhpBaPWVXw7TQLjycFtv+fHUC5l/SUImtVZ7D5slzkbKUTS+pXU+sj6YYg6NvrtD8hZZQL0Gu/tbMJFjngunlacINC78lPCxA5zPjQbhorjy/rBhF0u1tdFyOVlQMdptWU4FAuXz+STUn83Y8HM7wfh5rouuodLpFRoEsJpOusX3C9VSB18XMdrsbRVCEJ6Zb7auC7sId80O9cJ7jy3VX/7cwL4j0v0QI6wofbWUaVcOYzMsN411Aw/bWAst7wBzcMTAx/X720sN5W48f/gkSE5kspTpvbQOvCNydJ3Z4v7jUPNiaeaaQpEYqmyvaXbkyb5MBdLRQf2dnw0pF/VknZby9ZM428xiqNniHyZfEpVhMbSmtN0eV+ROiYH9gM4EqwjzBRqgeZ9HdGlIaG3RRy/RVfEN43fFttkYPsMnDT1f0eVy8bQqGXaF6muZM56iY4FDEJnftTTGpWy6bmQpvXVJxrleM3o2vGl46iuV5hKIkJbyBPQynmoIDlrhNnpzj8OGpAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(956004)(5660300002)(54906003)(83380400001)(8936002)(52116002)(26005)(38100700002)(4326008)(316002)(36916002)(7696005)(86362001)(4744005)(186003)(508600001)(8676002)(6916009)(66476007)(66946007)(15650500001)(66556008)(55016002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2p0JNmEoKuAbZUBShm2S8T1VPkYQhuXY2rvMZxxok4O50hb/MuhahhzMQdjH?=
 =?us-ascii?Q?nJxpa8fP0J1Wrg/uLvL51QTnVG8btd7ZFG0J6V1q++AGmfRdJDXM1xMkJAnZ?=
 =?us-ascii?Q?aR+c092w0ouLJwZC7uxME32fg3crgcbrRcKXzjCSiNzV6Lo0mjm1qCzUVtx/?=
 =?us-ascii?Q?Zn3vTLGIvqn7Zz3MGgz5vZg1QKNb5ZMkbuHR5iLb9UBj9k1M3o6qEWdVwwve?=
 =?us-ascii?Q?fpjD4uHW8VyfgyXxOFp9P6So9u4hjMplj1qN+iXP0kNnK0ksWdXU/X7LjOz+?=
 =?us-ascii?Q?aiZF+YmBT1OXakO3Mb00HW7oJQts5z8v6nc+aHXb57Kn6CRZDA3OLuIxYHlu?=
 =?us-ascii?Q?q5DrCF7LPSVLveYEwKdmvDvt08JXG6z2M1wwvAX4/yt4ZSlbnfhFPurFyYse?=
 =?us-ascii?Q?LrGkmFOHpbcexHflxrftgtcE9pnfMp4xVVOAaLG+bwFuMjgkZgStzJl4avlR?=
 =?us-ascii?Q?B9yOkCw9fhcHmcJixn+tviiCzfhlyJQYkC9H/CxXCuAPD5ycJgKprdM6EunF?=
 =?us-ascii?Q?KlCNiK2DMIESdJ2In1IEEOlBxTZGYhC6FfkIxuHCHE32moxmO8+BSbNXke+v?=
 =?us-ascii?Q?xQaY+REfYtx6efMVFF4FSZkK0qh2zFaRKXFFWhTvjSB2GrYhMq5SexRTFr3e?=
 =?us-ascii?Q?is3PwnJZ7UklZroUXCpSuVY+8xtVVUg3J8Ve2HU6bdQ/rlAQQCFkAEimtDx0?=
 =?us-ascii?Q?8n1PeY545VOUoMk6lMB/YLjipiO69I5dLhQTFlH7Z2KT/CMsy/Y0F33aYgzz?=
 =?us-ascii?Q?JmqydjQu/azkp6oFLXui/gDojnmRme039G9CI8lwfNNB8Ck3BcKwNiKx4lmC?=
 =?us-ascii?Q?0KLmkjXBOLG+1bs36RHSAXMjB2fqhIIC/WS+rFtrc4AyLyKJrV0uPoYWUTLL?=
 =?us-ascii?Q?HQ8Z/CX4Bn3X5jXNm6aYI+IsaHhV3rnd1wYBtmaHBE3P5ibQ7FvMd6koEoWh?=
 =?us-ascii?Q?eZ7gtGrgdQvenlUcDe6imwU+NLgr44dQQVkco1LO6Kz5VYSPayxoMqupyoEg?=
 =?us-ascii?Q?RTNxfb9PejiorHlG9izuvfCkgHySEisXblAJHqoPLe+YGO4GK6VrSIagxSHY?=
 =?us-ascii?Q?fqXQzM0GRIp2RbhXnBBid23OLbjOe3GtGW+M+zC/LpfRY+VTm2YAib/WpNk4?=
 =?us-ascii?Q?JbMOhanLlXKzJs3qDaAL3PMB96LXCZEqHBUMY8sQnQuGKoai5I2b18SZs/E0?=
 =?us-ascii?Q?eF3wZKOQrQ7V64fINPBGePHbBVhHxSo5diD5PDQWk2RBa+VCzwcOC7nchmxl?=
 =?us-ascii?Q?OxJUnvfGn39zZZIMYN6obdHOQvx/gxngGYhG1orwAvlJawodYpPMGgV8fxKn?=
 =?us-ascii?Q?FgmISP1HlV+OjpsluD+hUSPN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3557ef8-0242-4f87-ef35-08d97d7e9dda
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:08:21.8682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCKfMopuX3KUi9iI2q0MpKf0+sb1J5B3F7DvXdzYjMr/XceKXQUqj60oZCZsChhiU3ZYIEdRrYKziKYqg55aBUMJAQ0n2J/8xvky0FW0ANM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109220026
X-Proofpoint-ORIG-GUID: DLmCi1NwmfEu83oWJnSry3Bh8_Z7KBAJ
X-Proofpoint-GUID: DLmCi1NwmfEu83oWJnSry3Bh8_Z7KBAJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> UFS3.0 allows using the ufs device as a temperature sensor. The purpose
> of this optional feature is to provide notification to the host of the
> UFS device case temperature. It allows reading of a rough estimate
> (+-10 degrees centigrade) of the current case temperature, and setting a
> lower and upper temperature bounds, in which the device will trigger an
> applicable exception event.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
