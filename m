Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E89C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 22:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiB1WuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 17:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiB1WuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 17:50:16 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A741F12E9E9
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 14:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646088571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VYRdDUb+Ope8PUvEj6nTJNWOkSjSgZokYFOzpL10VoA=;
        b=HA3RjxOyu0Nx4mV5O6f6CD2ibQUVQBSPGN6exDv6ZoDSpDphpXif5n/aamVuuPkILqUaGl
        Rba1s6RHP0sarMZ1gZH9AXpC0LveOSblELDwJV5MHHYEunG9Dqu3/A4/f1cSsI/Irfu5pY
        uGuyC4kwG7qrfiIk6YUwGTReCRP3WiY=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2054.outbound.protection.outlook.com [104.47.10.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-5-T22X6kuYMZa4cW8VvxGSow-2; Mon, 28 Feb 2022 23:49:30 +0100
X-MC-Unique: T22X6kuYMZa4cW8VvxGSow-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFa8EgNbL/f9jc7HeTHXwN/ApQoO4LlI+urz3JGSJAenRERWElzqLTzfObhvxVbt1qlmoYSzBXtaE6jkFW0sPjfwSXTkJFjdpCcksouQZ3p1F56eIiBaXxt2nvClBSmS/BO0VkSrjlVB5z7qeB8dSqMB3XRS9Jlh1waSnrTAjTbiK03/kmDfc3T29Z1ttZun0P68hiCn7eb8+2aw9A2W99r1rq1xS8NFh6RtRzFeY+ouOxP7dBiZ/EB/DVVtkOKMcAwHGJxhOdYJ7bxP9wCN9zfBdVeeVwUdG+UB5Sux3lpzCISzihtjBWmK7nVrzDCvEV6SUR5XlMmJRR7Y1IdHDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYRdDUb+Ope8PUvEj6nTJNWOkSjSgZokYFOzpL10VoA=;
 b=gV7+Mxn95b/e9YdQhdXdIRljheYqSdFuesBbKrEtvk55B5Ru5tW/oEasmEW2ecCz8OB0Uj+y1G8I1E29DXOij/uA9MYJ4WNZC9KMwAEpOe2qETVBnHhPNgzAx77Cvr8r7kzgtSTpxRFIL9PuzcWBCrB6ANQGjll0MdlQrQlADA2DHYgbzvP4rJNEXre322qffEM6yFSPjjCwK2fejwLIDzfDQep3AhI2ITqfgHVgFaYeYcLdn6DC5A2EUntOjUv2r5/Yy6eay/WY5kdpOjyWD4wkOgHRK7oWZgFSxJifebpx3/336AlbBVeJlieCjX86BMg3WTeGdU1y7jN4EjR6LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by DU2PR04MB8680.eurprd04.prod.outlook.com (2603:10a6:10:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 22:49:28 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 22:49:27 +0000
Message-ID: <0352a4ed-3b31-0e13-491b-58d196f29361@suse.com>
Date:   Mon, 28 Feb 2022 14:49:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 6/6] scsi: iscsi: Drop temp workq_name.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, cleech@redhat.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220226230435.38733-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::29) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44ef51c5-3498-4dd5-f26e-08d9fb0c9321
X-MS-TrafficTypeDiagnostic: DU2PR04MB8680:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB86805102E68CEC8CE42D7E6ADA019@DU2PR04MB8680.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caNB1QI1iaCaya+ak7JsbGCBsRKnj45tBYGs3/j6MGp/kk1rEBM7dtnjS1ahCnSE0xGqgFWMe6FF5QodBC8dMpjxGlnUTHrVGDND9AaO3VrvjetpNtmcyrsYopFKPPqVzAqMdCwEqFMaHxyS2vsbEVjxFuhRaJE+tDLLDTzGk0ansMYSzXUxB+k972Gv+poz1asX39CskfopgmnnklcIEgVeKlrmWcFtIaddGNWjyUhQJsav2F90OuA6xeG2r6s/BF14sgwJpJfAG0t5O301lANvOJZ+jwUIv27ITcRU2eoWNpR98zboMiocvZ6SZCoBqW+yXX4p91zhhBxR0VmwkTd+6ZgTO59hJza8jpWeGoupyiIPmbYZNQgsTH9ArML+yNTUTfKOU8O8Ny3UsMez4rA59JGPczloKCP/fwBaBAb8dIqXgRrvNhrETt4VjOQVD5cXx1njSdw4zLWp5q13/Aowonx523ajN7JDhM3rht64bHFiQHR4saBmPg/0NUVF4MxOdchJs6FwiYooB+0a5r3/elykVUGkoZAhm6BTIxcnxKJVvgfM/vHSg5VKVdJTy1BY1soGClwIWvfL/d9/LJzPUjA+6KdxajFUpsE6obC0DAbiWvyCtGCvFyvBk2EY+KU9rtxYyBzLs3R+q5kcg0JkBbZBGn+WsqCRaUuz1GSXZ00FDUawXjKJGXtVbtQef48GrvFtHP0jB07zcYj9WhbsoB9Fvy8Ok7kPULlChJQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6512007)(83380400001)(26005)(186003)(66946007)(31686004)(53546011)(6506007)(6666004)(36756003)(508600001)(6486002)(316002)(8936002)(8676002)(66476007)(38100700002)(66556008)(2906002)(86362001)(5660300002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjF1MGdmVVoxMkFURXdJMkMvdTdiTlRRM1hYZ0FRR0lRdkM0YkRYVWdHWjBO?=
 =?utf-8?B?cUNMOGNidVdua1dMb0FOOW9Vd2VjdktsSzRUNHN5ZWhwQXVoS1U2cXNCQjVl?=
 =?utf-8?B?bnJJaHBHdEVKQTZYVlpqd1V5Mit5em9RQzh5MUxRS1g1dFpGeDNCNEl2RXg3?=
 =?utf-8?B?cEZQQU5jUTQvcmZWWEhGY2dEcWJFaWZ3Yk5qa0orUFEyMUhFcTBKOGlmblJ4?=
 =?utf-8?B?ZmxWVnhNbUpwWktrNTArUXNUaXdLSjMveUpyY0dxSVh2SEZadTBKWkVFV21F?=
 =?utf-8?B?NUpZdlVOOGhlWTNSME43RnhxRGlWdWZJUnh3YW5WRXZCTjBnK1JVN3krTGwx?=
 =?utf-8?B?WjRJQXJlQTZtN0lrQ2xxcDJMWUx5ejNEcW5rWS8vRnNBSUt2VkZjOGdFS2E2?=
 =?utf-8?B?Qk55bHQxbENEWmUyQkFqdnVJbGpxalJrRjUydVVGdG9pQjJMMUk1MStSazlI?=
 =?utf-8?B?R2xaWGE0YVQxNSt5eGZNYmtmS2ZEUUZxdDA2Z05EQ0VKUjJBbTYxMXVJNERE?=
 =?utf-8?B?WmNsT0ZTVCtXRDdSdXVVeHE2MlY5VHpTU2llU2YvVXY2SG5PaitjY1dRcGxF?=
 =?utf-8?B?Q2c3UUhISzRoZlVWZkxGMGUyaWNFalpWa1RUNDU3b2ZFbGMzUXYvOHNmQlE0?=
 =?utf-8?B?M1gyZFNoYkIvdGNWSlBJT3FGenpYc1FIZnJxdVhDc1llaHk2eEtJbndWMzU1?=
 =?utf-8?B?V2cwYzdDUU96MXRENVZ6SlcvOWxKYnpsNWFiUC9MYk10aE1vYlZxWGJQeFNj?=
 =?utf-8?B?UzAzNEY2SEx5ODdVeGJYQ1lEcU5KdWpsWGNlZWhMa0xlNTdrVklXbHhnQXVi?=
 =?utf-8?B?MFJRdm1GWmNzMm44RWRqZGYrNUo4aFJzdkVrb2tya2w1L3FXaTlnMTFoTTFL?=
 =?utf-8?B?TE5JSWZpaEVqbk5lWm9CeU5zZzl6WEVOVDRLTE5GQ09iN1hlYWhjakgvN28z?=
 =?utf-8?B?UG9va3cyTmw2cHBNbU1qaFJFK2RBTWJnMDJVbkw2am42SDQrblJDUU5xakhC?=
 =?utf-8?B?d042Qk9OOFpRdUd6N2Q4WUZZNWMwU0ZSbmRoZU52SUQ1WFhiUWdnMnhXQzNs?=
 =?utf-8?B?MURqN2tCVm50OUJzSGNVK1pmcno3ZXlrQ3pCYklsdTk3WFJTUEIvVTlEaWFt?=
 =?utf-8?B?b1M1RXRMdmpSTDh5QTB5YWxQdTJWekQvanRCWUczRXJQaDlQYWZQR0NSeUdN?=
 =?utf-8?B?L3F5dEozMllUb2JnZnlUd0VEWDF2UDRkWmJwdXNFRTBPNDF2K3RhM2xkcjBh?=
 =?utf-8?B?Qmx6YUJjUGpqQW9zNy9Jb25UTU9zOEpSc3VTN2ZtODI0YnRUcjFLZURmNGhC?=
 =?utf-8?B?Ym9lWlhTc1AzVG1ZSzR2QzB5UzNNUmNHM0RjZVF1c1V2bU5sVGJlbS9jdmxU?=
 =?utf-8?B?SWM1eVRtNTExeUhJeEorTXdUazIrSUlqQjgycVRDRG92cTBXTlk5WWhYTHli?=
 =?utf-8?B?UGdtQWtmQjJLdWFPandTVzBNOWZxZndSekxrQXJqQnZRVXpENkcyUDZjUy8w?=
 =?utf-8?B?NjM1M0RPaVcza2ZZL3J5UVQza0V5SHZwZGxjL3VHQlRJUm1JU0J0bHUwNEsx?=
 =?utf-8?B?Y2YxcEVTOHk5VGJkWEpJcSttTTREZi9DQjlBcVE3a0JybmNTTjNmSkpTYVY0?=
 =?utf-8?B?emZCNTV5YnRxYlJrbzhISUtoWjd6YmNLekNKWVJuenIySGpsRnhPUThFZUZG?=
 =?utf-8?B?TnBwNFF0TVN4M0dScmxMOFF1cEJsU3daTnBwVGN4ZjVhczh6QWRjWFBNM1FR?=
 =?utf-8?B?d1Fwai9CbkZWOFdCdVhBQ0VxVGRFaHNodEpocCtBWSs0cXdxNDFGenpuKzRa?=
 =?utf-8?B?TkgxZmVGWTU1OW1SR295UVY1aXA1YTRDOU9EMmNKMUd3YWVkajl5ckR2eXlu?=
 =?utf-8?B?UHZBeTZjU0hLWXhUSWZCNXY1czZ6ZUcwNmplcGZCc0NDcHNPb2dvZ0Q4Nlpn?=
 =?utf-8?B?N2NzSnU2N042dFF6T3UweG1nV2U0bVg4dTg5aXduanMyRVcySUZobU9HR1cy?=
 =?utf-8?B?cTNzSGY5NVA0WWVJemZaMVFPNHRTMUdSZG53OTkzQ25LcDRPODZrQkI4eVFB?=
 =?utf-8?B?cEhBRklJYjlXcEFwSnI3UVV4cEhCNTRGaW5PSFBoQ2tQOTNlclBnL01aYk9G?=
 =?utf-8?B?L1JMbS9Kc3ZZaG0rSW1kVHc4dXhWdEtPeEFIcFppZnNRWjVieVJaTS9uc2Fv?=
 =?utf-8?Q?RIEOaVOsaJ5r3uIbCpWURvA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ef51c5-3498-4dd5-f26e-08d9fb0c9321
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 22:49:27.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLD4jKM5XegMslJDtqheujxGTQkkzYqtlg9ZRKDw6zy2zz73veyxX8DLmI7VAgBpy8OCN1YF1RZ4TCuIuPYoXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8680
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 15:04, Mike Christie wrote:
> When the workqueue code was created it didn't allow variable args so we
> have been using a temp buffer. Drop that.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 6 ++----
>   include/scsi/libiscsi.h | 1 -
>   2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 059dae8909ee..a75b85f0a189 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2798,11 +2798,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>   	ihost = shost_priv(shost);
>   
>   	if (xmit_can_sleep) {
> -		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
> -			"iscsi_q_%d", shost->host_no);
> -		ihost->workq = alloc_workqueue("%s",
> +		ihost->workq = alloc_workqueue("iscsi_q_%d",
>   			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			1, ihost->workq_name);
> +			1, shost->host_no);
>   		if (!ihost->workq)
>   			goto free_host;
>   	}
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4ee233e5a6ff..2d85810d1929 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -371,7 +371,6 @@ struct iscsi_host {
>   	int			state;
>   
>   	struct workqueue_struct	*workq;
> -	char			workq_name[20];
>   };
>   
>   /*

Reviewed-by: Lee Duncan <lduncan@suse.com>

