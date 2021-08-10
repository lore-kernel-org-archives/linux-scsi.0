Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E58AC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37D3601FF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhHJD5c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:57:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15546 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236555AbhHJD5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:57:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3uHHx021797;
        Tue, 10 Aug 2021 03:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1lYC/jiJn0UfIxVRZ8f6jOkrFcJsKsr4yNbJhda57bI=;
 b=Yl3lqexPOeW9Yqlz+3djlJysVuF2jd4jvtz21GU1NKUfs5jssbDmLNKVuB919xw87Goq
 HL7GhVW8KRE7Ursbo8L2zTVlLfFtIywXxriSEW656f9sk401IMpCMexA96JXMc/ljqq1
 ScPV5xMFHwBSW2AG0Evyw56gWGjY+RC250mwhtMs/gp7uKN+5uxRGRBqH+6ITruDqDUt
 73qQas3Eo4mSS8qjOB7IGAIPDl7oYM0E7NUCmguNvO6FQWbGOc03Aqd1Mi9bYoaYaqlc
 nA2E/mR4UnFKBuEaSw+S1F236NzFD64NriEcA+6Pss3zb+wuN09tf35Qx8IF2vpYYg0d pw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=1lYC/jiJn0UfIxVRZ8f6jOkrFcJsKsr4yNbJhda57bI=;
 b=mrmbPAMabUZztvBwZzbSHmXSoTVDOzlNI97gBldKR2PzyP675NOeMrT6MfxDdjWJ50ux
 /2XwpAih1EhCfVfM9NDamMfW/YsNqALGQHAlxYwRcR+PYsJqqQyZIkRM3/wUZBAqLNm6
 3sjcX7tINmGvaUpBQbVhob02Jr2+J+z4Ep4kzHRBA7kBv45ZzMyvc/PL0zkxKlegPRXf
 KVvuThna55xScqPwIWE7sWvzidFaErs71ZcPgG6c8DO1JFJlJAElPScg8nSky5J5wxU1
 13EKo9rslY5NuJd+J9KlRCeev/4vBn1tSXyKit/mdi91Ve4vNe1tG0YSdEo3V2H4x1xl Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaq8aauyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:56:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3u6PA184231;
        Tue, 10 Aug 2021 03:56:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 3a9f9w497d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:56:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djWsoLEuijPJu9BieVhsoislbRQAD88COknu86mUFYAzFr5g2cIvvmbgVQ3tKntg2lfJArUXVh77H/o2sZovr0XIRN8YODnX5xUAZM4irCCKgznROycMEir8SLXFCDIXpxMdFrZOtT5J6CgrA35lH/Q+euPNuJfHlMYQ5w98yGd7wIxUroFv96irDxj4to5Yiy51PC9NXq399yHAboffin+qEHEhyevzAYVPmsusbwRM7mxlKMwpOZNVAvbOugiklKi8qNTJBQ4cBZTXk0weVROJfRWL8ecdzGEJZVCdtmdsqTpVrynCayxmrRvVWMflUeZQ2NkveOyzqU6YS6I4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lYC/jiJn0UfIxVRZ8f6jOkrFcJsKsr4yNbJhda57bI=;
 b=G8Ru7N9g82Kn2Ww2uginig3BdL+Kv0q5tl2TZem7s1YJEeXtonVudBqZl8HmsiepYMTA6eSA657hCxvG02d4x+nf8jRYxQ9fwTUs8Iq7lbXT+acDlOYIGVpuZN4a6vxA8ZX6jNYTXdQ08wgnSKsoxY/eGXijAI0WOCZoY/xTQJxvnUNDLfxgwQKi3LojRM2xAgA8lb+so61MQoSV3cgTCe+tI5wZu/QPhZoPSq+ZPXoDDUojTRVD/UlSKX0qa9OsNCK8nTf83tdAkWiL9aR+OHwjJJq8E2OtI8VNVdGtjj/yLy4jrAVIv6ggp3c7TGi/dvA06iv5jb7ArVoQFJW5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lYC/jiJn0UfIxVRZ8f6jOkrFcJsKsr4yNbJhda57bI=;
 b=IpoIdO1t0pkqwuKf2n6UXn6XcpCmSAZdL22KNXsEb7qXh17mwES38B/CwYgzuUMrSkMBkaTi8UzoX8vUDFrv7iOk9Akrd3M3iv1LYxRpB+Veg6hdtbeI4rmdAY5j9FMCWv8Tsr1SmgS64ANE0LhSoR2boXM3ew761l1o+h1c43M=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 03:56:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:56:31 +0000
To:     Shai Malin <smalin@marvell.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <malin1024@gmail.com>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: Re: [PATCH v2] scsi: qedi: Add support for fastpath doorvell recovery
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf5auf53.fsf@ca-mkp.ca.oracle.com>
References: <20210804221412.5048-1-smalin@marvell.com>
Date:   Mon, 09 Aug 2021 23:56:28 -0400
In-Reply-To: <20210804221412.5048-1-smalin@marvell.com> (Shai Malin's message
        of "Thu, 5 Aug 2021 01:14:12 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0001.namprd18.prod.outlook.com
 (2603:10b6:806:f3::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR18CA0001.namprd18.prod.outlook.com (2603:10b6:806:f3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 03:56:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a3faead-0361-4ce7-6e6a-08d95bb2d6aa
X-MS-TrafficTypeDiagnostic: PH0PR10MB4808:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB48081A2E213C49CCFB79A2768EF79@PH0PR10MB4808.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tN4t29GJoXe7Ole7dedwEsZ48lvPDUHBiAZxgrzAd+Oy41+CHvDrupodc3IDaOcQ0VmeqUgFxm1cl22CTZXRKwpr6GD/Zl9onLqbYruFnGWKcmRWmDgFqbp1SP9uBw/564DXx/ifKlXt9kAr/SAE2xW9OQAApiP6VWDCO7sANfeVwoc87B6wq99F+gNtybSXygwOSib27zyEpAiKVy8whBj8h1y9/a7B6j+cVkTbURvV4sNd9KhZ7ZQ5TpLJbnJWWIk/FFOh8GQOriguEMowsrokR8U9PXhWApbIrgi/mowO1lP3Om8FVJPFCqV0vTyepmz6yAftfGYxWX9Ni1ujl8h+cPjnzGpDAxPvEAILM1u1I8CZpJRXfXKJP+ZYCYO0K2iJB7dcIppjmwnvDaOr4klcj8emtJQhhVa25r7eeau1nG8/49rXwPZ8fZ6m3XmOZ8M+J0Ylq+0nyApJ0GURU95XWviBNerRwYbpUYMMO2y8sqyGckNQEwEG9lWppUq3KgyY3AyylV3cy1W/sRRtsr29BYigra48/kklWTVgSQdsVcXYT2t54KY8dyBO3MXT02AStjnYTRzu72cRDku8N2pyYB5BST/PbBtfyzF42OJqjAq6ps8w6l+2OH6QP2WpwgQtI1NEbmSII8zzAv/prxYCmeIuGEOTEGIViARRv0O90vPNCkR3u16QuBSPQhJlZgZIMZz0XSyjEaX3xqzBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(396003)(136003)(38350700002)(66476007)(66556008)(66946007)(38100700002)(26005)(186003)(6916009)(7696005)(52116002)(8676002)(5660300002)(4326008)(55016002)(54906003)(478600001)(36916002)(316002)(8936002)(83380400001)(2906002)(4744005)(956004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0AMJpjCrJUnKayAzRL0lj6NlB8NHXU1JeN/N7K0/VBgLSu+GIGyZisYhUUTW?=
 =?us-ascii?Q?tcA9Ek6oXqZw8H28f5X51DAHvdjVrPr4a0j8wOkdcbcauf1j0UCDbmkzYWNf?=
 =?us-ascii?Q?N1Rv5tvu8Y7ky0RUwrlX80AAhe8UIFWo+1l8+MslgSv3WBeZaM5j9lEAVb8q?=
 =?us-ascii?Q?6xBbvoXxfYP4qvemPu1zzDtar+5r1V4gKP5d5Pk0FO6GS882VYKfXT36wEZw?=
 =?us-ascii?Q?sEUXLlG9a9Eogq1QGEnu/Lmq/KGhK+jLMZ4zG6WadZew086WGiePVeD8AXrM?=
 =?us-ascii?Q?rMfS3vmu4h1vzwvLUR9Bq/u1CWEH2Tjmb+6RU1Nv4r2DaLMJCthYTw25c0Uf?=
 =?us-ascii?Q?v82UENZ61/neQ2ovT6KCuF7ef4kdscx45QnETmVnk/lKhDVxNduMNtkBME+u?=
 =?us-ascii?Q?zXzGwUrbxg7BycLx6WSxhLLYBErwv1maedjZ7uYNahNtLR4UNkea8yuptmm7?=
 =?us-ascii?Q?7uiy3XkVVIvo8/d3JplDdyFOVHPuhXoTrPvZNPH1U3rT9f9HaIs2xS8TC/4A?=
 =?us-ascii?Q?Xix7H/lGW7AwW8BNWgGoLc8dWKrUoxOZEHswBxC2xNbCuk6q2OqYdXQm2gAG?=
 =?us-ascii?Q?eE3RwcpxX1KES+vl3c/FxLP4QHOPzuNY+Eh5GF7Z9UKzAW401QKIBzkqMcEO?=
 =?us-ascii?Q?rzp4BZPXJBUUeTZtkWGeCEMVeNlaoVDIoQNndrW9wa23a/OI+sIEbVzfwOqE?=
 =?us-ascii?Q?WNyEIKwJ9CozvJOmblp9OUqp2Qw6UMKG0Sdx4MjcxfS35apR86wqlMpJsWsu?=
 =?us-ascii?Q?P2GMybUhI4ar+8vJ9fPkOqH//9lrUXmt4z+Z+6TgvOd+D0NxKw3K32KEPHWs?=
 =?us-ascii?Q?6vfrYx4ZLQFYh8l//NFQNxT+UWUWR62Bn1vakdtaWOQnN5g5c7IcDnZFZM6K?=
 =?us-ascii?Q?lUO3gBytia9xU2sgMxKMEf8gt3mPPOgm7j0igtuWA/sYp4E1mpkn1HVE5Wg0?=
 =?us-ascii?Q?7kFvzID3lrRGY4kiYEKpB/pkePFhF/WceoSu7Pkxws6vjjfHVvgRxrSIheP4?=
 =?us-ascii?Q?bRPqb5kJb0WBUqC1nNY5osmhreNNME9867U7HjF12YES81TnoiqL25JrfHLV?=
 =?us-ascii?Q?0M7a+KMj2XSGYdzDo/2z9nBCUw5Vu8MKQwaodD3TIzHDVJsTxdHbp3706QPR?=
 =?us-ascii?Q?vjk97cpv5pLJrQSwbKpmheA6q3JgQtJ/2KNZqtSXB/Bg6CtkgyaqUxWNtZQ3?=
 =?us-ascii?Q?R0ywbeDPqG/N1+78g1H0NIcjNKCzbycsCWwNZ3vxnqgoiy/jidQEOn8bsPwM?=
 =?us-ascii?Q?V3QdOArGRlsiSttx4NrOzONmW8/Idsk2xg8UjjRxfSX0+fRl2OqJfkP7BwVZ?=
 =?us-ascii?Q?s3oXw4rmVMa0u2ONdf2pHNlV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3faead-0361-4ce7-6e6a-08d95bb2d6aa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:56:31.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cL8cGmrEhYRtyOrypEFokZhCCSLkoChDLXLWn6Ct73H5M578E5Qpm4JY8mfT3Hfp5EHny/dJgJR64SFHEMuRWx2rfz6WC1khdeVQ7YsPplw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=925
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100024
X-Proofpoint-ORIG-GUID: s95ibUJmGjK7GLsRb7k5xpikCe8zzGKk
X-Proofpoint-GUID: s95ibUJmGjK7GLsRb7k5xpikCe8zzGKk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Shai,

> Driver fastpath employs doorbells to indicate to the device that work
> is available. Each doorbell translates to a message sent to the device
> over the pci. These messages are queued by the doorbell queue HW
> block, and handled by the HW.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
