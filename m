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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1404BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 01:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C55613B5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 01:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhEFBaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 21:30:09 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:21514 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhEFBaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 21:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620264551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YpDdqhlKTp4xue5foRILCZPo+Ev7PcWURh6e0KMAtig=;
        b=F98gMaYDZm3rZNr46Qum5dvT3ZAkl9iCjb67RZu9bdwX6/1wC9y09NI+/Lq21Pi384Cs92
        6N7p8vDZ7QbSssawPWT0lIiO/gtCpsOYwNQ40rFkR55MOYM9aS/pU6Dpwc3MFDl/VK+g2q
        Alb8zA3UPcp5eIc3sp9wQm9LJm8B5k8=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2059.outbound.protection.outlook.com [104.47.4.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-FZakfXK7OxKz3oDu7vdCzw-1; Thu, 06 May 2021 03:29:09 +0200
X-MC-Unique: FZakfXK7OxKz3oDu7vdCzw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbHLf/GaRWn4KZr5GfDg05JUEWkGcyKSngnAe/6X4iW4LrauIxF9VJFwWzKp0daxuoCM5hGbHYnKa+2GcYvQ09GUvdrkp3UW/mmNN5W/UAolQCE79QkAMm5vapkfF7sOeYWPXO5ZCgYCDxMmZ8jy1wo8Kfui4Wlyn/GOMjj30r9OfEGrQbuXrbA1hGu1OmWsY4tdu7uQ4vSgLm0z2/KgS4EmK9MK8Cszzq4nqAkdtgqQjbdmG7S5DTw9oOLMWLZngVB9Ufd7+a5kUzGoMUZXBEfTsoqBWvONpS1M4smG+nim+/8k6i0jFs5k7pFnurZ9U9lH+jpsi3gXF3JRjBGwlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpDdqhlKTp4xue5foRILCZPo+Ev7PcWURh6e0KMAtig=;
 b=RiIVDSWIe5tpfWSgV4wpiitse/4J8UFpMkJVthMouQOojmeH/oM7nNreePruiivvP0ySxf5nzyWVA34Jy5wXl/2pEpw1ecRIkRYRryWICRA0uSHACsMuh/D3Fvw5Y30KUDK/nnkTggsFA7qVxB4gH/kHZ29ctmta9h8s+g8PT5tLjotsFOrda0zWq+2cgfnOs84YZeSzJpfu1iL4D0VdryG1vtNUy12hggZi4lp+s31RFsOoRk0cBPerb5sjAAqOKYxyt7TqGPGOq7rta4AZt6kfAJUbQFikXaqA3bkqOWEPDLRiHbJj4ZX9ok+yjyV76k3bpABPjEgKIfbFLK1huw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5016.eurprd04.prod.outlook.com (2603:10a6:20b:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Thu, 6 May
 2021 01:29:09 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.038; Thu, 6 May 2021
 01:29:09 +0000
Subject: Re: [PATCH v3 5/6] scsi: iscsi_tcp: set no linger
To:     Mike Christie <michael.christie@oracle.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <f29144be-cebd-475f-ced5-a3882b44f404@suse.com>
Date:   Wed, 5 May 2021 18:29:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210424221755.124438-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR06CA0131.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::36) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR06CA0131.eurprd06.prod.outlook.com (2603:10a6:208:ab::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 01:29:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6edacbbc-e3b9-40c5-7034-08d9102e5885
X-MS-TrafficTypeDiagnostic: AM6PR04MB5016:
X-Microsoft-Antispam-PRVS: <AM6PR04MB50165D7E5627924CE4FD4269DA589@AM6PR04MB5016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZA6pSPcDGTDP5jWeZKmfFE76LAXKagXeGz0JgnQawypSywBoqjxIK2cJjFCG7sxNyhNXG2R75elwPeaCz2ZlI/ARHsJ1vCCjwxxVlu5nQwzjSnDzPHJhYMHEuuIQU/pvxa9JtKi+3Ti7zsLcEZcE2HX0PWPF7lYYqMEGDEEQ7uGVZABexc/KXx69JK4VsurpGfdtYh/Hbu8TauF8OWc1VgVhHN2605m87vr1HRjzL/fzS0I4oyhnW97QnDj70ly1msI0VjsaIkuwlMEHtmhKpc4ldbPgXBxU6lxvvOj8UT9T/0P/UxEYEEOn/+bEaMq69J5i2QSD/ebKKZzgm8hCfZyRdbsk3bVBJDzHB5nsaIduKv9joFFd23dVVyw1dQ0fG8bhol5uoh28wSKprQYLUlAsL4cCQ5w8YQvX3im1U024frD1iwlnghdsiJQ8uwaQC8mDn/cZJF4OAPbRNyCIyQtgD162n1EdD4Im54VCGCKnBuvM7Ex796DstDwDc0HPCkpBY3+jgmk4KWrcXHxCTPU1QhmdPwkUt86BUTgrMJtHtBDJ1CAVatYPyRSO5iGwCcis+Qao3kTowiX4yOZheGryYy2uCoKdGRIGiJuKQb9xM3eulZZMHR8KKyduLWSb5Kdw/gDbz5nYxW4+xqwqKqwv4oLhvVlplvOCjbbmv0v09xdgKur7lELHq7Ha65iZMte/Fi5hVCLD4r2ZG2Gtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39850400004)(366004)(396003)(346002)(478600001)(83380400001)(2616005)(186003)(26005)(8936002)(6666004)(8676002)(16526019)(52116002)(86362001)(66556008)(316002)(956004)(31696002)(6486002)(38100700002)(5660300002)(66946007)(38350700002)(53546011)(31686004)(16576012)(66476007)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QVFIQUd4TFVVaytYcHhDN29SSFh1WkdIVERMNERPVEczRnhWYWV3ZmZROXNv?=
 =?utf-8?B?T3dOUmxMem9CSUNNVmdjemxwTnExQ1VjRjRFaE9HdHdKamtiNTNPYndEOEpi?=
 =?utf-8?B?MGVabUI4RVRKekVTd3luRjd6U3c0LzdHaC9BZnp5NHBFRTd1UVN1YUhZWWlC?=
 =?utf-8?B?SmFSajdrMVYwR3l4MVJLVEdXR3lWdGFKZStkaVlDbngwODdRY2NFKzFuRXpQ?=
 =?utf-8?B?SENlRFBpWmNlUVRueWRrOU1SSDNxTXZqRlFIdUdsZ2QzanNydk9pRXd1b2Y1?=
 =?utf-8?B?M3lPMWJ0b3JKajQwZVZSZzdIQmZOZDcvRmNEc1QzRjR2NzY0UVpKTVR0em5Z?=
 =?utf-8?B?YVVrYjV2b1FrN25sTlJkL2tWUXNRMkFzWjA2VzNjdlQySCtSSlhiVGZhVndW?=
 =?utf-8?B?NVpPYlJaVDhVblFuUDZqLytGUnNuRFZaNi9ZZlYvUCtRV3dvMHlnWWRwUEE4?=
 =?utf-8?B?blM5TUxGU3lZMnl4M0Z2Qk9yRzVNcWNwaExaaHhSOVpSaWRzRDJFVURnUWdr?=
 =?utf-8?B?QW5xQkcvWFd5RDdHOU4xaVJxZisyV0M1UnNyR0dMemY0NmdZU1EwSy9tR2Jk?=
 =?utf-8?B?U0wxTFFJVEFjRlkxemhFZWRlZHFmUjdCWEpZYSs4cGFaMytnMjVHNWFrRlZn?=
 =?utf-8?B?RFdLUWNpVzdmZEkrSTJ0QndpYzdBVFVVd3JXamtia1ZUdElFMlJQK3hQOXBU?=
 =?utf-8?B?RjhoVGthNFFKNHVVLzk1K2psY0tCSyt0VE1lN05SNDFRKzczdU52T2FJTWIx?=
 =?utf-8?B?SkpieitaelRHSWdZem9aSnJScWU1dGJqZmNsbm1XaFQ4eHl5SXQ2cnNHZnI0?=
 =?utf-8?B?SjRmRkNva3FXRHk5SUtySkZnYmMxN2h3TFBQMmNibUNCL1VoTUtnYmwvWmdk?=
 =?utf-8?B?NjV6cDZubGpqamF6RElyWXZpeTlGTlg3YVMvV215eGV2K1kzZHZPRjltcEU2?=
 =?utf-8?B?MmtSdUEzUjRqaG93QkZ3T1h4M01XdHBHbGUwUzA0dWJWaGk2NUFEajhOOVo4?=
 =?utf-8?B?QTJVc1BqQzRQSk5MK0g4ZzQwVnB5VVdSVE9Cc0plWWtzYUxycDNZWEV3MlNH?=
 =?utf-8?B?bkY5elI5SDIvRU11RExZV1NxdEkzU2FmZ3hSNmY3UVlmNXArU2pKQnVMOXJk?=
 =?utf-8?B?cFlqVGQybnd3aWQxVnhINXVPYmpjL2Z6dGcwOTJidENQNkxBcjBlaGRxTmlW?=
 =?utf-8?B?eWl1Mk9JSUF0SElaTGorS2dCcG43OHpwQWhlU1hxQkJnaG5jWGxLRXdTTlMz?=
 =?utf-8?B?UTJRTDhGd1FubDIydm9VRFZMNnZ6R3VaL1VwUE5nNEU3UHBJOWVUUXdPYnl5?=
 =?utf-8?B?NjR1dUhaSEdpUWJ3ZnN4MnpBYU45RUg3dWMzOS9FbVNSR2tTcGJnS1N4SnFY?=
 =?utf-8?B?MDU3MFdjZllzQmQ5TkVmRGlJTktDZUR0Y2RWOGxVcVlZTTJZZk1PRlFiVWJC?=
 =?utf-8?B?eFU2eVBRSWJSMFZoZXpFR3dUS2Y1NzR5Sm1McEw5ZGZBSURqZFI2YWpWa3N5?=
 =?utf-8?B?dFVjbkVhMWtCRmVyd09LcE1iMUNLclpKUUZmb1NWTlJWbDdDUEQ2Mjd0V012?=
 =?utf-8?B?bnY0YkVldnlrOE5kOGNzQkxKQjRua081ZTJKWm1CMXcwM3MwaFVqdXEvTkhm?=
 =?utf-8?B?ZUNmcVdXOWVvQkdMSjJGNGdnYUFaU3lHQVhBMVBvRW51KzloM0x3eS9EQ2Jz?=
 =?utf-8?B?cStQd2lXVmw4N2pXMnJaRUthb215M1hXT2VIOEo5RkVTVko4c1BKMVppaWQr?=
 =?utf-8?Q?KWlBY+Uxa1FjX6K/a27sS1yuwFjwD0WpSl4auhI?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edacbbc-e3b9-40c5-7034-08d9102e5885
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 01:29:09.0765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNXHvUeZBGNdsVOm/wWaNRM7MtOFv3kVArqPgBccveeDstctlUwqpVsjYojJZbnDbch1mqp07/jCPjNFcfyLPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:17 PM, Mike Christie wrote:
> Userspace (open-iscsi based tools at least) sets no linger on the socket
> to prevent stale data from being sent. However, with the in kernel cleanup
> if userspace is not up the sockfd_put will release the socket without
> having set that sockopt.
> 
> iscsid sets that opt at socket close time, but it seems ok to set this at
> setup time in the kernel for all tools. And, if we are only doing the in
> kernel cleanup initially because iscsid is down that sockopt gets used.
> 
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

Reviewed-by: Lee Duncan <lduncan@suse.com>

