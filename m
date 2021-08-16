Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28117C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000D860F36
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhHPRWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:22:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26468 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231861AbhHPRWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:22:36 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GHHXo3027592;
        Mon, 16 Aug 2021 17:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tb/bj/aCxJeX6O03djJJxdKr1XqsYPiOIEeRv12cJA4=;
 b=oYGSKTQ6jmj+sGLqb3z8x2o23mXTCNGCTqw9PmnqGEDvxIenlU/JRehawsEuYVna/GHH
 BW8bU4gelzadl/VthszFbSeFEoknB/RO2bgnG1QP4K36gsaqhArfJn0eWvWeUE7V+zaY
 uKsrJrxAaMSnTEqhlu710OvksPeuSbty/NTHhuuhou108m914B/AJtEbGmkoFudxjlwW
 wRWaVIg0OiQDN//3JTDvITI6vu/lrZK60NsYG4fBccvD602lUrKmOaMvMV2khKgcNAzY
 vcMC3Dl0smmm6W2EbMwRFl7L88U53SQZHtXync21GwhUS/hl7D6emFIsWzA4AJBGJmw0 8w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tb/bj/aCxJeX6O03djJJxdKr1XqsYPiOIEeRv12cJA4=;
 b=QVYWepmOmEQXDqOBvTF0bkrX0+MvDDRrDEmG7kVn3hSjJUlPUbKIbfCCtzqp8ClNvIkC
 gHF+DJxCnEJYm5KExeWo+gRALFjFuKh9y5sSud7bjMok+8w6jAchNXunGmfgkDlHE5qV
 rcYiDL2D3D6SWFvcOKOlzY88rbnLdIuhkQfjAqmpjemFvr+OUN0+F4nbz4hnvtEjca7o
 1oXMOuRCyDa92vYCTKowOMsGJq3K92LFVvCAMrCuV5ZMAwcldRG7WCm1glBzJYbfedm1
 F/9d8T0IEf2GdxwRUnterMO79TkzzT8ohwYo06lFNpLjS6Qx0eJNElIjFl1SH3cE5SlO sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af3kxtm6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:22:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHEpp8096477;
        Mon, 16 Aug 2021 17:22:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3030.oracle.com with ESMTP id 3ae3ve57c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=La/4zakRtUmPBZsJZwJjNh5QNvaa5ZUTwf+ENmSRLs1oNuOlXTIWuQG5CbH37G2iSfaQAMVPEXCaDX784zb41nRqfJH0lNK5wIVjRfsod+2tCBNIacd8D4T+7cGOxCj1Jf9eUdvY72S6mrl1IjF8tkIih8m31fciQTuArBES5vTtUHDZzkLGJ/Z/F6UKUlITiRsvwxjTdOkCmVHNxib4uehj2Hejsegi86iIY62tQzOSL2NsJkTV4KkDSxjPj57fqIjOWY/TV7saCymhbCASC+UeCshcZimP1o7yuwZXrUdONCzCxl1lVgpt4F8rg8dDhl8Cmxd0zhSuTKrv7fO/ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tb/bj/aCxJeX6O03djJJxdKr1XqsYPiOIEeRv12cJA4=;
 b=ZbnpbYTbndqNWgTjRKngLcravDvaoAc9hsndhP8lEVe4W4nxWFx4h07NlRUi2fY0JCEp2PPlnXdHza0ysQ/o09BDTkS6WhQio0wfIxVHornEevu1ADxXJl/YYChamTLpnz4cFt6gSKXKP5f9vIz602Qm/6CKDkofZM7cfeqty8d3R5Q8bIShK2Eyb61X4zWlvBu6IRWAP9XIoPQ9hr7NOntLVAMARHo184bauO3sKi6GCGvLgVBonBVBZNs30QArfvO0iqTCdt6TiguIBIGpcW3eJZXVTe9f+LqrZoQvsjWyvRn3b32emZaSCnmsxSrw/G1jdLKKqCbLA/Bgb68atg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tb/bj/aCxJeX6O03djJJxdKr1XqsYPiOIEeRv12cJA4=;
 b=JYVltr0exP6YwEW4zxOJWvpSEtRaM7rBJ6tW8XxVnSUSiD8dqckTxruGFiIVKT77qbKyaCLLW0Jy5a6t7eyyNME2sDsRPf54ZtTCkLYb/8pfDl2wyvPpm7W5llVoZ86d5VRGRpgyVyFjg3WlQ/Luurfzz99enZ6fCQoZ8xOQS88=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5434.namprd10.prod.outlook.com (2603:10b6:510:e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 17:21:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:21:59 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dave Carroll <david.carroll@microsemi.com>,
        Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>,
        Murthy Bhat <murthy.bhat@microsemi.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Fix an error code in pqi_get_raid_map()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf51paoi.fsf@ca-mkp.ca.oracle.com>
References: <20210810084613.GB23810@kili>
Date:   Mon, 16 Aug 2021 13:21:56 -0400
In-Reply-To: <20210810084613.GB23810@kili> (Dan Carpenter's message of "Tue,
        10 Aug 2021 11:46:13 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0016.prod.exchangelabs.com (2603:10b6:804:2::26)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0016.prod.exchangelabs.com (2603:10b6:804:2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 17:21:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af04167f-fc62-4ff2-ed5a-08d960da5ae2
X-MS-TrafficTypeDiagnostic: PH0PR10MB5434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5434CFFC5E1B73B0175676B68EFD9@PH0PR10MB5434.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTOcL93gpzsVFlTV7Gw9oRfGWkqF85eoa/JqGxDGwjIwPb51DTtnPnGMUNNL1GeHDNhqfjGgWPRjzmYaRIIes4OinE2wPrc48VsvsEcDf0tq8aS/pkAuQUG7w9gxSIPk+x1aI30k+HFzXVjDlqc83xgiwv1q9CLqS1IeekyVBoWqD9dLMcCgzJGWU+N+7Z8DjWIZFnV1OmnoyXgpqjeHOzmty2POtN2V3AmMovWAyjuyUGETw2DAfiK680l2XDtVu7W7M1US2iFGePgofnDKNaC4nW0ZYCdf3adx0H/CIpvt6u1cy9zh/nuc+UW2is1rv4tJntq8Kq5jP4eQkuRdMZM6AuaK+B3NOpowHaXdR6DC5tLuFHfDADc8iUnlZzQ0jhfymOwGv4TVegJgZ7qrwvJWYvyJd2miL5nBJ/4LRw+lGP2uMl2WgnLPeN4FVHQNHYR+rVVWmIR1F/oxQ8up0QoChJgfDdWJ84pVXK5gYPDkrRWlsAU3xBtL2mW7CjM5LspXmAH41fh9SIXFREjJ87nwEHXWIIrOiHw0s0aAF23npxbqBgs+iFcEDDC/24E1qEZ4VePEVn3NPYE3zRvPnz1QbyN2Nim92+FqDiC8aMWb80IE/k4IP+zpp6pCV0Xa3zcH81ja/oS/dRgnPEkhHbI9D02p61Xi4ItDopHxFeznwmlM5HI0XAr6GvR7AKV4YSrfwP5i25lv3EaWLSAz4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39860400002)(86362001)(38100700002)(558084003)(38350700002)(956004)(8936002)(8676002)(83380400001)(6636002)(55016002)(4326008)(52116002)(7696005)(26005)(54906003)(186003)(316002)(478600001)(5660300002)(66946007)(66476007)(66556008)(6862004)(2906002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vV5h1BUG9PizQQU7JpwH9BcuXVV7/eyVyHxuRzljLPweByx9pptsaiAshVyt?=
 =?us-ascii?Q?nY6bg/Q4LNXqQ1cB7tBv/q6k7whVGWaWlCAVvoNfAFwX3+hXDrihkFiiIeD+?=
 =?us-ascii?Q?EsW+XiI59GjKb3twFKVCV90rs4iuT1l/R+ROqVuNVDcWgfY0EQlk5b1OEQYw?=
 =?us-ascii?Q?6LfgeA5W/jPx0HoDuXihVR2Rq2SivId4oVMo87Bn6O/H80FFCYJxxZsDEC/Z?=
 =?us-ascii?Q?3lNjW4nsydaxyWDbfuAnUPcQX79d7rqRS0LpOtAFxYBdXMpfND2InZjYKAed?=
 =?us-ascii?Q?BSCeLHGNCRW82jKsDEgCDD2gnDtcjJ+J08Y+bWUWdY3eRVQnYf8nAZIX2bcB?=
 =?us-ascii?Q?oC+zuYvGQWUIpAWM2mSuMXK3iiRY0KRdBwKS9oec0phHa1yfuMMv2jZQKHoc?=
 =?us-ascii?Q?ffUsOLCVHUSCfre83UTM7rEK+VQA7R2Fjj/qFlPa1oQkiuGkixVZBz++EG4H?=
 =?us-ascii?Q?0pVKsdHo0JqIjaQeJjknSwSgcyS8nwPmIpaAC8YE/fMsT7z0YZK37lfNUW3m?=
 =?us-ascii?Q?XPslkdHx5hZBSAZu6RRAtp3WFAbWHiEMhcbZktocqbrq9AolJfFPSasQ5dJK?=
 =?us-ascii?Q?Jw572tqnqv1sMcH4Mxgotg6lj+nFePSUwpytnetjCABL/uZXI+udD/DApmDc?=
 =?us-ascii?Q?WCuQglUnrN9mHrbFnQ7jShrpNg0rN+NvyTquQeLD8Qz3s66W3IqcjxeSjjin?=
 =?us-ascii?Q?VhF9OmcsddmUB5d1P5dCcjf9BbcFHtJyoaEo9LEZY68cUon9mxvGck1ugv55?=
 =?us-ascii?Q?nw/pqjKedFB3YdLwhrLHnNsG7CK3pX9h8wY1D5aggKVkj5vj/EPFwtT48EVa?=
 =?us-ascii?Q?KJI+3MTzG8LlR6rqt4bkUxYmxOYuIGqgsAHA9p5Uiq91h/qaWCNTU5TACIEk?=
 =?us-ascii?Q?8lqC9udef4WJykvbDHW2J3GjckaWthq6zCQ5SmwF5IIsLWqEjKPw+z70jN2v?=
 =?us-ascii?Q?UHVoOuQjYgVkYDmiVGG6EFHJ1rJKxPTvuN898j6Iqggj77XY2CfXuiYYtf0F?=
 =?us-ascii?Q?n5JXpazN6gLts066dDK+4dwU07CORQPfAseniBhB4rZ9pzWLiV4WxRpNSdxD?=
 =?us-ascii?Q?I7GGuhyICi50LTmqWbiJlJcgBWn6ok0f7Ag87RtXqyy/6fx+lnZWsbKhWBnq?=
 =?us-ascii?Q?p6zr5Y1qaMrvLJx5T8odma4S2muyq643OCJwV2q+wP3jbuEXvrbquIP4sNkT?=
 =?us-ascii?Q?hcqlY4p6d0c7yhgQiMG1tTMXqU1eDyG4GbHJqxnHsVAyrjzwx4eJWp6XyBzz?=
 =?us-ascii?Q?sy5mTjgnQrporPXxCaMTMbY2MGKs9rXhQjH6V3w3LidLUqGvt+5t5slmdIob?=
 =?us-ascii?Q?Ly5ErMed9QZyHerekviK+7sm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af04167f-fc62-4ff2-ed5a-08d960da5ae2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:21:59.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRMkRWiXn727viv84L3XKSnEAyl/UjoHR/mLDuyPmi3uXZ3G+sC1036u81pTGmdPM9vVN+mMn42Ub5ffskFZ1AF5OiWx9IiPie8tvPhXudQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5434
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=915 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160110
X-Proofpoint-GUID: DIPJA5BWIRdKc2C_-UoTqSgP_dDiWh23
X-Proofpoint-ORIG-GUID: DIPJA5BWIRdKc2C_-UoTqSgP_dDiWh23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> Return -EINVAL on failure instead of success.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
