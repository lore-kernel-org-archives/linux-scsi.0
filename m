Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ED2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D18BA6140A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhJEDa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:30:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15618 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJEDa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:30:27 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19527ptJ004475;
        Tue, 5 Oct 2021 03:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=diyma6Tx15VV7x01WqmXQypqAVpUxIPJyrujek09IKc=;
 b=CWig1HdBs4sgSzaS2Ds/2d0FBgFc6NebKBoxYf5nXwgFDlkaePdlAjWxAABNnXzJn8Na
 U1wkY1CgW1RD+kDHl1p0H0+kVhnYgFuJSqb4ga2mpeJJn9yKL+JoeF4frP0vlbzkAcqs
 GNv9QbrjSzdp8XQq152y7w4RJi+bRQsZHdf6unNTByHJny3s4IHPpf+FEPVAMHMCwykE
 8D03SDzJrcWnyezvLAwx/f9jiqvOFyF0eq6ZVOo4sJhOnHHV/TA5xq4lxtGIxpQV7h3Z
 PvHe3K0liDnzIP7IoPHSr/9iVh5gOuLWujCbYXJluOh+KD3+6S9arR/vKm9pvR4CuHfo Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43dv1gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:28:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1953Ptg6101660;
        Tue, 5 Oct 2021 03:28:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3030.oracle.com with ESMTP id 3bev7skmgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:28:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrhrzwBBNW+X5y1Aj/iqBhSJMO+/9rv0czmm90op11pZIv6s/CX2DT3vm9yzN9gdpAN0CqqlIpsWs4hYNfGewTzYkUP9P3pSOGHCW3FtVv5EvcAxEWn32KAYmHBrKqGcx5mfdYYKSHhpd1WIMByvxbXALHtE/aDuHn9AwII7o0Oh1rgTGQNe4UcYhjgrHS97pYaJ+U/KxQ+gLkmRes3muuErT1zR5sQgi8BXRWGwCMbBVIJaASHzbXCh1z0cS4AZsCuxaF44y3weRqEmZ49rWOb6myghhc1Nq+d6nOsD7VA+6Vr0oteO0+KrCn1rGmr+vq9GL+cqZgmerUrM5MwOGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diyma6Tx15VV7x01WqmXQypqAVpUxIPJyrujek09IKc=;
 b=Gjt3ZxNYOMYAqIqtKHHzPpmQm6tU6KKoaDVB+q9Ae1741Vtp6y4dob2ROspyu9Cf4gxoCYyI9cj4gIi+2is0aP18VUxa4tJO6Z3b9BUr4J2Xdx4yua8Y3lyTd5jc75gX/4da1yhUYTiL1E7uG7wcbcXCKrA6f7lI09JFSBC1/yAtusKCXJq9a6tEssAkNp2CPKV2qR7LM3z9AZYIdqYfjAEaS8XijBzN1TZcv8pisiYAlUMiZG7VPS8dbJv3c0ridTeZe35UjUDUiMJlOjprrxznL4g+dR80cAKPg+tuNVAiqwdek/1TC0lA4fcF9Ibx5r0WBMZ1EHIPcoCREJB39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diyma6Tx15VV7x01WqmXQypqAVpUxIPJyrujek09IKc=;
 b=rrz8OajYfeULIsclgYkjl476/4j90EIQDgjkK1nOiqUeCaEyADSSSfOS+R5VwNgqNU0dJt1YhvROdVJKQRpMAe4fYkpquT56T2cIC6Js7+zrAqyyojCT7qRxpS7e+5XLML2dD5nXJhjCLzZ86s/XJSy2cgDSrCDxCZq7OY6LNbc=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 03:28:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 03:28:25 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v5 0/7] target: make tpg/enable attribute
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2786th5.fsf@ca-mkp.ca.oracle.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
        <97486c27-3332-5af6-6d07-065e987fe320@oracle.com>
Date:   Mon, 04 Oct 2021 23:28:22 -0400
In-Reply-To: <97486c27-3332-5af6-6d07-065e987fe320@oracle.com> (Mike
        Christie's message of "Thu, 30 Sep 2021 15:46:46 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:806:f2::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by SN7PR04CA0030.namprd04.prod.outlook.com (2603:10b6:806:f2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 5 Oct 2021 03:28:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6823d78d-cfb1-43a1-a939-08d987b03092
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744A69F1D8150072C4B08D38EAF9@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuLx5HFYeWKuEFac6DLras7Tt86I9s2p9eBL9shiEdIP1ABKLSqzhwBTirERzV705g0vExy0cnzei9Fxlwh/GPrgylnrJkthsPT9IcBea9GDiDY9q5oyOkVlMZ6Uv4t3BADY0kH6U1H/GVxa1EdsfYFhwOcihIlgJsshI6DGPmVpH+u1xAMnk+mzdMVetR4GiKMSqchg6thyXFSxJCB8qkj46l+WIUGpaTPBBtUBCd80Fm2NirA0eWZPc46CMAjfyvU5dZZtFngxzC2YuCTcwCVytOAZU2Dp3CJJeAiGah6WGbdWYGp6Y9JYR3HKEOr4jvYCf+BuX5V3ZyutJ9x3iTE16Ha+Gj5kp+1nms67+K9gtlXcIcw0cHrVYcpehLMyfbGmZlE0JOYHqoQRrk1fBQJifChadITuuWY1rJy8kPq+mA2A3L6vKDPXQVT8QEptCClPWT2DQktOVMYK/lGA6WTE5lQT6cGWbZUwGnpnkH8dlKcVD+eZ4fYXM2dJYjUY6tzDRkV3I0nMBD07SvYWomOOGIu6URHvQHK6pzx6dpwz8F/8gWUN5ohNy17C40zSQRsVujm2Nuwg1/YeNNovqH9k0pfCS9f/8QqfudHzZlIAUWvo9+2La+SqOKD92pULcWP1F37BwpZujjxhpP5ov1SiG+Sjh6rhJlJsoJZsMofney+3gT0xn4hXpBj0g+T4gtSOjQ58PocXYV7IzM8tRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(956004)(4326008)(55016002)(6862004)(2906002)(4744005)(86362001)(8936002)(8676002)(7416002)(38350700002)(66946007)(508600001)(36916002)(52116002)(7696005)(6636002)(186003)(54906003)(26005)(5660300002)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JFOBVFUZN0sqp9i88VipshuSSsciB/kkZzwpet/LFiOjya5SS0MZdtcPaEEs?=
 =?us-ascii?Q?2+1OCXObhk3TMwHgqxlOBSPtx6PpgOUlcfEa+86hXWYXUDgD6vD22VkhX1rR?=
 =?us-ascii?Q?xeV0L1O8ByGcaZSxyE003O+ZYIwbdaW//3WTSpX9oMUrcfvTrc5sPrgwT+Gm?=
 =?us-ascii?Q?5VyHkeiikasfSigABUI6J0/yr+cLuaqWSbVeyA5ncmXUJtfQ1t29QKv2NBwV?=
 =?us-ascii?Q?cg8ow22Jx3YhRlyzrwOCX5P2RZ/Uk4XHdrgBzkifqcPNqFXd6yIMZJTzrDPP?=
 =?us-ascii?Q?sH4AmhWtGmqWahjBwVtlweQ+ugncx5EWh2G9YDEu7TkEs8PXywlmrippNlkK?=
 =?us-ascii?Q?zkWxChBvnY4kq94tEF2aFyEarEypcxtBS8QLzt2d1F//9tfhVY8aqVM2b8o1?=
 =?us-ascii?Q?QaBjz1u6W5O9rSaZJ5ie6QIQf0Y0IvexdpebwdEzynwC4NyxboEzG3ldQize?=
 =?us-ascii?Q?jAy1aI4lX794B8SDQWgDFPvIbKyeYWHiNU8jchnI2yA5/TkZHlwVF4+NHuXH?=
 =?us-ascii?Q?evUT2fv/BpdFKOYZEGs7Oxzka9XCE5pk9aTZEXZONZiW6v10KVKD6dGa5fIG?=
 =?us-ascii?Q?PJ+MZgBMzfiCWRJ+CAbKPdZA6VQC7J+NOKz6MGucflk7rMgfxOmarprh52MD?=
 =?us-ascii?Q?vjsVHbASEKAJMLF0OS6RT+Kn8/+Vey194NmQmZeU5Y3QZZIrQ4hTMbUqW5IQ?=
 =?us-ascii?Q?MbO9Juctf23OIYVAyOsxWV3CziZ+iiKeyWB46EPYl2vXqb27XuNh5SRT5dJ7?=
 =?us-ascii?Q?21xFr/+Bycq7ptP5qFpfqxcY8RwtTMhDy0Z3v0dWAeeiYY9mDntO3MkBTi+o?=
 =?us-ascii?Q?uCClcQudRp1oJJFFbR54UscpaKItmZGQtXS1udWxn7SIK4RvParGJli019Jj?=
 =?us-ascii?Q?YABybIoYTdHiExN3bzlbiSNUfNh6Z0Bt6RH31WWEY2pFNjRjxuR4yHfIZY0R?=
 =?us-ascii?Q?0sGchrwFoZCMoby9dkkfmcSY1fcCtURZHzIbibufMVWCTxekxsImQCoWu2eL?=
 =?us-ascii?Q?hyqR4gCOWTLF5hZoCLXBly9sgHzafSXDakiNlaYeR1SUhomIPo0RJTNfOwPx?=
 =?us-ascii?Q?+wbPxhnp6b8yybepKXQ9oEN6VMSCnCwpdACTiH4ID4SrkhqUFtrprRJmyAyp?=
 =?us-ascii?Q?/h3CecGpnvtpzO/7aoyyQ+k3pA2fXlz1ASEHx10lhnA7JBCG16b5bepWeyYi?=
 =?us-ascii?Q?enyhZhl24wkMzFvPxjSGFw3GTZIqQw+62okdTjVYHOmrfeOL3SVYLg7DiHqx?=
 =?us-ascii?Q?89gx26VTniW6mIOohAbt5VVd+Kw4IO79GACNLiLy8EHwv9HCQ8ye+33qCZDS?=
 =?us-ascii?Q?9RtIbLgWMsTvkcdgb9YPBSuj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6823d78d-cfb1-43a1-a939-08d987b03092
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 03:28:24.9682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioOoDS4egyj9VB0BMTGHzqKBZ53btfzaMrywbXw5lNYbebsx8kqhTom9tH4fPpzbdPBxvOEyvXfxWs7aagIKFMpTEcuAynWKnG0tZeyXGRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=813 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050018
X-Proofpoint-GUID: dK6NH6SdyJdNGSwDLYlLdNKtE-2K9fz8
X-Proofpoint-ORIG-GUID: dK6NH6SdyJdNGSwDLYlLdNKtE-2K9fz8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Many fabric modules provide their own implementation of enable
>> attribute in tpg.  The change set removes the code duplication and
>> automatically adds "enable" attribute for fabric modules that has an
>> implementation of fabric_enable_tpg() ops.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
