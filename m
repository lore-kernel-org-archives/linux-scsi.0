Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE76C4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1457364F42
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhCSDrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbhCSDq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:46:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3ktxl097400;
        Fri, 19 Mar 2021 03:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=x5gLYB9lJOHnmDfL8zkbkkYRvifLKIPQoHK17xCy4h8=;
 b=bLXl/YrJL5wkH7vNUrvXRjT8p8yo1h2fTDkKCIIiXlSgq/sFd0pqwJeiO/mwovjY+r1P
 43DYDFEpEkAI0Tri4fTFd8njWJcQ1HZREnHY1NYMw/gY7t0XKrwO7Z9e5SJ18Y30SnOj
 0SgrO3y7t78gX9Yxqzd2DLrAO6gEHUEFq5LNOzBA1v440sQzoSHbEkZMKYFqRbCpapyB
 dPtYoG5XLY8+FD6mYSogFmpRL/YVIwuQkbqC9F78tKfjUUS2Ip8VepPtD15LpGNev18M
 WDXe4C/qdJxzV0zuqfTjYfe50a1ZpPGlYhRPdjR2uaPs0xaipUNL5vJS0sjfWgThzZTO VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 378nbmhhdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U9Wo175143;
        Fri, 19 Mar 2021 03:46:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 37cf2v0dn8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmXj4PSRrxKFS2EHvaXZvIr7oIHm6q0SRG1+SydzrvVSxFvwDlxRtY2roSAl4UQJ/d/cA0j9MvdvhqRN4uSL6bHolrdSIj6mhKmqrk5+JsSNpYuW5l4nacjxB4zBqXVWYcqLspBV3/Lm30SgFoH/eTiqaVFdTGZ05ZhtVhNAJ2jTJ12VN9t80icj+PJAzGkCtPyPrtecwrdahon6oRyGjDrDx9x0raboOPPFJw0iO0nRBTBGVi3xY9aszoxIU4qDfLRrwugOI3TRSgqwGflwHNmpYRRCpwdRWCywMqVZ0AsS/1IpsLJHMzt60dETleHtl+FH5vsu/czlKqKbYx3Xcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5gLYB9lJOHnmDfL8zkbkkYRvifLKIPQoHK17xCy4h8=;
 b=N6NXEY4cWRv8GcH7YOn2UwF2RL2R+5WEY2ZJoe7DMyJmwp46t0JM2s4eUrORGs82peUy8yIUZIol+fU1G8v6L3bQdjtz01BhS6+Jn6XLqotu2hv0q16c70K1bAWWb20iu74O/MWFQm81d17FzxCDWXTc747fKLZqA/kmsUmSwkt+P8RT8SCmzsFz9zMxwv+Bku642XLYY1QrpGLPlphd98uAC8kyZCl8DNLyi9cYScaxv8jUhv6uW6ke5KZb5iqrUFYAWGVHObXoSBX1CoAVaB2rijIShjOBW010vU68BAhyyuEA/321WyL3wfOcXMumIdGKgmFdvLP40HkpQvA3wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5gLYB9lJOHnmDfL8zkbkkYRvifLKIPQoHK17xCy4h8=;
 b=vLBYsWf1juVC2qOcRthnvSA6bUa9KhfrHUdGMtgi448GOuTR27Wnt/neKwvRYTq/Y/M4EbSTWaFEU3ugfICKK/wKqP4TdxrOY1BTOVpRtRp1/lbBe0t2dqpdtGDRv6GVseMilVIqORdxLCFdQSshuZbPIRTiBilSOVZgQT6l8Ec=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Replace unnecessary dynamic allocation with a static one
Date:   Thu, 18 Mar 2021 23:46:34 -0400
Message-Id: <161612513553.25210.11895910880367586236.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310235951.GA108661@embeddedor>
References: <20210310235951.GA108661@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:46:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 281d3c95-e4a4-4417-af75-08d8ea89a2c7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4616238F335D25A4420A7FFD8E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZvWbQjG+5pkBYQelRY9riDhGTLZzGtheiN5WiXZrXd8V2GfB/gFdf/R2th/ix0MXXySfNWmMXWmTvpIUjzEyMgcso6IeX/akZYEfiiwlUjVk9NQNT1RGlLuDeWXicYo3r7dhEounXl6E+GjfY2Rn/e9cbDilZrJ5fSu0pMcHEG9Aud1D5JQfkZ/F1BFQfJ6uy7zUvml2ClyV4gpxgxDiJ9IdrfsOsoHJSXOa5Enmj7kJUib0X0rcJKcUBScGPQiB2fAX8BFzrLVpLuzm8k5xSPG7/InILxC9MpPB5OdO45WiO4cdTYNoEZQ8+RV8qqQFaB2fNOPnTQkQFJqJ1tCmeMqd1w88QuKARKPXJS6m4L/6AZ+g8Qfg+DEAMFkN0HqoLuoljkdtzOXINZcWu93JLp9hu3KDxpSi3oAqxGyjfaCLx33iBVrW0zP+Xbdk52V2SPhILzWpLjDhqP/WkjLjzeaEdE0GG6HF3hrAVNSks3G05W4MigEhwQv7i9BOLB3HouXftD470GH/VLdKe1X21qiaJhLh8UFI9wlABlSQ0HDnSbu5Z2SXkJQH1VyxLoSTHHitGw3oAFNZ204KZVyCEMve3StrryvDDpubdD/K48gvrrv7SC7OqnPRV7y0GMOw0fbjKNjD2WVLr8B8pBp9RJkKCzEwgVhpDZ1ueCQrX/trLu6p9Im6+66iEYMICEP3Vfc6cBVm09dm2fZbE0mdPKJoyj5rYE1gYFGzIP0laS5VzPyuZPYeDYcMn7RvFq/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(966005)(316002)(4326008)(478600001)(4744005)(6666004)(66556008)(8676002)(103116003)(38100700001)(8936002)(83380400001)(186003)(110136005)(36756003)(6486002)(16526019)(26005)(86362001)(5660300002)(956004)(2616005)(66946007)(52116002)(2906002)(66476007)(7696005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFFuWVpDU08zQjE0Nk5WYmMzblJ6TW1nV1lWUjQrQXBEdmI1QjVBNzFKTTRw?=
 =?utf-8?B?UEJPK2txVkYzWlFpQXM4WkkwWnlSdHVpUmJJUVRLZ2tRaS9uc0RWQWZScXND?=
 =?utf-8?B?dXZoejBUNGgzSE5RR0JJS3BCMTZBYXdVSmduQVpWTHh0MFh0eGV0VmdQenV1?=
 =?utf-8?B?WkdjYjU3cHp1S0tNRGtCQjlxTFZOK1J4Q1RheGFocG5CZ0cvS21JK3pPY0dh?=
 =?utf-8?B?ckhnZS9EK1BBOWpDMVlaaXErbXZTNnBOazZoMTJ4MG0vMkM1K2MxNVdkd2xD?=
 =?utf-8?B?b1BzVEkrUmFubkVHNW9DU3J2Nk5mTGFnQUIyalQ3bUlqRncvZ0J4NWI5d3Ew?=
 =?utf-8?B?aGpPazNtVTBjZU9xU1BrTG5jV1NqeGtwaTRpUDRMYlVQK3JUS0RDVUhmQ3VF?=
 =?utf-8?B?bk93TGJoenl3YU1TMHJtb29SNmhPQnJqcUpLeEd1MnkrcGtGZDZmYXQwTVNm?=
 =?utf-8?B?VXIzUmhoMlRXL0dIaHVmQ1ZTS2poeE9PcnNZMENIOWUwbkJ5Q1NJUFVYb3c1?=
 =?utf-8?B?Zk5UdGo1ZnFodkxjVmtKeHRUT2dzK0swbTJjSUd4M1lsUzdxQVA4T0pkM2l5?=
 =?utf-8?B?NlBONHhWZ3YxclJ5djlmSlVPdHl0VFN6djNPd25sVjZjNmJvZ25vYWVWZ2F6?=
 =?utf-8?B?ZUs3TTVwTE9RbS9EQjY5VXlrc2V6TnNrcHQ2aWRlUi9XSW9WSGMyRFZiVXR1?=
 =?utf-8?B?QjI3MlFwZ0NLKzBuT044MlpDVGxFbHczTWVndWNJeXJ6WCs2ODdmemIrR2R0?=
 =?utf-8?B?aHJQL2x5UHVjbllVYTlrYVU1eml2ZktlRVBBYk5jeExJejV3aGxSWU5mbnNY?=
 =?utf-8?B?ZzFDVVpRbFpXN0VEWncrYVhsandSVUJHcW5wM2V4WFBNNUZqVlY1V0pTeFl3?=
 =?utf-8?B?T3hBK1VRemRvdUVSNVltNC95R2RhKzlSUXlXK2kzd1FIbWltc3lUN2RTQ1U2?=
 =?utf-8?B?a1JrcVVVR1k0eVMzOS9BWUJsN3RCcTdZVFE2VUY4UkE5VGxieHBmdlNlUndu?=
 =?utf-8?B?SkNneFdLMWtBTVloTEMvbHRxMmJsOVBGSUUvR1ZXaFM2ZUF2amZIajRaTXBF?=
 =?utf-8?B?eGN4NDF3MTZ0UFU1cTB6b2Zhd1RJUXRJaElZdVZUY0FCKzI1UXBoQTBmQ2Jy?=
 =?utf-8?B?TXVINUs1WVFyVlpzWkFJRGVsNVErd1JFdVFYUUplaVJjVmZ4cmRBSGFTMWx2?=
 =?utf-8?B?aTlmSUd3QWQxcWZobGpobU9HV2FRcDdvQ09SN0xjQVpYeHZ5VnF0dm1iSDVC?=
 =?utf-8?B?YVNxYmRUS1NpMmV3enRKSG1RdHkxMytMbzVCWVNzZnpHcmZoYk1KZW5PcVRy?=
 =?utf-8?B?OTNDb1l0eCtpTmFQVndYT2NqczFGdjBmNnFpMjU2WXBEYjdIY25tak9WRlNs?=
 =?utf-8?B?WFY2TU5IZXJMNEZhWEdkbzRzNGgvNHNvRUxvYXZ6WFZPajNsbmhYT3JZVStp?=
 =?utf-8?B?bWkvUW5WZGpKMmh2eC8xZENIdDMydXZjckd0K3hlUlM5SlZKOUpvc05wVG55?=
 =?utf-8?B?WjNBTXhBd3F5VEhZNW1zZjFEbGc1NFh6YnhFQUxOZ09raHpWam95Mk9YWXRy?=
 =?utf-8?B?SHluQkNGZEZnZjJBcUF5WGxOYlNCMGV2c1ByT1RKU2xGdHF1d2Vmc296bXFR?=
 =?utf-8?B?YklFb3NkZUVJOENYUmZEM0hHY0QrSDI0ekxDbDZZSEpUZndoWmZUOWg0NTNB?=
 =?utf-8?B?c1lGVWVCK1J2aDlYSWtTTDRZY213aGpMdytEbG01R210cWZpa1BQdDIrTGRD?=
 =?utf-8?Q?SBZLynS4Ucjna4el+54ZZv/LUTSb/t/lrkLkUJB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281d3c95-e4a4-4417-af75-08d8ea89a2c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:53.7092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vn92wwnyTI66YdwOHq8j53TPS2w1zmEIIDeZHRSw2kRKtyliC/YVTnJm/iN8c8UYdy2PtM02LFp5/uySL7J26AYoHQNEuGOGYIurpL5+BbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 17:59:51 -0600, Gustavo A. R. Silva wrote:

> Dynamic memory allocation isn't actually needed and it can be
> replaced by statically allocating memory for struct object
> io_unit_pg3 with 36 hardcoded entries for its GPIOVal array.
> 
> Also, this helps the with ongoing efforts to enable -Warray-bounds
> by fixing the following warning:
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Replace unnecessary dynamic allocation with a static one
      https://git.kernel.org/mkp/scsi/c/a1c4d7741323

-- 
Martin K. Petersen	Oracle Linux Engineering
