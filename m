Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B32C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 628826135A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFWCHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:07:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31728 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWCHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 22:07:52 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N21VlD015151;
        Wed, 23 Jun 2021 02:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kMgtPb3gSzVxHCCX7iCvRBPVX3KdU5+40JXQC2Ttpgg=;
 b=ULiu4JTD+648OSXV4MJRwyHZZuu7ezVuBjA+EG+/pTomQcM/lpv2+aOj/Wg6hGS2Y1FR
 uwFldhv5Q+S1jYAyy6qT8f7KIhPW/6mGpBMGOK4g70sRZDC68mFaZdnm4N4eo+Ollu6S
 1MCiDfdHeaEzbmloI07IOlNvuPIwhwKpQAMcdzv8OMCZOARGY8VOi++LKlYgvlSDT860
 skY1u4+xK5M+yH4WiOrqpkO7vm0Lhn9JACYzbXkN+BzDS+34dPoecGpgHioO7728+63X
 +0Ic/piIYTnDm24cd4WJSe6BRZeBExIhmJDgT2fkBfQQf/xRRyNVXtJ9B3luUmqlcC2d 2A== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39as86vb1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:05:32 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15N21TRT187095;
        Wed, 23 Jun 2021 02:05:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 3998d8dexm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:05:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0/Hz6P548syJcubywQh9G2DnE8KkvB+tV4soDJmStdI+xNWKHsPthRtwnIqysxrQhw0tp595/JsARxYojPLiIktQwkuwvTZxxk1sQVI6G7x8W5DrEMEGj72eA08X5yCGNrDHoVRpykugNJIYys/S9B7VCtOIeCSPHyjEAPqRbaeP20izaxmbyiFsWPbtDRp4q/Av6PZb1z/R9qValHnleXXJ7AHfF+33obQZXjhMyqofeuBi8zZaZpLgyE0bHDccAJ/RoEIpxcFldbIHkcKzprwCTIuoRrX81Z4OXtQV5Z2X+8q58G3TBXb0q2P+Ms2RLF8/Q/CDNJl5gbNNoOzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMgtPb3gSzVxHCCX7iCvRBPVX3KdU5+40JXQC2Ttpgg=;
 b=AfEnu08OeoGH3W0nYrt8qKWlqPfwPb1C9Wm3ymKW9Y7YE6yLEyMUfWIlcRnj1/fD96il5TsBJDMp0u5yrBIvC/2jTkXHDTycqyrGJLKu61LCzKUJn27nVm+pra/X5sgmsci27dozr7Com0y/aBizjcyuT1gMBl/KpWDIAw2sZ3iRFzpaG1xZrgeOVcK8HLSHrwEWYIKrcRU0vnw+4nHEkIZ+7waMpq05SHI83tpUpor+a/Ui/b0fxkXVpZHkclATbROxsYMJQtNGDX+r5ZbTHbVdgWi92iReFPs5zAndmvLiYzIrYzoOFPqltyoTdAUsRy6pMRUdg19AGPA55P/7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMgtPb3gSzVxHCCX7iCvRBPVX3KdU5+40JXQC2Ttpgg=;
 b=x2JU4cpD7YcvFUmliXf5dmLA3C/mrY396YBSKSzHFBY/0eG+koMcR8rY4O8myEedE1E1S/EgfvHYbxmtlD0kLzqRdwwOZ5/4EitfiWWjehoxkh4AKS0DQH5WlsaLdF45ku7WfZZj+mRZ1CY4pSGuvH1j566toWpnn+0PLuJbkNA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1997.namprd10.prod.outlook.com (2603:10b6:300:110::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 02:05:29 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 02:05:29 +0000
To:     SeongJae Park <sj38.park@gmail.com>
Cc:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, himanshu.madhani@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH] scsi: bnx2fc: Remove meaningless
 'bnx2fc_abts_cleanup()' return value assignment
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135t9s5cy.fsf@ca-mkp.ca.oracle.com>
References: <20210618164514.6299-1-sj38.park@gmail.com>
Date:   Tue, 22 Jun 2021 22:05:25 -0400
In-Reply-To: <20210618164514.6299-1-sj38.park@gmail.com> (SeongJae Park's
        message of "Fri, 18 Jun 2021 16:45:14 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:806:24::15) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0100.namprd13.prod.outlook.com (2603:10b6:806:24::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Wed, 23 Jun 2021 02:05:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47627a1f-9c7b-40b4-0bf9-08d935eb5fa0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB19971E19DDC054087F710F6D8E089@MWHPR10MB1997.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5S94H3zLnYhLK7vcaE1TvDRoMQrvu0cdq7ywTKJ+0+nnBSnizPjiC1KprU5At1w+WdPOMnK8muShlQkSNLsBZEJMj70UhH7AvySpruQ+lsMDyBcQCQLQLpux0OCcchPs+CxVvvO5y0K91A0UcxERAAulLzKpfWl9bPz1Q2jzyaPYINwPnW49zLb+QLhObPudhpyCp+cKjDBJfE0q1yERQwPqlNLHcnPhAhzJRtrmaHWVwMixwQ7CHTs59xZdZm69s1nMg7Ts4gdiWGebvhNLItRYLCUJvIbb1q3H7TKSPSh9wTPKcitA12ne0//o7kEt6BrOvjjD1q8AegqU4HulW5UkiRj1YWX/2VxIYIyIcekiSnBsdy5g2zAcR8pucVC/TRU6jPpJ0N6eaFtAWvwOYqT6NktZ0M4ySWXnTWuroZnrzk9wjwXgcP0OcF48S6BZB1bDCcR0o+PeqI02vzD8YqtgMfxxF9o9TP2hCrwy/mToAnJVqQ5Usafuv0Zvy9z0qCUyTn1GqIWczuaxAksY18TBHgNtSfMQCi4rTtpJ1g3gO76ZHlSSajxoLNnsLpyJuz+3qvlk5DCxdZz+idvw2g5vKC/ELNRgRwpzAkcAgfM76j2OA7cIKZlgZ9Bq3RKXWxb430yQpofyknPdyDS0hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(36916002)(83380400001)(26005)(52116002)(7696005)(16526019)(186003)(478600001)(6916009)(38100700002)(55016002)(38350700002)(4326008)(8676002)(316002)(2906002)(8936002)(66946007)(956004)(66476007)(66556008)(4744005)(6666004)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EzX6Bw+BoZyQFlxO7faloCRsBVSKIx7AWq1r4Rxs3ypXinhNO+Pf9P57BvhB?=
 =?us-ascii?Q?qJV2AfDlzzp4juSXEmdNlH5WqN1RMIs64vbGYjBKM7WhRPUclfPz6ekWMFxh?=
 =?us-ascii?Q?d5rtE7AiBtaLFkWizkFaxWgVkVk+f5yySpC87uZwN0/3ynOV6z7azfKk5Vot?=
 =?us-ascii?Q?xRyOa1PaRZChTUV3shfwwKGtRqt1HBj8Paxl+UnOhGP8lvgl4giLvhg404ux?=
 =?us-ascii?Q?1YmbHHpm4iW7+Lctfm3jJqwQVuZWX3MQZ6Uj8wgdArF9Psy1TFzuVgv1/aJL?=
 =?us-ascii?Q?mUKmQ8y7zJ9JYGFn3hYI7VdfbBHcIPmPJIIxGC3M2nRsBl/BgqWb1BUG+EYP?=
 =?us-ascii?Q?/oKwmEdlwc7AzgQsFPIG3wQdGbjBFEIvgmhG2e5cyb8LBV+8O0bLd2loCdHM?=
 =?us-ascii?Q?+h4sWU7ox450s6KGMAH5sAJ1oTYUWHOt+21yN45K+GTOGjppjxPbBHSjDExj?=
 =?us-ascii?Q?PbniB96LVlh25aMXigr2Vk0015YVZ8/XaeO4YImcKYPwGrujEHdnIROSxtoc?=
 =?us-ascii?Q?fSayoyl1ISJcgXOUX2nDDtdgulrMj7wTjLZQuYaOMDFVoszRfzeLyK9RMv/4?=
 =?us-ascii?Q?ha0tYm8pmfpBuOIR+bslBxrHBIBUizQQ9Ltw3+OBdKJPGCRLQDipzMv8rhng?=
 =?us-ascii?Q?acC5+YKOFUmPPYvEv0KRStHAnKy4cBqyupUsJdQVJDKFHQQ/UKo7ILoUk0Yl?=
 =?us-ascii?Q?rQufVD9Wmtu3j75njNKWXf8dexuyRG7r/GHlTgJ5if3fSB1ziv2c4mdZKvJH?=
 =?us-ascii?Q?GcjkSDiHiEP9SWLQf+8X42pA1knAkcsHOJxC5B0l2+R8cIv+7j19YxTJDv16?=
 =?us-ascii?Q?gIj39c4FIyooC6qduWGiK8105XEWdoTlLCnGgrrcl++/tac7cpyXLZpQCUBe?=
 =?us-ascii?Q?pMLjSMOBjL46XfcKKm/uctvWm5hxWExW2gO8w6M4MRvxNgWc2PzuVKuRFmNw?=
 =?us-ascii?Q?A+SktCB8u2gOidN+G6WP4FujE/ixSeyLFFbMOXttaYfXWCqVeXp9sEgV1C+7?=
 =?us-ascii?Q?a9Cr1SWbH6+jFOa2D0nEgluZHPaPqTqW8Ha/aBd+vqdhI+XmM+TFQyxvQqtM?=
 =?us-ascii?Q?ZQITwzs+BPR9+IX5qles65wcU3KFmjfJ/B2Ye56BekFydzZTtPyFF9cBBtq3?=
 =?us-ascii?Q?EvR97OUgqsrAntQe0A2KmICVcvLOILLTS+kGixE2BnWnJhmshVYcnRLcXmc8?=
 =?us-ascii?Q?CAprmOEiSLj8SUyINKpK1RSgq58bvFeLGUPi1al+HgfzrlmGzTYKON/m6nHs?=
 =?us-ascii?Q?JRvDr4twKe1A9XTrxdlL9f/VF5E9SMGaHi9KPc6HAIEqz1nEmyLM1E2vdWDD?=
 =?us-ascii?Q?+mUD0mhpuckkwnsvByNWKRS+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47627a1f-9c7b-40b4-0bf9-08d935eb5fa0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 02:05:28.8652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3/P9v3JKXKUYyqYoS1pwcF6SAMStxMWp1LZebHpJ0b18plE/FyQjX1J3/P9EcXEPsl8z6u6iGtmObb9qZWNEjzkt8woQE1NZXhQbwidSOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1997
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230008
X-Proofpoint-ORIG-GUID: Agb9ayMvGBniOtImLfn1FkkeoyqDbVkG
X-Proofpoint-GUID: Agb9ayMvGBniOtImLfn1FkkeoyqDbVkG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


SeongJae,

> Commit 122c81c563b0 ("scsi: bnx2fc: Return failure if io_req is
> already in ABTS processing") made 'bnx2fc_eh_abort()' to return
> 'FAILED' when 'io_req' is alrady in ABTS processing, regardless of the
> return value of 'bnx2fc_abts_cleanup()'.  But, it left the assignment
> of the return value of 'bnx2fc_abts_cleanup()' to 'rc', which is
> meaningless now.  This commit removes it.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
