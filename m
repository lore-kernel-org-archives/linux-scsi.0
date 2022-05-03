Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20FFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 21:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbiECVGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 17:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbiECVGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 17:06:13 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FE940A10
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 14:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1651611749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0s2wArbV5OubHcNUt6O35iwpmt60Za5gOnzRIkcx0zU=;
        b=bs8JMGARI2KnvgOPl77wD41bGY61tUBUCRXZq9iUlfpAxNB5ixYwgOvg3PLFnLfLKHnIYM
        ZmhoEmg/WXL+S8fOEDCx9xCPYoHpq2bdYxaEVHNnuhMEwaq0g1W+NGvY2MzBkTIVK6f6gJ
        IZR/VKe3c/WRa67sWQICh7tJFtnr1uk=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2054.outbound.protection.outlook.com [104.47.0.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-25-OcVz460NNZqcRVnLS1A9pQ-1; Tue, 03 May 2022 23:02:27 +0200
X-MC-Unique: OcVz460NNZqcRVnLS1A9pQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE1o61njpKoyYcjPaCvGyn/Bqwjyc/5xfOGQVQNBBD0ZoBXh6otOdWniL/pIAHTfr5+hee0jfKsJje4/VKbmM90YXSspE9/Tn4w2QiwdrSOZT+hser2kQYYynITVtZf6TEvtnS+vZQMli9yXbnxMqdPnl0LIS6K5TUOyEPUNvOO26J/QfDEAdoVqZZwNP1pupzaGkzVwWfCHF5LUnW2iEO0rAA3P+fcS4XsfPdqCViPzu+IgK53H77Z1tojthRAOC6RrCr/kd8VWAAF4LolORakF0o7GnJ6IvR3Cpv8e4T/A4RK3o/+bd/fWrLGurpNj2Ymd3nNn8E87eR5PFXZGDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0s2wArbV5OubHcNUt6O35iwpmt60Za5gOnzRIkcx0zU=;
 b=Yuh1+Ok3xUr3ppfeV/f0TMBgRn/KomvKvGvXhPojkPp+WU6ik3bjAYrOKFYy5gSqSBzthjE7RxsrDNezpiQ/UJ11ngNOcE1WI6WAtCCtELeiv5B6iILVQf1tyz2Fb2qJVflvJNKL7PoH4cEITH6o9uHgoqUgnDm5lqiiPqf4aSPGj7VbbvThPITWabVRYpdEP3bTYxflXkD/Of64o2PYQ1Ac3Lv/9f3vVhB6xKuIQAH8Y8kMPe7KoZ4CwO00yNqzrNJ1hLsbXkEe/K9jMNcNuKo2rh6gVMg+su1F7trf85IJ9mE1yiZ/pYyIeJ66CkxANl+SA9OQbZh5p4ST5WoqoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6116.eurprd04.prod.outlook.com (2603:10a6:208:13c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 21:02:24 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 21:02:24 +0000
Message-ID: <aa1cee11-8436-929a-9660-cbe8c9929aef@suse.com>
Date:   Tue, 3 May 2022 14:02:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/7] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
References: <20220502215953.5463-1-hare@suse.de>
 <20220502215953.5463-3-hare@suse.de>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220502215953.5463-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:806:122::31) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee31938-8d03-4c7b-7506-08da2d4838dc
X-MS-TrafficTypeDiagnostic: AM0PR04MB6116:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6116D4F7DC60E86AA167C052DAC09@AM0PR04MB6116.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tvI7trHB7kR7E3ntI483gh3Oq8hLrqFtzpeO4P8uuleEw+3KLOc9UL85y19GzHgKMapElWf0Vm8FDPeyTiEbwpmBajuUjcNVRZcTtw2EygNQnTb0Pb4FvJYB06mOGBrtK30kygIXXCJf1Tj5p5DVWqH5ooGt9P3Hi3fmV7pkv19VvVTSg0S0ke5Xg0+rIrjF/FiN7P0vVkJBT+uwZ5sCbYQWo+lbJ7zGC3d7PiNGmAmzN1tiZ05ExM3XIFBwduTYEtZmJW5Ob4U+2Ob+zWYh/y6L7q/P2zNjn/GljhU9YEi6krTIMwsp3YPllrvbvgc4N7Y6JrF/bW7A65f9btSWQOncUdc8DLnZaynTUwyf5mJHGUx711kNduVmG7Qm2avei1H+tFhMskcS+a1y2cEBKQC9f5Wo/0/dbn8+Jn13pZmq99Zp6Z+OWqOo5vci+45zr+ziatDwL3e/2hfftYk3F2A+YJZfMaCTEOylpZl1dVUZ1F/flQrYetNDv+VQoSwSC4k7piD0G9GNzvQtJiAW74PrBXn5N4ijQeWE+KPyaHBYmpdoWZbcPx7MoiVut/7rQ6hI1OQb9HyEY5MqYU/HDK7dVXixk5yGf9P19yAiRE1PKTFZ69UUGCAStSObdpXS/ot6EYMZ9RnfufpBvOXy3hKmwOnu9JzyHaTLuJCKqQ7O0Q0H5RPRcA3tecej5UheUbnlzh8wMXXRkh/CrsVRFV35p1C/5XqNZvBwSbxc+/E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(53546011)(6506007)(2616005)(83380400001)(2906002)(31686004)(30864003)(8936002)(36756003)(6512007)(5660300002)(508600001)(86362001)(66476007)(6486002)(4326008)(8676002)(66946007)(38100700002)(6666004)(66556008)(186003)(54906003)(110136005)(31696002)(316002)(43740500002)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZStuTHpvWGVvQmtVdjhKQW1kcFQ2YmwvTmdTMjNBOGlDU1pwUm5zYkRYYzVw?=
 =?utf-8?B?NzVyRlZHWDQxOE40bGRodnRpVy9IOFdoY2R1d0YyaUxXMnF2bjRhd3pjY1FU?=
 =?utf-8?B?VDJySmJhR0xaK0pSYWYwMXMvVHlKVkMyK1lpK0FVNzg1MjZwNVovOWFuRWlq?=
 =?utf-8?B?SWV2RHdaVlhtd3AxZC9zQisreTZ5SGNpRldrT1dZd1ZLSUwrT1lmOWNQNzNy?=
 =?utf-8?B?VzVhKy9ZYktlckx0SUE5UFdIWWN2dnNLL2hhNHZsZmRnbGVVckRrUXlHZWZv?=
 =?utf-8?B?QUdkSlBpMWtqQVo0MGhTSTNtM1JjajJsekhmeDMyY3pGVGRZWDJvZHdaWlFw?=
 =?utf-8?B?bmtQMXdwQm40MlpiZWo0TGdITzlRL3lNMmZ0L2N2V3VFMmp0aUlqOVlycHpY?=
 =?utf-8?B?aFNseGh4R0tzeXFTS09mak9Id3lDWVJoVDRjR1JKK2dqMVFSWnk0bTR3eE1M?=
 =?utf-8?B?ajZmVTQwZjJaeGduY0xnUUFOSVE3TWpzVlp0cndualNZZ1pzdk8wb3hlU3ZL?=
 =?utf-8?B?RXo0NXZJcUo5dDhWQ3J0VW5tVkIrZkRBTlNES2NvazdudFNRS3JUQ1h4S21H?=
 =?utf-8?B?L0kybXFDTUhxblcxOTF1M3JGV3JPODBRU3RhY1FvWEtwZ28yQ0ptOEFXQmxH?=
 =?utf-8?B?SmlQOXFCRW1ZR3hQc1B2YVdpMjkvbkUxcHJWRFdxTXNaaWhKam5uaExHbm9h?=
 =?utf-8?B?Z2M4emNWcTBUSjhiWmRjZDhqWmdlcUh3SGprNDc3cnFJdU1TZXNQamVwTVJ3?=
 =?utf-8?B?ODNaY25VZTVhbURVT2d3TngzUitjQ2dpem5aNU41NHBGOTZXQitzRWtZSUYy?=
 =?utf-8?B?ZDF2RUg3N1BQR3RpNmwxd01jd212S2hTb2NrcUxYc01NYzBqSVhJSDhmaU0z?=
 =?utf-8?B?MDJkdVovRmRPbTgrK1pqS1lSdXVDaUNuR2Fqa1RyRU9ma2pqcnN5M1NuL0lR?=
 =?utf-8?B?TWE2ZGcwSzFuQ2Y5R0ozViszWVlZSFlUMTg0VzZvWjc4azYvNnRWTnRPZ0Rj?=
 =?utf-8?B?UGI5QkpNSkRzQmNNbS9jNnBnMnE5YXRCQXBIaGhvU2pudFJMa295RUJtREJR?=
 =?utf-8?B?cCtNUXp1dy9BTUZVZDRlRnpPZlVZR2w3ZE4zNDNBaHZ1ZzF6RWduZmhYTWxU?=
 =?utf-8?B?Ni82S1M4V0U1b3Jwbi9YQi9jUkdhMWVXN29XQ2pCWU9GUVZGeG96TjBhSEFv?=
 =?utf-8?B?a3lqZDlOWk5RenVrZlVzdk5qMTJEMGpEVEVsZlpzMm4zbUxIWHVHMnM0MlNW?=
 =?utf-8?B?QmxTYm92NzdaSTBZM2lBTXExTUhWZVMzeVJwTUx1VFF6cmIzRzBIVC9pYmxZ?=
 =?utf-8?B?OVR2UjRmalF5QUQwY09zdjVYejJiRWR6elBtK0o5NGpXUEtXcEdOeUVwOTFl?=
 =?utf-8?B?cSt2d20wZm52TE5vRmtlUkhDY0VhQXpscGYvSUFka3U2TlVxQ0dKT0JDR2Y4?=
 =?utf-8?B?ZDJSYXZSTndXYWxQQStjWXcxVE01ZnNleEpKNFZBNTM2Q3ZnZ1FCakhWRExI?=
 =?utf-8?B?YklqWndzZUdOME94c1gzYzA0YWNHYW9sR1liMm9tU21neFVYNjhvMCttU2pV?=
 =?utf-8?B?Z2hOR05tWnpXdVNEYjVnZzhkbHNuVjZ2bEhNMVpoRGpLaXhBd1Nmbk1lK0dn?=
 =?utf-8?B?UldiYkZlemJ0UThaSFRyaDI5R3JGd0xKUHNFRStNdVZoMUFOWFJXTWF2V1E0?=
 =?utf-8?B?OStHNmNIdFhXTW1rd3NYTHlqS1dpaVNoeTNFUjEyc09DdkJGaHpQVDdpSGE2?=
 =?utf-8?B?RkhmUS9RSEhBYUdoa25NbXp3WCt5M1A2ZzBRTzNPc2NiMDNLZ3FvSjJVaFQx?=
 =?utf-8?B?WVlPK0R1OEwweW52QnpkbXZEVlFoQUpodTZRSTZla3pORDM2UmRmeTdSa1l3?=
 =?utf-8?B?NjNPKzlsaGtqMnEwVEhKSlVhbUYzYXEzQXNYODhaQVV1Tml5ZXNoLzVvaDgr?=
 =?utf-8?B?UnI5ZlpXYVEvUkFQdS9nWjZGWkVRNEdXOTlSdUMwdlNmTldGS2haUURyQlJH?=
 =?utf-8?B?bkJnbEV2S0pBZHdkUUlLV2UvVmNPd1ZVdkJwcHdGcjhGeHJNQ1hCemVjK3NJ?=
 =?utf-8?B?RXI1akptWHRlMFI4YzltaCtEdG5jYmdhYlVDK0NSajRWMFl5OUpSRW1CNTFT?=
 =?utf-8?B?elE3bm5WTThBeUxxL1hPTlBKaE8yc0xnZ0lXWTFlTi9pd1NwSUhYVHpUTDJP?=
 =?utf-8?B?VGlHT0VOS1hTeG9VUi9xVW1mTnphRUM2ajZScUxKUGJSWjl0S3ZNd2huWVhW?=
 =?utf-8?B?YW14cEd6bjhLQkZqamFkNUZ6dUlXTXFoN05RMk1OTzNjcTRNaHJ6TWRCVyt5?=
 =?utf-8?B?K0xOOFhDTHNOaTJRS0R4Mkk0TEN2aDdWc2NlWDlHN1AzT1VzYmRXUT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee31938-8d03-4c7b-7506-08da2d4838dc
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 21:02:24.4963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhO0/MR4sj29Bd98ENR5/uu3SiEdCWFCxmefaA5eYrbbpC77dVZ1ooiQ0Qja1ODkTtcmHfMUZ0LoZ99KIUzcIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:59, Hannes Reinecke wrote:
> Issuing a host reset should not rely on any commands.
> So use Scsi_Host as argument for eh_host_reset_handler.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   Documentation/scsi/scsi_eh.rst                |  2 +-
>   Documentation/scsi/scsi_mid_low_api.rst       |  4 +-
>   drivers/infiniband/ulp/srp/ib_srp.c           |  6 +--
>   drivers/message/fusion/mptscsih.c             | 19 +++++----
>   drivers/message/fusion/mptscsih.h             |  2 +-
>   drivers/s390/scsi/zfcp_scsi.c                 |  3 +-
>   drivers/scsi/3w-9xxx.c                        | 11 +++---
>   drivers/scsi/3w-sas.c                         | 11 +++---
>   drivers/scsi/3w-xxxx.c                        | 11 +++---
>   drivers/scsi/53c700.c                         | 39 ++++++++++---------
>   drivers/scsi/BusLogic.c                       | 14 ++-----
>   drivers/scsi/NCR5380.c                        |  3 +-
>   drivers/scsi/aacraid/linit.c                  |  6 +--
>   drivers/scsi/advansys.c                       | 26 +++++++------
>   drivers/scsi/aha1542.c                        | 20 +++++-----
>   drivers/scsi/arm/acornscsi.c                  |  8 ++--
>   drivers/scsi/arm/fas216.c                     |  4 +-
>   drivers/scsi/arm/fas216.h                     |  6 +--
>   drivers/scsi/atari_scsi.c                     |  4 +-
>   drivers/scsi/cxlflash/main.c                  |  5 +--
>   drivers/scsi/dpt_i2o.c                        | 14 +++----
>   drivers/scsi/dpti.h                           |  2 +-
>   drivers/scsi/esas2r/esas2r.h                  |  2 +-
>   drivers/scsi/esas2r/esas2r_main.c             | 16 ++++----
>   drivers/scsi/esp_scsi.c                       |  4 +-
>   drivers/scsi/fdomain.c                        |  3 +-
>   drivers/scsi/fnic/fnic.h                      |  2 +-
>   drivers/scsi/fnic/fnic_scsi.c                 |  3 +-
>   drivers/scsi/hptiop.c                         |  6 +--
>   drivers/scsi/ibmvscsi/ibmvfc.c                |  4 +-
>   drivers/scsi/ibmvscsi/ibmvscsi.c              |  4 +-
>   drivers/scsi/imm.c                            |  4 +-
>   drivers/scsi/ipr.c                            |  4 +-
>   drivers/scsi/ips.c                            | 22 ++++-------
>   drivers/scsi/libfc/fc_fcp.c                   |  5 +--
>   drivers/scsi/lpfc/lpfc_scsi.c                 |  3 +-
>   drivers/scsi/mac53c94.c                       |  8 ++--
>   drivers/scsi/megaraid.c                       |  4 +-
>   drivers/scsi/megaraid.h                       |  2 +-
>   drivers/scsi/megaraid/megaraid_mbox.c         | 14 ++-----
>   drivers/scsi/megaraid/megaraid_sas_base.c     | 34 ++++++++--------
>   drivers/scsi/mesh.c                           | 10 ++---
>   drivers/scsi/mpi3mr/mpi3mr_os.c               | 12 +++---
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c          | 11 +++---
>   drivers/scsi/mvumi.c                          |  7 ++--
>   drivers/scsi/myrb.c                           |  3 +-
>   drivers/scsi/myrs.c                           |  3 +-
>   drivers/scsi/nsp32.c                          | 12 +++---
>   drivers/scsi/pcmcia/nsp_cs.c                  |  4 +-
>   drivers/scsi/pcmcia/nsp_cs.h                  |  2 +-
>   drivers/scsi/pcmcia/qlogic_stub.c             |  4 +-
>   drivers/scsi/pcmcia/sym53c500_cs.c            |  8 ++--
>   drivers/scsi/pmcraid.c                        |  6 +--
>   drivers/scsi/ppa.c                            |  4 +-
>   drivers/scsi/qedf/qedf_main.c                 |  4 +-
>   drivers/scsi/qedi/qedi_iscsi.c                |  3 +-
>   drivers/scsi/qla1280.c                        |  3 +-
>   drivers/scsi/qla2xxx/qla_os.c                 | 18 +++------
>   drivers/scsi/qla4xxx/ql4_os.c                 | 18 ++++-----
>   drivers/scsi/qlogicfas408.c                   | 10 ++---
>   drivers/scsi/qlogicfas408.h                   |  2 +-
>   drivers/scsi/qlogicpti.c                      |  3 +-
>   drivers/scsi/scsi_debug.c                     |  8 ++--
>   drivers/scsi/scsi_error.c                     |  2 +-
>   drivers/scsi/snic/snic.h                      |  3 +-
>   drivers/scsi/snic/snic_scsi.c                 | 37 ++++--------------
>   drivers/scsi/stex.c                           |  7 ++--
>   drivers/scsi/storvsc_drv.c                    |  4 +-
>   drivers/scsi/sym53c8xx_2/sym_glue.c           |  3 +-
>   drivers/scsi/ufs/ufshcd.c                     |  6 +--
>   drivers/scsi/vmw_pvscsi.c                     |  5 +--
>   drivers/scsi/wd33c93.c                        |  5 +--
>   drivers/scsi/wd33c93.h                        |  2 +-
>   drivers/scsi/wd719x.c                         |  4 +-
>   .../staging/unisys/visorhba/visorhba_main.c   |  4 +-
>   drivers/usb/image/microtek.c                  |  4 +-
>   include/scsi/libfc.h                          |  2 +-
>   include/scsi/scsi_host.h                      |  2 +-
>   78 files changed, 269 insertions(+), 340 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
> index 885395dc1f15..12113cca5ad9 100644
> --- a/Documentation/scsi/scsi_eh.rst
> +++ b/Documentation/scsi/scsi_eh.rst
> @@ -215,7 +215,7 @@ considered to fail always.
>       int (* eh_abort_handler)(struct scsi_cmnd *);
>       int (* eh_device_reset_handler)(struct scsi_cmnd *);
>       int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> -    int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +    int (* eh_host_reset_handler)(struct Scsi_Host *);
>   
>   Higher-severity actions are taken only when lower-severity actions
>   cannot recover some of failed scmds.  Also, note that failure of the
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 63ddea2b9640..784587ea7eee 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -777,7 +777,7 @@ Details::
>   
>       /**
>       *      eh_host_reset_handler - reset host (host bus adapter)
> -    *      @scp: SCSI host that contains this device should be reset
> +    *      @shp: SCSI host that contains this device should be reset
>       *
>       *      Returns SUCCESS if command aborted else FAILED
>       *
> @@ -794,7 +794,7 @@ Details::
>       *
>       *      Optionally defined in: LLD
>       **/
> -	int eh_host_reset_handler(struct scsi_cmnd * scp)
> +	int eh_host_reset_handler(struct Scsi_Host * shp)
>   
>   
>       /**
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 285b766e4e70..de901dee6935 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2842,11 +2842,11 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
>   	return SUCCESS;
>   }
>   
> -static int srp_reset_host(struct scsi_cmnd *scmnd)
> +static int srp_reset_host(struct Scsi_Host *shost)
>   {
> -	struct srp_target_port *target = host_to_target(scmnd->device->host);
> +	struct srp_target_port *target = host_to_target(shost);
>   
> -	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
> +	shost_printk(KERN_ERR, shost, PFX "SRP reset_host called\n");
>   
>   	return srp_reconnect_rport(target->rport) == 0 ? SUCCESS : FAILED;
>   }
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index ed21cc4d2c77..3df07e024026 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1956,15 +1956,15 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
>   
>   /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>   /**
> - *	mptscsih_host_reset - Perform a SCSI host adapter RESET (new_eh variant)
> - *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
> + *	mptscsih_host_reset - Perform a SCSI host adapter RESET
> + *	@sh: Pointer to Scsi_Host structure, which is reset due to
>    *
>    *	(linux scsi_host_template.eh_host_reset_handler routine)
>    *
>    *	Returns SUCCESS or FAILED.
>    */
>   int
> -mptscsih_host_reset(struct scsi_cmnd *SCpnt)
> +mptscsih_host_reset(struct Scsi_Host *sh)
>   {
>   	MPT_SCSI_HOST *  hd;
>   	int              status = SUCCESS;
> @@ -1972,9 +1972,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>   	int		retval;
>   
>   	/*  If we can't locate the host to reset, then we failed. */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> -		printk(KERN_ERR MYNAM ": host reset: "
> -		    "Can't locate host! (sc=%p)\n", SCpnt);
> +	if ((hd = shost_priv(sh)) == NULL){
> +		printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
>   		return FAILED;
>   	}
>   
> @@ -1982,8 +1981,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>   	mptscsih_flush_running_cmds(hd);
>   
>   	ioc = hd->ioc;
> -	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
> -	    ioc->name, SCpnt);
> +	printk(MYIOC_s_INFO_FMT "attempting host reset!\n",
> +	    ioc->name);
>   
>   	/*  If our attempts to reset the host failed, then return a failed
>   	 *  status.  The host will be taken off line by the SCSI mid-layer.
> @@ -1994,8 +1993,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>   	else
>   		status = SUCCESS;
>   
> -	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
> -	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
> +	printk(MYIOC_s_INFO_FMT "host reset: %s\n",
> +	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
>   
>   	return status;
>   }
> diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
> index e3d92c392673..0faefe9c7541 100644
> --- a/drivers/message/fusion/mptscsih.h
> +++ b/drivers/message/fusion/mptscsih.h
> @@ -122,7 +122,7 @@ extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
>   extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
>   extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
>   extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
> -extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
> +extern int mptscsih_host_reset(struct Scsi_Host *sh);
>   extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
>   extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
>   extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index fb2b73fca381..873ccc60e4d6 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -371,9 +371,8 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>   	return ret;
>   }
>   
> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>   {
> -	struct Scsi_Host *host = scpnt->device->host;
>   	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
>   	int ret = SUCCESS;
>   	unsigned long flags;
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index cd823ff5deab..61af5c5eaccb 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1717,18 +1717,19 @@ static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
>   } /* End twa_scsi_biosparam() */
>   
>   /* This is the new scsi eh reset function */
> -static int twa_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int twa_scsi_eh_reset(struct Scsi_Host *shost)
>   {
>   	TW_Device_Extension *tw_dev = NULL;
>   	int retval = FAILED;
>   
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> +	tw_dev = (TW_Device_Extension *)shost->hostdata;
>   
>   	tw_dev->num_resets++;
>   
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
> -		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		     "WARNING: (0x%02X:0x%04X): "
> +		     "Command timed out, resetting card.\n",
> +		     TW_DRIVER, 0x2c);
>   
>   	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>   	mutex_lock(&tw_dev->ioctl_lock);
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 3ebe66151dcb..c4d1ebf15700 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1423,18 +1423,19 @@ static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
>   } /* End twl_scsi_biosparam() */
>   
>   /* This is the new scsi eh reset function */
> -static int twl_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int twl_scsi_eh_reset(struct Scsi_Host *shost)
>   {
>   	TW_Device_Extension *tw_dev = NULL;
>   	int retval = FAILED;
>   
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> +	tw_dev = (TW_Device_Extension *)shost->hostdata;
>   
>   	tw_dev->num_resets++;
>   
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
> -		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		     "WARNING: (0x%02X:0x%04X): "
> +		     "Command timed out, resetting card.\n",
> +		     TW_DRIVER, 0x2c);
>   
>   	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>   	mutex_lock(&tw_dev->ioctl_lock);
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index a853c5497af6..8c5f37563515 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1366,25 +1366,24 @@ static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev
>   } /* End tw_scsi_biosparam() */
>   
>   /* This is the new scsi eh reset function */
> -static int tw_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int tw_scsi_eh_reset(struct Scsi_Host *shost)
>   {
>   	TW_Device_Extension *tw_dev=NULL;
>   	int retval = FAILED;
>   
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> +	tw_dev = (TW_Device_Extension *)shost->hostdata;
>   
>   	tw_dev->num_resets++;
>   
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: Command (0x%x) timed out, resetting card.\n",
> -		SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		"WARNING: Command timed out, resetting card.\n");
>   
>   	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>   	mutex_lock(&tw_dev->ioctl_lock);
>   
>   	/* Now reset the card and some of the device extension data */
>   	if (tw_reset_device_extension(tw_dev)) {
> -		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n", tw_dev->host->host_no);
> +		shost_printk(KERN_WARNING, shost, "Reset failed.\n");
>   		goto out;
>   	}
>   
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index e1e4f9d10887..6a44a0795bb5 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -155,7 +155,7 @@ MODULE_LICENSE("GPL");
>   
>   STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
>   STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
> -STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
> +STATIC int NCR_700_host_reset(struct Scsi_Host *host);
>   STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
>   STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
>   STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
> @@ -1934,40 +1934,41 @@ NCR_700_abort(struct scsi_cmnd * SCp)
>   }
>   
>   STATIC int
> -NCR_700_host_reset(struct scsi_cmnd * SCp)
> +NCR_700_host_reset(struct Scsi_Host * host)
>   {
>   	DECLARE_COMPLETION_ONSTACK(complete);
> -	struct NCR_700_Host_Parameters *hostdata =
> -		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
> +	struct NCR_700_Host_Parameters *hostdata =
> +		(struct NCR_700_Host_Parameters *)host->hostdata[0];
>   
> -	scmd_printk(KERN_INFO, SCp,
> -		"New error handler wants HOST reset, cmd %p\n\t", SCp);
> -	scsi_print_command(SCp);
> +	shost_printk(KERN_INFO, host,
> +		"New error handler wants HOST reset\n");
>   
>   	/* In theory, eh_complete should always be null because the
>   	 * eh is single threaded, but just in case we're handling a
>   	 * reset via sg or something */
> -	spin_lock_irq(SCp->device->host->host_lock);
> +	spin_lock_irq(host->host_lock);
>   	while (hostdata->eh_complete != NULL) {
> -		spin_unlock_irq(SCp->device->host->host_lock);
> +		spin_unlock_irq(host->host_lock);
>   		msleep_interruptible(100);
> -		spin_lock_irq(SCp->device->host->host_lock);
> +		spin_lock_irq(host->host_lock);
>   	}
>   
>   	hostdata->eh_complete = &complete;
> -	NCR_700_internal_bus_reset(SCp->device->host);
> -	NCR_700_chip_reset(SCp->device->host);
> +	NCR_700_internal_bus_reset(host);
> +	NCR_700_chip_reset(host);
>   
> -	spin_unlock_irq(SCp->device->host->host_lock);
> +	spin_unlock_irq(host->host_lock);
>   	wait_for_completion(&complete);
> -	spin_lock_irq(SCp->device->host->host_lock);
> +	spin_lock_irq(host->host_lock);
>   
>   	hostdata->eh_complete = NULL;
> -	/* Revalidate the transport parameters of the failing device */
> -	if(hostdata->fast)
> -		spi_schedule_dv_device(SCp->device);
> -
> -	spin_unlock_irq(SCp->device->host->host_lock);
> +	/* Revalidate the transport parameters for attached devices */
> +	if(hostdata->fast) {
> +		struct scsi_device *sdev;
> +		__shost_for_each_device(sdev, host)
> +			spi_schedule_dv_device(sdev);
> +	}
> +	spin_unlock_irq(host->host_lock);
>   	return SUCCESS;
>   }
>   
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index a897c8f914cf..62c3aa7570ab 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2843,21 +2843,15 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
>   
>   /* Error Handling (EH) support */
>   
> -static int blogic_hostreset(struct scsi_cmnd *SCpnt)
> +static int blogic_hostreset(struct Scsi_Host *shost)
>   {
>   	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) SCpnt->device->host->hostdata;
> -
> -	unsigned int id = SCpnt->device->id;
> -	struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
> +		(struct blogic_adapter *) shost->hostdata;
>   	int rc;
>   
> -	spin_lock_irq(SCpnt->device->host->host_lock);
> -
> -	blogic_inc_count(&stats->adapter_reset_req);
> -
> +	spin_lock_irq(shost->host_lock);
>   	rc = blogic_resetadapter(adapter, false);
> -	spin_unlock_irq(SCpnt->device->host->host_lock);
> +	spin_unlock_irq(shost->host_lock);
>   	return rc;
>   }
>   
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index dece7d9eb4d3..6704415fb1c2 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -2379,9 +2379,8 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
>    * Returns SUCCESS
>    */
>   
> -static int NCR5380_host_reset(struct scsi_cmnd *cmd)
> +static int NCR5380_host_reset(struct Scsi_Host *instance)
>   {
> -	struct Scsi_Host *instance = cmd->device->host;
>   	struct NCR5380_hostdata *hostdata = shost_priv(instance);
>   	unsigned long flags;
>   	struct NCR5380_cmd *ncmd;
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 9c27bc37e5de..19a012c9a3c9 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1078,13 +1078,11 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
>   
>   /*
>    *	aac_eh_host_reset	- Host reset command handling
> - *	@scsi_cmd:	SCSI command block causing the reset
> + *	@host:	SCSI host to be reset
>    *
>    */
> -static int aac_eh_host_reset(struct scsi_cmnd *cmd)
> +static int aac_eh_host_reset(struct Scsi_Host *host)
>   {
> -	struct scsi_device * dev = cmd->device;
> -	struct Scsi_Host * host = dev->host;
>   	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
>   	int ret = FAILED;
>   	__le32 supported_options2 = 0;
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index f301aec044bb..0b7fcf7f9624 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7016,9 +7016,8 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
>    * sleeping is allowed and no locking other than for host structures is
>    * required. Returns SUCCESS or FAILED.
>    */
> -static int advansys_reset(struct scsi_cmnd *scp)
> +static int advansys_reset(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = scp->device->host;
>   	struct asc_board *boardp = shost_priv(shost);
>   	unsigned long flags;
>   	int status;
> @@ -7028,7 +7027,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
>   
>   	ASC_STATS(shost, reset);
>   
> -	scmd_printk(KERN_INFO, scp, "SCSI host reset started...\n");
> +	shost_printk(KERN_INFO, shost, "SCSI host reset started...\n");
>   
>   	if (ASC_NARROW_BOARD(boardp)) {
>   		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
> @@ -7039,16 +7038,18 @@ static int advansys_reset(struct scsi_cmnd *scp)
>   
>   		/* Refer to ASC_IERR_* definitions for meaning of 'err_code'. */
>   		if (asc_dvc->err_code || !asc_dvc->overrun_dma) {
> -			scmd_printk(KERN_INFO, scp, "SCSI host reset error: "
> -				    "0x%x, status: 0x%x\n", asc_dvc->err_code,
> +			shost_printk(KERN_INFO, shost,
> +				     "SCSI host reset error: 0x%x, status: 0x%x\n",
> +				     asc_dvc->err_code,
>   				    status);
>   			ret = FAILED;
>   		} else if (status) {
> -			scmd_printk(KERN_INFO, scp, "SCSI host reset warning: "
> -				    "0x%x\n", status);
> +			shost_printk(KERN_INFO, shost,
> +				     "SCSI host reset warning: 0x%x\n",
> +				     status);
>   		} else {
> -			scmd_printk(KERN_INFO, scp, "SCSI host reset "
> -				    "successful\n");
> +			shost_printk(KERN_INFO, shost,
> +				     "SCSI host reset successful\n");
>   		}
>   
>   		ASC_DBG(1, "after AscInitAsc1000Driver()\n");
> @@ -7065,12 +7066,13 @@ static int advansys_reset(struct scsi_cmnd *scp)
>   		ASC_DBG(1, "before AdvResetChipAndSB()\n");
>   		switch (AdvResetChipAndSB(adv_dvc)) {
>   		case ASC_TRUE:
> -			scmd_printk(KERN_INFO, scp, "SCSI host reset "
> -				    "successful\n");
> +			shost_printk(KERN_INFO, shost,
> +				     "SCSI host reset successful\n");
>   			break;
>   		case ASC_FALSE:
>   		default:
> -			scmd_printk(KERN_INFO, scp, "SCSI host reset error\n");
> +			shost_printk(KERN_INFO, shost,
> +				     "SCSI host reset error\n");
>   			ret = FAILED;
>   			break;
>   		}
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index cf7bba2ca68d..69063fe4aab8 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -913,15 +913,14 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
>   	aha1542_outb(sh->io_port, CMD_START_SCSI);
>   	spin_unlock_irqrestore(sh->host_lock, flags);
>   
> -	scmd_printk(KERN_WARNING, cmd,
> +	sdev_printk(KERN_WARNING, sdev,
>   		"Trying device reset for target\n");
>   
>   	return SUCCESS;
>   }
>   
> -static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
> +static int aha1542_reset(struct Scsi_Host *sh, u8 reset_cmd)
>   {
> -	struct Scsi_Host *sh = cmd->device->host;
>   	struct aha1542_hostdata *aha1542 = shost_priv(sh);
>   	unsigned long flags;
>   	int i;
> @@ -933,9 +932,9 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
>   	 * we do this?  Try this first, and we can add that later
>   	 * if it turns out to be useful.
>   	 */
> -	outb(reset_cmd, CONTROL(cmd->device->host->io_port));
> +	outb(reset_cmd, CONTROL(sh->io_port));
>   
> -	if (!wait_mask(STATUS(cmd->device->host->io_port),
> +	if (!wait_mask(STATUS(sh->io_port),
>   	     STATMASK, IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
>   		spin_unlock_irqrestore(sh->host_lock, flags);
>   		return FAILED;
> @@ -946,7 +945,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
>   	 * us again after host reset.
>   	 */
>   	if (reset_cmd & HRST)
> -		setup_mailboxes(cmd->device->host);
> +		setup_mailboxes(sh);
>   
>   	/*
>   	 * Now try to pick up the pieces.  For all pending commands,
> @@ -954,7 +953,8 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
>   	 * out.  We do not try and restart any commands or anything -
>   	 * the strategy handler takes care of that crap.
>   	 */
> -	shost_printk(KERN_WARNING, cmd->device->host, "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
> +	shost_printk(KERN_WARNING, sh, "Sent BUS RESET to scsi host %d\n",
> +		     sh->host_no);
>   
>   	for (i = 0; i < AHA1542_MAILBOXES; i++) {
>   		if (aha1542->int_cmds[i] != NULL) {
> @@ -982,12 +982,12 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
>   
>   static int aha1542_bus_reset(struct scsi_cmnd *cmd)
>   {
> -	return aha1542_reset(cmd, SCRST);
> +	return aha1542_reset(cmd->device->host, SCRST);
>   }
>   
> -static int aha1542_host_reset(struct scsi_cmnd *cmd)
> +static int aha1542_host_reset(struct Scsi_Host *sh)
>   {
> -	return aha1542_reset(cmd, HRST | SCRST);
> +	return aha1542_reset(sh, HRST | SCRST);
>   }
>   
>   static int aha1542_biosparam(struct scsi_device *sdev,
> diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
> index 7602639da9b3..3fc9326fc4c0 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -2631,13 +2631,13 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
>   /*
>    * Prototype: int acornscsi_reset(struct scsi_cmnd *SCpnt)
>    * Purpose  : reset a command on this host/reset this host
> - * Params   : SCpnt  - command causing reset
> + * Params   : shost  - host to be reset
>    * Returns  : one of SCSI_RESET_ macros
>    */
> -int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
> +int acornscsi_host_reset(struct Scsi_Host *shost)
>   {
> -	AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
> -	struct scsi_cmnd *SCptr;
> +    AS_Host *host = (AS_Host *)shost->hostdata;
> +    struct scsi_cmnd *SCptr;
>       
>       host->stats.resets += 1;
>   
> diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
> index e6289c6af5ef..38eec967155d 100644
> --- a/drivers/scsi/arm/fas216.c
> +++ b/drivers/scsi/arm/fas216.c
> @@ -2656,9 +2656,9 @@ static void fas216_init_chip(FAS216_Info *info)
>    * Returns: FAILED if unable to reset.
>    * Notes: io_request_lock is taken, and irqs are disabled
>    */
> -int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
> +int fas216_eh_host_reset(struct Scsi_Host *shost)
>   {
> -	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
> +	FAS216_Info *info = (FAS216_Info *)shost->hostdata;
>   
>   	spin_lock_irq(info->host->host_lock);
>   
> diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
> index 08113277a2a9..f17583f143b3 100644
> --- a/drivers/scsi/arm/fas216.h
> +++ b/drivers/scsi/arm/fas216.h
> @@ -394,11 +394,11 @@ extern int fas216_eh_device_reset(struct scsi_cmnd *SCpnt);
>    */
>   extern int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt);
>   
> -/* Function: int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
> +/* Function: int fas216_eh_host_reset(struct Scsi_Host *shost)
>    * Purpose : Reset the host associated with this command
> - * Params  : SCpnt - command specifing host to reset
> + * Params  : shost - host to reset
>    * Returns : FAILED if unable to reset
>    */
> -extern int fas216_eh_host_reset(struct scsi_cmnd *SCpnt);
> +extern int fas216_eh_host_reset(struct Scsi_Host *shost);
>   
>   #endif /* FAS216_H */
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index d401cf27113a..d967141f366c 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -667,7 +667,7 @@ static void atari_scsi_falcon_reg_write(unsigned int reg, u8 value)
>   
>   #include "NCR5380.c"
>   
> -static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
> +static int atari_scsi_host_reset(struct Scsi_Host *shost)
>   {
>   	int rv;
>   	unsigned long flags;
> @@ -684,7 +684,7 @@ static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
>   		atari_dma_orig_addr = NULL;
>   	}
>   
> -	rv = NCR5380_host_reset(cmd);
> +	rv = NCR5380_host_reset(shost);
>   
>   	/* The 5380 raises its IRQ line while _RST is active but the ST DMA
>   	 * "lock" has been released so this interrupt may end up handled by
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index e7be95ee7d64..50c04ba85b0b 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -2476,7 +2476,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>   
>   /**
>    * cxlflash_eh_host_reset_handler() - reset the host adapter
> - * @scp:	SCSI command from stack identifying host.
> + * @host:	SCSI host adapter.
>    *
>    * Following a reset, the state is evaluated again in case an EEH occurred
>    * during the reset. In such a scenario, the host reset will either yield
> @@ -2487,11 +2487,10 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
>    *	SUCCESS as defined in scsi/scsi.h
>    *	FAILED as defined in scsi/scsi.h
>    */
> -static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
> +static int cxlflash_eh_host_reset_handler(struct Scsi_Host *host)
>   {
>   	int rc = SUCCESS;
>   	int rcr = 0;
> -	struct Scsi_Host *host = scp->device->host;
>   	struct cxlflash_cfg *cfg = shost_priv(host);
>   	struct device *dev = &cfg->dev->dev;
>   
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 93227c04ef59..6e3ad0e5b533 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -746,15 +746,15 @@ static int adpt_bus_reset(struct scsi_cmnd* cmd)
>   }
>   
>   // This version of reset is called by the eh_error_handler
> -static int __adpt_reset(struct scsi_cmnd* cmd)
> +static int __adpt_reset(struct Scsi_Host* shost)
>   {
>   	adpt_hba* pHba;
>   	int rcode;
>   	char name[32];
>   
> -	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
> +	pHba = (adpt_hba*)shost->hostdata[0];
>   	strncpy(name, pHba->name, sizeof(name));
> -	printk(KERN_WARNING"%s: Hba Reset: scsi id %d: tid: %d\n", name, cmd->device->channel, pHba->channel[cmd->device->channel].tid);
> +	printk(KERN_WARNING"%s: Hba Reset\n", name);
>   	rcode =  adpt_hba_reset(pHba);
>   	if(rcode == 0){
>   		printk(KERN_WARNING"%s: HBA reset complete\n", name);
> @@ -765,13 +765,13 @@ static int __adpt_reset(struct scsi_cmnd* cmd)
>   	}
>   }
>   
> -static int adpt_reset(struct scsi_cmnd* cmd)
> +static int adpt_reset(struct Scsi_Host* shost)
>   {
>   	int rc;
>   
> -	spin_lock_irq(cmd->device->host->host_lock);
> -	rc = __adpt_reset(cmd);
> -	spin_unlock_irq(cmd->device->host->host_lock);
> +	spin_lock_irq(shost->host_lock);
> +	rc = __adpt_reset(shost);
> +	spin_unlock_irq(shost->host_lock);
>   
>   	return rc;
>   }
> diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
> index 8a079e8d7f65..b77a3625fa6f 100644
> --- a/drivers/scsi/dpti.h
> +++ b/drivers/scsi/dpti.h
> @@ -28,7 +28,7 @@
>   static int adpt_detect(struct scsi_host_template * sht);
>   static int adpt_queue(struct Scsi_Host *h, struct scsi_cmnd * cmd);
>   static int adpt_abort(struct scsi_cmnd * cmd);
> -static int adpt_reset(struct scsi_cmnd* cmd);
> +static int adpt_reset(struct Scsi_Host * host);
>   static int adpt_slave_configure(struct scsi_device *);
>   
>   static const char *adpt_info(struct Scsi_Host *pSHost);
> diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
> index ed63f7a9ea54..a104d1a3a9da 100644
> --- a/drivers/scsi/esas2r/esas2r.h
> +++ b/drivers/scsi/esas2r/esas2r.h
> @@ -976,7 +976,7 @@ long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
>   /* SCSI error handler (eh) functions */
>   int esas2r_eh_abort(struct scsi_cmnd *cmd);
>   int esas2r_device_reset(struct scsi_cmnd *cmd);
> -int esas2r_host_reset(struct scsi_cmnd *cmd);
> +int esas2r_host_reset(struct Scsi_Host *shost);
>   int esas2r_bus_reset(struct scsi_cmnd *cmd);
>   int esas2r_target_reset(struct scsi_cmnd *cmd);
>   
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index 7a4eadad23d7..52494c8bb656 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -1059,10 +1059,10 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
>   	return SUCCESS;
>   }
>   
> -static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
> +static int esas2r_host_bus_reset(struct Scsi_Host *shost, bool host_reset)
>   {
>   	struct esas2r_adapter *a =
> -		(struct esas2r_adapter *)cmd->device->host->hostdata;
> +		(struct esas2r_adapter *)shost->hostdata;
>   
>   	if (test_bit(AF_DEGRADED_MODE, &a->flags))
>   		return FAILED;
> @@ -1087,18 +1087,20 @@ static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
>   	return SUCCESS;
>   }
>   
> -int esas2r_host_reset(struct scsi_cmnd *cmd)
> +int esas2r_host_reset(struct Scsi_Host *shost)
>   {
> -	esas2r_log(ESAS2R_LOG_INFO, "host_reset (%p)", cmd);
> +	esas2r_log(ESAS2R_LOG_INFO, "host_reset (%p)", shost);
>   
> -	return esas2r_host_bus_reset(cmd, true);
> +	return esas2r_host_bus_reset(shost, true);
>   }
>   
>   int esas2r_bus_reset(struct scsi_cmnd *cmd)
>   {
> -	esas2r_log(ESAS2R_LOG_INFO, "bus_reset (%p)", cmd);
> +	struct Scsi_Host *shost = cmd->device->host;
> +
> +	esas2r_log(ESAS2R_LOG_INFO, "bus_reset (%p)", shost);
>   
> -	return esas2r_host_bus_reset(cmd, false);
> +	return esas2r_host_bus_reset(shost, false);
>   }
>   
>   static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 64ec6bb84550..b41eac8b5e0f 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2640,9 +2640,9 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
>   }
>   
>   /* All bets are off, reset the entire device.  */
> -static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +static int esp_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
> -	struct esp *esp = shost_priv(cmd->device->host);
> +	struct esp *esp = shost_priv(shost);
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(esp->host->host_lock, flags);
> diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
> index 444eac9b2466..5d3f1520ee50 100644
> --- a/drivers/scsi/fdomain.c
> +++ b/drivers/scsi/fdomain.c
> @@ -456,9 +456,8 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
>   	return SUCCESS;
>   }
>   
> -static int fdomain_host_reset(struct scsi_cmnd *cmd)
> +static int fdomain_host_reset(struct Scsi_Host *sh)
>   {
> -	struct Scsi_Host *sh = cmd->device->host;
>   	struct fdomain *fd = shost_priv(sh);
>   	unsigned long flags;
>   
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index aa07189fb5fb..7b81bea3ffa2 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -359,7 +359,7 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
>   int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>   int fnic_abort_cmd(struct scsi_cmnd *);
>   int fnic_device_reset(struct scsi_cmnd *);
> -int fnic_host_reset(struct scsi_cmnd *);
> +int fnic_host_reset(struct Scsi_Host *);
>   int fnic_reset(struct Scsi_Host *);
>   void fnic_scsi_cleanup(struct fc_lport *);
>   void fnic_scsi_abort_io(struct fc_lport *);
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index fb6dc59a5a7e..b286d5feaca1 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2452,11 +2452,10 @@ int fnic_reset(struct Scsi_Host *shost)
>    * host is offlined by SCSI.
>    *
>    */
> -int fnic_host_reset(struct scsi_cmnd *sc)
> +int fnic_host_reset(struct Scsi_Host *shost)
>   {
>   	int ret;
>   	unsigned long wait_host_tmo;
> -	struct Scsi_Host *shost = sc->device->host;
>   	struct fc_lport *lp = shost_priv(shost);
>   	struct fnic *fnic = lport_priv(lp);
>   	unsigned long flags;
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index f18b770626e6..30f6a6891ea2 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1091,12 +1091,12 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
>   	return 0;
>   }
>   
> -static int hptiop_reset(struct scsi_cmnd *scp)
> +static int hptiop_reset(struct Scsi_Host *host)
>   {
> -	struct hptiop_hba * hba = (struct hptiop_hba *)scp->device->host->hostdata;
> +	struct hptiop_hba * hba = (struct hptiop_hba *)host->hostdata;
>   
>   	printk(KERN_WARNING "hptiop_reset(%d/%d/%d)\n",
> -	       scp->device->host->host_no, -1, -1);
> +	       host->host_no, -1, -1);
>   
>   	return hptiop_reset_hba(hba)? FAILED : SUCCESS;
>   }
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 2e7128f0d905..5fb36cd70dde 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2984,10 +2984,10 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
>    * @cmd:	struct scsi_cmnd having problems
>    *
>    **/
> -static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +static int ibmvfc_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
>   	int rc;
> -	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
> +	struct ibmvfc_host *vhost = shost_priv(shost);
>   
>   	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
>   	rc = ibmvfc_issue_fc_host_lip(vhost->host);
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 63f32f843e75..892d79e2e7e1 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1735,10 +1735,10 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
>    * ibmvscsi_eh_host_reset_handler - Reset the connection to the server
>    * @cmd:	struct scsi_cmnd having problems
>   */
> -static int ibmvscsi_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +static int ibmvscsi_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
>   	unsigned long wait_switch = 0;
> -	struct ibmvscsi_host_data *hostdata = shost_priv(cmd->device->host);
> +	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
>   
>   	dev_err(hostdata->dev, "Resetting connection due to error recovery\n");
>   
> diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
> index 7a499d621c25..757175d09b2b 100644
> --- a/drivers/scsi/imm.c
> +++ b/drivers/scsi/imm.c
> @@ -984,9 +984,9 @@ static void imm_reset_pulse(unsigned int base)
>   	w_ctr(base, 0x04);
>   }
>   
> -static int imm_reset(struct scsi_cmnd *cmd)
> +static int imm_reset(struct Scsi_Host *host)
>   {
> -	imm_struct *dev = imm_dev(cmd->device->host);
> +	imm_struct *dev = imm_dev(host);
>   
>   	if (imm_scsi_pointer(cmd)->phase)
>   		imm_disconnect(dev);
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 104bee9b3a9d..29893dae7f24 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -5181,14 +5181,14 @@ static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
>   	return SUCCESS;
>   }
>   
> -static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
> +static int ipr_eh_host_reset(struct Scsi_Host *shost)
>   {
>   	struct ipr_ioa_cfg *ioa_cfg;
>   	unsigned long lock_flags = 0;
>   	int rc = SUCCESS;
>   
>   	ENTER;
> -	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
> +	ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
>   	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
>   
>   	if (!ioa_cfg->in_reset_reload && !ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index d49c1d6df5d6..f57858f561e3 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -229,7 +229,7 @@ module_param(ips, charp, 0);
>    * Function prototypes
>    */
>   static int ips_eh_abort(struct scsi_cmnd *);
> -static int ips_eh_reset(struct scsi_cmnd *);
> +static int ips_eh_reset(struct Scsi_Host *);
>   static int ips_queue(struct Scsi_Host *, struct scsi_cmnd *);
>   static const char *ips_info(struct Scsi_Host *);
>   static irqreturn_t do_ipsintr(int, void *);
> @@ -829,7 +829,7 @@ int ips_eh_abort(struct scsi_cmnd *SC)
>   /* NOTE: this routine is called under the io_request_lock spinlock          */
>   /*                                                                          */
>   /****************************************************************************/
> -static int __ips_eh_reset(struct scsi_cmnd *SC)
> +static int __ips_eh_reset(struct Scsi_Host *shost)
>   {
>   	int ret;
>   	int i;
> @@ -842,13 +842,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
>   	return (FAILED);
>   #else
>   
> -	if (!SC) {
> -		DEBUG(1, "Reset called with NULL scsi command");
> -
> -		return (FAILED);
> -	}
> -
> -	ha = (ips_ha_t *) SC->device->host->hostdata;
> +	ha = (ips_ha_t *) shost->hostdata;
>   
>   	if (!ha) {
>   		DEBUG(1, "Reset called with NULL ha struct");
> @@ -994,13 +988,13 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
>   
>   }
>   
> -static int ips_eh_reset(struct scsi_cmnd *SC)
> +static int ips_eh_reset(struct Scsi_Host *shost)
>   {
>   	int rc;
>   
> -	spin_lock_irq(SC->device->host->host_lock);
> -	rc = __ips_eh_reset(SC);
> -	spin_unlock_irq(SC->device->host->host_lock);
> +	spin_lock_irq(shost->host_lock);
> +	rc = __ips_eh_reset(shost);
> +	spin_unlock_irq(shost->host_lock);
>   
>   	return rc;
>   }
> @@ -1078,7 +1072,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC)
>   				return (0);
>   			}
>   			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
> -			__ips_eh_reset(SC);
> +			__ips_eh_reset(SC->device->host);
>   			SC->result = DID_OK << 16;
>   			scsi_done(SC);
>   			return (0);
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index 074996319df5..ab4a1c01a353 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -2195,11 +2195,10 @@ EXPORT_SYMBOL(fc_eh_device_reset);
>   
>   /**
>    * fc_eh_host_reset() - Reset a Scsi_Host.
> - * @sc_cmd: The SCSI command that identifies the SCSI host to be reset
> + * @shost: The SCSI host to be reset
>    */
> -int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
> +int fc_eh_host_reset(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = sc_cmd->device->host;
>   	struct fc_lport *lport = shost_priv(shost);
>   	unsigned long wait_tmo;
>   
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 1959c58d22f8..0443846c9fad 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -6503,9 +6503,8 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
>    *  0x2002 - Success
>    **/
>   static int
> -lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
> +lpfc_host_reset_handler(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = cmnd->device->host;
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   	struct lpfc_hba *phba = vport->phba;
>   	int rc, ret = SUCCESS;
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index 070ebe352f9e..466efe781376 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -100,14 +100,14 @@ static int mac53c94_queue_lck(struct scsi_cmnd *cmd)
>   
>   static DEF_SCSI_QCMD(mac53c94_queue)
>   
> -static int mac53c94_host_reset(struct scsi_cmnd *cmd)
> +static int mac53c94_host_reset(struct Scsi_Host *shost)
>   {
> -	struct fsc_state *state = (struct fsc_state *) cmd->device->host->hostdata;
> +	struct fsc_state *state = (struct fsc_state *) shost->hostdata;
>   	struct mac53c94_regs __iomem *regs = state->regs;
>   	struct dbdma_regs __iomem *dma = state->dma;
>   	unsigned long flags;
>   
> -	spin_lock_irqsave(cmd->device->host->host_lock, flags);
> +	spin_lock_irqsave(shost->host_lock, flags);
>   
>   	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
>   	writeb(CMD_SCSI_RESET, &regs->command);	/* assert RST */
> @@ -117,7 +117,7 @@ static int mac53c94_host_reset(struct scsi_cmnd *cmd)
>   	mac53c94_init(state);
>   	writeb(CMD_NOP, &regs->command);
>   
> -	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>   	return SUCCESS;
>   }
>   
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 9484632ffed6..6f6b66715707 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1875,13 +1875,13 @@ megaraid_abort(struct scsi_cmnd *cmd)
>   
>   
>   static int
> -megaraid_reset(struct scsi_cmnd *cmd)
> +megaraid_reset(struct Scsi_Host *shost)
>   {
>   	adapter_t	*adapter;
>   	megacmd_t	mc;
>   	int		rval;
>   
> -	adapter = (adapter_t *)cmd->device->host->hostdata;
> +	adapter = (adapter_t *)shost->hostdata;
>   
>   #if MEGA_HAVE_CLUSTERING
>   	mc.cmd = MEGA_CLUSTER_CMD;
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index 013fbfb911b9..43acad67d95f 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -973,7 +973,7 @@ static irqreturn_t megaraid_isr_iomapped(int, void *);
>   static void mega_free_scb(adapter_t *, scb_t *);
>   
>   static int megaraid_abort(struct scsi_cmnd *);
> -static int megaraid_reset(struct scsi_cmnd *);
> +static int megaraid_reset(struct Scsi_Host *);
>   static int megaraid_abort_and_reset(adapter_t *, struct scsi_cmnd *, int);
>   static int megaraid_biosparam(struct scsi_device *, struct block_device *,
>   		sector_t, int []);
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 2a339d4a7e9d..e250566a17b6 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -92,7 +92,7 @@ static int megaraid_sysfs_alloc_resources(adapter_t *);
>   static void megaraid_sysfs_free_resources(adapter_t *);
>   
>   static int megaraid_abort_handler(struct scsi_cmnd *);
> -static int megaraid_reset_handler(struct scsi_cmnd *);
> +static int megaraid_reset_handler(struct Scsi_Host *);
>   
>   static int mbox_post_sync_cmd(adapter_t *, uint8_t []);
>   static int mbox_post_sync_cmd_fast(adapter_t *, uint8_t []);
> @@ -2512,7 +2512,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
>    * host.
>    **/
>   static int
> -megaraid_reset_handler(struct scsi_cmnd *scp)
> +megaraid_reset_handler(struct Scsi_Host *shost)
>   {
>   	adapter_t	*adapter;
>   	scb_t		*scb;
> @@ -2525,7 +2525,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
>   	int		i;
>   	uioc_t		*kioc;
>   
> -	adapter		= SCP2ADAPTER(scp);
> +	adapter		= (adapter_t *)SCSIHOST2ADAP(shost);
>   	raid_dev	= ADAP2RAIDDEV(adapter);
>   
>   	// return failure if adapter is not responding
> @@ -2556,15 +2556,9 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
>   
>   			megaraid_mbox_mm_done(adapter, scb);
>   		} else {
> -			if (scb->scp == scp) {	// Found command
> -				con_log(CL_ANN, (KERN_WARNING
> -					"megaraid: %d[%d:%d], reset from pending list\n",
> -					scb->sno, scb->dev_channel, scb->dev_target));
> -			} else {
> -				con_log(CL_ANN, (KERN_WARNING
> +			con_log(CL_ANN, (KERN_WARNING
>   				"megaraid: IO packet with %d[%d:%d] being reset\n",
>   				scb->sno, scb->dev_channel, scb->dev_target));
> -			}
>   
>   			scb->scp->result = (DID_RESET << 16);
>   			scsi_done(scb->scp);
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index c95360a3c186..0222e234f108 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -2896,15 +2896,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
>    * reset requests. Device, bus and host specific reset handlers can use this
>    * function after they do their specific tasks.
>    */
> -static int megasas_generic_reset(struct scsi_cmnd *scmd)
> +static int megasas_generic_reset(struct Scsi_Host *shost)
>   {
>   	int ret_val;
>   	struct megasas_instance *instance;
>   
> -	instance = (struct megasas_instance *)scmd->device->host->hostdata;
> +	instance = (struct megasas_instance *)shost->hostdata;
>   
> -	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET cmd=%x retries=%x\n",
> -		 scmd->cmnd[0], scmd->retries);
> +	shost_printk(KERN_NOTICE, shost, "megasas: RESET\n");
>   
>   	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
>   		dev_err(&instance->pdev->dev, "cannot recover from previous reset failures\n");
> @@ -3057,31 +3056,30 @@ megasas_dump_sys_regs(void __iomem *reg_set, char *buf)
>    * megasas_reset_bus_host -	Bus & host reset handler entry point
>    * @scmd:			Mid-layer SCSI command
>    */
> -static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
> +static int megasas_reset_bus_host(struct Scsi_Host *shost)
>   {
>   	int ret;
>   	struct megasas_instance *instance;
>   
> -	instance = (struct megasas_instance *)scmd->device->host->hostdata;
> +	instance = (struct megasas_instance *)shost->hostdata;
>   
> -	scmd_printk(KERN_INFO, scmd,
> +	shost_printk(KERN_INFO, shost,
>   		"OCR is requested due to IO timeout!!\n");
>   
> -	scmd_printk(KERN_INFO, scmd,
> -		"SCSI host state: %d  SCSI host busy: %d  FW outstanding: %d\n",
> -		scmd->device->host->shost_state,
> -		scsi_host_busy(scmd->device->host),
> +	shost_printk(KERN_INFO, shost,
> +		"Controller reset is requested due to IO timeout\n"
> +		"SCSI host state: %d\t"
> +		" SCSI host busy: %d\t FW outstanding: %d\n",
> +		shost->shost_state,
> +		scsi_host_busy(shost),
>   		atomic_read(&instance->fw_outstanding));
>   	/*
>   	 * First wait for all commands to complete
>   	 */
> -	if (instance->adapter_type == MFI_SERIES) {
> -		ret = megasas_generic_reset(scmd);
> -	} else {
> -		megasas_dump_fusion_io(scmd);
> -		ret = megasas_reset_fusion(scmd->device->host,
> -				SCSIIO_TIMEOUT_OCR);
> -	}
> +	if (instance->adapter_type == MFI_SERIES)
> +		ret = megasas_generic_reset(shost);
> +	else
> +		ret = megasas_reset_fusion(shost, SCSIIO_TIMEOUT_OCR);
>   
>   	return ret;
>   }
> diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
> index 322d3ad38159..5e1d0bde36f3 100644
> --- a/drivers/scsi/mesh.c
> +++ b/drivers/scsi/mesh.c
> @@ -1699,9 +1699,9 @@ static int mesh_abort(struct scsi_cmnd *cmd)
>    * The midlayer will wait for devices to come back, we don't need
>    * to do that ourselves
>    */
> -static int mesh_host_reset(struct scsi_cmnd *cmd)
> +static int mesh_host_reset(struct Scsi_Host *shost)
>   {
> -	struct mesh_state *ms = (struct mesh_state *) cmd->device->host->hostdata;
> +	struct mesh_state *ms = (struct mesh_state *) shost->hostdata;
>   	volatile struct mesh_regs __iomem *mr = ms->mesh;
>   	volatile struct dbdma_regs __iomem *md = ms->dma;
>   	unsigned long flags;
> @@ -1718,7 +1718,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
>   	out_8(&mr->exception, 0xff);	/* clear all exception bits */
>   	out_8(&mr->error, 0xff);	/* clear all error bits */
>   	out_8(&mr->sequence, SEQ_RESETMESH);
> -       	mesh_flush_io(mr);
> +	mesh_flush_io(mr);
>   	udelay(1);
>   	out_8(&mr->intr_mask, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
>   	out_8(&mr->source_id, ms->host->this_id);
> @@ -1727,13 +1727,13 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
>   
>   	/* Reset the bus */
>   	out_8(&mr->bus_status1, BS1_RST);	/* assert RST */
> -       	mesh_flush_io(mr);
> +	mesh_flush_io(mr);
>   	udelay(30);			/* leave it on for >= 25us */
>   	out_8(&mr->bus_status1, 0);	/* negate RST */
>   
>   	/* Complete pending commands */
>   	handle_reset(ms);
> -	
> +
>   	spin_unlock_irqrestore(ms->host->host_lock, flags);
>   	return SUCCESS;
>   }
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 31f05e9f5ee0..bd42d3a56590 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3335,15 +3335,15 @@ void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout)
>   
>   /**
>    * mpi3mr_eh_host_reset - Host reset error handling callback
> - * @scmd: SCSI command reference
> + * @shost: SCSI host reference
>    *
>    * Issue controller reset
>    *
>    * Return: SUCCESS of successful reset else FAILED
>    */
> -static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
> +static int mpi3mr_eh_host_reset(struct Scsi_Host *shost)
>   {
> -	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
> +	struct mpi3mr_ioc *mrioc = shost_priv(shost);
>   	int retval = FAILED, ret;
>   
>   	ret = mpi3mr_soft_reset_handler(mrioc,
> @@ -3353,9 +3353,9 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
>   
>   	retval = SUCCESS;
>   out:
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "Host reset is %s for scmd(%p)\n",
> -	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +	shost_printk(KERN_INFO, shost,
> +	    "Host reset is %s\n",
> +	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"));
>   
>   	return retval;
>   }
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 7e476f50935b..ea9a8799f89a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3526,13 +3526,12 @@ scsih_target_reset(struct scsi_cmnd *scmd)
>    * Return: SUCCESS if command aborted else FAILED
>    */
>   static int
> -scsih_host_reset(struct scsi_cmnd *scmd)
> +scsih_host_reset(struct Scsi_Host *shost)
>   {
> -	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
> +	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
>   	int r, retval;
>   
> -	ioc_info(ioc, "attempting host reset! scmd(0x%p)\n", scmd);
> -	scsi_print_command(scmd);
> +	ioc_info(ioc, "attempting host reset\n");
>   
>   	if (ioc->is_driver_loading || ioc->remove_host) {
>   		ioc_info(ioc, "Blocking the host reset\n");
> @@ -3543,8 +3542,8 @@ scsih_host_reset(struct scsi_cmnd *scmd)
>   	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
>   	r = (retval < 0) ? FAILED : SUCCESS;
>   out:
> -	ioc_info(ioc, "host reset: %s scmd(0x%p)\n",
> -		 r == SUCCESS ? "SUCCESS" : "FAILED", scmd);
> +	ioc_info(ioc, "host reset: %s\n",
> +		 r == SUCCESS ? "SUCCESS" : "FAILED");
>   
>   	return r;
>   }
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 05d3ce9b72db..249813bc926e 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -695,14 +695,13 @@ static int mvumi_reset_host_9143(struct mvumi_hba *mhba)
>   	return mvumi_wait_for_outstanding(mhba);
>   }
>   
> -static int mvumi_host_reset(struct scsi_cmnd *scmd)
> +static int mvumi_host_reset(struct Scsi_Host *shost)
>   {
>   	struct mvumi_hba *mhba;
>   
> -	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
> +	mhba = (struct mvumi_hba *) shost->hostdata;
>   
> -	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
> -			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
> +	shost_printk(KERN_NOTICE, shost, "RESET\n");
>   
>   	return mhba->instancet->reset_host(mhba);
>   }
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 71585528e8db..437b11d48238 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -1251,9 +1251,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
>   	scsi_host_put(cb->host);
>   }
>   
> -static int myrb_host_reset(struct scsi_cmnd *scmd)
> +static int myrb_host_reset(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = scmd->device->host;
>   	struct myrb_hba *cb = shost_priv(shost);
>   
>   	cb->reset(cb->io_base);
> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index 7eb8c39da366..caa5511ca923 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
> @@ -1529,9 +1529,8 @@ ATTRIBUTE_GROUPS(myrs_shost);
>   /*
>    * SCSI midlayer interface
>    */
> -static int myrs_host_reset(struct scsi_cmnd *scmd)
> +static int myrs_host_reset(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = scmd->device->host;
>   	struct myrs_hba *cs = shost_priv(shost);
>   
>   	cs->reset(cs->io_base);
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 75bb0028ed74..d1f760c8e8ce 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -191,7 +191,7 @@ static int	   nsp32_release     (struct Scsi_Host *);
>   
>   /* SCSI error handler */
>   static int	   nsp32_eh_abort     (struct scsi_cmnd *);
> -static int	   nsp32_eh_host_reset(struct scsi_cmnd *);
> +static int	   nsp32_eh_host_reset(struct Scsi_Host *);
>   
>   /* generate SCSI message */
>   static void nsp32_build_identify(struct scsi_cmnd *);
> @@ -2876,23 +2876,21 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
>   	data->CurrentSC = NULL;
>   }
>   
> -static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
> +static int nsp32_eh_host_reset(struct Scsi_Host *host)
>   {
> -	struct Scsi_Host *host = SCpnt->device->host;
> -	unsigned int      base = SCpnt->device->host->io_port;
> +	unsigned int      base = host->io_port;
>   	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
>   
>   	nsp32_msg(KERN_INFO, "Host Reset");
> -	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
>   
> -	spin_lock_irq(SCpnt->device->host->host_lock);
> +	spin_lock_irq(host->host_lock);
>   
>   	nsp32hw_init(data);
>   	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
>   	nsp32_do_bus_reset(data);
>   	nsp32_write2(base, IRQ_CONTROL, 0);
>   
> -	spin_unlock_irq(SCpnt->device->host->host_lock);
> +	spin_unlock_irq(host->host_lock);
>   	return SUCCESS;	/* Host reset is succeeded at any time. */
>   }
>   
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 48acab03a8a0..4aa9737fa711 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -1497,9 +1497,9 @@ static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
>   	return nsp_bus_reset(data);
>   }
>   
> -static int nsp_eh_host_reset(struct scsi_cmnd *SCpnt)
> +static int nsp_eh_host_reset(struct Scsi_Host *host)
>   {
> -	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
> +	nsp_hw_data *data = (nsp_hw_data *)host->hostdata;
>   
>   	nsp_dbg(NSP_DEBUG_BUSRESET, "in");
>   
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index e1ee8ef90ad3..f532adb5f166 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -300,7 +300,7 @@ static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
>   /*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
>   /*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
>   static int nsp_eh_bus_reset    (struct scsi_cmnd *SCpnt);
> -static int nsp_eh_host_reset   (struct scsi_cmnd *SCpnt);
> +static int nsp_eh_host_reset   (struct Scsi_Host *host);
>   static int nsp_bus_reset       (nsp_hw_data *data);
>   
>   /* */
> diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
> index 310d0b6586a6..59893db166c9 100644
> --- a/drivers/scsi/pcmcia/qlogic_stub.c
> +++ b/drivers/scsi/pcmcia/qlogic_stub.c
> @@ -270,8 +270,8 @@ static int qlogic_resume(struct pcmcia_device *link)
>   		outb(0x24, link->resource[0]->start + 0x9);
>   		outb(0x04, link->resource[0]->start + 0xd);
>   	}
> -	/* Ugggglllyyyy!!! */
> -	qlogicfas408_host_reset(NULL);
> +
> +	qlogicfas408_host_reset(info->host);
>   
>   	return 0;
>   }
> diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
> index 5d7dfefd6f6c..79862f17de8d 100644
> --- a/drivers/scsi/pcmcia/sym53c500_cs.c
> +++ b/drivers/scsi/pcmcia/sym53c500_cs.c
> @@ -583,14 +583,14 @@ static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
>   static DEF_SCSI_QCMD(SYM53C500_queue)
>   
>   static int
> -SYM53C500_host_reset(struct scsi_cmnd *SCpnt)
> +SYM53C500_host_reset(struct Scsi_Host *shost)
>   {
> -	int port_base = SCpnt->device->host->io_port;
> +	int port_base = shost->io_port;
>   
>   	DEB(printk("SYM53C500_host_reset called\n"));
> -	spin_lock_irq(SCpnt->device->host->host_lock);
> +	spin_lock_irq(shost->host_lock);
>   	SYM53C500_int_host_reset(port_base);
> -	spin_unlock_irq(SCpnt->device->host->host_lock);
> +	spin_unlock_irq(shost->host_lock);
>   
>   	return SUCCESS;
>   }
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 62b9de87ff05..79ca737ac75b 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -3086,19 +3086,19 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
>   /**
>    * pmcraid_eh_host_reset_handler - adapter reset handler callback
>    *
> - * @scmd: pointer to scsi_cmd that was sent to a resource of adapter
> + * @shost: pointer to scsi_host
>    *
>    * Initiates adapter reset to bring it up to operational state
>    *
>    * Return value
>    *	SUCCESS or FAILED
>    */
> -static int pmcraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
> +static int pmcraid_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
>   	unsigned long interval = 10000; /* 10 seconds interval */
>   	int waits = jiffies_to_msecs(PMCRAID_RESET_HOST_TIMEOUT) / interval;
>   	struct pmcraid_instance *pinstance =
> -		(struct pmcraid_instance *)(scmd->device->host->hostdata);
> +		(struct pmcraid_instance *)(shost->hostdata);
>   
>   
>   	/* wait for an additional 150 seconds just in case firmware could come
> diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
> index c6c1bc608224..14a4b582fa9e 100644
> --- a/drivers/scsi/ppa.c
> +++ b/drivers/scsi/ppa.c
> @@ -867,9 +867,9 @@ static void ppa_reset_pulse(unsigned int base)
>   	w_ctr(base, 0xc);
>   }
>   
> -static int ppa_reset(struct scsi_cmnd *cmd)
> +static int ppa_reset(struct Scsi_Host *host)
>   {
> -	ppa_struct *dev = ppa_dev(cmd->device->host);
> +	ppa_struct *dev = ppa_dev(host);
>   
>   	if (ppa_scsi_pointer(cmd)->phase)
>   		ppa_disconnect(dev);
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 85ccfbc5cd26..c12fb3465946 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -952,12 +952,12 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
>   }
>   
>   /* Reset the host by gracefully logging out and then logging back in */
> -static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
> +static int qedf_eh_host_reset(struct Scsi_Host *shost)
>   {
>   	struct fc_lport *lport;
>   	struct qedf_ctx *qedf;
>   
> -	lport = shost_priv(sc_cmd->device->host);
> +	lport = shost_priv(shost);
>   	qedf = lport_priv(lport);
>   
>   	if (atomic_read(&qedf->link_state) == QEDF_LINK_DOWN ||
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 31ec429104e2..dfb12f80fd9f 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -30,9 +30,8 @@ int qedi_recover_all_conns(struct qedi_ctx *qedi)
>   	return SUCCESS;
>   }
>   
> -static int qedi_eh_host_reset(struct scsi_cmnd *cmd)
> +static int qedi_eh_host_reset(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = cmd->device->host;
>   	struct qedi_ctx *qedi;
>   
>   	qedi = iscsi_host_priv(shost);
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index c4466e4e692f..cd4c7126c1c9 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -995,10 +995,9 @@ qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
>    *     Reset the specified adapter (both channels)
>    **************************************************************************/
>   static int
> -qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
> +qla1280_eh_adapter_reset(struct Scsi_Host *shost)
>   {
>   	int rc;
> -	struct Scsi_Host *shost = cmd->device->host;
>   	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
>   
>   	spin_lock_irq(shost->host_lock);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 762229d495a8..5f86e7bd5a0e 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1604,8 +1604,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
>   *    The reset function will reset the Adapter.
>   *
>   * Input:
> -*      cmd = Linux SCSI command packet of the command that cause the
> -*            adapter reset.
> +*      shost = Linux SCSI host to be reset
>   *
>   * Returns:
>   *      Either SUCCESS or FAILED.
> @@ -1613,13 +1612,11 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
>   * Note:
>   **************************************************************************/
>   static int
> -qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
> +qla2xxx_eh_host_reset(struct Scsi_Host *shost)
>   {
> -	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
> +	scsi_qla_host_t *vha = shost_priv(shost);
>   	struct qla_hw_data *ha = vha->hw;
>   	int ret = FAILED;
> -	unsigned int id;
> -	uint64_t lun;
>   	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
>   
>   	if (qla2x00_isp_reg_stat(ha)) {
> @@ -1629,11 +1626,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>   		return SUCCESS;
>   	}
>   
> -	id = cmd->device->id;
> -	lun = cmd->device->lun;
> -
>   	ql_log(ql_log_info, vha, 0x8018,
> -	    "ADAPTER RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
> +	    "ADAPTER RESET ISSUED host=%ld.\n", vha->host_no);
>   
>   	/*
>   	 * No point in issuing another reset if one is active.  Also do not
> @@ -1679,8 +1673,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>   
>   eh_host_reset_lock:
>   	ql_log(ql_log_info, vha, 0x8017,
> -	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
> -	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
> +	    "ADAPTER RESET %s host=%ld.\n",
> +	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no);
>   
>   	return ret;
>   }
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index f4969b99c07f..8f89080e2580 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -159,7 +159,7 @@ static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
>   static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
>   static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
>   static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
> -static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
> +static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
>   static int qla4xxx_slave_alloc(struct scsi_device *device);
>   static umode_t qla4_attr_is_visible(int param_type, int param);
>   static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
> @@ -9411,18 +9411,18 @@ static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
>   
>   /**
>    * qla4xxx_eh_host_reset - kernel callback
> - * @cmd: Pointer to Linux's SCSI command structure
> + * @host: Pointer to Linux's SCSI host structure
>    *
>    * This routine is invoked by the Linux kernel to perform fatal error
>    * recovery on the specified adapter.
>    **/
> -static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
> +static int qla4xxx_eh_host_reset(struct Scsi_Host *host)
>   {
>   	int return_status = FAILED;
>   	struct scsi_qla_host *ha;
>   	int rval;
>   
> -	ha = to_qla_host(cmd->device->host);
> +	ha = to_qla_host(host);
>   
>   	rval = qla4xxx_isp_check_reg(ha);
>   	if (rval != QLA_SUCCESS) {
> @@ -9444,20 +9444,18 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
>   		     ha->host_no, __func__));
>   
>   		/* Clear outstanding srb in queues */
> -		if (qla4xxx_is_eh_active(cmd->device->host))
> +		if (qla4xxx_is_eh_active(host))
>   			qla4xxx_abort_active_cmds(ha, DID_ABORT << 16);
>   
>   		return FAILED;
>   	}
>   
>   	ql4_printk(KERN_INFO, ha,
> -		   "scsi(%ld:%d:%d:%llu): HOST RESET ISSUED.\n", ha->host_no,
> -		   cmd->device->channel, cmd->device->id, cmd->device->lun);
> +		   "scsi%ld: HOST RESET ISSUED.\n", ha->host_no);
>   
>   	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
> -		DEBUG2(printk("scsi%ld:%d: %s: Unable to reset host.  Adapter "
> -			      "DEAD.\n", ha->host_no, cmd->device->channel,
> -			      __func__));
> +		DEBUG2(printk("scsi%ld: %s: Unable to reset host.  Adapter "
> +			      "DEAD.\n", ha->host_no, __func__));
>   
>   		return FAILED;
>   	}
> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
> index 3e065d5fc80c..008e908e3aff 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -525,20 +525,18 @@ int qlogicfas408_abort(struct scsi_cmnd *cmd)
>   
>   /*
>    *	Reset SCSI bus
> - *	FIXME: This function is invoked with cmd = NULL directly by
> - *	the PCMCIA qlogic_stub code. This wants fixing
>    */
>   
> -int qlogicfas408_host_reset(struct scsi_cmnd *cmd)
> +int qlogicfas408_host_reset(struct Scsi_Host *host)
>   {
> -	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
> +	struct qlogicfas408_priv *priv = get_priv_by_host(host);
>   	unsigned long flags;
>   
>   	priv->qabort = 2;
>   
> -	spin_lock_irqsave(cmd->device->host->host_lock, flags);
> +	spin_lock_irqsave(host->host_lock, flags);
>   	ql_zap(priv);
> -	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
> +	spin_unlock_irqrestore(host->host_lock, flags);
>   
>   	return SUCCESS;
>   }
> diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
> index a971db11d293..c1b6e9fea9ce 100644
> --- a/drivers/scsi/qlogicfas408.h
> +++ b/drivers/scsi/qlogicfas408.h
> @@ -109,7 +109,7 @@ int qlogicfas408_biosparam(struct scsi_device * disk,
>   			   struct block_device *dev,
>   			   sector_t capacity, int ip[]);
>   int qlogicfas408_abort(struct scsi_cmnd * cmd);
> -extern int qlogicfas408_host_reset(struct scsi_cmnd *cmd);
> +extern int qlogicfas408_host_reset(struct Scsi_Host *host);
>   const char *qlogicfas408_info(struct Scsi_Host *host);
>   int qlogicfas408_get_chip_type(int qbase, int int_type);
>   void qlogicfas408_setup(int qbase, int id, int int_type);
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index 57f2f4135a06..bd3defa15933 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -1260,10 +1260,9 @@ static int qlogicpti_abort(struct scsi_cmnd *Cmnd)
>   	return return_status;
>   }
>   
> -static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
> +static int qlogicpti_reset(struct Scsi_Host *host)
>   {
>   	u_short param[6];
> -	struct Scsi_Host *host = Cmnd->device->host;
>   	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
>   	int return_status = SUCCESS;
>   
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 592a290e6cfa..6292ac7aef7a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5357,15 +5357,15 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
>   	return SUCCESS;
>   }
>   
> -static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
> +static int scsi_debug_host_reset(struct Scsi_Host *shost)
>   {
>   	struct sdebug_host_info *sdbg_host;
>   	struct sdebug_dev_info *devip;
>   	int k = 0;
>   
>   	++num_host_resets;
> -	if ((SCpnt->device) && (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
> -		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
> +	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
> +		shost_printk(KERN_INFO, shost, "%s\n", __func__);
>   	spin_lock(&sdebug_host_list_lock);
>   	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
>   		list_for_each_entry(devip, &sdbg_host->dev_info_list,
> @@ -5377,7 +5377,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   	spin_unlock(&sdebug_host_list_lock);
>   	stop_all_queued();
>   	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
> -		sdev_printk(KERN_INFO, SCpnt->device,
> +		shost_printk(KERN_INFO, shost,
>   			    "%s: %d device(s) found\n", __func__, k);
>   	return SUCCESS;
>   }
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index cdaca13ac1f1..747131ca8970 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -841,7 +841,7 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
>   	if (!hostt->eh_host_reset_handler)
>   		return FAILED;
>   
> -	rtn = hostt->eh_host_reset_handler(scmd);
> +	rtn = hostt->eh_host_reset_handler(host);
>   
>   	if (rtn == SUCCESS) {
>   		if (!hostt->skip_settle_delay)
> diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
> index e40492d36031..79916e803b26 100644
> --- a/drivers/scsi/snic/snic.h
> +++ b/drivers/scsi/snic/snic.h
> @@ -380,8 +380,7 @@ extern const struct attribute_group *snic_host_groups[];
>   int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>   int snic_abort_cmd(struct scsi_cmnd *);
>   int snic_device_reset(struct scsi_cmnd *);
> -int snic_host_reset(struct scsi_cmnd *);
> -int snic_reset(struct Scsi_Host *);
> +int snic_host_reset(struct Scsi_Host *);
>   void snic_shutdown_scsi_cleanup(struct snic *);
>   
>   
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index 635656ccf30a..3722383fb529 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -2295,8 +2295,15 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
>   	return ret;
>   } /* end of snic_issue_hba_reset */
>   
> +/*
> + * SCSI Error handling calls driver's eh_host_reset if all prior
> + * error handling levels return FAILED.
> + *
> + * Host Reset is the highest level of error recovery. If this fails, then
> + * host is offlined by SCSI.
> + */
>   int
> -snic_reset(struct Scsi_Host *shost)
> +snic_host_reset(struct Scsi_Host *shost)
>   {
>   	struct snic *snic = shost_priv(shost);
>   	struct scsi_cmnd *sc = NULL;
> @@ -2360,34 +2367,6 @@ snic_reset(struct Scsi_Host *shost)
>   		 (ulong) sc, jiffies_to_msecs(jiffies - start_time),
>   		 0, 0, 0);
>   
> -	return ret;
> -} /* end of snic_reset */
> -
> -/*
> - * SCSI Error handling calls driver's eh_host_reset if all prior
> - * error handling levels return FAILED.
> - *
> - * Host Reset is the highest level of error recovery. If this fails, then
> - * host is offlined by SCSI.
> - */
> -int
> -snic_host_reset(struct scsi_cmnd *sc)
> -{
> -	struct Scsi_Host *shost = sc->device->host;
> -	u32 start_time  = jiffies;
> -	int ret;
> -
> -	SNIC_SCSI_DBG(shost,
> -		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
> -		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
> -		      snic_cmd_tag(sc), CMD_FLAGS(sc));
> -
> -	ret = snic_reset(shost);
> -
> -	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
> -		 jiffies_to_msecs(jiffies - start_time),
> -		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
> -
>   	return ret;
>   } /* end of snic_host_reset */
>   
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index e6420f2127ce..d6f7e3f541e2 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1433,14 +1433,13 @@ static int stex_do_reset(struct st_hba *hba)
>   	return -1;
>   }
>   
> -static int stex_reset(struct scsi_cmnd *cmd)
> +static int stex_reset(struct Scsi_Host *shost)
>   {
>   	struct st_hba *hba;
>   
> -	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
> +	hba = (struct st_hba *) &shost->hostdata[0];
>   
> -	shost_printk(KERN_INFO, cmd->device->host,
> -		     "resetting host\n");
> +	shost_printk(KERN_INFO, shost, "resetting host\n");
>   
>   	return stex_do_reset(hba) ? FAILED : SUCCESS;
>   }
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 9a0bba5a51a7..70bc095c6e78 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1659,9 +1659,9 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
>   	return 0;
>   }
>   
> -static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
> +static int storvsc_host_reset_handler(struct Scsi_Host *shost)
>   {
> -	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
> +	struct hv_host_device *host_dev = shost_priv(shost);
>   	struct hv_device *device = host_dev->dev;
>   
>   	struct storvsc_device *stor_device;
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index cb8885eb5a5b..a573baa5bdf2 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -693,9 +693,8 @@ static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
>   	return SCSI_SUCCESS;
>   }
>   
> -static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +static int sym53c8xx_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
> -	struct Scsi_Host *shost = cmd->device->host;
>   	struct sym_data *sym_data = shost_priv(shost);
>   	struct pci_dev *pdev = sym_data->pdev;
>   	struct sym_hcb *np = sym_data->ncb;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3f9caafa91bf..d1f065d4bcce 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -229,7 +229,7 @@ static struct ufs_dev_fix ufs_fixups[] = {
>   static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
>   static void ufshcd_async_scan(void *data, async_cookie_t cookie);
>   static int ufshcd_reset_and_restore(struct ufs_hba *hba);
> -static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
> +static int ufshcd_eh_host_reset_handler(struct Scsi_Host *shost);
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>   static void ufshcd_hba_exit(struct ufs_hba *hba);
>   static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
> @@ -7311,13 +7311,13 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
>    *
>    * Returns SUCCESS/FAILED
>    */
> -static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +static int ufshcd_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
>   	int err = SUCCESS;
>   	unsigned long flags;
>   	struct ufs_hba *hba;
>   
> -	hba = shost_priv(cmd->device->host);
> +	hba = shost_priv(shost);
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	hba->force_reset = true;
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index f88ecdb93a8a..ddf1837babc0 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -894,14 +894,13 @@ static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
>   	}
>   }
>   
> -static int pvscsi_host_reset(struct scsi_cmnd *cmd)
> +static int pvscsi_host_reset(struct Scsi_Host *host)
>   {
> -	struct Scsi_Host *host = cmd->device->host;
>   	struct pvscsi_adapter *adapter = shost_priv(host);
>   	unsigned long flags;
>   	bool use_msg;
>   
> -	scmd_printk(KERN_INFO, cmd, "SCSI Host reset\n");
> +	shost_printk(KERN_INFO, host, "SCSI Host reset\n");
>   
>   	spin_lock_irqsave(&adapter->hw_lock, flags);
>   
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index 3fe562047d85..7cfe736ed6c2 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -1568,13 +1568,11 @@ reset_wd33c93(struct Scsi_Host *instance)
>   }
>   
>   int
> -wd33c93_host_reset(struct scsi_cmnd * SCpnt)
> +wd33c93_host_reset(struct Scsi_Host * instance)
>   {
> -	struct Scsi_Host *instance;
>   	struct WD33C93_hostdata *hostdata;
>   	int i;
>   
> -	instance = SCpnt->device->host;
>   	spin_lock_irq(instance->host_lock);
>   	hostdata = (struct WD33C93_hostdata *) instance->hostdata;
>   
> @@ -1599,7 +1597,6 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
>   	hostdata->outgoing_len = 0;
>   
>   	reset_wd33c93(instance);
> -	SCpnt->result = DID_RESET << 16;
>   	enable_irq(instance->irq);
>   	spin_unlock_irq(instance->host_lock);
>   	return SUCCESS;
> diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
> index b3800baccd2c..87119e47836a 100644
> --- a/drivers/scsi/wd33c93.h
> +++ b/drivers/scsi/wd33c93.h
> @@ -341,6 +341,6 @@ int wd33c93_queuecommand (struct Scsi_Host *h, struct scsi_cmnd *cmd);
>   void wd33c93_intr (struct Scsi_Host *instance);
>   int wd33c93_show_info(struct seq_file *, struct Scsi_Host *);
>   int wd33c93_write_info(struct Scsi_Host *, char *, int);
> -int wd33c93_host_reset (struct scsi_cmnd *);
> +int wd33c93_host_reset (struct Scsi_Host *);
>   
>   #endif /* WD33C93_H */
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index ff1b22077251..02b8eb153944 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -520,9 +520,9 @@ static int wd719x_bus_reset(struct scsi_cmnd *cmd)
>   	return wd719x_reset(cmd, WD719X_CMD_BUSRESET, 0);
>   }
>   
> -static int wd719x_host_reset(struct scsi_cmnd *cmd)
> +static int wd719x_host_reset(struct Scsi_Host *host)
>   {
> -	struct wd719x *wd = shost_priv(cmd->device->host);
> +	struct wd719x *wd = shost_priv(host);
>   	struct wd719x_scb *scb, *tmp;
>   	unsigned long flags;
>   
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 48aa18f8b984..0de0dd09cf9d 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -390,11 +390,11 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
>   
>   /*
>    * visorhba_host_reset_handler - Not supported
> - * @scsicmd: The scsicmd that needs to be aborted
> + * @shost: The scsi host that needs resetting
>    *
>    * Return: Not supported, return SUCCESS
>    */
> -static int visorhba_host_reset_handler(struct scsi_cmnd *scsicmd)
> +static int visorhba_host_reset_handler(struct Scsi_Host *shost)
>   {
>   	/* issue TASK_MGMT_TARGET_RESET for each target on each bus for host */
>   	return SUCCESS;
> diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
> index 874ea4b54ced..8b560772c49a 100644
> --- a/drivers/usb/image/microtek.c
> +++ b/drivers/usb/image/microtek.c
> @@ -345,9 +345,9 @@ static int mts_scsi_abort(struct scsi_cmnd *srb)
>   	return FAILED;
>   }
>   
> -static int mts_scsi_host_reset(struct scsi_cmnd *srb)
> +static int mts_scsi_host_reset(struct Scsi_Host *shost)
>   {
> -	struct mts_desc* desc = (struct mts_desc*)(srb->device->host->hostdata[0]);
> +	struct mts_desc* desc = (struct mts_desc*)(shost->hostdata[0]);
>   	int result;
>   
>   	MTS_DEBUG_GOT_HERE();
> diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
> index 6e29e1719db1..31f60d2ad318 100644
> --- a/include/scsi/libfc.h
> +++ b/include/scsi/libfc.h
> @@ -950,7 +950,7 @@ void fc_fcp_destroy(struct fc_lport *);
>   int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>   int fc_eh_abort(struct scsi_cmnd *);
>   int fc_eh_device_reset(struct scsi_cmnd *);
> -int fc_eh_host_reset(struct scsi_cmnd *);
> +int fc_eh_host_reset(struct Scsi_Host *);
>   int fc_slave_alloc(struct scsi_device *);
>   
>   /*
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 667d889b92b5..3b8d9e65ea57 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -141,7 +141,7 @@ struct scsi_host_template {
>   	int (* eh_device_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_target_reset_handler)(struct scsi_cmnd *);
>   	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
> -	int (* eh_host_reset_handler)(struct scsi_cmnd *);
> +	int (* eh_host_reset_handler)(struct Scsi_Host *);
>   
>   	/*
>   	 * Before the mid layer attempts to scan for a new device where none

Reviewed-by: Lee Duncan <lduncan@suse.com>

