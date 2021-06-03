Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7051AC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 23:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5951F6140B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 23:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFCX3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 19:29:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCX3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 19:29:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153NDvvk106197;
        Thu, 3 Jun 2021 23:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gX6+Lke57Qmm7EXTNMfXa8xpMXCHc1P4TqdwSQNN1n4=;
 b=f4pAmclmTmbcJjmdwXIT4dPqHAO6km/gOk+AfuWvB/n0saEGLgARcQvg7PU4PKgfrBgp
 mQqGXbWI+Gl6g4O1GhVBm73Eb9jvMiu5yn1W1ybuEehMJBvf72uNFxNMJE6pZ0ACFaog
 CJQDOVmcU5C4/qi9heuA9UxxjipqWXBfHCmAJxcpycZmYw61QDROyaVIDehCB+R/FmtY
 D2VPEC7Lggc9erqHp0qZGO1DQ8ob/YUT5qHVjtX5oaWA7KclCZsY/TdnTYWysXeRt3mv
 z6dP0DjzStkdmgoCDi/iSZ+JAOtvWNgliG2fKaPHX94TpaO9Fg8jC0ymdiq9irv7ucFs hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38ud1smm01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 23:27:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153NAjQL098222;
        Thu, 3 Jun 2021 23:27:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 38x1beaypm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 23:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9Z31VlUHwe8LQCWq4ZwdbK4kD8RluAdkvgr/+wc5q1jnIBMy5qt1TlWxzNpoCzbmQvrEzmcpn6itG0zYqsnzmiI4X/uXIgnoTS8KTs1BC5M6CUPfLIEIK6GqpSyvjQPQbBLm5reDDoWP27tK7+XQn2NHaDOEn01dESdTrQvIJp5bAQ0ORBBUHZhf6U3L7itYruPvdaHQJ41U8fEd4BXXPcJddaULWEX0t8NH4k2WZOuq/RyFRNiPSFVwmleS+HCJPhVTAnsLv5efMKWVZSA0KACT+jwZwBxUXb/uSNMzROGvlQ+zsSrdzvXZ1w7/C9daux/WqyiTOhe42jzVHvcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX6+Lke57Qmm7EXTNMfXa8xpMXCHc1P4TqdwSQNN1n4=;
 b=Dbn71cRw+DmHcWNyrKRS+aMhudSjKmKkZFGf9sSgHDIt5lb+1Xf67OYJtQml1uCX6Ap2TIbp7V+HSXshCBz6o3P/q4mIsheh6ptX78nCGQ0eXDJWx9Lrc0NYxo0rbE2j/+I8pQvOyGcG8ysm7ujsAqzrZpvYNvAOXDDRJ9vIURpGWwkDxomXcya0kqNJQEYVr6b3LN0FrZ6nDOzsiJeIA/tn+0hSicx3UM4Kb1xBP2wITnuPKawDnFQwIPjIY62+m0MA1ws+ZqV/QwrhJ/bUj+bK18OaGDNeFbsqwFTYuHDekIND1IFKj8ZKB610NBUkqLFQWr8pirzWYHwVi+iDuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX6+Lke57Qmm7EXTNMfXa8xpMXCHc1P4TqdwSQNN1n4=;
 b=uasvt8XVzccOQLNAiYxfBwpSQy+skBLK3JLdM9siYQmxUytFWstUqsEZK8A29HdWiLfRjfgfPz3B05YFLG8eVH3xphasH+tKQEamn71qKsCa18eGhFW/fIG8WK98/iRPM6LZeYBJfEGFmm2fulsmLt0GcEBSz5sAiFgmDyVp3tc=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2837.namprd10.prod.outlook.com (2603:10b6:a03:81::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 3 Jun
 2021 23:27:40 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 23:27:40 +0000
Subject: Re: scsi: iscsi: Drop suspend calls from ep_disconnect
From:   Mike Christie <michael.christie@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
References: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
 <08f664af-30be-aa4b-aa82-2333650dee06@oracle.com>
Message-ID: <f2679a9b-7ccf-b4b8-c028-1c164d532fee@oracle.com>
Date:   Thu, 3 Jun 2021 18:27:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <08f664af-30be-aa4b-aa82-2333650dee06@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0130.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::32) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR02CA0130.namprd02.prod.outlook.com (2603:10b6:5:1b4::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Thu, 3 Jun 2021 23:27:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9718300-c695-45ec-e614-08d926e72e31
X-MS-TrafficTypeDiagnostic: BYAPR10MB2837:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2837B5E9363DECAF5F23174AF13C9@BYAPR10MB2837.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+mpSypctxhV8dFQEcOM6zh+4epkj0HLsYCxYpKT7QjV2azvKdPwMEOgqSb1V7oIMXJYHqKIKetOWU8cbwQ2MBmktwKQdL2yc7UqaeNvfYzPIKTNBCcnZ0b81KrRRV+OVmAZjQyEOVNnygBQ4o6nuXzZS9byZMjZknU+MdcCj3q+fRy4jJiL+B2gppU99u/GaSW0jTqwgE821npS9ExPgZXjgR246ej/TPyeqi96YadII5Z9jZ4N/RskNNSH+eigvduiNQ/wjWJ8J6jpSbgRgDVIlqn4jMSjRtPVc8xNDsTVvjpf4hMhavGkjqG5XpWyxoJTCeNA4d1jT9nYpqNO6sjIl0ux5iSp98hCIzjCMVXWOCS/ir0xt7/O5toMYdpQ92QecroA0+HECrmdQe7u4ZWD7MG+hy32IhbH+Pri1/DLhAeii87qw+ca4l3FqL2dfJWGsj3E3+Gjdpd9LpbX649gpska0RI65s1MnJLz8ofNaAhxa0RA/2QzbTBv3FjPFrYhHcH3Ew+DtLRLXmjjzvqR12QS3wwKrseJVQl+dYCBCbbHMy+QxArOExysrP9Ml5QED9y0G10oxD2SIsiKDKdGh0fBEsqwHyTW9mzvKBVm/fZ4zHAkT4oO8oWW8BmEzFQBYXuMMqQxRqwjvgMjbtlN+aWEslbQbWHrYSJuIx7CumfzegTNWyZvP0I2zk3Brt2MTBUvxNlvDwPGinydfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39860400002)(83380400001)(16526019)(8676002)(186003)(26005)(31686004)(31696002)(2906002)(6916009)(36756003)(6706004)(15650500001)(86362001)(53546011)(5660300002)(6486002)(4326008)(478600001)(956004)(2616005)(8936002)(316002)(66476007)(66556008)(38100700002)(66946007)(16576012)(54906003)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TzlKaTFpcVROZ0FjaXF6Q1BMYU1Na3ZZOTkxY1JqdnNwZFVNOHBYWnN2V2c5?=
 =?utf-8?B?VmZVRUsrb1BReFRuNHo0Q0FCemU2MVYwb0JZbnBkUWdVUk5PTmtWcytSMlpB?=
 =?utf-8?B?dlFPRnNWWUhpV0JWRmlEd3BpQ0JZTktnVG1FM0tkOUVXck91czcycWJLeXNw?=
 =?utf-8?B?aXliZEhKRm5ScjFVZ0hGOXY4WmFuZGhOZ2VuT1JQU3JrVGZad3VKMFVDWk1q?=
 =?utf-8?B?VVpWSUpFRGM3SE4xYmZwck5EUEFiT2x0VVp5Zy9LK0J1Qytzek80cHNKdDZo?=
 =?utf-8?B?OEVyNWpoUnNCTnlBc1BheDVtaXVVQmVCcWpaQkcrY2tDbHg1c2ZSRXlWeE5y?=
 =?utf-8?B?ZjV3UmtlcHRLWEF6KzVyWXgwd2krYi9UR0RzUWp5cDMyRnNBQi9nazdvd1o5?=
 =?utf-8?B?bWJsVTB2TERrUzlNSFByN2txMWRLd2xySnQwTW5tUVhFTDRQTFROcnBUR3Z6?=
 =?utf-8?B?TWI3Y3FLblp5clpDQ0NuVHBPcmpTZlNrN3p2bEdrVVRQK1B1NWdFc1R6bDRv?=
 =?utf-8?B?RlBtRmc4Unhwck9GdTFjczlNdUhpTExKL3cxcFE3eHpPcmp5SUY1YjFFamxj?=
 =?utf-8?B?eU9PYmwzems2Q2Z0QzRMaU82bzZxUy92Nk5lV2tWa0MrNHN1QVc2dXlBdzNW?=
 =?utf-8?B?QUF5aWJGOE1sWHprcW9KRDRDb0VoaGJ2UC9tN0VxRnc3THAyZ29DV1hHNUs3?=
 =?utf-8?B?VklPelNhMm9FOU1CTFdQdmpkeDNUNjdYV0NaMk9sWFJGdWdHSUZwMFJCWTdx?=
 =?utf-8?B?dXh4Qk5wSVZlMytlYkZ5bTN3M2Vxbzg0L21MQVZXbENjeklDR2Fod3hSWEIx?=
 =?utf-8?B?blVFU21tdEEwWU5FQ1FCeDN3U3hUdTVLaE5LZWNoazhHTXBKTXFBbTFJZUFa?=
 =?utf-8?B?Y0xES2R2anVqZEFXSm9hb2tudzgzOHJSMWN3Y0YzVmlwREprRW1RLzd5SVVT?=
 =?utf-8?B?cklWc2FYLytTUDJkdGppU2RyYjNGc25CYUFaYlJxSmVxemVsU01zM1IwOVRL?=
 =?utf-8?B?YStER21veUluaUJoUDBDa1d1WmZrQ1U1cGk3T0Rlb1lwZmFremMvbzlOVmQ2?=
 =?utf-8?B?U1A2TlJ1dTJ5RlY0UURsZ2xvREhxVTBzckx0UTNjK2Z0eE8yOWhseDdDcVZM?=
 =?utf-8?B?dWFyM1dyTXBPRjFhZUgyRCtWdS9UQ2lsZzBrenRGSmE0NlRBdmFhYUtBSm5J?=
 =?utf-8?B?VVRENWk2enFwVldRcjdhVmJId0dBclBOTTdpdnB0LytQQzBQV0p4dnMvRWIw?=
 =?utf-8?B?TEZsM1NSZkgxWUdiUllmQUs3MnVCcHpwczUzdHZnK3lRWWhIVS81cFBCbTVn?=
 =?utf-8?B?QVp6K25sUnpCTTdCSkNDZHJiNmxLRm5BbmhTMzlVSkxJZmZITmV2YStqVFRh?=
 =?utf-8?B?eEVTejdyMVozbnlLUU5FdGdDcktTbktLZVFFS3lsLzZMclNINHdBbU04U0J5?=
 =?utf-8?B?MVFDQkExd1NLdCtZWGVRQmc0NWNGOE9veWVJMGNqeS9qbEZLL3FFejBDVzYr?=
 =?utf-8?B?cWdXek43ZmJ0SlpVWGRsNUFMaUY0UU84QXNZSlRlN0lSSjdsM0NwUG1za29U?=
 =?utf-8?B?QzNYdlJyNWhNRUtpbkh4Snp5NUhyWDNYU29wTzZzbEtJc1RQWDYzdHhwYlgy?=
 =?utf-8?B?OXFBcUF5VEtOem1XeVorVnlESGpmZ04wQ3NlTXVZV2swaENxbHlJOFNaT0NJ?=
 =?utf-8?B?SVB1aU5IZ2t6bGs1NXdtbkVQQXlNL0ROWVBiVHdNZ1ZuSTJlMXQxemd6STBH?=
 =?utf-8?Q?ST7cOBOR9bLu8XY1mPYZiEOAE8m1W7yx9xyQpG5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9718300-c695-45ec-e614-08d926e72e31
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 23:27:40.5487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v3rFUTwCNiIDdZcgiDdBmjwadBNtBAKhz1vjpksy4PcxqpGpKCxyXPanVkjTdCScqZmAAyCNzleOiP5xP1MUXCB4U57JObgV0TIjcpAuxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2837
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030153
X-Proofpoint-ORIG-GUID: ZBszS-FtW-ZzgjOChR8bjU0t_QkekR29
X-Proofpoint-GUID: ZBszS-FtW-ZzgjOChR8bjU0t_QkekR29
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 6:25 PM, Mike Christie wrote:
> On 6/3/21 5:25 PM, Colin Ian King wrote:
>> Hi,
>>
>> Static analysis on linux-next with Coverity has found an issue in
>> drivers/scsi/qedi/qedi_iscsi.c with the following commit:
>>
>> commit 27e986289e739d08c1a4861cc3d3ec9b3a60845e
>> Author: Mike Christie <michael.christie@oracle.com>
>> Date:   Tue May 25 13:17:56 2021 -0500
>>
>>     scsi: iscsi: Drop suspend calls from ep_disconnect
>>
>> The analysis is as follows:
>>
>> 1662 void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
>> 1663 {
>> 1664        struct iscsi_session *session = cls_sess->dd_data;
>> 1665        struct iscsi_conn *conn = session->leadconn;
>>
>>     deref_ptr: Directly dereferencing pointer conn.
>>
>> 1666        struct qedi_conn *qedi_conn = conn->dd_data;
>> 1667
>> 1668        if (iscsi_is_session_online(cls_sess)) {
>>    Dereference before null check (REVERSE_INULL)
>>    check_after_deref: Null-checking conn suggests that it may be null,
>> but it has already been dereferenced on all paths leading to the check.
>>
>> 1669                if (conn)
>> 1670                        iscsi_suspend_queue(conn);
>> 1671                qedi_ep_disconnect(qedi_conn->iscsi_ep);
>> 1672        }
>>
>> Pointer conn is being checked to see if it is null, but earlier it has
>> been dereferenced on the assignment of qedi_conn.  So either conn will
>> be null at some point and a null ptr dereference occurs when qedi_conn
>> is assigned, or conn can never be null and the conn null check is
>> redundant and can be removed.
> 
> The analysis is correct.
> 
> The bigger problem is that this entire function seems racey with the
> normal conn/ep disconnect or shutdown.
> 
> Manish, when this function is run iscsid or the in-kernel conn error
> cleanup handler can be running right? There is nothing preventing
> those from running at the same time?
> 
> I think you want to call iscsi_host_remove at the beginning of __qedi_remove.
> That will tell userpsace that the host is being removed and libiscsi will

I meant iscsid not libiscsi.

> start the session shutdown and removal process. It then waits for the
> sessions to be removed. We can then proceed with the other host removal
> cleanup, and at the end of __qedi_remove you do the iscsi_host_free
> call.
> 

