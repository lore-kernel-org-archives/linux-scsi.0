Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6421CC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLIKKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIKKf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:10:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1C427CE0
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:10:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97neeu003829;
        Fri, 9 Dec 2022 10:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=t3O+vlzuucgWWJnj8sjqtqy3GoopOXqnBzgDRQO0aAs=;
 b=0NNXHlM2NqlWqCPL2ZHrrOpbmRggB0KJl5A1ytHy1gn2ZbwxzlcsZM7WSlMHnnMneGsO
 H3I9Mw5puOdbKNq1AfrRLTACSjljDlCXXTnavdb5pCDDwe6zZ+7XtNinsn7sG50ilBzX
 aBB3/IqUUQ1Lf/wF9TU7zRdBE2DzroYhD5iEuRygRKNN2MAKJEvK5VGOHnJi3wh2emsm
 EAG2SqZs3ZsYaKTVaoWyC6yYnRECJoBiz5qGMQCEGBPNy8lt3slKkyxK0sQvqM8hZc+0
 9NCRlFThlAQKf2dr+Sg9J/L8ldfnOxWPJKJi8m+cdJS5OtgnU/Ltgzrycm2p4oZwb7hj 6g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8mqyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:10:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B989BMn019613;
        Fri, 9 Dec 2022 10:10:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8k4r4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:10:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Finpuqplhu3C52jM5k0JkuT/ErrfhsWEdMvUvsWZ9F1thtp6igJVJ7mgblVtRuca1sRJTGq1pOmT1d0A850S1E8vgCRFF9DuZ6cSLQhqyipOcLe1xUt6bHO8QPCg38sgcmErEd3M2gBIq+wEFpHxhJ9EGQmVSl9lIhz0/1+VuDcf/7PsU/knJVkftCFVsxNn2dMRsTuUTAiARjqzLot1omowObJX5MeALxiFA3tv7Zabwq6EylmR/ce75UtAnW8i2dyc8atqb44wzx/96EdKMtZ0ShdGdcpCMbv0MpG6kD6I9zz1m+21OsScKzlpJgNh3MnD5qRifKVrldg2Td5Lyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3O+vlzuucgWWJnj8sjqtqy3GoopOXqnBzgDRQO0aAs=;
 b=HPzEfKtcVVQGAfZno+Ethe+LBF8KR2yXwxz5zEP+S6+MBxcBg9lTQMif+HCT9DSXowKpf/1TVEwiLgtrRjl4jQBe7JAdSTYh+vKrSqhuPguOIuaBz78SzZYURRGlhJnjbzTA0OYwehfvNg6PJwKp8U5iz6rudAOTKhf0yrCuiuFnB7zZ0JVy79TBWgSdte7/i7UrjPHLwrma/URFiMS3BVyXiKx6d+FWHzYNWyhDGNDWH0BpqnLU1KrgXw6CuunVEzywJJmquQ7EQ1k6Pj9Rap8mcr99e+LBa3jIUB0Rd4pVSH0UBoAWQaNy20P7NXM+O6YhkgTNYT3+znSeutwp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3O+vlzuucgWWJnj8sjqtqy3GoopOXqnBzgDRQO0aAs=;
 b=ovI8ZzHpscIQRBGP2HB2ZGkoXIp971k2nRTbQRzALw77Khi3A1g5KbhPMwHx5odAZ8pTa9tEeoDkDcjgxkBappEtPAnHrmHANzGExrk3Kxi6PfEGc/6IrJ2yXmbpf35vLt2jykhpQq3jIWcieJbiY0v/SIU0Ra79ZFC3MbnSBAY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5135.namprd10.prod.outlook.com (2603:10b6:5:38e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 10:10:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:10:22 +0000
Message-ID: <9f1501ae-329e-c183-0ef5-b60fa87ac5b9@oracle.com>
Date:   Fri, 9 Dec 2022 10:10:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 07/15] scsi: spi: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-8-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0341.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5135:EE_
X-MS-Office365-Filtering-Correlation-Id: 737097f1-b203-4091-feee-08dad9cd9510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtrgC2z8WtBUuPvNVyK+U7v5hve30o+xaj+50D30sC5dK/fFHcD/ajqq26r0ZPrchjaFLgeZRah1KmOPOmGj6xEc1qvG5N9AruTN0x6aCsrpWCX3rc2dxvq7AD8FnEdVswUMaEBzQ6Tc1UGt9mwENREzh+Efrv2BbrAru1Ij911Hxqf1PYrNHJN6Wa61nulpv7iUiTE+LM8PB+ShjJ9U7TZZFZnq4yxNwFoRp75ru7mLY8LV/ePgQF0KHfo6AzMkJi3lI130FVf5jnRmu9WYQ2nvwReTgMmoh4n0E+ZDOxpS4sDm5xxf118uQNJpNQcoeEA0toOd3Sghwc5WyqhzpdhD2OvwGDVp1VNHSFeCdhbIeu/Ss9+TQ/pD+uhgUSv7AJCJgeHiJ6PoisYhSjOayzkevzDnU8XTEE1+IW3aUkK+O1d/pc+PpYhK6Uuo7EKv/QrkflGzurYb3eTeQOnCcrj+BE5HrPD5/bkGYs6/+wWS7NPKLVRJTx39zuec8ivt2IImjDH8o6sVvoTtN7sKEM8MgBctg0uCgnCUNd7MiuO6tyczgxe9e0Y2BXFLH8V2FOma00BNWHt5OupzSrhqAL9DNEusqcD2+P+5bST4WtJie7pgReGEfxz3Odg9F+UQD5orcp86ylDH5xsoif1NqDLtL/lSBA2Zqb0gKg2BdYAHyEzNdG+BtRD6pZERGAsZrAFFndDHO7WoDTNoJNLFMJwHZroOBydk2/C2/KQdvNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199015)(31686004)(86362001)(31696002)(6486002)(53546011)(38100700002)(36916002)(478600001)(26005)(41300700001)(8936002)(6512007)(66476007)(8676002)(6666004)(316002)(66556008)(66946007)(2906002)(83380400001)(186003)(2616005)(36756003)(6506007)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW16eTJXeWR0d0tHSm1xejl3NG9tWEJFVUZiZy9mSU1PTWMvQlkwQy9OZmZp?=
 =?utf-8?B?Q1R3aDI4Ui8xVWpHTnI3UVhDdGx3MjFCRitkQ1J5dU85Si80Nkd3dDFoakFi?=
 =?utf-8?B?SkpuVU9wTG1rcStvTXdSYWR6dzNpdlZ1bWdEejlrZ0dKUDdZK0NpbXcrMVhs?=
 =?utf-8?B?YytTdXdSV1Q3dHFSSnBtUGJKcmgxOW1oblVJMFE2dzIvbHcyVDB6Y1p6d0pG?=
 =?utf-8?B?T0xzcXc0Q1B4N1E3aml6MWM2cTY0ZEcrQzdkTVkxSndlaEJQTVRsYXJOeWJ4?=
 =?utf-8?B?WmZDV1VpQXdJNFJKN2lSM0cwcnVOTEs4bDFoVjNRVEs5ajBJdlJrZ3hPMkJ2?=
 =?utf-8?B?aXBVcmZQdkEzQ21vVTNsT2pGMEpBamRBc2ZVaEpVNEsra2tBYkJnMURCMGQ3?=
 =?utf-8?B?MUF2MmlMQ1VSV2p4MWpjRHhiODBwREk0bFJlNzhyMGdaTnZxbThZR2hQV2FZ?=
 =?utf-8?B?LzNoRHhBUE9ibW80SWo3SzFVS1NVVmloRXVZazI5K3o4RngyVk9Lc2R3Ynd2?=
 =?utf-8?B?V1RTY1ZkRUs3aXdXVmdhZDFCS2tvaEJrd0VJSTR6R1RIRlp6S1BpcW5DTDNF?=
 =?utf-8?B?ZUpFOUlGNUUxZlljbVU5dWtBLzQyL2FoRnZIWkd4QVE2YUZDeWVvU0ZDVktq?=
 =?utf-8?B?a1RMeTJkMENsY0djc0ZwWDl4Q2RrK1NRbzV0WlRVZ2RlWXNwUFJyTkxtUzM1?=
 =?utf-8?B?ZlNmRUpmc2pVaC8zQXdNTy9iVFlaYnRaclBZY1VzZUFXUnRzck05TGd6WnpX?=
 =?utf-8?B?RXptRUFKNHFwSHNqWkRIekNzSHgxaW9UZzFuaDVBczF5NGdzL2dOOEJwNjgv?=
 =?utf-8?B?M0t2UmpUOGNpV2N3b3JNdkcwVmd5OFpUaWRaRHoyYWI2cTYxY1ZycUd1V0ZD?=
 =?utf-8?B?MVcxNWpvZG5iYUwzbGdOaGNiNW5wc1Zsa295YWxmL0tCeWI2YkVWNWYxUzFT?=
 =?utf-8?B?VUZlUWYzMmRWVjRmZDVKWXdaRGE3TkdFM3F6eUxsUUJQaVN2c2xIVkdYa09Z?=
 =?utf-8?B?U0lORW50eVpyaXdGSjRuSU0wNWluZnF3WWVyVHVNZ2ttd2V2NU5yNkEyaThU?=
 =?utf-8?B?R2ZLVmVrSitkVWtuUWZNVzZBaGIxM2NKWHJsOXczUEhXbW8rQnAvcjVKV0Jm?=
 =?utf-8?B?azBwOGZicVdYMGxIOWZXVkFjVnpIRFA1YTRPdGdXRFdWT2V2VHB6NlVRMVNa?=
 =?utf-8?B?ZWZrTXZiQ1h2Q1VFai9ybUdrZ3dWOXVZRmNVdU1aL21sbkk2cFdhWm9uUzA0?=
 =?utf-8?B?TGRURG5nQTN6OEt2TkpjbkhkUHJJWThZc3FRM2dCTlJKNHJheks3c2lZUU55?=
 =?utf-8?B?U2xqbGI4bWZjcWVkZ2d1STFyaTNsNFZEZVVWamdZWHU3TVRFNkZnRjZTUGhG?=
 =?utf-8?B?SlZlclVuaWZSalJJb3phSlJTaUcvenBLZGdsczVaTUxTb3BEdWlpYU8vc3JP?=
 =?utf-8?B?RndaL0s2alhmOC9xaWlYQStXeG5tb1RWdzIwV1JPejc0blhTMjhjbWZuVzFq?=
 =?utf-8?B?SlYva1JFSVZEUHA3UGdXRnJPaDRsa1Iza2NiSDhyb0RIOHE4V0l3MHgwTlBK?=
 =?utf-8?B?WDVBZW9aenIyczEwL0hGVUMyMk9IaHQ2RVA3MytGSU1mY0JLbktaellmWDJR?=
 =?utf-8?B?eXd6aVpnN3NWUGk4TGdoR3I0dUtoSzhRaHpYR2VXOCtLNVRSV2dyVVd1NE4x?=
 =?utf-8?B?T3Y3Y1p2bngrMXE3L3gxZHhsMzI3dklQTHVadVBraE1IUitPTG5FM2M0Nkg4?=
 =?utf-8?B?SzFvYnpvaTFWU2NqZDh4eHpEcWVZMGRTRXdZSWtIaEI4dWNudHlBQkwrdnU2?=
 =?utf-8?B?VmFVVHBTNzluOHdHbGRoTUwvU2tZNHBHQ0dIenhEZEhIWjEwVHRucjhwRkg4?=
 =?utf-8?B?ekdXcmwvNmxscTBkano2enpzbFp6OW94OFl0MmdmQ1ZvbDR3ZWFkK2VsRUMz?=
 =?utf-8?B?ZnM3Tk5iVC9WQTVaeHY1STIzaU5jRG0wWE5YSHVyTnJWcHpxcURZQ1M3SGsy?=
 =?utf-8?B?d2I2L1VPSDFmOVR0bUxsVlRGWlF2MFhmZktxd3hFa1FEdmlGbit3V3VYYWZv?=
 =?utf-8?B?ZVpLc3ZMeGZQWVJxR0x2K1JobGh2U3FmbVZJRE4wS0dleC9CdnZGcDNDbEV1?=
 =?utf-8?B?ZkZnNms3K3lReU93QS9vUCtqTFZUcVR6Y1dMY3NYWXBwbHFQS2s1cEVVNEVC?=
 =?utf-8?B?OXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 737097f1-b203-4091-feee-08dad9cd9510
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:10:22.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkC1NxGGwybOZwVzbjzlt9FHz4NnM47EQzSMyzGl7yEAZEYlsgve9Tm9/rOr8LpCg6ZCupPw3ecdZsDSKT3ffQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: zO_9EKMWj823m_60j9u6oCKY9ov1Ufd_
X-Proofpoint-GUID: zO_9EKMWj823m_60j9u6oCKY9ov1Ufd_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute is going to be removed. Convert to the SPI class to
> scsi_execute_args.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW, Apart from nit:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_transport_spi.c | 28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> index f569cf0095c2..fa06821f3cb6 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -105,28 +105,28 @@ static int sprint_frac(char *dest, int value, int denom)
>   }
>   
>   static int spi_execute(struct scsi_device *sdev, const void *cmd,
> -		       enum dma_data_direction dir,
> -		       void *buffer, unsigned bufflen,
> +		       enum req_op op, void *buffer, unsigned int bufflen,
>   		       struct scsi_sense_hdr *sshdr)
>   {
>   	int i, result;
> -	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
>   	struct scsi_sense_hdr sshdr_tmp;
> +	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
> +			REQ_FAILFAST_DRIVER;
> +	struct scsi_exec_args exec_args = {
> +		.req_flags = BLK_MQ_REQ_PM,

I think that .sshdr could still be assigned here, like:
		.sshdr = sshdr ? : &sshdr_tmp;

I think that is the proper syntax.

> +	};
>   
>   	if (!sshdr)
>   		sshdr = &sshdr_tmp;
> +	exec_args.sshdr = sshdr;

