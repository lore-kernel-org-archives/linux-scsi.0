Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395C9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiDHRuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiDHRuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 13:50:20 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBF5BF947
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649440094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Y3kVbJmBPcc2u5t5K7iXjBbjv8MIjtETXLicrutm54=;
        b=RnIcB7R1z/7CXVU5Y8Xd6M/BJauqz8Zz4/oqmwEbqtViD3SNApvKAC4fuq4fbRiAw+EPBY
        wvYayC7gVpKdwvAa7bBDgVgpDNFIFG11DIGbAUO3Fzfapn1QWkB+2gyG0s4qwRQaBaHRCW
        l607u1FWLfkpuTbYX7xXCay9ibTea4o=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2107.outbound.protection.outlook.com [104.47.17.107]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-ZLBYKUc8PLGbWp54pVcUbw-1; Fri, 08 Apr 2022 19:48:12 +0200
X-MC-Unique: ZLBYKUc8PLGbWp54pVcUbw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jc82jPRE0eEToU9cByjHCeqSOM9vSElvUEnIoZdXLbN6zr7TIlT0m0IVzz9LJ1TwBCMqamy6ZK9MiTgAnVqbt0hS1PICo1zV/9ZMjpaaplF1KYtj8ybHa/HigPjVSs1io3qLOoW1NRqLdACCFfAYQvykQYcB7EVIBjrWx9AQFh71SvWWp2pcaIPs95penl7hE8Vcf+lcQvXugW/hzTqNQRiDuQ9Y0R1v1XwDMPXGe0kmMgkYQK/8jRIayrG4D8NEksjRxQiGF9hR0jVMoD/ufid2IGvH137l6YGl6e7s6cpytXyA6gyClDBnTQdNLXcCOhhzSrOQ9eqJ3iKkaB5rNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Y3kVbJmBPcc2u5t5K7iXjBbjv8MIjtETXLicrutm54=;
 b=OXGxSFRpFbGOAvnvrnZABIXUjgAuMGyivFKNlqf8Ciw2Ht/k7jxlGpZR6QKmWYATx4OTFElmSFuU/sd3wMnzgc+yOgJjazUG/ye1UxXLdglGEdLcN0IKUV8813dfYtHrcK0kF3/KDY7ei3WB0uVTYRICRsrc8jlWnHe13dz3irCfJEW+HJuq452P1kvCPBEmwKBKc23jwtOtqH13yBRryu1P9FVFdTAscdn6Cka7FWe3D9I6jpQotAHIJiScL/fg8JQlcBYkDxuyiLqizx7KYduEhX6GDAJHTAZDTg5uZN/4xZiSMVaJZ2BHlpQgD4rs/v5eoUYpljkzKX5tAsDxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB5331.eurprd04.prod.outlook.com (2603:10a6:208:65::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 17:48:09 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:48:09 +0000
Message-ID: <54f07377-fa76-486f-38b2-d37f8a64af75@suse.com>
Date:   Fri, 8 Apr 2022 10:48:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 05/10] scsi: iscsi: Fix conn cleanup and stop race during
 iscsid restart
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::11) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c4cc2fb-97dd-4d15-e0c6-08da1987f1ca
X-MS-TrafficTypeDiagnostic: AM0PR04MB5331:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB53317E3E0B155F0C86A544BCDAE99@AM0PR04MB5331.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AyYsrPLNZidD0gqKjo5i8/mC0dYyQzKAyvGx1mcBWiididvBJsxIWsRoZIOm/zGiC6L1jrwhiP8rMGePQlmqO3FBkATlxMH46p53Clet45cSP8KdA9WEJPb3sSa0x6PzYNNAGn5kegasmp5yFk+rJ4sGhf5uyfAIrk3sR9x+1qWwxskHPLAtNqSRo2BqVFTdaEltjOmVLw+4/fxbG1ZdPE3kv1pqPbdJC3ZVuy2yhkjgAADSGx3v5gD/0tm2vvmPKSq2pnJPJGKV8BNCG3It4VW3j85CQjQS0p2kAukYKco5uWJXlhAs+PP889eMCwlxd+SJKPfvjhOTZos4qtlz3NxsS470B3cE1H4TOxGXBSolRkcP5PUL9lXv/O6RTMYPDPyN32tbEIB9SDxsKq+JGs+dYadimagFf97xcZYUmincFIhHAYnhRBObZlvqyWtX1LsdQptuLYI4Se3wrcKFws16gFm7UTKEi2HhctjtoHbcUOsauIa0fgIKIG+wMfcZQ26rJJZtbJCd1zKf1vCQGvnTGmaRb4prNddEKn/qP6H0tW9Nsy955FXbpPBOxraa9EFtUFF3qZ1ZBnTDC8k0umbTuAC+RFi1c4Nh6xgrM1B/ttzlWTfyHA70c1GWeXUTrxypt0MuhonvY87IXz0/HblkCKxXjTMqZMPZhrqFja1hkbpnTlbNcmBOdjq581LpN7vd7inVOevb9MW4xD5GA3co4sQL0RqHZyP/aMGHRwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(2906002)(31686004)(36756003)(6506007)(8676002)(186003)(6666004)(26005)(66476007)(6512007)(66946007)(66556008)(53546011)(8936002)(83380400001)(86362001)(31696002)(316002)(38100700002)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eER1Y2U2Q2dDb25CUjE1NytHM1FiQ0U3dVkxdkFnWmdGR3ZvMDBpSkV1czJE?=
 =?utf-8?B?TnpmdXVyTUFwSG85Q2JIQ3VnRUVsN2lBVXRpaWhpajRBc01vSy9FOWlLNS9N?=
 =?utf-8?B?azQwUkR6bGpOU0JJcVpiYU1OV3M2eWQ1aXN0SS9KVHZHMXBMU2t2UmRCVWk0?=
 =?utf-8?B?L2NMUmsrQ1hkL3I1THRMYU5HcUlBQmF3Y0VyNDUrNFJ6UklYUG5jZ3JSV3FW?=
 =?utf-8?B?bVR0cjJ6Y05SVFAwUmYyNUl3dlEvRUd0YVBDcC9zZStGZWw3ZTZVeWdyc3JS?=
 =?utf-8?B?MzJXQlI3ZFd4eDhxS000SHBmeW1USVRHSUU5T1lYcHQ0SFBFOWk0ODg1cXJG?=
 =?utf-8?B?dEdPZHd1YUd4TnJGRjNuMGRaVHBMYTBMMzJ1UlBZUlRjOWtvRi9zNnBISFV2?=
 =?utf-8?B?VThCNlE5NzVaNHRFSHo1NWRkeUhLeUJjZEtzUzR6c3V6MWFCaVpOazQ3UkdK?=
 =?utf-8?B?V0JaRHlOYkwrNWdFdktpRFNYVVJycDJNZndnNFZCeU1RYXZmU3oydjNpVGZ3?=
 =?utf-8?B?Mm5kSnJjLytzMnR2UzlRM2VrUExuTVVaY281QlRqdXFXYmpRREI2YTQ1T1VF?=
 =?utf-8?B?b1pJTG1FYWtlR1Y4QmJrN3QvUzZ1Nml0ZitMb0grZTBpQXRwWEs3MlNRbVBH?=
 =?utf-8?B?cDF5MWxXUnQvVW1JbFVHZHFUVHE2NU1XaWZncUZBY3N4MjM3NXJ6ZWNGcmx2?=
 =?utf-8?B?QVVXMGQyeHE0Q3dSNThvUXB4RWx6TnBvQzluQXo0WkQ5dEtiTkN5MEU5cUh2?=
 =?utf-8?B?RVk2OFM5RE8zdkNvejlYT2h0OUVPYlB1cExtb1MzTk5NeUpHODJZVVBIbW05?=
 =?utf-8?B?b0Z2SDhuOFJjeXhzdlFtckFKWTgvNDJmYysyY05oV1piV3ZPR3Uvd2VkQ3ZH?=
 =?utf-8?B?SE5HbnladC83OHhNWUF6bVJCWmR0UHNiOXJucjR4MFozRkhkdVhCZ3lrRWZN?=
 =?utf-8?B?VytjaThjSVNOWksvTERkUkE2czRNSXFvU05LT3BZU0EzcG00OHNnZzZ1aVdq?=
 =?utf-8?B?QnRndFdSTHk3RzVsSVZoVzRJVkVRNldnTlRobXZKczdDYzAva2E3dVU2ZXFZ?=
 =?utf-8?B?UWlEYjhyVFJaSDVUbXprQUxFT2VmMkFEOVEzQlhVVUJ4b3ZPWDRyZjFwWWxi?=
 =?utf-8?B?VDFLKzhCMThTNWxXYXpKcSt0TlNOWUMrckd5bXRpTWVMZkc0SXZwTTlPWHFj?=
 =?utf-8?B?THdDMEp4Rkc1ODNZb2tKWm5nYzd4YjJoQ0dsMUtjRjJUakZ0YzVQRDBUbnZn?=
 =?utf-8?B?cXFDZ0hVQkRCSjNHYi9DQnhlSjRJdnNvL29ZekZJT0NHbC9veHdranJmTHFw?=
 =?utf-8?B?aHl4RFM4RFBjWTdNNU5zRDYxYzh2aS9XU0pheXRlbm1kcG9qaHQ1Qms2dnlY?=
 =?utf-8?B?bE9pMXhodjhsbFdrT29hWTJObXlMMFNEd3M1MEljbkgzeGhaTXlGaUZ2MUlS?=
 =?utf-8?B?aXM0MzRWWFc2aExZcWVLSUs3SnV2MzBVSm5ZelIva3RMWTB4VUF6eXcwNmFG?=
 =?utf-8?B?WWQ3T1p6UERLRFk1RlpCdGhPZ2RYaTZudmNWcFVuNm4wOW1PTWJCMXRqRlBU?=
 =?utf-8?B?cjJpY3BzenBxSmNhajVkbHVPN2gwU2lyUnQ1dDNHekxyY0x2OUg2NEZqbm8w?=
 =?utf-8?B?SXRRdTcyT0phKzFNTEtGUURCZEw5VFA3dCtnTVovRnJ5SzN0R2owaGMxZ3JG?=
 =?utf-8?B?N2VQdnFwYzF4R2lpdEc3N2tJdzljK0tjSVozUDEyWXYxaUlUbFZxZ3ZLKzFF?=
 =?utf-8?B?WmtBYW9nZ29GdDlNZU95UHJVWDREV1NpQXhxU2FlMnJXTnhhRlRWb25SN3px?=
 =?utf-8?B?bHU3aGdOZXBJVHRLenc2N0tCenV1WTNTZGpua1gzdktkMlNDSEFjbVkxTVJa?=
 =?utf-8?B?eDA3bE5NWnhuMVVBdXZ6cjA0dkIwYUduWUFWUzNVYTd1NWVKdURvQW8vcHJm?=
 =?utf-8?B?MEs0VTB4SHQrVEFPT2hmdUpLNTVwaGVVKzcrWnRnSTJVZWl5ZnBNcVE2aWJv?=
 =?utf-8?B?SW4xUnJseXU1Rlp0TzdVU0NjOTNsTlZqeEt0b1Q1ais0c214YkpHNGFXK05P?=
 =?utf-8?B?dGpkb1VsUE9ud1ordG5jTnlIb0Rsam5qc1pyQ0tqSCt3NzJFdFFKZ01jcjNV?=
 =?utf-8?B?WHhCejlycjcweHhYMnZmOVBBa3B3YUxoTkdEbFR0RHlEdmJzRFNhU0ZwZDJD?=
 =?utf-8?B?SjFVN3kzLy9paEpCU1oyV29VSlordVdwREVTUFpBZ2VhbmJGc2hNem5HdWpD?=
 =?utf-8?B?Mmd5dThJN0I0ZkQ5WTVzUG85WjRaQU1IZVFkTFd2WUgxdXFwWDNReHYzaE9S?=
 =?utf-8?B?OWlSd2gzWVUvSHlzTDRrSUxIbit1WmtnYWg1VEFKNjN3TTNvNzRJdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4cc2fb-97dd-4d15-e0c6-08da1987f1ca
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:48:09.6418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4QJnh/pNHPIdBWhua8t+f5qyZZWOhL9In4SIBEQXTx5M42OF9+p+tdGRIFFDOQDsq5AnRL8h858sr6F/Y6V+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5331
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> If iscsid is doing a stop_conn at the same time the kernel is starting
> error recovery we can hit a race that allows the cleanup work to run on
> a valid connection. In the race, iscsi_if_stop_conn sees the cleanup bit
> set, but it calls flush_work on the clean_work before
> iscsi_conn_error_event has queued it. The flush then returns before the
> queueing and so the cleanup_work can run later and disconnect/stop a conn
> while it's in a connected state.
> 
> The patch:
> 
> Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> 
> added the late stop_conn call bug originally, and the patch:
> 
> Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> 
> attempted to fix it but only fixed the normal EH case and left the above
> race for the iscsid restart case. For the normal EH case we don't hit the
> race because we only signal userspace to start recovery after we have done
> the queueing, so the flush will always catch the queued work or see it
> completed.
> 
> For iscsid restart cases like boot, we can hit the race because iscsid
> will call down to the kernel before the kernel has signaled any error, so
> both code paths can be running at the same time. This adds a lock around
> the setting of the cleanup bit and queueing so they happen together.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 17 +++++++++++++++++
>   include/scsi/scsi_transport_iscsi.h |  2 ++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index f200da049f3b..63a4f0c022fd 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2240,9 +2240,12 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>   					 bool is_active)
>   {
>   	/* Check if this was a conn error and the kernel took ownership */
> +	spin_lock_irq(&conn->lock);
>   	if (!test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		spin_unlock_irq(&conn->lock);
>   		iscsi_ep_disconnect(conn, is_active);
>   	} else {
> +		spin_unlock_irq(&conn->lock);
>   		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
>   		mutex_unlock(&conn->ep_mutex);
>   
> @@ -2289,9 +2292,12 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   		/*
>   		 * Figure out if it was the kernel or userspace initiating this.
>   		 */
> +		spin_lock_irq(&conn->lock);
>   		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +			spin_unlock_irq(&conn->lock);
>   			iscsi_stop_conn(conn, flag);
>   		} else {
> +			spin_unlock_irq(&conn->lock);
>   			ISCSI_DBG_TRANS_CONN(conn,
>   					     "flush kernel conn cleanup.\n");
>   			flush_work(&conn->cleanup_work);
> @@ -2300,7 +2306,9 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   		 * Only clear for recovery to avoid extra cleanup runs during
>   		 * termination.
>   		 */
> +		spin_lock_irq(&conn->lock);
>   		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +		spin_unlock_irq(&conn->lock);
>   	}
>   	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
>   	return 0;
> @@ -2321,7 +2329,9 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>   	 */
>   	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
>   		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
> +		spin_lock_irq(&conn->lock);
>   		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +		spin_unlock_irq(&conn->lock);
>   		mutex_unlock(&conn->ep_mutex);
>   		return;
>   	}
> @@ -2376,6 +2386,7 @@ iscsi_alloc_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>   		conn->dd_data = &conn[1];
>   
>   	mutex_init(&conn->ep_mutex);
> +	spin_lock_init(&conn->lock);
>   	INIT_LIST_HEAD(&conn->conn_list);
>   	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>   	conn->transport = transport;
> @@ -2578,9 +2589,12 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>   	struct iscsi_uevent *ev;
>   	struct iscsi_internal *priv;
>   	int len = nlmsg_total_size(sizeof(*ev));
> +	unsigned long flags;
>   
> +	spin_lock_irqsave(&conn->lock, flags);
>   	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
>   		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
> +	spin_unlock_irqrestore(&conn->lock, flags);
>   
>   	priv = iscsi_if_transport_lookup(conn->transport);
>   	if (!priv)
> @@ -3723,11 +3737,14 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>   		return -EINVAL;
>   
>   	mutex_lock(&conn->ep_mutex);
> +	spin_lock_irq(&conn->lock);
>   	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		spin_unlock_irq(&conn->lock);
>   		mutex_unlock(&conn->ep_mutex);
>   		ev->r.retcode = -ENOTCONN;
>   		return 0;
>   	}
> +	spin_unlock_irq(&conn->lock);
>   
>   	switch (nlh->nlmsg_type) {
>   	case ISCSI_UEVENT_BIND_CONN:
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index fdd486047404..9acb8422f680 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -211,6 +211,8 @@ struct iscsi_cls_conn {
>   	struct mutex ep_mutex;
>   	struct iscsi_endpoint *ep;
>   
> +	/* Used when accessing flags and queueing work. */
> +	spinlock_t lock;
>   	unsigned long flags;
>   	struct work_struct cleanup_work;
>   

Reviewed-by: Lee Duncan <lduncan@suse.com>

