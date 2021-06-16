Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B940C49EA5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02FD613C2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFPDvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59302 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231168AbhFPDv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3jde8005722;
        Wed, 16 Jun 2021 03:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=go3xrsiVIR3MkRn7h4tBNqCH1y506345/PQ9bZJwgak=;
 b=MZQ108XwmBmCcjVTKnE5VmhQPh33NcUzDHbylJnexrAsBHYLO+9r0Kaz11wBTXVRllnd
 ccTV3afDCOhb64h0nCA5OXhC4XHBn6sDhD6Xl0KTagGkuC8repCepdYtA0Hz64AgGCPf
 fCFz1hWD3W6FnvEWrdlH6x2opMZc7trl9KMVPl6/B5IbZVkTvX+5v3tO5MKL3Y0A9BOA
 xR/nCFcMKGlwsGEc3+B8t40FEvijcyfy1XK256Wa+l7LL5+T1ODLOwNMm8MErcl2UZ48
 23BgHl2ZaOOvlmKzEuEISqn8tWJrXPZPTL6UMPYvGMYDsZCCAzMjVlhQFIxevutIdcvE NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qstxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3ipkj064670;
        Wed, 16 Jun 2021 03:49:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 396wanasxa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RE5hzWsWybrR1hmHQBD+z8DOWz7TCm+gtb/O7k+QwQiJrhfdUyVznmijsa+WuwmGOLVfxeky8Kq20b5p9KZyJqc+UnEGr8L8kQ53Q4gEZnTUlDaGclXRgJPIbwZpsU7VJK5y7xEY2DwwFTG2J3cgRc916y+e5eFCZlpQUQ61CZsYk4exfhC295fVZBIb90m72ss7UfEiGG2wOzTYOBqG4bzaMZuXokxpTZ19eh19JHHmt8g2jbjBaw0XhqDcwND4RixMEA+f7pB2prhrMq4V8cOX+5KmPkYAHC46etQ2DS6Y942fNGlmaGvWhr/tlEF2NFVS8+QqjXY2+G1LClBpAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go3xrsiVIR3MkRn7h4tBNqCH1y506345/PQ9bZJwgak=;
 b=LaFbobgCh/JGvjXdobXRw5jyhgAz/ABBSdngc7NTFt1ek6/AnmckaYWxwQdoR8D2LEVUYvpU7PyxPWJJXSRHaKe+1gfolvkCI/yUa+YTdi01KRT/WPLFy3LJZBwTw0/wlsvGc4bF7XEmE1OIKbbWCb03EllyXgAHyNbfGl0mW4TpKf+M1Vvw+og6SJW2VhaJrVjvYZV3DTKCxDQbvjjotyQeQUs4zVSBedDFuLUVy0kmpLFQ0h3lsAuyJJPl129DG59LHoEpx0KLYH4ECQtaS4WgXmpCztjXhvu9h90WrSC/dlEG610mMw3t3FwWX4I2uvbhJKRAqE7mFQun/Ne01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go3xrsiVIR3MkRn7h4tBNqCH1y506345/PQ9bZJwgak=;
 b=IQG+8kecRKdU0VzqdxuTu4jFZ/08FpsnfdrTRs1iMCm9cNXLiSyRWLaXUs6u1G7dSuxte34C7bHJw9+Bj9eSEw1gRQG2itc4Dy6peN0l2lpgv+9zzhbc2MlxTRrhBwTEVKF6zO83fuZ8XauSVhIDaCX9AGf0DSkMPqyyrB/A7Pw=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH 1/2] scsi: mpi3mr: delete unnecessary NULL check
Date:   Tue, 15 Jun 2021 23:48:52 -0400
Message-Id: <162381524896.11966.10253531415079746073.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YMCJKgykDYtyvY44@mwanda>
References: <YMCJKgykDYtyvY44@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b4eaec-b826-4075-2ea7-08d93079b58e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663A23BFD78404597C3F1AD8E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkTxICgZO+NT+BWNgX0opfFTfrswLMtiGy+jeGY6UdQuvPwuTiCCzvHdOlUhfTnVraY+MAiVL45fq7ZLsg7/dxZzJ2Su2LgcF1tVypGltWTlNsmfsZrbf0SzVLvFtrk42aCFrJ0YQdsEhKqfOh0Mf+rXKPtZniBGLDVPIKAT6pYz7oShavssXSVH23tU8OwYJ88SmjuSTz8FWJOcB5WoW8WYwArfS/Z8oqyZUAzpwqE9Gt5bT3HNTw2pvGruNdCxfnXInLOEcbhF18464/PxP6IPjEirrtwHA1jFoswA2qQAl5xUwwUPVp/DUbc/J916dLSt2EKIT30OQTx7PWwzaFqlmmxcRAKauIXjqEJnY4iQLR0fDB6tgHcGL7+Z1CC/wWjvCREEnVcWgJrUF47m481KulJsLJ/A89PpzxrODXx05Mn/Ul5h7XWd1yaM1BFt+85ma9Yp7OIo3jDVh7UASX4D6JN4cg50bnXOB/JQRBYE12YVf7a6BtU2utfIsSLnTs97VH7Ujrejx1pThsMXjxwRg/Lv54rp27MlDV3krP91fbN0jnxKjuaMKhw6xTofjjfVjHEc0izK3Xtgsn2qzcmLdT0qBpLNw0aWk1hF/7q8Q5Rk16SDdTAcJIlr/+wdsoBqJ2IQ1ifazftLIV5lbe328g3MllIO/17LjQ9MPG3k4yoHcBdGhpakOaNYt9GMTriQIYBMkNV+cwoumTO3prvYpG+DIIRTBHSAMwi1DAtGFzEb6b53N1UiOI83rSzPgHhc9y2A36im+NIOvdryRRCr0N7mfdTU0YpeRSVp3xcBN2wM+SyKcUFuyxpIQA9znz03aOvrXTPi82jVxmo5Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(110136005)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXQ0aXJsemRiVE8waGtPOUFyYkhSUytTL3JxRE9LYUtzWGFKTHFEWTBtTm9O?=
 =?utf-8?B?Q2F0bGsvM2xWSDJ0dDlCL3hhV3FVMXk4ZlBDUENIOGNCNXd6UXpIbjdHRnl1?=
 =?utf-8?B?bXptMXhoVHpMbWtoaUdoQzF0Q2w2Y0doZmtWcTYwZTlrSnE2MURsVC9wbHNG?=
 =?utf-8?B?MXh3RWFiMXVPcmxvZGhXeWlVUENmT3BWZnJmdkJjMzRwQWtMRUNERmh0Yzll?=
 =?utf-8?B?ODRnenhjc3dGSi8wd1Y1dDBWWGZuN244Z1ZPWEZsSjFRd1dRTElsblJPTU1Z?=
 =?utf-8?B?TEEyOWF3M01YMmtkRnUzc3RUUDVkUUx3Szl5dUZzekhTTlcvL1kwY0NCcmVF?=
 =?utf-8?B?VnNPUXBlbG1ITzRBR1ZJQlhOemJIZnJQc0VEWXdtUzZtUzRXb093dU1JWTNI?=
 =?utf-8?B?c0Y4T1NpMkJ2cmp2MGEvYUR4YWlWaDRCNnNiTjRvZXVNY0l2THR4eWp6WGh5?=
 =?utf-8?B?Sm94bmtHa2ZqN05tNnhLbTE2OEhQY1cxdW1ldjF3Y2ZvTlp1U1poa2JwZXJq?=
 =?utf-8?B?eHQ5Sml6R1JqSzA3c3RLMkkvQzVVZk5mdDRvSWxTQlNjR0hoQkh5cUgwV2Fz?=
 =?utf-8?B?NnNlT1dKdk1DT2J6QU1SNVRmdTBvMy8zOVpMMzN6cmJVeHlmd1J6WlhQVlFE?=
 =?utf-8?B?WGJnNUw0U2pWNFNQSW0yaWJBVjBkY0N0WCthekpZaHVNS3ZUOEdjYkxGL3NI?=
 =?utf-8?B?b05vdU5IcURYV2NGMFdvK3g3ekZNRWxhTC9aN3lHTkZPaENNRzZRUE9iY1k0?=
 =?utf-8?B?a3dvOTRpeU82OHFra1ZKMm9LY296WXNvNWticWx3V3pYaTBHOHJDL0FjTVdu?=
 =?utf-8?B?OE52MkptUC80WkJBakJyZDZFVVZScDZtZHNDbHBFWHgrNGQxSXVWclBoZjJY?=
 =?utf-8?B?UlBFL1dmYm5BTFZlSWUvUGp5cGFxNGM3WnFveFVIS0ZJVWtRZWNmOVlEaGlP?=
 =?utf-8?B?V045OXJ6aS9mRnJtR0ZDWjFqZld4T1FyWFBkbFZaYUJjYTZlM3BzK1JLMWZF?=
 =?utf-8?B?MWJpUERZNm1Ob2Ftd1pHclR2dk5rRnJ4M1ZqZFpSWWVSSUlxWDlRTDBmcHcy?=
 =?utf-8?B?SUhMeDdLalNXaVJIeUgvWlA1WG1YWm1Rc0hwbk1qREpGZExHWDZkQnM5QnZE?=
 =?utf-8?B?MldaUklvNGZrSHdjeFM4dWFqcHR6cEJnam9LdDVIeG0zZUwxVzJlRVdVajAz?=
 =?utf-8?B?SnR4U3kzOEs0WjY3b0pZVWViZnc3TzFaSks5c01RRFdCTlVneUwrOEJlUGcr?=
 =?utf-8?B?QjF6dHRYSm5MZ3d1czBqWmVMcFZ4YzlyS0JsUW1mS2RISXFmRncrcEZyaWpa?=
 =?utf-8?B?NFgvY3lsWnRwWHlVWUV1WXRlaGowdVNOTWFndVRqOU9tOWhjYm9HN2tuaks5?=
 =?utf-8?B?MTFJSlR2RElxYzdjNzVJYXk4TmhTaXFGM3R2VVNmZmYxc3REcC9LS3VjTWZW?=
 =?utf-8?B?SFh2bVJYTFc3VnR1Z1NMS1E1ZUtwbW91OWRHUG1jUW1HVGQ3YnpHY1M1ekJZ?=
 =?utf-8?B?ZDljMDREeVNjeTJNcmN1dG9TSkxlaGZIZHhRZlh5UUFFY3VPbUtGcDhIWVFV?=
 =?utf-8?B?cURhc0NDNGtxem9lZTluc2NDMjArdCtWR0l4Z3FETURWRGREdHlwdUtPSjQ2?=
 =?utf-8?B?V04yTmZKeDJ4YlhKSWsxeHYyQmU5aEcvZlorWjl6YXVUWDgzV3FkV29xYzZj?=
 =?utf-8?B?T3JrUmxvVGJUUzE0Uk9lc3NoeG1EL0xFTjB3N0ZGeWt4cnQyK09QbFdoQVBD?=
 =?utf-8?Q?lvRyVlO4leKSmQUkxkakXYNKeLEYmKRSQTRmQb3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b4eaec-b826-4075-2ea7-08d93079b58e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:14.6657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAjZIfu3Mpb06gbMNKi0K+HXHYD0VzBTLfO5WBWDx3f/mIR+Y0rnR40871SdJBna0yF4fZtFZ5wGV8GfQ5SFD/PlG/0MKnUh128kNSZUXpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: bhAwb1C7motbE4HsgkFmcn_TWzrL6wZX
X-Proofpoint-GUID: bhAwb1C7motbE4HsgkFmcn_TWzrL6wZX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Jun 2021 12:26:02 +0300, Dan Carpenter wrote:

> The "mrioc->intr_info" pointer can't be NULL, but if it could then the
> second iteration through the loop would Oops.  Let's delete the
> confusing and impossible NULL check.

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: mpi3mr: delete unnecessary NULL check
      https://git.kernel.org/mkp/scsi/c/d46bdecd9f3c
[2/2] scsi: mpi3mr: Fix error handling in mpi3mr_setup_isr()
      https://git.kernel.org/mkp/scsi/c/2938bedd0efa

-- 
Martin K. Petersen	Oracle Linux Engineering
