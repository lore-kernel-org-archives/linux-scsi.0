Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460AFC35247
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 17:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 114422087E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 17:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBDRqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 12:46:20 -0500
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:43072 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727451AbgBDRqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 12:46:20 -0500
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.146) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Tue,  4 Feb 2020 17:44:11 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 4 Feb 2020 17:41:12 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 4 Feb 2020 17:41:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oP/NBp2IXLm/PKsn5r9UywJcDZsmftCPl0YfZBEGTHIavkH0lddlNzJUgySnz7qoI97tZkDu8qi8RwVBNPWKh/vhydEnM90dI4mEwns8IAplz8VnwAxYUz9Uy/h/gIQhI7UJqwZyXCS8HHg27rNsdI4Xhvb1kXwZYhHGt2k1JhypTfyIKNwKMML/SwGu45xxA5ZQmIiR9N26l0pOZsyG87T7/OqhjMvb3/5csATeIWGYK3fN1VpoamEeUbXHl52Z4uzsvxBnTnNJToT8ywzkUqI/4xC2qjIjrQKTuBvnaWjMBNYAdr1LMupeQWyJ0lFcFOELFr0MaobrfrJ6FhH3yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQ4dxVoy/zEAojyTj/rv/BTPoQE32o/UluTi5XTc4y4=;
 b=h2gKN/eeAMlk/2g6vOVqp4+muBhIemW/iC+A8vqJM2Odmz62d261t+UQnNRwJ/qzzXRE7g+hZfX1Mm9G7x+vtxSSS14AOdcw5UL4WPZAmHAp4KSk2osAGxxcPk/KE4U6WLjRTy2+IdfU3lhNUyVw+nDbzXprn3G4cUbkIxtn+O0LEfF9IkSx6foYqy1cRvvpZndaDrYRymZEURQUjuh+L+/rTzClTvGCeaiLmWhw0YFWiKvfwjDqQRJYY0AsLYQPYLIOwzPFQzIrxc+XF8eSX0phPgcdNi1TOYvmgaYZh8PqI6WsBzjggtEoVbvkzisHfd4mAvtTJFbNrSwKdHmwbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2543.namprd18.prod.outlook.com (20.179.81.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Tue, 4 Feb 2020 17:41:11 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784%5]) with mapi id 15.20.2707.020; Tue, 4 Feb 2020
 17:41:11 +0000
Subject: Re: [PATCH V2] megaraid_sas: silence a warning
To:     Tomas Henzl <thenzl@redhat.com>, <linux-scsi@vger.kernel.org>
CC:     <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
References: <20200204152413.7107-1-thenzl@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <f9ebcae8-5f4b-7725-10dd-716d1d3a406d@suse.com>
Date:   Tue, 4 Feb 2020 09:41:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200204152413.7107-1-thenzl@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::30) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0018.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:62::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend Transport; Tue, 4 Feb 2020 17:41:09 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d34990f4-a76d-4416-1a27-08d7a9996c4c
X-MS-TrafficTypeDiagnostic: MN2PR18MB2543:
X-Microsoft-Antispam-PRVS: <MN2PR18MB254359D0080494700E5D9DC0DA030@MN2PR18MB2543.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03030B9493
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(52116002)(5660300002)(66946007)(478600001)(4326008)(86362001)(8676002)(31696002)(81166006)(36756003)(81156014)(8936002)(66476007)(2906002)(66556008)(26005)(6666004)(186003)(6486002)(16526019)(31686004)(16576012)(956004)(2616005)(316002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2543;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEsXVMsVmtmP0AVvpwhQ5DcsD3ylNxsNtqcGsjY4xoMdJFeOEWpeLZlfDnE6OiBmJ9HRvvjk2Bkjn8SsSsjkEU0g7xnJokPlwUBBdaJhPgD+zbDuKHJWxmb3NYxpX606pnPiVNgVb9kXZcBYuGNMC/ZsFz9ZhIez/nL6uUUOTZPixnHeGFh4dyYAvQxf1eR4ULoCZgqTipqAsjnjM3hjotloA4cHfLzml7ATFxroDk66IMvH2MbBue3E3AuSF6lYQepKKhHQUOS+CAdpKgP40/0gTDc4Ed1E0VITWwiPy6eaJSKkdK/kazwyVceucujfAlp1jBbscUFu0oCTSMhHJJcGz0np8bUyfoV3Bsj4Dqj0CFs3sp52zC+yH0DXYLnxUHP7u1NlDx16vFFcEfvrbvgLOy1u0mDa62Dz9Qgct7eMOkNLM6h92iWl0nEwGdDQ
X-MS-Exchange-AntiSpam-MessageData: zp6PXnVnVPy/MAFyc6aXflf+Sic6e3l8UgxqaGjqBuno3d2SrOqEnDXSP4icCK7xe9mpMFSGQhUqmP6Wv7BKJZDOncF9fE+J/vGiLL3tqGdQiy3Zc3tprWMd32j0HGeNssQRUAqyH+4UneileXLKhw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d34990f4-a76d-4416-1a27-08d7a9996c4c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2020 17:41:10.9870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dIvUDO5SW0+UL8kJGzhzjdJk8I2LpMCVlUBJ+Ry+4lhYBb1N+hRKFik1+tjtB/lvfPfx0DPTCtPhSMtBvIZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2543
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/20 7:24 AM, Tomas Henzl wrote:
> Add a flag to dma mem allocation to silence a warning.
> 
> This code allocates DMA memory for driver's IO frames which may exceed
> MAX_ORDER pages for few megaraid_sas controllers(controllers
> with High Queue Depth). So there is logic to keep on reducing controller
> Queue Depth until DMA memory required for IO frames fits within
> MAX_ORDER. So or impacted megaraid_sas controllers,
> there would be multiple DMA allocation failure until driver settles
> down to Controller Queue Depth which has memory requirement
> within MAX_ORDER. These failed DMA allocation requests causes stack
> traces in system logs which is not harmful and this patch
> would silence those warnings/stack traces.
> 
> With CMA (Contiguous Memory Allocator) enabled, it's possible  to
> allocate DMA memory exceeding MAX_ORDER.
> And that is the reason of keeping this retry logic with less
> controller Queue Depth instead of calculating controller Queue depth
> at first hand which has memory requirement less than MAX_ORDER.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> V2: A change in the description, additional information is added,
> kindly written by Sumit.
> 
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 0f5399b3e..1fa2d1449 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -606,7 +606,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
>  
>  	fusion->io_request_frames =
>  			dma_pool_alloc(fusion->io_request_frames_pool,
> -				GFP_KERNEL, &fusion->io_request_frames_phys);
> +				GFP_KERNEL | __GFP_NOWARN,
> +				&fusion->io_request_frames_phys);
>  	if (!fusion->io_request_frames) {
>  		if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
>  			instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
> @@ -644,7 +645,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
>  
>  		fusion->io_request_frames =
>  			dma_pool_alloc(fusion->io_request_frames_pool,
> -				       GFP_KERNEL,
> +				       GFP_KERNEL | __GFP_NOWARN,
>  				       &fusion->io_request_frames_phys);
>  
>  		if (!fusion->io_request_frames) {
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
