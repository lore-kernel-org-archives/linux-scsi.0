Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51320C43333
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2578064F30
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhCSDr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47168 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbhCSDrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3UFTJ171057;
        Fri, 19 Mar 2021 03:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=O5iREcvKO+lYDhmnQF9Lo4Zh/R4/yxGL1/8FBWQ/XGs=;
 b=R82Py79X3UtRzNakQPRN0CUThkMmGydTg6+7biV+ChHNZeoEYJ56X1NQqPP53VH0PXef
 OD7R8wlY/s1XwVK9/fg7vNvTfU4EMiYD80uu01lewQID9qhUFUZxH4wfGWn+SeckvrJa
 AUe4caKULOV6vEaL95iqFCZgtmxhCOI2kXOK0FmEmuqdGYGo3G+XKPGzDFVCYLWPf8C3
 UmBRxwKEKpz3lxNMdW7NtQ4O5hQCW9W8R0gyone8ODvdyPfGrG/CFV+A2L/SezTE7RO1
 3XldW2yTeJI5S9He2xW1LX6vsfN7Mmoz80a0CUCw4O6wObKZAC2qFAqzvBNiLXftkl1K ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbskem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U8cl175034;
        Fri, 19 Mar 2021 03:47:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 37cf2v0ds7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCrItiTePTRZOnKAXDD/cDt6TBLwDkndxLviRzwg6QFqmnCVRGrcUoU7C3TDSNTEUklAWyq2zcGsr/B7TlDpnDnObQ5jGXMm8dXUutdr1Mlh08kHYV86u9kjUxEVzxuRy8a2LRhP9+nBAgWUqwchfhICkpYUthqX4hCMJwicWKum/SZf5WWmw3bAspPhSWDw3PSbscMX0/NTQKqk+hvM41ovVkp/5EHyAdoogWKDzSH1zFf/hSWTjrPoLDbgNV+NlggIWONstVZAMENQt9SAisT6sCsCHmu5YkTu1+C57GtxOCyYZShvfajKe6cf4ytgK4r6ig+ERmjU8U6EkRyDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5iREcvKO+lYDhmnQF9Lo4Zh/R4/yxGL1/8FBWQ/XGs=;
 b=YFxFGY1xW3uTm3mBE5cz/Fy4M/yrKin0LGa4WmmwflQei3VB9YrxbMVn+Pr4uU4XcCF+k8Kv9OP7lPaLYQs1PTOWM3JNN37Pj6UOBc4RlPQOUviaQRcMy9P+oH3BjBIHGERbtHV1mgnEM/QAv1hX0aA2mUyapRfhlIjHM0uCK6/B4hFhXo8KQgkCT6mu2FaKFJLqRFhjnZstFojW2Ak0QEUr1CyMMvQ4TESXJ9la3tyGopwii2ypEQcMxvpeZhRdBMv7nY7oNTpMGfEqtB/tHjMfnJxIitMGY396PGUHluQaQ/+IOxg/wwbE2y64zWiR1Xy1MGHARPqI16wInCtr8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5iREcvKO+lYDhmnQF9Lo4Zh/R4/yxGL1/8FBWQ/XGs=;
 b=yNsTOtnMDq4aDR2zIb3IRO8Pr0SLrB1H5vhTnGBltP7dbbj1fXq7BarjOKW7dl9B4KcSDpgfGjZGsOKPsM9ZXjQLzwXLGaTOsVAh6oXZZO6c1jM2lMwntcv4xZFQVzuJMfnm6v3U0mQYUKftAIKN24SmvODEixucDBmOpEyj34c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH 0/7] Handle DMA allocations in same 4G region.
Date:   Thu, 18 Mar 2021 23:46:41 -0400
Message-Id: <161612513555.25210.16805688562056096998.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210305102904.7560-1-suganath-prabu.subramani@broadcom.com>
References: <20210305102904.7560-1-suganath-prabu.subramani@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88a8c23b-34f4-487c-5e4c-08d8ea89ac05
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB447079E016B1E3F1B84C08E78E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSknMJcCFj+tc8s+hS2oycO+ZvEnw3cAYIUaLILTuvhnutvQyXKthOyO0Z6g+bdhzbfUjgTs4ZNr8ojUHSsiixGBKW1/yzJRHzk+NYfyotuMsfMkjVlz2i/ULXNjptjnoi8t6vOzR0pO+tInanVrpSWjqd5HGswLg4lTvYmCYdGMmTWTosYnVAE+P+DvXvsfgnXDXepjak2hF6I/A3h35gt5NYwq3H2jaWo/+Lcei7T9shZPv1a0kY2ZRzBSG1hWL0dBrVGVwLqCoElwdRPZNM8Ir3+O5piBgHWB2Ykwujx5L+bKzA5JpMIUZMf1LRpoe3eVfG1b8KTbsDcq3m5bFGB1xyxlBw2yc8jWgKY8Ovrp2xAajdCzXig/txMn9PfsX3JcF5cbXVzloMHvSgPv3eHsBgpARXUolZNsShT14fot0akEsfs1G9XNkvskCFiT2NqJ/unm8Kd6RXmxfeYbrFn5uQiYrkP+VH5hfSZGDugwZ3DUFOIfF/pdqgR5Uh4xeFHv3+J37NYPwA1ppCFq/ULpodGah0XZUVxRBAHhjZiv2fiu9/WL+sHjbdTw77BT55fmM1kgNCLO2vm9/R07DvNy5qZR+MdnAXvYMcFyCPbiMvemeW/elo9SxppPukKA6we7QO5vGz6e1lyfnR0wrR/j1bSEwB6B6RovMdalK0QvTOYb/ijH7IOMrvO9Ky300oqh9q9dZajt6OP0ynYYuVn+Cfrf4OTr6IICjeHNvDU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(6916009)(6666004)(316002)(8936002)(103116003)(86362001)(966005)(2616005)(26005)(66476007)(66946007)(36756003)(52116002)(7696005)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3BCZk4xYUFaVTRsWWY0R2tqZVprdzVETy9aa3p6V2R0Um1LeVZQQ0gyeDk0?=
 =?utf-8?B?bkZmVGhyN20zNzNwcHJDaXNLT3ZYUW5xL0ZXbTR1aFQ5M2tPZWJMcThETW5L?=
 =?utf-8?B?OWVsbzE2dUZlVno0cUo5aTJVU3M4U1k4MnJRZEJjODhZVnJBUFcvNjBaU0Mr?=
 =?utf-8?B?Ly9vMnlYODBsbGtmUDVINGwvVDJ3UkZTR2lXRGI2U1hwWDRZS3ZzR0V4eFUx?=
 =?utf-8?B?MUphaVFPM1Rray96bmowbFUrczhBNXhsMWNEUmpSMS9mWmR5OVg0b01Jdy9l?=
 =?utf-8?B?L1pWMEVuNzR2Vy9rdm5vMS9kZVBvMGo4VC9XTit5K3RWZEk3c0ptQzFycG1p?=
 =?utf-8?B?L1hCcG92b2dsN0tZZmZydFlMU3N5cmljZGQ2bW5RZUFMcTNPR1U0VkgyQ0xi?=
 =?utf-8?B?a2VVbUdkMngwcGs3REpkZ3d6TlFmUXFNbzVWbStnclN3TWpIcHRGWnlMd1l3?=
 =?utf-8?B?WEYwTjFpVUlhM3czYUtwRzlTTjFUZ2MzTlIzR0lyaHdDc0lPVE9YMVhNMG5v?=
 =?utf-8?B?dHVOMy9manVTL2xWTk9MQ0owWVNiN01LUFFndWtMWjBkU3B1K2NGZnd5ajh0?=
 =?utf-8?B?MVRjVWpINnFOeUlEVFcyN0YySkQxZ3VEZTBDbTVDNFMwYjRUUFdpbXhjTTZm?=
 =?utf-8?B?UlQ4ZkdGbHl6SUNiS2Y3UEVtTTJUbUxkcUlKbFRvWmNHMGNVZFdiSFJmeHJC?=
 =?utf-8?B?alo1NVBSVjFRYUw1dlYvUjVCU0xydkUzY2RPNVhpMWNiVHA3Ti9mYlRiSXNF?=
 =?utf-8?B?bTI4QkpnaUViVE9HcnB2MDgzMldOaWlBY1ZNZThRaWc1UjB6VWZDVHJ2K3I3?=
 =?utf-8?B?ZkJZT1RPL0ZHcktPMjBERFNTdGVsVVdSd0NHd3JzWEFmeUJlMkZXbmdtZkR5?=
 =?utf-8?B?K085M2NLN2F0ZDgyYkxKRWIyN0Y5Y25mb25pTUhJSHNXb2VTUlBnZXlvZFV4?=
 =?utf-8?B?NmxwL1EwMjRUU1IrNHpOWi92Y2FyeVhNWC8wUSs0NHlSUnZjQ1ZKaW1JYTJL?=
 =?utf-8?B?Nk9FbUd3ZDJQdjYya21rQllVbFczcDMzR3NENnJWZEl2U2oyS0ljOUlsSTdZ?=
 =?utf-8?B?UWI0bnQ4bnVnaE9renhOS0NOLzd0K2FDSmwweFJqVzlVckV4SWg0MGhkUWtw?=
 =?utf-8?B?ZC9tekd0WlAxM0k2dWVYSUh0R2tkWUUwZDRnOWlFRkQ2cUlNS3ZWclQ3aDRS?=
 =?utf-8?B?YlNRY2hnb1d6Mmg2ZFRVL2Z4U3ZxWGxkYzdLcFk0OTRsSTI1VC85Mm03dUFY?=
 =?utf-8?B?RkJiSE5ySmlVQnNXSitwSk9UM3NzaHJQcW9OMG5rRDFqRkF2SlFVTDBhbHBV?=
 =?utf-8?B?c3NPZFEvN25uRVBsOEVjemhlazdrOEk3d2RZZ1pwVDBqbkNzOFBWcFJzQXMr?=
 =?utf-8?B?T0xaU2FmZTIxbHI4UERuMmdYNTY0b2lTeEdRMUNQV1BjSk9QeTZiVTRBUFpS?=
 =?utf-8?B?NnRTNmdEY1lkbGpxYkp6Q2JQbkRyQ1B4WldVYU5PK2xsTndhWWg4TTdxRTdP?=
 =?utf-8?B?VHNMK1h0MGpBaGVlWThQK1VCN01sVGRIR09SL05hekFSUSsxYTRvNHdUczYz?=
 =?utf-8?B?Qyt3YlczMzJFSlNrSVJWdVBJMHBWQnVpS3FGS3VRRmFuenh4eGdGZGE1WTNW?=
 =?utf-8?B?Z2RTS01rTjhqTDFiamdsOHJiT1ZyZzNhZnAwM2NXVDlNamZIWENZSzRpZUhy?=
 =?utf-8?B?TU5qdXVwMEw3bXpTQmVxdFQrRjUzK3pTeExIZ0FzSit1aVJFNWhZdmpEWVBw?=
 =?utf-8?Q?GzoZOQA4y4NkwyD1R1ovHiEnc4VhtxD8aG2Bjzw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a8c23b-34f4-487c-5e4c-08d8ea89ac05
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:09.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NKLcMgREHXcavZQeKS9fUgnYRy10uKejMGiJoR8aubY7MauacDHAogNazVcPMY1nzHw0WSFX23bx1fuMiVcrHO0dXlp48dle62D6aX7+eb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=830 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Mar 2021 15:58:57 +0530, Suganath Prabu S wrote:

> According to MPI Specification PCIe SGL, Sense pool, Chain pool,
> reply pool, reply post pool & reply post array buffers should not cross
> 4GB boundary. So while allocating these buffers, if any of these
> pool buffer crosses the 4GB boundary then,
> * Release the already allocated memory pools and
> * Reallocate them by changing the DMA coherent mask to 32 bit.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/7] mpt3sas: Handle PCIe sgl's in same 4G region.
      https://git.kernel.org/mkp/scsi/c/d6adc251dd2f
[2/7] mpt3sas: Handle chain buffer DMA allocations in same 4G region
      https://git.kernel.org/mkp/scsi/c/7dd847dae1c4
[3/7] mpt3sas: Handle sense buffer DMA allocations in same 4G region
      https://git.kernel.org/mkp/scsi/c/970ac2bb70e7
[4/7] mpt3sas: Handle reply pool DMA allocations in same 4G region
      https://git.kernel.org/mkp/scsi/c/58501fd9375f
[5/7] mpt3sas: Handle Reply post queue DMA allocations in same 4G region
      https://git.kernel.org/mkp/scsi/c/2e4e8587327b
[6/7] mpt3sas: Handle reply post array DMA allocations in same 4G region
      https://git.kernel.org/mkp/scsi/c/c569de899bb4
[7/7] mpt3sas : Update driver version to 37.101.00.00
      https://git.kernel.org/mkp/scsi/c/37067b979309

-- 
Martin K. Petersen	Oracle Linux Engineering
