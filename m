Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B99C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 15:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbiERPot (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 11:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbiERPoj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 11:44:39 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1726636B
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 08:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1652888658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=224WQ6EKjHigIsikL7hwQ4fle9kXZGXCfHodRHA7PxM=;
        b=ECeomdnr956ZngG/GPdfwerVotvHCYY1mgozqEX8oxWQvjzlI7+HnUtJ+W8VZuQ4Ow+Bsx
        CSUoSA13dW7TNqwcXxbxQ9/+ABREp57acH7LW56OB+7ft+uEV2+RpjGhoP1WwoJ0RyBsC2
        s42eI1Cv2sojbXjPJ7Kfr/RakAbO3iQ=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-10-LROK9JCuO7GG_s688YIf6Q-1; Wed, 18 May 2022 17:44:17 +0200
X-MC-Unique: LROK9JCuO7GG_s688YIf6Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGxcHCofW35bxxGZcSxQLssyKZHHWob9/2mAc29I5U54225dZIWsvUHJmVpwNky/dC6Aww0y6YmnIkfBJ6vq/U3LBHUL4uDy7LUsAMMjH6R9xTzJGGDR2hAHRDJTt+ndMSrWmpORio6EyyTPpvn7tRFaOMwYVokm7QofyFHZDLRNWwTYpQ0PR+HkH90vz5KcCfQSe9uK2jwmSunSnbpgrnXUOP2hgurvfMJP2MfVLO086bffyz5NFUJgN96IGCk15X+eV1vLWaEeuCWlAdHf8OCSwT3DzTwVXzxFQ40/DM5s91EbzWjMOe/Z6ohrnJQgRHbqNlFpFti++m/G8GPEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=224WQ6EKjHigIsikL7hwQ4fle9kXZGXCfHodRHA7PxM=;
 b=Ht7kljdUrj7bltJoHK4RQQvrnT3tPprHduxrgfQasPcIWMDJ6G/KPzAwBZ3op7GcErNBpxBBFIL4KDxr6x0YnSeeuiJGoPzZpL5gVraentnLcWTxE+aEl9NWpPXBhrOcxi9KwvDcYmVibi2f2Tr+glu+N8Nc443w02HeiNOhkI5HXvw+CS/4gvfvOKcY2fO8wz3RhYeRtpzw4xVIPJpfgxPJ+Ca2sKTMrZ3rKgqV48a/nEZ2DArl3lFq0DEDbGvvZEVqoVGAnux3Pv6sB+O+mf+2E/KqXNo6D+2Ilw6yqogkZxM8Mls0OADe8aj22WeUy3Wgr2iGaKgTTXMsBvu8Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by HE1PR0401MB2426.eurprd04.prod.outlook.com (2603:10a6:3:1f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 15:44:16 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 15:44:16 +0000
Message-ID: <44823217-9847-ca75-5e7e-3b1f612399d5@suse.com>
Date:   Wed, 18 May 2022 08:44:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 01/13] scsi: iscsi: Fix HW conn removal use after free
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220517222448.25612-1-michael.christie@oracle.com>
 <20220517222448.25612-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220517222448.25612-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0224.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 026242f3-fd55-4147-61d4-08da38e543b3
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2426:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0401MB2426BAF510A7EC2993DF0CA9DAD19@HE1PR0401MB2426.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkMYkWTvU6djAj9dmo2WLdKhWI2ZlyAZQWNWKcqafabuWGYTSbOTqnCpUeWHLJ24TmcIC/cWq+5V6ZRmzHuRUHxk6b+5puOXJ9SwkzhjZ3PibLOiI6BiedHVpuoSseXJLj+mW2B+T3pP0SXH4UW1IfM+KEZXjmvV2UWU6SOig1iQIGoB3b73FDsPA/1PuSSubQc6zs5JTpewpzRT1SBc+lCDyOwYr42iiyIJg6DBm7hWrNbLIT9Ca37fkJXgjXqg/30wE2UKcjJd5w66CC/CX4PBpskXMqaK1BZ7vuuYwQF+7hxcdyZfsSj5rCjK8pPXeofzrhgKFCpiuLAq6US490uUKdy8d3OCQ59YfaYqsqev4o8cf4+cOJN/+h3qPhdCBUzyNfzhQomjBhq1QSBsDLK1e6UPacOMQDTHbzbDNImkj3orW3mTzGOPFbNHIFLEesrFieysVPLdAt6Z6XREz0trAnJr1Xpf1i4gT3kBTg1ma0ZPEcKvjHC0jGVqouO3FVsvwQTPEmuAKa2tqS+h+DNsld4xQfoLaDyZgISetoAwrrq4wv2DrXfq1kQOdcPCdlJqImM7RaACKC9liH+AOMGp44mQKtklPNWdsEcsAHUg/oBXCYuWIKjlQbVgokByEPbwN7FbqCwK3kQ9xwQabZDXXvjN1u97bNZ25FxjxmbBlvfRFleCH9WdQgV1K7JUxDQ0tx5MGK5B+FvAy92Hea2J3SO1LQb7BSEd60VK+VQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6666004)(316002)(31696002)(36756003)(6506007)(83380400001)(31686004)(8676002)(53546011)(66946007)(66556008)(66476007)(6486002)(508600001)(5660300002)(4744005)(38100700002)(2906002)(6512007)(26005)(2616005)(186003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTM1K2duTHB2eVQyWlhSQnhNcGxZUkVaVnovcFJIdUNsRGhyNmgzV3g3eDRu?=
 =?utf-8?B?bktvMWRRam5INVlibEZPMk9XWThpSXg1Rk1uaDlJYWZINzRyTTRqcnNQZWtK?=
 =?utf-8?B?NW4xSDk1OGhxZDA0OEdISTR3a0tFSG83SytHV05GLzhtZ01JY0ZhK0Q3WENC?=
 =?utf-8?B?M0VZMEErdWFOTVhJMytuMDU4dUJock9pazAyd0pUL0lHOVd1Q0pIcTZtTDk1?=
 =?utf-8?B?VzU2cGFkOGkrWHF4U2pHUkNSK0xqaGloaFErcXVaTjZKcnE5MkRoVnhPeVRi?=
 =?utf-8?B?NUMrTWRmNGJtYUdXblQ2UUNjbE9WMzJscU5IanhVU3NuN3RXa0l5T1FtL0E0?=
 =?utf-8?B?QmUwZkh2cUk3MzVtTitUS3lTTW5CVVBvYWRuK2pvbVhUV0VIb2dVT1N3ZWd5?=
 =?utf-8?B?MGs5S1J3dnRHZ3FlYlFuY2xqYUJCSWgxS0JndkQ1dlJQTnRwOVRIbTZkcXU0?=
 =?utf-8?B?NFVsM3JOOCsvUm1qaHJiRWVxaVBjQmFNQ1ZhT1VzR0pJd0VKNlQ1RzBZWTdZ?=
 =?utf-8?B?MlowbWRyZjlYV0gzN1RDREJSWXd6a1BVRFJ2UVkxbXNvYmRRY1Q0dWdmUk1Q?=
 =?utf-8?B?T0QzcTZod3A2YWdSNS9ySHVBbjlYVnlzY3VFcGxtaHBLLzRBWXhUV1IxOWkv?=
 =?utf-8?B?Vk5aM0tBTnZyVTY0YXhDY1BXSEtmS3ZTYVhTVlp1THRZUUlrbFkwMERBME1v?=
 =?utf-8?B?dzNVYlJaME5Kbms0WkthMWNiSzdQQkF2RDBBd29PSDljZnk2UEc2cWI3UGxI?=
 =?utf-8?B?dnRSVTZTVXBhOTFGOG9rOTBtdnUwSnNjZm1qRGlqVG5SQU5LV3loS2ZIMVoy?=
 =?utf-8?B?d3JsSWdTTEFJRXNIYlliekd3b20wUHFqU0E3TFZYb2ozQ3V5MWNOaURqWm01?=
 =?utf-8?B?d2V0MllUemhOUUh3SHdKY2VpVWswOVkrL3duY3JKTDhBajdkVFd5RS9FRkx5?=
 =?utf-8?B?ZUtNdStYZVJndEw0TWdVRXF5WDB5VzRXcGoxWFRSMjdUVVFHK0VucGoyV2JV?=
 =?utf-8?B?d1NXYzU5MWFpaHoxK3BpaDh0a3hUaFpSZEtVOGpQQmVieU91c1NxZjdFRVF4?=
 =?utf-8?B?TkhyTjNmbmJZRDFTTUFhSzRBeHA1TGhGTCtXM0dnbEtvTnhrMExXY0Z2Q2Ry?=
 =?utf-8?B?RWk5dmIvM3RRMlMvRXY5b2VaMzJMQjhJT2FLRloyUEZvMGZTYUJNNjhSYXpF?=
 =?utf-8?B?ZGtHYmoxS1JGZ3Yrd3FSelAwdUlaK2I5WEdKQ3N1OEw5bUJxYkVqbWhRaUFK?=
 =?utf-8?B?VHFtUmd5TkpJR0hUWGVxRTNsVGNMZWMydEhLN0dvOC9sY04wZkNYSG05WGNT?=
 =?utf-8?B?SnA0dGhNN2t3bmxiUzNUZmJLZHBMZk1QaGdDelk1UUQ5RE9wdTN1dnV2Q2oz?=
 =?utf-8?B?V0xlQWdSd0Z1V3lxU3FWa2pOZ0x3ZHg0SklDcHRwS1lQUjVPTzJWQjh0Z3Vp?=
 =?utf-8?B?cSt0ZzlheTBPY05LVE1uSVZGazgxTGJNeFBXQ2tWUUk4WlFaWHFxS2xPZkRY?=
 =?utf-8?B?dE5ieVFybjA5eGpXamV3SkwwRWRBcFFEU2RFQ2I2cnJESnRMcVRDQ2UrTktZ?=
 =?utf-8?B?VVBZYnZGWER5VkZVeXpmcnZhaVdpWHppTkR5NGY1SG56TWhBWHA2QjMwaFc4?=
 =?utf-8?B?QVp4VEF5S1BIMTFCcGhjR3czRlYwa0dERnFpN2RUK0NHNWIrSFZmZThySEVi?=
 =?utf-8?B?cFduTFVIcVB1NzFZdHk3cXNZOVFmWmJMNkwwVkprSGZlbE5LUVQwWUFXOWxH?=
 =?utf-8?B?UENwRFhnaHcyWXZrd29hdGcvRFFsK3ZNMEpOaC8zTGZhTmRDcTk2emM5VnNH?=
 =?utf-8?B?eXplUDNUWEdRcEw4Y0NEdU5Kdzd2RGtWb3ppTzhOLzB5c01lK2VvbkVBNmtr?=
 =?utf-8?B?Mkl1ME94Q1lIcE1hZXVEenIySkRjNExpNWt3K2E3N1FCTE95WUpFT1ZDZWt6?=
 =?utf-8?B?bTQrcko0RTcrNTROcUNKMXorNWVtN1VjQXE1M3VIVnptaWJiSy9pUXhTbW9V?=
 =?utf-8?B?ZXdPby8vTWJsbysxRWpnQXl4WGxqTjZOVXJYNGdUVkhvRTczT2pzcHp1eXFB?=
 =?utf-8?B?SHk5WHIzQUV3ZS9CKy9hV2lZNzJvZ1Rwa1VUQUZIM096TEdlUDExK1BVY2dU?=
 =?utf-8?B?Q2VQUDVoTGdlVWE2dExpbWxhU0hiaDVyVGJCbzhBaHE3Tlg0YlNJWi9GME5N?=
 =?utf-8?B?QkZXTjVxUXhUTGppeUdOR0tlY2VYd0s5VS9TRzJwbWVGUWgxRzNNMDk0ZEFG?=
 =?utf-8?B?Q2dHL2E2NTNObG8wcEtXcXNXanpXTGNoY3JmNzBMZFhuRkxscVRmWUFUYXQ0?=
 =?utf-8?B?OFFFdVJFbDgzZDZKVzVRSEtsdVhtdEE2bTNnVDAzQkc2ViticGdNdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026242f3-fd55-4147-61d4-08da38e543b3
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:44:16.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c7ChaGMARwrP5MSl31EuOyMCMfHpY66W3IQAggC1Czg0lvarnW1zhmCgC37IofWFmVZQfFpIo4WPIlaMIpCJCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2426
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/22 15:24, Mike Christie wrote:
> If qla4xxx doesn't remove the connection before the session the iscsi
> class tries to remove the connection for it. We were doing a
> iscsi_put_conn in the iter function which is not needed and will result in
> a use after free because iscsi_remove_conn will free the connection.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 2c0dd64159b0..e6084e158cc0 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
>   		return 0;
>   
>   	iscsi_remove_conn(iscsi_dev_to_conn(dev));
> -	iscsi_put_conn(iscsi_dev_to_conn(dev));
> -
>   	return 0;
>   }
>   
Reviewed-by: Lee Duncan <lduncan@suse.com>

