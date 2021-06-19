Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293AAC49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12F0C61057
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhFSDb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 23:31:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2608 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhFSDb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 23:31:56 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J3QwAq008295;
        Sat, 19 Jun 2021 03:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BUxQY/ukP6JgyJJOk/EGqPhMz1IaACKGG+S6NVoC4Sw=;
 b=p6dfXg0clfaUNCfOcW+euVCKDC8A5oNc/OwtNvxeeBtqQZCUp3M4lThPtMnjre1CFYs4
 WVBtPeqfYuiUJWABPXAseasqoGPMG+mKlQhd1P4dfCHw5W7iDI4UIW51XmBT1KDYUzoN
 4OFFFx4vzMNI37vjqNk48PTJ4MlhBF1wvbaYQPAJAQAkwMfqPX6RNT+I6J4O4hdUo/qd
 bkPfbfrSInJ2vcHQinB8PReDIhsvu7I+8VDGxrGiNRCTrnh9/vjzvh6jqHkXvfjEljrh
 owEq5T7Qa2OqbVc8oPR80s9M3pLSitcEUSE9HXyT1y4wv3S/4xOUtIU7b4l41udqhoMM eA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg22m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:29:40 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J3TdQQ125077;
        Sat, 19 Jun 2021 03:29:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3030.oracle.com with ESMTP id 3995psbng7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:29:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBIow7BOIgazt9kMx2HhASbitL/tGZdxf09nNv5mdsrxcT1FoXLgZm/RQ9I6bkF/yfd7WtKxV5sSrOXv89A6WqJ57fkVZe7+Ean1M12mBpxpO/Gn7NjX8xgmxE/YcBTGq7yVqMDlmhQsJiykDLgkmXnOCTmbDp5rJOexNGuBRIvdufAtnEeCiBMgiELTVqyELlx7tvcK0cd+W5CP++b8ft85d0stN23lw+H7jLHhTYH8VuxzxbD18bFyS/X74t19416a8ki3loRdNYcrKAxdyVojsN2+VRGIil1g7tjtIbeE3q1gl6Lsh6Y/ybsNActgGK8JUBSJCtO0bst8pQA1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUxQY/ukP6JgyJJOk/EGqPhMz1IaACKGG+S6NVoC4Sw=;
 b=d3kgfxrnI72PtloLrIBVLKVZ6i7C1ojy5n/P9NQ1lK713KshyMbuWzvo8xJUfjU7GHIjPmPFc0eR2hIjXz/hHqNuliZZ60qF0+cNV9ePE4UJnHASO3P1RE5KFbD63OR1eyzxyRnLirdoQvxv/aqLE0+SSlcB5K8DKviFo6FvDQRvsPvXWoZmZ7jh3PvpzK8ZlYjD/t/piftkm6I/CdcG0Dw9q3oJQKht49RR5RrZZdV9XM/m7SvV+mrMOkvm6x/pK3dakatvet42Z3tfx7JQk7GzhybHold86A3NJehlixrw4bQHe05o1ZdmsrhRUW0Uv4lzJGhKwh2vjwTwNBF6gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUxQY/ukP6JgyJJOk/EGqPhMz1IaACKGG+S6NVoC4Sw=;
 b=lp/E4rnwkX7wDbQpf1dRnKxTKwDhbxovkA8pO9KqZARJE8PzCQjucx5eto4CNdLFfz4xyfkXM0iW8YmIlMApFRFcY+1tHjABxzENIbGTsBxkHHzJGL5yhlHhFS80w3M/tVd3xmN1VTgFuhDYxO+8T16xR283SNBikcpGOFOkYfM=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 03:29:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 03:29:37 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ching Huang <ching2048@areca.com.tw>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: arcmsr: Avoid over-read of sense buffer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v96av8fc.fsf@ca-mkp.ca.oracle.com>
References: <20210616212428.1726958-1-keescook@chromium.org>
Date:   Fri, 18 Jun 2021 23:29:33 -0400
In-Reply-To: <20210616212428.1726958-1-keescook@chromium.org> (Kees Cook's
        message of "Wed, 16 Jun 2021 14:24:28 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN2PR01CA0040.prod.exchangelabs.com (2603:10b6:804:2::50)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0040.prod.exchangelabs.com (2603:10b6:804:2::50) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 03:29:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe17634e-c254-42b1-2813-08d932d2774b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5466B163E21A11B3440906FF8E0C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Y/offd6dYL1Gpua4g2ABmfaJ3XnADDnA3QC0GYoM2H5jQsWa+u1L3lBnlIC/2EL3mjOioTeR0soGMIh0BNpQM4rMCm619aRgKWuOppxv1khrmhoOUmsf9+hBKPFxO7BHHkQ1prPthb0dFDYSWSJWxdQhH0TKWell0wi9HUTs5G4h83JueSwko7iq+Y2bObhBMGFW6ivHDL/6e2dUuzP0wNsw/cB6AYkoLCcwWY9JaeYLLqw1cNp1Xb9h64agSzwWxZgKokTRkqR05x9bnrmp4KFw4vCnc0xGXx5dakQe+Cid9baGBhgvRiJhU2wteaA3OKseWE609jiMx7dGJECUlr8lBs0+PSxMHYTh2hkxdRYUtTG/hZ3pImXYoBqG6EuxGaYnGxG2SSOkYPsm2/i66Vvn4INWqRde9FxPb8MSR5cMc75sitUUz784eVPOhvrwR7IKvUeMQRZA7/OlPGZoFypsarzM2BfikzS5dl9dyqku5KPPiz4fdkcW4S0JLKlcM1T0n/M5AgnuKIeW38g9NwZ3AnteHbAW8166oc8KFiFG3pCGkxIitsLWf+GXp390uYWfGtvAX7XblBo6D6pUc2Qh9n0TOYWr7IE5dRGc6Bl13MMlqcAIfKTb0ZGWYJROtO1ZQmcCgrrcO0+2GKyvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(346002)(396003)(7696005)(66556008)(316002)(36916002)(66946007)(478600001)(16526019)(55016002)(7416002)(54906003)(4326008)(26005)(2906002)(186003)(558084003)(66476007)(6916009)(52116002)(8936002)(8676002)(6666004)(956004)(86362001)(38100700002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TAzoQ9fvQh5wBqQdm6vAmXRONPK1Aa1yZ/ntKOR/bE6dwE5pb7WtBuYZ/vUx?=
 =?us-ascii?Q?B80/FNSPYIBb4HxC3Vrms0JWyjeYwR5BeYUt/QT18C3BKVXsGagGueLa+wWi?=
 =?us-ascii?Q?C9x3UiXLUPVOVe4N3JBzM61kl8jxpuMDiY9rwQ2VdJa7USX14VwTF7jdoCtD?=
 =?us-ascii?Q?8jLEnV9cRnlboYA+d66y6yhwMl30iY5nIk79x1zyp77icuebQaTD0Hjq+SPO?=
 =?us-ascii?Q?m7HjXxJXohkgivFsdnrR0aXatWtxpHfT8uawd3GkWHuhqyxlUYCLpDBoypn0?=
 =?us-ascii?Q?p/vWGHpFxv5Ofh6mYnIgjjstEeiu2aUC+IbRqbqC0ntghY65JaSHMssbti7/?=
 =?us-ascii?Q?dqHH5Sda+5XGK6zgojVJkl4/uZExU/51hkbrfeCce9gJdin7Df+2Z+FqCMct?=
 =?us-ascii?Q?29ns2uqBu9EEWxEM4/tkRu56jDSGa++hp4nRY77AIIfuF7VXaeYPVEfCzI40?=
 =?us-ascii?Q?k/hGE7EKBTFruip/0Rji1dwVHCdycCr/De5QgR0C6RH3GJohEOtoA4d5X+OY?=
 =?us-ascii?Q?PzYr+aL9QfCc8/iMKqvIGWKgGM8flz4hZb/Xea4ln7xRoi/+OriyGK+O/Up3?=
 =?us-ascii?Q?RpmRVk7uqPDazAG4dGuTl95IAEvSQHchxQXFYCA6E8uFPK23BaJ8pftDwBxe?=
 =?us-ascii?Q?eKkbqJRswTP0bjlUOrj6SBjBpQLwvJ1JsD3JdM1lwuOHymYlv0RXcwty6KtJ?=
 =?us-ascii?Q?1Zc0uguqczNAmml5zp8eW1kXz3MrIT8ut7PBMz8yDfkd8uE0lLmS6ozK0ifD?=
 =?us-ascii?Q?RexJqijqCJ7UeEj928nuzSspFc25r2xSFXeqma0emhx1me7QyxuVcck/iwIg?=
 =?us-ascii?Q?UDSZtNM0iGVSRSBFoy3Njw4qOKnUVMRKKDu4tiv9pkY9PQItXcFYCdmm6xHn?=
 =?us-ascii?Q?62IK3so/HezQfseFtzJTuGX/prYYy10H4ns1Q9J9nNyC0if692rWJpHLiYh8?=
 =?us-ascii?Q?DWwvMEjir3i2i6SVKpI8zJJTdFlOes9kHaAih6j1zJKUxw/T7zoAEwC+WXDA?=
 =?us-ascii?Q?zaWu9POHS2JGMqRVsgQ5kObcI+JN0iUguGvgDLWIVhfDFmOY7j5Q4la7krpV?=
 =?us-ascii?Q?Aypzc+j7/DXdyX1FlEyQdy+eu1+YI+hi0lpitkOzRvpa02nHQ24PSZVd4FrK?=
 =?us-ascii?Q?DVPtMpW0cddrdQCcpiN+mRQ9L++m2TrQjzYHsAvB/fbK5svUynldv9C6q6oP?=
 =?us-ascii?Q?G9FV01WX5t6Nb5R1AlyX4QyiNj+m0IQ2iG1D+xOpSh9g4Ht/hbjVvqVtfcQx?=
 =?us-ascii?Q?rA56dUAs2MJeZzpT4XCZfesIdZaZ0i6igwHuOOrEd/O1mctXmcLklfyL1MiT?=
 =?us-ascii?Q?RHUWmP6gBvGzphKGaZ+aLe41?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe17634e-c254-42b1-2813-08d932d2774b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 03:29:37.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxtRRF3o2d0S4GbCY47JEMuO4lsksvyjXmmaG4YYIHZalzW2CfATT5vXGVmswGcAm9f4I6S0o5qbglwNOvw0zsaxu51/zcP3Cp8jI2efvZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190016
X-Proofpoint-GUID: 4WQslX2Eo9-FbakDMsj-0L05Q-5E8kn7
X-Proofpoint-ORIG-GUID: 4WQslX2Eo9-FbakDMsj-0L05Q-5E8kn7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kees,

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally reading across neighboring array fields.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
