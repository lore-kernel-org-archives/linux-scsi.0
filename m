Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED07C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 18:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243046AbiEWSm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 14:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244702AbiEWSlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 14:41:51 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6A71912C5
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 11:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653330120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vlgqOg3+9AiYTKfkuffi91ej26ydsuokOGvKDFtxOw=;
        b=HFTd3EC8f6uYW+50Z4zN2f24qLd+QDmyMVjkeRSi6CbPKBqnLlUodq1GpAeqJWoluuCywA
        xHHZw7gxzpJ71NJrx2vMSgLIk+dE9xZYqZDMFan2sE+7GsFSY7bZTf51UvS+Y1EJQR4mFt
        Uk6nCDvmWr7IiuA5YzBfLUnwKgqLxL8=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2110.outbound.protection.outlook.com [104.47.17.110]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-40-fhg2aaU3Mi-_tpM_R3xNFA-1; Mon, 23 May 2022 20:18:39 +0200
X-MC-Unique: fhg2aaU3Mi-_tpM_R3xNFA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRMhbrpMX/BRb6NgssMTGW/mKYqrMNZzY22N0DCTjkGuY0G6xeWwyf8bOsqsQ1+PgtnFUgjP857r/AGprnxcmLDSh55ITow6U0i80kNCjhTVLt3VKXg57H1QLqLDtKDYR4K5fN2cblEoeUyRuRMbq9wQjnpiCSEw8S+QguQjDOFoVrswBlUf0iQyCiWUse+vL7DaHVAjXM5mvCx73m7aKgNZCgNPIiewqTwXNc3Mh8lb1u64XLkfGeePAhq1jBhJrHMcB1W2K14JuqsG1TXL0R3LbiVnstT+xeF3cHYln9vKlC/XqQqtdtM0JwG2Y5/kpSutlHri3XpKHV7MQsQV5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vlgqOg3+9AiYTKfkuffi91ej26ydsuokOGvKDFtxOw=;
 b=klKIYLcm7lI1DWogvqCqXnmLtDLGILvSYhBQnBVWAlXBnu3ajjy19Rr4y5J42/tdxTcQlEvRIoKLTQwZz4nN09gq9s4vOq+b/E0jTlZtiyzBGTGxqNVPb2U676RB21/KKfNCI0/18e8VxJ8s+wZedvTR4HDK5k60l5jF9uLzgy459TRtydSOzFYZ7eayNEtEjRPgz60S2rEi8g0MVJTWpStU8nmBmZMNE0aUFTz2c+L7e1mMQulDvI7uWxg1GYxo2NOn4RIpeVSkuRIcCFGK2oQPj/6mN6BwsLBou0tKDJibHPYagbR5Qd4G1+WZsnjTWhDScWj3nCf5VVRGZXR1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS1PR04MB9630.eurprd04.prod.outlook.com (2603:10a6:20b:475::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 23 May
 2022 18:18:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 18:18:38 +0000
Message-ID: <4140e315-81b6-3a52-0bd8-a649638f9ff5@suse.com>
Date:   Mon, 23 May 2022 11:18:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 1/3] scsi: target: iscsi: Add upcast helpers
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20220523095905.26070-1-d.bogdanov@yadro.com>
 <20220523095905.26070-2-d.bogdanov@yadro.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220523095905.26070-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:20b:451::31) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd6ae01a-df1c-4fcf-9fbc-08da3ce8a84a
X-MS-TrafficTypeDiagnostic: AS1PR04MB9630:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB96300E4D7D732B7D59746858DAD49@AS1PR04MB9630.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvpzhWVP6pzhN3018TxIAR2+km6WDvqQwasIXCaDYHhXbCX1NWPBmgL2NRDBNYiYDrvvtrV/Nshjbpa/i54s25CZ3CVsEEdOSYP7FkzuTKn3hsE1L3vZ3DJsW+TFwZCRyV6XfmGZjoKgBPSzDT8OmsjlSlcV4cbq/gHrSjR6RsAYzg7956jVguorRwNAjSiQh6UYEUlldFeNfFgRXVzTjzo/3VNW3WLQrQqkqZYFg6jNOpKvNIVJjwYA9YasRdoNHQeP7F5iMqh3G7IygAr4FF4cvRfMtssECct14IQOcsI/xNqTpFfqJMpCLWqVcJxVuMULiiqMrNoKiThqhpRzZVf2XrZ/4ebSJad3bg/dcjtNsa2BbQN0dr3Gv+g8yI9Oz4UVGLb+VBOZBJaDpUlOFYEceLa9f3KXGisUb9CeKeddveKoZpHIS9yAXKmjKzojDhcKcYdhc2chkt0XB+/QYt9NQWnlm0WTf01JNLzrCA7KZDxZG5LblYyYZS+VW9LDNG/XqyKQADo+LDr5G0ppDrGFOPuOg8uexaDW/4FWzbcSPoZKg3vJmKB89x8LDU8LVwuxeGIkHGH/XDQkW0yCuL+Y8/SRKM26k9p0/IMZvoiH5+4jw4bPDmWGpDFdcW85CHL0rflVSe0rzHyVvkIaTnh0g2IRNP1kfKlZ0CbSaHFb7N2sY2OKcfC4Lqs+Mfev7CDpfcAQz//hX24jXwyFUPnEbUZGNFRKVvWGFznhRcY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(30864003)(6486002)(38100700002)(5660300002)(508600001)(4326008)(66946007)(66556008)(186003)(2906002)(31686004)(6506007)(53546011)(8936002)(8676002)(26005)(6512007)(6666004)(66476007)(83380400001)(110136005)(54906003)(86362001)(2616005)(31696002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3VSZS9hbEh2OXM5citObE5UbHEwdkh5d2RMbzZCT3NsUG5EUEl5U0dRR0Y2?=
 =?utf-8?B?T2xpVi8ybk9nNFNrSVdsVWtkWENaakd6TUpyVEFDTjdxcVpsSzhXMGFmaGZW?=
 =?utf-8?B?K3REbHA3VWFROWJmZkFZbkxJM2d5VFZxY0tDV3pHZmRIamxaL0FQMXAxSlV3?=
 =?utf-8?B?YzJaS3ZpUElGYlRWY2JHQitDK1BFR0tyZkJnTit2ZEFGbVRtQmV2KzlUN2My?=
 =?utf-8?B?OHEwQzNNb20vMElwUkRGNk5PYWcvMVVRamNQSDF1WE9wT1pTbEhTNnR6NlpC?=
 =?utf-8?B?dVhhcnZLQUlFR3liRmcyd053YWZPNjR1RkJRVnM5Tjh3dUNmbm1lbVBsRWVS?=
 =?utf-8?B?ZnBDYWQ1bkplQnFuOHdjUXcwTGdkT3Z6YjVQRXFNLy9POUVHN0NTYjdHeC9k?=
 =?utf-8?B?V21yamN6aTVPVWZSdWhjeFJtWkxxbzlDenRGajhyK3JUSEVGZDRxeUcraGVC?=
 =?utf-8?B?QXVrK3RFdGh4L3g2VkQzcnBsUmxiUUE1bWZHRkhySWtVbXVCT0RhR2xoUjJZ?=
 =?utf-8?B?S2QxSTNzcGdLQUZkRlhKYnFDRURZa0p0MkRQVThrbkQ3eUt3b0UyU1RHem5k?=
 =?utf-8?B?Qk1wNDRjWmhtbnJTKzlKQnltUVVHeldQUno4cjNtaXFTZUo4ZWRPQzE0R1Ux?=
 =?utf-8?B?NjZBTE51a1F2WFlvTVR2KzMzckRUdng0LzJZekZRaGRSYWtlS2NoNThsSmlP?=
 =?utf-8?B?bmdIZkJKS1dGclQvNEM5WW9hamYrZzJuMEhEYm8wcG4yeFhXZWQremd4aUtO?=
 =?utf-8?B?c0hkNk5mTnQ5QWlFZ2VEZXg0UDVkTi9xNWkwa1Rzb0p4eGtqdnpGbDlqZkwy?=
 =?utf-8?B?WjdEdEdYUmtqcXBOZS9DRGNsWk1kSGppSnN0NGVUS1JJcEZmWlgvaXF2OWta?=
 =?utf-8?B?UkREU3Awa3V5UldhNy9FZEYwR3lOS3laUUx2UmF5M0xFMW5BNHFQRDNkdy9m?=
 =?utf-8?B?SjlnZ01VT2FPdmlteVE1aHc5Q25pZ3QyeDVqT1F3T2dTb3JHb0lkTlRNQWJj?=
 =?utf-8?B?R3FtZldGTno2RDB4aGFlMXVXcnlrRUQ3VHZ1QTg2dlVPLzllUUZjcVBYWDNV?=
 =?utf-8?B?TDREM20vakJEdHpYMjBHN3ZZQ1ora0EwaFplK1c1NW1hcHJxTWczNFB3N2gz?=
 =?utf-8?B?ZFM5a3BQYXVEalVYcSs0alpqZU9PMFZKa2xHNkEvY05zNjBhaHdkSEJ2VUxj?=
 =?utf-8?B?eUFmZTVXNXpFVmNCWUl5cnNMY0dMbGJJWWh3UGZMcHI0c1JvSFBSdUxDd2NQ?=
 =?utf-8?B?T2o0LzluUmowQ0wvbXlZTG4vQjVXYVhQUGRNMHArQlpUUkJ0UkdWOStvQkdF?=
 =?utf-8?B?QkhlMWVSV1lqZi8zNUlSYkVoRy9CSmxsSXArcU9vWDhFL1lTMW5EcG9jTEtK?=
 =?utf-8?B?OTZ5UFVNV0FTYkJ5bG9ISEh4NEdwQ2NlZFRsVExIUnEzZkhBcHYyVGhOK2lV?=
 =?utf-8?B?UGhDczFHM1hoNDlGYzIrQm5xY3hGTFdnZGRxTlVZZHdMOFpNRHZnRE5xampE?=
 =?utf-8?B?QXREb1B0RCsrTDBKMFlJaG9sODF2bnJmSXB5MGVqaEI2aCtDN01XRXdMdjh0?=
 =?utf-8?B?Vk1McU1iM0RIYVV0T25qT0k2MEU2eFNTREtoNHBQUVdDenpUSklaYklBV3NL?=
 =?utf-8?B?UEx2Z3dqWXJvRStHYmQvRTBZK3FuU3lXeFdVRUpOUTljMzRhMmwyaTFHOW5v?=
 =?utf-8?B?dE04QUFocVNvUnhRVVIxQjFZc3RvUFF5NHZYclh4ZTFIY2JBejkyV0ViYlVJ?=
 =?utf-8?B?L3YvZU9pVUt1QWJPdE10cTNDNTgwRTkrWi9XM013VlY1T1luaFhCN28yd09K?=
 =?utf-8?B?UkNVT2RmYnFUdzBTZTJtUlI4Q3FlYTZMMkF2cVBVR284bUcza2V4T0xIR1BN?=
 =?utf-8?B?NXMwVnF1d2VkbXdsUVFUY0lWeEhrSXNYUlJIK0pJY3VCQ0ZFc29BY1hQNTF5?=
 =?utf-8?B?QVVFbzNtUlg1YnppUzh5WkNsMmdERi9uOGVnK1FETk5COVYxUE55Y3NnbVo0?=
 =?utf-8?B?SUdkd21GVEEwcmR0U1QrRU9UclNNL2lIMzJ5bWFKK2RDUWJkNkkvTnBtYWx1?=
 =?utf-8?B?K0pYUzFxRmsxcnJVUFBobTRBQ294a2tYNFdXMnBSQmFOcENRQ0wrTy9NRHhL?=
 =?utf-8?B?NithWHlXRG1OcEdVQlRTYnU5dUFPUzRrMkNWbGRVZXp2Z1BZQ0IvbUZ2NzFX?=
 =?utf-8?B?SG41UGJyRWFOdTNrMG1LcEFYdjB4OEpLNnJsNGlvb0s0eEFlTFBoNTBVK2do?=
 =?utf-8?B?Y0R5QTVVNGoxMlhta1RYK2pDTXI5QWFhTUZNcXZNZTc2K09aZG5iK08vTEww?=
 =?utf-8?B?bXhCY2svOFM0L2Y0aEdEVUF5MXhaQSswdnNNaUtnTVhueXJrT2lZZz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6ae01a-df1c-4fcf-9fbc-08da3ce8a84a
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 18:18:38.1607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUC3BBFkvs9VfujQoEKddbdAsw39yw9l7zMrgfNxZe3GX/CCR9+3ylnr6trwonD82TMrQeBbPBZOb8HgjBP/GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9630
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/22 02:59, Dmitry Bogdanov wrote:
> iscsi target is cluttered with open-coded container_of conversions from
> se_nacl to iscsi_node_acl. The code could be cleaned by introducing a
> helper - to_iscsi_nacl() (similar to other helpers in target core).
> 
> While at it, make another iscsi conversion helper consistent
> and rename iscsi_tpg() helper to to_iscsi_tpg().
> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/target/iscsi/iscsi_target_configfs.c | 82 +++++++-------------
>   drivers/target/iscsi/iscsi_target_nego.c     | 14 ++--
>   drivers/target/iscsi/iscsi_target_tpg.c      |  3 +-
>   include/target/iscsi/iscsi_target_core.h     | 12 +++
>   4 files changed, 49 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index 72f5ff959636..1096201f1599 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -210,7 +210,7 @@ static struct se_tpg_np *lio_target_call_addnptotpg(
>   		return ERR_PTR(ret);
>   	}
>   
> -	tpg = container_of(se_tpg, struct iscsi_portal_group, tpg_se_tpg);
> +	tpg = to_iscsi_tpg(se_tpg);
>   	ret = iscsit_get_tpg(tpg);
>   	if (ret < 0)
>   		return ERR_PTR(-EINVAL);
> @@ -281,9 +281,7 @@ static ssize_t iscsi_nacl_attrib_##name##_show(struct config_item *item,\
>   		char *page)						\
>   {									\
>   	struct se_node_acl *se_nacl = attrib_to_nacl(item);		\
> -	struct iscsi_node_acl *nacl = container_of(se_nacl, struct iscsi_node_acl, \
> -					se_node_acl);			\
> -									\
> +	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);		\
>   	return sprintf(page, "%u\n", nacl->node_attrib.name);		\
>   }									\
>   									\
> @@ -291,8 +289,7 @@ static ssize_t iscsi_nacl_attrib_##name##_store(struct config_item *item,\
>   		const char *page, size_t count)				\
>   {									\
>   	struct se_node_acl *se_nacl = attrib_to_nacl(item);		\
> -	struct iscsi_node_acl *nacl = container_of(se_nacl, struct iscsi_node_acl, \
> -					se_node_acl);			\
> +	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);		\
>   	u32 val;							\
>   	int ret;							\
>   									\
> @@ -377,15 +374,14 @@ static ssize_t iscsi_nacl_auth_##name##_show(struct config_item *item,	\
>   		char *page)						\
>   {									\
>   	struct se_node_acl *nacl = auth_to_nacl(item);			\
> -	return __iscsi_nacl_auth_##name##_show(container_of(nacl,	\
> -			struct iscsi_node_acl, se_node_acl), page);	\
> +	return __iscsi_nacl_auth_##name##_show(to_iscsi_nacl(nacl), page);	\
>   }									\
>   static ssize_t iscsi_nacl_auth_##name##_store(struct config_item *item,	\
>   		const char *page, size_t count)				\
>   {									\
>   	struct se_node_acl *nacl = auth_to_nacl(item);			\
> -	return __iscsi_nacl_auth_##name##_store(container_of(nacl,	\
> -			struct iscsi_node_acl, se_node_acl), page, count); \
> +	return __iscsi_nacl_auth_##name##_store(to_iscsi_nacl(nacl),	\
> +						page, count); \
>   }									\
>   									\
>   CONFIGFS_ATTR(iscsi_nacl_auth_, name)
> @@ -417,8 +413,7 @@ static ssize_t iscsi_nacl_auth_##name##_show(struct config_item *item,	\
>   		char *page)						\
>   {									\
>   	struct se_node_acl *nacl = auth_to_nacl(item);			\
> -	return __iscsi_nacl_auth_##name##_show(container_of(nacl,	\
> -			struct iscsi_node_acl, se_node_acl), page);	\
> +	return __iscsi_nacl_auth_##name##_show(to_iscsi_nacl(nacl), page);	\
>   }									\
>   									\
>   CONFIGFS_ATTR_RO(iscsi_nacl_auth_, name)
> @@ -623,8 +618,7 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
>   {
>   	struct se_node_acl *se_nacl = acl_to_nacl(item);
>   	struct se_portal_group *se_tpg = se_nacl->se_tpg;
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,
> -			struct iscsi_portal_group, tpg_se_tpg);
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);
>   	struct config_item *acl_ci, *tpg_ci, *wwn_ci;
>   	u32 cmdsn_depth = 0;
>   	int ret;
> @@ -700,8 +694,7 @@ static struct configfs_attribute *lio_target_initiator_attrs[] = {
>   static int lio_target_init_nodeacl(struct se_node_acl *se_nacl,
>   		const char *name)
>   {
> -	struct iscsi_node_acl *acl =
> -		container_of(se_nacl, struct iscsi_node_acl, se_node_acl);
> +	struct iscsi_node_acl *acl = to_iscsi_nacl(se_nacl);
>   
>   	config_group_init_type_name(&acl->node_stat_grps.iscsi_sess_stats_group,
>   			"iscsi_sess_stats", &iscsi_stat_sess_cit);
> @@ -720,8 +713,7 @@ static ssize_t iscsi_tpg_attrib_##name##_show(struct config_item *item,	\
>   		char *page)						\
>   {									\
>   	struct se_portal_group *se_tpg = attrib_to_tpg(item);		\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,		\
> -			struct iscsi_portal_group, tpg_se_tpg);	\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);		\
>   	ssize_t rb;							\
>   									\
>   	if (iscsit_get_tpg(tpg) < 0)					\
> @@ -736,8 +728,7 @@ static ssize_t iscsi_tpg_attrib_##name##_store(struct config_item *item,\
>   		const char *page, size_t count)				\
>   {									\
>   	struct se_portal_group *se_tpg = attrib_to_tpg(item);		\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,		\
> -			struct iscsi_portal_group, tpg_se_tpg);	\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);		\
>   	u32 val;							\
>   	int ret;							\
>   									\
> @@ -800,8 +791,7 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
>   static ssize_t __iscsi_##prefix##_##name##_show(struct se_portal_group *se_tpg,	\
>   		char *page)							\
>   {										\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,			\
> -				struct iscsi_portal_group, tpg_se_tpg);		\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);			\
>   	struct iscsi_node_auth *auth = &tpg->tpg_demo_auth;			\
>   										\
>   	if (!capable(CAP_SYS_ADMIN))						\
> @@ -813,8 +803,7 @@ static ssize_t __iscsi_##prefix##_##name##_show(struct se_portal_group *se_tpg,
>   static ssize_t __iscsi_##prefix##_##name##_store(struct se_portal_group *se_tpg,\
>   		const char *page, size_t count)					\
>   {										\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,			\
> -				struct iscsi_portal_group, tpg_se_tpg);		\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);			\
>   	struct iscsi_node_auth *auth = &tpg->tpg_demo_auth;			\
>   										\
>   	if (!capable(CAP_SYS_ADMIN))						\
> @@ -861,8 +850,7 @@ DEF_TPG_AUTH_STR(password_mutual, NAF_PASSWORD_IN_SET);
>   static ssize_t __iscsi_##prefix##_##name##_show(struct se_portal_group *se_tpg,	\
>   		char *page)								\
>   {										\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,			\
> -				struct iscsi_portal_group, tpg_se_tpg);		\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);			\
>   	struct iscsi_node_auth *auth = &tpg->tpg_demo_auth;			\
>   										\
>   	if (!capable(CAP_SYS_ADMIN))						\
> @@ -900,8 +888,7 @@ static ssize_t iscsi_tpg_param_##name##_show(struct config_item *item,	\
>   		char *page)						\
>   {									\
>   	struct se_portal_group *se_tpg = param_to_tpg(item);		\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,		\
> -			struct iscsi_portal_group, tpg_se_tpg);		\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);		\
>   	struct iscsi_param *param;					\
>   	ssize_t rb;							\
>   									\
> @@ -923,8 +910,7 @@ static ssize_t iscsi_tpg_param_##name##_store(struct config_item *item, \
>   		const char *page, size_t count)				\
>   {									\
>   	struct se_portal_group *se_tpg = param_to_tpg(item);		\
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,		\
> -			struct iscsi_portal_group, tpg_se_tpg);		\
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);		\
>   	char *buf;							\
>   	int ret, len;							\
>   									\
> @@ -1073,8 +1059,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(struct se_wwn *wwn,
>   static int lio_target_tiqn_enabletpg(struct se_portal_group *se_tpg,
>   				     bool enable)
>   {
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,
> -			struct iscsi_portal_group, tpg_se_tpg);
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);
>   	int ret;
>   
>   	ret = iscsit_get_tpg(tpg);
> @@ -1106,7 +1091,7 @@ static void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
>   	struct iscsi_portal_group *tpg;
>   	struct iscsi_tiqn *tiqn;
>   
> -	tpg = container_of(se_tpg, struct iscsi_portal_group, tpg_se_tpg);
> +	tpg = to_iscsi_tpg(se_tpg);
>   	tiqn = tpg->tpg_tiqn;
>   	/*
>   	 * iscsit_tpg_del_portal_group() assumes force=1
> @@ -1412,46 +1397,41 @@ static void lio_aborted_task(struct se_cmd *se_cmd)
>   	cmd->conn->conn_transport->iscsit_aborted_task(cmd->conn, cmd);
>   }
>   
> -static inline struct iscsi_portal_group *iscsi_tpg(struct se_portal_group *se_tpg)
> -{
> -	return container_of(se_tpg, struct iscsi_portal_group, tpg_se_tpg);
> -}
> -
>   static char *lio_tpg_get_endpoint_wwn(struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_tiqn->tiqn;
> +	return to_iscsi_tpg(se_tpg)->tpg_tiqn->tiqn;
>   }
>   
>   static u16 lio_tpg_get_tag(struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpgt;
> +	return to_iscsi_tpg(se_tpg)->tpgt;
>   }
>   
>   static u32 lio_tpg_get_default_depth(struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_attrib.default_cmdsn_depth;
> +	return to_iscsi_tpg(se_tpg)->tpg_attrib.default_cmdsn_depth;
>   }
>   
>   static int lio_tpg_check_demo_mode(struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_attrib.generate_node_acls;
> +	return to_iscsi_tpg(se_tpg)->tpg_attrib.generate_node_acls;
>   }
>   
>   static int lio_tpg_check_demo_mode_cache(struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_attrib.cache_dynamic_acls;
> +	return to_iscsi_tpg(se_tpg)->tpg_attrib.cache_dynamic_acls;
>   }
>   
>   static int lio_tpg_check_demo_mode_write_protect(
>   	struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_attrib.demo_mode_write_protect;
> +	return to_iscsi_tpg(se_tpg)->tpg_attrib.demo_mode_write_protect;
>   }
>   
>   static int lio_tpg_check_prod_mode_write_protect(
>   	struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_attrib.prod_mode_write_protect;
> +	return to_iscsi_tpg(se_tpg)->tpg_attrib.prod_mode_write_protect;
>   }
>   
>   static int lio_tpg_check_prot_fabric_only(
> @@ -1461,9 +1441,9 @@ static int lio_tpg_check_prot_fabric_only(
>   	 * Only report fabric_prot_type if t10_pi has also been enabled
>   	 * for incoming ib_isert sessions.
>   	 */
> -	if (!iscsi_tpg(se_tpg)->tpg_attrib.t10_pi)
> +	if (!to_iscsi_tpg(se_tpg)->tpg_attrib.t10_pi)
>   		return 0;
> -	return iscsi_tpg(se_tpg)->tpg_attrib.fabric_prot_type;
> +	return to_iscsi_tpg(se_tpg)->tpg_attrib.fabric_prot_type;
>   }
>   
>   /*
> @@ -1500,16 +1480,14 @@ static void lio_tpg_close_session(struct se_session *se_sess)
>   
>   static u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
>   {
> -	return iscsi_tpg(se_tpg)->tpg_tiqn->tiqn_index;
> +	return to_iscsi_tpg(se_tpg)->tpg_tiqn->tiqn_index;
>   }
>   
>   static void lio_set_default_node_attributes(struct se_node_acl *se_acl)
>   {
> -	struct iscsi_node_acl *acl = container_of(se_acl, struct iscsi_node_acl,
> -				se_node_acl);
> +	struct iscsi_node_acl *acl = to_iscsi_nacl(se_acl);
>   	struct se_portal_group *se_tpg = se_acl->se_tpg;
> -	struct iscsi_portal_group *tpg = container_of(se_tpg,
> -				struct iscsi_portal_group, tpg_se_tpg);
> +	struct iscsi_portal_group *tpg = to_iscsi_tpg(se_tpg);
>   
>   	acl->node_attrib.nacl = acl;
>   	iscsit_set_default_node_attribues(acl, tpg);
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index b34ac9ecac31..d853bacf1cfc 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -104,8 +104,8 @@ static u32 iscsi_handle_authentication(
>   {
>   	struct iscsit_session *sess = conn->sess;
>   	struct iscsi_node_auth *auth;
> -	struct iscsi_node_acl *iscsi_nacl;
> -	struct iscsi_portal_group *iscsi_tpg;
> +	struct iscsi_node_acl *nacl;
> +	struct iscsi_portal_group *tpg;
>   	struct se_node_acl *se_nacl;
>   
>   	if (!sess->sess_ops->SessionType) {
> @@ -120,15 +120,13 @@ static u32 iscsi_handle_authentication(
>   		}
>   
>   		if (se_nacl->dynamic_node_acl) {
> -			iscsi_tpg = container_of(se_nacl->se_tpg,
> -					struct iscsi_portal_group, tpg_se_tpg);
> +			tpg = to_iscsi_tpg(se_nacl->se_tpg);
>   
> -			auth = &iscsi_tpg->tpg_demo_auth;
> +			auth = &tpg->tpg_demo_auth;
>   		} else {
> -			iscsi_nacl = container_of(se_nacl, struct iscsi_node_acl,
> -						  se_node_acl);
> +			nacl = to_iscsi_nacl(se_nacl);
>   
> -			auth = &iscsi_nacl->node_auth;
> +			auth = &nacl->node_auth;
>   		}
>   	} else {
>   		/*
> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
> index 4339ee517434..3cac1aafef68 100644
> --- a/drivers/target/iscsi/iscsi_target_tpg.c
> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> @@ -394,8 +394,7 @@ struct iscsi_node_attrib *iscsit_tpg_get_node_attrib(
>   {
>   	struct se_session *se_sess = sess->se_sess;
>   	struct se_node_acl *se_nacl = se_sess->se_node_acl;
> -	struct iscsi_node_acl *acl = container_of(se_nacl, struct iscsi_node_acl,
> -					se_node_acl);
> +	struct iscsi_node_acl *acl = to_iscsi_nacl(se_nacl);
>   
>   	return &acl->node_attrib;
>   }
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index 8e68ace428d9..4dd62947f8db 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -758,6 +758,12 @@ struct iscsi_node_acl {
>   	struct iscsi_node_stat_grps node_stat_grps;
>   };
>   
> +static inline struct iscsi_node_acl *
> +to_iscsi_nacl(struct se_node_acl *se_nacl)
> +{
> +	return container_of(se_nacl, struct iscsi_node_acl, se_node_acl);
> +}
> +
>   struct iscsi_tpg_attrib {
>   	u32			authentication;
>   	u32			login_timeout;
> @@ -839,6 +845,12 @@ struct iscsi_portal_group {
>   	struct list_head	tpg_list;
>   } ____cacheline_aligned;
>   
> +static inline struct iscsi_portal_group *
> +to_iscsi_tpg(struct se_portal_group *se_tpg)
> +{
> +	return container_of(se_tpg, struct iscsi_portal_group, tpg_se_tpg);
> +}
> +
>   struct iscsi_wwn_stat_grps {
>   	struct config_group	iscsi_stat_group;
>   	struct config_group	iscsi_instance_group;

Reviewed-by: Lee Duncan <lduncan@suse.com>

