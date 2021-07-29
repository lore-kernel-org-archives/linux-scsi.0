Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145A1C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1EB26101C
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhG2Dhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57026 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233684AbhG2Dhb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3a8MW029079;
        Thu, 29 Jul 2021 03:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=liOCsDJCwMYsM3qEW/lM/ZIvI6QDAYRMAUdSsAW/l0E=;
 b=HNkcfWcIM6tY/Ynv0zhB1CQzIWMdnSwbMcTeWoqGMTPsisVAC+e94pjmCQXEf6kFktOA
 BQqND11Abm5ztTLfGbfti4wysbleqzAfgMOYrfZpyYfnlPJD12zza+YbV3B8UgqP/HxT
 kv1EucdQteFtCte/wb5zAn4EsqrHF37lZadkpSeJlno5iwJeyoedLCAMV0IwTfYX3qJo
 rw0JujYbdhqxWifI3yI8p2g//JBS2yQ2FKDf7v15pwKy8AbkarMGVpGzwd51BbGNAF9x
 8UjDkAP+RPO7cp8HnBwkqPzxzzYk1eCIAkDJgidExt3jX/LAeAFgJV1fVK5fzBRcXmut wA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=liOCsDJCwMYsM3qEW/lM/ZIvI6QDAYRMAUdSsAW/l0E=;
 b=PrscIwmIhNCu/3FxqWKRLba1wPFc5a56WvQ8NQA2FyeNOWgWDX+aCJ67RfrnbmkmkOHv
 YGmoOHhPmhT/++LXhTWquOqXgBngmoN4DQKkyhEjVqyard9IDlLHxXDWQBQWsl5FOsZz
 hcw/9qHfRdyd65mJ3dBb7uMyC1zX28yp5IqpSy2kb68HIFCLK86yFC0hqP0wBRRNks+l
 6TSyhFDzagJkqXuJQc+9vanNUZ6T38OIsJzrHVbr3gqSiYmNGsDNpvT5vHtRqEXkBq1y
 ZML4rN4sREf6hJDvoWtzH48PnC3eNfQwbubtd3zLozK0YkT6N/IqKQ/XdykkpVw+lC2V pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3jpd042u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Tloc040950;
        Thu, 29 Jul 2021 03:37:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 3a234dpce5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZK2Z07y/Ao0pxmllUOSOPpsm+vK7n3UShvBqh2Z9z+G/YRmbHo2t7kSqG3xpwl9ikPTz9z/pahL2kuUVlMUT2Qaq+L171J5j+LjAycV02lbsTmSMVV6Hoz8Nl1Cl2Ykx1ouvBOtSW3yATLqiZNVgNwZNbG+1xFezY8s578NiffGZw5uWSUdfP8fiYnFEh0gWib+VCGauvzjXWP9wTEz3qDGgGGjN1qae4YfwtFxrf4MhbuKGnw/ybGKMghe30+S3MKt9umNdOVD+BONgh+qXarMDvWDeRl6xKVgMgyQP3FOElDkiARSvuCS8k9MmFrwOdsYyC2zw1BWJqXBNApl9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liOCsDJCwMYsM3qEW/lM/ZIvI6QDAYRMAUdSsAW/l0E=;
 b=LGQxZ4K2eGBZ6WjjQR5dfGIf8AeyWq9ocrXXK/0ioplwLFzLVKC177vqh7TwuIxz8F8QzUmbaOmyjDttLbRVAJ1+beafJ9kBoge/igiU2Qfirm6gKNEBeNrtrECwFIAQDqN5pw3jDhYRzqL/XuGoXMJ2uVmaA6JI6Qa6hVCAiim3dHJABp+NWnIowY0IkCGmK/S3tXhKHptx8WkDqL18JBSlz8nfsC6K4IVLpWwUq9m7XinZ9rbT3hKOnMvxusISntxm95GVtQcrsqW1dntZajWRKmz6oWcObb1j+aAi9tPCPgVVPKxjXrE9ZDuwiYOPitkRBkr13rE8/tQog0SKeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liOCsDJCwMYsM3qEW/lM/ZIvI6QDAYRMAUdSsAW/l0E=;
 b=zSEfFvY4tpBkkxnCp+oGCyvdi1HD4DyjmJBlWp/sXDEwlX3dfBc6zs9BIBdyb/B/5HS6y4jwmEoUFD9ZTKDYcRCOaCv8qJ+JL5/klSXscwF/yBEoSYJ+7OD3IE3ajYjCBcCy+u1TXxIac20l9UBNxvE3k0elg/NZJupVd0/DbGY=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:22 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ye Bin <yebin10@huawei.com>, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATH v2] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach
Date:   Wed, 28 Jul 2021 23:37:08 -0400
Message-Id: <162752979292.3014.9865687646574128836.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210113063103.2698953-1-yebin10@huawei.com>
References: <20210113063103.2698953-1-yebin10@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19236cce-e560-4111-2aa1-08d952422ce6
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1549E345297A014521EE68A58EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziK4hG0gIyZcQwA/6YQ9Rwfb6bczK4+ed1m9oDDiHRwAzuhH52HekAMuZRNsgyuxCPVFSWqgAiShjkIBUy6IoNcDM9BEwrPTtwDUmnZr7ZLvfAyg+t7scyf+6I1gowomd09gAIFZtmEXznAJdcnLUvrY/D/jy0H6963XHWeQWPwvaEQn3Cx0eTLN61J2Nvnlz8SXalhNGPekE+8t6bntHa9N0mcMTNwgCGl8osuggNvkwf5mJG7Eu1TOiDvuPxME5mY500Ip6Fc3pxpMRlWLX6rwlpd4hf0c6f5DRcpgS9swZ7Mz0kMayCDf2rcRgPeVty+fSIDe0dOMlOjR1ppARpXrLQmye+JZL9d0D1kq5djOSRcdnLi9vyVHewlz+UWxfKeiB7xPxm/ckGZLipMsSSD0+qzYbGIkxzXkJ7iS227pqTyN22JLV2HYT9aeb8aJsb+FIZNICMDolZxFeDjc5sCHRC43Bnt1vclUclMxuYV+Zm7iK0qZaZEui9uhcKVTyerDgYj4W344d9ZhCrFrDzso5aRzWaRkT3fpQg8RS1bm9u3ERCONHI7XTsN1C3KAr5B7989SvprtF0x689VY8B5v0JnRy3rJNzh3GOrA6XgOsj4fLGe+yW5xIV1nsPIdZ22NBOnh/USgrIF6PF5HsTvejJ0FTbkM+H7z8ecNhYDsAMHSvLLqlcMntPhXoD5xMHKk5EbqfB+etezLY0rDWMyCOLRcI8MsLQNRx33h8PuN0PjcZFaHxDjStQ+t3hCJeSYdsPVddA3qoo8+AVDGwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(107886003)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEVoT29lZUxUcXhPekRIalBlZW5NVER2ZW5GZnk0cVVvYkYyYkxFWkcvVW9s?=
 =?utf-8?B?OFF4NmxoNHk0MnEzZFVSQ3Q0RlBYSldINUZEU0RWODJ3cmZObjlCdVh4b1Y3?=
 =?utf-8?B?ZVhPeThDc25ZNEpVSG5GbzA2djltcTlvSHlqNDVzY1FhRGxheWxrSHNoYUsy?=
 =?utf-8?B?K1h2UG56ZGxyUDFXcFpENHZGa0drWHdFN05QeGd0ZDRMOHhaR0NLWG9vb05i?=
 =?utf-8?B?WHpoL2JTeDF5RDIrR0RJdDFLSzZyWnp5OEo2TnljYTN4cHgwYTRydkJ5N3lx?=
 =?utf-8?B?N2NXUzQvdDg2dzZKM0RTcGh3MFVxOUMrM1Bjdm5TR0Q2aVdNU3lLb0dmcmx0?=
 =?utf-8?B?Tkh4aEJjS3QySWNCRmY0RTZya0ZPOHhvcGc1SWtzSEcxWlc1d21qOFBVRVE0?=
 =?utf-8?B?NWJQL1lBL3NoeC9WakU4OVBJalZSWEpUeEd4V2xIejh3cXZtTFhPTEFwSEpB?=
 =?utf-8?B?UHdoMm9OdFVTb20zdnNLRHVKSEdRNWtTWXBwSHZ4R0FEK2ptbnByRzY0VkF1?=
 =?utf-8?B?L3VkNHBzMjh3eHRxanE3c29JRnBZNGlxSTNqclFJY1ZtZ3lidkxuK0hLRDVW?=
 =?utf-8?B?d29QODBKL0doWnBYRitYR1F5R1ZycDJvbjNCQWsxZVJzZjBtYW0wNzdpZGpN?=
 =?utf-8?B?UFFaVFMxVmhVNmFMekk2YTF0V0xYUDhmWndENnd0dXZNaThDaUZiY0dSU1pG?=
 =?utf-8?B?MWZtZkJ5M1lyMDJXQUM0NndxcDg5c0Z4OEJFdWdzS1o5b213Ulk0Q3hWWGRm?=
 =?utf-8?B?N2F6bi92YTFsaWF2TDRnY056OFVTN08vNzRnQTV4T1VQcTVCZlV6djMyb1Ix?=
 =?utf-8?B?VEVCLzBBbzNRZ0k1NGRRWnQ3UHBTSTV6UTJyTkhnQTc0WHBpMXN5Zk5QNGF4?=
 =?utf-8?B?Ukt0VFAzY1g1MEwxaVdvKzBYN09sU1hZUHZGV21HY3huSit1SlJ0NjNIa3lj?=
 =?utf-8?B?QVZ5WitaRmdncVJjeXVRT0dDd3Zmb3FLYXFzdVRzUlpPREhXckRBVElWMGNZ?=
 =?utf-8?B?UjNiNkZ3K3k3bm1BYXpBSkZqeWZzcXpXRDlyUGR6WGxxT0ZxSzVCbFRONHFm?=
 =?utf-8?B?VDVlblpSV3lmUlhIdW5YS1JDZ0ZwcnY0WkFKS3IrZFZhZWVzVkhvR1BtalIy?=
 =?utf-8?B?YkE5MVdWcy93TVVySlVBN1hVRHNkTzJMbGdhdGF0dUkwWTBEQ2JjVjMzL1ZJ?=
 =?utf-8?B?QkpFRThSK2ZLdktLRkNoRmR1TmR0enA2V1dqUnpXYkhXK1JFNWtIeEd4M0Vi?=
 =?utf-8?B?QTRTVlpOMnBjS25wa2hTWDRwbXVBTWxBcmY5SjdxSGdJemhRWWZqSis4WDN1?=
 =?utf-8?B?WVpLMDJNOTdhcHYwekNkNUlEN3ZBazd5bnp5U25JWi9uM1NGSzlRMzRQbTBq?=
 =?utf-8?B?aldlTzRaMGpmK3FoS0c1Z0Y4dWgxK0Y4eXV4VFlZNFdSc2dmd0lCL0hiNTJh?=
 =?utf-8?B?QXF2RGMyQStoeTZkT2RSNzZ3c0RURFI5NTArenI1clpBZWlrZGk4YkFjUlhL?=
 =?utf-8?B?UzBIUUFpWU9lVzZsMmFHMEtiTVVaMzcwbnZjbm1wVmVuRVlncmFUeGprb0kv?=
 =?utf-8?B?c090QWdHemlhdmJyc0p3ZmFyaTBrNXIvVDF3TVFtTUEvaG1GRkNvNkdjREFX?=
 =?utf-8?B?NFdJVG9vb1BOUHJ0M2JrMC8wRFRDQ290M1Vid0pkZFc4LzVlT0QvTnlQN1ZW?=
 =?utf-8?B?aWl4Zmx5cVpKdXp1dE8xSG1JenNkNmM0QUVvZ0xtaU5xVHZmRUhOQ0F5THFS?=
 =?utf-8?Q?KPFqgmOcLWpgh444g+DsdLw4NOq/9M0QZN0jibZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19236cce-e560-4111-2aa1-08d952422ce6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:22.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UgQ4f6/s+BBeSO8KHEXCRT8666o+AutjH2x8T+oscjxeKNHPM2bCQlJugZhxt0tMBDO8EZRF/pwoV4qX12ncdqRt4efw+EnD3Mr3KNpfK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=933 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-ORIG-GUID: TdA4jw9ghSfhGsbPY4rFkCDbN5QaDTOQ
X-Proofpoint-GUID: TdA4jw9ghSfhGsbPY4rFkCDbN5QaDTOQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Jan 2021 14:31:03 +0800, Ye Bin wrote:

> We get follow BUG_ON when rdac scan:
> [595952.944297] kernel BUG at drivers/scsi/device_handler/scsi_dh_rdac.c:427!
> [595952.951143] Internal error: Oops - BUG: 0 [#1] SMP
> ......
> [595953.251065] Call trace:
> [595953.259054]  check_ownership+0xb0/0x118
> [595953.269794]  rdac_bus_attach+0x1f0/0x4b0
> [595953.273787]  scsi_dh_handler_attach+0x3c/0xe8
> [595953.278211]  scsi_dh_add_device+0xc4/0xe8
> [595953.282291]  scsi_sysfs_add_sdev+0x8c/0x2a8
> [595953.286544]  scsi_probe_and_add_lun+0x9fc/0xd00
> [595953.291142]  __scsi_scan_target+0x598/0x630
> [595953.295395]  scsi_scan_target+0x120/0x130
> [595953.299481]  fc_user_scan+0x1a0/0x1c0 [scsi_transport_fc]
> [595953.304944]  store_scan+0xb0/0x108
> [595953.308420]  dev_attr_store+0x44/0x60
> [595953.312160]  sysfs_kf_write+0x58/0x80
> [595953.315893]  kernfs_fop_write+0xe8/0x1f0
> [595953.319888]  __vfs_write+0x60/0x190
> [595953.323448]  vfs_write+0xac/0x1c0
> [595953.326836]  ksys_write+0x74/0xf0
> [595953.330221]  __arm64_sys_write+0x24/0x30
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach
      https://git.kernel.org/mkp/scsi/c/fb5d909021b4

-- 
Martin K. Petersen	Oracle Linux Engineering
