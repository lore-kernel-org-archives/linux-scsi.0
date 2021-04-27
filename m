Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFFBC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF0B7613B3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 03:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhD0DIU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 23:08:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36724 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhD0DIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 23:08:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R37Y5P071875;
        Tue, 27 Apr 2021 03:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5UD0b6sLPqqoFtorvbzaOV7Cq54XJ+R+O+dtaMIRCcc=;
 b=L3ZAT2wD3+6huImbONbL7rBlzSiDagbHzweaC3fPakrxoKbm/kuqqSsZmcaDKEhXZ2L4
 qxRkZfKvrheqHRS8MqWIuPfzZ4BQCGAb+PChaRueVGnnvW7y2F1w0yhLroDYHVNT6xyS
 hYTAJ5+2viXTQDi2PjDISYO7KzoAo3caejamqWFevkesKTakoiGH8QEHfLC8NkiEf3aP
 DtaLHypshAdv1m6E7X7Ij8cYZDt1x/leO2R7La1xIl/UiA0rp9yKkv0HuYUExdDTvvn2
 MW5wXzesAgunnuOJ/jRxitSUwhb6gKts4nMD0MplBlos/plnzHy4nWU2K7XwyFKfCMIk ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 385afsv001-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 03:07:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R35hYC147009;
        Tue, 27 Apr 2021 03:07:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 384b55r9nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 03:07:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSwk8H42dGHnJkd+EZ9dMwjr5T5qTTEm18n0fAHomFnSTeNMBvM/IMteRiL3OMbD3h9JuQNcb5P7jcv28XP/yTwbj2eRHxoUWwIRmLVGKzzaJK5FDFRpJ4gT95ZECQazE7wzr9WPiLP/+52Cqh0yy3Pou3Uw7dl/SqMdRZZFc9OQdYbIXQgnoXEq/uIUjggWn85mVFkxutEtQBJsCfEC5/gvC9JZ9GGsex2dF27v95WwjgW7BF/swlOpEuUD809eT0jHMf9S6Y6ok7WeAuWXw+UZqiUP/yrMzNBlgKqB8KIqb+n+lYH8ChifgZzcLUBiAoyMVj9juxLPQP6jAmIBFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UD0b6sLPqqoFtorvbzaOV7Cq54XJ+R+O+dtaMIRCcc=;
 b=bFYv7hJUGt3ebeDmUTc+WJqhGzp4mdUBoOS4vTgW7j7ZhgWGerbj+1UJg7FeEnW5fC+6Gr9uyxkpia4CTyVZlKxy6cGnpWR7KBiP2LFJ1qkE+8dA/q2f2VSaKRvzxc/+lOp382tjM7E+yVbVr9tMDPKyGNk8yF611CdZ0GF89fEfshL48Gd8+1a2RyvYxs+Cnv+KUqTic59P0wCNfYOudX3qsrU7L5KPLMvZZjDro0GmSraFdVuL8lt/kmug9XnsTuFjIG8TJcxzLijo8L5SNVJ7kl/d5jKEuIiXNq1FGS+EkBsAYFgh0uiheFfzmsd6UQnQ+ALPTk5ztNioqNs5zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UD0b6sLPqqoFtorvbzaOV7Cq54XJ+R+O+dtaMIRCcc=;
 b=YI2VuGBTrOROvgD+AM7uuWb6uMTPs7Wn66VpW5nuxIA/thaoISEdayvGU/KaXnkEZshboOeZx+Cccs5NBJYgIfv4N4LxMV/EyY3EoACaA8MCWdsC8ajs2g3OH2v1GYJGCZPZ/QX92nUm7WPkAnP4zfaR/wN6khLZTuZAQGoqX7I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 03:07:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 03:07:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH][REPOST] lpfc: Fix dma virtual address ptr assignment in bsg
Date:   Mon, 26 Apr 2021 23:07:24 -0400
Message-Id: <161949269497.28290.14980075918062583156.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421234448.102132-1-jsmart2021@gmail.com>
References: <20210421234448.102132-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:806:120::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0043.namprd04.prod.outlook.com (2603:10b6:806:120::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Tue, 27 Apr 2021 03:07:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08bb064a-6c50-44f8-866f-08d9092997d4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4501FC75929C63CC6490EA068E419@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdqYijFwUC1347t2Kquy6RqZJzu1cewRCMvJ55GJ8U5FFIS3x66lznGmXad/pSGXCAr9BbnsFk1ev9cnsyeSboSG2M4k4SOLN2Icb8nLqxdnq7eB4NsaCNdWOsgLxh9Mh/QCZ2uEpPyJHs6CpYRQBqSZIaUx/brv8FnXL/cEm06S8pzvjAUpKN+LsCSwU8zbL2fWmMSUgJ6a/9klYpiZ8SHiNbKWAxvmpHZ/IwRPL0LwDMoMe/AnV83Qbp9gyylZ+fkcwdoy3hT6TCVp21727tnMGF6cyDCImbFYgyCYietMS/DO6gdAZj/J52HuJ2rz2U1t+NWhyEjhIHWILrjiC3siQOWb6lAfI3ncS/PYEOf8rxa+EHVU146IMsyEOasajYzZ3SQNIw4DATsCuezlXkEUEB3t7c12gbWyAmXXFziSeEVBuhr0K4mwgF8Ia7BNIOknGCC5c92XejU3vvfYbqulCJS5q4e7Ju/WCHJHk1wsT2p9ytoPrGx77uXewuYc8tMdiGZ09kSo7vqBgeg1YxbdHbZ5n624cJPAAVPN8l9iKDNwLW5u4q6gZAkBajSJHGzH4m/XWx5rFPICoknyLmFS7qgIpdi7yl9cSOByLTagme36S/RKEOFIZbOdbgqGhV6juF3+c/C5BXRiFfYpjQN47lmK4fLQHTjdcogMkEWbfMcxMBCjT8o2Y4zIu2qB0fcGZi6igM6j4Fi8XzFsCtcmRJHkxvk0WMfGSgWmTSU1H4enx593gouR+oNr+ukC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(103116003)(36756003)(6666004)(6486002)(26005)(4326008)(966005)(6916009)(478600001)(54906003)(956004)(4744005)(186003)(83380400001)(16526019)(66946007)(7696005)(86362001)(66556008)(8676002)(52116002)(66476007)(38100700002)(38350700002)(316002)(8936002)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SHlOY3BWMmtBeTNaUU1ocWxHQ1hUMWZVcVFQSkdLT0JIcVMvaE1FL2hRcnRm?=
 =?utf-8?B?dTZwQnRXTVlMaVkxNUhWK2txcUNiaStkNHVIUFJSZWR6OU5tWEQ4OW84U0JN?=
 =?utf-8?B?UmplSkhSaUxBSlpNclRsN3d1QlFRUnd1OU00cGpHT0NnTlRMZzYvMkJ1bmJL?=
 =?utf-8?B?S0FVc2tqRmxMUjVyTjkvaTl4dVpacjV3cyt1Q3MrTUhMbk4rMnRiQzRsUEIr?=
 =?utf-8?B?Kzd2NzVlTEQ5WUc5MmtReFFjemlZZkkraWFQK0tIYm9WZ0ZVdXVkZDJpRU5B?=
 =?utf-8?B?WW1YS0lhMnpTK2w0amdwd0VPci9rTC9iYy9ENHZCNmRtK3pHYjh4a0djWGpD?=
 =?utf-8?B?ZWRqeVQ2L1I3RHJwdUxVUlBjNDd0T3J4TDl4bGJnQWtWeERTWG5lSFZJRE5Z?=
 =?utf-8?B?SVhaN3N1NlhnY3UyMjJqcEg3ZGlrSjdTQU1kVkl0bjczZWpIVGhMZ3UyckFH?=
 =?utf-8?B?dWVOOExKMWt5cHNpMGV2czYvUmJISzlWQTFyY1VkVXhLQkx3N2JmTlMxdFVM?=
 =?utf-8?B?L2t3QW4vZ0lRbnFMSkxoemdudGJqTDVINjZLNjhVVFpxZE9lZFhldDFlWTRh?=
 =?utf-8?B?Vmw0RVFNb2FrN1hQSlc3YkU2ZUQydkMxTGtYbUVzOW52czhTQlFzR2JiOU1Y?=
 =?utf-8?B?aTlBN3Q4eVRVbTlpRzh0QzZrR0tVdDA0MmthdHhkQTQ3d3JSWVBRMGFWaXFS?=
 =?utf-8?B?SzZTMEJmUHlUN2E5dlJuRG8rVnVHdXJiSUZDRVd1OW50RVVoM3BsYVBZT0Iv?=
 =?utf-8?B?K2hRVUo3Z3o0dlVWVjVJbGlhM0t0RVBYaXoramEzM0hKMVFwdVpreEZWbzZQ?=
 =?utf-8?B?TlMzUlY1VXN4NnRvRzFBa3ViYUtPZTM5aW9pdUVSSm9WZEpFS0Z6MmtFTkli?=
 =?utf-8?B?Y2Nsb1N3YWNVWitzM0VmMWdzV0JESWs1MXdtOGRWMUM4YkFYdm4yVFZ2b3ZS?=
 =?utf-8?B?NzU2eFljS3pHMGxZVGpFeFJaT29wV3dXaTZFZnRtNHBCOVBZYlFhNTJ5czhB?=
 =?utf-8?B?NjQ5a21EekNQZlM0UVNTQ2xKeDRzZTZiQUpMckxYS1BzYVFhcnF4R01KeFJr?=
 =?utf-8?B?T3BrVVVvMXhQTngybXkrSjJjakRvd3N0dVY2Z1EwSEpzRXo2YzF6UkEvelpu?=
 =?utf-8?B?NzFDNkkvSktGWlRoREo4ZlVkbUorQTNvVW1vM3EveFpGcG1uK0xWQXZFZ3lh?=
 =?utf-8?B?TE15MVYvdTZoV3RyR2czaytUYmEzczFFemxncHl1QzE2TUlFdjRCUzQxQk5F?=
 =?utf-8?B?VUFVZ20vUGdqK3BST1N3VDFvZnZ3Nk41ekt3M3lEYzdicStmWTFFdGVySkQ5?=
 =?utf-8?B?a2xXUGhSQ1BENlRXSnNwSUJ5dUErYXFnTUY2TXpCWjZjcVJuVTE5QUFjVzcv?=
 =?utf-8?B?dWQyT2JmZmZQQ0IwVStIQXV1QlRBS0lja3hJK0U2UDU2QXhXckRYbmdWRWxV?=
 =?utf-8?B?TTRMS05NcUZOM1h3ZjZaRGIwdzkzM1JYdU52WkZyaWt3eFJXVVduY09jZ1dh?=
 =?utf-8?B?TmU4cjZ4RkZvUnBVOEJlb0JnOVdscDRmM1hOV3B0UmdhT2xuZzZ5VTMxYXBV?=
 =?utf-8?B?TW1pbngxdW41dFdEOEJkY2ptWXk3Yit0UjdBWTdQYWt6dVkxK1p2VENpT1l0?=
 =?utf-8?B?U1FNalJoZUliWWRhT3BOZVlkNStBanE0WUNTUmpUeTc3Zk9HbHFnQmJGTGda?=
 =?utf-8?B?TEJlWGNRT0gvSnNGWFBaOXlhU3NmNjNzVTN5MVNTT2UycTl5WTlwRjg3SXlx?=
 =?utf-8?Q?JfnzeGQFPbUP9fHqHZx72mLcWQ8TnmZDljJvcAt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bb064a-6c50-44f8-866f-08d9092997d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 03:07:29.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HTQWzD0kqa3mbMSACY96Ex6fzHfb82P0xF14X/ZEJu2U/phrTU/jqJhTxsq02nZRKaFAKhzYOUKXHgDHnTAhRVav3BBCrPZcYaeQ9wEw30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270020
X-Proofpoint-GUID: zqM3w-Sh47FXgYxOP4s9d0JZIYmjSvvY
X-Proofpoint-ORIG-GUID: zqM3w-Sh47FXgYxOP4s9d0JZIYmjSvvY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2021 16:44:48 -0700, James Smart wrote:

> lpfc_bsg_ct_unsol_event routine acts assigns a ct_request to the
> wrong structure address, resulting in a bad address that results
> in bsg related timeouts.
> 
> Correct the ct_request assignment to use the kernel virtual buffer
> address (not the control structure address).

Applied to 5.13/scsi-fixes, thanks!

[1/1] lpfc: Fix dma virtual address ptr assignment in bsg
      https://git.kernel.org/mkp/scsi/c/83adbba746d1

-- 
Martin K. Petersen	Oracle Linux Engineering
