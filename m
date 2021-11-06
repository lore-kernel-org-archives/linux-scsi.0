Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62E4C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 18:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B23D61101
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 18:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhKFSUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 14:20:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:51016 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230089AbhKFSU3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 14:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1636222667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PRi5tPNb+qLiLXrj9eZHvZUsxykWEFG5Xk0lz50JC4U=;
        b=T+9rROUPZmVt/cy5WsVpyP+SqOqE3/8WbDRitj75SL7OdTv2mTikRS0eQ4XjJGzedJSh+H
        qX+CT9ogNEP5eaF4shld+kvvuf4vK7vI4LXWX54SYSLBXJsS5otmb1F7LiWeRzW9tP+Mkt
        E//B5rPS7vKPWe1ocNQjxVtiYhdgRTs=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-oatQWkzeNb2hSBE4Wj2tsg-1; Sat, 06 Nov 2021 19:17:45 +0100
X-MC-Unique: oatQWkzeNb2hSBE4Wj2tsg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ngs4hMqHPXUbuG3MSK8LZFXhetmluEiIL5pso0pzjUdb0ZNq8b6zrgbF59Q2s7oAQgHCtmOfWFt4k/qJatFBWi0kzi8FirQYcA7913Hvy7LYTUlRsMTqnvh5BSqP5K9EmYvZZkI/BZqrq/4m/rm3tHnIev9Wtkc3RSZeiFV+EBensBWtm4n3a9Y7sUr2wRSnkx81aEP7B+Km+dNiDToLjVnJbpOqXCDp3faTT6w/2vKQE1fnEBlPfjD4o9rtNI5J1PwawxcRJG0M3nbM/PJxYvTtmw5F/qIjAIYNEGe6BSF8HvNKNOG48An6DO4EIr1QwEVgnxoVHrkQDRaxnhW30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRi5tPNb+qLiLXrj9eZHvZUsxykWEFG5Xk0lz50JC4U=;
 b=ZbOeuGKUtLjt25yTTQj5ASr8h79AKevm0/82shsyFZx19+NRhCoqayJLsMnl+m9brsJ2TaABpjpLAJdHkKOJ0qRetd0MZAXFe+Z3ZBY2GVAcv36DJaAqtYVmudGaubFU3wyggoNuTA/LhWLrAwN+ZMGD8flgcq+pP56rSzSztPpBYxOyF87gD8Ba3yNsTKu2TuIjEAhdMJ3TlFvr7fhXSo7Hw/M9CUhsI79WrvR6KL29akAUhL8v1nr5QPmOHwBlgESUTXRVXyMB7oG95drgLDmIaDOTFDVjcWmo5W9bsUaFCQIRrqW32/kd4KEvyNnRX0T4zewHD/dCFoqeA5jlNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8200.eurprd04.prod.outlook.com (2603:10a6:20b:3f8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Sat, 6 Nov
 2021 18:17:44 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4669.015; Sat, 6 Nov 2021
 18:17:44 +0000
Subject: Re: [PATCH 2/2] scsi: Fix hang when device state is set via sysfs
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
 <20211105221048.6541-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <b5547dca-cd7f-c3ac-e072-3fbac7f1b9b4@suse.com>
Date:   Sat, 6 Nov 2021 11:17:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211105221048.6541-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0096.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::37) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM6P192CA0096.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Sat, 6 Nov 2021 18:17:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cf5f8fc-1597-40d1-bb06-08d9a151ba28
X-MS-TrafficTypeDiagnostic: AS8PR04MB8200:
X-Microsoft-Antispam-PRVS: <AS8PR04MB8200CC6078CEC7C11AF4E431DA8F9@AS8PR04MB8200.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X1Ezopo0ZUS2Ii0QkY1B56XhOgFIuwAWbPNSxoA4b7GguSV1o1xDQiykqF2pxgfBw6GBnaBZTmJlNGkU2C4/+WbzFLsN8kugPzLZmXL9T2/GziAISWWHOWG6Oam++1phxKmMofHK5MQGhuzTFAOzn7zdOMJBfzYGSvI1sqA1EbcN3wA1l8VtRN2cIMqctBkdc9VTVyFTJSf20Fzdtmc+fDVSvtAqx/XQgKI2VDi1Rf3LgtW74+8PtrU9gxpX6wH30wQzCmiBWHcUiUAHYWMlA6AIZaV3fM6YHN0QBP/HclfJXDNsGwMaJUp1sRwZ+2lTz6MCscG7pbqqL/x24pUhd2cmPKU3b6oitIRomUgpR+6Ef1D76bovsWAxc70oYb3VniEnZ+PTlljUvyIv7HWkhhRc5n9aBcoFHrIVAM/B4OPqAm0rzMbUWPV2gjcrhNq5XiB2MsScDvAzvd1zJ4X2CF9sH0sSxLVNUho3+c+up4QrO60JokfGYuOVnCxalZUo/IxU2applpdmxka0lxnuhC7UUYR+ko1+k2ijCqXxXEVSZ4z3IWQAUV9C5hxGgz7voyKj7fBBHBkXbKERrgeYe6/EUqb9WX7eFAOaQhEv8yYJhX9cEhsjBkhdbQODnv2CiuzfENMUkjg9YumWoYn5VwjeoJ2ZQ2yqaTWopHU6duJXj0euSAYx6PhrOEew5HlUAyEYZobY49NfwTaTRcWjrcgDRdyeZ8aFB4/PBudXBhs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(66556008)(66476007)(2906002)(31686004)(66946007)(38100700002)(186003)(2616005)(316002)(508600001)(6486002)(956004)(5660300002)(54906003)(31696002)(8676002)(53546011)(86362001)(8936002)(26005)(4326008)(83380400001)(6666004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDV5WTFJc0svTEtYQ1RUZy9RVEdFckFsSDZGbENpTndqb3Z0ZXVNT0l6elJM?=
 =?utf-8?B?TmlDR091SjRPZWY2bDR5bzlyRzNaRTFjMFMrSkRiRXVrREhKMm9aYzV0MTU2?=
 =?utf-8?B?akFYeUgreE8zMG5YajF0Qlg1OFc4VDZpaDZwakVrYWtGam4wd0VCOC9yTU5K?=
 =?utf-8?B?aU5Nekd0dkxJYlBCTDc1dEcwUmh2SXpoNmJUamQwUW53VzAxMXhhT3lYT3p0?=
 =?utf-8?B?TVEzWldpa0ZyejNuZ05uY0JQMDJNNC9ER21FVDZWZGZkb3htWnJITmFYaXpY?=
 =?utf-8?B?TDBZYnhVYTdOck0wRVp2UzE0OFZkWUxnSSt6YzQ1MS92VVJuaU5qbVk5cVR1?=
 =?utf-8?B?bEFncHJnTFdteW8rQkpGcW9NN3NkbGVOa09sbGRSQWIrQWFKdWE0WVBYeUs4?=
 =?utf-8?B?Y25OZDJySzR0cXZNUkFuajY4T2RWN1RuRWJ0bTcvQ1JGZlEyUFlobllMcGpo?=
 =?utf-8?B?RGR5NHNiWVlxWEMweXRDbDJiemU4WWlDR0gzeWdNSUlHdy85NStSWEF0ekNp?=
 =?utf-8?B?V3ZuenhmZi8wQ3dZdGxDQjRCaE01WHk0U1JaVGVKMm4xME5SYUNWM2s5aStx?=
 =?utf-8?B?bXhBTlJvQmVHSm9hRmZhUE9vUlZZNW8waXA5bk1XM1g5bU1ZaVQ1ZlN0OFlz?=
 =?utf-8?B?NTdWdFdNV3lZU21BT2U4RkZyODhvMXpsb2FCV0diL1RZbWtaTEVzeHlFMFVO?=
 =?utf-8?B?R0tuYlNOa2FVZk1ZV29aUjVKNmx5ekFIV2kvZnNBeEdSb2I1bnpLWDF1MUVv?=
 =?utf-8?B?TU5pbjlFSnJMTktPVU5Ib1NNYmxKQ0N2VnVqR0FYMklRblZNOTMzUzF2OG5r?=
 =?utf-8?B?VFk0M21IbU9oUlRJM2JwbE5iUnhmTnNpOXhLdHBaRUdINkorK014Z0g3M1Qw?=
 =?utf-8?B?YmxVM3JPUmtobkRFYTRtK0NYb211RDFEQjBTanQreW01RkdkWXRMeGo0dnVj?=
 =?utf-8?B?UzBJS29RcHUrQWhjeHIybHVmMW91L2ZCcW82ZFBFc1Y1TDdmaDRMSitScHhT?=
 =?utf-8?B?dXNvY29BcXltVmM3bTBLN0syWFhzbjAxRFNCaVVYS3lBWi9VdDU4aHFvNzE3?=
 =?utf-8?B?SUdkczViVVFkR05tS21zK1RDVUU4QVc1eHpVK2R3YmFYdVJMa0wyOWVqOVhH?=
 =?utf-8?B?cVhNTENxZDhzV1ZnZktDVW1rWHpqY2xYTTNadXJsak5TYWhQWDRCRmZvWmVz?=
 =?utf-8?B?TUM1ejk3a0Rqd1NXbVB1Yittc21XalBtVGxnZ1M1bkJZN1JSTXZjRFRlNmxS?=
 =?utf-8?B?ZEsrOFdpSDNOb2c0UVFFQVFyR2RxTTRLZDZVaUJoVExJWkQvTHZSUlRuZXpX?=
 =?utf-8?B?TzFKS2dFYytYU2JoL1JHN2taUVkydmZVdVdIYVU4WUJJTEtXQ1I4VVNwelQw?=
 =?utf-8?B?U04xOVN1dFM0bnpSTFB5cllKRldMWmk2cmZHWEdIUGxXWllwNjlubDgyRm1O?=
 =?utf-8?B?bmwwM0NTUGJjVDA4ZnJBc3RvTmVyc2hLN2xxVEtYTTEwRzB3anpoRzBjQVdo?=
 =?utf-8?B?NEh5VTIyMHN2aUlSZC8wNEtKNWRLSTcwQ1kxdXgzUXdIaUd1aDlWOWdIdGlL?=
 =?utf-8?B?cER2bnVQemd5Z0s0S3VzdmY0cDBmWVNoa2dLTVpuTHd6cnZJeEpQbCs1WExV?=
 =?utf-8?B?OUR4dHhoOFo0RnNpSVFBbm1sd2Q5bmdWQU5JMUlaVXhyQ09ldEhveEFHUFB1?=
 =?utf-8?B?ZE43TFhDVzlxRTZacjF6bnVKcktsT1lsVWxnVmdlVzUvbDRnMUdWa0NQUGdB?=
 =?utf-8?B?bm8rSmMzckdMSGwzdDJnWElkT1phWHpTRnZiOTFtM0Y2QlZxbGJhMXVMNzI3?=
 =?utf-8?B?UVhvSElFR0VJUFZ1ZVNyVUIveVdvdS9vU1BDNzRrRGJod3g4WlVQbFE3TTZJ?=
 =?utf-8?B?VlVpc3V6azhBaEJ2VHAvVXdKU1oyMWFBOFNnUlRrS3dlOERnbW1GdkQ4eFVs?=
 =?utf-8?B?QjVCQm9HdHhYQVpJNmwyNGo1b3VxV3laQmZCM3RLYUJNV1BYbHBNWlNIeEts?=
 =?utf-8?B?bFJjL1ZJTW1NOWtkcHg0WmltaVc3RGtaVWJTNkRVN1R6RTBackFJZThOUGxn?=
 =?utf-8?B?UkgybDZCcklvOFdKQ2g4OWcxVlViRDNxdzQ2Y09EL21EV1hFTmtBRVdQeXY2?=
 =?utf-8?B?UDFSVVRrTGlieHplaGdNSWViamlubWxhaWJOMUtkYllUeHBiR3pOb0MyT0Z2?=
 =?utf-8?Q?yFemB9FIwC2Zwd7NZbyg+bo=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf5f8fc-1597-40d1-bb06-08d9a151ba28
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2021 18:17:43.8549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOmVxu4LKgz4VmLTVtmAAkCrxX/9Ef2EcEQZRYlG+U2Jp5YOy7tJqJ3DQO5yCrZFEA6nAvnMGO3Itcr813juXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8200
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/21 3:10 PM, Mike Christie wrote:
> This fixes a regression added with:
> 
> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> 
> The problem is that after iSCSI recovery, iscsid will call into the kernel
> to set the dev's state to running, and with that patch we now call
> scsi_rescan_device with the state_mutex held. If the scsi error handler
> thread is just starting to test the device in scsi_send_eh_cmnd then it's
> going to try to grab the state_mutex.
> 
> We are then stuck, because when scsi_rescan_device tries to send its IO
> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
> which will return true (the host state is still in recovery) and IO will
> just be requeued. scsi_send_eh_cmnd will then never be able to grab the
> state_mutex to finish error handling.
> 
> To prevent the deadlock this moves the rescan related code to after we
> drop the state_mutex.
> 
> This also adds a check for if we are already in the running state. This
> prevents extra scans and helps the iscsid case where if the transport
> class has already onlined the device during it's recovery process then we
> don't need userspace to do it again plus possibly block that daemon.
> 
> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: lijinlin <lijinlin3@huawei.com>
> Cc: Wu Bo <wubo40@huawei.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index a35841b34bfd..53e23a7bc0d3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -797,6 +797,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  	int i, ret;
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  	enum scsi_device_state state = 0;
> +	bool rescan_dev = false;
>  
>  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>  		const int len = strlen(sdev_states[i].name);
> @@ -815,20 +816,27 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	mutex_lock(&sdev->state_mutex);
> -	ret = scsi_device_set_state(sdev, state);
> -	/*
> -	 * If the device state changes to SDEV_RUNNING, we need to
> -	 * run the queue to avoid I/O hang, and rescan the device
> -	 * to revalidate it. Running the queue first is necessary
> -	 * because another thread may be waiting inside
> -	 * blk_mq_freeze_queue_wait() and because that call may be
> -	 * waiting for pending I/O to finish.
> -	 */
> -	if (ret == 0 && state == SDEV_RUNNING) {
> +	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
> +		ret = count;
> +	} else {
> +		ret = scsi_device_set_state(sdev, state);
> +		if (ret == 0 && state == SDEV_RUNNING)
> +			rescan_dev = true;
> +	}
> +	mutex_unlock(&sdev->state_mutex);
> +
> +	if (rescan_dev) {
> +		/*
> +		 * If the device state changes to SDEV_RUNNING, we need to
> +		 * run the queue to avoid I/O hang, and rescan the device
> +		 * to revalidate it. Running the queue first is necessary
> +		 * because another thread may be waiting inside
> +		 * blk_mq_freeze_queue_wait() and because that call may be
> +		 * waiting for pending I/O to finish.
> +		 */
>  		blk_mq_run_hw_queues(sdev->request_queue, true);
>  		scsi_rescan_device(dev);
>  	}
> -	mutex_unlock(&sdev->state_mutex);
>  
>  	return ret == 0 ? count : -EINVAL;
>  }
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

