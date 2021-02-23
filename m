Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F30CC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 188F664E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhBWDbY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:31:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhBWDbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:31:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3UeW3066760;
        Tue, 23 Feb 2021 03:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kH5DoguzekEsOf85yiKtjSbWNNXLDSW14WOP50lpoqY=;
 b=JGYMA83T4S+DN8Ep53AF2UefxFPdKQksllMbRuPkWlCTlqd2TKVJuq5oSeEVwt40wCuU
 TE3s/clpq2+VVKFZH9g/LOtnAv1rgzgxRpR+KZ+oNiwttOHajt4uzhIVVKKBD9Eiz35B
 Bvh1Yb0U58zPEVCT52NAchnla3fiJM3K9rwnacbsCtBC0kthRvljYUUt6nCOVblgvpG/
 n1F1lgs4ic1ixuZjqsp+PSUhST8wWhc44RWP21FFFY7ACDc8lE1OtI+5dWs3ad0H8o+y
 X6fxmY+RgSJngmzkz6eAJUgWZMKnDxvUg7B3hzo1dzA8K+1Z513DaHPKB9HadlO/OTQI 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3cmrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:30:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3QkJJ153725;
        Tue, 23 Feb 2021 03:30:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 36ucaxtnct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:30:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdvdgfmNxuLmyv0mx7M1Q7joZCSnM5QVMWxTS9IEW5sSN2uuqxpLXn5TYkfyeM4KevY76mkIQHHf5We3St2cB2zJj+w13wP9UCtUaDYWR1R0XPilws2t31yG2cFPWAb3c3DCG55eTXPpggiGSTIOYY8xPEzPeL9YIkyDFKljoR8097REq+fuTBEg82v7IhUVCMcnjbBQR8c0Vqc73tCaRCHk2OPq1Zy6tV8ODStc6h0Ln3wnX9/NCloZ+vEjrIsMq3phCHfgdrWPwzSZO/xkIH+1Dm+VS3ilyqzvgwufVD4Aavw2ECPVtnbT0gY8QxLxpDPqUSw5EPebR1viQ9AWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kH5DoguzekEsOf85yiKtjSbWNNXLDSW14WOP50lpoqY=;
 b=IoclGMKKUXZuQpNAh5xYg8Xa8zplL6VDcIJnKo9U5b1MCc6lsFNveyOSP+GXBlCZHoo1hdUDUuJFSAMeKhWSYXZOJ9UwBBq4fQTh/yXrdZ/LvF4ZeArI8OG+UfHqiIPDH8NPe/CvlfP5UI0/pMgmXr3Z6G9YzjdO7TkKN1eF1WRVAIpaqO4OxKmJpwK2Bdt14b1ezTynOLYRx/5QWhys79ucXYhVgkw/J14kAptZpx+br7s9F1+fyDYmLW2OogzbomD8hdEHKvfvWRNTwilhuBhMNyXs3ym+zPqeStw0bL1aOrhDNSHDJ4X5t6j9I9neOeUnmbwkLPRJ6/cmBN6b6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kH5DoguzekEsOf85yiKtjSbWNNXLDSW14WOP50lpoqY=;
 b=hKaSKFo65L+TH8BbrxvpsoTptOn46b7i+aNxHv0mdddX2kX1LjngCAHjdJ37/XDn/hRfMuOO5AcUpV7xb4gy6xSNd0wosmGSEkUTZiadGbprvp/MDp1WOW/K/X2Zrj2QNtMxz8zX61b04sJ8PpxQ8vxawqdXAOxfHe7Ojh9Nsak=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 03:30:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:30:26 +0000
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "martin . petersen @ oracle . com" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] sd: sd_zbc: don't pass GFP_NOIO to kvcalloc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn0rfol5.fsf@ca-mkp.ca.oracle.com>
References: <5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com>
Date:   Mon, 22 Feb 2021 22:30:24 -0500
In-Reply-To: <5a6345e2989fd06c049ac4e4627f6acb492c15b8.1613569821.git.johannes.thumshirn@wdc.com>
        (Johannes Thumshirn's message of "Wed, 17 Feb 2021 22:52:45 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0111.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0111.namprd13.prod.outlook.com (2603:10b6:a03:2c5::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.11 via Frontend Transport; Tue, 23 Feb 2021 03:30:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2119b9a-d676-45c8-8a0c-08d8d7ab5c90
X-MS-TrafficTypeDiagnostic: PH0PR10MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB453409317273B180872DF33F8E809@PH0PR10MB4534.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lS9r/QAtuam+CkAcgXcFlbsFKSPeIbvgutF2pNbbeBVXgRKEkfMilgjnCqX9LtfxxGDZvZt5YcpuYPG/rQrFbV6FB6w3hRj1j40i4vJLn0xNBQsKD9r6IFhDYmUzrBkFfKiEfjjdp33p+/ban6ljprcuXJQlnmQF+EC0Cz3zuUGSARaJ9nolAiu0nDvGDEAhBVy5Jded/8rn9WLp/9hqADy3PLojpSZ2ZGs13tYuSjxeePz1G9nDo/AZ+KaqARsHtOxuWou0T7WjzKUQ07RHRLntZWJsrqlRtmJXPYu/hduML452JQLePBJ5aLJzW22h0Yn3L8WvdV4pNy10gb0bqj0o8ydz7q/cVCSTIPnjBPoqCZiRsh/CxXjTf4q4cTmKNiYJ1aELd4aDbGpyWonVSmV5yfwKyyuIyw31QHaauoC9gxTqQ6ugMzYnCeXtWaZpXRucrDOpz0HRWWGw2bisNcZJgBXu3dIDCW6I9Wv4q8wNt1fmbQvoewWcF4rygsopLaLTU3Jf/qKti7im5TZ5cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(5660300002)(52116002)(7696005)(6916009)(66946007)(55016002)(66556008)(4326008)(66476007)(26005)(2906002)(8676002)(478600001)(36916002)(186003)(956004)(8936002)(83380400001)(54906003)(16526019)(316002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9B2X4Flxihi/RERHC6RC1468xKFhEV782CGYsitc+bvoOB/9CR0NarcEdPti?=
 =?us-ascii?Q?sqWGfZxBN/h5+O5Hvl0VNvPGMQ/3k/5uCnr0rs3l526cRDAvcCO63OwS0emV?=
 =?us-ascii?Q?trwAifxJEeoDjgJm9CdUOLtERhXHIzXcVKsI7Vi8nx1Vt9m/MPlbdUstFcuB?=
 =?us-ascii?Q?7ydGh94LoE7+wSmmwV5XzknMYN9SoupPVOMTR7V5m8pCauersMARmZlU9ALV?=
 =?us-ascii?Q?qXQTtPuE1kbKrPBoWnuJaTznS8KHKJu0ZYQ/POsGRFOuBUzp1VuQd6m6zO8k?=
 =?us-ascii?Q?rA6T1OP2uLgJ39nvIcxqc6ycQz7q1LkvajWu0kBsyZXmXY2hL1mE5RKWl6JF?=
 =?us-ascii?Q?8y52DjPNjL7Cr8QfiWY3hL+7+5eJ8MuWmAeG1ayu5l7Av2p2v0obDDqzn7lJ?=
 =?us-ascii?Q?5ymKT6Yh27bAxrUHcD/v+QSmL+Xk3OJIwfifAwiHHa0LSqa795jtGfxHcbO+?=
 =?us-ascii?Q?EjCValeHy1iOALuRtEPG+kW+Oo3v/uOT44Iu2KxiKUxvBuoZfAqq0SDG+MT6?=
 =?us-ascii?Q?dLh44+WwIIxuUqTAOSQEGk+zI3FKGXTtyagzbn7kECW3SI9otAE0Dad2F6wx?=
 =?us-ascii?Q?asbXWbZwLYtVar9quzCVY73AMFO1sRFisah7AvVWjYsnhkGuklpy67DAINlv?=
 =?us-ascii?Q?v1q4JlN1UEqHwYbejD8eSe0//PJhCBw4wggus4RBGVwbxTt3y/f+Q74W+SkZ?=
 =?us-ascii?Q?IYyIuyeT6VVczHyF619yRGg34iFZelJ+v32NoZCI9DACSTqft/gY0T/PhzCi?=
 =?us-ascii?Q?SbbRSF6U3VVEzFJh/eKZp/gEDbw7K9Ui6kHcviIcrKqDFbxLxtWNq97S2HDY?=
 =?us-ascii?Q?NLsTLfaJKzFFyIXScP+GJ3pPIIMHm2vs+HHBUtiyUHfhNYYtSYa5auJNMIrM?=
 =?us-ascii?Q?JOnLwSwdgexv5Pk35oXn4TgD4H3HLHTpi3gslRC2JlQHNSOIQUdGih3Jp26D?=
 =?us-ascii?Q?3Jpo0cnmTZLOAhzY/mCfg0KHFm8pE6AM1Y682YN0xAkVd3NmVBzH+IW0HlsU?=
 =?us-ascii?Q?KEd3Bn/tL3k3kPOdSGzEx0lc5vEr8C5ZbhDen/rl8Mz/16WeRh9N0BqQKeDZ?=
 =?us-ascii?Q?Cnus9+oklCRiWE8wn2GDX2CKfq9OP1godfppKPQRTaAKG/4Zl0+tSM7eDqjG?=
 =?us-ascii?Q?7wKqeu18YTTO2CzT1rsgWr/sru0cFBbRB0rNqezeUXbjxa8UZX13tKWp+gWA?=
 =?us-ascii?Q?Bm14G5jeRA3zoZv+jKTg+B8wlGMnXss9O+W0MqmRzp4Mmq5SQyTFQtZtYndn?=
 =?us-ascii?Q?3v5KFSEUZXJzqd9o5eJm1Vjx8S0ZMykhTMAmD37t9HQKd9lx+49pmnIsD/z1?=
 =?us-ascii?Q?614RsjXwhryeUvDzpwq73O6D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2119b9a-d676-45c8-8a0c-08d8d7ab5c90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:30:26.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHcLlMw4SlCjTKyXy5MqRu++xtcOzE1DyeOGR6d6zfxdutzCbKjrtJi8vvs5TyDt/DBfytA9hkQsJKiUwE9niWOQ3QcduQLEgNbs4Z+My2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=907 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Dan reported we're passing in GFP_NOIO to kvmalloc() which will then
> fallback to doing kmalloc() instead of an optional vmalloc() if the
> size exceeds kmalloc()s limits. This will break with drives that have
> zone numbers exceeding PAGE_SIZE/sizeof(u32).
>
> Instead of passing in GFP_NOIO, enter an implicit GFP_NOIO allocation
> scope.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
