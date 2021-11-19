Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428EDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A9B761360
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhKSC6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:58:23 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4984 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234312AbhKSC6Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 21:58:16 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2k90i031693;
        Fri, 19 Nov 2021 02:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DQXUFp1WsB7c1GBSalonOP4PKIWyi7vcrWY/VeghUJQ=;
 b=SlL8q1QG1Of5mMNtnN909CTExy9j/T1oiujGFZClifCk+yUKC1feTmAisDjs31xgn3Ou
 I9P2bYgNV3HATPIycMDs6lhn+8GrLmwZI8x11MxxGD3OXrlxXYF3YTqdaXC7u4WBw9pO
 Qe9RzCXkQOcwTs1uoSO0bEelPrN+7Rjtjm4mE0tfLIaC+gf4Awuc9fCtDlTMoeCr0O82
 0I854j1JZ3vgfTN7GtcKNN4UISWlxvv6en1inCA70hnF9kdQSLrtLGA5BaIazDgcxWZQ
 9DBW8GlvwXfhDazGVSfz7gXDJCyQNjIeFNWfXYCbPpm3icUSm9wXmtbA4dOj8wpRMAa6 pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2aju92k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 02:55:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2olqO026277;
        Fri, 19 Nov 2021 02:55:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3020.oracle.com with ESMTP id 3ca569khu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 02:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyqBagXjhu+5u+WcMB38rbQxyStTRdHTVYWl3Z+B/Srun6JEmOq/a16792ptSfS6bT+jUNU7UjK9uDD9P+6A/AxuycJ9MsA38KKKI7+4mYkYYZ6JD6ci2LzvLYndoiTwcWFqceukMLexUMr/kGkK5gfUsM9AWhqXrxYy3y3ZWDe3BvA7EejBcB67b9qny6sz4tQGVBPG8KxO/EgkainaBio0ciaTOkf5/yW7lbaU3YN523e3p+mChrojk2mvOF0g/TKyceXVXs8Mt1JTYnM8xm3A/m8LUyUQI2eRq4Q6pojWbaHz2Aev4hidd+wU+TwutKF+Mdpy7RBFFi0y5mCgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQXUFp1WsB7c1GBSalonOP4PKIWyi7vcrWY/VeghUJQ=;
 b=Rh8tWMZRN5ev3wwGOwCxjiULZJrRLbaYVYrIhzfh29LUGR0kPKFwa7xIPHxXIoFxEuVlEU6/xiLmfkuWBVG35Xbl/qhjehYEaqo0FfSVgGqKGWvrbkFK+WUUIVZFF/eJfuxZ2pYVpZOm7VmgVLKnsHVKNtr1sRzxleCMA6NKg7Uozmu8VBIivWebvSnpvusoq9ij4sfBMJSb/93iAC1mUwZEsmAqgPuaNmcE/GcFWrgK5/56f2z9j969sdPZyzMo/LfvAn09bbEEFSwbNJwFjm83C0xn0fAaBU22mgy63mQKfjmfy3vpmRDQPc7wXgm+NMew6ZQxrlVlQUa33Gh7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQXUFp1WsB7c1GBSalonOP4PKIWyi7vcrWY/VeghUJQ=;
 b=G7INnv9MKfTvWlA+Z1PEHeohU25A3Y4+fhdwlv0hAYbvLPevxK1ij1NNUJpol70UTUFdjGolKnpAM63G955Fu7prqcajyXNmbuOwK4JXA04ZDRLBl6pDffsRbGtWfWnO8r2CQDv7tZ8NX+iF4ICMFB0evNYHsB3I3/3XYmYrWow=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 02:55:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 02:55:03 +0000
To:     Changyuan Lyu <changyuanl@google.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 0/2] This patchset adds tracepoints to pm80xx
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsrs7t3c.fsf@ca-mkp.ca.oracle.com>
References: <20211115215750.131696-1-changyuanl@google.com>
Date:   Thu, 18 Nov 2021 21:55:00 -0500
In-Reply-To: <20211115215750.131696-1-changyuanl@google.com> (Changyuan Lyu's
        message of "Mon, 15 Nov 2021 13:57:48 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by BY5PR04CA0009.namprd04.prod.outlook.com (2603:10b6:a03:1d0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Fri, 19 Nov 2021 02:55:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc0a88b-446b-4149-4dab-08d9ab07fbdc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-Microsoft-Antispam-PRVS: <PH0PR10MB55147971D548BD9BF452E3578E9C9@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXaH5zaufnd+ivJXcDzVNfLSN4wjFRx8trSElynIQjTlTgtaUmEtG4UyHI0Swi8sJiJzoPolTWiP4i/YGkD98pZm+lRD6I+mhQOF+H2XmLrTr+BM3V0+/qYGB+FNK8/FOYoav5sAboM+yneEmHLbFl3cAhX0jWU+zvmmIHNfwzO7wIbI7RNxltpZWBQHjVEUZHTpQd1807xh1qt0iyQ0QEJvRxY9e1NvfOkBwxngp/yVeNkYquDktI6a+n1X1eFaNfuM5ZtcUgggXOuiRpx03/+py58ngvNpl0fCRnu65GQHspKEemI1btWPgnr/sq36imHWFXLAjCNQF6SS8ncLFZLpWhrM5z//9sejJHbP4ldcr9T4YNQDTg0OzBkqMBQxcOGW1g5Wr3bD7g7Ml3yQlJX40KA3xnjaTF7p+LI6nXpZNSF2yQvYAq9seaV4Twh/VgYSBIwlYwKRsOuAZhVgF2fQ+ROAUR5BGtdLGtnMATZDD7GAPlD1563y5EwS3Y7+r/XW6bS1ibNTo5qYUsSrL/8xGGHpHQM5SwUDXnnkpmKrOmNY4RFUOJ5bd2O65NcS2oq9wAWX6JrZXDn93SF0GlHYD+ud7jsnfRcGNko2AFGjMJ8yRgmykd6fP5U6chZH2Cf9LOhWmiFC44avnbBSoramlf3a0VR3A0Eq2nh8gKFZRZrPIHKr0kKBVUlZZ159X6RJVBMPvFlQXgrcowtacQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(186003)(956004)(6916009)(5660300002)(558084003)(38350700002)(38100700002)(8936002)(66946007)(8676002)(508600001)(86362001)(66556008)(55016002)(66476007)(54906003)(316002)(36916002)(52116002)(7696005)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bZL8wPGhRZ5hrohkCz+A2OL05ANevFoSo00ozeBG9AhshL89bfoQCXk8whTl?=
 =?us-ascii?Q?tFuP74uGeHVNgxpxE8S/r7mKBQPcRHssDE4R4SMh31YStfQNqH+KS5QudRz0?=
 =?us-ascii?Q?gAciOE+LUDsEW4VBoN2WNGzwnpOGHHRrwnccK6lJOtnLAfsqjSJgP+7pqxQK?=
 =?us-ascii?Q?pBByPjqUqk6MhXyX2ZYyBc69Hxoe95mZfibR047F0fz9tvCP8shXZVWzHNd0?=
 =?us-ascii?Q?/mr+5j8M6GDSzNoF7W1JR1Trgoqq8+yoqVJopHHw0iFSa/tH5EwjoaT9dTa7?=
 =?us-ascii?Q?B0XnsL/iBqH+BVLyZrfHEC1b0vfoA70x4Y23D144Rpn6RdvUkm42s96mxTDz?=
 =?us-ascii?Q?EYcf4mhxpyObJoBCNeRfwO1tDcf4GNmZhdP4HYqEjsHVaV9p53AMc+DXLZ1+?=
 =?us-ascii?Q?W8hq1hkRuAq54O1Ektrzy+XviuAQyarh/c/CWEOVSRqTfKw4fbQNbtqMprxw?=
 =?us-ascii?Q?e4/eznjTEJ/wj9JRAt9P8hvr4D8FD7x4RCiY4InLmWyCft2tdHJjUFMaWX3W?=
 =?us-ascii?Q?o+AymXsmUubWXDF0hKVNzljkY6gPL7sfyOekyYlm3n95dZY5iMweXvWhbp3q?=
 =?us-ascii?Q?ndht9ds1Ef77Jn1Nm86e2zVlnl/3dF5IepMhjSr0huwgWQpK6uUSXUOBiHF2?=
 =?us-ascii?Q?EZBe7jHIjTx86laMjCh63KHDUnHLMy2DO7awbZ9voiBE0+vdcau2XIcIDAbI?=
 =?us-ascii?Q?UTBSVJQHPNvZeUmaDH7r8lkd38hasVStSfvjHXlylab15YVhLEZfvuTZmJkZ?=
 =?us-ascii?Q?Y4yQb58vb4g7GHYKvrxKV1JSqyITL2w3UZ3djcGx+IWY9W3IGrRH/UhVYwzw?=
 =?us-ascii?Q?Llv42sehMX9/Va3ncCusAhdL1Z6lzxgHferZoBufWjhqDGF80fz3au/KR5y1?=
 =?us-ascii?Q?JV+rsCeZL37k7BDvrESh/xv0GaYq+3m8aEsqepWIw1aGjJhTVVHWQf7M2b6k?=
 =?us-ascii?Q?fmQsehUf7SQsDK5+Ye+3xHbx7T+rMjmewa9rSMvWOdNxjUOfbCPgQM9SqK17?=
 =?us-ascii?Q?WS6Kom2CGqWemZYxYOh0dIsrC54GPMoyc5igNvS6vRx2FSlITsmAH/hYXrMU?=
 =?us-ascii?Q?YPAaBioZ2KG4XGekuVsMum1JioeuCswbpMVsVniv+B0hexvK1qYBtM9411CQ?=
 =?us-ascii?Q?M/w2+dd6sxRjV94mfJVJnM8vhxxUjFHno9dtKV3NnHUJBQRU3Fl6W6Mi2JeV?=
 =?us-ascii?Q?2J8NM0OkRr+a70EAMPmN4Qvo8WcPiruTPMHfl53Gj+W888t6D59LH/v17Jhv?=
 =?us-ascii?Q?yx4HsFiyINBpeKOWY0XHF5emmKzYkOqbHJz7m/NZc9TA/UUDXzONL9MLDLzK?=
 =?us-ascii?Q?WWPCpfOYtm1AsrcKhPB4+MpX8FqqyvdOoEEF/JFbO6fVxuY2Ph55M8HljbE0?=
 =?us-ascii?Q?fgWbAEZnUQz0VMedZ2NVrU7yBfG04JnFChtFH3VwnTZiYCFD6vfDWEA2K5L8?=
 =?us-ascii?Q?zM5s5rwX6S44MZPVsnry768F4Ijyf3M8+RNKgD5b8JyuNXo9yGOZpgil0Jyc?=
 =?us-ascii?Q?67r3f365POUs5atJk+jyXV5S04cQjsZ2zKv3ckawY1QlZ16qwl0XFobH23cL?=
 =?us-ascii?Q?24r5+3N1N9xKvE/laiXQtyXEi6VR7hEqsOYDNjZvuIDOdERYfi1CMOe+kyAZ?=
 =?us-ascii?Q?iL3Nzyr1AWpqxzoR1J0hGf9RclK+yYiKLD3MlX7FRYDVK8sScQoYWJOCIHu6?=
 =?us-ascii?Q?x6dhwg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc0a88b-446b-4149-4dab-08d9ab07fbdc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:55:02.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ayylW5fsAPXB0ZTuj6MMAsVhlCXZLtMfjsmibjJ2jgWx9SPD92oDZv1hEx+TP5A8vBCfWqnzoCkYWx4HpzjtoYAiplkrxICONIN4vIKvuhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=902 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190012
X-Proofpoint-GUID: CuCp67fZ9ZZgyVd3Z9JoFR-zw2bvlnpb
X-Proofpoint-ORIG-GUID: CuCp67fZ9ZZgyVd3Z9JoFR-zw2bvlnpb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Changyuan,

> Changyuan Lyu (2):
>   scsi: pm80xx: Add tracepoints
>   scsi: pm80xx: Add pm80xx_mpi_build_cmd tracepoint

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
