Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0DFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C98096109F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhIVErh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30070 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231976AbhIVErT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:19 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4ZpDC027991;
        Wed, 22 Sep 2021 04:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4yHkBCvIkptxML65agggPRTGwuvl05pJW+GLoBdRpmI=;
 b=inYTspdAimWcGXBcd9jIldqFQqgmbQP41S5mbOELtCpfmHyfgoMSn0th+wCdFgef1mCh
 gMnctLiSNpssiW3N9VKYhEcJCt/cwQ2cJpW+avWUfmL9fhyVo42dHrSw9hkImsV0WUtd
 FXaNpX3qZFO5SmvSIzyLtuttdZKNj/wwvn5L3nj5E41l3GWAvy2Gl46cRVsEzAvCRUBy
 jFJKlEf24eqYdOXlNLK3wSOW2/QE1cr0FhlteENiohNfD/SxFXP3Kp6b4QzyKlTDdv+A
 qx9FYh1h2JiN7/gpyhOG/Z6akm6fbwiMpcpLc5RQaoKEmIqIs3wXVi2vKYT4SWYc0Qz+ YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9d8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4imvK117636;
        Wed, 22 Sep 2021 04:45:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 3b7q5a3ry1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHNUS6ibM7ubCRVRVWISup4oNzvw2tmS+G+FHbp06vVKh9u9Wmx9vESH97EoBft2sCOWWXHBctCdccjgtwubIzkDnutbwZJBPgZrs55FGII89SEFkJj+E7yWmIIapZtw9Bmeiou1IZgMSWetSxxsEnjrZQdDaqe9/ww9z9srKNMLGzuMdwaY+VuUEIyKg3ohOVrvQ17yC5s1xNMnJMvqy5CbimSBf8/979DZ43p3flhpWorPvmiD5yxLAeQwimihOh1FJX0DVVyxn8DscbKxXwRYVdiD7XpWiVF1wBukYLhWJNSOhLaGZmkYDrro5CaySLN1/ceuEvBkrNc7RQjVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4yHkBCvIkptxML65agggPRTGwuvl05pJW+GLoBdRpmI=;
 b=L6gWVkfSi+bIiPeaH55z9q3nQPxdWkS1KZqTefkm2sX8tYGUabz5cOUNsFMbSUPhmXK5qR3B0LYjkiC4k/RTbnJg4/ZIl8QF1oPDUZBPv/7GkomhCRVkPN2x9D8f3LBrYwE8FUAZephrCzAUG50/O94ijtlR5NAREbTsb1XN1/jfDfyCZlPd7iHplwVKwcGqWcpbe4tjrerDFn4VkuWLzwgo4o3xoP1YonhPsBk417LI6AuwiywmO+upuKddRDHwau4PrfyI89b2Ts9+UlBce6SHDpsan2QpRN3CpdXJjGi4LqI3WzPTtzHcPGB1jSIC98PrUvRr75kOd7Capk+I/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yHkBCvIkptxML65agggPRTGwuvl05pJW+GLoBdRpmI=;
 b=CoED6Z2Zf+QVAJBathTY/J8OVy5zBiz1bz71S2VSDZBkhoqmRxas2gqoNkxnEryd3WIOGiqC7NJnwoYXtBk7pT57ItLJRqPjGbwO4dsaoRVmMu5ogiylc2e8A2KMcciyze6hZ6oy5YM46e62xDO7YmGiUWarEZk2AYd9mIZHPaw=
Authentication-Results: gmx.com; dkim=none (message not signed)
 header.d=none;gmx.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Len Baker <len.baker@gmx.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        target-devel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: elx: libefc: Prefer kcalloc over open coded arithmetic
Date:   Wed, 22 Sep 2021 00:45:21 -0400
Message-Id: <163228527480.25516.16772825174305781427.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210905062448.6587-1-len.baker@gmx.com>
References: <20210905062448.6587-1-len.baker@gmx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cab41a42-76f1-444a-6019-08d97d83d217
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4456D7E142522D4AE0117F718EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzCK+I2jEZkopVDetiOQu0TP/4LCkgTvTDSzX1JhfqQE+ECfiLv3tI5U4a6VtCZogOUKn+kMOS+sTPE3eHqcJoA9YJHQfZ+YdU08nzbKoPzdJcGyosJREWF35IfAIUBorDYVzl3OS+1U3GHNSzKgfECJuVR+/li6qoQPAtO2vpF35phwYIQlzzRrO6slh3rKM3fZXt1BLaPk50x+R4CzJWEJLP0MbZ4QqCk1pdIrU0+cI8EAmTpBB1FEcv3utn6L6KgURav/tKlid3tqgL+gzY89OnXmIH55908DbQJ71ZzWgQZwNUYn1svm1WGC8k+4l6rlA4/22xqFQWozk1UYQ8vF2KCYdbPlxzuufaV+HjEx4VekkBF3Qqt2RZ0CXMDJtprd2dRTvmMSYFHVhZxXKOR0vtsMB6SVZD1XmmOLZsBa//By/NqKfWLDgdOwv1NbLxg6gM4BDeuqGqTxW1X1pjUPJ9zdsI+3d9uKhBJOQ9xYVtEZsgiXyRYA35CcZII/4I6PPKYmCfmWDgy4dpfYnq+VL602iVoe5deNb5Bb7dDrnUL7QgFpp5QOmKfI05ZOyC93geffdYvR9aDsz+ycygr+KAoQj50GhELnUTCgKVsaeiOrWOa7BXcF6CSadUV3w0tyyUqlrCJrnDYWSF9G4DT+w8vWvN0+BjaGB776+HaIXjw0jcbbJeWsmsiMzivNMq+L+9iAThJDY2CTV3p0KivZl3FBXhNa43Q1Z+lnCLBowvA9Q7jkAXk3R4Pf8xcdYrp2irkvvQYYNFDV51vGQ606Pko/hh7rPtEQeMGQxK0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(966005)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7416002)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(110136005)(54906003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SCt1bjNsbXpjRkFQeVRwdzRGRzZENi95NEpRbXhrMXRBeUx3S3NGNkVkTE9k?=
 =?utf-8?B?SzlmL1pQZmhjcWFhSlF3c3dTYVdORXpBTnVET3lVYm4zZjlLZHdRcWsxWUNS?=
 =?utf-8?B?N2h0TE9MS0Jyd0wxUXZsSlNVT01MeHlDK1N2REc5Z3cyRnRxVE42a0l4bldk?=
 =?utf-8?B?ZGF3NjVvRXZmNjNsWTRiUTBsM3A4bmlaMERxbTBxTWE3WjdkN0FjQTZvMWZB?=
 =?utf-8?B?S1VZQ1hsTk9uTU13c0VDNXdOK1lJUzdHZ1BzWDdKZGJZbU41YXRueGNYZ3NL?=
 =?utf-8?B?M2U0dURtTEs0dWdwSjdzNTBLYlpZLzBJeGFlVENwZk1NT1hRNGdVbjc3YUpw?=
 =?utf-8?B?V3E4OVVQZ2NZZ3IrL3ZwRmlMNW9DMitOWHFHUkZCd2ljMENzcW4vbDNQSGlQ?=
 =?utf-8?B?Q29iKzR3N2dkVXEvUjFuTFBCWWxBNHVxbjkrZkdXQWp6T3RGellvYTBrMWMw?=
 =?utf-8?B?ZDJrWko1YlpybFkxUTZJdnQ0eGNMbjhuK0oyMmpyR2dncUp6RGJvR3h1a0JP?=
 =?utf-8?B?TFVmaFNWM0dVck91TGNzbHowZXRlYlIzaXk2dWRpTm1VMUo0Z2VlL1hKV2Jy?=
 =?utf-8?B?elNEYzBuYjhZSjRBMHU3RGFqRWEvK0NDT0cwZkJ3UXBuMkJqZXhxdGR5eVMz?=
 =?utf-8?B?R0ZZNmhQQlNhUFU3TW5USnlSZENXUS9ZbDJaTjJEbFN4M1BuOXBnRlJmNWJp?=
 =?utf-8?B?cTBRMEVWb1h2NmUyL0ZCN09yZGM3K1oyUkplMW5LaU1icmoyOWVIeDVoUTE4?=
 =?utf-8?B?a05KN2J4SXJ3bTJ5NTAyTWhjNjBtRTVndlhmZmkwRFFzRDZid1VOY21IVmpY?=
 =?utf-8?B?UVBIVWdLUnQ1ZEE2NTlUOHJUNUQ5eThqbzJWNUs1YmZXc0JvVm5RSHNwc3du?=
 =?utf-8?B?bitBQ2FadGhXNExmYXhxeW5nRjlUK0htVDN4YVJvQ0NUZ3k4ekV0UWowQk9r?=
 =?utf-8?B?NmYzL0pzRm5HckMwOG8wWVI3WmFMd1Z4cU1pbTRSOUdGRXZUdTFEYTFFVVlM?=
 =?utf-8?B?VmhnT0dBOEdXeTllZExMWTV3Q2NDdGZSM3o2YURrWUZEWFFvbitsK2Q2SHNs?=
 =?utf-8?B?ZWx2UHNHZ0FsYmcvR2txeklTZXkvbTY3T0I4TE1lR0NaaktFYm9CUDhaQmRR?=
 =?utf-8?B?SitKc3V0enZnTU41czBONGdjdkVEM1JjMHRyZVQybkw2bjN0b3ZYMVp2Q24x?=
 =?utf-8?B?MkRCejIreC8vMWZIS0ZMalVjSWx0Z0lnaUswRkFQaUZ4WVhqcHdvZTlzN3RX?=
 =?utf-8?B?M2djQUJreklCYllzVnBwNG5MeUNIMkNwWEl6SS82ZWpyQi9yaXdzRVQ2OEsr?=
 =?utf-8?B?R0NsaEZjYlNTb1AreU0raGhJdUhhVzByeE9hTGgvY1AzNFI3WGpFNmpBMGov?=
 =?utf-8?B?SmhKQ25BYkxCTktGTW9NdFlORVlyaVdkKzV6dDlzaG81aGx1SUFHWXFiSnQv?=
 =?utf-8?B?ZFJKdHJTbHJqQytBcEhJTUdweWtHSVd1M0l4eDczMW1JVGZhczFUTWZNQ0Z3?=
 =?utf-8?B?cHpvMlFxUytXZ3hjQkQ2Z3NCSzZLV3J5cVhNMFBUcytaY2RpS1RLYlUzNDJG?=
 =?utf-8?B?Zjc1SHpsdlpXUzdWZ0F4TjFrV1o5eXdjOHZ4Q2I4U0ZEMFMvVDFqcktYYmoy?=
 =?utf-8?B?VDhGNHdMWWIweXQwSnhCNFp5aTVrenBzNTE0MlBxL0NlaERtUDRxTkx2YXA2?=
 =?utf-8?B?b3BmWlZMSTY4UWtiVm1hZDZWNk9mVXZhR01PdXhxVUZGRWZUcVdkRE5lNldo?=
 =?utf-8?Q?IusRvVI+DQ9JcF18qhknu3fPghkhvIWCSo82q77?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab41a42-76f1-444a-6019-08d97d83d217
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:37.0054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oB40l12amGwds45bin2+PorVs7hyV+ayAPfMJ0v6jA67cju1eTYFBDA8LBrAKtI1rxV24fdg9Ce4jL8ofr6nSxz1JAngai56gXM5y/mY9Gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=829 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: lXy7zmNDOnqOQPzVbwkCBLtm-NBovlGe
X-Proofpoint-ORIG-GUID: lXy7zmNDOnqOQPzVbwkCBLtm-NBovlGe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 5 Sep 2021 08:24:48 +0200, Len Baker wrote:

> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: elx: libefc: Prefer kcalloc over open coded arithmetic
      https://git.kernel.org/mkp/scsi/c/0a5e20fc8ca7

-- 
Martin K. Petersen	Oracle Linux Engineering
