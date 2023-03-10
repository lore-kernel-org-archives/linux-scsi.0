Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEFFC6FA99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 15:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjCJPDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbjCJPDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 10:03:03 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A0126F11;
        Fri, 10 Mar 2023 06:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0myRaItko04nq8Fcw1DEu5P8f/p64+saYSpPP45QzGJwO1WVWmG/KauIJ1Ih+ATcCViAHDcmMqP66WvwgMaPSB6H6kr7vFeW2XiXdaIEWlBCF9Aupcrl8sSWxA03KYoJlRzUXuuj25BApPE+Z/BowuXFtXw0eRy6WA1dYGr8khJzaVDMB18IyvH//kMOz2uIPMJ2Gvht9oCSjwGwE1h17jMflI7IWGO8gj9szpNe5L8ee5nc4yD5kczAyIfbqV0hrILQPst0XgAIi7lJ1cytqKdl+NI5g5s48I6sQon0+QYnEAZhvb9NaVrh29bUyS7r7rKuiDddmpljJPQKdLstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afB7vSyfhMc/zmB1oyQ7R8XRzhOJeTy+rXQaD20OIXg=;
 b=TLYqXel3YrL7SkhT2UiDBEb93nQzO8xF+4HhUsSVWUoJf5CjSgmkczsQD43+ltE3dkVDp1mRMT8psjZOJ4UaqtyVPQwiF6SdP840buPVrxUqQnvNwlXMfybR9IbhtOp2taqSpuNE1MbrgIEYZe6T9q8Ak37/fjcc5F9FEGQKPOARY7Qky8N+slXDeH+NktXMdj8Sisrqdt/x0AdJDZUAUJIzcCuxAWVUvaQINyUQmmTR97CD/gfts140brlPEb3hu8IeHkvEdYFcncnQPelOTxs7J2d9D4VqRUnVtyzFjCIoO1IpH14M+DKqqaOMR/X/Gp/Mn1FLk3STPVt9atWcpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afB7vSyfhMc/zmB1oyQ7R8XRzhOJeTy+rXQaD20OIXg=;
 b=dy4aSLhPJ3iEHI9bhuyRi7QcPzPq/Zx//4T/hnjolKyvKZwGIqcNytYaGRysvvEl5sf/92x7YOQbDdjiQtrWTcTy3WAMH2CKIs0R2JZYKRd7AujjZKP4yayd43R/3/JbgiQa8wY1hGcGthCfeO0l8GvP71deaurjd8Z7ggT3A7gRnA0dJhjVJYz87eQC1Mlwo4rPru02byDyp4hkrA+wgTV+wjwhYF+MelzQsdE6JWijNzpBq1DiLbYDiQ/9ulBmEqo91yDO+OMePb7HU8XTp8hIOnCEl1tBi9HlzkZ1wpqwHLs4AYyNTnqUKBHIb4ERJWE9onTodJ76uXS5yEc9hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 IA1PR12MB6065.namprd12.prod.outlook.com (2603:10b6:208:3ef::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.17; Fri, 10 Mar 2023 14:54:58 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 14:54:58 +0000
Message-ID: <709a7ebf-22d8-7349-d852-9324eb61e3cb@nvidia.com>
Date:   Fri, 10 Mar 2023 14:54:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 04/82] ata: Declare SCSI host templates const
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Ondrej Zary <linux@zary.sk>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-5-bvanassche@acm.org>
Content-Language: en-US
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230309192614.2240602-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0091.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::6) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|IA1PR12MB6065:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a8136b-cec8-4d99-5868-08db21776aae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7U5sMBF7Raa+VhBBO3pMeldodpTNTDJ5owE27zkpJ0PIXFbWB9oVrRCruedNxRQSgSItzuk0q7O6U816QXDiJbCf7AFVp1Loby7xieUva7DBlcR4P+bviczCgP+jLLE9mYpm8MIXUq4iQ6XBvGTs0ig7EjI83V2Hgj0AUX+fYkbhMnYThsfU6YREL5UBxUoBfHGBnIskMdOiS96wJBzsZeB9t6JGA188590JB5e99bfVNT/D5mls21qypM3roh/LIGJygGPxXLfgbTlPaQjFnK54aANEvsBs3aveksBdrb8q3en50tPa3sjy19w0dWQRZog3TO/VfQfxNEaijhnY1hFZPhWkYeqTqsN9r0piEhYtIWgenQpgEiZQFQATZEWgfZkFC/NSLzLymuM5eTea1QVQ5M+i9DX+Qe1Y2nGYMWJ73KLnk9a2lillG8y0NKTCNBSr/SxBm4Tn9S+MeirEgBUQD3m+8kZKsjywe2KDplcUDMmO9UW9u6OHYIDb36p/J9KwWd7bWb3AxX3mJlcXlRZp7LPsaKTBsYP8NMeVaFQmmGqyLVhBZvpjG0xG0iyifcxF5ZxHC4jZfHLBSPJZO7PZ9UCCrSs5WEHwhpzy0jIedy95iSB9cI5V4OK+qKZhC1Uu57sCZ1/gPo5s6R1RcNPVBfCAMtCSUyfYbjquZKRxg4ir/f1WgDYm2pCF1HxHgMHtZjO8Fk2CuclFWwcZ5gWuS7Z0QJNmuPUeVUDvwkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(478600001)(83380400001)(38100700002)(316002)(54906003)(5660300002)(7416002)(2906002)(36756003)(41300700001)(110136005)(31696002)(53546011)(6512007)(6506007)(6666004)(186003)(31686004)(66476007)(66556008)(66946007)(4326008)(2616005)(8936002)(6486002)(8676002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3NERS8rL2ZLcS9nYnBBaklvTkJEeGtLd1BBeXhtNjBVc2pLb0lsNkJDMFVW?=
 =?utf-8?B?dHczVDgwQzRIbXY5OVF0QUxVVlpHb0tlbmhVa2h1TVJsTmVuVDN1NnJKVkdX?=
 =?utf-8?B?WGdxbHB3REpPQlVUbC9mckR6SFZRNW9sT1BMSk1uMG5ZelJXWjlHakdwVE0r?=
 =?utf-8?B?UnB0WFQ0b2IvNGxkTE44V2hVUlBsbTlBbGtvWUxWUk9vU2ttTitHeDRFRGZk?=
 =?utf-8?B?U0ZXb0tCNjJGTGVoTjV0aWRDLzV4aHhJQkV1QWhNUnU0bFdjVkdoelRlMUlB?=
 =?utf-8?B?R1M1VzI3UVBQV0t6ZmdSWHlRV2NFVStvekp0Y1J3aUthc2lUSnA0TW13RWFR?=
 =?utf-8?B?R2llL0RzZTFmdTJKWkNudU5SSVAydis5Q05senVmMmZUaDh2Wnhhb3BHRE9z?=
 =?utf-8?B?TGFvSTAwREJXbkdodlpnQlpQaDUwQWxPSWUxSEdNMUoyUTVqSU9CRlJkdWFR?=
 =?utf-8?B?SlRxcUdQdUFDbTlkWUZKUW5UdHhGK3JYU1ZaSk10d01zZWU3Ry9RT25DanRO?=
 =?utf-8?B?OXhyWE9lYW41YXNmRnczN0xkVzJVeG93RkJUcHlpU2pnSm5BYnlIV3F0Mzli?=
 =?utf-8?B?d20wazg2Rkx4R09hZjg3MURWbzZoNENSU0wwck1lUVd2UWsycUZCYjAreHd0?=
 =?utf-8?B?WkdNdHN6cGxJNFFSL2VmS0JmcVZKMEh2YVNycjJzMHp4NUpDMW9nb05jbDdk?=
 =?utf-8?B?emZ2Q05NWnlJYWJiMi9lWFJzb1RwZjZYNlRibnRmV28ydzBlb1hPNERPRHBF?=
 =?utf-8?B?YmU0V1BFeVIvUTBJQzFsRFlhUlFOdFl0VnduaXd0V0VTRzdxTGZSUmJJMkli?=
 =?utf-8?B?MWtBYUpncG1JdExBZnFFVS9NUU9WNnIzQXYvclBWVzlKd0FHYmVabG0vVExh?=
 =?utf-8?B?VS9WRUlpb2FYeERJMnpxZ3JZUE1BVlpWbTQwajUvYkR3WjcrWnBRUGh4M0pw?=
 =?utf-8?B?WTVwSnVlUFBOd0s2N0s5enJOOVBaSnMxKzJkSWZjZDhJUGtFSk94QXYxbXV2?=
 =?utf-8?B?ems0TjdhRTJXb0V2ei9hZ3NleEtMQmpXQ09wTWl6dXpXaUVaMXF4cGdhbTlI?=
 =?utf-8?B?ZXk2dTVsWmJDUXFpekg0RmtiZ244S09tWDV1UHkvd1JDZjcrK0lESDNsamhj?=
 =?utf-8?B?blV4LzhxaXRtT09xV0JINXVIbHhXaGpVcms3V3BQUGNlM29Va1ppNUtWcnYy?=
 =?utf-8?B?dG4rTHlXbldrVDNQdGhHK1czWTl0Y0dKMW42WW1mMW5IcUMwQWZtRTgrMVpm?=
 =?utf-8?B?MXNzTFY3L1dxR085WW0zTE9BY1luOGhHaWorekZPQnBTT1ZCdmZtbGowbW5h?=
 =?utf-8?B?UEFXWmJ2ODVuTFZJZ04yT1VYb2VWUjVITlVwcUJ1TXU2UVBNTklWcnFPcm5J?=
 =?utf-8?B?c3BUK1FFTS9Yb1dIOXJyVWVMaE85ZjVManZrUkx2dXRBdjhKdXJXdWkyLzRG?=
 =?utf-8?B?NDRLTHI1dTJzdWxLODMvSUtPdWNVTEVpTmhsamN3Um9WTmVWU3ozdFlhUG9o?=
 =?utf-8?B?cURkMktlUUxkSDBleWsrd1NMbjRQSktsZTZPcVVoeEk3aVBVWWcxM2plWGc0?=
 =?utf-8?B?VUpFNlFtbWhpakxleFhGTWc0Rk9CajlWQlp1MjBKM0o1Q1Z4QU5FOXdHZHF3?=
 =?utf-8?B?UEtVd0dYK2R3L3RIRUNUUTV3cm12WmtSR3JTMUtnVTZDZnIyK09rOS93TGhl?=
 =?utf-8?B?c1ZZWVZuZ0lzeGpqeVFmVGQ4VWRUUW9Gd3ZpNWEwbGdOSzFZYlZzbDdUcmlG?=
 =?utf-8?B?WWxERmRWaXBRTkdNa1dIdWRxbUcydFdKYnc2S1FRTm5UcWsrSUxRSUIyeFhG?=
 =?utf-8?B?STFLR3lDQW50WGcrMzNWUnBtdlFNVkk4c2hXc2lMbTk0QzBPMGlUOGhDV2xX?=
 =?utf-8?B?K2R6YkJDa0xqTmZ2Z0Y5UTA4RjVGTk1UVVpEdS9aeTUyM3gyUEhlRHVncWJJ?=
 =?utf-8?B?OHBLaWVSRlR3NG1URmExYUZxaXVJZit5aGUvV25CSjl4ak5XQVlFVXBudUpP?=
 =?utf-8?B?M1V5aHptdXUrNTFlNkY0VnNlaGtvTXZyelZkd0pKRUdiQnhONWROeFhpSGdI?=
 =?utf-8?B?S1VNUnI4RFJPK3BKakpLbnFGYVBOS2hJY0RRODd6OEl0NEFMSm1ZdEM1dG96?=
 =?utf-8?B?T29ydHE0czhUQUdFcy82M2kxMzRPTUs3cTlhL0llRVdOa1duditVMHAzSlFL?=
 =?utf-8?B?RGJCbmtnQWY2Uk1wU2Fna1Y4VXZLYWtXSmc4SzQvQ0dGMFhIeXhYN3ZJWnVI?=
 =?utf-8?B?ZVBRcEZoUGdyRG5kM3hWRVRvR1pnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a8136b-cec8-4d99-5868-08db21776aae
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 14:54:58.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZxtQ6Fm5eFIMu94EaECEU9jpzEJkziE2uA19TUMZzV1AgveAzu+QwVKT5BfYQ29V3aZ/R+aer1/staAso3ICg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 09/03/2023 19:24, Bart Van Assche wrote:
> Make it explicit that ATA host templates are not modified.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ata/acard-ahci.c                |  2 +-
>   drivers/ata/ahci.c                      |  2 +-
>   drivers/ata/ahci.h                      |  2 +-
>   drivers/ata/ahci_brcm.c                 |  2 +-
>   drivers/ata/ahci_ceva.c                 |  2 +-
>   drivers/ata/ahci_da850.c                |  2 +-
>   drivers/ata/ahci_dm816.c                |  2 +-
>   drivers/ata/ahci_dwc.c                  |  2 +-
>   drivers/ata/ahci_imx.c                  |  2 +-
>   drivers/ata/ahci_mtk.c                  |  2 +-
>   drivers/ata/ahci_mvebu.c                |  2 +-
>   drivers/ata/ahci_platform.c             |  2 +-
>   drivers/ata/ahci_qoriq.c                |  2 +-
>   drivers/ata/ahci_seattle.c              |  2 +-
>   drivers/ata/ahci_st.c                   |  2 +-
>   drivers/ata/ahci_sunxi.c                |  2 +-
>   drivers/ata/ahci_tegra.c                |  2 +-
>   drivers/ata/ahci_xgene.c                |  2 +-
>   drivers/ata/ata_generic.c               |  2 +-
>   drivers/ata/ata_piix.c                  |  6 +++---
>   drivers/ata/libahci.c                   |  4 ++--
>   drivers/ata/libahci_platform.c          |  2 +-
>   drivers/ata/libata-core.c               |  4 ++--
>   drivers/ata/libata-scsi.c               |  2 +-
>   drivers/ata/libata-sff.c                |  8 ++++----
>   drivers/ata/libata.h                    |  2 +-
>   drivers/ata/pata_acpi.c                 |  2 +-
>   drivers/ata/pata_ali.c                  |  2 +-
>   drivers/ata/pata_amd.c                  |  2 +-
>   drivers/ata/pata_arasan_cf.c            |  2 +-
>   drivers/ata/pata_artop.c                |  2 +-
>   drivers/ata/pata_atiixp.c               |  2 +-
>   drivers/ata/pata_atp867x.c              |  2 +-
>   drivers/ata/pata_buddha.c               |  2 +-
>   drivers/ata/pata_cmd640.c               |  2 +-
>   drivers/ata/pata_cmd64x.c               |  2 +-
>   drivers/ata/pata_cs5520.c               |  2 +-
>   drivers/ata/pata_cs5530.c               |  2 +-
>   drivers/ata/pata_cs5535.c               |  2 +-
>   drivers/ata/pata_cs5536.c               |  2 +-
>   drivers/ata/pata_cypress.c              |  2 +-
>   drivers/ata/pata_efar.c                 |  2 +-
>   drivers/ata/pata_ep93xx.c               |  2 +-
>   drivers/ata/pata_falcon.c               |  2 +-
>   drivers/ata/pata_ftide010.c             |  2 +-
>   drivers/ata/pata_gayle.c                |  2 +-
>   drivers/ata/pata_hpt366.c               |  2 +-
>   drivers/ata/pata_hpt37x.c               |  2 +-
>   drivers/ata/pata_hpt3x2n.c              |  2 +-
>   drivers/ata/pata_hpt3x3.c               |  2 +-
>   drivers/ata/pata_icside.c               |  2 +-
>   drivers/ata/pata_imx.c                  |  2 +-
>   drivers/ata/pata_isapnp.c               |  2 +-
>   drivers/ata/pata_it8213.c               |  2 +-
>   drivers/ata/pata_it821x.c               |  2 +-
>   drivers/ata/pata_ixp4xx_cf.c            |  2 +-
>   drivers/ata/pata_jmicron.c              |  2 +-
>   drivers/ata/pata_legacy.c               |  2 +-
>   drivers/ata/pata_macio.c                |  2 +-
>   drivers/ata/pata_marvell.c              |  2 +-
>   drivers/ata/pata_mpc52xx.c              |  2 +-
>   drivers/ata/pata_mpiix.c                |  2 +-
>   drivers/ata/pata_netcell.c              |  2 +-
>   drivers/ata/pata_ninja32.c              |  2 +-
>   drivers/ata/pata_ns87410.c              |  2 +-
>   drivers/ata/pata_ns87415.c              |  2 +-
>   drivers/ata/pata_octeon_cf.c            |  2 +-
>   drivers/ata/pata_of_platform.c          |  2 +-
>   drivers/ata/pata_oldpiix.c              |  2 +-
>   drivers/ata/pata_opti.c                 |  2 +-
>   drivers/ata/pata_optidma.c              |  2 +-
>   drivers/ata/pata_parport/pata_parport.c |  2 +-
>   drivers/ata/pata_pcmcia.c               |  2 +-
>   drivers/ata/pata_pdc2027x.c             |  2 +-
>   drivers/ata/pata_pdc202xx_old.c         |  2 +-
>   drivers/ata/pata_piccolo.c              |  2 +-
>   drivers/ata/pata_platform.c             |  4 ++--
>   drivers/ata/pata_pxa.c                  |  2 +-
>   drivers/ata/pata_radisys.c              |  2 +-
>   drivers/ata/pata_rb532_cf.c             |  2 +-
>   drivers/ata/pata_rdc.c                  |  2 +-
>   drivers/ata/pata_rz1000.c               |  2 +-
>   drivers/ata/pata_sc1200.c               |  2 +-
>   drivers/ata/pata_sch.c                  |  2 +-
>   drivers/ata/pata_serverworks.c          |  6 +++---
>   drivers/ata/pata_sil680.c               |  2 +-
>   drivers/ata/pata_sis.c                  |  2 +-
>   drivers/ata/pata_sl82c105.c             |  2 +-
>   drivers/ata/pata_triflex.c              |  2 +-
>   drivers/ata/pata_via.c                  |  2 +-
>   drivers/ata/pdc_adma.c                  |  2 +-
>   drivers/ata/sata_dwc_460ex.c            |  2 +-
>   drivers/ata/sata_fsl.c                  |  2 +-
>   drivers/ata/sata_highbank.c             |  2 +-
>   drivers/ata/sata_inic162x.c             |  2 +-
>   drivers/ata/sata_mv.c                   |  4 ++--
>   drivers/ata/sata_nv.c                   |  8 ++++----
>   drivers/ata/sata_promise.c              |  2 +-
>   drivers/ata/sata_qstor.c                |  2 +-
>   drivers/ata/sata_rcar.c                 |  2 +-
>   drivers/ata/sata_sil.c                  |  2 +-
>   drivers/ata/sata_sil24.c                |  2 +-
>   drivers/ata/sata_sis.c                  |  2 +-
>   drivers/ata/sata_svw.c                  |  2 +-
>   drivers/ata/sata_sx4.c                  |  2 +-
>   drivers/ata/sata_uli.c                  |  2 +-
>   drivers/ata/sata_via.c                  |  2 +-
>   drivers/ata/sata_vsc.c                  |  2 +-
>   include/linux/ahci_platform.h           |  2 +-
>   include/linux/ata_platform.h            |  2 +-
>   include/linux/libata.h                  | 10 +++++-----
>   111 files changed, 129 insertions(+), 129 deletions(-)

...

> diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
> index 4fb94db1217d..8e5e2b359f2d 100644
> --- a/drivers/ata/ahci_tegra.c
> +++ b/drivers/ata/ahci_tegra.c
> @@ -506,7 +506,7 @@ static const struct of_device_id tegra_ahci_of_match[] = {
>   };
>   MODULE_DEVICE_TABLE(of, tegra_ahci_of_match);
>   
> -static struct scsi_host_template ahci_platform_sht = {
> +static const struct scsi_host_template ahci_platform_sht = {
>   	AHCI_SHT(DRV_NAME),
>   };


For Tegra ...

Reviewed-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
