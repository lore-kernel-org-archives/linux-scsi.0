Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F14C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800B1619B4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhC3Dz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43552 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhC3DzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3i6W6103434;
        Tue, 30 Mar 2021 03:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=O3FBNmPCYVMY6ayR2Ci9MJx3XP4RHfg0fcwVWF/QEU4=;
 b=f3GaYcexssAR/2pEIHbjvJR4CsfVsa7RGN7XMDk9qpmo0dhPH7Ok5AKmBjQ2NrJnXgwb
 XWBiXyWJGVkG931nrZ1KRwtYtPPKIU8XH6EQUKsyt4HnI6qdwoQCQAiPK22HC3npc0yy
 1BjNk/pkkAmtFUB7ehh+PtlgtCVigaQgJC3SI+mQUDQCaY6wwcpZYaU+UPnyvasmkhOD
 52EJrWvhKZ24SZoKdQCZK0/cIHZlgdhMlGQUtpukliW50bQfIN4dfirknIa2GlToQgIM
 kIsK+cQfJIgwmdMp33MnZPTbg9KMcqrXBRMRDk+UATQNPcjD+3vXSQXlo7qdnFNCAFal dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37hvnm5kbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jRc8187808;
        Tue, 30 Mar 2021 03:55:15 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by userp3030.oracle.com with ESMTP id 37jemwj7fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdApAgpIHzZF0eRan3SMG8HmOvAhYVQpgiiUsJ/kQ9An0w02rDRO082pwChKYegvISjHTIo4y/h6XTobVL5gAznfDKoyA49cV+OhrkBnxyo9aLrqGtp/xifWtxevItn7SGqfMvBqKzOXr859Ob9QyqwNRxMIKt0GG6d4UuT06uVMZ3ZoUh3edsj59cJ/Y1Egb4qdT4RVbm3cyCDEfUoa2/QuiHz5BCIHALMh8ALBuJWvLFRiTU9I3YPrzd2E9ASJnmZ+U6iQ7UqyfDTPLENp2aVwZzJkimGghejx6piVaQIBjaJKSV/w//feupToNiAw5NF4lQNS68rZIeGY74C0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3FBNmPCYVMY6ayR2Ci9MJx3XP4RHfg0fcwVWF/QEU4=;
 b=XBVy8w6jBVAB5BmnYQ1Htul1+qV902WpiYrXKuwFwG+XnyBnnv7hUTINRMKnFVlUPVx7zvuGQThndY4tzVoZY8q43QZJI2jFPRBfvo4KQp80KnUqSnGL3RlT3qPW9cuBcwDbAzrEjrGttF0zpuOD/7KIFyvIbnL2pC0mAo8RLljx4nzZl+I8yXaCPLG8hn1cT+sOZKEi6DxZWQkBhK8CUmXCVKFefy30gLfn5ndaOFC8bpXqYng4WNhfUvjmFfRniZ5lvyxKDVhVDq7uRoPrM2D/6IdnhB2ouVBWvlfvTLDerDdyhGxnFrHwKa7vDoVoJ/4K5ZxLpfU1M87GZE31ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3FBNmPCYVMY6ayR2Ci9MJx3XP4RHfg0fcwVWF/QEU4=;
 b=x+WP5fLLNQSXQ2UQRLxYQu4f7Upo7E9+K+VRye0zrjXs9Ic8t75fQMP/iYt0UXNKpS6aRZVKZHyQ99e2JV/QGygYMqLMYKUwrsfbDfsLNWdgH7VGVTUBYtktmGTN+FK14sWk4GevgzGjXvAZVoU5ExUOvpio+oBpdMwyy7h8p5I=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sathya.prakash@broadcom.com, linux-kernel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com,
        suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org,
        sreekanth.reddy@broadcom.com,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix a typo
Date:   Mon, 29 Mar 2021 23:54:44 -0400
Message-Id: <161707636881.29267.10459243315111010196.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322032145.2242520-1-unixbhaskar@gmail.com>
References: <20210322032145.2242520-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72b51fd9-f21a-4ba6-4e76-08d8f32f9ecb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB475853E4260F3FB47608A39B8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YozcMrgzaGv1+izjuFoYqWxdbNBkKPt2SCbaLFf4Zxo1FAF79Vlc05JboPV5DhqAjkcJFcNLxijavl/p7fSRSLqe/e7JuuZ9V/xu6S2ln64Tr6oHpD7+pD9sYO6nhTG5tZimA2k/3ainONWbSdkMVnrlo8IV9VrQ8GK/zW4LCsm4jxNLKmoRo2tul6fXoWsoNPkcAYpG2x1UVzh7lrDA7Z+MOU6lfKVZUa4yPNqTxwUhAyx27Xa4t3vJTjz0iTfoQ9SEq23w1nlzmOj+L2E6IP5I+XFROJ+f2aEgWMwff59bnNK6v+S5CEcdP+FcgK2aS2jMiHn0wCimUfF8PAaF0l2bFeEarMm7kVSby3wAUY3XFkD6l7hfr3zAiTCBlv7RzIq7Nqzz4N/rovtLsezhp6CQURGJYAwMwDVKnTDUyCK9QJtUoXLrssamXC+DyGGDGNo5yYkDIAEtPfdd2VNmjxadBCboNOQsawkgv8nMl4f5OQ0JJFDiN8YaduMOFd0BJcIvOgAUgIDypz4P0d7tTUsxqBIkLpqThd50yxCqNAYjslSfu+0inBtT9bVazvpctrR1q+eaWwSZ67QCJH+e/CPoChWHrotdPTGX8Z42aSB+vafR5qJU0uqsYxo1U3FREhC7Y1ngnaDaUG0SDLwPIeaHA+T/rr99uTX/4X+YtcN4D+UkjY8LSbhRQSmrpzys1YtLN6tWmwS8O0a0+NsLUAhNkZJaoGj/3MgMU98afHa3vGvMMcKZ7KRkEZXLzVhH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TDFnSTNNMlYwMUpsbElPa2tqc3ovMmVJMjJqSSsva2JSbjI1ME92UVlFN3l5?=
 =?utf-8?B?Mm8rVGQ3SEVlYWt1dmxBMFc4UXdxbUtUUmdZWWVpN0xJdW5KRktvL2dBbkNZ?=
 =?utf-8?B?ZWcxN3ArTkJ4L1BiVFM5aHl6VTBlQnZHVXgzcEYyZjBjZFhWb0tuYk45ak5K?=
 =?utf-8?B?Vk0wVlVsZU1XZ2MxRFo5b3phZENpME01dXE0ZjFyb01UV3pvMEVCM1pXdStw?=
 =?utf-8?B?TDNrNEZibGhQTGZtNXc1dmdHbFF4SUhJRlVOemgvTVVzcXVYWndWYlR3RHBI?=
 =?utf-8?B?Zng3L0V6UmpPUHoxbjZmeTJRV2t2Si94bTZPR21Qb25hM0RwQWY1RjhVNGp5?=
 =?utf-8?B?RG9iNm5GY0pSbS8vbFJzeDNvc0sxL3I4WmRSekFhNWwvTnJESUJDeE0vZnhm?=
 =?utf-8?B?Nkl3OVlrQUV1TEdidHNwSVBrelIvaWV3eG9ZS0tDcXRuVW9lRS9hc3NzNmhR?=
 =?utf-8?B?R2lzZTQzOFFaQmJqRTBLby9McElvWno3N3E5YWJYZHMzODlxMFJOb2F1UFFz?=
 =?utf-8?B?QnRqcndxcjVVVWRIMlgwMGVTY0VQQlZhYUpBeFJNSXB1WnV2cnVYNDM5Q2xG?=
 =?utf-8?B?R1VNOHE4YzBFM3NVeW9DZ081ZHdFOFZMcVBvZ2p4d2tFdjlES2ZwNUprU0dr?=
 =?utf-8?B?MWwwWXRJWk5XcmdZMms0VEg2Z0RyRGRqdmt4amRleFpzaG9CWFQ3Z2thNVE2?=
 =?utf-8?B?RE1LNTg0MitRMDdiVGxXcktXaUMvemJhMGRxRU1QKzE5UXphQVdjT3hqcHZa?=
 =?utf-8?B?Nnl6WllwZ3BidlBPYmpBL2Z0QVRMdTh3dGFmV1hHTTRNWCtnV2FJenpscXcz?=
 =?utf-8?B?aFVkbHEyVDNoc2VjVnA3c3BGNnN1bm5TKzlDYUN4dWlsRkJ5SDVIamJyU1lI?=
 =?utf-8?B?OGZLblU5SEVieDlhaXZjVWFIemhQb2MybUJMa2g0eTV5d0dJT0NzN1p5SFRR?=
 =?utf-8?B?UlhGSlZJZHVSbmEvZXRjMm0yMDVLZ2pFOWVPaDEvV293TDk3a2lSaGsyR1A5?=
 =?utf-8?B?UkhiNGtvTFFEaGFEOUdnQ1ZEWWQrZ2RhZi9mV1NOeFVKaUZ1T0JWejNlWStQ?=
 =?utf-8?B?a3M5eUk3dUN6ajM2RGpzREgrUWtOL2ZMdktTNlY1MlhOZGJqekFqd1dFR21D?=
 =?utf-8?B?U0NUeFFzb21UOWxnbGNOUE1kZjdGYVBiVGtZY2FqZ05TaE1relRpYWE1NEgz?=
 =?utf-8?B?S1Q1YlVBM2xWWHE4WHM0VmtaY090S3hOc3RHRE9qMTFmeTZsNVIvR2dGL1lZ?=
 =?utf-8?B?ck5uSDdzTHF5Zldjb3Frc2xDZ1JhOHdOWkhwbjYxVnZHalpCQXpCTHZHaTA1?=
 =?utf-8?B?YldzN2psMkJFMjdTRVIxdjl0UVE5NHdrQ2JScXYrNUpkSFBNVmh2ZGtHMHRu?=
 =?utf-8?B?cHNFTHcxaVozSmVpRkUxR05yZ2FiV2tEUjdETHR0eUM2blhNQ2lLQW5wckxa?=
 =?utf-8?B?OVRGRnF4NU1ReStPYUY2c0pWdzU0U1BSeURNUUU0RTM5eE1rTjViMG5HbWYr?=
 =?utf-8?B?NVJOQ2lvNXk2MGtaTTYzV1d2SVl4ajlHWWtvSks0dEY3UGRienRlQVFFcU05?=
 =?utf-8?B?OW82eUxOUTR0NWh6eWhwd2txREVXWm5JOUNTK0Z4b0EwYi9rRmVWY2QyK054?=
 =?utf-8?B?b0x5dlAramM3ZkVNZDJxVTBzK0Q0ZjBZNG5oMGRkbncxOVNraHhLbnloelJm?=
 =?utf-8?B?S3gwemxvSXVmK3E4VjJRbmJWSGNnVGlpMkVESDFUYUhwbDRtb3hWSXNXSVBX?=
 =?utf-8?Q?Ap6YKxJKrYeNyvY0tXABRHY2lsyme1saZzj5sZg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b51fd9-f21a-4ba6-4e76-08d8f32f9ecb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:12.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsEKaMRwS8M4kYTwkn6XrugGzKBjIvx1ezqagFwa0usvRzZ/t7ksjiSZn6TlcRbfNf9aIE3ZavYPCXlLNutrUFwp2Pkph4NDDpTefKZx1Tc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-GUID: NhrQsQiVZhlMlMqt_SVOWcgdypFt3nK1
X-Proofpoint-ORIG-GUID: NhrQsQiVZhlMlMqt_SVOWcgdypFt3nK1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 08:51:45 +0530, Bhaskar Chowdhury wrote:

> s/encloure/enclosure/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix a typo
      https://git.kernel.org/mkp/scsi/c/206a3afa9482

-- 
Martin K. Petersen	Oracle Linux Engineering
