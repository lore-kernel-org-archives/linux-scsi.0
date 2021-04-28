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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA76C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 19:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE77461440
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 19:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243689AbhD1TDx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 15:03:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:55898 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhD1TDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 15:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619636586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N16qRmTsLMbkQS1PZD8w2n+pl5mEBwH4/wcLNwtMc68=;
        b=lua5AVWVVGqSY6nyOk9Cjl4FwpAY+8wFfDMb6NojIgzjBnmIfSU3LE66BO4B36n8LUoGRh
        9XWN401mHcFx5a0wutHVhfSCe3dBsYh4XEUFsm4A7gkauS2QEXMgBoOel5k+NoZ7cuceet
        H+Fo05FqcunqusM7sL3Tde/q05gxrZQ=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2050.outbound.protection.outlook.com [104.47.9.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-uwO4sPAbN9yBv_yvEL87FQ-1; Wed, 28 Apr 2021 21:03:05 +0200
X-MC-Unique: uwO4sPAbN9yBv_yvEL87FQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqg/cg1PIzVSTmgXD+9TxCNsY8RRIoBYqV5bTpFoS13jKC1O2h1ntlgyQmZSVJZxkbci+46k1k9yiBnKToNyLtI9TZ8utqqr+2SUs4EZJuPafuG3NqNnSkl3bv0/PAdEELLdtXJh5VjqOAT23vzoH8OAyK0rOA1gnCqtIT6CEpnnAwtodRxFFpYHbRrponnoPM5UDgJlROAS9n3HUoOrG8kUBFKY/M/3MXofbS0pvR/RvUDTSdHvcbCew7uvKumGsy1WsgIAL824RCTblFSUvLCBNXXBeirNsbqFnhMy7nuwPqhe1r2Fb5J1d5XANQLNSAWyZe1cY47YFcZqFh7hqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N16qRmTsLMbkQS1PZD8w2n+pl5mEBwH4/wcLNwtMc68=;
 b=HWdIDlqzsO3xbUPP87TLyj8ZP6KrwHAjNCCDjzezSLuka84YCLiu7xAP+gyDIwjA9p6VFkpHGU6n3mP/IoGw2yhGrf5VXgxi2dZlz/HurqWdzrlyJF3+kKtoBhRXRCO/BmBsG5Q7F2gPHiTF7HLmwsvKnxmR8KirGv0IVXBF2q+2RLfbavqf2pMOsZxxrykEUjQGSvft4EaxzJu5E+XMO03YfdBbctjax1oXb8A//I7rSREVo4Z+d+nrxjTwzIfhdRAtoeD1YINhxOBF5weouycMEvqiFIsjq0DhP/VKpNb6EeWKP8FjiUOdZ5uwJeXDiLfkEOmaJiu0g0CnrGeT5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5223.eurprd04.prod.outlook.com (2603:10a6:20b:3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Wed, 28 Apr
 2021 19:03:02 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.038; Wed, 28 Apr 2021
 19:03:02 +0000
Subject: Re: [PATCH v3 2/6] scsi: iscsi: use system_unbound_wq for
 destroy_work
To:     Mike Christie <michael.christie@oracle.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <a4572b94-044a-bab0-f6bb-9d9bcfffad21@suse.com>
Date:   Wed, 28 Apr 2021 12:02:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210424221755.124438-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3PR09CA0023.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::28) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3PR09CA0023.eurprd09.prod.outlook.com (2603:10a6:102:b7::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 19:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0007ac4-c0ba-4173-e25c-08d90a783f4e
X-MS-TrafficTypeDiagnostic: AM6PR04MB5223:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5223DDF94C0BBA819019AE0BDA409@AM6PR04MB5223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAYWK+Vl4l5RVBXMxxX/OJmX47psDyx2dzYj44qcEwyIvMHuqPJtK2g4XulbXd//2D/Rijtp4szdMNjwunMj3AyoyxZeYUOXryMz8MGKYGsupWVWerr9TOiOa7BCTYDdELuh3sAcgE82RGhL3WldrbsANGq8qgRu1wWSZWuO0LdG6rq0Zd/+AglG69UYeghknwWiYl7oPMo31L9vIY6AXEckGWAv+eg/6KosCBa3WbIBDRVLhZzHMPVRYknNaRt5llTZSWGMZBzxGDSg80Yn2ZjwaHS27mS7tE7yx2Tm0VfWmJXxgbI9vu4VJWCtIKPdb/fUnezVOPyHLoUW2/idrx52bX5PN/7MEmXMB2R9+wMRkD4IahuKKCOadX0SOe6MiqDEyDQHJry+EE/HVQx8K6M2XVtKshOe5Q6NVfQW5ttPpK7nnthoi9WdFtuoGNXuGigyoKaTbiPQQ3QvIoBpmWWSzUmRCHiNU+q93XkHsSchbo0HQ2CqAEtWqzBE2jWGY7Qpe70BUHjyKhuiU/vMSGDJifWDEZLMJCryyBhsnr4mFyiaDDtsPpLsxX9PxAHt2cDkHfDa4UriiGf4M0xlYZpfMyI+rVMP+3FsowNJBnw3Qsu1dyygyIjUQS+KgEuhmFpqEv7Op4fEMAkmbDSEeyU7uc/88srX9MY6USFAZev3TeroRQu8CnkdnLnUs5RKEmp6x3rUFTIlPLsQj0SOPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39840400004)(38100700002)(2906002)(6486002)(956004)(31686004)(2616005)(53546011)(5660300002)(66476007)(38350700002)(478600001)(8676002)(66556008)(66946007)(86362001)(16526019)(16576012)(83380400001)(26005)(186003)(6666004)(316002)(36756003)(8936002)(52116002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NEZ4dEw5TXBvV0k1M1RWbjc5TjJIZ0JjdTM1WkNZRm5kQjJialAwUXprcjl2?=
 =?utf-8?B?dFh2aEdFSnBINjFoNWRsVXRMQXFDbWlaVzFPV0wwYTFoL243ams5eHcrbHFL?=
 =?utf-8?B?aE1adWJhTmp1dXlUNS9Ob1JQVS9CSUZ3bzZZQmRqenVsbXFyRjJlb1FkSGkr?=
 =?utf-8?B?UzMrbXhWZlJtYnJPcjJERXYwazkwekpIV3NlcThuL0pkcFFya3VIcVBSdVMw?=
 =?utf-8?B?WmhvZ0FYcldkcmw4U2tIQ2tQczZtVkFlOGJVR3hGdGx1YkNBemNOSFNSMk84?=
 =?utf-8?B?c0hHRFFzVHFKQllHb0U0TjI0V3YxRkVva0QwTm9raHQzV2dOb1dHeER0U00r?=
 =?utf-8?B?akhaOUxzKzlSemdmc0x0aWpKdXpITllpc3RNZVk2OER5azVTaWxtUEtqam1h?=
 =?utf-8?B?RStUby9vNW1teUNPbURWaGU5Q2ozeTFmcWVGZDlmRUJkNER4UDNzZ1pEQy9i?=
 =?utf-8?B?QjY5aXM2QkZGbUpZTWdlNEs1Qk1ia3hBdXVCR1cxbVpiandodTNNMUt1S1F3?=
 =?utf-8?B?eE82V0NGOWZZSTNXdFdsSzZ0ekRLbmkrZDMwVmp1K0w3MW93a3QwN1IrZGND?=
 =?utf-8?B?YThZeFZqaFFHM3JQQ09FcWd3WnRzczV5YkhCNEU1cGZoanFNNk5LRmR4WTRp?=
 =?utf-8?B?Vmd2b2F5V3E5VGVZRjZYbWhlSTF2dnp6ZWl4T0NMeWRsQTdZbEdtNERVUVBa?=
 =?utf-8?B?RDlBWVRLM0Fsd0ZBRnB4UzhQa3pZZjd3cnVUcTBHNnA3NmxRbVBSMDF5NzlV?=
 =?utf-8?B?SnJyTW9uY3ZmMHRFbUh6UXBtZXJUM3Y2MWtjL3BzMUxQbUhlY002bm1EOWpo?=
 =?utf-8?B?U0p6RG5qN1VwRjN3UU96NW1IdGx6WHNoR1Q0c0tROHVrQ2xDa1MrcVZ0Q0Nr?=
 =?utf-8?B?MFYzNkwwSG8vc2ZadFhTWm9YcDlBTzBucHlhbkV3T0U1R25UVFJhMlBmN0k4?=
 =?utf-8?B?b0VXQ0JjNTcxNzcxTHBSd3ZkV2JiRjlKQk05Y05pR1JsOUQwM08wTXN5bVZr?=
 =?utf-8?B?S01GWmNJS0ZKb3pCTkhHQk9TcllsNjdoNHV3U3U1Ukl2R2N5aUpnWlkvSmtU?=
 =?utf-8?B?ZGNkQlNEdWJwWUxJK044Y1JWZlB2YlplcGQva2FiVk01V0JXZE9ibkRsS1lZ?=
 =?utf-8?B?czFEM3Izc01CYm1IbzBDbFF3VFltUkxjcHg0VldnZnF1VUNnTWZYR2RWUXZU?=
 =?utf-8?B?LzAzM2JtK05iVUgvSjZ5cG53akFJVStWYVVtekJybXI0OGp1eVVtVlZ0Nmhs?=
 =?utf-8?B?U0tvZGtoY3BaYmxKVlpjdmtJc1hzTG5MTTM5cHBVN0xQUGViMTlrc3U4Rkhx?=
 =?utf-8?B?RlFwSCtDaC9xaDBuVzd6bXNkTEJ4R08xcEoxdno1dVJDVHF6UHlMSlZra0hO?=
 =?utf-8?B?aGd3MnFYaFF1cmNqak4zUTRNQm8xZEkyekJ5RWQ1bHhDVXRSQWR2MWZQUjQ4?=
 =?utf-8?B?SnFiOG9kUXlGc1k4SUpacVhmUUdYWVhHWHB6UXhJTFF3NGtjc0lDWnVGN1Qz?=
 =?utf-8?B?TmdZLyttaEJCcEVodVRObWZaMGcvWkw3Wkl0ajhFUXFpY0JMdzljQnZ1QVUv?=
 =?utf-8?B?VHZZYlBiOW9CMVA5RGhhOTNsMjdvbFBHUUVBVHVyMVA4SVVGU1dVYUlmOGtN?=
 =?utf-8?B?VzZVSFM3MWp1NmU3a0JMVUdYUklPWlF3Y0hQV1JNK21QbEEybVBJYVZXQ0lW?=
 =?utf-8?B?Y0xmVEJQM1ZudndydnVIdVZMMTB4OXEvbU4yQW14Njg1bXdCQXVJb29BcFVs?=
 =?utf-8?Q?qg/nL6+/JmmnIC49EztP9dl17b0Isx2HETXM9LA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0007ac4-c0ba-4173-e25c-08d90a783f4e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 19:03:02.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9hPF3gOTIrcij2inm40RUWaBHA64M8Dta9aAafwucbtqeSUFsLVANiKqDM2/fV2aniS2ozjixZpucwYSYtL5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5223
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:17 PM, Mike Christie wrote:
> Use the system_unbound_wq for async session destruction. We don't need a
> dedicated workqueue for async session destruction because:
> 
> 1. perf does not seem to be an issue since we only allow 1 active work.
> 2. it does not have deps with other system works and we can run them
> in parallel with each other.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 0cd9f2090993..a23fcf871ffd 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -95,8 +95,6 @@ static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
>  static struct workqueue_struct *iscsi_eh_timer_workq;
>  
> -static struct workqueue_struct *iscsi_destroy_workq;
> -
>  static DEFINE_IDA(iscsi_sess_ida);
>  /*
>   * list of registered transports and lock that must
> @@ -3718,7 +3716,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  			list_del_init(&session->sess_list);
>  			spin_unlock_irqrestore(&sesslock, flags);
>  
> -			queue_work(iscsi_destroy_workq, &session->destroy_work);
> +			queue_work(system_unbound_wq, &session->destroy_work);
>  		}
>  		break;
>  	case ISCSI_UEVENT_UNBIND_SESSION:
> @@ -4814,18 +4812,8 @@ static __init int iscsi_transport_init(void)
>  		goto release_nls;
>  	}
>  
> -	iscsi_destroy_workq = alloc_workqueue("%s",
> -			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			1, "iscsi_destroy");
> -	if (!iscsi_destroy_workq) {
> -		err = -ENOMEM;
> -		goto destroy_wq;
> -	}
> -
>  	return 0;
>  
> -destroy_wq:
> -	destroy_workqueue(iscsi_eh_timer_workq);
>  release_nls:
>  	netlink_kernel_release(nls);
>  unregister_flashnode_bus:
> @@ -4847,7 +4835,6 @@ static __init int iscsi_transport_init(void)
>  
>  static void __exit iscsi_transport_exit(void)
>  {
> -	destroy_workqueue(iscsi_destroy_workq);
>  	destroy_workqueue(iscsi_eh_timer_workq);
>  	netlink_kernel_release(nls);
>  	bus_unregister(&iscsi_flashnode_bus);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

