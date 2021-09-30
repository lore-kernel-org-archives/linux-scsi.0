Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61366C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43DBF619F9
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351310AbhI3SYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:24:43 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60580 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351008AbhI3SYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:24:40 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UILGsH019369;
        Thu, 30 Sep 2021 18:22:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2a+ePxiAqfOWli2DEF0lF4IFlHOqZJTz1NsjF9x+oLA=;
 b=m66+0ONo6ZTYlA+loMNDADnT/XD5ffVZ7AdZ//Vk+VAXDsZyKiv1jvAH/Tg9HDWmtNH7
 paLMXXlEzrphgOp5PQeXmnsxPxJOlLMnr5xuUBcYNywS/RTXuECtkXKFkg2hsCvRmSoT
 zDIGWN1urETt9ooS3cNIChd6sSTXBRtqVj9g+9M3jT39YRoLFYeVYsGxzBZGSXj9XzJW
 Jx44FtmZoymAjIU2z52XUS706u9jM64JPH0oXoC4MRBTUEdwnQR/QLVtTVCC5WjdTGxk
 NY8I9kIkVx0kR+oN4fmm6KNHv5432SpQho+aTo716DZ646g5dHe+zFyhFnVU0y4eZwit eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bde3cadx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:22:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIGIH7135993;
        Thu, 30 Sep 2021 18:22:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3bc3cgb0hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po2c/LLNDRu16OrdVeIvtVbNwClQkJVdgRtr93kYHpFBOfYFnL4OvqblyzZZcjkD+O0H1RPM/0pk+5a9deX4wG+nLZ0n9gppDOWrV5zUSgNV1HxqIVGhnh+vEoV3DZagDuVYoS/iuqMlBvYstPZYGlB5d8Y1Dopzgj08tHKu44i8KUWBpQrFL0Qh2yYOqRJKpDcySsapIldjisrK2XnDOwDWasvsySZGx+LSuRUpHSwH0omXCJVj9vhUHTdALQHAoinheQKD7LLT9rd35wKO+8+0yTzP3FWdwwIATifHKd1JnaZE95b+xiD+8sV3x5vM+OkxKGjqP87bqPSuFfGrEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2a+ePxiAqfOWli2DEF0lF4IFlHOqZJTz1NsjF9x+oLA=;
 b=Wd2ngyZm9PDIBXSHbqEI+rqjzLQqWN+lkX8PnAUsXwL9yZGHENZ1+By3t4U4EBt0306djcv3U1EPx6j6Rzlfi6pcp1knXYgrhcU4QO9HtoKirz9KeN3M0qiG3675bp17JBCYkh3MpXdWiM1ZH0pBxwmH26RavVUlG9a6L6UzzZ54pc+HOo0RygNm1mtzvDLtsbc+wV26znCCZ3Q4oAfNea37ytzjV8NeUYMvrIzi/jovpQV5vTPyeh4sEehaglmnXjPqb+qoucOGjH8biCCdiJtYpaiw7QxYnlu0dtCF19hHYopA9ZY6D7Xi4OBJn8bc9kYP+Y1YY4JyEgTA3Qsg0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2a+ePxiAqfOWli2DEF0lF4IFlHOqZJTz1NsjF9x+oLA=;
 b=Oirb5mmoy73tRIfrE9on6Qa0xVIQua3PXihHdgvEC5VHZrDPhVJhYvECKvvr0RnKdvvU7AvPRceMuIpj4+Oi1rzfU62kUKcF33G0lPdgOXKeLXJt3Sp9xF7UGbuax8ZtCCjcZF8Eaah+djkK7iIZ2pz5FMLqCGgM/4aBT0P9rLU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 18:21:58 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:21:58 +0000
Subject: Re: [smartpqi updates PATCH V2 02/11] smartpqi: add controller
 handshake during kdump
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-3-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <2fbc5c41-0b58-0173-fa1e-9f4a155953c8@oracle.com>
Date:   Thu, 30 Sep 2021 13:21:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-3-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::48) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BY5PR17CA0035.namprd17.prod.outlook.com (2603:10b6:a03:1b8::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 18:21:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8153463-9593-4c5e-78fb-08d9843f30b6
X-MS-TrafficTypeDiagnostic: CO6PR10MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB553955DF534817814E12F10FC7AA9@CO6PR10MB5539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hasx4c1OsTJ9TmGCso5jv8FY1zykIKofAYpnJO+stWSmWj1DT9j/07lj1fG/e1Ski0Zo5dTvOmBm9E8ukez8UKX6hdy7atnRz17AXVaIZzaE61TZmcdm090hDfEJpphi1r6eKSxolPubl1kItfiUUGdJ4C4YOLhQBjg9PRQdM8kwBl65svKM+gNJlJll39qMQv55dy59CSwNZ8soeTKOy2l21vzPlfqQZkcb1oNzbHs+w/vdYMCRjUVkXyIVZqC5lE+pv9iwyuEpFPefSTyszJBadY6z/Dzf3a5b8tsvbDoBDMONAcDHgD5CzxcGUd7MPIHnzNHbCkVBLL08wzkyI7+GIhZ2XAOnFg2PMyIZbT9AN/rTDzFFqUv+tGAuf6wcNqH944+G/m/cnI8aoRBO8McDKCmXXPdq6J9D4OACg93K5UMpuLiei1hwQwhhYyi/CSoRff72kHW4JThPcXIumX2El99gIbgqPwz3Fyy8Gp9XxRSFmz/F3iQi+VrJdCwBhVjpUnFoP/YbG19bKYr/axXmTr0b4Sf2egIxYzfA+x6AYH79EIvlHeDqZeowoIGSxewJzuqMl6o01kkzoq/9ajzrILZIk3VY/t2s8kCo4MwSIxev5fpDmHp7YaaTFNUCeTKanw2s8JVyAkoUK36eE4KCHXD2S98ITluOY6ByQ7yxHZ237S+uujkwtmEAII32V++7Hx2F9PJ7pfP8U+hdBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(2616005)(956004)(31696002)(7416002)(86362001)(6506007)(53546011)(8936002)(26005)(186003)(2906002)(36756003)(6486002)(38100700002)(31686004)(5660300002)(316002)(15650500001)(9686003)(6512007)(66946007)(66556008)(66476007)(508600001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnNhUWNYMThnZnFkWmhKRmdYYnVYZ2NmdlR4TCtYcFg1TmhzTlRwRXpWRTlR?=
 =?utf-8?B?M1A3L1VvaFF6ejBWOTVRaThQb1lzSkFPcmN2KzQxNDVXb0lvV2hHVU5XdGw4?=
 =?utf-8?B?OTE5bklsVGFGVCtDS0ZyeGNrK0ZSVUp4MXBxcmYwZE50aDZqQ0RZU3ZkT3pt?=
 =?utf-8?B?ay9BVWkvSThkc2NZQ0xpaUplMXBaRlIwaUlQMjVCTGZWbm1zalY3Vmd1dUtZ?=
 =?utf-8?B?R0djUXBFR0REVmxsUjJZbnR6ekY1VjQ3QUM3a2R6cFJmUTdCTWVuRVJzODRk?=
 =?utf-8?B?c0tWRjVlcGdXaklEYm9WNlVwZEd6cUhzcWgyWDRLSmFQR25XTjZONzBUb0hT?=
 =?utf-8?B?cnlhNEwrLzNCS1Y5YUEyejJiL1hiUllyOWFxN2xKSUVtQVJ0U0tWNlh2aCtH?=
 =?utf-8?B?aWMzcEdrdkNIRGVINWNpbVJZWHZab2VrTEdoN2FleUU0N3o2TjBqUzg4VjJW?=
 =?utf-8?B?ZU1iYXB4dzM5QXI0d3BlVFM1YTdJSG44Y05oc2NyUEswdHNYa3lWdVhMc1Ar?=
 =?utf-8?B?K3g1Qmg0TzNOQXE3c2VEazB6ZmhRQ3RJQUU3WjBSOEszdmQwRDA4T3o5SmFM?=
 =?utf-8?B?SU55OFZneGhQa1NqVnI3VFpyRGpjbGw2eEVWOWVhSHNCSFpEcmxDUlJORDA3?=
 =?utf-8?B?bDFWczlxbDlrZzRPcFZOTUVVWWpzQVJNcUpMVS9TMDNidGpheHl0M1ZPMzlP?=
 =?utf-8?B?ZG9ZYzloUlY4VWNqcjlmWXV4ME95WkxGU1RscHJMOHF4SktxNVMrQk1jWXls?=
 =?utf-8?B?RGJLUnBiZUswd1ZVSkRDU05VdFFteGg0d1YrVy93b1k1MUd6QlRCaDhnWE5Z?=
 =?utf-8?B?UmdJSE9oRmpyc0NBZzJuTUhzb3BzSFg0YlRndFVDaitsSzBBK01Gb3VzeHFV?=
 =?utf-8?B?VkZ5ZjZueGtBTzVySE9CUEtZdkZOYXFERXUxMk5UKzdIR296bVJRMHp3cFlu?=
 =?utf-8?B?ekI0ZUhSQXlLVnNuNEJuNWYrMVcxQjcyMXRFOEtXQ2NpN1MzYlhDdEtCNEhP?=
 =?utf-8?B?QVlsRDMydy84TlZ4RWI4ZEhqSk53QmRqYzkyWWoyajRyRkVHTUhPT2dVeFBm?=
 =?utf-8?B?U2hSc2RLbytVNUxHM3luUk1KUHlEMDQ0RUhQUkpvcVRST21TdzltNzQxaWxY?=
 =?utf-8?B?V3J4YkhoUEJjTTZEYnBDNEQ5eU5EMW5sOGpkRjFOYzIzODFBRTJMN2hGOTNv?=
 =?utf-8?B?SW84NVMyZHY5aDBuSHJaYi9vdTYrd2RsUTRKeXdGYjlmWFBaUDdNMnNFck5s?=
 =?utf-8?B?U1grK2JhZDIrQ3JIbHZSbmVsTGNtYmxaZExDenBSeVB6ZlIxck1iSnNFdWdY?=
 =?utf-8?B?MWdpd0svTFlORGNVSFdHSFRSWmJYdTNWS2lGck1vT2M5MFJkTWU1dkgzQ0lB?=
 =?utf-8?B?elczcjFUVXlWZkZkU1V2cTJNUzc1RzBaQWl2S1RCU2RBMkk3Y01CNVE2UUVF?=
 =?utf-8?B?VlVkUFVBNzc3S0RQclUzbFAwYVRNSE92NGlCWEQrZ3dlWjl5UE1LYzVuYTVW?=
 =?utf-8?B?NE93QzJoWW4vNEZzN050dHAxblB1a0FIbWtRbUFWZyszdGl6SmJqRlBaekpE?=
 =?utf-8?B?NGx1TVpXcHFQZ3huWEJadU9CNmVVOVo2c3VoVEt2RXFYOUxwM3kydHJYYlFN?=
 =?utf-8?B?NFlYVUVrdEgzeGlhT0IyNmlMeWgzNTAxa0RjcXRQQkxVRkJGVkRKZFBYK0ty?=
 =?utf-8?B?UzNDK3FWNkFzdHA3UTEwMjFqMThMME0xRFNNZGdHYUo4RlNLcXJjVFhJSFhu?=
 =?utf-8?Q?guVPFXy+DxJtL2zufmp/Jt75eJJRMFtULr4QyPg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8153463-9593-4c5e-78fb-08d9843f30b6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:21:58.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0gO/D6jkUaVTDvBmkpkx9h2KTVMJnPnNbA9QOJrpz/Oznn9C1Hu6Sa/Jf2c+0LDTCQUUEdHlFypP2OUe2GwijFZWwonlULruxQI5v7N850=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300112
X-Proofpoint-GUID: exi5vjQb0In9CM9DSqwaPPiM7cx5rjgP
X-Proofpoint-ORIG-GUID: exi5vjQb0In9CM9DSqwaPPiM7cx5rjgP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> 
> Correct kdump hangs when controller is locked up.
> 
> There are occasions when a controller reboot
> (controller soft reset) is issued when a controller
> firmware crash dump is in progress.
> 
> This leads to incomplete controller firmware crash dump.
>   - When the controller crash dump is in progress,
>     and a kdump is initiated, the driver issues
>     inbound doorbell reset to bring back the
>     controller in SIS mode.
>   - If the controller is in locked up state,
>     the inbound doorbell reset does not work causing
>     controller initialization failures. This results
>     in the driver hanging waiting for SIS mode.
> 
> To avoid an incomplete controller crash dump, add in
> a controller crash dump handshake.
>   - Controller will indicate start and end of the controller
>     crash dump by setting some register bits.
>   - Driver will look these bits when a kdump is initiated.
>     If a controller crash dump is in progress, the driver will
>     wait for the controller crash dump to complete
>     before issuing the controller soft reset then complete
>     driver initialization.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 41 +++++++++++++++++++--
>   drivers/scsi/smartpqi/smartpqi_sis.c  | 51 +++++++++++++++++++++++++++
>   drivers/scsi/smartpqi/smartpqi_sis.h  |  1 +
>   3 files changed, 91 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 97027574eb1f..5655d240f7a7 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -234,15 +234,46 @@ static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
>   	return pqi_scsi3addr_equal(scsi3addr, RAID_CTLR_LUNID);
>   }
>   
> +#define PQI_DRIVER_SCRATCH_PQI_MODE			0x1
> +#define PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED		0x2
> +
>   static inline enum pqi_ctrl_mode pqi_get_ctrl_mode(struct pqi_ctrl_info *ctrl_info)
>   {
> -	return sis_read_driver_scratch(ctrl_info);
> +	return sis_read_driver_scratch(ctrl_info) & PQI_DRIVER_SCRATCH_PQI_MODE ? PQI_MODE : SIS_MODE;
>   }
>   
>   static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
>   	enum pqi_ctrl_mode mode)
>   {
> -	sis_write_driver_scratch(ctrl_info, mode);
> +	u32 driver_scratch;
> +
> +	driver_scratch = sis_read_driver_scratch(ctrl_info);
> +
> +	if (mode == PQI_MODE)
> +		driver_scratch |= PQI_DRIVER_SCRATCH_PQI_MODE;
> +	else
> +		driver_scratch &= ~PQI_DRIVER_SCRATCH_PQI_MODE;
> +
> +	sis_write_driver_scratch(ctrl_info, driver_scratch);
> +}
> +
> +static inline bool pqi_is_fw_triage_supported(struct pqi_ctrl_info *ctrl_info)
> +{
> +	return (sis_read_driver_scratch(ctrl_info) & PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED) != 0;
> +}
> +
> +static inline void pqi_save_fw_triage_setting(struct pqi_ctrl_info *ctrl_info, bool is_supported)
> +{
> +	u32 driver_scratch;
> +
> +	driver_scratch = sis_read_driver_scratch(ctrl_info);
> +
> +	if (is_supported)
> +		driver_scratch |= PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED;
> +	else
> +		driver_scratch &= ~PQI_DRIVER_SCRATCH_FW_TRIAGE_SUPPORTED;
> +
> +	sis_write_driver_scratch(ctrl_info, driver_scratch);
>   }
>   
>   static inline void pqi_ctrl_block_scan(struct pqi_ctrl_info *ctrl_info)
> @@ -7292,6 +7323,7 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
>   		ctrl_info->unique_wwid_in_report_phys_lun_supported =
>   			firmware_feature->enabled;
>   		break;
> +		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
>   	}
>   
>   	pqi_firmware_feature_status(ctrl_info, firmware_feature);
> @@ -7618,6 +7650,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
>   	u32 product_id;
>   
>   	if (reset_devices) {
> +		if (pqi_is_fw_triage_supported(ctrl_info)) {
> +			rc = sis_wait_for_fw_triage_completion(ctrl_info);
> +			if (rc)
> +				return rc;
> +		}
>   		sis_soft_reset(ctrl_info);
>   		msleep(PQI_POST_RESET_DELAY_SECS * PQI_HZ);
>   	} else {
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
> index d63c46a8e38b..8acd3a80f582 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.c
> @@ -51,12 +51,20 @@
>   #define SIS_BASE_STRUCT_REVISION		9
>   #define SIS_BASE_STRUCT_ALIGNMENT		16
>   
> +#define SIS_CTRL_KERNEL_FW_TRIAGE		0x3
>   #define SIS_CTRL_KERNEL_UP			0x80
>   #define SIS_CTRL_KERNEL_PANIC			0x100
>   #define SIS_CTRL_READY_TIMEOUT_SECS		180
>   #define SIS_CTRL_READY_RESUME_TIMEOUT_SECS	90
>   #define SIS_CTRL_READY_POLL_INTERVAL_MSECS	10
>   
> +enum sis_fw_triage_status {
> +	FW_TRIAGE_NOT_STARTED = 0,
> +	FW_TRIAGE_STARTED,
> +	FW_TRIAGE_COND_INVALID,
> +	FW_TRIAGE_COMPLETED
> +};
> +
>   #pragma pack(1)
>   
>   /* for use with SIS_CMD_INIT_BASE_STRUCT_ADDRESS command */
> @@ -419,12 +427,55 @@ u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info)
>   	return readl(&ctrl_info->registers->sis_driver_scratch);
>   }
>   
> +static inline enum sis_fw_triage_status
> +	sis_read_firmware_triage_status(struct pqi_ctrl_info *ctrl_info)
> +{
> +	return ((enum sis_fw_triage_status)(readl(&ctrl_info->registers->sis_firmware_status) &
> +		SIS_CTRL_KERNEL_FW_TRIAGE));
> +}
> +
>   void sis_soft_reset(struct pqi_ctrl_info *ctrl_info)
>   {
>   	writel(SIS_SOFT_RESET,
>   		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
>   }
>   
> +#define SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS		300
> +#define SIS_FW_TRIAGE_STATUS_POLL_INTERVAL_SECS		1
> +
> +int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
> +{
> +	int rc;
> +	enum sis_fw_triage_status status;
> +	unsigned long timeout;
> +
> +	timeout = (SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS * PQI_HZ) + jiffies;
> +	while (1) {
> +		status = sis_read_firmware_triage_status(ctrl_info);
> +		if (status == FW_TRIAGE_COND_INVALID) {
> +			dev_err(&ctrl_info->pci_dev->dev,
> +				"firmware triage condition invalid\n");
> +			rc = -EINVAL;
> +			break;
> +		} else if (status == FW_TRIAGE_NOT_STARTED ||
> +			status == FW_TRIAGE_COMPLETED) {
> +			rc = 0;
> +			break;
> +		}
> +
> +		if (time_after(jiffies, timeout)) {
> +			dev_err(&ctrl_info->pci_dev->dev,
> +				"timed out waiting for firmware triage status\n");
> +			rc = -ETIMEDOUT;
> +			break;
> +		}
> +
> +		ssleep(SIS_FW_TRIAGE_STATUS_POLL_INTERVAL_SECS);
> +	}
> +
> +	return rc;
> +}
> +
>   static void __attribute__((unused)) verify_structures(void)
>   {
>   	BUILD_BUG_ON(offsetof(struct sis_base_struct,
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
> index d29c1352a826..c1db93054c86 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.h
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.h
> @@ -28,5 +28,6 @@ void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
>   u32 sis_read_driver_scratch(struct pqi_ctrl_info *ctrl_info);
>   void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
>   u32 sis_get_product_id(struct pqi_ctrl_info *ctrl_info);
> +int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info);
>   
>   #endif	/* _SMARTPQI_SIS_H */
> 

