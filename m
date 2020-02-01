Return-Path: <SRS0=vSKu=3V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9C4C3F68F
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Feb 2020 17:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B245C2064C
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Feb 2020 17:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgBAR1m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Feb 2020 12:27:42 -0500
Received: from m4a0072g.houston.softwaregrp.com ([15.124.2.130]:44978 "EHLO
        m4a0072g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726195AbgBAR1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Feb 2020 12:27:42 -0500
Received: FROM m4a0072g.houston.softwaregrp.com (15.120.17.146) BY m4a0072g.houston.softwaregrp.com WITH ESMTP;
 Sat,  1 Feb 2020 17:26:13 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0334.microfocus.com (2002:f78:1192::f78:1192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Sat, 1 Feb 2020 17:27:08 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (15.124.8.12) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Sat, 1 Feb 2020 17:27:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGH7QNgMficrJ7FGBRjte8t5cx/u4HqvwIxB/IVxuGbMbpvLwx9JIfIGmavezOKzY3QqgY/OvR3yr6VJbqEkj6CqyOrgg6MyNWlRnb39PWiq8506H+ZfEvbKcVp8LDWpD0Lx9POhtSDM0t06V18LAd/67TqL30cy0PCw5+MUGyHQ36MFWYusjSonYQFhebNA+krjPLJvWwVyK/0JVkOslFJp8A9FBOGZl7cAcYEfhmvNE3vU+dhOhbD4i27XY/b85gTo946SqSGXc/ybGKrtFKoHu3uehl+pUYncHkPCK/spE86s3FF5a0oCGeMQJ/9MLcGtnwZ62raYeHM8TarArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SzF2TC3gNucQsOdQnCjj/DsOmiTS2Kq22OOMpysJPM=;
 b=ANmv9fwLOoy0fE8uqIrcrb/j8JN8M9LHNho4xSaHb3XZuU7wGsPOL4kEIO9sqzeOdKpd/YzDyGlS94HSX/A2HgicodVNnkFX+vJLnuFHzMxo3Ml8mPL/9E9uVsl/Y5vJaeKEp43lFEm7TeAD3U8cF5O2kUUTX1/eSof4DdyMs4SnUzcZq+Me9FhOYQZlHdrnHTldFqtR/f1CfAFlVPgbJEvofW/1dLzkwBCU0WkGj4G6eNzTgOBngfG65ATMuDD2DviNy+IgxDTjRrSQRM/55SOCdCPQ7QZUPkCjiOPdcYcUODt5T0lTPUC0rljS6lV/WOgTF523UZt1WNuNkZPcVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (10.255.237.204) by
 MN2PR18MB2973.namprd18.prod.outlook.com (20.179.23.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Sat, 1 Feb 2020 17:27:05 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::3050:6182:4666:6784%5]) with mapi id 15.20.2686.031; Sat, 1 Feb 2020
 17:27:05 +0000
Subject: Re: [PATCH] megaraid_sas: silence a warning
To:     Tomas Henzl <thenzl@redhat.com>, <linux-scsi@vger.kernel.org>
CC:     <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
References: <20200131132350.31840-1-thenzl@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <ff50f95a-1885-9fce-946c-f31861c06486@suse.com>
Date:   Sat, 1 Feb 2020 09:26:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200131132350.31840-1-thenzl@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::14) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0002.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:62::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend Transport; Sat, 1 Feb 2020 17:27:04 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e83db4d-2e50-4995-4677-08d7a73bf535
X-MS-TrafficTypeDiagnostic: MN2PR18MB2973:
X-Microsoft-Antispam-PRVS: <MN2PR18MB2973623B9E8D2C34F74E15E0DA060@MN2PR18MB2973.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(189003)(199004)(53546011)(31696002)(52116002)(2906002)(6486002)(66476007)(66556008)(16526019)(66946007)(8936002)(36756003)(186003)(86362001)(5660300002)(26005)(81166006)(31686004)(2616005)(956004)(8676002)(81156014)(4326008)(478600001)(6666004)(316002)(16576012);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2973;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KHPzGw/w0JcW1Ea5G7HNgFf/YIKL6BexmWvGfKKMPREubmwRAUD5XPPMKGsU5U/WysclchLn3iG2svCCr/R7HTCyX0GHImamS+ZVq5W53HvvG/pc1ApG/zmdz6NNp5mfV/HpBMxjVgi366cFhrtKUW9NuQAI5lEepsZGlEf42nFE+hraCgSKhGb+UwFhdmNtJW47FxzrCKqZPaW57WqZo6rK+KwlqOTyg++wQ3F32Fz9bSbJWFcC8IbAWDvl6rF7vTSMV6H4DRrcDJgDrm+uKcJYipouo6Ja/dtJJRboQ2pH5IculnxJ4vBLzHSwOQZ57kIBpEreETV5tADeOMKVz9b0K7i2b5EPdi/P7HWFmm1M+1uFUVnUcXeTgQxLVRv6d4ggpA48HtY6x9e4ZGYp4NvoVJL7HSOcyEHAOsc1vrCD5F70N1iPyo1UGx1bZsI
X-MS-Exchange-AntiSpam-MessageData: V7XANPzWkWAIvxMnGosF4eesIm+A/9y+Yldn7tvuf/cdnnYr477rDqM641dc4nT411/dMHog3cBzdeKuT4qSuJ9RnS55VcWAT21Y4ATD+cQMBdGx86n0uaju7/5YCGe+YHlw7lJv7FVqms9ZZoYVPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e83db4d-2e50-4995-4677-08d7a73bf535
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2020 17:27:05.8301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWx+1oflDSTbBcNhA7PwQdOJO04XQOi8Dhxk6ODkKzVMGgedkQ1kT1tS1FZQDpktNIJcAf8b7L1AWP+nzGIxgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2973
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/20 5:23 AM, Tomas Henzl wrote:
> Add a flag to dma mem allocation to silence a warning.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
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
>  open-isns-updates.diff.bz2
>  		fusion->io_request_frames =
>  			dma_pool_alloc(fusion->io_request_frames_pool,
> -				       GFP_KERNEL,
> +				       GFP_KERNEL | __GFP_NOWARN,
>  				       &fusion->io_request_frames_phys);
>  
>  		if (!fusion->io_request_frames) {
> 

I'm fairly sure this is a good fix, but I'd appreciate more information
in the comment, such as what warning was silenced, and why it's okay to
silence it rather than "fix" it. I know from experience that, when
choosing which commits to backport, more information is better than less.

-- 
Lee Duncan
