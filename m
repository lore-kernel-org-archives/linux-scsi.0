Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D26C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD5961166
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhDPCVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:21:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60178 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbhDPCVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:21:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2KnWp121652;
        Fri, 16 Apr 2021 02:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=quOJVvr4h5M8pmXdqvjQiXPnFFr7JK9R62oCDcacufY=;
 b=CYeVUH5zfuEvp0DwpazWD9gDlqYNyuEvew50TxitKkamSJWZKVlP0xu+Mu5IzkZTw1Mp
 W6nweIIw/E2/q4Em/+Q7+yfmYr3vNuxjwtR95VNiMHP/yiTOo87LX/K+SLrmmjZc/0yQ
 Cq4sHCZLjbeb4Vov2wgZlMDmlym1fapdY7x5cZTJosF9H5o+dnOFwOWUpu+qAR0dDM8n
 mVPex3hqnubczpMb/IEq/s+IhqHhmIf9ZxK1/s4gjUvb8zGCGdOseFK6QagDTkkKi3+v
 w9Ef8pYimsZWAxrkL2w8qnNeQja+nsn3e2MUHG4SWrpTqyr5AjP6JM22oL5BSoCJmfR+ QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37u3erqq3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:21:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2FnmK065475;
        Fri, 16 Apr 2021 02:21:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 37unx3t4w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoRuFnw6PeTMWuVziwJK5IxryJghzr3GyqMb9Py39N1CqZ2QtKSw/nHFGue4E2ocTICEfY5t5xcXbA9pEMyWQznsSqphlOeYf9PAiKAALrpBuZbImo9K417qxsdHKctj5lgWT2UVLE47NpzM136NKvgP9ZaAkBc5yEaB7fDKZN3Lmm4kAf6mO0BTLy11PwtuEu0z6oVgrsyhUpe2Ycnaxc9soW1cpf4XBVnsUNb7lxcSh0d+hqhwsXHstDEjJ5SpkuwtQMxrWoeoY3YVF9mztn8w0hnXimF3gCDxue9J3yhQdE78tohBEXz1/zAiyA78bfVTSARZ3B3sDe6JCUydWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quOJVvr4h5M8pmXdqvjQiXPnFFr7JK9R62oCDcacufY=;
 b=Fj3951BdKBIPiG0MGUktAZ3YfM1IGi7Xy23lxMpO/+13jqLrYe22ncDtbUdju5eAZK2pmmxDr/reTBVzMA7Y4kY3BIAafcjwbtjOEv6ksEjjjn4IGzb415Nb5WDSnveRY7SKt0KpihSu1tC4L1NqHAHLPxFq3YXHEUjzil/Fk3NOGD2VGRPojqQ4xmEsN9y5hXuSQXBnZo1+MYHXQ04wl2tAHyy/o6UWiwwLAPNqWO3VuocCY/R7VxSsFOezzg6Y4owQwVEvkvKa3vhIZqOSdqh2rHvcXNQRPhNAjthxiH1I6Ec17Dl2igv1LtC9wlRWx/sDcZQAUNlOodRi063Frg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quOJVvr4h5M8pmXdqvjQiXPnFFr7JK9R62oCDcacufY=;
 b=QkDWPFiA6g+oMuIsqXEhZZOcg4KmNe6SPYrkcVOLAHznvXL0Uyz6Red5+Lp4A72244Kv0/b8iBc9gUxQgdPMyhgCJMraetOr75aaXO2y3LPdeUpd7ILNqzXBeHaYvcs9obbG9G4OA2+Dsb62FcU1OcZ69C1nqBl4rCNN77n5gEg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:20:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:20:58 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Yevhen Viktorov <yevhen.viktorov@virginmedia.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/6] zfcp: cleanups and qdio code refactor for 5.13/5.14
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v98nynqw.fsf@ca-mkp.ca.oracle.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
Date:   Thu, 15 Apr 2021 22:20:55 -0400
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com> (Benjamin Block's
        message of "Wed, 14 Apr 2021 19:07:58 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0041.namprd03.prod.outlook.com (2603:10b6:a03:33e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend Transport; Fri, 16 Apr 2021 02:20:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 521b48ba-a431-41ae-7ece-08d9007e4555
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB463148B553971683F7CE05878E4C9@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBFWor+ylu9u4hW/aqTik1N9/O4tAp1fznh+5Usjsub6VegsYrSZs5Oq8To3NPAeaIFyl4zP4FH5LbDPUmkj6mOF5gdk08rcktUJCPCR52L2FSQ+5BTOewWwN2X82w7pH5OOYzaZtmZB3BjpWMzrTKDUq5PFz/Ku5j7BBrW4u2lz+uuRCJD/va2YK8vF0cJw10q4s8vQKOQaiBcDKpDJSjq0qLrxyZGLU+gBJ2trOBp6BbHnN02ga3yX/jvD+tgFyNEYMkft2gpr89GZNklFI4+NPijUq2mI+7PJvHE55UJDe8W4rwFdSqJUZjPhOJWqzBsh7FPHUhFrKQIZD4KV7DUFRkjUTRC8aOmlj6Ir6N2tCbcqE4yU+Wrpshix3G2kqDJ92X7XR4rc6U0cABhOaTULNfYsDUh1F0RolaHvKshGQ1p3JfUhZrnpKHyfHE6f/yWgn7iZBrEfsHtZvxMpW2SoeTxHWwu8QRoIhCWX8Oj5taecxHd5pNyKk/lybx0bmeEFLlS8hoc+83QDqxKldlSj0Qk3Go2Nol7ja/TTnS6H8fC71oZh946BthwMp0DrIjV7uJasyPytwIaQ79y2lCZHWdqq/+h/A9AIARnKNQ1KgkPaOQUx954PwU/GZgcr2dbWcB8/229nZYnO2gyNgu38cw0YHjxnB1GdwTZWgIM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(26005)(6916009)(55016002)(8676002)(66946007)(186003)(8936002)(16526019)(7696005)(508600001)(4744005)(38100700002)(66556008)(52116002)(38350700002)(66476007)(54906003)(956004)(316002)(4326008)(2906002)(7416002)(86362001)(5660300002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yzOcQbVB78zbGX1nQT9InaGZ0OGk1BjEE60yMxLwm9ospRhg06aKWc39Nyd/?=
 =?us-ascii?Q?dxxaNwM7/Orm4bRu8d/XOHmeHL2D/YWIAiJ+wUD1FVYRL/HBs3V/kZtbMmHM?=
 =?us-ascii?Q?9eK+jn1lsZVSWopzT2sf9gjMaKGefk1e46Bo9r4ubF/c1UU2XVPltqqITlu7?=
 =?us-ascii?Q?Ed8zdtN9PIHlz5cVpdUDOUFIAihp0+GGJLwzDsDxCfsxczd3RtKFr0hpseOu?=
 =?us-ascii?Q?nCexWBYt1m1mPFfXOy6K2wlzp8AaF/soPFfQ0YKHFOsxnqHFBwPWuyaGP3Jw?=
 =?us-ascii?Q?Mceecv6LB6MZhdotevRakIo+YG3gjKUck8rvcRiBLplvyCZ7yqnDFeuQf4je?=
 =?us-ascii?Q?xmrhr3FSeyF79igNVRuREYL/bPT+ASeQCbDics01IrUXt90WY5WkDivXPcRj?=
 =?us-ascii?Q?pkqNK/uTYCO45UpWgeudV7HILM/iT829a8ON9VMF08n+e9HkoO58/pqUGQU0?=
 =?us-ascii?Q?xWrVuCGKxFdrCO0WiSxO87Z+JBCmT0NaR/SObfafRJ525wNkxCVD0VjknTGA?=
 =?us-ascii?Q?dYrT6n1onPJREUwk4GIE/Q9hJXL9nVC9Fx+gv84vnyB9pbLs37ltPXtTPBWu?=
 =?us-ascii?Q?R9DgFcFsIS6tDNCs8cRIT3GE5P98Jx6mFvPP/MTU7Znn3JfIkiYtwC7EzOVu?=
 =?us-ascii?Q?Cs4iFekG3BknwABeZ7euGF7//x++K9P/V9+p4ffrFAo6/E+oqliK/kAjqG0h?=
 =?us-ascii?Q?ecwcbu4JgXDv2LTnsEjU0Tqt8kBptlLirq6ABTyU4+bG5e8XFBaI8yQ645U3?=
 =?us-ascii?Q?ylSDNld9pzgy1shUXNNhUXOLKqHruS57l26kIUu35p/Ik1ZSvUvl3oJS5YWQ?=
 =?us-ascii?Q?u0j28ctgSVknzfY/noJayuh/7+R2kVZ5+5eTOiE1GbpQL1YfZy1YXB5n7vyp?=
 =?us-ascii?Q?XPr9FutvW+AD8cAB+m2M/gHii1pU/ebSxWnZSWUfHLFIopvXQR9Qj8ik6QAc?=
 =?us-ascii?Q?ahp0d8SO5IpDL0HfLw9a6yKDLPfz6GJHpDoIK35EGjFxKn1HeVOfPRUhkJ/X?=
 =?us-ascii?Q?3vrPQY3hTdRdaqgyUaDKVACAWXdEp95o0dr0/br5ZZ8LD5TlQMi6ReqSH9BF?=
 =?us-ascii?Q?oXpLYvZEUeGAoiXRQ8eceQLBp3K0tZYRWftx1dGewowG0oWAfxEY3cs1E49E?=
 =?us-ascii?Q?+g2LMorQoD9J4+6edH1qebQjrAEKpL1C7ccvzb1RRzalYhMKaEZyVITPJaK8?=
 =?us-ascii?Q?btAlxjwbwkpDZEGet9YSWEGenUnBXhmgR6rnmR47ZxNZz8aMvlso2FqV6j2o?=
 =?us-ascii?Q?R+p/YLA+KE8ALrAjqc6Nc04zR2cqMk91gP6SNafRxTE7spy7TqEubAdKVMyh?=
 =?us-ascii?Q?OYj///xrxBPTU4CyMY4Vv/qu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521b48ba-a431-41ae-7ece-08d9007e4555
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:20:57.9701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0cqnW6C9S82tboe0+ueFlThoGUVRGeeqAJ5IaI2S2PcQacaFMeN1ODK7DBTsj3TpoTwZF5HAG/exnKNMByUUZ5Qkd/T6F+WwYObR6unQBvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160017
X-Proofpoint-ORIG-GUID: q1NbU66afEHOeVLMecWv3ZP5sCkJ0lTJ
X-Proofpoint-GUID: q1NbU66afEHOeVLMecWv3ZP5sCkJ0lTJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> I know I am pretty late; we have some patches queued that I didn't
> come around posting yet; its nothing world-changing, so if you don't
> want to pull them for 5.13 anymore, no worries.

Applied to 5.13/scsi-staging, thanks! We'll see whether we get an -rc8
or not.

-- 
Martin K. Petersen	Oracle Linux Engineering
