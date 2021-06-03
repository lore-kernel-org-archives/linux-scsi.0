Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F227AC47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 23:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3066140B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 23:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhFCX1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 19:27:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44382 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFCX1e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 19:27:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153NE7u0057578;
        Thu, 3 Jun 2021 23:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dZixXP1hSrg0lyanaOTvgu58nZ7S95ap1hktW/0wr/U=;
 b=CSQo7ccRj+6uF2DMQyvCnhu3dYU3P7IUIy+IxcWHhoAROz6lluoAo+CyKAjO6nRGRLlg
 JgK+HVtT8En2nefSgOIpJNdiyK/yR8hE7lUVvR5V6g0h4fjMrkBStL+wNy4Vt3sOjd85
 tvPHsPshuIAO6BZvII4D2KN9bMsrL22ZpIwa6pUSgCf39d1aL/d9XKwEJGTC0RloOtSC
 tu5Apl5oU2sYS96KSAEBldGlw7K/fDw6KfHLcrTLe4N6DDz6HlEMhNaTKVGVfYD20K30
 HADm2GxMqd1za7WXe3TdTcPBMoD4bgM9WYRf78gpYd9LTerKeQEMjoqdOWf06WJP6SY5 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ue8pmky6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 23:25:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153NAkZY098347;
        Thu, 3 Jun 2021 23:25:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 38x1beaxwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 23:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5H+ZnnbDM387KJwa9n2Tegh9NJkIVB5HKj8VSzlG2LYAAk+yYhq/nj9uDT9h6F9uL3qMfLrj51yQNqk9h+s/Hl2btRaJoWa3oasBHQgmeVWidvAX+yKjfibqCWUiDL3lRUxhCbrKfYd9rClRmhpHPtTgOzg3aN9gPJtKVUMks31ZNEoHjlXOoPBoTW8mGDanj0f78OA5RCZ/bJSdFhMr8FScRA210r0+aJOAEPkzg4A3ucFq32mAnyND5C3RkB2PB8CWnDwG9o8f1f/U4DJEiMPnfTBJ6RY+zuZoO18UAwvZXeFQJErivbtcmbw/YsTn1uOsTHPvm22vFfEJkcvzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZixXP1hSrg0lyanaOTvgu58nZ7S95ap1hktW/0wr/U=;
 b=KnNleT148O8LoPK5eSuslkMMH0J4D/7ZHZAFVRlEuRngRAt6hPG6vA82/74lAw9lbKoZtFtl1aWqZRrj8tvyAR7aIYcx4UvRCGatmSS7BHntPUF/VdLmlHtSgX/bkFHWdC6qk0JGs7g1FbRs/P3B5+oKEEN/Dx6QW5ZAvTONDuwXS1lKMmD177RybMwKLyUOtna2kaWbsUfvKrHBClJ2cYxjx6+EnbwfRDinIRn3O3E6UyE9sjKeKYJHQz86jtacn8H7xvhJbr4l+c4tasTxByF116abpFtZgV38xdtjrcrLJlZ5Uz5WfjViz9Khj81A79JIy0e6emYSdc2++cFyig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZixXP1hSrg0lyanaOTvgu58nZ7S95ap1hktW/0wr/U=;
 b=ol+Il5rzfSk3JU3bWL9S1kFmouLaaX5YIzfp5KTbNMNUkhQ2O6UsCO87Zp2Kzv+WGUfH6HLb6I99fmSZXcEFpRu1BOo8Tbx/UhhCbkDIUHggTxMO7iPvykZUxAXSs3gC4J4r6bR9Wtcakt334uUV17IQEM9308Wfxzhb6c2Gno4=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3704.namprd10.prod.outlook.com (2603:10b6:a03:123::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 23:25:39 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 23:25:39 +0000
Subject: Re: scsi: iscsi: Drop suspend calls from ep_disconnect
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>
References: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <08f664af-30be-aa4b-aa82-2333650dee06@oracle.com>
Date:   Thu, 3 Jun 2021 18:25:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0133.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR02CA0133.namprd02.prod.outlook.com (2603:10b6:5:1b4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Thu, 3 Jun 2021 23:25:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04f82630-6788-45cd-c14e-08d926e6e5c0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB370428AFFED2DD82541008A9F13C9@BYAPR10MB3704.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bTuksm9BvpsMKNKCTkQ0mW67mnBrCmS7satdC5alJQ3T2BtgZgOjVjE9z3+FMj70OyjC4ngj/EZ1Qlcg9a2kzLh63EHY8Os923Gdz/8j8ZiNau59RnkcZiU1JyGUjipluA29sxhMAz7/ogbCNd0wfFZc/gwZIa41BWWHjYrVog+cy6/QHv2YK8j6BYq+v000QrH1+8VP1PzpgXJhgX3dEFPiG921AsGp4e8TjWR01Jb7UcDXrO8xASjNlDmZqwUALnySTW1BmwpC5bIt7pnwKIYouY17L2F4uvbtWZCUs4D3qjQgnQRmo+okFW12N//nFyveJZBPRzlTaLBjObRCWhcRFvtSqcsaHFMc3R1X3xHNpT5Grb9LnrMBwZ1JfvA0YvvPXaDpIdIDIQCy3Jg4hpO2em/z37sHAxtTvLi4VfEXimsPb6uCXxJbztMdydx8bvI35HQt+UNw8mLfdG1M8lXrzlRrTlxu3sm+j8xB2Sh/QjLAQaC2x+tX76tsERay5Rh9idPOFAvrBdce1GFS8V+e9ulTS+EryQarX6wPvjXuT4i7RYvMaA+w1hOsRlDk1W9g96gHAuqoNIgivwvkbA1i07A1kIWpNN9p3JmKpGoLKd9V9EFxJX6M+5fGJtAAosyFNjZKi4emqo6oMAEDwN9ATCov1wQQRS32v1OJNJMjaK4pD5nb3GUJTBKHW+O2YBx/7KlO/dIOdAri651l7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8936002)(36756003)(2616005)(8676002)(956004)(4326008)(16576012)(316002)(26005)(66556008)(66476007)(2906002)(186003)(6486002)(66946007)(16526019)(6916009)(5660300002)(38100700002)(6706004)(53546011)(31686004)(83380400001)(54906003)(15650500001)(478600001)(86362001)(31696002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MFdLc2djY1hZQy9mT09sWlprdm1TdVZxOU9OOUgzNFduTDFZNm9hY3BCajg1?=
 =?utf-8?B?UmpaaExYZmMrUXNURFppZWRXblgvUDEzRnliMnVOc2htcXBZNHpGTmxTMUIv?=
 =?utf-8?B?WUh6ajFQWjN3b096RHZZSmVNVVNPSXRzSTBCSUNzc3RlZEo1dGNwaHV3U0dV?=
 =?utf-8?B?anBiSmhrcWRJazFJdGxpOFNMV3pENVdPZlVNSGRrazR5b3QvNzhrSEpHUzRn?=
 =?utf-8?B?TzNBZ0ZMbzRSZW1NNkluMTlHakdkSlpUZ3dmRnRDSFNoalNuTzZaTm8vYXdQ?=
 =?utf-8?B?QmgxQ0NZa0R2enZ2NW4wWS9zbnFZeFFsdEwreDR5OTJZRGt6eml4cCt6Ky9t?=
 =?utf-8?B?eXlVYUp6V1F6dmVoR29ZR1VUUzFsYndqZmZXWVNxVkloWDhTRE9JQmlsZ2FV?=
 =?utf-8?B?clVFaVBSb0gzUHdKOEJWVWZpM2xkeFZjT2VRSmtqSlpMNEFHQzRpazVXeGJa?=
 =?utf-8?B?dWNhM3gzbG8wNEVjekJMYVFRYWoxbStHL0pBa3JXRmx6TG4vSW9Ec0YvUVc0?=
 =?utf-8?B?SGpqclExdUpLZ2FKWGYwU2JxS0xSSzlRTGZlZXdPTXQvQ3B6dXpPSkpTK2g1?=
 =?utf-8?B?UTgybE4rQzdRZVhxcDc5NXV0S3lmNExqeVFQVTYwT2tMemNRaC9OTWVwTGdu?=
 =?utf-8?B?MTBITkZ3SmE0bzZIQU9mNUd6cWJzdnlZQmI1VnM5clJqY0ZEOTZtQmVDb2w3?=
 =?utf-8?B?WjBjMk1uTElrMThLNUNSYkMybGE1Qkg5OElrbWR5aGJmYXVvekZJZTVHOUJh?=
 =?utf-8?B?b2Y4SlVSQS9sSmFTUTQrQ0VpeG1WNjhHNU4zUVQvYlpyOFpicHFvVUVSRGRW?=
 =?utf-8?B?T0Z5bGhiMFZuUlZ3WnpJMmRuU0dqM1BQYnRKeWlNME1hTE5hZTlITW96OEs0?=
 =?utf-8?B?MlBxeWdmalhlcDUybm5tbGQrc2RUd1Q1cHlVU2U3NVVKNmhibjBwOHlZdzhI?=
 =?utf-8?B?ZUllM0EvMHg4enVlbE5JVVVMSWV2Mk5OUjVmaTNlOUc1UjFoRUF1dkgvRGll?=
 =?utf-8?B?bkVRMENPM1NoaXZqRUs1V3VsTWRtZzZaVFpvdys2c0pLZVNqdGpXbHlmZExz?=
 =?utf-8?B?TTBtdFNKTnhaVVFZRWVDM2Y5TCsxdXFLcVA1Q1VacloxMVBTUzM3MzhlSVBu?=
 =?utf-8?B?djZOdElVbVBENHdjazJKeFd3RFFQQXJDM25lU3ZjRjV2amxoenVFbFNvRW8x?=
 =?utf-8?B?cHE3QmJ5R0VLU2Z1bWpQRldHbHBvME9kbjJjZnV4MFdyZUVtbDJ1YmJYeFcv?=
 =?utf-8?B?ZFdteFJBRFR1N213dU5wZmFrcnZJRG11d2psdlNwMjFBUU00VVJDMXcvajlM?=
 =?utf-8?B?MWFyQUdKc0pNUTN2RFphenFva3Z2Z2paQ0xkMzY2UFlZN0hxcjloS1ZRcnVP?=
 =?utf-8?B?alBCeWhHbXhPL2hxajBuS0orNjZPZWRhTGNGZFNDbjlPT1hVOEovZWNZZEF2?=
 =?utf-8?B?L0cxYUFuTW44Wk9UcEVzMEJSSGprSG1oSkY4blFNZlNTODlyZ0Zlclp1SEN6?=
 =?utf-8?B?UmlPZ1kxdDNnVEIzbHUzdHM5TDQzSGJzdmpyNHBmTmlIdFJDV2ZvMzc1U3R1?=
 =?utf-8?B?VjNxRDNLL2JIUUJmYkwzRjVuR3hUNW5obGMvbWhEWXJWcDF1ZldNWDlhUmF6?=
 =?utf-8?B?MGs1WWZSb24zM2YyVGRveXZUUGpnQmtoMUtRVGlob0N4dlIwWEp2cUhIM3lw?=
 =?utf-8?B?cnRDVFdWemNTTG4wby8zOG5WMUlWK0JIa2FmenhyZnlwNzhiTUpKYkN5WWts?=
 =?utf-8?Q?P7yzA+My5LG0+azm+M4MOaLt+CNorDRVi2VdkG0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f82630-6788-45cd-c14e-08d926e6e5c0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 23:25:39.0023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fiO6urlX6nR2RigFXdEDceORfXdupJxtZHUwNBpGaSYLNJ2m00+XIcBg4p7aQMGz2NVZ34TYVbV1rD9a1y+7v8EdzGc7WrCdUtOKdnpSZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3704
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030153
X-Proofpoint-GUID: hsd0qPjzXVTnN1rNZjH8ahxWE2pfSpYR
X-Proofpoint-ORIG-GUID: hsd0qPjzXVTnN1rNZjH8ahxWE2pfSpYR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 5:25 PM, Colin Ian King wrote:
> Hi,
> 
> Static analysis on linux-next with Coverity has found an issue in
> drivers/scsi/qedi/qedi_iscsi.c with the following commit:
> 
> commit 27e986289e739d08c1a4861cc3d3ec9b3a60845e
> Author: Mike Christie <michael.christie@oracle.com>
> Date:   Tue May 25 13:17:56 2021 -0500
> 
>     scsi: iscsi: Drop suspend calls from ep_disconnect
> 
> The analysis is as follows:
> 
> 1662 void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
> 1663 {
> 1664        struct iscsi_session *session = cls_sess->dd_data;
> 1665        struct iscsi_conn *conn = session->leadconn;
> 
>     deref_ptr: Directly dereferencing pointer conn.
> 
> 1666        struct qedi_conn *qedi_conn = conn->dd_data;
> 1667
> 1668        if (iscsi_is_session_online(cls_sess)) {
>    Dereference before null check (REVERSE_INULL)
>    check_after_deref: Null-checking conn suggests that it may be null,
> but it has already been dereferenced on all paths leading to the check.
> 
> 1669                if (conn)
> 1670                        iscsi_suspend_queue(conn);
> 1671                qedi_ep_disconnect(qedi_conn->iscsi_ep);
> 1672        }
> 
> Pointer conn is being checked to see if it is null, but earlier it has
> been dereferenced on the assignment of qedi_conn.  So either conn will
> be null at some point and a null ptr dereference occurs when qedi_conn
> is assigned, or conn can never be null and the conn null check is
> redundant and can be removed.

The analysis is correct.

The bigger problem is that this entire function seems racey with the
normal conn/ep disconnect or shutdown.

Manish, when this function is run iscsid or the in-kernel conn error
cleanup handler can be running right? There is nothing preventing
those from running at the same time?

I think you want to call iscsi_host_remove at the beginning of __qedi_remove.
That will tell userpsace that the host is being removed and libiscsi will
start the session shutdown and removal process. It then waits for the
sessions to be removed. We can then proceed with the other host removal
cleanup, and at the end of __qedi_remove you do the iscsi_host_free
call.

