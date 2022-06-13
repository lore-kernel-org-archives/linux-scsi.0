Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2887CCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 18:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343931AbiFMSmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 14:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344447AbiFMSl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 14:41:56 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20067.outbound.protection.outlook.com [40.107.2.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31371E2779
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 08:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff1LuSEPwAtyBx4UZeidpZfHRh2yhd+ZKxI02ej54tDYRXoOxWkEN7Sa/J146Pa8pd1Y1HsIkPAQh3CyVm/2MhLqlweAxt8bbVZ9OqdWZN7zR1cNT1TfF/+4aBfTOgJEfMRSHJ1ScVch4HALy1St0qU29wr4b5dz7+OARnaNQc96z+2WqG1fAo3Aj7iJhI+cUKCqfyYJdEG3mPb3Q2rCV4SbNXqXQG7/1t3wNlfSoF7RKQRH4nO8jaH1nGLWHexso2CpAdJu3E/IjjJYH+eEwVcOkduxMQqT8ZoDPOrOkvWnDUU8g3Fi27jiUzgnkfrvZBXSsOTtvWO+FBaCfJlXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=as+fDSlZudlat9xl3CAKBc9GRQZ/wn8OIYEzyxzpP6k=;
 b=PF72hcP9NA7nFW6+MVC9jAZjqgreP4oNLL79SsbaM1z+iS4152ww8p7QuvmWHiQJeRgiTc0kKaZMxeBPfF6COND3pzHO6sfbU+MvDGRIY4bErkod63nFZnI/V1/LIrwsxSsXgv3mZyVZ23ITINk6iRzpT5EJ7UTTjdevWHgV/hx6d2W+WDLoXxqyPxgp2URgHQj45C2IAjc7YHcQ9FqWVGWdvROvK4eQyZLgesQcuQdzns8YT6aZXhZKWLKZePsvtHzs+ODXz+irnPUHvK86bYaJCe4vQ9O9xGtEkx3X9cuOH104Zbyzd5LX7tUieE4xLPrX4rRKR8MjZzgFerhOQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=as+fDSlZudlat9xl3CAKBc9GRQZ/wn8OIYEzyxzpP6k=;
 b=1dnJCImP91urONv5JIjhEqKYnSq0YSSDCvB1GNEVMWpSi3tHsOxDnR3PtWSTGtcpPquNS7IP9A7IJ2EfHPi+XiJy6RGAobJ4Euzp3v8R4aOtaCN0NHjF31+25NAfTyW5KiDKWq3bfCdDqSndZuZJQY0SUgwVeLXaAmo0yH4t6DV4Mao4CitimUE19nctAta1q99KC9tjhybdDs/rSUXe9XSBDKJomSEPDpA31ygDtt0othFjPtqjGIqMKe1rjWKrAbKIJB5G7hz9CxLChzDI3rE0quD3SthCcZ/LsRcPBi0UDNs4IcXRznAn9wpEhk/6BnWBmoqsTVNcpGQK23CNNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR0402MB3892.eurprd04.prod.outlook.com (2603:10a6:208:11::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Mon, 13 Jun
 2022 15:23:41 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c49a:9069:bf85:6d47]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c49a:9069:bf85:6d47%7]) with mapi id 15.20.5332.019; Mon, 13 Jun 2022
 15:23:41 +0000
Message-ID: <b7bea363-b2e2-dead-8b2d-f70f822a5484@suse.com>
Date:   Mon, 13 Jun 2022 08:23:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] scsi: iscsi: Exclude zero from the endpoint ID range
Content-Language: en-US
To:     Sergey Gorenko <sergeygo@nvidia.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Chris Leech <cleech@redhat.com>
Cc:     linux-scsi@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>
References: <20220613123854.55073-1-sergeygo@nvidia.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220613123854.55073-1-sergeygo@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0365.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::17) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8976d972-9076-4968-7d43-08da4d50b25f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3892:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3892EDAC667C062A1C082532DAAB9@AM0PR0402MB3892.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A062vFNI2VLvG82pz4dzq1zS8ajHIpc+cUgdmIHDY69iIP3Hk4vq5PJZjb92DYvQ4dUzCLojEVdvbi2vSb0nbwSCEXAq2dC3NwT5QM0Ho0eWhCZnfXqrwsySqFxnjKN+a0ATVwQAhNEymb1dCuH5rf/iZCm6bQydYS4ImN2zzN3dXpib2CaqxLl2eE426WOozbgAiOMomdQZg680HqeppsrjNTa3UclmpFLA+H4qG0T/hAgLrRp8xWIC11G8oVVWep0d2GlFA3D61nhrygjcO4xBYP+qTP0gCKhAqycM05X/+AFEsadgqYU3lp96E3yqjCOOylvg0glLQMooxtMd0reUp+/mrJ69lwJJjkM7ALQYZkztMYaEhmWd5qbkROJxsnlwl1xMY0FiWreZagV7meQ256qLmzxbiaZ2Ik8B20Bp1ZsWNGh/o7z2EoSqweOhIIcIBSHdgoIMJPEUyQWvtM7q4ZYRFSoCh2qrfwV0wL7tDDDgxgSoNY9Xq02G9Dml+deNHb9zoYk+90AkI+TBSn9fYV+V5RCLwKcinjXNJ/Fsh3nJ72p1yl4Gj+HxmEM6fE1nVqRpcbxtNroBMgellGc8R8S6sYNgtexcgprG+n4cojj+5P4xjAZZZynqdGXzlSejV673E2chi5qJcIk1BJ1c4jVlQtH+67t9d28aotgHRg66eKp5mXZ5VeKa+is4OxblygFq8UrALyxLETzZTIUkF1ZPFKnrzzx2CK03tbg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(36756003)(4326008)(83380400001)(110136005)(53546011)(2616005)(186003)(31686004)(6512007)(508600001)(5660300002)(2906002)(66476007)(66556008)(66946007)(6666004)(6506007)(86362001)(38100700002)(8676002)(26005)(8936002)(31696002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blJCRUsrT2lIcXJFTU1oc0dVTWJKVDJ5RGY1c2lJRVRLMWlaclB3K21QNmt2?=
 =?utf-8?B?SHUwcDkzZUV5OTI4ZkZFMTkra0xueVZkcFZFM0M5RWJsRENyRmJWRGhreDky?=
 =?utf-8?B?bnRhYlU3TkZLNWJvVFBnbDlzdGNFWThnYjhKcmpZQldzL25mSGUyZWhKRlM2?=
 =?utf-8?B?cldJUHRHUkRjL0NCTzJ6d3B5cytaenBaMW1BSE0rcTh5V3I3cmtwRHlhRVpO?=
 =?utf-8?B?NlhsQVhkNnZ1bjlMZ0NDNUdqMi9pdUJValZXWjFVWDNWNUU2N3NKQXZWbmJx?=
 =?utf-8?B?S2pHOEVmbTNEZ2NobVZneDdjamFLUndGeVVCbTdnbXFvZTZHQXMweDU1UHFh?=
 =?utf-8?B?cmVwc1pzbldKV0N4SkZheHorcE5XY2FLUnBCZGNVd2Y3UzJEYThqOUdjdDRz?=
 =?utf-8?B?Y1B5Wk1UcDhZaHY0b2FaRThMWmphQ2hXVUxIUm11Z3RZQjI5YS9YLzVtZTd0?=
 =?utf-8?B?MEZsZDgwZVRpR3hNdjJpY1ZDYXlRVHdSSFVhMjd6UWxhSDhFZWdMKzBaQUFK?=
 =?utf-8?B?SW9WeFRQRnBaNnk4clE5TWhuQlB3QkhyNUFvWjRNaFAzVTJTZFhOZVI1dm9v?=
 =?utf-8?B?dFVQLytHelV3N2RZOUY0QTdmc3VtV3IxOXMycnBmVUhvbVRtU0c0a2hKY0Z0?=
 =?utf-8?B?Sm9INVJLQ1JuMy8zOHl6eFdnbzdnM1Y3YndsT1F6NXVXL2hzZjNQRUVvY0RH?=
 =?utf-8?B?OGhLM3ZiN1ZwbDNSdHlsSVViZzUxYllCMXhCdytCNjZ3VnFEMlRlRit4d0JR?=
 =?utf-8?B?K2RpZEFkeElVRWt6Y1pMZHZhQmFHci80YVJDdG1PczhvdWNLdDdTL3lLazhq?=
 =?utf-8?B?dTFmV0YweVJudE42Tlc1WkRyV3JZdjBKSFYvWm9rUzY3RnNkd1Zlc3p1UWFn?=
 =?utf-8?B?VElVQ0xjOWQrU2t1dk11RnZjZmpZRi9RdGp4TUJnMGIwNG1PcDVwd0doamRi?=
 =?utf-8?B?VDNqOWZPcjlaTlo5dENtSFNaN0dySnFORjlMeFZwcm5LNHZIZEwrd09NU3NC?=
 =?utf-8?B?dVFCUzlUZVRuNkc4OTdyMHJjbXlpVzhETWw3dUcyOVc3RksxdG95UkNNMDlQ?=
 =?utf-8?B?eVpDWEM3MHJ5QUFxbmg0UlBiWFRpQnhLczBzcGtGdktPQmhwckMxdy9ZL3Nr?=
 =?utf-8?B?WlI1d0NQM3VSSTIveHZlQkVqUWU3eWRHSHpSN3Q2OGRlVEMvUDB0MkJET2h6?=
 =?utf-8?B?aDFnbFdJODRuSXNkZEh1em5ITk42ZVhFcHBKY0tKR3lONUhUaDhlU1pQRjZY?=
 =?utf-8?B?K1d1M01uQ1Jxc2RGSEZBNEFySXZrS1FRTStjTlg0dnZqSGgwRDJ5S0hvSW1u?=
 =?utf-8?B?QTZ1VENFNEpuMmp5OW5SUzQxZHBIcTlwMURlTUdkeTRFQ1g2RE5iRUd1aldG?=
 =?utf-8?B?ell0MkZVY0pVR3BkUW1rQ3NYNWFNOW52b25KUi8xYXM3RjJ4U01zdFBKbHZi?=
 =?utf-8?B?L3laWWF6U3hIcTduay9uaS9UaFozMXdmTlEzMjJ3YzBRSEhzeGZlOW50NEJ2?=
 =?utf-8?B?T0IvODZ6Rk5iWEN4aWRzOEJlakhpZ3NwV3pjRTYvcStHb0d3MWxkYXc2WGV2?=
 =?utf-8?B?NS9pbld2OGVndk9jY0sxU0FOZUlYMXdTemprd2FiK2J6L0c5ZmlpZWlKdE1H?=
 =?utf-8?B?amI5ajZPUFlKYkNGTDZaS2ZEeTRyc3NiaDZ4bXRPME1YU0VuQ1I0blh0bEVn?=
 =?utf-8?B?SVZJQ1JKYjZxNG9uRmtoSkFTSlZqdWVvb3ljaXA4Q1NRUC9kc21rL0NWOW1j?=
 =?utf-8?B?Rk5ISnRtNnA3b2c3ZkJmRmJ1WGl6bUI5TXpld0R6Wmkvd0E2dklZS0l5cmRk?=
 =?utf-8?B?REhnTEhEU01qblppc3JIazR6dzVBdWRJQy9ieG1FWDM1R1pDQUNQTUw4d0Nk?=
 =?utf-8?B?UVVGclN4UnFzUGxsOHgrSG5qZ0FIc2wvWnA1K1BvQk8rRzRuVXI4c25JUStw?=
 =?utf-8?B?RVUrM3dhb1F3T2Z0enVPZ0p6Q2tDbUdTaE93Yng5WVJBcUJ1UUQ5dXRESlZV?=
 =?utf-8?B?ZUFBME95MU9mS2s3aXN1c3pwNnFXdDV0WkpjN3dIdHV2QjlSby80T2NaWndG?=
 =?utf-8?B?UzA4dXkxMlh1WTliNmovN2ZRY3c0ZlNPMGVoODhqQjBoZmwwUG9Kelc5Qkpv?=
 =?utf-8?B?UUw1SkgzK0taNFF1Q0RmNW5La1dqbXZlUDJYYURQV2JhZGl6c1h0WjE3SWZG?=
 =?utf-8?B?b2FlNXNvbkV0QmJONkFrU0R3bWthOVdTd0RrcTNTaG10N2svY1pPTE1OUmN4?=
 =?utf-8?B?UlQzd0w1QnFKN2dMWXNjZjhTdW45aWJQdWhNMVNoZVBXQjlBQkFWMHlOSERp?=
 =?utf-8?B?MUhQKy9pdEowR1pDMSttRW1vVTRkc1JzOWYwWUtFT2MyMi9GZDIvQT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8976d972-9076-4968-7d43-08da4d50b25f
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 15:23:41.3233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA953ynH1fwZlzWtqSLnGcFUJP2sdTfhr9+4Jn4mPrBJKhGoCr7TVRXHlpGTCGCzyghLXoa4J0o1Sk13ZzoF5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3892
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/22 05:38, Sergey Gorenko wrote:
> The kernel returns an endpoint ID as r.ep_connect_ret.handle in the
> iscsi_uevent. The iscsid validates a received endpoint ID and treats
> zero as an error. The commit referenced in the fixes line changed the
> endpoint ID range, and zero is always assigned to the first endpoint ID.
> So, the first attempt to create a new iSER connection always fails.
> 
> Fixes: 3c6ae371b8a1 ("scsi: iscsi: Release endpoint ID when its freed")
> Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Sergey Gorenko <sergeygo@nvidia.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 2c0dd64159b0..5d21f07456c6 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -212,7 +212,12 @@ iscsi_create_endpoint(int dd_size)
>   		return NULL;
>   
>   	mutex_lock(&iscsi_ep_idr_mutex);
> -	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
> +
> +	/*
> +	 * First endpoint id should be 1 to comply with user space
> +	 * applications (iscsid).
> +	 */
> +	id = idr_alloc(&iscsi_ep_idr, ep, 1, -1, GFP_NOIO);
>   	if (id < 0) {
>   		mutex_unlock(&iscsi_ep_idr_mutex);
>   		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",

Reviewed-by: Lee Duncan <lduncan@suse.com>
