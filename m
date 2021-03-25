Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93F8C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E6D61A0E
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCYDyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhCYDyA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3nd2m098150;
        Thu, 25 Mar 2021 03:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qwUUzJROiYbl6qiTAchDH/8K9tyPI5EAtJ3KQbSjC74=;
 b=jZNuvcyrhIrJ2AzJ3cm9RKTnJad6ncNZrCVhu07EYw5LHtRyXa9+f0lZ8sOwLArPAEqf
 jv7xUD0tVt0LHxKgjRq9WBS1jOUwSikrIb3jrHl7NIGCLEKoepe+C1Oe7EATBzBWarQ6
 MQ+7isk6fXKlgsORzl+eBfb4z5ZIhJdFjJhupJICbjLGyBSuuko3u4XDQiBTKYRQzGEm
 jgPdtT5T3kVmE+RSGC6TVyArVg6JeyCvK5xoGhyDZpQQBNqq2igbcQWQTaHbK4AHflJ2
 WFc04xLLogmTRwDAOkSGr5nSRLZJlmjjkwVqiU0nTF3UQ1pveL70QVojXE6iUaqKl6vw Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mmvnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pFBQ134352;
        Thu, 25 Mar 2021 03:53:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 37dtmrmum5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOExTfy18R3tkMjRBQUj3sL31tit13TPA3UCaNo5/DQ7CAKtEd0x4bBgyXOIYEjZOcitje6Dhr/S/LQS8jIY0lMWgSI52qVxFfEkiHJrFdBrW/RpkKqg9OvJXH3tQmo/ZKvN60qxA7995bczb3yz+ToZA4EtHTEE5OyPj8+DO6tIvM1fNZSfmaqrOlv6BMKkN+4Is9odkLKzOAPa7xLLH+PCn7fd1ZYJi9U5jhARUig57Wq5iiChILLXM3L1qKiofkPZ1jnjCD6N60FyoE+7BpNyzBRPKcOYJPpQblgHzUIIQz0VIeCKYCyibuvY9B15JsVGQuZFuwqyI2nuJ407Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwUUzJROiYbl6qiTAchDH/8K9tyPI5EAtJ3KQbSjC74=;
 b=L5/8C9PHGRi1YHs0m6wBPnY/gM35jJaSHv9NN1tv+1ABiQsuWEE28V/bEWHvHpSQ7vyxZ5MDztJKTFAGwFCKk/8XapkyvklX/G1r6DAef/XUaQluBQYfpH3HCIqZzjnRc17MWtWuWfY0XsFBvkf2Dw06a9IjFItGsSs2leyL74vV76q4LVt8HvytqXgnv6SVN0WkDHddG+/yhM8DhBv6gXz3AmlcmApGAp4PZ033K/TzLMwC2lHHhfNwJPDwyG0LXOwC1c2SV4UWIbfd0RRjAJUpnNFdIimBmjdox+ixeRf3KxB9fq+la1tCaItXZVSHQ069Y/W65lXg8Umeg41Dyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwUUzJROiYbl6qiTAchDH/8K9tyPI5EAtJ3KQbSjC74=;
 b=wwgO/4zxOf0qqRnbC1T1EQN7iX7EbchvU+DUo8ZU4bsQT6fnYU3FUHGXMftKDaY79AfAg/qpCoJnJtgnYybHQRdAfJCFqTAAd7LTill5FcqWKrc+l8T+t3H+1+4gMsiyYPyWLmaOGPQBBEKwQj3r2c7c6fMa2qL7t0ijc7/EWVs=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:53:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:53:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        sreekanth.reddy@broadcom.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: fix error return code of mpt3sas_base_attach()
Date:   Wed, 24 Mar 2021 23:53:45 -0400
Message-Id: <161664413899.21300.14359949090344574751.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210308035241.3288-1-baijiaju1990@gmail.com>
References: <20210308035241.3288-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: CH2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:610:38::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by CH2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:610:38::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Thu, 25 Mar 2021 03:53:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7feee05f-9f31-47f7-f71a-08d8ef419c14
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47748DF7A9413F49474B6C0C8E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWLv63udnN1QFn9NGs7o3l1b8nrssOAZBkCG5XcTj8ShYPzKG5dNgfZmhhVc0EcUnRVLsTTF7duhBHyIhWYBbOC5gAuTZ1zJPjgc4jXEOCn34YX6u6l/4WURjstj4lJQbe3cuO3qhlzQD6tnjWRdjwC5lRSeI3BHm88t4buT/sRb6uASNwRUkPqf61K1GotE0LZdYM8iG/csDSdLnESZMzKZ9AvYaCwvn3WFWEG23AnifCgOzHXZ6o9SKCoL8lDCDqaKizjdBQz9bxn0pg9JF4DdmqUTeOE2CS0Z+dyboCorgGqdOqyiBODE1XBRuB42z2tk5oP0rCFtEwNyuy2Ghcf9y+a1LbjQjrzBd2Lw4lgMIftoOQS66vJnTL9HI5SDhD/a6YQkEVyhLDLGzXinqv0yPG6jxHGzy1wTaZam1zd9RCJ5BzKPFbB0u5CL/IEh2xPTu2l1MNtrpzygwh25FHAC8FfV8ZGDclEa8WIB+hfwWDP+1/YHwrRAWAdoccAB9mBTbZPjQvYFkvT1bsC6HAallXKAaah63B5EsxSqqKTL1pluCvd0enDiMSCGWZ1QJWbb7qXrhTL+Zb1oBJIg1/18zCa8TBqyxXKaXWcnBuCbIvO1RmPlN8GgaXXJGf960Ehe5V0lMZIeBzU+vaBp4veJH4Okgzy7eoFfWCBdCMqeK9szBNIcNu+6vU0/tTI/cuz5FnWzqnMrrNQebM+xYAffg72Gejy6V6wCrDicUCAfRPwbZWM2mBgdp6JVPWew
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(4744005)(38100700001)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(66476007)(478600001)(5660300002)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mng4TjFBRWFDK2I1U2xpcGZpa0xPSmpvc0w1SUNMUmxxRVRIR0Q5RlpWWVVW?=
 =?utf-8?B?ZFB0eTE3K2ZvVkRMVzdTMTh5RVVSampyeTBpZTZuVVRQbzltKzFUc2R6UEZN?=
 =?utf-8?B?MjF2MTBDeXJpWW5WRWttVlQrQm9yQTVpNTl5SlljS1RWZFVsZVV6c1VMbXBw?=
 =?utf-8?B?Ti9DWVVtNlRxZERQV2kxVTY0VWw0dEc2N1QxNTJlcUhHNnArck1IY2lMSlpI?=
 =?utf-8?B?UHZISEZ5bXNyNjd5dXJvNmd3MndscXNkWUl4MXJkWW5TYUNoSU13K0JCcVQ5?=
 =?utf-8?B?NWtiZ2NPTmtCbUIxLzhmTmlaWXdjTlRpQkg5ZkhrZkhRMmtYMTZxczhSSmNt?=
 =?utf-8?B?REpDa2N2TEhrQkhTUHZib25uYXA5VWd3bUVLYlNlK0NmNjNrR2hJb2xaMDQw?=
 =?utf-8?B?djNXdC92c09salkzc1ZOMHl6eGh0Vy9hYk1jWlVUTEFjRzFITHlad1NnMDI5?=
 =?utf-8?B?bXR3bDRCNUFXVWdUMGN3UncyYVllMCtsc3VGcy9sMEdjbW9la21yM3JaQUFp?=
 =?utf-8?B?ZmxLTXJyWW1NOXY4YU9lUGZTZVBLeUN6WERqdGIydmJaQWo5WXYyQ2ZaQkhZ?=
 =?utf-8?B?NGsrNUYwSk10eTNzd0h3SWdrWEpqc1pNUUMrSWhZT1crR1hJQUNiMFhoQmY5?=
 =?utf-8?B?NnBUNWdsN0ZuNERtbXFaVWp6SWJLaWpmSzdCU2lkZFo0bnJJV21xemFWc2l0?=
 =?utf-8?B?eHhaNFFBY3hlaEhYK0NkQXI3cXoxb041QU51NjFpTENJRXh6ZjYyUVMvOWEz?=
 =?utf-8?B?eFI5SzB3ZUhXb2JDR3UyTy8ya3o5TDZtMllScGxDMjkvUWphY1NmUXpJUnVm?=
 =?utf-8?B?ZmZNMjRtS2J6SGM2Y291VUNQUkJSYTFQUHVnaXlTZHhoM1NPek9zM3FhQTc4?=
 =?utf-8?B?b0dBWkZrVHorak5Vb3NKRUtzWEdsdUVGb3FxTDN6RDlCTXJkU2J2ZE9zSkpu?=
 =?utf-8?B?Z213L0lWOG1zTHU2aFJraEtYY0t2M2pWNXdMT0FLSlBUb3JZOE5FeE5QUzZ3?=
 =?utf-8?B?L3owaHV2c05hOExFWHJpUDRYaFQvQU1PWlRqV1BLNithQjFLS1diK3ZKTUls?=
 =?utf-8?B?UThCMlB6VmdINmVTR1pDV0VPelo1bitZSXZBUDRyaDhqekJxMm5abnh4VUdq?=
 =?utf-8?B?ODJuVDBjN1pHVUZEQkl5V1k5aDArVkN0M04wemU3SjhxakhOTTF0OGhNZmxi?=
 =?utf-8?B?TmFiUmdkNzAraWlWRGN0dDZvRk5SeFVPcTFFelZwYllLY1Nhck1MNU1DYjhN?=
 =?utf-8?B?VkdCODE0WFlKMndEejhKSjU0MUNWOStHanNIWjNSbFJHaTYvMHlSTFppMitM?=
 =?utf-8?B?MnBWanRqM0xNWmVrVENjMGlYSE1EcjdVejlIVzIwNmppWGlVZE1kTlFySXZv?=
 =?utf-8?B?RUJFeVlJWTBFUUtLdStRRjBIZ1k4QTBGSzg4K1pzcVg0UmF0TmF1OHBmOHFa?=
 =?utf-8?B?cTdQOWc4MU9vSzhFdnJRVHFBK3BVL3VmVER2SEsxTS9kbFZDU05HR2xRMHNN?=
 =?utf-8?B?alRYNHIwSDByQXd5VDlNdldLNWZQNFZoOUJKNmdRZ0hsbVlrU1dLcE15K0VZ?=
 =?utf-8?B?dkV3ZC9EbzQ5akp3bzBVMmpjVlBQL1p0U080L1JES09MWFhsNHloeDFUMW0w?=
 =?utf-8?B?QmFMUlpGUFpGa2NkVUlscFllVDFrbGxueXR3K2NjS3BQVU41cS9kalM1VUhY?=
 =?utf-8?B?b252cW5MUDlEblJFTjZ2TGRLZExpVWd6YndPRzJOUldzS0czUTNhRHNKOGhX?=
 =?utf-8?Q?Ab6U3acqvGdyji8bd7Nj7IqHhm9xykN9Q8+PIwg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7feee05f-9f31-47f7-f71a-08d8ef419c14
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:53:54.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lVis8UELTzbCggetACknmtFaqM7lsDvd/b+9ITUcdVgLdfe39TRNc7NE2CwTwnhW3aXrKQyOe1+Tn0EdYyPstsuYejWyUqY5jYhkDpD67w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 7 Mar 2021 19:52:41 -0800, Jia-Ju Bai wrote:

> When kzalloc() returns NULL, no error return code of
> mpt3sas_base_attach() is assigned.
> To fix this bug, r is assigned with -ENOMEM in this case.

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: fix error return code of mpt3sas_base_attach()
      https://git.kernel.org/mkp/scsi/c/3401ecf7fc1b

-- 
Martin K. Petersen	Oracle Linux Engineering
