Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FB2C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1620F613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344714AbhDMFtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344695AbhDMFsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5hoGr053568;
        Tue, 13 Apr 2021 05:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hUIp8n/F7a6jTcEqUZyIbL1yErhqi0Bj9PbCHPd47QU=;
 b=FcJwKE2FY3PrQIb/6z9hrXz7uHwZlQaQ2CeN05C9/h7K24oJc59Gu5nG2URGAv5+F3ET
 rLRzasSkwvCurgfcxNSgkklFVl/WSVD7+D0PGGg89Dhiwz2kUF42ao6iYkx6NZuDWtUI
 0u+yF50Fv3CXzyevpNwwqphsOkRHGWULCqKApkvkhGNjW7j7QvNtlgoJM7UXuHdqtVSv
 ZHZeaMMuislItjRRX8JRYddJQqhKulvnfNiMAd+BZlAQegFkchjtMyz3EWPL3D8SRq6a
 qdroNS357mgREu3aUzrza6XrUMOIX64jnFIP+Q56Mk/HqlTmAxptMvXjeutrhQAKXl2C vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3erdust-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jRp3090754;
        Tue, 13 Apr 2021 05:48:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 37unsrxcbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3bWm7CJbx5OrgwBua4UmEG6hAeU24T/Se1psMuGamqn9Hmrux2WiLpASg0n3HzVkKQHupiLQb9qYY2bQst8RykyU2ymH60KUyY4UHFR/eXDsDP44XS445vwQ+w744tvwK+MzKtHTiowR9b3RgYXDWXrfcfBOnSjPdo2W6SRB0EdYa1FLL/wMlEaPeHYDp1HFv2gacb+aq13xSQgaXXTRxpR2MQOnA4jzA1KorgRkJiNqy7/2nDUVv3aCBFRrGEeGTqMFjxpCixjCywHTRuJZ7pkHaZeIX1AMSgkSxmnYtFNkOwIt9Hu/d0sV5Kv/7h8ibDo4dPDYDObLlng69meBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUIp8n/F7a6jTcEqUZyIbL1yErhqi0Bj9PbCHPd47QU=;
 b=SMkbWXPBO5DCS7rEg2ypYVMoM3oIocSDjHid+JODLadIiHeuTWFvQnRBhR0HxWa7jKyvWRzfyrtlomQcWPKjai5vSAVxDJmlUJpXYzGv2OeudU3M82CZsie01gc+5MnOBXh9eHR4iuGaZu8zReEStFMwVsBK7+SDHsq503e0U8UtklvvvuZEd8E5FyDPtk1Z9dVu5cuk13WEETAIYnOIHZOVezJS57fyCW26BME0fIt/JlRtiUMAnsgf12jTx/5nX30Y0VWPBbvzINDUXxktROLZUbXO54lf1XxLYZMMXsPqz4/tBsfSj4Qle3Gm9WwfzHJmu2FjrnNiUblyeBJSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUIp8n/F7a6jTcEqUZyIbL1yErhqi0Bj9PbCHPd47QU=;
 b=qnTPejeFG/wVcrzDwH0Vdn79Mnh1fULzG8VZbetyXxQDZe3lJL9zfpMLPyTRR3nZRVz6nETAN3T88aKiK77SWuII4Hm/HsK9Gm3Dy+C90Oek/gEkmOFy4u0yveaAXDQkPRvasBe+cXbFMSmCXJqkJwnbeQ+69nSMMruAmXLSXtM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hare@suse.de
Subject: Re: [PATCH] scsi_dh_alua: remove check for ASC 24h when ILLEGAL_REQUEST returned on RTPG w/extended header
Date:   Tue, 13 Apr 2021 01:48:10 -0400
Message-Id: <161828336216.27813.6602800554497462104.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201154.20348-1-emilne@redhat.com>
References: <20210331201154.20348-1-emilne@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71c68c54-0ab3-499c-7690-08d8fe3fc044
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46147B683D86A031F7AB3CDD8E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jgQ6x735GTtNDimDYnDZXFQCslv8kO5S65swrtFRav95oVAORofVmmytGQ5qCq9U6kO9rdkelP2w9aeQvKG3wJf1vY/Ah0I6D8pyC2tJBfEUTj8cp7+dcP1Bl4HkwpTq/hFMZyoW682nfPshXihXLHbZ5QCgshy2LoTMqDxLL59Wi6vdS1ZDJ6HOqYeT/lK80io8J0+NyeqaiJ8O1i06XNsbVPKontjgfVT+yL6co6SBmwxofrNpwtz4YmYP55fqmXRf4eEm6zQl83Z1ZNaQpcRqTULrC+sU/j7il6oOrsjBwyKOeh3D8Qx1jLScJ+Mxr/V/AC7+TSzoXCU5CycjC1iOkHL+r6g/AaxpjsJastWcF2jT+Epr93mzVKmJL1njfO689Lsrzx71OLdNUpi7OXIwd3utsh92IxWmvO1Y799xRBJXj1Wk10MUdIioAFKY7Z3dkTCAFDV550B6umMYXuO8kR/BFyLXnYFzHSfNQBrannwfYUHbZh5Bmc3fPUq8xj337jm2q/e7j9whB9+LeAHjtGEWdeOBlky237It301V/mWhE3GkglKm+gg8DjRXvHBen6Q3uZf81pb5oOtdzuB/kWBQNQ48mVM7fXIvuE/jYuMmHr+Zy1vIax/ci0elthhucrU1Xjldg+BvsnV62f+Mh4+soJ2IbGFXj+Sb/shBH4A7b9QZDR6Tdwzfasvs9PnGLzLw65/oDihbwI8qGRxGqSiOWM2xjrVdLzYyGPE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6916009)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V24wWitGS2gwV0RveWVUQm1sQzducTNMMWlabUljMnloQTBReWRwRjJnWGtp?=
 =?utf-8?B?bEdRU3dNa2hoNFpTcVEvaksyZW5DczMwTjFIRGI4UUpNdER1L1VSMENucW9m?=
 =?utf-8?B?MU1pUzFKVXhZRlVNZVZ5ZUtYVUFZYndzTVVDazRQdTJtSmZKWHg4TDFUYWQr?=
 =?utf-8?B?QjZnbTJUUG1IVHRzZ1Z0dDFkSUwvMEpYbnhWTGo1dmFMYlFkQUZScXV5aHBi?=
 =?utf-8?B?dEZxUTVDQUNPS0ZkT3g2ai9hKzFsSE5nRVczalh5MnJUem1DTmhIc09Keldn?=
 =?utf-8?B?KzByZFJnMHkyY3ZGdHFKcE9GSWpjMklaRzdRVm1lWVBWb0F6MFVXTmNSUk9a?=
 =?utf-8?B?ckdLUmFsTngwZmJBTlJQTEl5OE9tZzZXVUd2SG0wQURoSDJORHZiS2RqckpX?=
 =?utf-8?B?Y2czdGhieGFGbkgyRWV2enJvK0VHSXJMRExTQ3NVOHpudVpCTmJpUWcvWHJr?=
 =?utf-8?B?YlUwaDEvOUkyT0RZSkJBbW5yVHh2LzQ2VXhIMHRYK3Q0MEcyMG1vb3pYMlBI?=
 =?utf-8?B?bG5UMDhraVNYR1hFK2dnK2lQTlhiTmVjTU5GS2FQYy9mYnZGbzZFRG5Zc09K?=
 =?utf-8?B?UVZhOTJua1hMR2xNQk1aUExoL2dkL0w5cVJ4Uk9iUlVpbUtIRDBsQ3NzcGZR?=
 =?utf-8?B?eG14UnFEb2JnNXV5QllLS3FOWlNNcXJaeGNyQ2hXdjVoUW1hRE1ONmFob2xm?=
 =?utf-8?B?NGVMc1M0LzcyMWZrNVRkZjJyUGxlT1Fxc2tGWWtseDcwZHJxb1l5YzluVkVn?=
 =?utf-8?B?UUhXaVVjWVpvckIzMktuSFpTSWxGMnhReEI5T01vZWUvb09KQUR1NTVTQ1Y0?=
 =?utf-8?B?K1ZsK3RCUHhybmIycERWN01XUkx1L1JNdVZyZ3Y3cEV5dW5zL1RyVjdlc0pi?=
 =?utf-8?B?RE1ueWJMdXJ6UjVWYkttbUNNU0taYjZJRnZVbXpaa3pCQUFtUEo3TmoyU0N5?=
 =?utf-8?B?K1FjQWJ5VHBNbGZhUUdnSzZaRCtqa2ZFamY1eUV6cG1GQk5CZlRmenFqUEty?=
 =?utf-8?B?aVg4dnVFU3I1NEJoT2pWSHBuN1ZhZytGanlZUkljbFpiaW9pYTZLWVF0em5S?=
 =?utf-8?B?aVFzWW9iQjJmOW0wSkFMMUxZd0h4UFQyZHhpQ1lKQTZoZTY0cjhqTGlneDBw?=
 =?utf-8?B?VWpBaTgwc2tNT0tCYk1ZbEFnN010bjBLbzJqcmhUTDY4Y05CTndZTldnaU01?=
 =?utf-8?B?akdpN0g0NUtOekdGNVpGbDRBcGhTaHgwdHgvcXR3RTA3bVowSWIrY3J5eHIy?=
 =?utf-8?B?M0hta3dWSk03c2NvakxBdUFZQnhLTGpaZUZPdzMvVitFczg2a2Y1eVloa0Rp?=
 =?utf-8?B?V2tYUURxdTNzREtOUWN5WitmNGx3MXBZekN2RGtDVmJ2UkZObUVMOEthRU1R?=
 =?utf-8?B?VGthQ0VVa3hRR0I1UExCQVREMGYvc1hMTFNYRStVOERjbmkydjYvV0RrdzBX?=
 =?utf-8?B?UUhkUzhPNjE3NDFnUnQ2Z0FwcGtMWTlteWg3SzBmamJXM0Q0Z3MzbTA1NG9I?=
 =?utf-8?B?NEp0WHAwc1p3SmlOdlU3d01FbVhFZ2I1d0dJTnFNdHBob2RsNnhRK1Q0UmNh?=
 =?utf-8?B?NXovME9IeDNqcnRrd0l4dWloelZOR1RQMkpQL01pQmQ3dkFnNGthTWExbmpZ?=
 =?utf-8?B?VjgvVk1pQzhaNWIxMk1yRUo5dDhaaCtQZ0h3S2crYmdxM2FidVUxL0pFZFlz?=
 =?utf-8?B?c25lZWFNdGZnTEluTTg5N0UwTmpPOVlnODR6V3ZCVWFPbUhKNzFmbmNnVGxx?=
 =?utf-8?Q?bwIuNlsBlyW5x1CzyqojdY5EAaZPJcyVD4it9RV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c68c54-0ab3-499c-7690-08d8fe3fc044
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:23.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTlVMo67rQ7dSjysEa99ErwAZaACxuKjaSb7k6hf/XMghMRJiwkHRBHRoxaeYnziWtyKOHK0I2XWIh62OReo6yqDX6ba3Amkk5P8Y69wS+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: C84WC4GkQuif0Oi4nzkh8wmfJM3XxkJN
X-Proofpoint-GUID: C84WC4GkQuif0Oi4nzkh8wmfJM3XxkJN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2021 16:11:54 -0400, Ewan D. Milne wrote:

> Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't support the
> extended header, so remove the check for INVALID FIELD IN CDB.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi_dh_alua: remove check for ASC 24h when ILLEGAL_REQUEST returned on RTPG w/extended header
      https://git.kernel.org/mkp/scsi/c/bc3f2b42b70e

-- 
Martin K. Petersen	Oracle Linux Engineering
