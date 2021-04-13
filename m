Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D24C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858416128E
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbhDMFsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:48:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56582 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243542AbhDMFr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:47:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jdaj010030;
        Tue, 13 Apr 2021 05:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jrQeMueerMxHFydkaNi8rhJK1l7cf+VpdvEZxx76EFQ=;
 b=exmgrsp0kvxpAyls0oH0PlqSaOOsySjrssUJOtGOZBfzMVJ1PVXG1xsgWHzrtGf4IfsG
 J+SLVbY9S8taHwcawsB4/VsFrgolAQdIiknWE9XmXn4sK0+twqAtS0uBh7EoMEtYnl2E
 2RRqLj8peykYgB8TAi8+ZW4L6eRSDj91ObjVq/4UzE+pxR17MCxunKewKE5dPUBms2jM
 q3Ga3/BBCB4FptYAgmswFQEFMBstKwT1F2XWaEr1gQrLVYiEqOI5yglR0udpxkduWG8v
 8Tv4iKHDk4ujBsQlPX8NXkhSMaWdYagSHiL7zMbCbTuiosSuudtFgi0ibVO7MXX8IeC3 ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbdxfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:47:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jcXb125402;
        Tue, 13 Apr 2021 05:47:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 37unwybx1g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:47:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6B0+k3sPlhJ/HU6uaCSqm4wW6aUberdOdSLKK35YSLADbs4zwuNNfPIoHUiVFqaB3WtGxI//t81VfKYN/i88TtlD5ngaNwnABxUEgO0gth05i2sKXPvYNOxwWc6aSadL4bz62EPJmlpgcp6FowZ2k1f//3DlNLRGfL/o8ihPG8JRO0wVegZiH+9aIYXpV9g5nSgJuqiLN9eUkeeBpETZsptrTlIWaO8WA7jq1NQCRWxLv/+82BnV3EGAHYxbB2juTJ3kz6oncAEfB/TErqgBtQnpEAt7INBqR52Nr0gk3MMsOSevagTlnC1g8e5xIutgrPpeRjCY/3Kuz5abKGe4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrQeMueerMxHFydkaNi8rhJK1l7cf+VpdvEZxx76EFQ=;
 b=Y4PdpYsmknIOkcbj2QniruJra1vSLdev3ZRhQMdqgsxao538XA8FbU1Nk8hnGD548M+EIG/KH49FAn1dlfhxRjQaDq4Y0Qo1cwcS0VFi/Fa6NUTKcJ/e9z8YtD9GcgKlJHFhQFFjWAWCaEOhUp2/mG4VlZxkZpZZFfdiE+ygqo6T9I/+wQWYtSBgk9X244mQh9TIsVErLOybMUQipZa3RBJ/4v77eIVCZUWUvIXkKev331gl4WrYLoWdjt173UJWXyN2UWRagLrXqljdUh/9Gf8vPH5biMb8aq/6vMP1AjtQ4HbaqyI7NKGfeP165wTqUfWohcjguBVTNiuoJ+7WMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrQeMueerMxHFydkaNi8rhJK1l7cf+VpdvEZxx76EFQ=;
 b=OJ5gLko22WJ2LapF5J5VWPlho9dq11pVWhggS+X0BXakok0yzDOyn6FuJrTikTSMpXIDeObHGe8upJ3ONG8AegtiqhwtEpaj/k0ZrDJnbz7DaG3B46B2ZXBzSfoIlMpYbVdj8xcPG2s+ZoVRNfGEn7A7KykQZhZGAnYl5kgN4/U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:47:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:47:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com, cleech@redhat.com,
        lduncan@suse.com, Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: iscsi: fix iscsi cls conn state
Date:   Tue, 13 Apr 2021 01:47:27 -0400
Message-Id: <161828335261.26699.14446086099588675713.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406171746.5016-1-michael.christie@oracle.com>
References: <20210406171746.5016-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY3PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY3PR05CA0042.namprd05.prod.outlook.com (2603:10b6:a03:39b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Tue, 13 Apr 2021 05:47:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49e40625-e6f8-4d8a-d817-08d8fe3fa1ec
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614111433CFA516558B0FFE8E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6XWs2XdQLFGqjyeQLki0BY6lgdS05AWyBIG7xwTEbq7hMp1CErWF0BZQj91oz1IoYkfZYSPOPFF2vKeSITYLGdp6EhR56byutWL4CQRDGmuAJ9ZH9qn7/j5GD24SxdNOe5jk6MaKjsGs15OnzN6vNnjouyHDtSqNcCtGwxAR6KPu7OaTSLPiK15ilyd/mYZD5N3T3JNyI58abOUVojak27OyttM7lHrnZZx8GsxbS+3NmbBGOGBlW6QGxkciq2YdTolT8x3f62lfzlTBS4MnwBeRwD6OttnLlsC9E60Dd3lBSGuZ6VpTYn79stS27mxlzfVKgw7/jYLxgq8wKpZ5plICYoRWOF9eU6uyVY8evxW6wdj7LwGOmrntvhiFvxIMK4UvNgN57XNoHhRchho3f87YfRouh3kS3bWF9Pm1L4JmDZASX/v675mvkhB+Ua3gTLNvvKFI8697VgGzppZFsoOJHSi3wXO9gVkUZtOM7OFio/mO4u9kjSLO8XzNZdjy3LNkB7u48fL+UJ/DkwBVWmz69r9aO5Ko2nLmAG3BE7IhK+Hix/hE0L33TtNp+eH9q28GCFj5PNLWu4lC6a8PVFxfVKVl6m/+xPNRJ1sFJ/mWVln5UGhgxFEe55NXolGzSi3k1+ycSDcbOuHdQNmJUWJOxnASNAEqf9pHd6IuJb30vcZR9AAhZriPKFtZgWE8QYptn/h4gmcNWNPrAT6ue1nvTqvIpQe/r89ym+1o3MY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(4744005)(37006003)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(5660300002)(6862004)(107886003)(6666004)(66556008)(26005)(7696005)(956004)(6636002)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUEwek5JeldlR1RTNktQQ0hYaHlWWTBMdHBrM0wwazZtakdnQWNVQUtaUXZF?=
 =?utf-8?B?QkN4alZ0bkdxRkVsZmJXK1JUUlJuYVFDVUpSZTcwbnNFNHJyRkljR2lMOHNH?=
 =?utf-8?B?Y3BuZm9xUlNLMTcyS3RxRkNER3ZXOFFqK2lOSWNQWEM5K28vN205K1ZvcXEv?=
 =?utf-8?B?YVB2VUhFWFM2TFdQWXluMGhvT1hmOUZmbjZCSWI2YmdNcklSYXo1em9tSUlS?=
 =?utf-8?B?M013Mm9Fa2J6L2RUYno4dUxPUXFzT0xNWkpMYTVpY0ptY2VzTzRnaThaVVU3?=
 =?utf-8?B?czAzcWhPUlNiRUV1ZGtZZm5PemlMTEx4SWpLZEdRMmpScVBTYTdFZnpmZG5V?=
 =?utf-8?B?TGJOeDVjK2sreTFaQlFmTzhKNEVOem5UOVZ2MlpXNWRHRlpvZUt4MHA5R1lw?=
 =?utf-8?B?OXEvYnRIekx0cVJpdDNGREx4enBLVEE1a2NMS1NON0grK3R3dkZDYUFGTExP?=
 =?utf-8?B?ZnBpR2s3SGV0NmZUOEQwanhSQk4xRG4xZE55L25mc29iVy85bHVGREhEN2pZ?=
 =?utf-8?B?eGE2TzBYU2gxQVhKVHFxbjVyQWUxRkxNV2xTMnhvem1XNnIvc3BrekF0RkJz?=
 =?utf-8?B?L2N3cTRwYVpHVjRRcGlGTGtPN2VyU3ZnR0c0bWNBMWEzVmh1WkhOWHFmRE1l?=
 =?utf-8?B?MGRjdXhzQ3hacFBTd0tjRnRpbjFXejJTNDNjVTRRM01aaXpLNTRMWjUxOTlJ?=
 =?utf-8?B?aUtiUVkzV1Bhd0FHSXk2OFFLOXh0a2VFNUh6aE1wWDF0ZmhsSC92Wnp6aHdJ?=
 =?utf-8?B?RUZkLys3aHhMUVA3WWJsNGZSK0dleENZT0dEV2Q1RTE0V1R2Q1lvRUtvK3BK?=
 =?utf-8?B?VFNhVjVhZkgzYlhtSEUvaEVvNHg1cUFhZWI2MmxhQlIxbjkzcGIrZWU3ZndX?=
 =?utf-8?B?SUhnUDR6bDZYWW9mRTRNSzhrNWwxelMrQVh6QnprclBEb1pDeGhQSVc4ZVlB?=
 =?utf-8?B?alE3cWVuK251c0p3QTVTQUFIekhLNWttZjVjaHdSREZzYXpSNXZPeWJrRHBj?=
 =?utf-8?B?RmdqNXZmakxneFV5b1JrWklxbWJGd0VHcnRwZkNReWhyWTZXaDI0Q2dTdjFj?=
 =?utf-8?B?TlRVdDIwK2U4TXJOQU9rZUtSYmVCM1J4TXFjZlhpaHNLY3hkZktQcHNJY2R6?=
 =?utf-8?B?REppK010dnRvekplYjUrenNqYkJvcEVTa09mSGdkVUIvMWlQUFVTc3hYVVJs?=
 =?utf-8?B?VnlxaHFyN1dycjdGc0RGaXMyc2tReFcvVUY2cGFwVGFqWWpqTEs4b0tFdGpL?=
 =?utf-8?B?VzVrYUlESFVBNGdKRkFDNkJSNVFXb3lNQXc1OWIrUnR6QXNzS0hjTmhKUzVk?=
 =?utf-8?B?cnJIVGJMTTU5b1g1TDFzeHdJeG13eFNoajFkVTZpN1BvWDV0UGMxUU9UWC9p?=
 =?utf-8?B?aUVmL0lFQXVDU09BUkMzMVBzcjR1SUFzNEZvZ2VFOVFmTm1XdDdVU1U2ZGJG?=
 =?utf-8?B?amNpZ2h2Vk1rYzJsS3F0Z3Z0aVZRZDFaVy9pYlpWa0RTbjVIRWtzYlZBTHRJ?=
 =?utf-8?B?azZaT2hyK2JwWmtWK1VSb0orVVlrcXY4VkNEMWMvVVh2M1UybkI1MGUwQisr?=
 =?utf-8?B?WUhrNEd3Y09meE1VNnJFaXBaR3pQUXNqa2MzM2FRRXBONUNlZ1VkcEVIMUQy?=
 =?utf-8?B?YldHS3F5VWgrN0xLMnpsbjVLRkJRQmRkK0Z0RG1aS0hvTzRRS0J1NzBoRGk0?=
 =?utf-8?B?NEV1bkQrenpKL09ZSTNMUmdFdG4xeGhnYkRhUUdZTy9sK2NmUW95NzVCTG9z?=
 =?utf-8?Q?h9MdL9YxL84Pprhhzh5sqe80fOcmp8Tl6r9RvAe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e40625-e6f8-4d8a-d817-08d8fe3fa1ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:47:32.7974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bnF93JeLpWpeETQjOM4RQI74PDrzxFaa1euuTAvO5n5JVhHmrI4PXxRA/eRQDGsIBQIdIuOcJPpwAHMkd/lJg2DUVcdssG13tPK7YU0xHi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: HhlfNq9prg6pKYjwzdI8U3iHvdkQ9jo-
X-Proofpoint-ORIG-GUID: HhlfNq9prg6pKYjwzdI8U3iHvdkQ9jo-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Apr 2021 12:17:46 -0500, Mike Christie wrote:

> In commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login
> and sync thread") I missed that libiscsi was now setting the iscsi class
> state, and that patch ended up resetting the state during conn stoppage
> and using the wrong state value during ep_disconnect. This patch moves
> the setting of the class state to the class module and then fixes the two
> issues above.

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: iscsi: fix iscsi cls conn state
      https://git.kernel.org/mkp/scsi/c/0dcf8febcb7b

-- 
Martin K. Petersen	Oracle Linux Engineering
