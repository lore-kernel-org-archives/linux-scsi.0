Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D949C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 00:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F153464DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 00:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhA1A5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:57:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36076 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhA1AzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 19:55:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S0cY2m196439;
        Thu, 28 Jan 2021 00:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gQqDaTXxkVjpE0VPTHaf+Hqd8IMhsZ7Hb1Ep1Bl/Irk=;
 b=uQubxn7KaSWIonPd6eBdLF+u4ZD1xNIF1H7TgGb+0pVOXLDNPrj0GcJPSFnHogDDrwsC
 twedlBnYG46+xL38dW8RUey9fI2al2qKX7KQ71DSL51NoqtALMkfG9vnCoYE+/ZFtTvH
 z46fif79YAGAOBG4NRUaihESGT/7iGX7vfIW3OLj3x5yJoiWNPU10bLNceb30nwjPLgE
 D8ThjsDHhOLlSw8i+TxgPNMfAccYaElVmIljL8GiEDw90jYq1oYEmn3vaF6ayPmqvdLU
 WUhRQpwL4Lwlil45pWQztbEUBUEXkvtpNcpcapAUB9V8u9IJmXkjYReMKQO9sUge88Oy /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 368brkss8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 00:53:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S0Z8qw114459;
        Thu, 28 Jan 2021 00:51:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2059.outbound.protection.outlook.com [104.47.36.59])
        by aserp3030.oracle.com with ESMTP id 368wcpxg1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 00:51:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMjKbSm8HCwdToQfVJLLtOSHILJIxR5KnOKIEybLug/Xw3UHptacL5dE+NRzpqEa24wYggGJjNp9DPhuKJu+pvSRyM9UAZfLj4RBrVtMF1tjUpxQI7qBO1fzodYBU6o+Z7hhbZ1ZSh3u+69KFGnSomPOtY38NtLJZ6S9FlwlCHUaRPugxNeqFNmM1BUcJTesiCqDNGFPk/jh03g7T/r5wRwmhU7Ru9uUY0fB1OpvR0H4nRiLa4fBzPpdU8QwBgftLcXvrk6P7rLXcFtWOMxn5U+uze2fMP2cvfh16bVm5IDL5QMxRRzFXXG3tSxdcmyuAnGgLOuw8pjpwG0cvG2H8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQqDaTXxkVjpE0VPTHaf+Hqd8IMhsZ7Hb1Ep1Bl/Irk=;
 b=lQ9ahX3FSAbzCOcSsRhGnFQS+pdJJhpWPqn2gxuemuUv07+6IUMGk9C7EXfP/rV06Kffv/q6elWlH0OiYM2k0nzWGAaJybifK+8AoXXnB3OAxQESLUGd9X2vWwcBGjbDo0yX9u1RQ7Jxktq0bok8hE1Af2AahpoylvyfaN2vWiLa5SwKMA3TA/29Fp/PFd+Y7eTgvjjYPvDvbBgk7gQpQTID/MU6ozD9bKLsmJILXYFZC63AIpfXF/8FtQWd+76EQVksxQOfzdxLlcg3/LNrNQJ9xq3H5vbdPmWLcilDRxiLe62O2+dRWqCvPddc5MP69m1Y4qmZBzjZ4MhMSW+XBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQqDaTXxkVjpE0VPTHaf+Hqd8IMhsZ7Hb1Ep1Bl/Irk=;
 b=OVYAY++sv789K0eDa46ZYWF+ZtHVCNUt6v7M2nhBOw2SbZWB3e1/P9GoytBDUO8fGPyQDWbu1r5/l+f+vdaML/J7syDC5i1kuHF2ena6+Unxm0aOHNlmF87U3gsGQtwN4AAWThz61NWhCmlInpxnjTJvG5vvmgBNu3AMKVFcVQY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5221.namprd10.prod.outlook.com (2603:10b6:408:122::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 28 Jan
 2021 00:51:47 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 00:51:47 +0000
Subject: Re: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>
References: <20210126130212.47998-1-hare@suse.de>
From:   michael.christie@oracle.com
Message-ID: <e5c71e73-f36b-8ff8-ef4e-d424304431a6@oracle.com>
Date:   Wed, 27 Jan 2021 18:51:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210126130212.47998-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:610:4f::26) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.12] (73.88.28.6) by CH2PR18CA0016.namprd18.prod.outlook.com (2603:10b6:610:4f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Thu, 28 Jan 2021 00:51:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52182e25-b928-491f-5267-08d8c326e3ba
X-MS-TrafficTypeDiagnostic: BN0PR10MB5221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5221698F538D7A40FE459CA1F1BA9@BN0PR10MB5221.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mW8sRQaN+iaaNriBvGpQxucrKR9jlJWmPKIlhptRpImtQ9TSLpuf9n5jnkPZ5kVAK3+dzlboH1eU/zHKHgHAJdVNu6DctMu1Mot7XFfHkEUVoHnXPmmwMZdrqpzUSgMZdJtviWBUm1TJyUj2/8hrAGI1PtW0v1+ZFyMMAxj+U27EIc/+llvg+DpfYA5m9COxCeQZXfXCE1hhoz114SIUr/uKaIEZqZmJieaJ9okZDZxl+NAOWb+LN67qnH0Vtf8Q4GYDDK3EyjrSpX833YazURXkc+ghYdUhMhrDmjmdZaA57k5dll+OjrziCg+2phdSIDZLqr2l9e8By4QqbSL1Rck5PX9FMslBXZg3Dst/MnnD2dLarQtGYP0ezuBHhKecKozxLaTHtJr67DagA1anrc/FfW9mTWg7+oz5q88GEf/MfKgqF/QOXOoNZhMGVH04Xq/tt2+Ari3OkzKb/v4GKpmefGEEy1Z/bTHmxAzJaaU2UzSvAPQbcNKhbwj+t35Uw8mt1aKavyc3R6xYjxpuza5KVaOeFt8klsnS8l8evANSuCaPg7VDftHR7v1U8xUCK+ILKVS9hQFm6G1kNrMuxYueQ4IHiQAfeqPn/hYgLhs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(31686004)(4326008)(36756003)(316002)(6706004)(478600001)(54906003)(9686003)(16576012)(66476007)(2906002)(5660300002)(186003)(110136005)(26005)(956004)(66946007)(2616005)(66556008)(8936002)(31696002)(53546011)(83380400001)(8676002)(86362001)(6486002)(16526019)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eUwvLzFvS2pIRXlad3Z0eFkvNWVPU29FNTVDYzJKY1ZCUU1oN1J4dFNWL3FI?=
 =?utf-8?B?K3IzUWlhbElXVGh2N0phWVRPQTV1Y1pEVDM2UWJFZnpnUjlDa21FVm94NjBo?=
 =?utf-8?B?YU05Y2pyeFY0bFVqbk5tT3dRbFNmOURQNlNMRkI2TGF5VkpDUDF2L0JBaUdy?=
 =?utf-8?B?MjROTzE4SEhKUUVvYWdpWFNZNnpOQlZNbEJBYThWS0pGM2dnUld4dDE4ckN0?=
 =?utf-8?B?MUxzSjBOVmdiODRocXlDYThXOVRkZ0ZteEtXcGlwNStOOHhGRjd2a29jZnlP?=
 =?utf-8?B?eHBnSnoxWE9nMkxqVlk3UU1pOU9HazRaTmxaR2pFYlY5emR3N09mQU0xWnc2?=
 =?utf-8?B?S3lVWHNoZGpidld2czlDK256cld6MG9ZSHNCWWEvUUFwejZ3bWg3cTFuQUhO?=
 =?utf-8?B?aVVSS3FMM1BrcU9KUDJzaWc0TUl3ZHp1cVk5L0xMSE5kRW0reVROQW1UREdo?=
 =?utf-8?B?UUhiTnBsa3B3d1dFOHpQbjk4RTR4d2NHT2dlMGVxRHpWTDdTNVBRYU5nOVVD?=
 =?utf-8?B?VmVXRlZXK2d5REVYY254NVhiZk9ncmU1eU95UDArNXkwL3FZNllodWpwM055?=
 =?utf-8?B?ZGlBMlNIU0RjQmQ3WDZ6R00yMnowakVRdmI0VW1rcWx6Nmx2Sm1uVkpPaWlC?=
 =?utf-8?B?YnJUZno1bjZQRW42UitMWVo3RWl6cjFwOFVma1Z1WmN3R0loeDNQWisybVRq?=
 =?utf-8?B?YTZ1aHpTT3EyZ3RsaWRxRWlqZnNBdlc4Q09kcS9LVHJzWEZYRVViMkRzVDdG?=
 =?utf-8?B?WXRBTW9PRWQ3cEhyMEs5aGkxRXRsbHQvRStkRjg1UENqbDA0UGtyYnRGVTAv?=
 =?utf-8?B?NTRUdW45cVAxRm1RU1dPWDkvNG1VazRjbGFiOEd3bWNUNWxSSHhvQWNOZzNh?=
 =?utf-8?B?NHE3b3ZicG5jejJXWjN3ckYrbGZlSzZiV3pwYTM1Y1J4SjNVbkVqWXNOWCs0?=
 =?utf-8?B?eTFmZjYvYWdYb2VrMzJ3UTlPazlFMTBnbHVaR1kzQ3gxTFRId2VzcXR0SlBK?=
 =?utf-8?B?bFRhYVZTdUVtWDFTODRoaUxLNXJMdzAzQm9DMm1NQ01McUxUYi9qSWVEOFlU?=
 =?utf-8?B?cDd2bnVzN0tkMS9JU2EyRzRLSW80R3JUWXRoSEF4N0ZNME0zVDNWN3hnM09y?=
 =?utf-8?B?cmVha053NkhodUVQVUNWVFZHQW5kcnlTcnBIVXFEK3c2dGVrVWV2M1dRbmgz?=
 =?utf-8?B?WkJRSlREcWhpVGV0YTBjbWw5enN0NWFkQVNMczNNUkY2Z0x6ak9rMTV5MDAw?=
 =?utf-8?B?YlRlZFBjcnAvWTBiRUdxenBxSjhSQVE1VlZPTWxpMHRGNTVpMEcrbzdEOVBs?=
 =?utf-8?B?NDAzc2RaWWV1OVluMXBubStLZ1lOVlNCL09hZURveHpTYWIrUzB3YnFjS1ZR?=
 =?utf-8?B?N1ZKdkZJN2ttRkVSdTc2SGd1M2dBZ3I5dVJZTnVLdXBXRnd2TVNlenVsZWJQ?=
 =?utf-8?Q?GjqO/ivU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52182e25-b928-491f-5267-08d8c326e3ba
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 00:51:47.1536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hf5yeQDzWonJUm1M3o7U92iY0PQ6UMx8UYsHFtp0Fmc5BWqiH79XTWg8YmpsatHDTYAx8OCcpUDmtj3C1otUc0H4+RWRWQskw2xaRSUOetE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5221
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/26/21 7:02 AM, Hannes Reinecke wrote:
> When a command is return with DID_TRANSPORT_DISRUPTED we should
> be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
> the command if set.
> Otherwise multipath will be requeuing a command on the failed
> path and not fail it over to one of the working paths.
> 
> Cc: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_error.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a52665eaf288..005118385b70 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1753,6 +1753,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   	case DID_TIME_OUT:
>   		goto check_type;
>   	case DID_BUS_BUSY:
> +	case DID_TRANSPORT_DISRUPTED:
>   		return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
>   	case DID_PARITY:
>   		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);

We don't fast fail for that error code to avoid churn for transient 
transport problems. The FC and iscsi drivers block the rport/session, 
return that code and then it's up the fast_io_fail/replacement timeout.

