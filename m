Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F7AC43214
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC69060FD7
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhHQDSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48788 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236991AbhHQDSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3CCpO032611;
        Tue, 17 Aug 2021 03:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nIWWdAqJ5b+YOy1AmYHKJ5AEuODxF8kmq7dzQinIFbc=;
 b=nV8NGFGhmnECWKGUJP4ZEn75xbIq/WkTCCi5zepLRNX4osNKcQ6mDVksWZcIa2wYCpT0
 cEuGkl/Qf2hnC9UogS3yyzkCL3hMy7lqFtc+PeNGReyO/9KngFgy+1W+jYlFIQgsc+Dm
 Ud6TG8HKR/SAmBtt47FOPiMstOBYe4jaJ45MqMu9LPJiOvX1dab3dhWDKhFHd4U33qU9
 1/4QNiMbJBq1V5+zNt6H3g3ek5WZycx5dlpJ5T834lv0dV4lK3O2kTlvex1WKimq9P5N
 1sraM9YN3Dw75e7ZJE02EePI4lrevcjaXfC1gIsS49vnpHcfvMGj5dowp9uqb7W/hu1e eg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nIWWdAqJ5b+YOy1AmYHKJ5AEuODxF8kmq7dzQinIFbc=;
 b=O5qYS+wj0jpkF6NfOCJXN0wFS7zpqzu2Ua5ag5RoCKb/uBi7VqR6iuKEapIpEnaHJqeD
 1LTtkCPqrb81Ftgc0pzooEzLQzdrQozj6mGYHgkCvHNne9vK/ByLRhuXoZj60wF78j9+
 bLOQFn8jwBhRncYKC9hvimflvKgXfHCh4BqrQN5cJAUjL2ole1xZ+lZ/pqo5cZwXEJKn
 CTBhnw1YsMgmpuxfKVA03wyvj/sYeSuWsNH5V1IEtyi5AlyPPVfKzWMvqI/aqT66Ob8R
 nDNSQ/waUED1k2W5srxHQYk7b7U9C+ULVj0cYlCcaqeyKX6MB5p9Sz4B94XWCDhvHYng lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af1q9bptm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3Al0a195432;
        Tue, 17 Aug 2021 03:17:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3020.oracle.com with ESMTP id 3ae5n6rge8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maNMGERT//hHioZjBppOZXRMuuFJ/FV5N0U6osVIjN/XOLWupraYY5EDppK9HxbsN5OLIIFT54PtFXzLs/6XfWqtB7MjBJ00/oC4uNYyxUZBftJ0R8G8HCQb6wxGakjxu3y0+gVoeRuEzuctR5Xq8QNiDnx4wZTVPVod+iOzUJL0A5Wl25sjVZ12tZ+W/skCffefbUm+jBln94KwrGQJpEOadSCY5JcqL3DEEKufv9e6KKN/aiWsIPOCwt+WR7wHTNpyR2PDnbs0MqsrrmIXr+SR99cVcGuGnrIXRVZ+ISJOvl57RO4mMetL60E9u7rW1ZnPS9ExojBTcezHak7uiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIWWdAqJ5b+YOy1AmYHKJ5AEuODxF8kmq7dzQinIFbc=;
 b=fcKQetxmWksHdl3r2M1+htYHIpg5kVDpV9mgVffMWq+OZmNXkavpPLMAx0rAevqmUnGDc9VSStujYcyTactaobyLs3mXw57jKeZOfQXp7OSahMYjz3WwSL89BGbHEOKwu/T4Y0oq6+4S1LlDjSE1oydGMQgWEgUM6oyBjbHSYltKcz8Ux7QPxA+YYX1yhwaNoEglJuckPb0g4yZHAQT3/W1RNOb83iwUU/lk8wb2piWk1RWrL/oLR/RfbggOeBut0lqsOvlSfrDFLg4UJFYZAAmr734ub6F6T4s1knfzAyHkBkLXyfTVifO4pVdyvHkVIrAZnA/Tg078d8IUEtCiJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIWWdAqJ5b+YOy1AmYHKJ5AEuODxF8kmq7dzQinIFbc=;
 b=VXjneoTWKyAKMhmUMWEtcS8tsOFAE8lo78ytxJRc0CmZcacLaMo39Q57v3GI0Er/YcnmTCrXRYRBfhEl8sd12LR5+p4/4mQwXPCyUlZDlhIyV9DqYu1jmSW4Fr5g0UcdroR9N6H/L1AoZqnuEjf5r4cUr0ciLgxXK9JzjlNDMnE=
Authentication-Results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:17:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Karan Tilak Kumar <kartilak@cisco.com>,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Sesidhar Baddela <sebaddel@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Remove redundant assignment to variable ret
Date:   Mon, 16 Aug 2021 23:17:37 -0400
Message-Id: <162916990042.4875.3450655556098051970.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806112313.12434-1-colin.king@canonical.com>
References: <20210806112313.12434-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8d03df-6e22-4d1b-8ea9-08d9612d990d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566D68910BC75B8FFAEF9EF8EFE9@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r1rFRfS7E2qWrsAp3aBcB21NLafbe5xy3afp5y76CLlmhqLe9oCu5EKkVaLfMrPe9gLUNABDWQKuWNETBDj2Y7KwohoftuJggmHEcmU/3Yv7MYLyydHQZp/dYp9QY6jik8+TME89FOgkm9iQ1VIzshsVwOPR7fuIsw2n9C7TmhCwQLrOd3LdL/8uVgKmBPptLHcr00wxp+fsjdp+RHm5SihvCTvfc/RXZo0V7zBhNHzyPzkfnrNg7yhElO6mzuhmSG5GPdm7CfcPy+HgkA1o3mnHydyNvJ+L87TOgCWpWrM5MDQNoJtBgSMNaLA1pWsG80+fl4ZDuE/eXtsBxCnbmZ5aTZPNuLBZqzvT1vFR12IkvirTqxI5gtIHx5UQVpp2FlxhAAfyo3Y6GqO8KKPTNUtaIpdgu6Re0r5bbq+dqS/mJ9frm4cEq42hVLJlCQz3fNvnq7alQLpV1NEzhvEj2oUANq3laHU19KdECITEbCOH7qlRRaoumaMO41Th/0xLH26xCenS0EDUDcG1QMVCK3bUVGIhopwukMj7Dd+G8IqDJJCAdf038Y363tyT/pUfBFZmSnE9Hq78AGsV1u7x5b/THDvCRXSGIyaf+5T31eS0GQQt3J/eMbsaaSzfuQEqi3S+5rA6N/D7vTs9d6yFmrCuVyxwGGQqDyBOKrVHYy4pjy6+6NBNdb/OBz5DYzgP1kypMOLeKNJRQg8sOChhDvOys4iOxdAMxIyYeTlVfsByReUFzPMXV1tiq4vzVl4KyKgvbVoAo2c6MKB3QxqZVTsz1TdGFQmZl4DbN3tbuN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(6486002)(52116002)(7696005)(4326008)(66556008)(66476007)(66946007)(6666004)(5660300002)(2906002)(86362001)(186003)(38350700002)(8676002)(4744005)(26005)(36756003)(2616005)(316002)(956004)(38100700002)(110136005)(103116003)(966005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTMwU1BhZjZCMGJieWsrbkp5ZXVrQ0FwQlQ3Z0s3SVBHYnB1MGV5UVlJODZV?=
 =?utf-8?B?b3NGcFljM1ordlJvdHBkTWpRTm5TL2tWWGx2ajRJbVRXQlNWQ0hDN3ZpWmlT?=
 =?utf-8?B?K3l2dVp3ZXRuNmR1YnZXVlB3a3loV0ZNT21YK0I5SGRsZlVKb1kyV2g4UU1p?=
 =?utf-8?B?RWtNY2NLcU5XNzQvalMzSTNsek5xTEtHdVE4cEgyM2ttSitTM09kQzhxc3ZN?=
 =?utf-8?B?eVdHa21TK083WFdYaDJhR0wyaUJ0V0o4WnZRbCt3ek9KdjlxSnlvbUU3QUNt?=
 =?utf-8?B?cXBBREtCa1N4bHRTc3d4bnQ4SWxUN3FRTlgxajRDSGdXd05rZGY4bThhVTVy?=
 =?utf-8?B?QVBta1NabW01QU03cU13TGpBSjdKc0dKbWFkdVl5RU9JL1hpcVZWTTVLbjZW?=
 =?utf-8?B?dHQ3Wmo5UnYwKzVEZkhnWmptSnFGWUc4cEtYK3pEbjdyVzk0QkNBSndyd0hl?=
 =?utf-8?B?c21WZzJDSGZLK2huQmJaVFEwa0FHRkJZK2JZMGlIKzdXclBxNGI2NzJ2dXdS?=
 =?utf-8?B?NnhBcURaem5GNUJ6NWYrem9lL0VlRHRxUHh0VVd6SGZ2U0VpM1RIQitPQ1RW?=
 =?utf-8?B?UXhhRStnTHMyeUdENXZUbUFLT2I3Y0FoTThMWGdsYjErWVZkQXhUaHJPelhv?=
 =?utf-8?B?VWN2VkFkcXZwenN6QmJkOWF5T1RaeHowZFo2bDI3UnVXRC9Yd0RUNmFLeFRr?=
 =?utf-8?B?NXg2SnhPT1MxVFVUblRYSDQ5QWM5RG42UEM0N0hhdGh3SlRPNVZ2SVgzOUVP?=
 =?utf-8?B?RVQ0WFpQMVo5ZUQyeXVMOWdoSHB0ak53QktYZnBsZTVURWdmaWtjUWl0Nklo?=
 =?utf-8?B?MUNuZ1U2b256ODlLSjBJYy9RQ3orZzhZLzdSemNRc3JaSnZrUElQTy9ONDgy?=
 =?utf-8?B?OFBYeVFBVm9ZeWM2bll4WURITm1XcVZ5MWxGY1hLODZOQm0rTGwzT2hVRG80?=
 =?utf-8?B?cTVjY3drZlR1SHNMWlRIcUE4RnlBcEpoOXNoS2ZFa3EzTzVzMGE3WjJnaFdQ?=
 =?utf-8?B?eUZYZ0tJRHNEbVo0emdoYm5WZkhJVEdGTm9pQXlFeDRvRG12OUJ0WFBiMXRo?=
 =?utf-8?B?NDBoWGd0WEJSeWhJWFArcS9pVzlKcTFZSHRDbXhlNkVVcHN5UXhVOGlubXh0?=
 =?utf-8?B?TmJOOGgwKzBlSkNTSitYZ3BZSlJxNkNYQUxjYnN2WVhGME1DUTF5d2s1Y2Ny?=
 =?utf-8?B?WHRZcEJ3d29xVmRJc2RIdC9XU3NaUmlsdUVHSUhzRTBsTkRmN1dDYmRiWHh1?=
 =?utf-8?B?N0J2b25sZUtmVG1XTVB1dDRkVzJiYlhWTmlRMmphaENqaFVIUzBmVEhGUm1r?=
 =?utf-8?B?TGRmckNqL3pKTWk3bEs4MStON2hNc1lNUm5nbzdpcmFXSUkwek1PeHB0NC80?=
 =?utf-8?B?UTV1MmN4M2gxZjFGN0hTbEJGVFRSMFVsUUxveG9HUnR2VWlPU1NzQVYzNVdG?=
 =?utf-8?B?UDhkd2Y1UWlMSG1CeFVWTXEyZVp4RlFXTzNzT1BjUUZqdUgzczhBNWw1ckNI?=
 =?utf-8?B?Mng5OVBDbldTYXVIYjl1T3BsK2hiMnlPcFp4ZTFvMTlMeHpYNFlMWldtZTBo?=
 =?utf-8?B?N2hUWDJhQmlRbXMzQUs5MDQwVlBqTUxQL2NoWS9WTDVmMXhkejYxbkMvVzdT?=
 =?utf-8?B?WlkzdGwyVWZ0ZXRuOWdSQWNVS01XSGF3bDloMGliWjdjdDN5eE9qNDYrbFJh?=
 =?utf-8?B?Q0ZBVVQ3WGRiZzZ6ZE12OXZEWTVqM2JUU1c5OElIU2V6L0h4L0Qzd3VmNVpV?=
 =?utf-8?Q?obFnzOtBJ6AMx4n3W8Shhx//+qb7qsCUIn5IQgF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af8d03df-6e22-4d1b-8ea9-08d9612d990d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:52.0762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yK7jU+bOh4tXomQv7hiRdXWSFujdiynEw7fXLRBPhBYjEkuozAW+0kTurKEzbVhIaG8d7ZElPKv9sNGcZq9DebHbtDzVaQIJhiU+V5Qd55M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: Fxaoteo2EOpWqUUTeJuxZHkpk453MJv0
X-Proofpoint-ORIG-GUID: Fxaoteo2EOpWqUUTeJuxZHkpk453MJv0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 Aug 2021 12:23:13 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never read,
> the assignment is redundant and can be removed.
> 
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: snic: Remove redundant assignment to variable ret
      https://git.kernel.org/mkp/scsi/c/e9b1adb7c5e3

-- 
Martin K. Petersen	Oracle Linux Engineering
