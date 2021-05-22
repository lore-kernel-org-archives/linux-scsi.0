Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55C1C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD9D6135A
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhEVEme (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:32980 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhEVEmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4a20Z020424;
        Sat, 22 May 2021 04:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xF5rhCMcN5DxmOJxKFTBxYCpTHxKdtxzaTDwTYwO6d0=;
 b=xVmU/++vrWsBOTLG7Gw8weAqKC/lAjEZzQJ1GrAOW1AMvuRIL+PoOYFKXQnx9VYJbgrv
 e8SnUI68atomC/l7zlsBJXJJi8C393ZEjnUg2itxepMxCb7HyeCpenegKXxjx0uhlyyN
 G9rrxANL23iJUQ7QKKBGsvmb5zQZEgZqUzGu1AUoEAJxXhYBk4hMMh0Up8oHUw/Gfmp8
 hzVdmXUA7c2W5oWqNmwi8NXMdnYGqIC6zQY4dr6e3VVcT7Tnjnd+a9+ltuwPbKBpiScV
 ybWzLe7V4dLbndAs4fDJlbDsEcZ10c/mMgWwxEBQpQgSNz1tfOq3DZmYlbHYhvqvc4M4 nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfc846v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4aljL072530;
        Sat, 22 May 2021 04:40:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 38pq2rp5bv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY/IPLVJ98H1HgRKbRfzjEFg9+4BfW2PbyPTGsdMHFhCX6A5GyvJaNPFwqRjU17atXWRTBY1lhdRo2oI/F6aD1DZwrECNz+sNdusLMs3iCeyXgprObkhD72N8JGXlZJzjneMtyq78fBOo5o134S86B+azeNJqimjKMjexs6WTPh7ZsD9b+lsrHN6n9UGJmTb5UWMVUX8D/aJ75Jev13gayMaoAU1Eod71pGE+gu5l+t68aVWpZaRZmpofxjpbGZ30roOwDJrJ5PgmQHECd3z6BUgATZ5qubzICwB927pkKySZwPwRXFSjixbk6+aadY0mByrtkm2yrvjgh8XiJUybA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xF5rhCMcN5DxmOJxKFTBxYCpTHxKdtxzaTDwTYwO6d0=;
 b=eEBL6vcOKNho88VYi2/QAxWY8x7xd+XkFfNOSwrigThXWUp2AFMocqJX5JwVLQe6pyixy2r+XuilVQr3vly9RfrlGTumRpjhu255377oZKZfnUnvNJsjty/QV5NozdDWh39spY1bt1VlV/MKj1+1PAVEJjShJ/PZ+0L0JMZUXKY46nTIuGRodDzLOI11ciDdVznFpkdNT/mu9vR5VlEBcah0BRg+r/nPYAohSs2EBIblRLXvcswk6DAYRAqkk3K8lboofMGvtSgKzgGghXuTf6QiDcdfFdQhx+ps9sFHDoeBbMNbxTwFPDOJncWA5Pa24EBU8w7SvjXxKg0hJIm5Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xF5rhCMcN5DxmOJxKFTBxYCpTHxKdtxzaTDwTYwO6d0=;
 b=nPMuHg2aRWARDkyZtX3zlV4FVWjFHZzYMhTurf/p0Fv8cD42hW84QUi25drg/ftfezX/IuhqqqIwm9tbCaVnQb0Hy3TKB1bZ6ZbIWpNE/l43r3imtC8hbz9HmK+oYj9WBAEZNMlW+YUn86u+AE2YcBs0edDAbyeJSoRA9isFGsY=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        john.garry@huawei.com, jejb@linux.ibm.com, luojiaxing@huawei.com,
        chenxiang66@hisilicon.com
Subject: Re: [PATCH -next resend] scsi: hisi_sas: drop free_irq of devm_request_irq allocated irq
Date:   Sat, 22 May 2021 00:40:38 -0400
Message-Id: <162165838888.5676.11334211615721778971.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519130519.2661938-1-yangyingliang@huawei.com>
References: <20210519130519.2661938-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb7b43cc-d31a-4cfc-17b8-08d91cdbc696
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5481F56630F97FE9F73245068E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QOwUdivbmlA5lzoWDOrK4Zj/wm3GnA4DsGeOQEn2U+rOu2bTP0VhgzrCH7o45TSUAVp2+21Wz+zk2uMIhsenuQFk6UO0m5LHP7Xvnfz8GbNPnkfdHPUT9pACaRHnimy/fdFhIWlsTEp6iwtpBeiGNjMotbZnIMHuTQvxQ4i490seLG4HCSjSLVz7L3FQBRgpjTLFHjxnUz0/I8T3jgAP+IUVzRuCusLn64itb0aOrzbglwHlFZpU4EPyA6WoJCwb7sQ52wvyJpXzrIZiXV5y+JsLPvrwkchNtJrDJtAO9uB6TOnddlqBkgKN6JkNxLwaS335boCL42PeHPKV3VfP0YV0jtLxFdL8152DOyuTBxEI5SPEsWOpcFxBEQC4q/I2GdlNWy42AbM35mwcMj30sSjvhFI57g9teBNFnne8CETBd5e50QZtDo9jj+OKv0SX5LfIk0KJZWg6FNoAxVd0Kc0CzHtedW/8+Yu9kgwrxaUZ1Dm3sJnpYJ+BV+cVGYBda7m4kwphrMv4HOD5iTOeauQRLYWxkD/QH5s5qn63+F54i5gEPTJaTaek/OZR8CWkf152PvXAxgsjUrdiVN9RB1zc0oVAPnb3cfDxfmPvyYH0Bh/OTBrhSlURdmYcEw/cW2f30XkSjXWn233Fsz1SqWXM27m5T4tQDyML5u+Se0vhdghGMqEeLKme9aGRNd6EZD4WXRooBVihGtbBBXStbbRt4pEC7c3CkNrTbmYbILKPYQqf2eUOy2dABXi5T9BIBKx2mFj7Zp7Qkm5I3xkGNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MnR2Q2ovYWRUSEp6YmkydmpETWp5TFk2dmVYV25LSktNR1hhcFFTOWJlRk1r?=
 =?utf-8?B?eXZTTUNJMnRnaUlreW1DZ3luV09tUUpla1VWNzM5ZVVod1ZKVWNZcjlva2VW?=
 =?utf-8?B?ZCtHeDJ3aXlQVVpGTXhCWDA3akZWYUFNZjh3WDNMdEFLWUl5M2xLUFFNOTVp?=
 =?utf-8?B?TjhMeDlOeFBMRks3bHRxKzluS2ZPeXNpTzk4Y2N4N1dlU1doTXdlMzYyelBV?=
 =?utf-8?B?Ymx0M2NXK2xtOEF1emNKUCtPUGhTRkE0c3RHdFlLVDVqM1dlVDMxYUlsMWsv?=
 =?utf-8?B?Y1haQW9mWThYTjFibG5qT29wQW9wYU4zT3E5c2ZERmhMekZhWnZqYnJEVE9s?=
 =?utf-8?B?eWVoQ2NoSG9MdWtKK1NSbWM5NXkrMHdzeEVMU0pFOXZGSWRSSTh5Z0x4OUF5?=
 =?utf-8?B?ZG9HeFJ4REJQbm1rTHpOKzhVZ0R0bjVXRmJLNTdTeUg2MHJLT0VRR3o3TWxF?=
 =?utf-8?B?cyt1akREUDVaZ290bGxjd3NZNUcrRVdQSTJja0lOZFF5NHhtSGFQQVNYWVhq?=
 =?utf-8?B?TmZJU2xjNVJqb3dMUHgyMWwyMmYydkNDZzg4SG9wbWZZdVdGOFd3ZVBUdVFu?=
 =?utf-8?B?VTRWMmRzTHlyL2x0dlppaTJ3YzRhTytMaGoxL01qaXdmY1NiM09EQ3h6ZUx1?=
 =?utf-8?B?ckVrZnBMbHg2Y212OTZ6YUdMdS9CUVgwZEh4Q3JPcndlMXdVMnI1dlVkZmpo?=
 =?utf-8?B?ejVUU0ZTRGdMdUdQSCtSR3VnMTdBOGxLZEx0b01wL3RwOHdrOW9OejdrZVFS?=
 =?utf-8?B?TVJhRDZ5TUZQTzFrUXUyNnpWQXJkUkYxMkZWeno0a1dic3k2R2tCSy9FbEZN?=
 =?utf-8?B?TmVjbG1YZUZBYkxuSzJYMUlYUjRyM1YvbFZxYXlYdkw2S2NBV3QzZzU3L2I2?=
 =?utf-8?B?TWJYN01nMTYwZ285K0Z2TXZkZDZTMjZxTTl5Y0NUaEkzNUxsTUJUM1AzRTgw?=
 =?utf-8?B?RTZITGFGQzhGR29NbTYva3dNbEFaRXVsR0xxaFZUY0grQXdYQm94TlV5ZzFl?=
 =?utf-8?B?ZkM0eHFjdEl2b05FWHpmQ21TL25rWnRVdzNLeHRiUmdNbTZLM3pvSnoyb243?=
 =?utf-8?B?RHZxVHZIcHNwWm9zYTU0VjdLOXp4ZGNzcWFWaWxyaHdsbWJ6QVVsdzRmL2Fh?=
 =?utf-8?B?bkVqQUZUTmVHbDNtbW1SdkF4RGVualVHcG4wRnZyV1oxM25MVDJGM0RieTRs?=
 =?utf-8?B?MU1CRTVWaUR2K0pZbVFjWi9GOEJ4VE9FT3VPTzZ2bWE3ZXVacjhVK2Rydk9K?=
 =?utf-8?B?NnhCd3ppTU80UTJmeU1OT0hJSTR1MFNuY085YkRTK3AwU0Q1R0RBbVhmV1VM?=
 =?utf-8?B?Z01hUGNNSlBKM0VxeDZoZ0ZlcHVibXpiMkZFWmNhZWZyM0ZIZnZuRUFBbkJG?=
 =?utf-8?B?TTVJZEJDekdXbis1dndTVUEyeWJSTFUxNEp3dFI0WXdFZ25lajNkejNMeXdj?=
 =?utf-8?B?K1pIWnhESDhDd0lSYTZydEhFWW5sdm11dkdPVG5LNWdHMk5sL0t1Q1FmZjcz?=
 =?utf-8?B?anBPczlwWFJBaGZ1blhKUDNpdk1DdGFaQzFXV3ZFbEx4ZjIzQzRzNk82dytY?=
 =?utf-8?B?ZUcweW5NWHJJMHdncE5XbWFYRUJoUi94T1U0eUxNNXhpVjV1czdEVFpxRkc2?=
 =?utf-8?B?SlB6dndLejRoZTVjcnJvR2xhSXRER3M5VUFwaGVwUmI2Tkh4SmdLc1R1WVFk?=
 =?utf-8?B?ekViOUhPRHNQeHJJVDdhb2txQmc2U2tUOFhBVmFraVNUV1NpQWdORXpmSzdu?=
 =?utf-8?Q?sQiA17rIqLFzARW8IIKWhAshG3m0k2KAG9IFBBt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7b43cc-d31a-4cfc-17b8-08d91cdbc696
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:50.6489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzJ7MClFB3ZrIgfiCGPjcT5A+RvXziF+vXH3awl+50lMWOV0tPe7j2xHtw2h7zkQ8Wc9U4STG266/Jdb2be5CtYNnTAVqGKjxdmwJbxq/0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=940 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-ORIG-GUID: FUGHLOyGNdWmVRiRIu8F1z3zpoholkh6
X-Proofpoint-GUID: FUGHLOyGNdWmVRiRIu8F1z3zpoholkh6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 21:05:19 +0800, Yang Yingliang wrote:

> irq allocated with devm_request_irq should not be freed using
> free_irq, because doing so causes a dangling pointer, and a
> subsequent double free.

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: hisi_sas: drop free_irq of devm_request_irq allocated irq
      https://git.kernel.org/mkp/scsi/c/7907a021e4bb

-- 
Martin K. Petersen	Oracle Linux Engineering
