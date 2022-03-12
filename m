Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73063C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Mar 2022 19:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiCLTnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Mar 2022 14:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiCLTnb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2022 14:43:31 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3DA1E95CD
        for <linux-scsi@vger.kernel.org>; Sat, 12 Mar 2022 11:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647114141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ag8JnzSFH9tYCZWBRu3V3MxQF8nNf7tw+K0ji9HRYUI=;
        b=CO+z4L5lD9sxEKBDlxHc17Igmu3+n/F7x+lcCtVoLh0RTMNP7uPcG2vCyFJ5JHqtxYjSvL
        GMTEYilhnUMfoyolGVRy52ps0iiTIatFogIMPPKknNCeApMlPrPn/xJ0yF/j5o3UHsqRTt
        7mK/5Q/sBiK5nDJHgi3LnwGmfgibKEs=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-FUya3_XgPl2oGnzlut8yAg-1; Sat, 12 Mar 2022 20:42:20 +0100
X-MC-Unique: FUya3_XgPl2oGnzlut8yAg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpMDHgqfVbWBhNOE9HuUq92/5sTyb+JqKBuQnYR38eTXteQDvK0nXbswr/z6hFxeAFR3pg9F4ayO12TbpHlXa3AmpQ9KZdokAJuLHGvSkdqOZ2bnZW1OtD5iHCxYcSxj67YGUxouLYlwqw11Qc1R1JJPmwjKBsQasUW2F3Kw22twxM6Zf6JITRnBHYEowx4+hyV5jdRj0jDcJNgVF/y3yaF0t/jWhOnGS092YV5i7EddsgpHcr1ZY/jp1h/C/++WJoC9W0YzG+K5CKX1gmJQV6bDmK1zoWCl0p/Gy84pu8Zl3PTPzCUCb0RjFXIVgjpBkyQmt5h3Pky3cbDrj27pnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ag8JnzSFH9tYCZWBRu3V3MxQF8nNf7tw+K0ji9HRYUI=;
 b=H2fNrw2KEqD64DcF3mJ2s9w3s7XJWO3ezGiupfovIS1trRQ0QFyck2pmck53YuL7whykCdXN1tLSOw2PHNlLa2ojt+rY2Sj8cB/KmLV5+ehN0f1ipY1okiNEcCqOrrALJuMZqzT9Aqu8vQqd0x0QLB5JEQb8bO2ltbpWSk+IPx0htS5ktwFQs9r+YyRlDcfL4c0nYY0sIk4J7zLeATjreVEnS+aOQsOyh6dmYCIDbvHgpoBCG4Ccc/jiFRBe8A9hyzBl9nccVr6SbG+79ZmgHEfNY+ABiCnES3n11I4/PxT7QZ44VrRgzbEqbwDmOgkpYIq1uKB2jGdbw6dZqxphdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by VE1PR04MB7215.eurprd04.prod.outlook.com (2603:10a6:800:1b1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Sat, 12 Mar
 2022 19:42:19 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5061.025; Sat, 12 Mar 2022
 19:42:18 +0000
Message-ID: <49ce092f-b97c-53a6-85ff-490eeeba4f47@suse.com>
Date:   Sat, 12 Mar 2022 11:42:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 06/12] scsi: iscsi_tcp: Use sendpage for the PDU header
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0168.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::23) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58ea3fda-12e2-4137-c421-08da04606b1d
X-MS-TrafficTypeDiagnostic: VE1PR04MB7215:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB72156A972BE37A19659E8B6CDA0D9@VE1PR04MB7215.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XKeG23C1eEAsfA01iDWO93AS3ruNYbPTXqO3xxblU8xeDhm6xG4zZvd+Ep0Goh9X8B3ThEDKb5HNqbHf8Ipf/3j/rB/KOtDowTK+ksRc+nuXv7JhTODiVFCYbjAwlRDJ4TpeuE7+8ffYSlZpB4ukm9kHaXQ4HqxzZ9u9P1FnO/JwvCQA38cht5TahcpIRECeliKkhJX70rVlaswZsB6So+Wvy+7Mj9XWwMPLH4P2Kz9aZcWYJa0hnKc2yys0W7Hi86giYoJ/+azajhIeEZwZuwrCyFxVf3WLPT8d7gGo2DbCPPMri27XQ/RQK0meLvwRFaLxoucPlp3FcjeZjFH8Z22gb8nU+UsYi+AOPC7Xx1WEe3d0b5U1stQM865lFgqjTRkw4GYRgVcEh+NiY9o7uWTgFdn1nGBEMTq51NKbBjvLH0oc95ygI1zU+AOkV8DIGBFKKiBr9yjKMs1c55bflTQY82Yrsm5hXR4P9fCrY1dU1oEVRKA4UClbi/RZBwJGmj3GfhJR0Sn8968weY5S4Auu5Fhs6tyx6sorjiTilIlFBsVENrvSpvn5WdSiXb5SzYwrB3aB2S5zhlqi9BAlYoJthocvEaQAWD9e4A6raxKxxtfeDoH0NEaIydgqFUKHsknuQsl8L4cT/DHHtuJdcEdWIfCxwU18+RKKjFd2xBCTttNl+a1rsyzbTD+Gn1Gk/WpHKzp/gCbYHb5CsIsaaWTLpg6/kXb5al4aC4l9vP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(31696002)(86362001)(2616005)(5660300002)(31686004)(53546011)(186003)(26005)(36756003)(6506007)(8936002)(66556008)(66476007)(8676002)(508600001)(6486002)(66946007)(6666004)(83380400001)(6512007)(2906002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3hURHhvUitmY04vdjZwL1ZvTGlFOFh3dkhORVZ4TURwWDB1Tm50K2s0VGQy?=
 =?utf-8?B?dHl0YmdNcHIwN1hKRlorTWhqVzh4emhRT2tLVy9sRDRGME5PWW4wa0xRMytP?=
 =?utf-8?B?dFVNNThZOEE5eEcvTUZ1bHMvNkVDdFdmeWI1SEZZR2t3ZkswUXZVUVpFdzRP?=
 =?utf-8?B?NEhmbWI3Tml6a3Z1c1NwbjJxVTJvSDhCTlRDVWp1cDgxc0dkMEhFaE9xbGFy?=
 =?utf-8?B?RWlBdnJ4SG9WM0JYcGhrcHZTUkNraFN4eUpqZTNOTlVKMkZjS3BaWkFuc3Bw?=
 =?utf-8?B?QTNYd2V2Ujd6Q2NxaW9KclREYmcwSzdUS01SVjNFVlovTitkU0hmSkRSS1V6?=
 =?utf-8?B?akJTOEFzbjNYK25NamhJSEN1WE44WEZWR2tXVm52RkdjTzUxSnJLbElpQms1?=
 =?utf-8?B?QXFGU1ViV0ZlUVlWN2JNUCs3c0Z4cm1MMFpvQWJIMFJNSVBteCtETGpabHVi?=
 =?utf-8?B?c2NiSHpoWUlOV2N1NmRKNFY5KzhiMm5YUWlXNjZjTkpvWUVXbWM5Y0tDYnRu?=
 =?utf-8?B?V29jdmtoeTFTaE94bTRRY0Vna1B6MUM5L3ZUbk9EYnFUdzkrSkJ0d0hhc2RV?=
 =?utf-8?B?blFUVmsxSGZJM3czNjV6NTJXa2I0QkN3RW5KS1pKN3ZlYnhMdHMzNytrcXU1?=
 =?utf-8?B?bUd1ZVJMRjU2NlN3eDJ5ak5RUWdGbHZVSHlscHBWWUNaZy9wcWVtL3dZaTRj?=
 =?utf-8?B?ZWt2ZkZ3TG1ZNkdhcXRIb0F1d0Z6dWNiNHVwOEJNQklka0Z1bTJmSEN1TTlt?=
 =?utf-8?B?aVZhbUZQUXhnUm1XQllPMENnNEg0UW9JVTdsZkduSTJjZWx1cE93UmpUZ3Zz?=
 =?utf-8?B?ZDhtT1BtVnBJSWZpaGVMNmc3M3NlOHBoRHdham5OZUUzQ0dyQURRKzF3QlQ1?=
 =?utf-8?B?KzBrVHAwY3JFbGVudnZZYUxHemRYMHZXYWgrMFdsbEZZSlJNOGV1T3hudENo?=
 =?utf-8?B?dFA4Z2QwNCtBTEExR3prK0E5MkpwdGNDb1k5cGdtRHZyVENqVFBZWmd3Ly9X?=
 =?utf-8?B?Y3NIK2dkcGwvNlRMOGNsNG5PamtRbGxzY0pGcVJLZDBmSjd1WHMwSS8wTk82?=
 =?utf-8?B?eFRhSlFyMkZkQzdIalROSURQSFFmbC94L1V3UDBrU1ozSk9vcmVmZldFUWQ4?=
 =?utf-8?B?bHNlcHZUWFJTRTZ2MnNuN04yZEFSeUZsS1NkRXdMQUg0MFA3a0NZY1FldGxO?=
 =?utf-8?B?TTlMd1BHUEdNZFh1NTBDQUtVUUV1eG9IeUdNc2t4dXptdFdBWVAvR2NRazYv?=
 =?utf-8?B?MHZLM3VJNmZ3bW9rSFppQk96K2NBc2ZOZE1Pa1FLanFlcUUzMzBHVzhjeTBB?=
 =?utf-8?B?Q3RMNTZkdkJ4d1g0MXkrRWZ5T3JYdXgzRndIT1J3bStEcGZKVXBHU2Jhejhr?=
 =?utf-8?B?L2ZxbHB4NkhOQm0rNGtidVZVcTFqdVl2ZHVsMENDOGVCSzl0aEJlaFR2TDVq?=
 =?utf-8?B?MXFZYm05dzJ1QlVJeitkRzBRYi9TRDZaenpNVW5ZVHkyeXRLdmt2WjBpYXhs?=
 =?utf-8?B?OHJub2dpZXFESGxNc25PWHl2SUEwVVpaOG5yV2h4VUtGRndaMHMwa1BRQzZL?=
 =?utf-8?B?Wk9aNmdxYlkxOTJBa29xeDFxT1k0bGNVeWRyU0h4R1F4RzFpUzZuMGEvOEF0?=
 =?utf-8?B?TFJ3QlZsVU9qOE4rZ3BVM1NIY3V2M1d5U3BOend1TFRiUFhpNUFMQjJVMkYy?=
 =?utf-8?B?dUlubFF5SmFBRk93bHhRVzJEWHJpYmJOK3gyakRjdG14cnR5a0JJNU14NEo0?=
 =?utf-8?B?QVlZbzRPaEVzU3lmTW15MVRacjJ4KzdPOG44UmhFSmFyQ043L3pEcW5Hc0ov?=
 =?utf-8?B?Y010bU9USVpDWUhKTDBCUEVzcExCOVhNQlVudG9CM0JxSWgxdDE0djJjTkxM?=
 =?utf-8?B?MlpPL3Z3bWpQWmhPTVhBY3NXRE5FWjVOMHh5WWU0cStNbW5yeVVBMzgyUDlF?=
 =?utf-8?Q?oMWYDvlI+cmjOSUIfT0ORjWevm76rOO7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ea3fda-12e2-4137-c421-08da04606b1d
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 19:42:18.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RTplVbdfBgbCNVguF3nPLgf2a7LkLSC0Ubz7pHJsPp+jzpzAR+qO71drYG942Ydp5UshoyOdShn6blntf3OmIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7215
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> This has us use zero copy the PDU header.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/iscsi_tcp.c | 30 ++++++++++++++++++++++--------
>   1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 261599938fc9..3bdefc4b6b17 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
>   		copy = segment->size - offset;
>   
>   		if (segment->total_copied + segment->size < segment->total_size)
> -			flags |= MSG_MORE;
> +			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
>   
>   		/* Use sendpage if we can; else fall back to sendmsg */
>   		if (!segment->data) {
> @@ -315,13 +315,27 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
>   			r = tcp_sw_conn->sendpage(sk, sg_page(sg), offset,
>   						  copy, flags);
>   		} else {
> -			struct msghdr msg = { .msg_flags = flags };
> -			struct kvec iov = {
> -				.iov_base = segment->data + offset,
> -				.iov_len = copy
> -			};
> -
> -			r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
> +			void *data = segment->data + offset;
> +
> +			/*
> +			 * Make sure it's ok to send the header using zero
> +			 * copy. The case where the sg page can't be zero
> +			 * copied will also go down the sendmsg path.
> +			 */
> +			if (sendpage_ok(data)) {
> +				r = tcp_sw_conn->sendpage(sk,
> +						virt_to_page(data),
> +						offset_in_page(data), copy,
> +						flags);
> +			} else {
> +				struct msghdr msg = { .msg_flags = flags };
> +				struct kvec iov = {
> +					.iov_base = data,
> +					.iov_len = copy,
> +				};
> +
> +				r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
> +			}
>   		}
>   
>   		if (r < 0) {

Reviewed-by: Lee Duncan <lduncan@suse.com>

