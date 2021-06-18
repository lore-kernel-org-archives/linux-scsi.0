Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0296C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 17:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8400C613EE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 17:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhFRR4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 13:56:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5452 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231449AbhFRR4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 13:56:11 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IHl0gg017452;
        Fri, 18 Jun 2021 17:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jk+91m2gD8bD1L0zJr8oW/KKPzwYWNlmiscsDAEup2Q=;
 b=ExIitU5Tss74wG7eqV1GE1CXvV57elZDNpOpgiXmuC3gIoO7yltgbFTU8kVeqf7TibkA
 aRkTxz+mByskhPJpDDNsYk5pjS/MEis++yQ2wn+G4lmJtrgaGZ2ufNqWqrhmtiB3hEfH
 bgTQk7OqjSWPFWnHOy1JTWcJe9+ddpOYNECg0t9m+zv+eVlePkqr/6yxPWhDtu/uf5ws
 3bLW9BBm3nZivkpxlbXKWOcQmBLSzKHZ0iJu6cuD4V/mdOWHfxZLAT7FrPM9ZIWme7S6
 dUm1l+7VVQr4CJ5y2tXIUkCNv+8wJEjwJKmeds32zMba67N8hqwDEmIgDsds1jnaT6Iq cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 397mptmhb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 17:53:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15IHjCp3065850;
        Fri, 18 Jun 2021 17:53:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3020.oracle.com with ESMTP id 396waycecw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 17:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4N+6Aa4x/h4vVxSPiHMWD4DeaE0hHbrqxjf1WGi5N2+jruLPNR0KROn9TCX+BLP7CuiOLjY9O8dp5vABh2jXU7W2qfXtgigrC9MAqeRvywUWGhkOhiv8vP/JcrYNuR/IJ2dPiDwgiMmDrYRAltYlaBLT3esD5cXRt1IcR9ia1e0mnbg3FfVuSGrPMLINbUwDflYjptXCqjTCcxqkWXg+eGWtUTLYSdL+d1it7iJVlHbC8BuRPVcONx8QjrEgOP6g0DfyTOC/m2UNNxcwtoJqJD28UWA/v8xFm0m6RhQ7Ch1LRlaoZRVvQpYLqkbxAISpbbaAG8993xIvaH/Ai0f9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jk+91m2gD8bD1L0zJr8oW/KKPzwYWNlmiscsDAEup2Q=;
 b=iCgp58+aflAchg0Yxe//01kZkVPa6FNXYYhVBlEwY/TtjXmlFkIGZDdpLupin1GGfFg6DEpzTYgPTmqYqOFVX3rkja3QIRwYCgU2atTmgkxSEj37jU2rgjuNdViYs7TGHUlr6X7CMy7aLhccuYsa9JEJFIiRKA+CXhMlwhW1MSG6wwSBDcXqccvejTvROOb5m54DgCeJvsLyx1ScGghaAB0qB1l/d8j7qgkzgh3u1TRqftbc8Fxn1evMr3fqQEDqwVWunKOqPwQ9wPqpaYoxMAbg8NVtwT9dcAAs3xC+GU38wKaEJIWGhhurvO1lnfsPo+IvzRSXRQ6LUl/E2eCGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jk+91m2gD8bD1L0zJr8oW/KKPzwYWNlmiscsDAEup2Q=;
 b=CAyWLkk8hWf/31iW/F0MQ7TlP0J/jiW66aTds6ar/3g1zuP4oycc5GWtWs/C7N689ZRGR/7tfHaGhiPxSZcDNF3N6yPFOBsbGWTSQftauGOSoJHKB0y+JY5Xkydt1zdX/8KXwhofXJlYBoZijD7vFWqMzksh5c223y4iHkFPvZA=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4762.namprd10.prod.outlook.com (2603:10b6:806:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 18 Jun
 2021 17:53:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 17:53:55 +0000
Subject: Re: [PATCH] qla2xxx: add heartbeat check
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210618094911.20377-1-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <e9d2498e-77de-c606-5db5-01b8424f82b1@oracle.com>
Date:   Fri, 18 Jun 2021 12:53:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210618094911.20377-1-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN7PR04CA0119.namprd04.prod.outlook.com
 (2603:10b6:806:122::34) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN7PR04CA0119.namprd04.prod.outlook.com (2603:10b6:806:122::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Fri, 18 Jun 2021 17:53:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0bb71ff-f612-4f33-ffbd-08d932820a97
X-MS-TrafficTypeDiagnostic: SA2PR10MB4762:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB47625B638E1075B1BBBFED3FE60D9@SA2PR10MB4762.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:217;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ep1YlXjZ3JC/x8TEd7FxXtc2Dp9defIYbNy/9BNvpPTCr/39G7b4K4HBNW7bT81NYrRcDEyHcPXlxNOz9QGAM5pniKPatHlfyysM0k9UlCOtFfFT6G+ybfo2JR5n/Om3zPdvBkvEjatIWLchN6oyK/uARTSd03oHWvjF05du8sDoqommXBxF6sgKdFp84ySc8laSEEEai2UvNBeTOkl4Sfqu28mGH6s9LH4JAPyE7uC58Jo1S1yO9XTv8iroX7/PP2vE9HHmSnu9CjRu4BNyp2xRfvS0j6bJNSABwYTdVwoHa78a6I6PcNQcsrj1bsvHA7pczAPF+8uAyjR1ECx3/acFUdj/RW0t69Ti7UBtS2wNlz7qBFNzp567gClP5XLsocjD0D9rMEXaQb8ctlwqtf9PGBLSalLF+zmoRJgOmQiBk4XW8p8pi/lU/9alNXGehMZTDWKk+G2+mmy6m2qTUnmT+7WMm27eHJQxXBSQ6G9Qk7j6Ue/v5W0w2cYVyra7fObA2tGpkIdbYBU9ZYwiy6QNHZgyRICbWpjXu8XbeP2RGALhyquPYwO3zkrtTieiOQZUQf89E7uVNGbpIyhqYoNpTUlldPRBEKT0kMoJJcLBy1PPG6FLZIK8hvdO3RjGZuWNLzJD+QbTg6YtYh9ja+/YfNxjHkUsjRTZcTJPHsip7nVx/pocSJcaZOo4FaFB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(6666004)(31686004)(6636002)(53546011)(2906002)(36916002)(36756003)(83380400001)(478600001)(66556008)(16576012)(38100700002)(6486002)(4326008)(31696002)(16526019)(316002)(26005)(8936002)(186003)(86362001)(8676002)(44832011)(2616005)(66476007)(66946007)(956004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFdJZE1rV1R0K2RaMTU3SGlhdjFSYmM5V0hDN0dKNkJEU0lWN3NhaUhCTm9O?=
 =?utf-8?B?dkZUU3BJZm1QMDVLUnN2MGE5MmxhdU95MHZWUzFGSnJ3WFFxM2NGb2FLdDVR?=
 =?utf-8?B?a0tocjhtMW4xSE81Y3NiYjFkcmJWTjdoRlpRdW0xWDZXeVRBYmFrMFBFcEZ5?=
 =?utf-8?B?dDhzaVJHeDF6UDVWVjl0SklQZ2NiSzlFazNjU0IxN0xCSXE3Sjk1SDgvaHdu?=
 =?utf-8?B?U1h2NEN3emlUQ3E3OTNETmJwcG1Qd0xUM2ZWckFsRG5LcXNZRUltOUIwd0pt?=
 =?utf-8?B?Q01jVEUvT0FCYktHcWZxelBWRGFmRW9SU3FBemNVZFVnYWQwNkJsalBONTQ0?=
 =?utf-8?B?b2hoZXhPMDVoL2pMNGxKMis0b1VaYUVvU2xwTDZvdzBLQ25pa1MzRDJGTFpk?=
 =?utf-8?B?SWYyOGJpQ1hWSTZneE91OWNwakxYQUczUi8rVkEzQzFIbUJiOGR4QXBQWGZ1?=
 =?utf-8?B?UnZlcmwzaTQwak1MZlBhYUJhc2RuQ2ROOXNtWDJJK2s4YTJERVFWcEE4ek4z?=
 =?utf-8?B?RWhYeUdjVGRjaTFDWVc4R29qbmRpQWRvaXpGdmJPWFpkN1BWU2ZRY1ViSUho?=
 =?utf-8?B?L1hqZ2hpTjIxalJTQUJOb05qeG11RWlSUElVWkpnZ2gyczhyZ3RiSmN4MzlT?=
 =?utf-8?B?cC92RFRRTTJhUm5LcUFWNWNNTGdFL1pmc0M2bXNac3NiRE1lMTBHd29nZmYr?=
 =?utf-8?B?RXF2YkNqc2YzVEhMaklUWmdhNFE1OUxlemhJYnlkaTVJdmdNOVVNZ0J0a0w5?=
 =?utf-8?B?SXlPYnpmTEZOdkJpajh6TGxUSklab0owQzlMK1hzSHU5aEFIMVNHdTVGek9h?=
 =?utf-8?B?L2pVL1RsaGpBbzdXbmFiR1RJU2J0ZFlETTJPUFZtM1l4MkFWUmdxb3ViWlBM?=
 =?utf-8?B?eEovNWNKYzNEa1hCTm9DMTkrOEIyaFlqckpCZjEvbitBUEIwd3V5U0RNeEQz?=
 =?utf-8?B?b2FNUE5ZOTdSQzBVRHlDTXl6b2l5YWxzU3QxQVRqT05wL3pxSHpLWlR3V0Ny?=
 =?utf-8?B?WFVyM0xPRjl2amF2TjhHTXAzQkkyRUVCRkhmMlVCRG50K0swb0xEZkcvdUc0?=
 =?utf-8?B?dEJLQnRvUGFYWlEwT3RiU1R5VDZoYW1TcXF6ZVpWVnpZd05JMGNKcHVaMlU2?=
 =?utf-8?B?dGRLQm9DbjZIZldhOFhkSGcwTS9CcHpnQit5WGpYWTIzUk9uV25pM3BjdytI?=
 =?utf-8?B?SG0yMUFLa0l1VTFTRTJiR1BoRWM0YXlLdThWRVhLbEp1ZUwyRGt1NHNjMWdi?=
 =?utf-8?B?ODd3RDNlbWdBL2FpYSt5Z3QrSE1UUXJabjhsYjBrZmRkQ0syODdBMGVRbnRH?=
 =?utf-8?B?bkVud1NLNnFzTjQxRHl2RitSN0FycWIvZURITmRFODlUUUs2elJlUGQ3SHJI?=
 =?utf-8?B?ZVU0dDYyK3NQdnowTlM2VWZhNkdjalpGa3B3dXIvV1BZajBYN1llejF0TUZO?=
 =?utf-8?B?a0NueTgzS0NWcitrUTBTSEtLMmZ2dDk5eHovcUFkN1M3dDZzZ1NQMWZxUys5?=
 =?utf-8?B?UTFpUzk1VHNneVpubmNmUThmT09LUlFDMyt2dVZOSHpweStodXpMTUh0QkhL?=
 =?utf-8?B?RjZHNURZVVNsck1rTGxoUWlhQSs2RXJHMmk3VmNVOWxVcU9hVXJVUXR1aHMr?=
 =?utf-8?B?Q2xHa1FPUjliRGtpT2V3MDc2bkI5OGo5bkI2RHIrY2pCTXFERGE3ck5PeS85?=
 =?utf-8?B?Sy9EZ3BHVW9iK3p1Z0w1LzdISUtOYnBaakp6bEgrYWlhZDBmVVkyMWlBTSsx?=
 =?utf-8?Q?b0KytAkGTuINaXZw3wExZY/DYaTYxvdFh+2sJ7x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bb71ff-f612-4f33-ffbd-08d932820a97
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 17:53:55.5366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DskYe5f19eroWnbWfiCnt7Me0v3elBCRFP5NzW1cbXLItnmZmPhcmswxt3uHgrPXeplr7eAFBCgQQCUlFzDqj2R/YCmuwZuJ8D30xnOFNMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4762
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180104
X-Proofpoint-GUID: 48bmqpxnitwTED01XsdCAy5jqkgHujFD
X-Proofpoint-ORIG-GUID: 48bmqpxnitwTED01XsdCAy5jqkgHujFD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/18/21 4:49 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Use 'no-op' mailbox command to check and see if FW is still responsive.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |  4 ++
>   drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
>   drivers/scsi/qla2xxx/qla_init.c |  6 ++-
>   drivers/scsi/qla2xxx/qla_iocb.c |  4 ++
>   drivers/scsi/qla2xxx/qla_isr.c  |  4 ++
>   drivers/scsi/qla2xxx/qla_mbx.c  | 27 +++++++++++++
>   drivers/scsi/qla2xxx/qla_nvme.c |  4 ++
>   drivers/scsi/qla2xxx/qla_os.c   | 68 +++++++++++++++++++++++++++++++++
>   8 files changed, 117 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index def4d99f80e9..2f67ec1df3e6 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3660,6 +3660,8 @@ struct qla_qpair {
>   	struct qla_tgt_counters tgt_counters;
>   	uint16_t cpuid;
>   	struct qla_fw_resources fwres ____cacheline_aligned;
> +	u32	cmd_cnt;
> +	u32	cmd_completion_cnt;
>   };
>   
>   /* Place holder for FW buffer parameters */
> @@ -4616,6 +4618,7 @@ struct qla_hw_data {
>   
>   	struct qla_hw_data_stat stat;
>   	pci_error_state_t pci_error_state;
> +	u64 prev_cmd_cnt;
>   };
>   
>   struct active_regions {
> @@ -4743,6 +4746,7 @@ typedef struct scsi_qla_host {
>   #define SET_ZIO_THRESHOLD_NEEDED 32
>   #define ISP_ABORT_TO_ROM	33
>   #define VPORT_DELETE		34
> +#define HEARTBEAT_CHK		38
>   
>   #define PROCESS_PUREX_IOCB	63
>   
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..70b7cda0a25a 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -551,6 +551,7 @@ extern int qla2xxx_read_remote_register(scsi_qla_host_t *, uint32_t,
>       uint32_t *);
>   extern int qla2xxx_write_remote_register(scsi_qla_host_t *, uint32_t,
>       uint32_t);
> +void qla_no_op_mb(struct scsi_qla_host *vha);
>   
>   /*
>    * Global Function Prototypes in qla_isr.c source file.
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index eb825318e3f5..f8f471157109 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -6870,10 +6870,14 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
>   	ha->flags.fw_init_done = 0;
>   	ha->chip_reset++;
>   	ha->base_qpair->chip_reset = ha->chip_reset;
> +	ha->base_qpair->cmd_cnt = ha->base_qpair->cmd_completion_cnt = 0;
>   	for (i = 0; i < ha->max_qpairs; i++) {
> -		if (ha->queue_pair_map[i])
> +		if (ha->queue_pair_map[i]) {
>   			ha->queue_pair_map[i]->chip_reset =
>   				ha->base_qpair->chip_reset;
> +			ha->queue_pair_map[i]->cmd_cnt =
> +			    ha->queue_pair_map[i]->cmd_completion_cnt = 0;
> +		}
>   	}
>   
>   	/* purge MBox commands */
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 38b5bdde2405..d0ee843f6b04 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1710,6 +1710,7 @@ qla24xx_start_scsi(srb_t *sp)
>   	} else
>   		req->ring_ptr++;
>   
> +	sp->qpair->cmd_cnt++;
>   	sp->flags |= SRB_DMA_VALID;
>   
>   	/* Set chip new ring index. */
> @@ -1912,6 +1913,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
>   	} else
>   		req->ring_ptr++;
>   
> +	sp->qpair->cmd_cnt++;
>   	/* Set chip new ring index. */
>   	wrt_reg_dword(req->req_q_in, req->ring_index);
>   
> @@ -2068,6 +2070,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
>   	} else
>   		req->ring_ptr++;
>   
> +	sp->qpair->cmd_cnt++;
>   	sp->flags |= SRB_DMA_VALID;
>   
>   	/* Set chip new ring index. */
> @@ -2284,6 +2287,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
>   	} else
>   		req->ring_ptr++;
>   
> +	sp->qpair->cmd_cnt++;
>   	/* Set chip new ring index. */
>   	wrt_reg_dword(req->req_q_in, req->ring_index);
>   
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 6e8f737a4af3..8a8e355f4a89 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2322,6 +2322,8 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
>   
>   	if (unlikely(iocb->u.nvme.aen_op))
>   		atomic_dec(&sp->vha->hw->nvme_active_aen_cnt);
> +	else
> +		sp->qpair->cmd_completion_cnt++;
>   
>   	if (unlikely(comp_status != CS_COMPLETE))
>   		logit = 1;
> @@ -2976,6 +2978,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
>   		return;
>   	}
>   
> +	sp->qpair->cmd_completion_cnt++;
> +
>   	/* Fast path completion. */
>   	if (comp_status == CS_COMPLETE && scsi_status == 0) {
>   		qla2x00_process_completed_request(vha, req, handle);
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 0bcd8afdc0ff..9f3ad8aa649c 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6939,3 +6939,30 @@ ql26xx_led_config(scsi_qla_host_t *vha, uint16_t options, uint16_t *led)
>   
>   	return rval;
>   }
> +
> +/**
> + * qla_no_op_mb(): This MB is used to check if FW is still alive and
> + * able to generate an interrupt. Otherwise, a timeout will trigger
> + * FW dump + reset
> + * @vha: host adapter pointer
> + * Return: None
> + */
> +void qla_no_op_mb(struct scsi_qla_host *vha)
> +{
> +	mbx_cmd_t mc;
> +	mbx_cmd_t *mcp = &mc;
> +	int rval;
> +
> +	memset(&mc, 0, sizeof(mc));
> +	mcp->mb[0] = 0; // noop cmd= 0
> +	mcp->out_mb = MBX_0;
> +	mcp->in_mb = MBX_0;
> +	mcp->tov = 5;
> +	mcp->flags = 0;
> +	rval = qla2x00_mailbox_command(vha, mcp);
> +
> +	if (rval) {
> +		ql_dbg(ql_dbg_async, vha, 0x7071,
> +			"Failed %s %x\n", __func__, rval);
> +	}
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index e119f8b24e33..3e5c70a1d969 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -536,6 +536,10 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
>   		req->ring_ptr++;
>   	}
>   
> +	/* ignore nvme async cmd due to long timeout */
> +	if (!nvme->u.nvme.aen_op)
> +		sp->qpair->cmd_cnt++;
> +
>   	/* Set chip new ring index. */
>   	wrt_reg_dword(req->req_q_in, req->ring_index);
>   
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 4eab564ea6a0..aa8581e07156 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -6969,6 +6969,17 @@ qla2x00_do_dpc(void *data)
>   			qla2x00_lip_reset(base_vha);
>   		}
>   
> +		if (test_bit(HEARTBEAT_CHK, &base_vha->dpc_flags)) {
> +			/*
> +			 * if there is a mb in progress then that's
> +			 * enough of a check to see if fw is still ticking.
> +			 */
> +			if (!ha->flags.mbox_busy && base_vha->flags.init_done)
> +				qla_no_op_mb(base_vha);
> +
> +			clear_bit(HEARTBEAT_CHK, &base_vha->dpc_flags);
> +		}
> +
>   		ha->dpc_active = 0;
>   end_loop:
>   		set_current_state(TASK_INTERRUPTIBLE);
> @@ -7025,6 +7036,61 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
>   	}
>   }
>   
> +static bool qla_do_hb(struct scsi_qla_host *vha)
> +{

small nit...

I would have like this name above to look similar as qla_heart_beat() 
for ease of reading, i.e., qla_do_heat_beat() ?


> +	u64 cmd_cnt, prev_cmd_cnt;
> +	bool do_hb = false;
> +	struct qla_hw_data *ha = vha->hw;
> +	int i;
> +
> +	/* if cmds are still pending down in fw, then do hb */
> +	if (ha->base_qpair->cmd_cnt != ha->base_qpair->cmd_completion_cnt) {
> +		do_hb = true;
> +		goto skip;
> +	}
> +
> +	for (i = 0; i < ha->max_qpairs; i++) {
> +		if (ha->queue_pair_map[i] &&
> +		    ha->queue_pair_map[i]->cmd_cnt !=
> +		    ha->queue_pair_map[i]->cmd_completion_cnt) {
> +			do_hb = true;
> +			break;
> +		}
> +	}
> +
> +skip:
> +	prev_cmd_cnt = ha->prev_cmd_cnt;
> +	cmd_cnt = ha->base_qpair->cmd_cnt;
> +	for (i = 0; i < ha->max_qpairs; i++) {
> +		if (ha->queue_pair_map[i])
> +			cmd_cnt += ha->queue_pair_map[i]->cmd_cnt;
> +	}
> +	ha->prev_cmd_cnt = cmd_cnt;
> +
> +	if (!do_hb && ((cmd_cnt - prev_cmd_cnt) > 50))
> +		/*
> +		 * IOs are completing before periodic hb check.
> +		 * IOs seems to be running, do hb for sanity check.
> +		 */
> +		do_hb = true;
> +
> +	return do_hb;
> +}
> +
> +static void qla_heart_beat(struct scsi_qla_host *vha)
> +{
> +	if (vha->vp_idx)
> +		return;
> +
> +	if (vha->hw->flags.eeh_busy || qla2x00_chip_is_down(vha))
> +		return;
> +
> +	if (qla_do_hb(vha)) {
> +		set_bit(HEARTBEAT_CHK, &vha->dpc_flags);
> +		qla2xxx_wake_dpc(vha);
> +	}
> +}
> +
>   /**************************************************************************
>   *   qla2x00_timer
>   *
> @@ -7243,6 +7309,8 @@ qla2x00_timer(struct timer_list *t)
>   		qla2xxx_wake_dpc(vha);
>   	}
>   
> +	qla_heart_beat(vha);
> +
>   	qla2x00_restart_timer(vha, WATCH_INTERVAL);
>   }
>   
> 

other than small nit... Patch itself is good.


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
