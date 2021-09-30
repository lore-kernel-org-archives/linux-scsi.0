Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29786C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A5361A0A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351354AbhI3SY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:24:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18898 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351333AbhI3SY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:24:56 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UHavRD011137;
        Thu, 30 Sep 2021 18:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=YLVxxk9RnwYKmLOem9cngp/smPMoCxexPoh0d0aNk5s=;
 b=oBMtuvZfmA7BkVk3n/mKVwwPi28+X/qInPBNpQxnAnt0xjWecx6VQ7PaRfFrCR1+hIjA
 xIslpXp2Y1/dR56gA0mN790T25zaNdyjJTvuTaFJmYTq5hfbGyz/yYX45rHbzKSctFt9
 nR3LjhnpoxM8AULenWLCIkj6Z0avUkIToAhPdGFGozZXeq9EduB8UAt/T2NAuSXFfbPI
 mMgdwgbOpLQdlABgBW+mKheeQ9ct/UQyc4mxLBUwnz3YhXmxL10QDKf+qLMJW0TvReDW
 OdYu1vf9uzU6zeg72cEKADuGI6hk9FJ5nBZNZmFsSkpFwoDO4G/rCumJhDRfafuv2hOV 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdds8289j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:22:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIEYIH100020;
        Thu, 30 Sep 2021 18:22:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 3bc3bn1gb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2JlXUERn8aKIhKEmvStuj0qsd9gOPQ1Cu0Fjw/gmO3mjyyGbb0L38grHVeb5hsHn31702XptNdcG+qhrSJvQlp4QBpRZJWn7SBRoZTv6XFLXoTSIhGkfleDoozvW18ADYQPstGYDBebCKhLchQAFEZknbOcRp8b6R4zJdXLmHTYwtKS79kCE8wnUPPBfgDN1I+oL7tzrkcyyVcxnNW5g0KPcOdc6LmV4fkpUKFleH2eDz6FSQNN2cYa8YFEB2W1LO7Mp7LI2EMkSK/timKuxA/poUWVEPgbtv9GKufCvgQ+92HDOFSaKOhqgROyEwe/fxA+ziLhwTHac5R9qj15gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YLVxxk9RnwYKmLOem9cngp/smPMoCxexPoh0d0aNk5s=;
 b=LxCtBXPeF6os6DRio+MCdUCAWaYYi/PUNcaesYEJz5gwRRl67dV+LDiLcJmM/gbH/QsVPMfkHe66GNv0awJFbl4mAAIcQKQSf+V0YtGdUJGvuBTRF/8tJhQZeWWwIDccqdku6PZU/tf9CQ9dz5jEZjQto5F8xmBcR9Kes/1ZpDR3vuX0nFiOUYy5jg6SiqIHh7l6R71CTtEu8otKc876Yoohx2u+UbQOJvI1hkJerft/m/cdJWCndi+CVKlkowobUYKk9GWK/FPw8REnM6R5hZkPnBJOPYxDLqPMf8XgNDh6orORF4VkX8ofSkKZZfB7Bet2v7FTGnFdtn+YE6oRhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLVxxk9RnwYKmLOem9cngp/smPMoCxexPoh0d0aNk5s=;
 b=JRAwGkq9U1HxCJ2EZA0Rr21RnBOHv1G+H2u6C06+tu+9AWKb/pRvnihts6q+aZ68hkkFpLVaD2L/UjnD0tj9dKuzXvvZOyg/8ahobC2YNRETfDy1Zs3tJkXNrl2QmKIE9iKmSjfykVPYE3JoFaOUC5SUi/kanB8rcUNXyT0rbcs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 30 Sep
 2021 18:22:27 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:22:27 +0000
Subject: Re: [smartpqi updates PATCH V2 03/11] smartpqi: capture controller
 reason codes
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
 <20210928235442.201875-4-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <2a3d7205-ffee-f0b1-8c98-3702882441a0@oracle.com>
Date:   Thu, 30 Sep 2021 13:22:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-4-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::29) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by BY5PR17CA0016.namprd17.prod.outlook.com (2603:10b6:a03:1b8::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 18:22:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16037db4-4a47-4f09-6039-08d9843f41bb
X-MS-TrafficTypeDiagnostic: CO6PR10MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB553965B483B9FD224EA8781CC7AA9@CO6PR10MB5539.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +L6R12MAcYMo6WOj6VaLyveTC+LdxIN1uhMNTW6G6Ah4YnGeUwEeQ65kdFH4T2pApvCJ4RNW9/qsVBjSywgYwJw8CNue6esuuqrx/6FUJb20RBpOxpQeWeJYjPljemN+P8iAZHsjNaWgq7qyjVUtferhla/kHujY5MO8Bb3NfCfhvYm8lCz2mPgkTtxrSUOjUTLnN4OZFt+hXyTpyGxUwY0ZAg/0Jmaot7D+eyNDWngCubTXkZvRO412AEIBY+998Y8k+eB+s2FL+02NzP0jopj3371dC1ZaRv0/VJHSpxcsAgYKjprJ2lsBGj62bNkdtcsv1CjhDxd5eHGdmpycMB8WieVzATdQ8i/w8EsAx+N89i2yFJW1W2CVNLi58IQGxdG1FHy+72tiktZgrJmH3KcZHVmjbwv5BwDgtUYbhv74fmU/Gy1y89RK144RfNr1EXBf/CJPjB0uJsRtUrbt8SevGt4GpectVLjpHttKly0fsG1Sx6W4z42wbbbkyfJD+P9yDPvM59lzyONdmlyev5CFyvGj6y9YuBcwkc0qBe31KRPJfXBWDS845Q12YtGfCq3Voex54Q7WVkJzMgNLFfAx5FvVoW9UVWTxiVFZotdHY8cfXNK6wJbxixPiwbcV6hsH78UfdgwHofpQg043Zw6XIRVwe3TjoCRcrhrLjYfvbzt2CStewzMpJj1DSw5fcqbzPRkAg9BPxVoLCrNlWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(8676002)(2616005)(956004)(31696002)(7416002)(86362001)(6506007)(53546011)(8936002)(26005)(186003)(2906002)(36756003)(6486002)(30864003)(38100700002)(31686004)(5660300002)(316002)(15650500001)(9686003)(6512007)(66946007)(66556008)(66476007)(508600001)(4326008)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qkx4WnpZRThtVktRWUN5VkU1dFl1ZGtjUm03S1ZYVHZVYlFTRzJiN1QrTklJ?=
 =?utf-8?B?VTBNclRvNEhHZDhzbHhLZTVFNVQ5dnhHN21vQ1p0YjlWNSsrNFVVWXkzaXhG?=
 =?utf-8?B?Nko1TmtMdE43NmRjNlJHNVlSSlZoSU1WU0dyL3VBazU5M2VsaVo4ZVpVQmdR?=
 =?utf-8?B?RGswbXM5ZGppajlaNStKQTllaGUrN21OUm9xOWEvbFlIV0hoTktIYXI2b2FN?=
 =?utf-8?B?bEw2aGIydG85Kys3VVA1UElUalN0VjloUUU1OXRNWU9MTXhnblREN3NiQ0xq?=
 =?utf-8?B?bS9iYkdMREdZZFhxZUFEakk2OWFmZXBrcHhNekRYSktmcnpsdUJrTVFNczFj?=
 =?utf-8?B?TGdheEU5VUIveWZWRE1BQU8wN3RxcEZIa0dWQjR0Zm1tRmUxVFNVUXNoR3F4?=
 =?utf-8?B?NHAzemE4K3A3NHh5L0QwNTBEbVdjaHNPVUs3TnZTKzFzcFNZUGlIRERDdGow?=
 =?utf-8?B?OGo4SjNMVkdHNWdkWVJub2VTalRQMzZzNWU5Z1VqM0tseEhVS0psbFdPYi9C?=
 =?utf-8?B?Zmw5ZU5FOW14eDlBb1FjSGtQSENzenozQVNwTXQxZ3VzaTZwM2lGRFlsM0Rz?=
 =?utf-8?B?RWRIY2ZybkIwaGY1MDc1elc5a0lXRVpxd280bTZweDZnOVk1OVBIQXhoblpI?=
 =?utf-8?B?TXZ2VWdpRXNsazNTTnFJU3hrN25qU3IxWEVtTlV6WUJIbFJpWWx4N1J6VDRR?=
 =?utf-8?B?cFQyM054SVQxOGoyRndmcll6VXpXcmx0S1VsMFpQQ0pRcUs2M3g2MlFkbm5a?=
 =?utf-8?B?dDJxVWJZL1BzK0ZCZW9VajZwdHBmYTRvYStROFdwdDhxbXFhRjZYdFA4ZXJF?=
 =?utf-8?B?NEJqc3dFc1JoK01SdGlqV0kxOCttNHQzSXVDRnFTOTBSM08vU1ZNM0llaWZE?=
 =?utf-8?B?bFJCc21yOVRacG1Ecm1QN20zZHNBWjRCVDE3TlVmcmpiUUx2QmhkVzgzcHcx?=
 =?utf-8?B?dUFrNmtmQ0JJaHNXYzF4amRPQURJdlFUblJwcndERVZ1UnlxRmpNbnhWSnZj?=
 =?utf-8?B?U1RRYkxDT3dkY0hJK1lETlc2SWtuNHhXRHhBSklGSGRmU3lsYkh2SHY3dmJZ?=
 =?utf-8?B?Z1VWOVhQckJUVzJ4RnBsdUJwWnZYTVFLTmJKZ2dFb2tCRjd3MUVPVy9yaHda?=
 =?utf-8?B?Ly9SeWd6a1RVcW1VTUlFeGpDOHJpMUErZzVPSFI5b1ZmeituRHU4dFlUZDN2?=
 =?utf-8?B?dzExcHpMNjVINE5xYTdOTnFNMnBvMlV2WEYwYkFMeFF0K2N4bHJSaUUweE9Y?=
 =?utf-8?B?aVlSREZTeFNWeUZuMDBReTN0SDFtbGZhb0g3N1Y4VUdpemtnODBnK3pPZVpq?=
 =?utf-8?B?b1JjTzdkZ2NGTC85THpWYzE5SGFJM01wdjZQUGViZFhaZ1p4Zk5LbTN3RHp0?=
 =?utf-8?B?dWtPdjYvbnB5Mkc5dUpWWHRodG4yYnhCOUptVGRkQkNpejh3Z1RPcTBFQk43?=
 =?utf-8?B?c3A4cjhUOWh5S3IxZlNwSDhxaStaQTUvbjYzQjRiMlVWTC8wQlhUUE9aL3VS?=
 =?utf-8?B?OVZoSGhGMWdrK0Q2VnhXNTEvMldJQ1htYUdzZCsveTd2MjZ2aUZYQjNrcXky?=
 =?utf-8?B?bWdCb1llNUVDN1NzNTVucHI2a3N1dFNaSDNuMmNrS1NwTGNmRk5OQk5vL2ox?=
 =?utf-8?B?bUEva0pmR2haSHg4SEtSaURWekFFcWpxRzIvaWRRSWJ4cm8xeVhUd04vQldy?=
 =?utf-8?B?ak0zd2xoQkJZUDUrUnJyYXc5amNUMGZTSE9IM1psc2RSWmFkVWxQa255USt6?=
 =?utf-8?Q?jX82K+gLmwug0avJjzLJiIAAH8vvls48ohGKHT9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16037db4-4a47-4f09-6039-08d9843f41bb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:22:27.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smnC83wt9/2cgQzRNCbrsJTpeVDyWPVcJKMuQiw7I/NltTfuiMZ8cHTq0iLzmtPNIbAuLuRFSVhOfsj0BqWwKIG2MaihWjQToTWYiXhY1nI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300112
X-Proofpoint-GUID: AHXvOTaFU_9aMS3EwPjzimHUPI41vCOx
X-Proofpoint-ORIG-GUID: AHXvOTaFU_9aMS3EwPjzimHUPI41vCOx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Murthy Bhat <Murthy.Bhat@microchip.com>
> 
> Store controller reason codes in a controller register for
> debugging purposes.
> 
> In some rare cases, the driver can halt the controller.
> - Add in a reason code on why the controller was halted.
> - Store this reason code in a controller register to aid
>    in debugging the issue.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi.h      | 25 +++++++++++++++--
>   drivers/scsi/smartpqi/smartpqi_init.c | 40 ++++++++++++++++++---------
>   drivers/scsi/smartpqi/smartpqi_sis.c  |  9 ++++--
>   drivers/scsi/smartpqi/smartpqi_sis.h  |  3 +-
>   4 files changed, 57 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index 70eca203d72f..d66863f8d1cf 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -82,9 +82,11 @@ struct pqi_ctrl_registers {
>   	__le32  sis_product_identifier;			/* B4h */
>   	u8	reserved5[0xbc - (0xb4 + sizeof(__le32))];
>   	__le32	sis_firmware_status;			/* BCh */
> -	u8	reserved6[0x1000 - (0xbc + sizeof(__le32))];
> +	u8	reserved6[0xcc - (0xbc + sizeof(__le32))];
> +	__le32	sis_ctrl_shutdown_reason_code;		/* CCh */
> +	u8	reserved7[0x1000 - (0xcc + sizeof(__le32))];
>   	__le32	sis_mailbox[8];				/* 1000h */
> -	u8	reserved7[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
> +	u8	reserved8[0x4000 - (0x1000 + (sizeof(__le32) * 8))];
>   	/*
>   	 * The PQI spec states that the PQI registers should be at
>   	 * offset 0 from the PCIe BAR 0.  However, we can't map
> @@ -102,6 +104,21 @@ struct pqi_ctrl_registers {
>   
>   #define PQI_DEVICE_REGISTERS_OFFSET	0x4000
>   
> +/* shutdown reasons for taking the controller offline */
> +enum pqi_ctrl_shutdown_reason {
> +	PQI_IQ_NOT_DRAINED_TIMEOUT = 1,
> +	PQI_LUN_RESET_TIMEOUT = 2,
> +	PQI_IO_PENDING_POST_LUN_RESET_TIMEOUT = 3,
> +	PQI_NO_HEARTBEAT = 4,
> +	PQI_FIRMWARE_KERNEL_NOT_UP = 5,
> +	PQI_OFA_RESPONSE_TIMEOUT = 6,
> +	PQI_INVALID_REQ_ID = 7,
> +	PQI_UNMATCHED_REQ_ID = 8,
> +	PQI_IO_PI_OUT_OF_RANGE = 9,
> +	PQI_EVENT_PI_OUT_OF_RANGE = 10,
> +	PQI_UNEXPECTED_IU_TYPE = 11
> +};
> +
>   enum pqi_io_path {
>   	RAID_PATH = 0,
>   	AIO_PATH = 1
> @@ -850,7 +867,8 @@ struct pqi_config_table_firmware_features {
>   #define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT			14
>   #define PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME	15
>   #define PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN	16
> -#define PQI_FIRMWARE_FEATURE_MAXIMUM				16
> +#define PQI_FIRMWARE_FEATURE_FW_TRIAGE				17
> +#define PQI_FIRMWARE_FEATURE_MAXIMUM				17
>   
>   struct pqi_config_table_debug {
>   	struct pqi_config_table_section_header header;
> @@ -1297,6 +1315,7 @@ struct pqi_ctrl_info {
>   	u8		raid_iu_timeout_supported : 1;
>   	u8		tmf_iu_timeout_supported : 1;
>   	u8		unique_wwid_in_report_phys_lun_supported : 1;
> +	u8		firmware_triage_supported : 1;
>   	u8		enable_r1_writes : 1;
>   	u8		enable_r5_writes : 1;
>   	u8		enable_r6_writes : 1;
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 5655d240f7a7..b6ac4d607664 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -54,7 +54,8 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
>   MODULE_VERSION(DRIVER_VERSION);
>   MODULE_LICENSE("GPL");
>   
> -static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info);
> +static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
> +	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
>   static void pqi_ctrl_offline_worker(struct work_struct *work);
>   static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info);
>   static void pqi_scan_start(struct Scsi_Host *shost);
> @@ -226,7 +227,7 @@ static inline void pqi_check_ctrl_health(struct pqi_ctrl_info *ctrl_info)
>   {
>   	if (ctrl_info->controller_online)
>   		if (!sis_is_firmware_running(ctrl_info))
> -			pqi_take_ctrl_offline(ctrl_info);
> +			pqi_take_ctrl_offline(ctrl_info, PQI_FIRMWARE_KERNEL_NOT_UP);
>   }
>   
>   static inline bool pqi_is_hba_lunid(u8 *scsi3addr)
> @@ -3180,9 +3181,10 @@ static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_inf
>   	return rc;
>   }
>   
> -static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info)
> +static inline void pqi_invalid_response(struct pqi_ctrl_info *ctrl_info,
> +	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
>   {
> -	pqi_take_ctrl_offline(ctrl_info);
> +	pqi_take_ctrl_offline(ctrl_info, ctrl_shutdown_reason);
>   }
>   
>   static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue_group *queue_group)
> @@ -3200,7 +3202,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
>   	while (1) {
>   		oq_pi = readl(queue_group->oq_pi);
>   		if (oq_pi >= ctrl_info->num_elements_per_oq) {
> -			pqi_invalid_response(ctrl_info);
> +			pqi_invalid_response(ctrl_info, PQI_IO_PI_OUT_OF_RANGE);
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"I/O interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
>   				oq_pi, ctrl_info->num_elements_per_oq - 1, oq_ci);
> @@ -3215,7 +3217,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
>   
>   		request_id = get_unaligned_le16(&response->request_id);
>   		if (request_id >= ctrl_info->max_io_slots) {
> -			pqi_invalid_response(ctrl_info);
> +			pqi_invalid_response(ctrl_info, PQI_INVALID_REQ_ID);
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"request ID in response (%u) out of range (0-%u): producer index: %u  consumer index: %u\n",
>   				request_id, ctrl_info->max_io_slots - 1, oq_pi, oq_ci);
> @@ -3224,7 +3226,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
>   
>   		io_request = &ctrl_info->io_request_pool[request_id];
>   		if (atomic_read(&io_request->refcount) == 0) {
> -			pqi_invalid_response(ctrl_info);
> +			pqi_invalid_response(ctrl_info, PQI_UNMATCHED_REQ_ID);
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"request ID in response (%u) does not match an outstanding I/O request: producer index: %u  consumer index: %u\n",
>   				request_id, oq_pi, oq_ci);
> @@ -3260,7 +3262,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
>   			pqi_process_io_error(response->header.iu_type, io_request);
>   			break;
>   		default:
> -			pqi_invalid_response(ctrl_info);
> +			pqi_invalid_response(ctrl_info, PQI_UNEXPECTED_IU_TYPE);
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"unexpected IU type: 0x%x: producer index: %u  consumer index: %u\n",
>   				response->header.iu_type, oq_pi, oq_ci);
> @@ -3442,7 +3444,7 @@ static void pqi_process_soft_reset(struct pqi_ctrl_info *ctrl_info)
>   		pqi_ofa_free_host_buffer(ctrl_info);
>   		pqi_ctrl_ofa_done(ctrl_info);
>   		pqi_ofa_ctrl_unquiesce(ctrl_info);
> -		pqi_take_ctrl_offline(ctrl_info);
> +		pqi_take_ctrl_offline(ctrl_info, PQI_OFA_RESPONSE_TIMEOUT);
>   		break;
>   	}
>   }
> @@ -3567,7 +3569,7 @@ static void pqi_heartbeat_timer_handler(struct timer_list *t)
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"no heartbeat detected - last heartbeat count: %u\n",
>   				heartbeat_count);
> -			pqi_take_ctrl_offline(ctrl_info);
> +			pqi_take_ctrl_offline(ctrl_info, PQI_NO_HEARTBEAT);
>   			return;
>   		}
>   	} else {
> @@ -3631,7 +3633,7 @@ static int pqi_process_event_intr(struct pqi_ctrl_info *ctrl_info)
>   	while (1) {
>   		oq_pi = readl(event_queue->oq_pi);
>   		if (oq_pi >= PQI_NUM_EVENT_QUEUE_ELEMENTS) {
> -			pqi_invalid_response(ctrl_info);
> +			pqi_invalid_response(ctrl_info, PQI_EVENT_PI_OUT_OF_RANGE);
>   			dev_err(&ctrl_info->pci_dev->dev,
>   				"event interrupt: producer index (%u) out of range (0-%u): consumer index: %u\n",
>   				oq_pi, PQI_NUM_EVENT_QUEUE_ELEMENTS - 1, oq_ci);
> @@ -7323,7 +7325,10 @@ static void pqi_ctrl_update_feature_flags(struct pqi_ctrl_info *ctrl_info,
>   		ctrl_info->unique_wwid_in_report_phys_lun_supported =
>   			firmware_feature->enabled;
>   		break;
> +	case PQI_FIRMWARE_FEATURE_FW_TRIAGE:
> +		ctrl_info->firmware_triage_supported = firmware_feature->enabled;
>   		pqi_save_fw_triage_setting(ctrl_info, firmware_feature->enabled);
> +		break;
>   	}
>   
>   	pqi_firmware_feature_status(ctrl_info, firmware_feature);
> @@ -7419,6 +7424,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
>   		.feature_bit = PQI_FIRMWARE_FEATURE_UNIQUE_WWID_IN_REPORT_PHYS_LUN,
>   		.feature_status = pqi_ctrl_update_feature_flags,
>   	},
> +	{
> +		.feature_name = "Firmware Triage",
> +		.feature_bit = PQI_FIRMWARE_FEATURE_FW_TRIAGE,
> +		.feature_status = pqi_ctrl_update_feature_flags,
> +	},
>   };
>   
>   static void pqi_process_firmware_features(
> @@ -7519,6 +7529,7 @@ static void pqi_ctrl_reset_config(struct pqi_ctrl_info *ctrl_info)
>   	ctrl_info->raid_iu_timeout_supported = false;
>   	ctrl_info->tmf_iu_timeout_supported = false;
>   	ctrl_info->unique_wwid_in_report_phys_lun_supported = false;
> +	ctrl_info->firmware_triage_supported = false;
>   }
>   
>   static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
> @@ -8459,7 +8470,8 @@ static void pqi_ctrl_offline_worker(struct work_struct *work)
>   	pqi_take_ctrl_offline_deferred(ctrl_info);
>   }
>   
> -static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
> +static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
> +	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
>   {
>   	if (!ctrl_info->controller_online)
>   		return;
> @@ -8468,7 +8480,7 @@ static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info)
>   	ctrl_info->pqi_mode_enabled = false;
>   	pqi_ctrl_block_requests(ctrl_info);
>   	if (!pqi_disable_ctrl_shutdown)
> -		sis_shutdown_ctrl(ctrl_info);
> +		sis_shutdown_ctrl(ctrl_info, ctrl_shutdown_reason);
>   	pci_disable_device(ctrl_info->pci_dev);
>   	dev_err(&ctrl_info->pci_dev->dev, "controller offline\n");
>   	schedule_work(&ctrl_info->ctrl_offline_work);
> @@ -9303,6 +9315,8 @@ static void __attribute__((unused)) verify_structures(void)
>   		sis_product_identifier) != 0xb4);
>   	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
>   		sis_firmware_status) != 0xbc);
> +	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
> +		sis_ctrl_shutdown_reason_code) != 0xcc);
>   	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
>   		sis_mailbox) != 0x1000);
>   	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
> index 8acd3a80f582..d66eb8ea161c 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.c
> @@ -397,14 +397,17 @@ void sis_enable_intx(struct pqi_ctrl_info *ctrl_info)
>   	sis_set_doorbell_bit(ctrl_info, SIS_ENABLE_INTX);
>   }
>   
> -void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info)
> +void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info,
> +	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason)
>   {
>   	if (readl(&ctrl_info->registers->sis_firmware_status) &
>   		SIS_CTRL_KERNEL_PANIC)
>   		return;
>   
> -	writel(SIS_TRIGGER_SHUTDOWN,
> -		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
> +	if (ctrl_info->firmware_triage_supported)
> +		writel(ctrl_shutdown_reason, &ctrl_info->registers->sis_ctrl_shutdown_reason_code);
> +
> +	writel(SIS_TRIGGER_SHUTDOWN, &ctrl_info->registers->sis_host_to_ctrl_doorbell);
>   }
>   
>   int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info)
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
> index c1db93054c86..bd92ff49f385 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.h
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.h
> @@ -21,7 +21,8 @@ int sis_get_pqi_capabilities(struct pqi_ctrl_info *ctrl_info);
>   int sis_init_base_struct_addr(struct pqi_ctrl_info *ctrl_info);
>   void sis_enable_msix(struct pqi_ctrl_info *ctrl_info);
>   void sis_enable_intx(struct pqi_ctrl_info *ctrl_info);
> -void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info);
> +void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info,
> +	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
>   int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info);
>   int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
>   void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value);
> 

