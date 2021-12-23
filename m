Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3810DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhLWEpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:45:34 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49194 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:45:34 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0bPmp026373;
        Thu, 23 Dec 2021 04:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zJbMcZqrV1PIdGmDSZLxPpnIW0ntaFy/JLGWeqDbEWk=;
 b=rC0wJjYD2mR/HFj3Ix2hnSnI0NSAC/FACKjDh8V6x9bSPPOn5wgkCJbEmCiGy/QZ5j/q
 gxwTV4i0ENCCi2PfTHCkga/vqdHdqp9TMzjxv8qrmyIz64pw0MBjDZJIm3jaXMvZajsz
 1PWPFFyM/W/dggYehs5ag9D7mr6LQssWo3s4faCl2/IxFsJqDBQjjtKjAEB44qbZ5/i8
 rpjKVk8ZfiRxBMD044KivKXRdB3j+Mu2Fp0lnpJWiSD0AJuOWQTSNkjtwsMKiYpFmrCa
 u0Ue0GVresSZuNZd+ud9jtQOQ2T69Wt+90JGPQMBI+07+EvPKTCmrzU0ZJWS31wsv3Fi jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4103a0q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4j5HL003545;
        Thu, 23 Dec 2021 04:45:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 3d14ryevq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTKZ9jlldZKi6pSYd59FE9v2DGHPOAjYVlNaFp8Ff5QIo9UKa+2utxuZfP8EaZE0inZwNqBD8Xx6pe3Xe3QTD+onUn3JSsuIArz48603ukJmNq9151Hxvx4q8lLBYT3nnCr0+oyGALgeiHglmNYWVUFDWTvP8dmTEbxOT8wC3O+bauMBBUb34uUgs3dEcwZ6x1/0TASBVJ79V0wc5w5wS8f2MTSLhSOV5QuMyhvt/7YdIpbOFnw0zH3sWh3H1bd4zx8x5Lgr5aDmSeUTlSXrM+XzwFBdj6SxZvng/IjG3l+kCSEeBrii8U8nb4iqxvPaY6n01TwnIEG+6i1rbYmNLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJbMcZqrV1PIdGmDSZLxPpnIW0ntaFy/JLGWeqDbEWk=;
 b=jW7FXr5AVDx6xO2ZEYafb3skGSlNJ/E+dfWWPm1G+lPRgB4s7npGYpXDLKM8SSC3FpvGgB5vnrmSLiJi4R1nCNdaoTH6fjOyCka7k2FtG9FBW6+GZZAh81Ady/Fa2Q9pm2P95FjoaeI7wQgyAXNv8p1SOoHZY/YpsmlGMwdJ6Yqb0/R3lYKD1jUEzgpjrozxYDz4HrJJq+038HNsulDuDkwxtkvcmy6iUTULytTz7G5e9HqYpmPkcvERP247iGQdNQOb9gNY54gpgZwAmeZZ4x00ayxKhudZlz5fC07CGLwEvJhkPh+fGjkxsN6vka17jwXgUBsEHxKSSaOYJn8hbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJbMcZqrV1PIdGmDSZLxPpnIW0ntaFy/JLGWeqDbEWk=;
 b=M2i4Ict4QUqAh3t7qXEALU0VsGjh981AGpZdOV1X3buq3wmf7j6VGIh8LvIBiuW5VHWRmP7BvGKGIgKWNjxKRVAGc1QfAm+8VUqnNxLQEmauXpLYjBxWdANw/R7pSqPl/790LIBuEEM6S4qWJe9MWoDySJ3TT0oGS/UNIWIW45Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Thu, 23 Dec
 2021 04:45:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:45:20 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ch: don't use GFP_DMA
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnjwgca1.fsf@ca-mkp.ca.oracle.com>
References: <20211222090311.916624-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:45:18 -0500
In-Reply-To: <20211222090311.916624-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:03:11 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0177.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 176a5a33-7d2a-408f-2b2d-08d9c5cf0619
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB46623E73B4DA699E648EB68E8E7E9@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXkyXqRiGAHwyjq7lACokFnQIE+K1swN1tyKyblwLym+Oxi/TxEeNR30H6OUTV+2rEoNXtwg9y7Ow5CaRb+SOBx6HFvFDjwn6pphDyn9fJMVWUlgi/gy4K44IZgj786cZZ4jpGs36ROB8jrjkNL5o/txjJmktbVWebUR5IYh1VMeYHHARjlSdzIq04uSoTS7achlsBGqL2teaLka/i0bo8bsxjTvFLgP5jbJpIlzUD2bTVuWrgRKwpo9bbyDdzesK+I9q319dU9VakbkZ/XjNOD//O08dg5JGEEy9L+DVlMShWGzo50Xk+5EWU1QD91eOF0odxtJQUvdPi7HQZVpsTwrBlXg8icCPGnv+pKvIUIq4z5ivlYsTwOQeVJ+E3/f4yX3whl4W3J4mepHqOj8WI55GmGCbpS3DkyfU2p5ysuazKK2Xsif/BoeOH279/+NLyM34cvn2mboeDbrmfIuEzfN5K72tnoPSv96I15bqJRrFN0MGEeTq+Y6q5coe74uRCcxn7OYYlKyXmKXPYE2yFgdzhnIvNHcF2Oku35Yy712FVtcZDiiSeUaoPZPNEWWWzPKHsykp/G5JYM8RxWtFzsq1zDsttt+sMYxndoUx4UNnCpExKs3TJuJEz50Lt34qrcDQEmQKfKj/1PdKdGMS0g/v4DTid747fgo/rdi55zxUiX+R5OWu0GyB4m9jsVp5lrtieJF9Gy9BwMtzNTvIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(52116002)(316002)(86362001)(38100700002)(2906002)(6512007)(83380400001)(66556008)(66476007)(38350700002)(6916009)(26005)(186003)(8676002)(4326008)(8936002)(5660300002)(6506007)(66946007)(508600001)(6486002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RR4nlTAo7r+qKrMCHrDfhzW8oohHrgCE1KbzyFnffa8RqyDXLcMvJt/2uu1J?=
 =?us-ascii?Q?dS2bT6qTEO41ZDbz2BK0i3j9KC6zEJKOCPCS57wLE6OAiReqGwf593ooTMn+?=
 =?us-ascii?Q?aRrhIAgqHYcveOMfvzNXrz9ATyWJo3eD8PEpMT4NIIBk5XGWv/KtyIfUn/12?=
 =?us-ascii?Q?pf86Q8MBguSF5PeA3HS3hJx5uQZSSE/RGGMlCVw7YqJ/CzR9wB/klo8Wqm3/?=
 =?us-ascii?Q?s0hH/KUqo/ZBoiH4hrkj/sBvxxX7iXAODysYv5hHhmVf6NyFV/utut8uWFoG?=
 =?us-ascii?Q?dksG6kHCe4rdltQ/eRIiRIem2JgSE0mtXN0kUSlJxK7S5vYDWAkZfbvlMbay?=
 =?us-ascii?Q?wof/bS7ws1UkM1Cn0JXrhuS9EK4BIQeLAilGdnzlJKkiBNDUvZ9ktyf5w4gT?=
 =?us-ascii?Q?syU07W5iUE25JOKZy/567pCg/s1LoKakKyuakYxfKilJ04tHNk2czGIH4ZVL?=
 =?us-ascii?Q?4NyojgutmNoWZ+vyX35BD+wvp8t4tI4rwXyIAbmCEScqDmpw5FrHnBylPUTt?=
 =?us-ascii?Q?Lmr5A9UNtzJ9UNfv2Pb/xzBg2z6R0wRLpk6Zu7NPB19gQL1v2UBO1rUDD1EK?=
 =?us-ascii?Q?5sEnFQ3qn1WYk5dElLizyFNctsH1K1g5Z6swsBS2A1jIcp+6JOBDEKwaHFDo?=
 =?us-ascii?Q?YnM2zB1vFG6ztug/5Iio16XdghZHKPHr+D7nlNWipz9kxcesto+OESA87bQh?=
 =?us-ascii?Q?UwS50XJcm2/rW3HLtyo7okGe+ZJyvSnpIu9jHOtKhooyu9e873o0OELAVuOh?=
 =?us-ascii?Q?2c73S3xGza9ANshTEDQbgxriOCyIEP60VnA2P8ARPZj/eAdhJmi+uBKcj0yS?=
 =?us-ascii?Q?9iQfK2oEvfdH5ZPdssrz3XVrZsVDrmr/nZGz0M9KEZWzoEnXzFaAPgM0h1RF?=
 =?us-ascii?Q?jLFqt2bMuACsi+VaVlaIcZF29XuyG2Bw/CQKwrxBGVziFTuVBNBgkL4kDZ9K?=
 =?us-ascii?Q?7rfbhl3OgAWGbhRnw9hiy5NOW4EPE77BCRpNrhbUjJAdarPK3NZMKsACr3ws?=
 =?us-ascii?Q?qeIzAGYzFQiJVfLyNk/TdQJ0oKJYROrxWTg1y1iDFBDL7UFAeWJaWg0pkHQd?=
 =?us-ascii?Q?OhZuwYJjCE3ERxZ1iEQstHwNSqMLciHT9l138vEHl6g0wJAst3r3+y/Py5xw?=
 =?us-ascii?Q?PmcNLJeLvA6J7vXezJLXfqQru1bdfnNfzLwUOdqw4ICbTFhNeD6vGlkuVS8o?=
 =?us-ascii?Q?LWcBAi/NnWIL/nKktHaghzfAwJRUrF96yMW43NAz2/QtUoQ7Pv9tIAutIwy/?=
 =?us-ascii?Q?OKqpFe7JBIElb1l5CzG/KNU4srLODEJS11zs88VadSdSE8rYCAjkOCIPSU5P?=
 =?us-ascii?Q?cj5IJNaiFaLUN3e5EwjXCvPkxfqZ/TxBuTW9MDJ0qdqEr90SsoNWTGHYi3L9?=
 =?us-ascii?Q?Dmo4jX7H93zxe0oKj4RaCcuceqPF7qEQtwvKHypabAskph74jA1U4LP6js3r?=
 =?us-ascii?Q?SKqnTjwOdsJ+RYv+X3N5tW6+VAdAjZvQA7mU7EXH8HlQCxPrq5EZHQf3zVn/?=
 =?us-ascii?Q?8VrwGTVnlukuiPR+CvwKA3l1D+Znu61NDVYN2aj0Otw3Vp/gJa/eURi7Ag2Y?=
 =?us-ascii?Q?u9IENI06gPsAMIOhcBHoBo6Vz5lTzbVEZmzquLxrED739CYYfso8sLROkDLo?=
 =?us-ascii?Q?7c24kN9LBccGPzGteLK0INvIhwxB3hzhJfKVZ4H4gIWWoBydR3j8WPNZEBAK?=
 =?us-ascii?Q?eXupSA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176a5a33-7d2a-408f-2b2d-08d9c5cf0619
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:45:20.1631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4j4cYO4GWthS0ejJbpZlRVE2Qf/B8siWRc41xAVPRBrrDlcxHvTtQjCQEBwsVyRGHcsg1bsj9G8sijiGYGW1tuNjYmlLokxpNw/f0ggiWvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=445 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112230025
X-Proofpoint-ORIG-GUID: sMpRHeaWnLa1wKq-7nQIh48d9k463lsQ
X-Proofpoint-GUID: sMpRHeaWnLa1wKq-7nQIh48d9k463lsQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The allocated buffers are used as a command payload, for which the
> block layer and/or DMA API do the proper bounce buffering if needed.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
