Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941B1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B8F61A0C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351545AbhI3S0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:26:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42398 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348612AbhI3S0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:26:17 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIL0xr009796;
        Thu, 30 Sep 2021 18:24:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1bVcMRUDceR+w2sQayDXcqFve4OAPy+c3EyQGiFkJrA=;
 b=Qc1uOa2bdspHM6JpuftTOif3YqkmMQTyHwQBzdfo+09QL0XB4VwhGb6V/n9Gh7lm37xT
 nDnra5LDrIZnkZz6qTkfso9al2hNuK17YPWEUQjekSkbFyJ5aESd4pXMRqJ/uXwFeuBi
 RuAW7tj1f3p808VFnZhKnW0w4cN1TEx/GQ2qrDGsKJ7KfM4KtZevNrDbJZ+IP/L4pWN0
 UJ9rzGLeSD/xeMAWiVuMs83O3+nHuEGKi6t3IFU/a+I4CDqaD57Ojml8iv7B4hIbJY9Q
 Xuy7gZVx4jm5GBJBsDDExUN7I/Kh0xxJuMH9XWgZPhsiymf7mzSbiN5QdbMQpoalKCRS KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bddu8tfqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:24:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIEXhP099643;
        Thu, 30 Sep 2021 18:24:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3030.oracle.com with ESMTP id 3bc3bn1kkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:24:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9FN1y1lLlHrsKl+FqkI8tgrieNIR6R1PxwsiGZpaelnZTtqdD6STEla+98NDeShu4J3J4uBU2d5M3k+7SnT6l7S9JGtB6iW7CX2x4JaO9vhZHAQsb/nxPmcy2weQWohQ5QSvwTqAgwqVkTaTo2f1LCLYKHi9smo4xDwpPvVBpEgH0oDMybVPN+tJZa35Ud45FEEw7nMiBBgpFkkQb4ZA8U4Db2xN8Lx38U42FEZToRXsn5n5bbYu6ctdKdFo6rwZvYpmyFhAneq3SygCn8jKYTS1I97OxjKPRJ7okM2sOv/o6d3fHmEWyjPEuvLDCipIQAeKJDjplxOOuyxmzq3sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1bVcMRUDceR+w2sQayDXcqFve4OAPy+c3EyQGiFkJrA=;
 b=mQgI8VtKvqVQJt72KuyKqtw/EWqHPcDERRJoIGWkwyWL8RzXJ1JsfOOGwSGX69SBOLQzrxoxuBM7McLilt2vgyBpj6EdNky43AAQiZ+oPfwXaRTxCIDLZtEjFXt6rEybvpARGugYIagiPHunn2/HiRk3xmHkY3JOOtAHCQdBsAPs2fHsqBoXao7UGVZ/ovZ6qh2WQkqAuKH+AU38ecSts0jGD9Gd6hlUYPVGSZ0q7THzOyNg71iIPUSJSU+eDpVPBWjaRckwq9BcDjhk5uGuHz/IoUghQRig3dGaPBHOkGR+W2URDzK2MJg2Y+SMfG+diNQz0iDSxrBuoqF9WE6/1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bVcMRUDceR+w2sQayDXcqFve4OAPy+c3EyQGiFkJrA=;
 b=OeFD1tj8nov0CtLgUGKSnZw3W/8RWlOGFw4mau7llJxtGpcPXuo8spGf0ucrj6jwXBSVee0Li3w8fHYzOi4qr+KYlMfMXhUcWX3Wuax5RIRiZzzYyPKw0/WO9o7FZnG+sl2zqcQp/otSQE3iR8yGLgpJ5wGBt2sWezkfNTmPZQg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB2032.namprd10.prod.outlook.com (2603:10b6:300:10b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 18:24:13 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:24:13 +0000
Subject: Re: [smartpqi updates PATCH V2 08/11] smartpqi: fix boot failure
 during lun rebuild
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
 <20210928235442.201875-9-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <700a1f15-5d26-31b5-1a2e-b733883fcac3@oracle.com>
Date:   Thu, 30 Sep 2021 13:24:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-9-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:806:130::35) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by SA0PR13CA0030.namprd13.prod.outlook.com (2603:10b6:806:130::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.8 via Frontend Transport; Thu, 30 Sep 2021 18:24:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b7f8e4a-7b00-4623-610c-08d9843f8147
X-MS-TrafficTypeDiagnostic: MWHPR10MB2032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB20329C4E472CBB43AB07E756C7AA9@MWHPR10MB2032.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RAfcBYtIWJqdSDfBa9ADdJk733W6zboZ53jj/y/CuLAQ2eilFqWyjGurBn032eRv3KYYT0gRGnCd92CZHemi/4uX/Eyj3/1mV7kuW3IatPOwZBzwNkkMkZRl8vcR/2rj1d89vtVo9yxWPnekI5HFwoH4nyxLDAYb9R3Vq/xMSNrtQhczKLFBh54VonPGsY/C0bwiCCc7Bw4J+/yKpoB11rWtB47Y/ijUl6+EroJhaTcJVOXYnNSXzSaSltEnig6U5apTNprQ7etnm4rmGzLwex4zvGArxueXAEpc4JKuiiYq9zJuG3RcZthLd5IYfMzEVVS6rotWa3woQ+jaCOkuEELKeRXhT9JcSRCrgGxncoIlkwpt/JrlbJTigPHdWr60hIIo5M73VzBe2dXPle09tR3qpIBHs67KX9/wFLihbcSB4Iri0wgMZs4zn+ZVQU0kGaA2zIl45UwR7cbuOrAUm0m/zwmmxCLf7TxQiiK3jVl57+yN/OnS3qdDnixgIhstsi5i7FwbhqX186eZCvQY2ThGxn274D3709IsZ731BcLQEf3kXDyOzglJahzyOhXABARbaVSJf9jWIb+g9qFMH0a0T3957/jB1Yz4ovp1YUVoluilszytpA4IRw6RENoIGcHSk7vqCNGXSmlsWItfV6Pe+HOtPrMAVwZM1BqKrP4yUlKIuXd/lQx/gHY0bLc+9efRIna+l/iBJDiudfyrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8936002)(66476007)(83380400001)(508600001)(66556008)(6506007)(26005)(53546011)(2906002)(8676002)(9686003)(86362001)(6512007)(5660300002)(31686004)(316002)(36756003)(31696002)(38100700002)(7416002)(2616005)(956004)(4326008)(6486002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1A2VnBWbXVWajhIaGJlZ0dlM3FseGhsSkJCVmhWc0xZRlFIZ2M1WkVRL0NL?=
 =?utf-8?B?aVpnN2thZmVFUlZWeHk4ZFBsN1JwdEF2SmNpSHZvNUtlTDZRbXFINDUxblkz?=
 =?utf-8?B?bldlNnhTMVRWWTZWUFJiWUNuOHVEUllVbWRiaEdhUWhZRm9vOWgzN3JUaUh0?=
 =?utf-8?B?Q29TeVIwb0ZFYVZWUUNiTlV6STVOWUwyRWduZ0hlU2x0TzFib0hxTVNWTEpk?=
 =?utf-8?B?OVhLdEhvRjhDS0U3Q2wwQ1lPNFpITE9BdnQ5R3M1cWNUcnhUVTM3QmV3ME5M?=
 =?utf-8?B?TWJxMkpWaUFORVpWQXdlVitQZ0NKL1YzOHlIRitXRlhDZHBhSEJtUHd6Z053?=
 =?utf-8?B?OE91bXpEelV3YnI5bW9WelBhMTNCNEQxVWx1ZEdCMnZzRmlCK2N0b0F2c0Vu?=
 =?utf-8?B?WVQxc3ZLVUZiRktiVERRK2JteTZib01zMi9Ob2Z0MVl4SjhzZUl5Qjd0Q0s4?=
 =?utf-8?B?WnliZG9YeEpEY2ZCNnZWM0pYTkZxVkwrK2h1QWlNa0k0OWJyMkV3SjExQVQ4?=
 =?utf-8?B?WHEwUE1ITkdTUWxiQkdCSGczQktSR1hGTzlKd0xQTEZhaEw1T1MyZHB4SU5n?=
 =?utf-8?B?NFRoeHlWd3hJYUVsVTh3Nno3Y0Z5ZXpZMlhyMHFHN1VpdmpmMXNZbzFRTHIx?=
 =?utf-8?B?Vm13Nitteno2bzBMWHhuV0ZmSzltaER0QThnVVVxMjB3TU5WaDRpZnpqeGRR?=
 =?utf-8?B?SFdON0k5bnFRV3JxMUwzQnFJTnUyT29ia1BkcGZkMmV0QXROYWJaYURCaWt0?=
 =?utf-8?B?RnJ6UWx6SUJQNWd6TWR0SmZFdzVaRVl6Z3BYMU16cVY0SWx2MzB0NnJaRTJW?=
 =?utf-8?B?eVBuUWF2aW41QWwzL0lTL1IzalU5NERCTEwvWFdvV3pEakpQbXpMNkZURjk1?=
 =?utf-8?B?WWhmajMwdUxmOVVHU09Cdm45Qk5tL2U4R3dRd1pablhhQmZIYWNaOVM4cmtB?=
 =?utf-8?B?RWtqbmE1bkZnRGlTT0tCVzRKaHI4NVpma3BpTmV5TWhsU1B6a29WZmE1U0JQ?=
 =?utf-8?B?QXpBZHNNMEh4anM2cmxzTkphRms4WTM5eU53WHZlei96T3phc2lCbTNCbWhC?=
 =?utf-8?B?TFFiQlNvSlhvTWNzNmh0dUJtc2NaeGZ0cXdTWWI1KzVJTWxGeGVnNTIveW44?=
 =?utf-8?B?a0J1djVpQTc1R2NRN29vbXVnY3NmY1ptN0tBRmxYSDNWc3h4cEZSdTBxVndn?=
 =?utf-8?B?UXd3aEZLR1ZqR2ZlbzJ4SFhzcHJ6cHRha2dpcGo2MDRxcGVUblZiekh5bnJ1?=
 =?utf-8?B?WFpHUUhMemYwYjBxMDdoQWVXdUNUV0d5elROTVVFYjBkTWhpcjBFaXJVMjVi?=
 =?utf-8?B?UXpWc2VJTXZKKzhBajV4b3JQQUVPZFZCM3U0SVQ0S3I0eHptelJ2S3ZuM0hw?=
 =?utf-8?B?SnJuNmdEVGNyNnFML2htTU82VUd6bkdjTGtFMjJKUC9mTmt6Ny90VzZtcFF4?=
 =?utf-8?B?b3J2S2hzSFZVdGlGWEMrdVF0U253NVF2Wk5hQVVjS1NKaERkdUxJdEpNb3o4?=
 =?utf-8?B?TkYxNjEvWGpTUXAxanNpZ0sweWVHNUNReVVyaDdzUytKVDA5Wm84Q3pPYTAw?=
 =?utf-8?B?aXhFZWZlenBKcC9nZUlHK1lrZ3dRY0xVT2Z6TUV5VXhGbzBXZFoydE10SElq?=
 =?utf-8?B?NTFPdjliUDVCenRlREZiVFdKdDRrdlEwYXR1ZDJsWU1pcEkwVC9GdDIrYmx5?=
 =?utf-8?B?dFlaelZ6RDRTOHNxVlRIMXFiSjJQZ1QwUEVzYm5qSTN0RnhGMER2LzV1OEZu?=
 =?utf-8?Q?6IVJtxsVfUVL6YQzDkLlxX114t8rvfunmCvKECs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7f8e4a-7b00-4623-610c-08d9843f8147
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:24:13.7416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WH+cKUt3M00xpbbzTlOYlJL1xnBZupzHGPJM7uJEyPqcD3KzlVhZuoKpaP/xKDhmZHjs1J2PWQ0uiuOi2dYXn8iXhCG9pOGW/NRevc28Rh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2032
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300112
X-Proofpoint-GUID: Z1fsUfCMVoeqFx6gGVuSq4xKp7EZotcT
X-Proofpoint-ORIG-GUID: Z1fsUfCMVoeqFx6gGVuSq4xKp7EZotcT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> From: Mike McGowen <Mike.McGowen@microchip.com>
> 
> Move the delay in the register polling loop to
> the beginning of the loop to ensure there is always
> a delay between writing the register and reading it.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>


Acked-by: John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 1e27e6ba0159..c28eb7ea4a24 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -4278,12 +4278,12 @@ static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
>   
>   	timeout = PQI_ADMIN_QUEUE_CREATE_TIMEOUT_JIFFIES + jiffies;
>   	while (1) {
> +		msleep(PQI_ADMIN_QUEUE_CREATE_POLL_INTERVAL_MSECS);
>   		status = readb(&pqi_registers->function_and_status_code);
>   		if (status == PQI_STATUS_IDLE)
>   			break;
>   		if (time_after(jiffies, timeout))
>   			return -ETIMEDOUT;
> -		msleep(PQI_ADMIN_QUEUE_CREATE_POLL_INTERVAL_MSECS);
>   	}
>   
>   	/*
> 

