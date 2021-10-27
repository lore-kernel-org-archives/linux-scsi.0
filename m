Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47819C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 16:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFDA60FBF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 16:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhJ0QTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:19:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50352 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhJ0QS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 12:18:59 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFxaLD023707;
        Wed, 27 Oct 2021 16:16:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1g+YjzXdAbJscfH6z6oEqCtVgOwxgkcyCps5fkPIr3M=;
 b=f0M9OgMwTsfd0Gc6yLyocHwRR3kz0qtccrI8T09XbuwPbBtDa+qTRLtOY/cprQZsa0Id
 Qs++S/m15RFHwqYHLeVbPcHHaCl0KKXq7IU1c4dxVvyqBnHBc0Zk2BVGDJcVULJFY74y
 a+SMt6ySVhbDm56uCBF2+vjLfclTLG7sp8EuJ+2IBKlKekBOaWn4i9knucbbWRObbhn0
 UCxiRwA/ozDxy8gvIRLHAh9dwWF9VhRu/iN9NawUm2QCCv0GgZNuB5TPkUDa532JoX+7
 oR5T9zDY+9Ms6JzaH23N9nEvSp1lDqVoyy9FFeAgOl3qDI1Ca6MgOb/Ato3rlbPHujPJ SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj4qy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 16:16:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RGC3om054391;
        Wed, 27 Oct 2021 16:16:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 3bx4h2m95s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 16:16:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/sQ2phR/wEY9P7rnt1ErNi6b99Eg5HA8UwUg1axzdCpCDTmdup4v5EfIFYlEbbXa+WZCmHfF7lGL/Ib2Qu7Wa7Z89kyxNKHkq8G213B5pQn9YJrKoy5N+ghFY8WSABKl56ZQzD+YItAzStiGkaBrllLr/FAFA0KYEzPm/vR/28TKhNbAzZEs/pb+aXTtwp9KdXe4ZCN1ex1Axm4Rw4AQ+2C8EBD2iEhxVuSBPu8KG/0JojjDiWCGIq7VbMjwjYg+Riv59epXKNzi0w5ReL2eJn6bCCJCYkrfetAAJpW9tRIC1vtd5HJ4uZvWkgOvoTCUmazkuz+9lFOfU7tS2STVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1g+YjzXdAbJscfH6z6oEqCtVgOwxgkcyCps5fkPIr3M=;
 b=V6uvroHkkqmF9SPJPbrGtY6Uip44JnDIbOUpZsmNtqxNAndk5s7kDdjbWPv71UBTwGtM+g30xLOF4ohNWympm+JUUrxJglkRaLTGehS/Mc54Bm+iBkRtlrnYuQ2go/0e6V5PEG3j2c/SjCi9sMQD8ZIghtCAzZ02xX9XWY3POZ3PV4DtmMlGqnxasmkhS9v1JHbglbxZAde/Q1Thri9qrNqx75wrwuYaCad0qmStLLuDZQQcqqpiI74j8Z6WJiPyYwAijOhGuBIsFRIQk0YiXBd8vprYvp1BAPpgNo7gZxJ/f3yXh/sYDNpKkDyxXdMd6LNA65Y5VC0YQKZKfuI0Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1g+YjzXdAbJscfH6z6oEqCtVgOwxgkcyCps5fkPIr3M=;
 b=jDrk8uP4EdDs4vwnODJ0onQXytqvSK+j9J4Q/zvJRq78Cr6Rx3d9bomO3/N1YJWmiKFQslW1W7I5Y6YGIUOyyrFyTJLwd1RZpcM+6Ww6vaKYzffIHKy4kmtLGEpDJwyhnz1M5nm7HNJiTOf+dNkeDKnBhSgnQ6kknEu0D/vNTQY=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4485.namprd10.prod.outlook.com (2603:10b6:510:41::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 27 Oct
 2021 16:16:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 16:16:09 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1c6zd4f.fsf@ca-mkp.ca.oracle.com>
References: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
        <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
        <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
        <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
        <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
        <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211027052724.GA8946@lst.de>
        <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
        <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
        <YXlqSRLHuIFiMLY7@T590>
        <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
        <yq135om1p3i.fsf@ca-mkp.ca.oracle.com>
        <bbab4d8f-67c0-83bb-a979-cb9f9ac28af5@kernel.dk>
Date:   Wed, 27 Oct 2021 12:16:07 -0400
In-Reply-To: <bbab4d8f-67c0-83bb-a979-cb9f9ac28af5@kernel.dk> (Jens Axboe's
        message of "Wed, 27 Oct 2021 09:40:42 -0600")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:32b::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by BLAPR03CA0006.namprd03.prod.outlook.com (2603:10b6:208:32b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:16:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f047db0-a1f5-405c-ba7a-08d999651644
X-MS-TrafficTypeDiagnostic: PH0PR10MB4485:
X-Microsoft-Antispam-PRVS: <PH0PR10MB448568A181B6FB61C1720A828E859@PH0PR10MB4485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KoBPjvAl4PdnrdbNJovOoYR0IrbjVdbMhUQ/IBpWlnPnB5wX0pq6pl4ku2V64gLp7GGQjZ830beSnAvNsPTCnrYdnaTJG2raSHkiDQkrv22a1ihg0H1QP7/oqCD7i51TpcM56zUXgT54uO7soFmzGEdJ4//wyNCP9CnuvkTJI8AQAcK+f/Ej5X4GkWyxgrVTL5cgumio5GTd9qcEXdQkxOPjA5f66pQHy56cqzY0qVzaspJmyfZVeHVR2d2xT0Q+hfSX92bQfErue9X8tdDbmBaJPaTXei4iYr0Y8xtXUoEqVCFfCaeIFtZuzVhYMHHKZMfU2NuogY0XY3EFC83WsX2F4YF07RAw6HIhxZO2AMWykPbf+0M/7LFTM/J+XhHEME6HnB3vd2pZYiP6kFruSi4Vbmh7JB+I+V8JPCCiBviwR4BJN1bCoiPN9G3ZwGh4fAueouGavkAhXbr/fsEnItjY4GwaD8hyEMPszgEJoR10VZh7SyBe9IRmG0VIEyXlS3vhF6c9QZbDrj5h68IX4XuyFdfv8R7vfQc+Cz1vtxLRaeAhO+MzGpXSYLnNRlgdDNQzjwz83VrCOl/htOOLXLY3hjULzKKIty/uvz9FLJbUg6U68QtfjrqJz3UQAZKE+61A0psyx5r3i9C04RCMEe7PYotlv+hBo7HpSbnyanmArDASph7xFCBQfKR/8IzorQdfORh+LiYvNN1XdVq9jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(36916002)(6916009)(4744005)(26005)(8936002)(38100700002)(86362001)(956004)(316002)(7696005)(4326008)(55016002)(66946007)(66476007)(5660300002)(8676002)(52116002)(7416002)(54906003)(508600001)(186003)(38350700002)(2906002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/YKLn3qAbUK2AoW8jHuaK4xrZC9fi04Qy5BE84ziDdC3kSd4kOMSit3gC0Rt?=
 =?us-ascii?Q?ag993F1tpYGgheI2xOVciv6XpX99W763uJchRRl5WYwd/gVoS8Ka2/W77ZWV?=
 =?us-ascii?Q?Nffxo7a4QvIGbdfEQIFdVALTUyRogNcd1XbFm9F2lvejQ0hV/wTMEqpAx6fH?=
 =?us-ascii?Q?+avmsBZ6fMaeBsmc7xbwPwXPNwB3wpUVUqpCp29a4JFr2mpeRTBxxSMs9flP?=
 =?us-ascii?Q?gSGFs7nHHCN5pMmWSykIYkXWCA/ZdaOY5ELXPMCbq1A7bfjI0JJ7tvS/TJ/r?=
 =?us-ascii?Q?g3g0e42+T22LifZFQavJobv9RN3IReK8bVT9eVlYHgPP0Wm6K/G31eazurwk?=
 =?us-ascii?Q?ZkekOtvIJAiVIN4n/Q86qjvuTwJ2LqknjLPpbbfG3czphhauGxLk+iXAIhuD?=
 =?us-ascii?Q?G7cKpEYnzsDtWQF0f6tYYVcLT0a9SiDngaRFlPUgJePzvGtOLH2JpCysDiUZ?=
 =?us-ascii?Q?y+tbzk9w9BIYBwlUi8Y0N6aNsJn1NCssaxpnret727OrUjNrKVK/lxezPWou?=
 =?us-ascii?Q?HqYZQO2H9WE5Rl6G2TnfS63ZcVGreGFbqDth7P2ATZEws8LyDnqVvplmOW06?=
 =?us-ascii?Q?eoo27Y+YdW7EBcIqvwLHChqT8ZRpqL+nuMxwLSL6As5tL7xHDwx06oeQ5mk1?=
 =?us-ascii?Q?t/KvXp9z05NxJFl4B6EOswqlp16YKMOmRX67vT4IKQjw9YGInHAYrLBcR25O?=
 =?us-ascii?Q?cBoNuYxZ/lXrhwWFGDPSjC0KN5evq2LLjuFz+KoFZ68M1EtI7KtfthRS4TwW?=
 =?us-ascii?Q?sQpCCdTk7E0dbCV+pI373WKpJjzfZfDa5VpI6m68MI+ZaBqrZccJSzlK0fDf?=
 =?us-ascii?Q?xeVt+4OMbmqkqQcxjaz8XyrNALGDO/2hBZQPIPe3jl39iUwzFxFMlrvEqWvo?=
 =?us-ascii?Q?j2OTCUl6+6jxoxDvgMY9uHAFFlzWw3kXGB3i2C9XFDNiTXJqhX9ho8A1a1+x?=
 =?us-ascii?Q?KGYzTdTRwDcKXgAm8aC/LDZrvDfjxzMl4V5t9tnIaj0JdPtlnwAeWDYNRQ6q?=
 =?us-ascii?Q?qgiEVmcawO9gn5Ub5VrXcGqROn/oc/IRKC7bn6mQc0TzTo0PV5MkfOb7aGLn?=
 =?us-ascii?Q?aka95cgEFuuz2fs1/xy1EEVlpuwzBDYe/qt0+e4wk0bi4kMcjkCZpLQGjsvM?=
 =?us-ascii?Q?A10PvfiWhBrtc9vTKgW929fSUX55ImUERY69VfLqkdvLvDscxR9vsZ1xAo9U?=
 =?us-ascii?Q?PvXDM04hLKolWzxeDuIvUbIR4mrHFredJ5beW8/znyvDDUI7yUMlj7s4t2Rc?=
 =?us-ascii?Q?JNgdVtHYt5RmBILPskr5yLDzVZ3ldPiU7vCXbAMwWkHQgrXznT1EDPlBKDZ4?=
 =?us-ascii?Q?2KZuIi1xJT1b/G+D0xHCbfnCkWXiu/TJgwX6zceYSEWDpfE+UWzq8d1tOUID?=
 =?us-ascii?Q?Sc62awpMrrvlz+8Qp4Ljl/W9eQHwyIPKw3i+ALU5XZGWrc5q46WuUMCuXCNZ?=
 =?us-ascii?Q?RoTsloYgYF1yGoNkLdEO5fRtCPyyFgf6EVkgis9VV72eHGlBHuNS/n/uhE+i?=
 =?us-ascii?Q?1DfD6y+rB+XbSu2X1H1V9tyx+LE3ENY8I8U26kTuv1ZNXlXiYdpALL9AM+Ts?=
 =?us-ascii?Q?0TPenUn4nDRNrJIlm8BqT5Kxu++VLY/QIhLdghDSBT3lQ4yTNjTh9HgS+N5h?=
 =?us-ascii?Q?SZodTZlqWFWHdRZnXYqU5KSazDbyQVujRxlaosQi4vOswP0ln4gpGLDRfVlT?=
 =?us-ascii?Q?skgbPiyEQEuuhQoqmIuAuzy0hHo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f047db0-a1f5-405c-ba7a-08d999651644
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:16:09.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQbY9uKu7YI0U1welHXoG+AJQBNrG8qGtyq07b9DhcyBVdx4eiKPPY1C8eRu8jGv/AZCmB+nn3jutao9aKqi/eoG0uPj7VneMnj+KTVO8b0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4485
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270095
X-Proofpoint-ORIG-GUID: yIY5Ik8d7Vz7H7pXbwL3OHvbu9lGvMSA
X-Proofpoint-GUID: yIY5Ik8d7Vz7H7pXbwL3OHvbu9lGvMSA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jens,

> It'd be feasible to have less reserved tags, you only need as many as
> you want to have these special commands inflight.  Post that,
> returning BUSY and just retrying when a request completes should be
> fine. Hence I'd size the reserved tag pool appropriately depending on
> what kind of performance is expected out of this, with just 1 reserved
> tag being enough to give us the guarantees we need for forward
> progress.

Yep. Since this is labeled as a performance feature I do think it's
important to find the right balance between reserved and real tags.

> I think the plan forward is clear here then:
>
> 1) Revert the optimization that requires the use of cloned insert for
>    5.15.

Given that HPB developed over time, I am not sure how simple a revert
would be. And we only have a couple of days left before release. I
really want the smallest patch possible that either removes or disables
the 2.0 support.

-- 
Martin K. Petersen	Oracle Linux Engineering
