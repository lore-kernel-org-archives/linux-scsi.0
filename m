Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129AAC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D306103A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhG2DhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5988 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233485AbhG2DhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:22 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3arUD005983;
        Thu, 29 Jul 2021 03:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lRK9/ttL/hk6EMu/TCDGZ7LL64juCsu6j0uqfPWHWbU=;
 b=pXtLD+dHeiy18ZsHCsKmI5ufQvO0V6GBtTJucAchqyjciUv7U+K+wTT1lYIR5v/Zu5Xb
 6+E3irC4OY2D6nwMOqLVCgyAH+Z2wHwFcILRWzZVWtOq+jHLR2gYZtdoBA/mYcblRaAS
 S7VVlVEbELO/KgGBV/pXrkEe/nYSA59d3JuoAqCej5NiRXuA6mSYXqQhsvwcMS8aUDao
 utHlsFd6xNNq5iSJqTKO3AT5cZnnlHS8vmEomeBEoeywYbYTXwj/c42391TuMycpSLsj
 bZ0SM4wUfqecRV3Ru+WSknqkfgbPS5Z5sOH00M4Gl7Wv16LLcEtDYrynPJQiJSquv2fw Yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lRK9/ttL/hk6EMu/TCDGZ7LL64juCsu6j0uqfPWHWbU=;
 b=mPYX4ka1ANeJr+fE9Ki21KQD8JNT+yRW2V2Ch+zm97tDCvq2I3XOTm4/yCDintA3+677
 EIFHxXQmBSsPS4K8AHJdRpR2kNhsDK4ENI8LTfyfwYcld/UX0f3M/4rCFs83PQSCklg5
 uzA4aH5fPhP4wf4zKWz4e0j+IQV86WvNDauzE6d4ZmFLOtboAHsu4bQC+sCzBBY2uwU9
 O7+N8Tydkbgoye33PZNYyvKl0LCKgGdvHUMtXUDppAkNl6FPs71vjTozPK5tcEiK7+VG
 8nCkW2aJGX0iNxcnPrR0N5oGi5hR2l4Vbs8393YLOQKa8pAaxMR9yZK54WpUEB8iTmYb yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2353e1yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3V0lL035553;
        Thu, 29 Jul 2021 03:37:16 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by userp3030.oracle.com with ESMTP id 3a2356hmxt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPD/6UrdM84I+66EGSAP7/7RJUtDnNItU+WwzvNOjw+3X34P18TR3hgNp+0z+HDVpqZIwmpNuivRYzmAqtd2TXSByGesW3QAhdd9C6p0e1cUb1OcCpjntfend4yaQgGayMSLJ3SaMDXNai9rDni/0PIKOGY0F2ouheBfZub3sotryEWS7rHlFw063l2pMUQo7KZQSocG98iM8yUDwqzI4KzxdIbcqBPcCGpsrkZLl2oP8ylxj/WUERkUkyJQoQ0wGXmnM4ApAtFzbYUr6zSHgTK2v9lnI310OZJzTWmN9TKVNa2Wf5/CkM75RMxMH6NGVtkoXWgwXUZPx2FzNIzo7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRK9/ttL/hk6EMu/TCDGZ7LL64juCsu6j0uqfPWHWbU=;
 b=leUSxw/VccwEqBxPUDYFvLZNWgxiKGAGcSFEKAaJpeB36DTxjbUV2zFmRk5sDORwAnhrVidYzClUEA3zw9cbWWAnMuP4aZWeNbNGCX204z8WZAS40plvFl2O/RtOVakFNKR54lyUDOu2u/sJ4KQ9OopgTPt/RQ39VlnqDuAMNXUAsTLBBX+u2dpB1lEBWWkqOw9Eq+Ejm0+LVcUAkrTN1Q2yS2+iRf8TvWii+F/CzZOXMs3OHu19AmY8h4/r8xVd37ThZ/wZrMpSLwRSQbNxqP2xMEMgrKZfuhePH7W9k04zMrN11CghVKN40ocEH09vVzwbOYxTKyUBnwtpQNjA1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRK9/ttL/hk6EMu/TCDGZ7LL64juCsu6j0uqfPWHWbU=;
 b=uYkdMhjWLlaAuthhNMUJ2IEtVYj7sC5iAdmMTbO/+cyzB5x63y3CPPjFqqanV9MDZyBdAb3wHTz0HZe9vwwumgrlTM4vpLV48Id+RM/h+NgNe63d+F7NbLE7rIn28s3KRQsAHGunZXIRlgvUUM2Fx/yKoEn6t73ys6DSyL0gyTg=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:14 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        kashyap.desai@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, dan.carpenter@oracle.com,
        megaraidlinux.pdl@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, sumit.saxena@broadcom.com
Subject: Re: [PATCH] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry
Date:   Wed, 28 Jul 2021 23:37:02 -0400
Message-Id: <162752979292.3014.6905350922705081988.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210708074642.23599-1-harshvardhan.jha@oracle.com>
References: <20210708074642.23599-1-harshvardhan.jha@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c36c88a1-1cb6-4149-f897-08d9524227d0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15497EB78908F40FF1DCE51F8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ulzZpp5NNiI3mQlPa7OB7SY1DRLAGlHg2JTEBz1dqDtool+NFXf7mk6D7WEaTO7EbJSMY+2EMfAF21zjPiADarfn3yoQ/e96EiT5JEbTe18ZZDqbv6EOYbtBDD/FHng8QVA/B6msATwt/RbrYArljHpgVqwOE1rPflHkly0knp+Xpdwf3mr9bE/OEZS6EnOKCQy4GRDHjUAUaulCEcZpUVn63XeRHFD1DHf81vfhTe0semLEHAuOzmoIwAmvN8WS3h096RzbHMC6zK4krsX0r77l7turqmuT1c8rkWaG2tQQgqaHeyzPk4mfj0FZTmXc0PQOeRCprKT9Tnb2EwX5QI7TAlT+RBRjGD86HV4IOsyv9ArJDF4uIheiyXLLtRAPlhl75JpZrHl/QahtClUqboZnsReu5aypDEQFZ6Q4xA72jK9ZJiadvdjdUY9AHk/Qc0hH4Lc7HQ5rY2FF7sdO4pwV8XTCdokSIO3n51yQRcAN5YxETm5imgBKWc1AjSIVuZx1+hSrWWEJ7HKto0J7fTr93Xqg0CwKyaFReZsxKI5fc9r9f0vHaGR3pxntP2jqQ0e+iyYGgyLhMV5J0eoh6vDYbz2V6ta4F7taKnO9bHy2O+H97ckDo0fOIptmSQB1LNskU4ASFhQL886Lo1vexxUQzLifHx+JZeA7jPp5js9nqkt3tLqJa3fZXjvXueUr+BvUA8/NaILZpOX/56lCR6yh1hHxx3rdV1ZYXPlVzug3qbPmpBN3Q4lcKqmwQUxREg0eumXQumiirXJ0F9HDBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkVCZXNCMjlJSnVLYnRNVGJIeE9CcVNHUjFrbGRNVjl1cUU5RlBxQ01JRG95?=
 =?utf-8?B?MThJNHd0VDdrclVWU3BNdWEraXhuM0xsajJaWmxaSmV5cHR5WFBFSXF3bURi?=
 =?utf-8?B?eGlCWmw5d2lhUFRnNkdMMTF1WUJxR0VRRUFmRGJZRTBEd3FQTDNUOGE1REVm?=
 =?utf-8?B?cE1JL0Evc2I5dWE0Z044WDBBMzhVc1U3MStqT1lucXdyWUJvcHBmM2tFRWdh?=
 =?utf-8?B?YXpVc2lxZitpTEkxcUxOZU5JSXIyN3hFVmNaMnMwM0V0Q0pyMG9jUmFtYTlD?=
 =?utf-8?B?Q3BqUFZqV1JoMzg1MHJOdGpyWWhjeVA1Z3c2dTFTVFIyQzJrZFRZVERlTEFM?=
 =?utf-8?B?Y0psU3Z3OVBPY01ucCswbmRrVERxOEFNdms5ZW9mS2ZNbkt1RmZLY05ZSUJT?=
 =?utf-8?B?R1R2OFBWd2lDaWJzTkFnL0szQjZHVk1NbVdsMEpmaUlwc1A0dzVhc0ZSYnFH?=
 =?utf-8?B?bTBTVWN0b3NJSHA4bllXMzl2NTFCSi8xbVVTT3hjRGNnc3Vzam1yaEgyeU80?=
 =?utf-8?B?Q0VMMHlkOVovcTVUTmdQNHg3VHJNaXQzWVU5MEJEZWFXNUJLQVg1dDh1Wktw?=
 =?utf-8?B?aXg1eUFHcmxJNk5KV1kxa1k5LzAzLzhpTjh3SCtoZmVqdW52Qi9wZGYvNG1K?=
 =?utf-8?B?dW0wWUxkZkxrVjA3WmJDVFVFQ0V4U05LZVBaUUE5SGM4VkJXYVRZSGFwc0RG?=
 =?utf-8?B?eWU1TUI2Rmp6SjlFOFJqUks3MjJMaks5NVUrVXZOK1JCNXdVK1ZpbGlxTlZJ?=
 =?utf-8?B?TjM4NzRmeFJzRFFzTSsxQUk5YWdOWWYwOVF3QzQ5L1hrN1h0eTg2UUFGZmp0?=
 =?utf-8?B?R1U2bEQ3UmRDcGNjTk5DZWQ3K2w5dXc4WHZNQTNCc2pxS3JLWWs2LzhZTnBM?=
 =?utf-8?B?VUJvcXhUNXk5WGxxMkV2aGppbS9LZHZyVFdIRjhNSW9id0I2RFAzR1BDVkF6?=
 =?utf-8?B?WG5ObS9HZFhZZmpZK3ArbmNXc2V2aDIvUXBzNEpvNmZKTEZDS2hYRHF1bXpI?=
 =?utf-8?B?dlBrQ1dvbm1qVVpYVU9DdGdQNXNoQUtIRUZEQklQMkp1QU5ud2s2UXFQY041?=
 =?utf-8?B?S1QxYnNrWkNqaEwrbi8rSFJVVkJyZTN6MVVJeVM4ZHN4SUlzMURXWUE3N2hw?=
 =?utf-8?B?SjB3MGRNTEFJNlFHTzJBTlBETVZvcmVDeEpqSUxqQ00vMGEyN042YlJlekIr?=
 =?utf-8?B?T0srUHVydFFVTFg0SEh1N1hOQ0xrNmNLakE2aGlMUDFJbitmbGlRTXJzTXZT?=
 =?utf-8?B?QVV5Y09LWWN4Rkw4ODdDc2NNdUhjOVB4bXc0Z05VQXlTUFRHUi80dkRmMmk0?=
 =?utf-8?B?K2FDaDVMcE94UHo3NTdFektSZ2ZKUzVteTQvQXI2V0VFRCtHeVVQRjBVRWRW?=
 =?utf-8?B?MjUrM21KcEl2RUZsTXJ6dEhzSmRCbS9idy83bnlEWjhCQ0NpSnM1d0oycklX?=
 =?utf-8?B?OG1MRUptTCtlR09YVTdyUkVhcyttWDI1dloxaFB2MnMyQnNNYXhIY2lBTkZS?=
 =?utf-8?B?Y04yd0pIWERYMHJnL2lFblFwZWZ0NGFvTWxGSlJRaEhqa3FUMmJtSEpsV2dI?=
 =?utf-8?B?VVlIaFZPSVVmeis2SDBCUlRseFBKdHRlVUNVN0dyMUFiZEMwdUdMTm9uNWQ4?=
 =?utf-8?B?aXB0SnV0WGhJamRJZUFVekJVWis1TDBvUWNHYlFYVHM0SVBkeFd5QVFJa1Rn?=
 =?utf-8?B?YnpZNGQ0YUhqRmZXWkZXUytDc0w0MjJvSTdCanVkc3IxeVpYdzVYMVp2bnY3?=
 =?utf-8?Q?FnvijlNvZ3ahBX9NcsyS2r9u9GdajNvFvCnj3G2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c36c88a1-1cb6-4149-f897-08d9524227d0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:14.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFUTJh/NNrWmJW5Wg8Emlw7jzM1H8li+AcjqQlQCSJN97bDsMZy37pvSdRDKLQ4+TDCV6UcKmzHRqmW1F9ZDOOKTgve4Gmdgs//QLl3biLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=708
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: O0L2NG8rRTy6OuwWGR-ewwZh80vEPufE
X-Proofpoint-ORIG-GUID: O0L2NG8rRTy6OuwWGR-ewwZh80vEPufE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 8 Jul 2021 13:16:42 +0530, Harshvardhan Jha wrote:

> The list_for_each_entry() iterator, "adapter" in this code, can never be
> NULL.  If we exit the loop without finding the correct  adapter then
> "adapter" points invalid memory that is an offset from the list head.
> This will eventually lead to memory corruption and presumably a kernel
> crash.

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry
      https://git.kernel.org/mkp/scsi/c/77541f78eadf

-- 
Martin K. Petersen	Oracle Linux Engineering
