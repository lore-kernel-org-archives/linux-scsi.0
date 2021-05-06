Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7248FC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 17:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3776C6109E
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 17:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhEFRGK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 13:06:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:28049 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236172AbhEFRGI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 13:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620320708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OhlmcJt/wXHwlUkx+il9SbcRxCrxAGBzBC9IMOatFhg=;
        b=XY/C7uvgTuV7QJvGRJcnzRVRsCDU631jxgEeBzrOfRYmlSVCfwEA6rlos67CaCzYa4uu4o
        OITWgJHZrQkbX1iKHqPiMktkNvwu2AlUbcHRvQNOJCmCoqQ81Cfs9pqnIKkwlAVhebHHXP
        uGywyW+x96HSxz668AOFz24YWT/GJa0=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-ruhi63LhNfSW6k2JMPM_8A-2; Thu, 06 May 2021 19:05:07 +0200
X-MC-Unique: ruhi63LhNfSW6k2JMPM_8A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QShch7TIzOstX4l1cZikzVYvjNN+5qEiighI7LDTCuBsUu8Ckv0g6Nd7sBfBOuH3puUt/5YCIMIjfI1JLqVxJA5TNYLWH6+QCIWzJq7/EJ0VENOiO4QX091EujarPi3pB5tGchNPxylJWjxXoODLVzMCn2Iw3UDiQjIKvKf5ScQ3ZG8clyGrkjv9Y7xy9eZEiKNujlsxgIhdQvZLLLq8iZxMZxAAtHqUamk+UgOm1fnm5WxjmwrgfR2d2AmSYBAIMm6AIQWqDnn/neiGtoApqOW74DSf+9jCofkdTfWEmkm4Sa3KtcPms+UHcb43PmOm89v4UJSDuUbw/51lYXgwYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhlmcJt/wXHwlUkx+il9SbcRxCrxAGBzBC9IMOatFhg=;
 b=RztrZq5xgcoP/yE5ZDvv16C63rINKRTMkmvl7IXGn1CsehGN59yUL+RLd+g+ZhjN8vJBgZo98m4QWmp3JQ2B2OdHDI04MTlMDidKlvm6un09DyPLCGbVcIk85/3Fz2GEZullkppyUbz9Vc11mZXzDijwnJXxu8q0nDYvhi/SOHgFW3pFSoS2lbR/NEZtercKYoTok2R0pgsho9m3Pjoh5bUaOR3+m+CBQhjRy10Iv7CYLeili3+51fRBGhiVgtRx8W5V1/G1xpnsXM0wEsTihuLtIjUQuDCKK8e2x+v7Rbv1V4URPwJ7rmtrbyL01eTS80fZ/s2h7ho6aTPs1wZ3Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4135.eurprd04.prod.outlook.com (2603:10a6:209:43::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 17:05:03 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 17:05:03 +0000
Subject: Re: [PATCH 011/117] Introduce the scsi_status union
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Can Guo <cang@codeaurora.org>,
        James Smart <james.smart@broadcom.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-12-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <ffcfaeda-a2f8-ab6c-d528-4cd999911cbe@suse.com>
Date:   Thu, 6 May 2021 10:04:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210420000845.25873-12-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR04CA0004.eurprd04.prod.outlook.com
 (2603:10a6:208:122::17) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR04CA0004.eurprd04.prod.outlook.com (2603:10a6:208:122::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Thu, 6 May 2021 17:05:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75261eeb-e50f-4251-05e0-08d910b1174e
X-MS-TrafficTypeDiagnostic: AM6PR04MB4135:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB41355E1276A8E0CE7B0DC515DA589@AM6PR04MB4135.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMYY4btVeSGkUkO1i9AdCJoqP45DJnSWpaFXrZZrWojqOy4bRjB/6ygEOQENE1mhcWJ0IyF0vZhrtBjj9dKhPOq6T7OU1aLlqVYZeXahC2mA/iudqSbAniD0TIEKBrVnLh4sIQjgkCY1NchQTsGeETfxd0awxS9xvjs37o+cLZmWQZMHKH4UwbVXgTmNpjjmwIlvdKgGR6bje5EVlaQRE1Stao3RtDpZ8jgg64QGqJ7fZmEPDcviLw4WMJYcOgThzzDRHb5Zl/vCnFLO13eufSBNqb99qOIapWlSxToOXhLZiksW3QcmjqxtLPmZ/llUh1obNUaW3/xAxKHmTc8lYP03stmmOPpGoUaxXx1eKNh982yFlabafZO+dtCX7/fZCK1nl80tyZ30y6GIv28N5AImgF5I9TdLXTAO97eVgXFLW44V6WGGVsTZkuXSuuzjVUKkdJ/1mFeCwd2yCKSHDhhjwNHp7zrueY3NraqBWS/0W93IGZn65XAPIkIPbBH8xmLD3d12byBMvBk3qpcjGK53u01VidoUsVRlIcojAStzKyJZ7DIbVNQPw17IB5J1WwJ/vqdQiNvMVy3fyMGMWESEO+r/J7YSmf81fpCKAfZ+hVvRylQH63dlqk+T969E5GyVjA4ZWTTYkkE286/e98OZiYSTXGy5udIDblBM6Et06O+cH+FtT+PHHXdu679O4lN+zJqCA1a5jBmOThhnSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(376002)(136003)(396003)(346002)(366004)(8936002)(52116002)(2906002)(110136005)(54906003)(38100700002)(38350700002)(8676002)(31686004)(53546011)(4326008)(5660300002)(86362001)(30864003)(2616005)(83380400001)(31696002)(26005)(66946007)(16526019)(66556008)(186003)(6486002)(66476007)(956004)(36756003)(6666004)(16576012)(478600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aHhvV25laW9xWkUvQVNDMy9tSCtzU09qSm9BdnBWUEJSMlh2STNzWkRzWEFU?=
 =?utf-8?B?L3ZVVjFKUkxhYmtQZXVKWDVvZDFJOHY4NVRjayszNHdrSEduVFdOdytGVXA2?=
 =?utf-8?B?V1pkQWpKd0hiNWRlVHdTanNmbmF2L24zMVdwaWh2UUcvWkVLMTNxVXFmQmdn?=
 =?utf-8?B?cm54eEJEYlo5UlZSZWUrb0x5NVBBTnhLdmZyWlhpK21JSHpmL3FGVkxoeE9h?=
 =?utf-8?B?eVB5enY0dnA5bUN6Q0d3c1lsWk9PVnlaYytxdFpXLzlTYlY4TUlrdXdBTGZY?=
 =?utf-8?B?aUVaRVZIRkR4VGRUbCtTUkZyS2M1eUJULzVUVjl1K1BDdHo0RlgwRHlhRyt2?=
 =?utf-8?B?TklJTk0rTEZUZWJnUU9SemVRTDFLM0NBUmNMVm1mSmRLYU5MMVRhN1ZKZGJr?=
 =?utf-8?B?Umt5bTdPc1ozbUJlSHB6M0NQcDNGOTAySlROZkNNbEZCUkVpcHg5M29HaDZz?=
 =?utf-8?B?RnRQcjdhdGFGU2lQVTVSRlBHdEd6aW1HVDIyWmE0N3k4dG9xVWVJQnlOUFZC?=
 =?utf-8?B?K1ZNSE8rVXRUMlFPT3hQemZLU01LeU9CdnV4S2dBUjRoQWMyQkZrTS9RM2po?=
 =?utf-8?B?Z1ZaRlBQRjhYQnhnVUZyVGgwRnI2emNCTEJUQWZtTWNKNkNRb0tIUUNkREw4?=
 =?utf-8?B?VjJDRmdzK240dUZRYjdxY2Q1REF4MWdqNUtvYTlHWWE1REZLY1FuMnBJWWFB?=
 =?utf-8?B?NkxqUTk1SWE1TEM2UTd6ZTRhM0JMT2V0Q0xtREhEOFBsN1F4QURUb2JoYXJP?=
 =?utf-8?B?RzVsR3ZlNDNUNDNwODUvVGpXdHRpRlRlRnUxdk8wZzJLd01WUDJSR2EzVHg5?=
 =?utf-8?B?TnZmOEtnT1oxcTkrOWVOdFo3M2xSanJBVGxCVjR6MXA2N0RGMGNzNWQvMzZH?=
 =?utf-8?B?L21SbWUrMVkzUTdleE9aQTVkZGxKTGpwRC9lTXRHNFYxNi9ZMU5sSXNCdndJ?=
 =?utf-8?B?UVJ0bmdBMDJ1bmYxSTVxZWJJbmdhYmxraFBHT3MwcUxIR2dodWRyaHVZbTh1?=
 =?utf-8?B?aStnclBNemU0Ly9OWFZaamY4U2ViSHVvMXlRQ1FoVEpFdlNKN2hrWFpOdHg4?=
 =?utf-8?B?ZzVzekdUcCswR3U5aHJsMW5yYndndFZoT3pubXc1cHR4Z2tUdStpMmRxNEVJ?=
 =?utf-8?B?bFZ1aGZUM0lrMGxVR0Vxb3EwTmVaT1gvR0I2NnAxaDU0YklrT1BaN216SHY5?=
 =?utf-8?B?ZmVQdWtQaFJ4UkE0RFVobEVjMlZYRVZZZWdtYmJMbUpPckp5MysvRExPRTRz?=
 =?utf-8?B?MWIzdkRFMDZZTzM0TG5oNG1iWFh4d0xiZzhOU3hxd2I2bHZzT1dpdmpSbjVE?=
 =?utf-8?B?bkFWM2t3Ti9xV0RBd1l2dTVGSFp6TXZHeGhUUXFwdEdwMDd0aStHYVVGSFJF?=
 =?utf-8?B?RDkvOFYrZDJwZFpuTHV2bmRKUjJySlI4OFN0NVp0MTlPMXVGUkx3eEZhTVRO?=
 =?utf-8?B?Z2xJZ05MZ0h0NHU4d1RLVTA5eGlBWXlZdnZYL3J5ZFNWU3FVQUhwTHR1TGFE?=
 =?utf-8?B?MTJEUmtQc1REZVo1OXdUUWpDbTE3ajJ4Sm1veWdCU2FmQ2JwWFVucjhDdjRo?=
 =?utf-8?B?SmxHSFJ0SGlKVlZtSk1WVExQeHhucGhkTGNNWmUvVG1wTDM5dkhNZzlKVnFo?=
 =?utf-8?B?YWJxczk0N09GL2FtNDhBVEhnUlAxeHErNlVVa1ZNYVJydHc3Y0ZIWGFQWitX?=
 =?utf-8?B?MGpudXZuOTJlcFlnclVJS1hRN0ZSNWF1dGRwblJJVWtHTHRybFVvaGZ2SEs4?=
 =?utf-8?Q?sOm2p8giYMekR0seqUS18MIDBjbIMWpm5gB7Iib?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75261eeb-e50f-4251-05e0-08d910b1174e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 17:05:03.7280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IB0jGStH1SqwQu+P3oSFO2TMunbQu3+Zr1oMx8T3RisHFu9HDET++gNA50RsqOHfx5h+2buF6UskTuJe/LgkRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 5:06 PM, Bart Van Assche wrote:
> Introduce the scsi_status union, a data structure that will be used in the
> next patches to replace SCSI status codes represented as an integer. Define
> that data structure as follows:
> 
> 	union scsi_status {
> 		int32_t combined;
> 		struct {
> 	#if defined(__BIG_ENDIAN)
> 			enum driver_status driver;
> 			enum host_status host;
> 			enum msg_byte msg;
> 			enum sam_status status;
> 	#elif defined(__LITTLE_ENDIAN)
> 			enum sam_status status;
> 			enum msg_byte msg;
> 			enum host_status host;
> 			enum driver_status driver;
> 	#else
> 	#error Endianness?
> 	#endif
> 		} b;
> 	};
> 
> The 'combined' member makes it easy to convert existing SCSI code. The
> 'status', 'msg', 'host' and 'driver' enable access of individual SCSI
> status fields in a type-safe fashion.
> 
> Change 'int result;' into the following to enable converting one driver at
> a time:
> 
> 	union {
> 		int result;
> 		union scsi_status status;
> 	};
> 
> A later patch will remove the outer union and 'int result;'.
> 
> Also to enable converting one driver at a time, make scsi_status_is_good(),
> status_byte(), msg_byte(), host_byte() and driver_byte() accept an int or
> union scsi_status as argument. A later patch will make this function and
> these macros accept the scsi_status union only.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi.c              |  9 +++++++++
>  include/linux/bsg-lib.h          |  6 +++++-
>  include/scsi/scsi.h              | 24 +++++++++++++++++++-----
>  include/scsi/scsi_bsg_iscsi.h    |  6 +++++-
>  include/scsi/scsi_cmnd.h         | 14 +++++++++-----
>  include/scsi/scsi_eh.h           |  7 ++++++-
>  include/scsi/scsi_request.h      |  6 +++++-
>  include/scsi/scsi_status.h       | 29 +++++++++++++++++++++++++++++
>  include/uapi/scsi/scsi_bsg_fc.h  | 10 ++++++++++
>  include/uapi/scsi/scsi_bsg_ufs.h | 11 +++++++++++
>  10 files changed, 108 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index e9e2f0e15ac8..4f71f2005be4 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -763,10 +763,19 @@ MODULE_LICENSE("GPL");
>  module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
>  
> +#define TEST_STATUS ((union scsi_status){.combined = 0x01020308})
> +
>  static int __init init_scsi(void)
>  {
>  	int error;
>  
> +	BUILD_BUG_ON(sizeof(union scsi_status) != 4);
> +	BUILD_BUG_ON(TEST_STATUS.combined != 0x01020308);
> +	BUILD_BUG_ON(driver_byte(TEST_STATUS) != 1);
> +	BUILD_BUG_ON(host_byte(TEST_STATUS) != 2);
> +	BUILD_BUG_ON(msg_byte(TEST_STATUS) != 3);
> +	BUILD_BUG_ON(status_byte(TEST_STATUS) != 4);
> +
>  	error = scsi_init_procfs();
>  	if (error)
>  		goto cleanup_queue;
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index 960988d42f77..f934afc45760 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -11,6 +11,7 @@
>  
>  #include <linux/blkdev.h>
>  #include <scsi/scsi_request.h>
> +#include <scsi/scsi_status.h>
>  
>  struct request;
>  struct device;
> @@ -52,7 +53,10 @@ struct bsg_job {
>  	struct bsg_buffer request_payload;
>  	struct bsg_buffer reply_payload;
>  
> -	int result;
> +	union {
> +		int		  result; /* do not use in new code */
> +		union scsi_status status;
> +	};
>  	unsigned int reply_payload_rcv_len;
>  
>  	/* BIDI support */
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index c9ccb6b45b76..18bb1fb2458f 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -39,7 +39,7 @@ enum scsi_timeouts {
>   * This returns true for known good conditions that may be treated as
>   * command completed normally
>   */
> -static inline int scsi_status_is_good(int status)
> +static inline bool __scsi_status_is_good(int status)
>  {
>  	/*
>  	 * FIXME: bit0 is listed as reserved in SCSI-2, but is
> @@ -56,6 +56,20 @@ static inline int scsi_status_is_good(int status)
>  		(status == SAM_STAT_COMMAND_TERMINATED));
>  }
>  
> +/*
> + * If the 'status' argument has type int, unsigned int or union scsi_status,
> + * return the combined SCSI status. If the 'status' argument has another type,
> + * trigger a compiler error by passing a struct to a context where an integer
> + * is expected.
> + */
> +#define scsi_status_to_int(status)			\
> +	__builtin_choose_expr(sizeof(status) == 4,	\
> +			      *(int32_t *)&(status),	\
> +			      (union scsi_status){})
> +
> +#define scsi_status_is_good(status)				\
> +	__scsi_status_is_good(scsi_status_to_int(status))
> +
>  
>  /*
>   * standard mode-select header prepended to all mode-select commands
> @@ -134,10 +148,10 @@ enum scsi_disposition {
>   *      driver_byte = set by mid-level.
>   */
>  #define status_byte(result) ((enum sam_status_divided_by_two)	\
> -			     (((result) >> 1) & 0x7f))
> -#define msg_byte(result)    (((result) >> 8) & 0xff)
> -#define host_byte(result)   (((result) >> 16) & 0xff)
> -#define driver_byte(result) (((result) >> 24) & 0xff)
> +			     ((scsi_status_to_int((result)) >> 1) & 0x7f))
> +#define msg_byte(result)    ((scsi_status_to_int((result)) >> 8) & 0xff)
> +#define host_byte(result)   ((scsi_status_to_int((result)) >> 16) & 0xff)
> +#define driver_byte(result) ((scsi_status_to_int((result)) >> 24) & 0xff)
>  
>  #define sense_class(sense)  (((sense) >> 4) & 0x7)
>  #define sense_error(sense)  ((sense) & 0xf)
> diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
> index 6b8128005af8..d18e7e061927 100644
> --- a/include/scsi/scsi_bsg_iscsi.h
> +++ b/include/scsi/scsi_bsg_iscsi.h
> @@ -13,6 +13,7 @@
>   */
>  
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_status.h>
>  
>  /*
>   * iSCSI Transport SGIO v4 BSG Message Support
> @@ -82,7 +83,10 @@ struct iscsi_bsg_reply {
>  	 * msg and status fields. The per-msgcode reply structure
>  	 * will contain valid data.
>  	 */
> -	uint32_t result;
> +	union {
> +		uint32_t	  result; /* do not use in new code */
> +		union scsi_status status;
> +	};
>  
>  	/* If there was reply_payload, how much was recevied ? */
>  	uint32_t reply_payload_rcv_len;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 202106e7c814..539be97b0a7d 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -140,7 +140,11 @@ struct scsi_cmnd {
>  					 * obtained by scsi_malloc is guaranteed
>  					 * to be at an address < 16Mb). */
>  
> -	int result;		/* Status code from lower level driver */
> +	/* Status code from lower level driver */
> +	union {
> +		int		  result; /* do not use in new code. */
> +		union scsi_status status;
> +	};
>  	int flags;		/* Command flags */
>  	unsigned long state;	/* Command completion state */
>  
> @@ -317,23 +321,23 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
>  static inline void set_status_byte(struct scsi_cmnd *cmd,
>  				   enum sam_status status)
>  {
> -	cmd->result = (cmd->result & 0xffffff00) | status;
> +	cmd->status.b.status = status;
>  }
>  
>  static inline void set_msg_byte(struct scsi_cmnd *cmd, enum msg_byte status)
>  {
> -	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
> +	cmd->status.b.msg = status;
>  }
>  
>  static inline void set_host_byte(struct scsi_cmnd *cmd, enum host_status status)
>  {
> -	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
> +	cmd->status.b.host = status;
>  }
>  
>  static inline void set_driver_byte(struct scsi_cmnd *cmd,
>  				   enum driver_status status)
>  {
> -	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
> +	cmd->status.b.driver = status;
>  }
>  
>  static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 468094254b3c..dcd66bb9a1ba 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -6,6 +6,8 @@
>  
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_common.h>
> +#include <scsi/scsi_status.h>
> +
>  struct scsi_device;
>  struct Scsi_Host;
>  
> @@ -31,7 +33,10 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
>  
>  struct scsi_eh_save {
>  	/* saved state */
> -	int result;
> +	union {
> +		int		  result; /* do not use in new code */
> +		union scsi_status status;
> +	};
>  	unsigned int resid_len;
>  	int eh_eflags;
>  	enum dma_data_direction data_direction;
> diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
> index b06f28c74908..83f5549cc74c 100644
> --- a/include/scsi/scsi_request.h
> +++ b/include/scsi/scsi_request.h
> @@ -3,6 +3,7 @@
>  #define _SCSI_SCSI_REQUEST_H
>  
>  #include <linux/blk-mq.h>
> +#include <scsi/scsi_status.h>
>  
>  #define BLK_MAX_CDB	16
>  
> @@ -10,7 +11,10 @@ struct scsi_request {
>  	unsigned char	__cmd[BLK_MAX_CDB];
>  	unsigned char	*cmd;
>  	unsigned short	cmd_len;
> -	int		result;
> +	union {
> +		int		  result; /* do not use in new code */
> +		union scsi_status status;
> +	};
>  	unsigned int	sense_len;
>  	unsigned int	resid_len;	/* residual count */
>  	int		retries;
> diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
> index da2ba825f981..120f5a43d2ed 100644
> --- a/include/scsi/scsi_status.h
> +++ b/include/scsi/scsi_status.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/compiler_attributes.h>
> +#include <asm/byteorder.h>
>  #include <scsi/scsi_proto.h>
>  
>  /*
> @@ -88,4 +89,32 @@ enum driver_status {
>  	DRIVER_SENSE	= 0x08,
>  } __packed;
>  
> +/**
> + * SCSI status passed by LLDs to the midlayer.
> + * @combined: One of the following:
> + *	- A (driver, host, msg, status) quadruplet encoded as a 32-bit integer.
> + *	- A negative Unix error code.
> + *	- In the IDE code, a positive value that represents an error code, an
> + *	  error counter or a bitfield.
> + * @b: SCSI status code.
> + */
> +union scsi_status {
> +	int32_t combined;
> +	struct {
> +#if defined(__BIG_ENDIAN)
> +		enum driver_status driver;
> +		enum host_status host;
> +		enum msg_byte msg;
> +		enum sam_status status;
> +#elif defined(__LITTLE_ENDIAN)
> +		enum sam_status status;
> +		enum msg_byte msg;
> +		enum host_status host;
> +		enum driver_status driver;
> +#else
> +#error Endianness?
> +#endif
> +	} b;
> +};
> +
>  #endif /* _SCSI_SCSI_STATUS_H */
> diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
> index 3ae65e93235c..419db719fe8e 100644
> --- a/include/uapi/scsi/scsi_bsg_fc.h
> +++ b/include/uapi/scsi/scsi_bsg_fc.h
> @@ -9,6 +9,9 @@
>  #define SCSI_BSG_FC_H
>  
>  #include <linux/types.h>
> +#ifdef __KERNEL__
> +#include <scsi/scsi_status.h>
> +#endif
>  
>  /*
>   * This file intended to be included by both kernel and user space
> @@ -291,7 +294,14 @@ struct fc_bsg_reply {
>  	 *    msg and status fields. The per-msgcode reply structure
>  	 *    will contain valid data.
>  	 */
> +#ifdef __KERNEL__
> +	union {
> +		__u32		  result; /* do not use in new kernel code */
> +		union scsi_status status;
> +	};
> +#else
>  	__u32 result;
> +#endif
>  
>  	/* If there was reply_payload, how much was recevied ? */
>  	__u32 reply_payload_rcv_len;
> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
> index d55f2176dfd4..3dfe5a5a0842 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -9,6 +9,10 @@
>  #define SCSI_BSG_UFS_H
>  
>  #include <linux/types.h>
> +#ifdef __KERNEL__
> +#include <scsi/scsi_status.h>
> +#endif
> +
>  /*
>   * This file intended to be included by both kernel and user space
>   */
> @@ -95,7 +99,14 @@ struct ufs_bsg_reply {
>  	 * msg and status fields. The per-msgcode reply structure
>  	 * will contain valid data.
>  	 */
> +#ifdef __KERNEL__
> +	union {
> +		__u32		  result; /* do not use in new kernel code */
> +		union scsi_status status;
> +	};
> +#else
>  	__u32 result;
> +#endif
>  
>  	/* If there was reply_payload, how much was received? */
>  	__u32 reply_payload_rcv_len;
> 


Reviewed-by: Lee Duncan <lduncan@suse.com>

