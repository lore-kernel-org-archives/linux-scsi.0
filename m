Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DCCC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 02:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BD3864F59
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 02:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhBCCRl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 21:17:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbhBCCRi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 21:17:38 -0500
X-Greylist: delayed 2549 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 21:17:37 EST
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132DoJN036197;
        Wed, 3 Feb 2021 02:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uf+QJYCGcXYwei3Nrcef8VslEL+dbgcoYaICmcNjc6k=;
 b=dIdWrZp6yM1sBHig++ISysqOuJUP7J59FFM1qKc7nZgWg2Mk9fnBhLov9+pyEEZN20ja
 iqahRBGddrJJf+86T2WuWLzehI3lDkkzL47rkh7IOgsCWyFx10RRxFYsfkY5f44hiTpl
 4Nd15Zr1YRzVI3y2jtPEVL/cfSCz+l0550naq1jlo1PuJC9lAVShN3gb7uunCP8WfnJL
 KoUzSEOoFbHutraCpMZUhl5SRg5OQsdyb0mnLpb5FRnw283BCqZhz71N5IykBMu56BVZ
 SCD3MJLbQKARrh5IGTDXFsP5yYzyN/hs3oecv8j0Pg2+OXikCK1kLE+qHkftzFCowOUU lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36dn4wkkas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1132GDW8061556;
        Wed, 3 Feb 2021 02:16:50 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2052.outbound.protection.outlook.com [104.47.37.52])
        by userp3020.oracle.com with ESMTP id 36dh7sgyyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 02:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IArBqNzdbixQJ+pJg5XuS4fD4BRmjR/9St3FTsU/SyNvoG3lmWS5en1Pf4m1Y0u2InkClha1SlxlXCAhmnQeBQbx6Ju1+o8hF+U5GD1KGa3Xg/orIbqJKFviD8uR7L8/ps1WoK5QbWSopfMA5fnPkanbp2Gi4iSyI7Ot7QY3cehgBgWs7wLE90Ra2yhGU/VDV3DL1PGIMxLjOHgCJSHGkxkg3yRQswVtSYK+MaghM6/XZvX58o64UtS3OSpCBtDUpmJ81eP+HIq89Jr+c3rEf9vL4ECTn9PaBFQsFLsM+gRJOHrQpJf2QFYX5eVlT+3RWkH8HspFNs2PVvEl88PD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf+QJYCGcXYwei3Nrcef8VslEL+dbgcoYaICmcNjc6k=;
 b=D4k2+EHISesfnGN8Tk54Yca2HIgGF3TUWLVf0GYE5/d/1P5JbzrU4teXFa9KdYAcSxgi4rSPWHyFZxKaGbhYEHrO8A4zw8J4AK4HpRFt2YGIvgPmMG04H2lWrRprqlWjiemmrAdJHZZ5SaW8MqXNYdSQhZcO6+d24kkpdaHv1Ue1bm/D2LY458QHua5mbXwPnxBvxjzvDeXmYyyOIt3ehbltc8XbpOE1ls6TWe9HDKc2UNjgoiarY0o8NQcbEoICz+xTidFYh1Mlzg9CIqyMzg6SOwK9vxn6gSYEFbLkrq7nSKeemzKNy745g1a3Z+AXVGx8UrH5kTZsy6pYqnVQYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf+QJYCGcXYwei3Nrcef8VslEL+dbgcoYaICmcNjc6k=;
 b=SZa6sVSW+vkNxTsHH8H0pROgZTLKe++Fpso2RaQaCA4FM8CPxRBa0dvItYrjy9OoOprXNMc4GxjjrefKKu3wVABLIWHFFMiVz7NqDu3R2GvCBVgzSeVjX61Cso85AxebPZMLc15icEeuLZw0ioB4oztSGD+ly6WwcU849JspPTA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN6PR10MB1460.namprd10.prod.outlook.com (2603:10b6:404:44::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Wed, 3 Feb
 2021 02:16:48 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 02:16:48 +0000
Subject: Re: [PATCH V3] iscsi: Do Not set param when sock is NULL
To:     Gulam Mohamed <gulam.mohamed@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20210128061753.1206620-1-gulam.mohamed@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <f8141353-7792-59d7-1f36-f338bb25cf7e@oracle.com>
Date:   Tue, 2 Feb 2021 20:16:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210128061753.1206620-1-gulam.mohamed@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:610:5a::13) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR08CA0003.namprd08.prod.outlook.com (2603:10b6:610:5a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Wed, 3 Feb 2021 02:16:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ad17022-5a5b-4a92-3676-08d8c7e9c2ae
X-MS-TrafficTypeDiagnostic: BN6PR10MB1460:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR10MB1460538805914171F988339AF1B49@BN6PR10MB1460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bH+O9Rcs9xOrEL25GeKtGJv/8GWOPCOonnC8sC3q0VVGq64YqtGryEiEMfTq9U9TLzqwaptZChEGx2OJZtFdVJ/NExOL6FfGntD4iDPQxWgI15jAbINYrgMi2dWJdQjeCLu/tSn9toxFyqaPCfoWord8aRDpGOAL+Mg87JTkkMsmAH6uY2EwBB/4WGnOEavmbn/KbvLJQwFRtzkm0rWGpmynXAJ4Aclfo4oBK0fLLyClD8rSLYIcOTLvJm+7xR/juzr/wfU7uZRALptrj1gUkZ5Bu2qlUrMfjmpKaEYXEG6Z1FTkTGt8Qe8OQYoMJ3yfl4OI4gm9tZhoy4/75sV4nzFvyVQlwRekV2pbWHPcTzX+2rqeOLq+j5Tz1mfmPfXxM9QZFiR+bU2n3Gr+JF379UEpfVaeR4JI8CgqoplmgFyg9Xz2RRphM27roJPtP9qVTHaV96Ds+XU77kGvbD9Ul9mTu+spQeGZOtZ0AysBWw27WA5nJ2RmfcrKYLj4wLDU8zt0Bdeh5DMhWMVoIeshrk/YZbReP1sWMc0AeXrQ7BauliVVDL5t8zstiwlAJtle6UomA0r9Nz+WnwvRzJcbY1BOeKAKVelFnZDn2O5HO/QBQlH4F6HoUACknQMWHNSQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(376002)(136003)(956004)(4744005)(8936002)(2906002)(66476007)(66946007)(31686004)(66556008)(6486002)(2616005)(316002)(16526019)(478600001)(86362001)(26005)(6706004)(53546011)(36756003)(186003)(16576012)(31696002)(8676002)(83380400001)(5660300002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YVJJOXQyZVl6TEc3ejlEbWtETzRQZXFTS0Q0S1BhMTR5ZmVsbHJFcUFWNVcw?=
 =?utf-8?B?L1ozdGFUNlpBMzV6WW0zeFg1aVdYOU4xVmtsSkhxY21rdm16NlV2R3FOSXZS?=
 =?utf-8?B?RDBYbWpGRlplaDhiUEx6M285RlZMZ2ZDSkJpdi9FVDF4WXlOd3cyTTU0SkNJ?=
 =?utf-8?B?OWFFYW04b1NRRGU1aW5UTnZ3ZzhzN2pjN0RraTMvRytBemVETjExNUhZWWsz?=
 =?utf-8?B?RkR0cXAzOVFSTTR3RFRMeDY0aE9leXlFU1prVys4eVA5ZTIxeUVlQmRTVzhX?=
 =?utf-8?B?a0dKNmJwOEF1VTFqYjBXMnA4TlFzcEZWV1I4a0FkTlcreDg0UlBBSDRjK1pE?=
 =?utf-8?B?RkNrTnJVN2hwSEN4Q1p1M0EwUnRXSkx5ZVhOQm5aeFhNVyt4ZW90dlc0eWlP?=
 =?utf-8?B?UjVvU2MyOVJIYXBaM2xuRHl2Mk5NTmludVFqeUcwRHo5Vk9ML0RDM2YyYjgr?=
 =?utf-8?B?WEU0Y2gzQ0l2ZC9lQkdQRTBUL2xQSDdHMjBKYXZDeERQUkRrczRvYUg0c3h4?=
 =?utf-8?B?eGdwc3prbkxBSEVhMk91cGFTbFNPR1hxTWZjREs5QURnNGZBajBjcVlUbzUv?=
 =?utf-8?B?UWs0U3ZRRzlibDcvWkttYXNSVng3Y3VrallrWGRzbzNzeEpZbUVLeC9mR3kr?=
 =?utf-8?B?VTNzOHFFMDlaMkEvZ2Naam4yNXhQaU0vRmhNWi9sb1lsQ2FzNnVhSjBXWHZ4?=
 =?utf-8?B?bTVyNlBrVGNxRzVkakFxNGk3L3Y2ZnhINE5DNlUzOWF6S2Y2c25NV1pTYm55?=
 =?utf-8?B?S1Q2US9vakNQL0haM1ZGeUgvNjNVOHlNSk9hKzY5Z0pMUGdEdG9zU3RENzdR?=
 =?utf-8?B?KzhBenN1M3V0cXRiOThOVFpENms3WkNOcnREMVNwcEIrUXFmTVNGSy80ZlIz?=
 =?utf-8?B?MDl5RFYwbnJLaXN1d3FoajlWMEh4NDlYY2prQ0gvRHl6dmJvbHRNUzRRbGU5?=
 =?utf-8?B?Nmx3dGJxdk11RGhXSndrNjRzTkdSanF4R0h4d1V2NC91RW1pUlVoMWl2WFU4?=
 =?utf-8?B?UytXZGxHNTZQNzR2czUwa0VrbTRmYVFWb2FMTXRSYjF5cXZQdEQxdnI1WElX?=
 =?utf-8?B?U0xoYi9OZ2NWeWh2ZjJYNU94TGlRZjNDZmFGSVpTdG9LOERqbHJEaXdjK3o4?=
 =?utf-8?B?MkFrWEkyWXdoZmVjR015R0NyM0t4QnFkR2FBVzdoclRocHJhQnM5Q3pzSUFt?=
 =?utf-8?B?WkkzNTVMMzdSaU1SWDZkWDF3ZTdBbWVZN2NjNVdoaW83bHo5d1lxdWpCVmpE?=
 =?utf-8?B?cGFMbXVJWmR5cjZlQWJJelplQktDWkQ5cTJTWHpmNWlCRXBaYnp5emE4SUFx?=
 =?utf-8?B?cURvT3pSZXBscVdwWUcveWxMdEl1QTNjbHFLY3RFcHJEcTJLYWJiSlUrTEFs?=
 =?utf-8?B?b2tHRGg4Q2FoVmI4RVV0RDYzaklEMUE5aWhva3BPYm1mNHZjRWVNTElURFF6?=
 =?utf-8?Q?jcoTrcxS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad17022-5a5b-4a92-3676-08d8c7e9c2ae
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 02:16:48.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpDXaIwMAO/ktzRcfKZW7vk+GDA+oFhFq4ZQ9abn+eG8eY/xEuBYw0KsWxEP7OYWmZEPFDMQhJcAS9sgKgkH+7Ha5O+8Al4I6qwrdKWpDPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1460
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030007
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030007
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/21 12:17 AM, Gulam Mohamed wrote:
> Description
> ===========
> 1. This Kernel panic could be due to a timing issue when there is a race
>    between the sync thread and the initiator was processing of a login r

Hey,

Sorry. When I had said that we want to limit the width, I didn't mean that
it should split words like above.

>  	default:
> +		if (conn->state != ISCSI_CONN_BOUND)
> +			return -ENOTCONN;

How about making this a check for BOUND or UP? Some of the settings, like
the TMF related ones, can be set after the conn is connected. open-iscsi
doesn't support it, but maybe other tools do. Also there might be the case
where a tool sets a value then forces a relogin and the new value would get
used for some drivers.
