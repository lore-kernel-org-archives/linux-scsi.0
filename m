Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01404C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 09:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLIJ5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 04:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLIJ4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 04:56:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C505F6F4
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 01:56:53 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nSqv018173;
        Fri, 9 Dec 2022 09:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=G/jp3h2ZE8Ba40YEydV63k8B1r/FCQrwsdIVwXePfk4=;
 b=LIEGgUVZBv+qT4PdZfVt+IwtzcYxM5qiB7MDLIhjsbC+m+gqLwUOseFF+8kZwS9Qa5LS
 bvuD+b7LefvNEuaR0AAZIvq2f2S4Zp6myJg0lyQ7zBiFT8MROd7aMZVq5peRnqRT443H
 xIL+Qqvx2JQ7J+eOJqarwh+3quHpPhgyGKl9zYyn5ERhCVilrL81ESrJrfJkd71FSzx6
 No4J5Mx0acquUlXiHOWgFCHzHKBCH4MLUA9bk8K9sI0vtlmWVv2eJVX0WjoAwcTD5Fg6
 NoNFnpZ2WM6TB3o9F+iuhi15uwQV1x65mBTAEmASuxTLiRET1vef4f7TYgmuK7sPRQuY Tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkmnym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 09:56:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98Qsfa025362;
        Fri, 9 Dec 2022 09:56:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa810dvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 09:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3ANlPY65ucSyZ+bkM/ZzsKRM1oVYMwIxgoA5UkSVPcuTEuvLt6CWhLWWZnrg9Hqa7PHWFCmzkneNq77k6xigGVlJkMPK7IyJ6T8elcAevOciTWw3foV92Qgwy33BJxPFYHGnnK9urCyTXIYRaqnQsk3b1mHTpAwNoaM3epID0PfgC4OE1vtNChHCWkElYHNh8PVh0Qe63fi7qdnMhMYz/NmgOaithLNO3DZ88sDPAvcEXFljYOseKECjqIoEqYmbDKQzBVCJ9lTmgbm7cAvIr1BtuhRL5HYjPdIjFmaNhLeL+m2zNSDmsnkWIY3s2fac2afhA+Nu5RHBDFYlwfQvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G/jp3h2ZE8Ba40YEydV63k8B1r/FCQrwsdIVwXePfk4=;
 b=A8F6Y4AjdX6aVQwCa69LmZ/fI6eWYJmSXGgddc/3ddUN0KIlOf3eFfSfHUNmHJMrFk9myjalXiiLwCIKL9VGeqXIoho59wdSCcI8LxVGw5Y6hU8CirQsqvTQPpUV42+2PqQSiiVgyrfls+CSu5yXfalNH7uWiKxs/Sifx0kX8bev2rR1oACJln0H+hpHio+JIFGwFEXpYvPQUu7T+ln+7UHpU0ue1sxH3LaQf9BsGZknB/IOH3J20hKFYlWxILiYLE0+zQY1EiGkwEHIdrLQoXui1Rshwf/jgnfkAfYBMtk4M3oGbigHcYhwUOnZ8lRvbdoTbiDa1GP2RpjH99ZKrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/jp3h2ZE8Ba40YEydV63k8B1r/FCQrwsdIVwXePfk4=;
 b=G7Y7yqPanWQbeqs4nO80zdyE+bhfw+AHoqzsQvSRGoSU/c29g1NY09YOAXFz8htJuolq3WYSdoJGzo2Y5VnS8BleXH9Rk83UhBEeXeg7ep3imv1tsZEpch0Yy+s93ZX/v+ZfBewN0+nb4IaRSJkbdTGSzKpRIHuXzJLeHen5ojo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6772.namprd10.prod.outlook.com (2603:10b6:208:43b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 09:56:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 09:56:43 +0000
Message-ID: <07e6e2e1-20bd-f0ba-7c44-8fa3c6e0d8ab@oracle.com>
Date:   Fri, 9 Dec 2022 09:56:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 03/15] hwmon: drivetemp: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-4-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: aec9f7eb-bb50-4d3d-bda8-08dad9cbacd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwxw0a5hrt/l1zxQDJzkUb9WEPIWxj1IX1E7vl//YOXyygMGR7dPRgg7+uVvSfkG7o/dibTcaT7F62UeBXyR/CeH9Gm9JBvABeddD+ZcKLXBh3BCzw76HWz/H6DBQmE8rM27+1aIvftRPqx0JPdHw/3Nf/8Pfz8PjOKAiVNWFWneJiai8npq6SMPJmR4GkCMj6IbHe/qg0tRppTa+rCuiQaPkjV7CRPENmzfnUHEvk6sOEIU7pNI8ZLXly64nKDUBkKVlOjK5cjotg9MS59GC4ofCFwq2G2mJhuI2gZoxfJZ95B6FHb9SLYnXJqd/4+IR/0lNq8WftjUdlmTw3tIKR3S4+a2JVI2IbRmzZVL1CtnohfuSoT3QA8lqtwsckWfxwD2M9ikXw0r7lvkg7rwZHt6n/qrC0rXAIGleYYwHhXjA9ZS3D0uauuLwSN737ooYCa6jXWZqurV+cN95PqP4pMB8MKj/Z7AFQj/OZhjcmpAdzrLB1eLTv7OlvLZGGTQALCINh5+a4zIMpZqpG5igHq8GQjQ+yR/4R0Ol7wv4zwAR+ove8nz6atOmKKtzYbVNocGw/M4u28Iu5cC9fHUbQsxCjkGhQpLhU/cCWAlhFJnW98DM1znInMggklMTMB9SDSHpMu574UGPDVeGf8EBzGWkequtpjI7yX7MJiXMhTXF20K4pLBKCuQMt2nCOZZ7F60of2cQMQ4RfFkEHl5w64O7JFDGauyCTZ01mXGWDubtBzK56okLm+d6zVwKRjnkCg39qNXekXBztb+9w4wjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199015)(6512007)(26005)(31696002)(86362001)(2906002)(66476007)(8676002)(31686004)(2616005)(66946007)(66556008)(36916002)(186003)(6486002)(53546011)(316002)(41300700001)(6506007)(6666004)(38100700002)(83380400001)(478600001)(8936002)(36756003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEZHRi82OHFMSHUwWGFycGpneHdOWnF0SEEwZnJ6bDFvR2pKU29FeTQ5cnRp?=
 =?utf-8?B?S2F1dndTSHBEZHdnRzltYWxla01uY0Q2eHA1NTk2USsrYkFhTjdadEdKOHpG?=
 =?utf-8?B?TnFRTHowR1hwTnNxUzF1ZzBDUm5XZ3d2N21KT0l0bEJKYTBmTVBiQmhqZDJh?=
 =?utf-8?B?c2lzV1VDVzhxTkZjYzN3ZnBwb3IwV2trT2Y2eThmZzZtMzRrVkRrWTg2RCtx?=
 =?utf-8?B?SFVWc01zUTRtaS8rS3RTbU1hUGRPTUhVRGVQY2w0MUo3Vm1oei9QVVo0aXQ4?=
 =?utf-8?B?Q0xBNjVscy9UNHVHbUd3VmIrM2h4SlUyWVdHTkd1M1lEL2NkSGNHeWFTSStW?=
 =?utf-8?B?dC9LOTZtWU9WeVI5Z3NNTGZrWmRaMlBKenRtVUpNYjI2UkZBQ2R6U3Z4UjUw?=
 =?utf-8?B?UEduUStzWk5CYXVKL1hKOXFLZXh6YWErWUJkcC9FVlgveEpvUWJ5NExYTlhG?=
 =?utf-8?B?SVc4NDl5SXJiVHFLdzAydWV4dUV1ejN0dEJaOE8wZVcvZDNvRGdzOEZqVFVK?=
 =?utf-8?B?eStNc2hsNnpCcGNJZU00ZVM0alhZd0FheWhBcWJWR3dXbnlmM1JoVWhaQU5D?=
 =?utf-8?B?cW5qSy92TU9MaXBhbVh5cVlmZUpDRFAxOWJIQTlaUXY1N283emF2NGUzTTAy?=
 =?utf-8?B?SWlmaTR2MnJ1aUpieitPMUd2dlhPaVhIR1dFdW4yR0JFbTIrdTh3RExhSmUr?=
 =?utf-8?B?elBzR04yZlBsS2kyR1lvV0cwSnByMkxVc0dCM2hwd1Y5dTVMZWNBZ3IzZ1FH?=
 =?utf-8?B?QzYrbVFoRk84V3NoN0J2RmQzS2MzWnczSG5BRlZBaUZxK3JJNFdpY2N1QjBK?=
 =?utf-8?B?OU1QMVp6S1AxSFFBZ3FuazZwUFRvM3B5a2dUR2ErbWQxSnhIQXM1TUE3NXV6?=
 =?utf-8?B?a1dnWTdrT3l0UXNoTnRLRGhEeTRiSHB2b0ZJTkNPakJyZlRnMnF3OUJQeE1T?=
 =?utf-8?B?bUl0V1ZBRmNsQ2dVcU55b3dnSHc2WWNtRlRiOW9TZ2VYVG1wOFlSbVlUSTFl?=
 =?utf-8?B?UnF4bk92b3l6bitRUTVrelo2RkVLZVk0ZExBY0pVZkh0TXRTWVlreGFjOG9F?=
 =?utf-8?B?d1FhbTNwQzVNOGJEdjVrcVdXU0tFbGcremJXd3p1YW9FT1FBRXlUQnI2M0V4?=
 =?utf-8?B?WFFGTWxYeE91Mm5IZ21rSEhXNUd0ai9SQkR4endCb00weDZaL2ZnbUFoZGhJ?=
 =?utf-8?B?amhRUnA1VFlmTERyN0RkaXAwV0RBeUFsVVZBcTlWWTYyUjhVdHduZitZem8v?=
 =?utf-8?B?ZmttK2Z3c1Bzako4WjVKZkdGTy84MlZSZCtLWVIvUGdoc0hab3Bab1Y3T0xP?=
 =?utf-8?B?MkxjS0Z6UWFJZ25taXhSRHRLZE1vYXhJeGxwQ1lTNTcxQjEya3JhZWRZbnZH?=
 =?utf-8?B?YXJ0UGpMYmRGcjcxYkJNdkVyTUZXdG5XWHA5aEQzYktDWGlMKzZGY21KeTNp?=
 =?utf-8?B?RE54b3EyRHVHanZkdERCdS9RajhwTDNna2NaNHMwSmozTm9SWll1Qis2Q3Nl?=
 =?utf-8?B?N1dNNGNtc1FmL1BLbTZUMUNkOUI3ZUJHZVZBaU15UHFuVXdyQkFlR1ViTUtj?=
 =?utf-8?B?Ti9BQWxHdjVYaVBxb29VblFTbTNUVklMazVJcklEc2drQXlLamNuUEZGOFVD?=
 =?utf-8?B?Y0NFbDVNMjJOcmdDalJ4QURNWEpmOUpzSllqTEJUTTMzR05QVWhwajErVEFr?=
 =?utf-8?B?RFIyS09WNVBzYWZkenUvdVF6bTdlSDFCL3BnclQrbDIrWmVDUzVGcGpwbnR5?=
 =?utf-8?B?aUNrOEgvbkE5Si9peERZZUFuNldTcGpNOWFYcVhiNmJ4TllSaEplUjZ0cVJU?=
 =?utf-8?B?bFQ3ZEZHTi9uNDRqUUhPREhvL3Z6UFYxZVZ1cDV5NlBKb1JaaFovS2ZwV3VJ?=
 =?utf-8?B?dlI2cUFQNWYrS3N6aGoxRGVmZUl2c2xONU9mN3lzYU40R2x6RVBvd20wK0s0?=
 =?utf-8?B?cTEycnkxT1pHR2c3eXFaMng4bzg2aURjZUJDSndoeUtrVURUUlJQREQveTUz?=
 =?utf-8?B?eDBMYUNPWVhjT29qVHl4cE9YaFQvZVArT2NQZ3N1M2kySUY0K2ZMRTRlS0cx?=
 =?utf-8?B?eTRnVlV2d3dMM3ZUUnRucGlMMHF2L0hDOXBtMEQzZlJndlF2amxFLzJCdmY1?=
 =?utf-8?B?RmZhMWdwV055QXFzLzR1UFJDU1M2M29yY05GcVlvOUlUS1NPeHRnTHdNVFhN?=
 =?utf-8?B?bFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aec9f7eb-bb50-4d3d-bda8-08dad9cbacd9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 09:56:42.9760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qO/h2oQ33+JG2fdFUE3eocSg2PZBVm4PTF6cATV9+JVuzxJC1l1/3k2CCKVCkwLBgIrrxLee9wA00CRfUOjJ/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6772
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: 0PmOoxIVBVhu5rz5vxlU3W1gRNbh_ZUA
X-Proofpoint-GUID: 0PmOoxIVBVhu5rz5vxlU3W1gRNbh_ZUA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert drivetemp to
> scsi_execute_cmd.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/hwmon/drivetemp.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
> index 5bac2b0fc7bb..2434ddb000f0 100644
> --- a/drivers/hwmon/drivetemp.c
> +++ b/drivers/hwmon/drivetemp.c
> @@ -164,7 +164,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>   				 u8 lba_low, u8 lba_mid, u8 lba_high)
>   {
>   	u8 scsi_cmd[MAX_COMMAND_SIZE];
> -	int data_dir;
> +	enum req_op op;
>   
>   	memset(scsi_cmd, 0, sizeof(scsi_cmd));
>   	scsi_cmd[0] = ATA_16;
> @@ -175,7 +175,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>   		 * field.
>   		 */
>   		scsi_cmd[2] = 0x06;
> -		data_dir = DMA_TO_DEVICE;
> +		op = REQ_OP_DRV_OUT;
>   	} else {
>   		scsi_cmd[1] = (4 << 1);	/* PIO Data-in */
>   		/*
> @@ -183,7 +183,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>   		 * field.
>   		 */
>   		scsi_cmd[2] = 0x0e;
> -		data_dir = DMA_FROM_DEVICE;
> +		op = REQ_OP_DRV_IN;

I was thinking that it could be good to have a small helper to convert 
dma_dir -> REQ_OP_DRV_* at some stage

>   	}
>   	scsi_cmd[4] = feature;
>   	scsi_cmd[6] = 1;	/* 1 sector */
> @@ -192,9 +192,8 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
>   	scsi_cmd[12] = lba_high;
>   	scsi_cmd[14] = ata_command;
>   
> -	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
> -				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
> -				NULL);
> +	return scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
> +				ATA_SECT_SIZE, HZ, 5);
>   }
>   
>   static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
> -- 

