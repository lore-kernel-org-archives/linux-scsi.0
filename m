Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0133C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 08:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78D9611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 08:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhDKIaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 04:30:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35456 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbhDKI3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 04:29:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B8TCIe177349;
        Sun, 11 Apr 2021 08:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=o24cCD9UiLyI5O2n2OoFHk47vki7Retcsi61qhvlONA=;
 b=DhdwZN4PdoXovX/xYKkAcqNb7f/Vno19XI0eZIzh0GjbLLC1WVDJ39BTpcy1swwy6JY1
 TzV7ztZuxLp0e9127NMP1B5MqKaBNNnOiY/vlHIgq6yxFG2UzpN0NeABnkfQxDRkwqmn
 FXnh9YKqMuyWrDjzRS98I+HWLvYXD47daOlfVYNHXgauvIYNm38uhaf9H9Gnw23ZfO90
 d+8bQ+3iy2aU1o3llKUNsA/o/ZryyAWqJ4ayXEM3JVkSvNrCHXVQdY99XE7iUdv4djs4
 zxoquGYXbCsZ8IRQR8TofM0EaHWKBp3hEkpxvQWlWctBqZu/UERNlzScz4nGbU4B5pLc ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37u4nn9b7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 08:29:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B8PK3O117807;
        Sun, 11 Apr 2021 08:29:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by userp3020.oracle.com with ESMTP id 37unsps5av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 08:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9ZCTjaDB9o2qOQiJLQx8x12lZ4Vk17Q08IiJD+/5OMeF1jd95oo7Gm4YI3/nJFfFjJNFyZIXf0Xn6bZhtwmNSCHEtA3bMAxXucZpzbICgVA/bh0dtCtgfI/fn1V64t25eY8RqGTYUe4X8Tqvm5G8/rz6YvwGzbz1foMK2HXPaTmlake5nZF3SgvU0FridJvMVDQ5bK4IIKRXBPKWhJ6WNxkT5Uk1UV3F34YmH4Dn5RH9UbXJgg/Nz1P+MUanpdAWRMLg1anuPacRGdmHeCiBjDi82nOZGPVRnBdofuKyltBhQDuk/r0ee5gTF2E7jkyMJXvd81gHuCuzMiuKt9B+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o24cCD9UiLyI5O2n2OoFHk47vki7Retcsi61qhvlONA=;
 b=Nnk0W7HLgFQjLRCyiKGc7prjSDr5NifbeChnYH0YmUVfyRm6zSzdtEFSud1CgkCFSM0BGk5o6L2dxev5jXsEX3D74X2oTtZMuAujgBGxaqzYUI+fY1avWi/u1DyL9Mex3Naqcb8G5jXZ+6qEvLeCl+qid56sPTMAu71BEXi9kOknZZ2M36RmVvjxdqkeqZffMx4qb3plwNndEAthKLlY0I6DAa4PTzchzza5uQJWfzp/42J2nwkkxCRX/BmGuWr2v2xLDQmKSTbOuvMLT6GBLEvK8ReNdQ/jupp1B0T4940Ig6V69RWYBR14Jag7ULCE20Bem97BK6+IIQ6pljFYnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o24cCD9UiLyI5O2n2OoFHk47vki7Retcsi61qhvlONA=;
 b=Xs6Zagv5A4GQfVNwx7o+z8bdyx96EKPBPKMZkNNT4m+KTqr1Q7u0bR0ogrTcFGklV0ONS8MTFM/jwE7htBhCubDAivlpuc/pzXUyodSHH1E8RwBZH97sgr6Ze9H80OekiSqd/nEMRrdHwJwE9XRGunHiyshzlc1vWeR0QMxZd7o=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2632.namprd10.prod.outlook.com (2603:10b6:a02:b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sun, 11 Apr
 2021 08:29:10 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 08:29:09 +0000
Subject: Re: [RFC 7/7] scsi: iscsi_tcp: set no linger
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210411075545.27866-1-michael.christie@oracle.com>
 <20210411075545.27866-8-michael.christie@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <1df86935-9e1c-3fdf-3443-eecfb441e780@oracle.com>
Date:   Sun, 11 Apr 2021 03:29:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210411075545.27866-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR14CA0059.namprd14.prod.outlook.com
 (2603:10b6:5:18f::36) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR14CA0059.namprd14.prod.outlook.com (2603:10b6:5:18f::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 08:29:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fc7512f-0e38-4833-5036-08d8fcc3e0b4
X-MS-TrafficTypeDiagnostic: BYAPR10MB2632:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2632B441FA44792003F2C11EF1719@BYAPR10MB2632.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:407;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGQjVvCRJyCQxYc7WYMZ+YxnFg1Z6d5Gg3hTYFs32vPSM0exy1ftmoKOdKzwzLQIe2E+1oTpdl0Xx5LH2KtZ5H/x0SKCl32qHu7nLq2TmJBNEkUr8xq1O2bPs+0hxHUOj+9/A3c3A5Cm4PfDuyIVoVPTffP+j2Uvpswbg8+8tUmE5Cryvy+fZniaPSaDWmbldyQGSyEvCtnZX0QBV4kUAO20H/5E/6RnXxlbUiAOGikwDRBPSOIVMjrtUAChTP1PRT3Ffd/Ico8J2j09C2DZwcnsgNECSbR3z/vH60x739dT1WwEh45I+dXNs+G7GOiBe7lNt0NWzLmZ/0NRMPURZ6V7sGQG69dBB/0AZKCF5mr4Ncy4gTLBzDJy7SHL8TMDADtML312TctmlJCVorriNX7eNUxi32WQPRQ4XSDj/WktcU9qFFa2F92pzufty6cwuYET7cMixKZdmP99sO+xoruwCgUoh5ny7sHHC7kzWsgv+eMFngIQkEhvhCgqaZGpqpIf7VGn8gLnxOqPT8PkX6dfZJLFG1RrTggkqMypqovrFgSP5yABNrzooubtV00bCH5FCxKKOGsxBWpJMGLnRD/rHgER7fYXpN77zGgrMfSSMte3rGnQP5H2YFiMOOe7ub0NNSIbhxQtgiE3xX4Acv3OhHZ3J1ERoxM8G0FxTHXSLWtcSMpDA8fzd4xFk6SwAVNbaXOeiW0eth5FObceZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(376002)(136003)(39860400002)(2616005)(31696002)(83380400001)(66556008)(8676002)(36756003)(66476007)(53546011)(6706004)(956004)(16576012)(5660300002)(86362001)(66946007)(31686004)(2906002)(6486002)(8936002)(26005)(38100700002)(16526019)(478600001)(186003)(316002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QjBJMDNFL3p2cjZlTU1DQVAzWjdXUnFPVm1DbnhSVWplWjhxYjJUTnlIMnVY?=
 =?utf-8?B?b3JMdS9FMm1pUUI5YitlTkppNTBnTk5IeFhZak1xeXJMS29rT25MRmlQZXMw?=
 =?utf-8?B?aUN1MW51eTlBWEgvcjk5Wm5DMFRFOEFjNVpGR0d6eVpBQ1dWNG0wdnNWRVB3?=
 =?utf-8?B?UzE3cUg5OXB0eXlxNW91U3IzbG9idnFoWDY0OGFRWUlnOUpUbUNlUm5uL0M1?=
 =?utf-8?B?SU1iQUNoZkJsNmlENXFZalR3c29wVnU4UjVqVXMvUVBPbThlaHpPbjN2WWJ2?=
 =?utf-8?B?OGNnS0RsZ20yQ3ZsTmtrYmEyMVBIRnpHZEFZN0VRRncvTWpSR1F4QkZabDZT?=
 =?utf-8?B?cWtsS08wbHdLKzlwRnNyOC9iYzM3VmZxRzcvOEVNZXYwT0hYWlc0NUlaYkxC?=
 =?utf-8?B?YnRuYVFxS2Z2TyszcEt1ZXVSZzU0ck9XYTJwWVFWekZGRHE0c00vS1g3ek85?=
 =?utf-8?B?NHJjUHdrY2l6OXpUYVl4L2hVV2tLTEVPL0NjZnExS1E0ajFQTC9zQlROWlJw?=
 =?utf-8?B?U2liNXVrcS9DOUtZZVhaMGpEakxqMjFvTjdySGJxcUw2cXV5M1NTemw5b1U2?=
 =?utf-8?B?K1p0MlYvZUU0bFYwdmliUTYzZjkyeHNhTFFzUExaQTRhY2JieFkvMUFWME5l?=
 =?utf-8?B?ZHNwdXM1dXJIN3h0YWNUczQ0YkJkQ0NES085TUt6ZjM0dUNIcTl6Um1vVkRF?=
 =?utf-8?B?NllIWXVuVitmTlI3clNheVhtendzb2JJMi8xM1BWY2RMVlR0RTZkUWgvWG8x?=
 =?utf-8?B?dFZ4KzV6d3N5ZEhhUnQ3MUg4OTZGakF2WG1HeHB2QjBoUDVyYnRpY1NGd2xm?=
 =?utf-8?B?bkFYQ1RtY0pFUGtsWHZFejhtdy9hR3BacG1kWjhoeUNMSGFIUkhlU20zbGY5?=
 =?utf-8?B?RVhzVTRNY2s3VnNKd01DclJUUlY2Wm9FZmV1a2ZRV3dBUzQrUnJKN1laeUwz?=
 =?utf-8?B?TEovVGFvL0l4NW5HQTNEOGlHNGJ2aUIvWXJrNEpkYmw0b0QvR2xIVjBrSU1X?=
 =?utf-8?B?cURzVDc2ZEQrY1dIV0dkNThoaG1MNFhwemdmM1BCMW9Senp5ZEpmZCswU1hw?=
 =?utf-8?B?Y2RINm4rUFc3bUlvd0pWckRlL2wxZnBhV1FKRWxrWEFWUEtmWmx0YmdWRGw4?=
 =?utf-8?B?ck50U0N5S2hMN3R6YnlNL2haS283VmYyaVhSV0ZWM2tScm5pQ3p5dDQyMXRo?=
 =?utf-8?B?VXd3NmVUdEFWNFFMQ0pSR3N3dVVzZ3I5RU0vWWtmTFJVR2RYdWxSa1lNT0or?=
 =?utf-8?B?TzRtUi9RbFhOemNiRUd6RW5XenVTOGtwY3h2UFIxUDJPQkZqdXhuYTVxQzBE?=
 =?utf-8?B?UUZpOVEvT2NJeldPd1dzaDNtMEdFQnBHMWxpNW1SVUJxSG5oVGx4d2hMVUlG?=
 =?utf-8?B?ZzYzUTRLZzFGdFF2RWp3WURaZUk2MXZxRnFIZDBXelJoTDAra3JyK1FtSXBM?=
 =?utf-8?B?VnZuNkozbVZqOU9nWmRFbkFJK0c3VUJZaGFrVmVBL3VMN0l6RjYzZDN2OC9Q?=
 =?utf-8?B?N0lWNCt1cTk2L01pTTY2K2dMRFFkV3A2ZnFOSzArK3NmQng1bUhuTEpzR2tl?=
 =?utf-8?B?elREK1U4VjRPTmZ6bVpRc0lndzU3WHFlZHB6VEliR0YzWXhlVUl0RC9WbG9o?=
 =?utf-8?B?MXFvRytVNUUxQ2I4SHZuVWpxRkFQMlVmaXFKU3NnOGhtNjl2WW5panBqYnZS?=
 =?utf-8?B?a0h2SVFFKzdyNHMzNFRldGFwUWJjcVlDdFZ1ZGtYMVlOZG9OMXp5eHdwRXpt?=
 =?utf-8?Q?pO4bfBdI1ziP9b4MgvTNZER4UC7RQGc2WaYdE/2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc7512f-0e38-4833-5036-08d8fcc3e0b4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 08:29:09.3120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vecLYJ4q5AiCe/1d6fT4xD20VmuJ0y3MXJaLBSDTYww5Xsrd6+4+mHF5Da0yBjjL1A02Fz8hNAG1MPcoX9Le4UQBrGqmnpqDjVbuf/zwFk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2632
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110064
X-Proofpoint-ORIG-GUID: 0DFmBOmwvFe9yN6Uzq4OMdBmTUX0ao0f
X-Proofpoint-GUID: 0DFmBOmwvFe9yN6Uzq4OMdBmTUX0ao0f
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/21 2:55 AM, Mike Christie wrote:
> Userspace (open-iscsi based tools at least) sets no linger on the socket
> to prevent stale data from being sent. However, with the in kernel cleanup
> if userspace is not up the sockfd_put will release the socket without
> having set that sockopt.
> 
> iscsid sets that opt at socket close time, but it seems ok to set this at
> setup time in the kernel for all tools. And, if we are only doing the in
> kernel cleanup initially because iscsid is down that sockopt gets used.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index dd33ce0e3737..553e95ad6197 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -689,6 +689,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
>  	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
>  	sk->sk_allocation = GFP_ATOMIC;
>  	sk_set_memalloc(sk);
> +	sock_no_linger(sk);
>  
>  	iscsi_sw_tcp_conn_set_callbacks(conn);
>  	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
> 

Darn. I forgot on the of the tcp patches. In the final patchset I will have
this one too:
------------------------------------


scsi: iscsi_tcp: start socket shutdown during conn stop

Make sure the conn socket shutdown starts before we start the timer
to fail commands to upper layers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 553e95ad6197..1bc37593c88f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	if (!sock)
 		return;
 
+	/*
+	 * Make sure we start socket shutdown now in case userspace is up
+	 * but delayed in releasing the socket.
+	 */
+	kernel_sock_shutdown(sock, SHUT_RDWR);
+
 	sock_hold(sock->sk);
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
