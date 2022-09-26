Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33C1C6FA82
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 16:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiIZQ6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 12:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiIZQ55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 12:57:57 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ABD11C29
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 08:54:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVzXwJEoP8T7HmmB4zhJgmfdFTfsN6oX3AwY5SwB2KSzf3dc1fJIucqTADkmeiFW7XNLbATogIiaqUkzpmvGIlb0GY9GOqYWX3wO8ykVTpYU7C+jWBMrYlTfJvuaxbX0SwctjXmAKdk5kjJ0RKUSPEKkB2W+91gpSQLPb1P1qvj4EG9nA3rBrmQGbMRG20f1BPkQHJ+tPRyhiliMU2Tc2vK7DdgUmKuaXn5PwEkrAg28mEyifFXT7/RBKWd2kjYP9SA8TIfYUZRI0jSLvxdZ1K/SdP5VUrA+XF8Z1Ycud4y7ZUjNMqaqsqVCx5rzuZpB7mxoeZUYXEH3mNebdn+mzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3QAhkYF6efzEfg3J95zdlO5VXSWOACkepCUCdcI9i8=;
 b=gRaco9Jx8XoJ3MdaET3UDC+L7QT+ZidyioT5mQ4rCq7IEau8WQ6FufR4/erTBOxwb86PJ+bdtIj54IlP0pwMKRAZGBS08org9miJgGePNSUFmIMAN9fdvF3nL6mr+qDKBl3NVLBjzuAiXO1VBqNROF2sSrJ2kd0AN5ENHtcNLrebPC1Xk3ZuzM2kj6ySdHWUMCWM5RX6PPhUJcgl9eX1UrgGhmUWByhxu93R1W1wI/8aWVRlwayAiEhXCHWe1DXG/2X9cKpgFNq/PAX5wqfFgQ1vt3XwXVM7FCUHIJzVhcJ4Rw2ggDkHmH06VdmbjHK7cAPwWY6/HXkojcadl33jJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3QAhkYF6efzEfg3J95zdlO5VXSWOACkepCUCdcI9i8=;
 b=ANQSO1GGJ5gWzCxcO4dV4Gbta1ljWp7xfAcmnxShZ1KRhdn5J5Ff+9zsdGGgievgW8vPDbxJK25KVgPUh5QG3UTLDGqZGdv31h/mSZ9/j0ndSZmsRlStxhdqSzGvYUnfEri35n3zw/lV5LZ2cO/1n1MDSpK9/QXegU+GEt37JwhrhF8RfHwYTHsdB7EoVMl7q2UMYjDMrunXskKuqaNzoVYHig5jnJu4U63px7ffwLz6441I73+FgQ6A2v5f3aLSpqDhuaqxNZSuEy0+93jaN8nz6pNMcX10P55WS1CPhvOQfFoYf/387s2mPHauCjuvFLVbBoFfW4Q4CenOWDXf9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM9PR04MB8713.eurprd04.prod.outlook.com (2603:10a6:20b:43c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 15:54:31 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::78bf:cbbb:dea8:7e4f]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::78bf:cbbb:dea8:7e4f%6]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 15:54:31 +0000
Message-ID: <6ee86af6-6a0d-4c8d-439d-0ea58dc7c743@suse.com>
Date:   Mon, 26 Sep 2022 08:54:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2] scsi: stex: properly zero out the passthrough command
 structure
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi@vger.kernel.org, hdthky <hdthky0@gmail.com>,
        stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220908145154.2284098-1-gregkh@linuxfoundation.org>
 <YxrjN3OOw2HHl9tx@kroah.com> <fd6a94cd-6d71-f241-fc7b-d8613c1c2616@acm.org>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <fd6a94cd-6d71-f241-fc7b-d8613c1c2616@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::20) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:EE_|AM9PR04MB8713:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d4e2f18-68d4-41af-535b-08da9fd7667e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/T/gCuL3BCtB8xddqnNX0/B/ZDNts77tM4gSRFUYsnSqOjHNjaB6Ciyx3kzHgllmmRI/mhBv2K/5aVV5cQN8igSOCMzoQsqsm9wHCYbFGaeKeZGA04wDh0P0TV5orwH/8FdQu8vWGY+LWJML++Cu49Li4zItcHgmPHwmfO14QHMpTJ3vh4PLLCzSL0Fs75fALhavtGcxLET1uoDBalmY8fDLpZM6VsPcPV7g/z6T9x5zauK8XMzUQhioKdQeuoy03pB+43Tl2ZYyWYaKQ40Gr+5tIpTgFYpIcOZH4jvJZpXd9LiwTEI6hE9Sy6VwuP+IcYlXzRm2CYqvxrmJ6KFibL12TsTGh7CdzqRX8njieUfXXIV6h3/saCuXCAp2Em8jkLxwYJDNidUMuHq6R/9e+wqqkpJ0of3ElzftCmQuBbm/AMUzLMWMyOOgbIC3MScqSR/0T1zVQ6G2JnltiiMS+kahinS5yrTv45/+8CFtJY0L7uxaTN8t9idgN1SUDF6wfpuv9LaEljTWQ6mN6Wop0zi+bQex6hxMQ9GwI77ddAheitARvMhMwdrxtZNnPuq4CMCD0qfpaJPB82R2F7AvLvnTAya+AdleioUREfO8FPj+rMXROSdSbyEznUTK9t0UeubRX/Fhf+6Z3OykeOVlNOpUkkE0oPAxyHHweUdnLyB5y/fSujxJZZvUTXlLnhTgCT5ehkO687XL11fgd2cs0Ytspqf7G7X6GwSg9ZFbYqp2cJV9JX61ArSlELyqOZ1Xi+TWwmiC9Cy+p50ykj0IoSIQTyk7kASEjI6jeOcp1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(38100700002)(86362001)(6486002)(31686004)(31696002)(478600001)(8936002)(83380400001)(110136005)(6666004)(6506007)(53546011)(316002)(5660300002)(26005)(6512007)(2906002)(54906003)(8676002)(2616005)(66946007)(66556008)(4326008)(66476007)(36756003)(41300700001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU5CeHpnb2JoNVpWaldYYThGVDZyL0JJYzJUODJ1Q1pyUVNiL0VtaC9xQjdC?=
 =?utf-8?B?Q3NiZFNzcG1Wc1JOcytXdkM3VnpqSElKSnpza2ZaczhCY1l2elE1TjBPM0NW?=
 =?utf-8?B?YnljY1JNU0x6ZVpRdlR0TThOUVVKTnpYZDlYL05vTmMyOXJCY1c5Myt3bEJi?=
 =?utf-8?B?cUpyamVnRG5WbDQ2VVYxUVV3S3pmMnhxQlNva29iQ09wNGVuRDVtaTFPdTJS?=
 =?utf-8?B?MHFUNll5MHFTY2pVR0lDMmFMSFpoVXJUb1lmUTAwUmd6dHRUaU4vUmxYeUUw?=
 =?utf-8?B?WW9aK2NPa0ZONDB6eG55K2VWbS9qYm43MlZ1akgzbU82VGM4dG94VndmMlFP?=
 =?utf-8?B?NUJtaS8vOWhpZEJqNWNWYSs2NnJYNnZFVmpUbEhZVUdILy8vTFV3NURTTE0w?=
 =?utf-8?B?aU55eVY4ZTlvUkpEOXFOTFFPMmxRWE5iU1I3Z0crUWRUZEVHNkdjdHpTdjVr?=
 =?utf-8?B?dHhOdXlMVjF5b3hUL1ZhNEg1OFIydWlrVG9xZDU4WU55MVZlbUxaN0FZa2gx?=
 =?utf-8?B?RnpCM3RkRWU1RXVRcGJQa2JVR2toaDI3UWhsaXlQM2ZnNXNSU1NkTy9yaUwx?=
 =?utf-8?B?MEZ0aTBOMUFpS3ZTUUtwN0RRaWtWdUhoUnlTb1A2Q0NIN1ozbjkveEtwUk1s?=
 =?utf-8?B?MmRmelZheC8va1BiUDZnL2szWEU2SWNPQTVQZEdDTjU0Qm1uYk5tR3IvVHd3?=
 =?utf-8?B?OHAwUDl5eFduN3k5QUFoSDNpL1l5bFpGS0RTOUxHaXZybkpTUWk5YmVkQlZu?=
 =?utf-8?B?dkFoUWhFZVNTQ1F1bE91d1FKODNYMWFVTFFNaHZJczJlUUR1QTRMYUdyZXNE?=
 =?utf-8?B?S3VZQ01PWGRGZjh1ck1yT2ZHTnZlYUVtYTdQY1BJbEZQODh5SjhJTXgyVFVT?=
 =?utf-8?B?bEN0U1NKN1dsQnJqTlREcVRvcCtZZk9EK1JCSmdVZlRac3RqNmlKWjgyL2dJ?=
 =?utf-8?B?Kyt6Ry9vTU5wYldlYzJXcXpNblpGMU4wN0lVY2NLYThuNHBQVUZULzFJVWM4?=
 =?utf-8?B?WURua0JWQTJwN0pQQXNrL3dzbExtR2x5OS9tOG00V1FTOG9PUzkvUi9ZSkk4?=
 =?utf-8?B?Ni8vWGJmSGQyd2ZueXdtM24ybUhEZXFmYmk0UlcycHA2L1JROHdQQlVtVzAy?=
 =?utf-8?B?ekt5bVgyWUNFTjZuZlN6SzJFU25SWll3cU1OUVErdHlhYzFxekdEZkJpY0s2?=
 =?utf-8?B?UGhQc2N6ZDNOTU02QkhBaVY2ckdRaUNtM015ZURUc2JDMGxBMlFXSHBYUDdI?=
 =?utf-8?B?VjF6VkZFaEN3RzhHTkd0MVVycTJyM1FsV2F5QkYycGZXczRQWjE3VWxSSWYz?=
 =?utf-8?B?aE00cTJXM3VWRXY3Q1FlK1V2eHBKd1UxZXFKRlNLMGJ0N1Q4YWpVTm14Snlh?=
 =?utf-8?B?SjNDUmwzLzV2ZHNzcm9HTUtwWXh1N2VNM09MLzJwYVhqMjZBUUN6QVBMQkRW?=
 =?utf-8?B?QlRRUC9ndlo2amp5QkFQY2x3T1RUczc3cU1VZVVPS2dUSWI0QmMyUVlqNkhM?=
 =?utf-8?B?MnpaRWJ2YW1CQWtGZGV4YjI1N2VOd3E0UVBEMlBQNTNWSkVRUi9tV1VmMU5R?=
 =?utf-8?B?Y3gzU3ovMEFOVGtzM1VpYVFldmovYkVDc1ppSFh2VmYyY29TcHAySDFoNGYw?=
 =?utf-8?B?Z0dHeFBwOWpETkhOaDJyNDA5SmZYb1VOQjkySlY2NjB2M2JmTUtpRHFzRlR3?=
 =?utf-8?B?TXE5UHVhRVJLTzR1aUFDTnV2YlhIOEovK0xYZXc0bGVqWTlVNnNaaUtCZld6?=
 =?utf-8?B?SGdWbU1rRjlqNytDSXhocVVtT01Oekl4MjJuY3NWdEtQbmg4S282MlNsbTdO?=
 =?utf-8?B?TjFxTUJEN0s5dEIwNmx3cmlMby9sOFM2WU5SOUh5d1JkTXFnYXBlaU1UdU91?=
 =?utf-8?B?TlJhclRNRUVsNHFTU25uMEN6VUYyZjBoT1NVdVUvazNQTnRiSXVQVm9weFBG?=
 =?utf-8?B?NXBNVHNpcFNXanVlZE9QeTMrOFVENjkwM2d1S0w3SVZnbHNvOWhMYzFnYTcx?=
 =?utf-8?B?TFBaSmliNUJkRDl2WFhrUjhQeEI2blVPR00rOFQ2Y1RzeldSRVZFK2RKeTJ1?=
 =?utf-8?B?bnhSK09KRVFmYWpYVGZmVW5KbCtkcjBkMjlLejlDd29sdk9LVDhqUGRPNEsx?=
 =?utf-8?Q?ONZu+8Y0IiwUyo4QDYtEKI8P/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4e2f18-68d4-41af-535b-08da9fd7667e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 15:54:31.6904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /KXP0bk5vL/BMX5vLf3o27Tezn8jnrjFeGfA371HZ5L5Ppm17wHeb2wbAUxgpk/1Ck+zcQSuwnwSYCB3nTSIKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8713
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/22 09:24, Bart Van Assche wrote:
> On 9/8/22 23:54, Greg Kroah-Hartman wrote:
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> The passthrough structure is declared off of the stack, so it needs to
>> be set to zero before copied back to userspace to prevent any
>> unintentional data leakage.  Switch things to be statically allocated
>> which will fill the unused fields with 0 automatically.
>>
>> Reported-by: hdthky <hdthky0@gmail.com>
>> Cc: stable <stable@kernel.org>
>> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   v2: Linus's updated version that moves the initialization to be
>>       statically defined and changes the function prototype and structure
>>       to be const.
>>
>>   drivers/scsi/stex.c      | 17 +++++++++--------
>>   include/scsi/scsi_cmnd.h |  2 +-
>>   2 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>> index e6420f2127ce..8def242675ef 100644
>> --- a/drivers/scsi/stex.c
>> +++ b/drivers/scsi/stex.c
>> @@ -665,16 +665,17 @@ static int stex_queuecommand_lck(struct 
>> scsi_cmnd *cmd)
>>           return 0;
>>       case PASSTHRU_CMD:
>>           if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
>> -            struct st_drvver ver;
>> +            const struct st_drvver ver = {
>> +                .major = ST_VER_MAJOR,
>> +                .minor = ST_VER_MINOR,
>> +                .oem = ST_OEM,
>> +                .build = ST_BUILD_VER,
>> +                .signature[0] = PASSTHRU_SIGNATURE,
>> +                .console_id = host->max_id - 1,
>> +                .host_no = hba->host->host_no,
>> +            };
>>               size_t cp_len = sizeof(ver);
>> -            ver.major = ST_VER_MAJOR;
>> -            ver.minor = ST_VER_MINOR;
>> -            ver.oem = ST_OEM;
>> -            ver.build = ST_BUILD_VER;
>> -            ver.signature[0] = PASSTHRU_SIGNATURE;
>> -            ver.console_id = host->max_id - 1;
>> -            ver.host_no = hba->host->host_no;
>>               cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
>>               if (sizeof(ver) == cp_len)
>>                   cmd->result = DID_OK << 16;
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index bac55decf900..7d3622db38ed 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -201,7 +201,7 @@ static inline unsigned int scsi_get_resid(struct 
>> scsi_cmnd *cmd)
>>       for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
>>   static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
>> -                       void *buf, int buflen)
>> +                       const void *buf, int buflen)
>>   {
>>       return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
>>                      buf, buflen);
> 
> Please split this patch into one patch for the SCSI core and another patch
> for the STEX driver.
> 
> Thanks,
> 
> Bart.

Ping? Is this patch going to stand as is, or are we going to get a V3 
that addresses Bart's request?

I'd like to know so I can backport the proper patch(es) to address this 
issue.
-- 
Lee Duncan
