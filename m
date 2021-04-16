Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C73C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82FF3611AF
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 21:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhDPV44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:56:56 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:30055 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231510AbhDPV4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 17:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618610187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZQlR6ClXxOb0XDC4pzrR1AXccnIVeBF8pnzMZjR3cw=;
        b=cOIUThjEP/YNlOGijhxmvWyC7jmZ63D18HINkff1UdYLiJvmqdKSiBW1yQ3L9iPvgWdO/i
        u/BPXxMmKcwEwVwLoiMSitoIW4oIjNmG4wlUE2DQXzLh5HiKBW9515fYdq4YbDkacPnM65
        tgxWAtswK0a1etZW5KZe+mvxf0e/zos=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2057.outbound.protection.outlook.com [104.47.0.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-qiRnrJKZNN-7ImBkIcWxnw-1; Fri, 16 Apr 2021 23:56:25 +0200
X-MC-Unique: qiRnrJKZNN-7ImBkIcWxnw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2iMopM6+GUE/z8DMr5PtIswXDAR34WjF/RJGgQ104+gnveW749cLJDJ5x6XuNU5AhhJstuWMIyP8xvVFrYFizqtA2smHM4tj6/KfMl9MbNRoVMLqALSAHO4XSy7xMu883aphb/srZVQaIL3r/Jb1RwtyNqGBwAaK3ReUZyViE7Ewox5h4AwLd4B2uSlHqIvY7x0uJzCkAeNZtdIoLEvCHggezWbODwRQzs3D3L+ScJiYZ7+hDKy2x+V49pgSiUrVMxMrlLeecIwQkghVF3IOURKfejwiWVvHgwway/Mrt1C6ZD0YbyZ5UtRb+ME3VhH1V5iQF6Ni5zPsznJIHC1ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZQlR6ClXxOb0XDC4pzrR1AXccnIVeBF8pnzMZjR3cw=;
 b=ladoS/GHVNrTwvKhvkGNloNPIHZ5lL6DJ/f3WY05oBAGV3DfZDXdauz7otR5X3N02ygLeFso646VUXsX5sPi9+nDo0z5X0/MWjEW3D5HNE/kdqvB+E9DyfE+GSfhyscPy+LOTteijfWG/k9plPeLeHakrIeMPFuXMa92PRl5XLz8f83gQzNr4fd/6YPIjcKoET4q4zrT317o6eHv2Xr1FcUEp36ZD4CDAmw3KgW7p4ayUNE+fO+FI73rSVyGGQiZHZ65BQjYHw8UM3dxTbUsgSRnYdYvGktNUSAgkWtZzyGOki3AzKGVlTAIfqAdq4I3atZR/fvac8x9XZiF3eR+Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB7016.eurprd04.prod.outlook.com (2603:10a6:20b:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 21:56:24 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Fri, 16 Apr 2021
 21:56:24 +0000
Subject: Re: [PATCH v3 01/17] scsi: iscsi: add task completion helper
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <ce32d391-0507-6855-a308-0379b5ae4098@suse.com>
Date:   Fri, 16 Apr 2021 14:56:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR2P264CA0032.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::20) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR2P264CA0032.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 21:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e166ee37-47bd-4857-8a36-08d901227a15
X-MS-TrafficTypeDiagnostic: AM7PR04MB7016:
X-Microsoft-Antispam-PRVS: <AM7PR04MB701607C1F9385DD48C0750CBDA4C9@AM7PR04MB7016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubSlvggmT6rEH+pv6m33asQHVLVw8tm2WNTa6BMR2qfvm8uIQqkmTV6do/qce32vZhE3ge9b3rnfCnUVp9nAXBsB/RhMWAYmCTwZAJs9borwIRitLcz/5HDTQR6LmkspXbdu0KIzbR6f0njwWQhXwi+wHif805bx3NkvcpqO6X9SlWo62/y4s3ITl4L9R4te4Wz0ytFQVAXqXUEH+M0RZOhmPAs26AGesPVtZjqMXRZNfkT3qhGA26S4HI8l9DvCiQBCzmuqMeryqsmERYybWWUjW2/Sv2EI14O2kKvj5bfbGpKe7PutvWuAUW3FkAo1Jmm31T7tlUhp+elULP3UJ7dLukHDZL4s2wJI4VaOeThG4bpCPJYlu76heWnhX3x6cYsGi+E4x7MjgfRVNqCDtJ1aWME2KYJmrJfH666RrXkMd7CMkMH0G8R3YcoVN/awFMqkaD2JZMjZM/EmXHkJIvmZy0/I1ZUJw7G546LZm2KY51zmW4xVGXFfcAY9oLpdTUbkg1EiPasxz96Bb3NMFuDNJIZQFpSGUZuxcrMJ3qoS/g7y8eHmihPTrYv5FOk+bGDYaSkO0bBudjXmsNksbad8ocKA5dB65SpegCcvfIQcclh43+8RMMZrl++wNygFLBn7T9+AAHqWwFX/F3BotbIlBOTPtqfXW+ABPHL33P9YtOI8Mases3Q3qPKCPwnnQwyEJztRUCLVLdqlh6nwHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39860400002)(376002)(366004)(6486002)(8676002)(6666004)(38100700002)(38350700002)(36756003)(4744005)(26005)(478600001)(31686004)(186003)(16526019)(8936002)(31696002)(2616005)(316002)(83380400001)(66946007)(66476007)(66556008)(16576012)(5660300002)(2906002)(86362001)(956004)(52116002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjZYZ3l2VWlvMFU5b01rQVk4TmpyWTFzZGVnMHpVRUk3L0daNk53SkJDRXpl?=
 =?utf-8?B?MTY5aUJtSjVVc2hwdCtlNHFzY1pwcjhFa3dDK2xPL3RnUENzd3ZXRXdEcjB0?=
 =?utf-8?B?QWo1bkVibUtuSjZqRDJLUDBqSnM2djFRR1JZd0I0elRtK21DKzF1eTRSeVpx?=
 =?utf-8?B?YTdMTUFmamdJMmh3ZXdpdnN2U3BhR3pyZVkzQ0VCdjhBRTc2b0NsUzQxWGVk?=
 =?utf-8?B?dGMycGlHeEhlSGxkRGZNb2JXMFJXKzMrMzFRd3lGQVFybko4eXp2ZGk2aHoz?=
 =?utf-8?B?OHFjbGtHQ24xWHNxazBubnFQWDhhNml2akZFNkpsZEN5bkcxaVREKzMwTi9L?=
 =?utf-8?B?ZEYyTldpVGhucUFPS2wyUkhzWFIwdGE1T3ZBK3BmSmRDRHErY1lVY2NYbmVW?=
 =?utf-8?B?dUR1YjR4RHFScDdCQ0tVMEtVcEJ1dEtMZFkzL3NKLyt5K2podi9YZFoxeHpC?=
 =?utf-8?B?bXNpT3FNWHcvM0FNRHk3aHFLSWN6bmdiNzNQM3UyenFwNmhQMDlwSVJpYU1n?=
 =?utf-8?B?R2RsY09KSUpWQ3RtZGdUMCs4czBmL2lwL0NycG5LeEVxT2ttSzcvVlAxZ1hq?=
 =?utf-8?B?eUpJQXV0Yzd2U3k4b0MvVmtNenYyaktEMWJld1NpSEpnMnZOeUdNYkxOSUFY?=
 =?utf-8?B?WGhSZWJrWE0zMjN5M3lqcUIxeTErTXJQcXUyRkdyL1doOXJZT2pyVTdjVFBv?=
 =?utf-8?B?RjlzZUMxTkQxNkwxMExtTUJsUTlaVk41OTB0K1RPRTR1Z2sxb3o3aFFmVlMy?=
 =?utf-8?B?M01zbXVOOGl1ZVE0M0tRZHlqc2YxZ0NlZk9FMVRDWkhSam1XeVl4WU5NaGg4?=
 =?utf-8?B?dE5VTVZVQUZHOWtvenFkL2tjNTc2K0VlTW12d3ZQWCtCcC84MVFySGM4NTVV?=
 =?utf-8?B?VGlBMVB1emdaS1RwZHZrK0pBaEpEZmhkNzhrRWIvOVIySzhhNy9VS3YyUVlP?=
 =?utf-8?B?VUZmZi9JdFlib0l6MXNOVithNENmWStHWWYvdTVTRXRWTm9jQ3JIem1jdTZ1?=
 =?utf-8?B?U1RUYWRWS0xHMDlDVkhEUmhqd2ErS0kxT1ZBRTlaMm1SM2VRTjltYlBMcWJr?=
 =?utf-8?B?bkp0d1p2RGhOYkttYjJKUmZhUjRCd0RHcDhaQTZvMlJaNWMwUGFVTHUyVnQ4?=
 =?utf-8?B?Q2g3S2hoaERrdStJR1p2N3ZkYW5BbC9yVEZSZ2FNaytEV2tnUWpwK1V4S1gz?=
 =?utf-8?B?ZnhUckNiL3FZL1dqM2VXcFZHRGkxU0RNSlZkQ2FGbldRejFKYkVNazV2dGNS?=
 =?utf-8?B?YVZHK0Mxc2hrQ2pFOURueXN5K3MvQllXT2JmL2RCVGtGTTIwNEpMZFA3ZmI0?=
 =?utf-8?B?eFdGTWRBRGFSS1VENlN1K1YzTVFialZmSnhOMnpaOGtiVEk2TStzM1VHWTMy?=
 =?utf-8?B?MVYxQnREbUlBU3ZJcWVRc1pTNVQ2VjdjTTdHWW04cFRYbGZKUzc5SkphRG9o?=
 =?utf-8?B?NmxmS0YrS1ZWano0NUhPS21UbzByNm5OUVVqazl4MDhrT0tiQWtjc1lyNkVm?=
 =?utf-8?B?LytyWVpERjhnU3d0ejQyRE4wa1N2OTNWU3RxR091L2ZwZjQ2b1o2NGdNSTRK?=
 =?utf-8?B?SDFnOFBQUFNJbUxvU1Q0QVI2K3RLNi8rL2tYbHVIVnViMkQxUyszOHA3Zi9i?=
 =?utf-8?B?THdUUHBJKzlrMzVlc3dTMW04T0dsVmZDcFlpdmxUNXMzc2RzL0FCTytyaGI2?=
 =?utf-8?B?cWREQWhnM2s5TCtwYThldmUxdTNpQ0h3SDBDZmVjYXd0ellIRWNLK1RKakJM?=
 =?utf-8?Q?MJ48/dmVgzuEfOMo6xqNyMO8ocAwda9JttKAROD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e166ee37-47bd-4857-8a36-08d901227a15
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 21:56:24.0452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjUeX0VD+k8jWdp6jI0N+l/Pa2UZgAXALBJBMYC3ZzO3lFKesmzWw8pVESVx3b/3mqneQIsHBgVzFxSIinnxUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
> This adds a helper to detect if a cmd has completed but not yet freed.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  include/scsi/libiscsi.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 02f966e9358f..8c6d358a8abc 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -145,6 +145,13 @@ static inline void* iscsi_next_hdr(struct iscsi_task *task)
>  	return (void*)task->hdr + task->hdr_len;
>  }
>  
> +static inline bool iscsi_task_is_completed(struct iscsi_task *task)
> +{
> +	return task->state == ISCSI_TASK_COMPLETED ||
> +	       task->state == ISCSI_TASK_ABRT_TMF ||
> +	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
> +}
> +
>  /* Connection's states */
>  enum {
>  	ISCSI_CONN_INITIAL_STAGE,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

