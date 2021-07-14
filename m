Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA3AC11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C24BA61380
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhGNB0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:26:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24868 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237310AbhGNB0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:26:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1H5DL017143;
        Wed, 14 Jul 2021 01:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vAU6WyYmXRhweR0+KH9p+yRWmi0eYyD5sCZor2Z+GOk=;
 b=TawAmkYpfcAVHxxZvNzzJyLxlz/RMCypeT3Qf6AJQt1WtGnBGps/2rmleeO34/PTmO2u
 CSmnOeQzNQ1r52oWw+zLg+G+D/hdlLKuLhM34lsAOXYJRFyxxoAlHvx7wLwB6C9TBPAm
 bXwyT0gzXFN8iDk7odwCRXVbORlxF3L2FSlkK6iczLe7tg4cyvlsjP788vmHieP6UZY+
 56X7epm7TklQschmRXIZMRHZ5G/L43c274uwuODHvNeh5HiialJRLlShSumErMoe083Y
 QwlgZFDmDBGz5uCqFwJkcDwSJa+kDrITLyaEKsPWjUXn2gu0sPxWMb4jvNQh6/aNG8T6 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8uva5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:20:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1ExDF174429;
        Wed, 14 Jul 2021 01:20:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 39q3cde4gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbt1/jjTylaoo93bzFwZrCC1raSjq9IFdYLOocvR+ZuM1usmbDe1Y0HcHEIPKuRmwuPUAIRD/0kTItg3FKVhzl+bGA/x6xvwVACRP/bLoq+sXL1PtHNJy3Sfin83hQmx/JA52nAi9AQEuRsJbbUQJZRnc0UE2eFwpw/27jWi140J/kJ72DvsisVhaknHtNZdm2FjTN0zoAmkFqFdRAVtTiaMIQif84GK2tL/G7ha+MWfCNzJfCGKjmbrdiF570MTQPbxzzP5IlFiLuHYSja/+l8L9yOufrQZuNc5bwlIc5wtgV+2g6fJ5Affe1gwPwxwKSwsjRNA5kTvCOmDBv9BYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAU6WyYmXRhweR0+KH9p+yRWmi0eYyD5sCZor2Z+GOk=;
 b=b3vfDynFJ3xR5hh39XiKOBrZFhiwu9YuD7+ZjpXYJyhbHMCz1H8R1IbH9Mkb98s9tk95YBGZIfwkvvVNp5415ppGn2yr5FbKoi+pHaS+N/RbLX59wOjgMEqnLmkNSPtWQSYErz/fVZz7MvdVDZ1arDk58IT+zZyImZDqBgQg+pQycmKmR4nlrKe56sCU5sU4gtpVCO6wCcj4tFkxErqgtvunI9eUmrnKnPJsUovpR7tjiSzHxPNM856ZDdjpRo66TuvX95jvL6W0cn6w9wM7isc3BWgw47u6svBWv2Owsteh4oYCV670VJPdBdnIX2aWSB234URl9AyGhOGdENcQJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAU6WyYmXRhweR0+KH9p+yRWmi0eYyD5sCZor2Z+GOk=;
 b=NgiI9umtsHwx6wcALKNoaBYnNbDNs1k+/JhEFBrC8mWDG03Uzqat0bjCHS+XPgl4kdUH+5e0lEchIzXVaTpS2JEyfOjnVwEeBCdvyMnnYarXT4qCf5mJET1I8TbdiVfLcgEEG2M5/iNUSS6ZCMGLY1a9sSUPcjSk0GfKrMMm1rs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4802.namprd10.prod.outlook.com (2603:10b6:303:94::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Wed, 14 Jul
 2021 01:20:08 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:20:08 +0000
Subject: Re: [smartpqi updates V2 PATCH 1/9] smartpqi: add pci ids for H3C
 P4408 controllers
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-2-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <dae7df38-8d47-6287-d5b7-5f5dce45e3be@oracle.com>
Date:   Tue, 13 Jul 2021 20:20:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-2-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:3:12b::25) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM5PR04CA0039.namprd04.prod.outlook.com (2603:10b6:3:12b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 01:20:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d594067b-7c16-464a-2ec7-08d946658467
X-MS-TrafficTypeDiagnostic: CO1PR10MB4802:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB480298814F0CB7AAB1E00848C7139@CO1PR10MB4802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFzEGLz8UqhWSA7AhMdPo6wNWDmWcF6+YuoPJKjpb+w3thUXZfYjQM6RmP/aaHnwFh7dRl9v6aK8O0SfntBs35x315Qkf/C0HRgJ3dyWRMITBln3wlk2Iuu1z2oaQJBt2R1qLEn4o9aEciqQ9g1ho2Vri3iIMhb121b/SIy7r18OqXXlabYBLgCbcZt7HeD9RTop+I5bbXnFmIt48xmcc7tbo/DQyMPLV6nBzLXDFcJdWCRFMzDznTBfNpHa+LfmioZ3ew/+KqpT8agbphFXc4Fq3ipRw2x6/Q+OauHJdmh1LSHC1EcHemO40slx0PxWB6jg2ZvieRkBuMTtjvXlhOB6+3jofPkXsDpFxgbHURAog+D1/m2XS8ukztqnnLohy/Zian5HAl4HlXGJGVUHDut5rcrlaGRC8eyOBRtx9bWDIQT+/yeH0w3wry038G6T4RKtEr7RXT0qGmWZTQ0TN/UtdB4qaJRbItNyyVHzsHHZfNcbrxnPNgXGc0nSUGuvenYs8Ou4oi4hQ6OM70RwtRw6N5uCqS8dTS11baNHRY2j/RiIaEDuDr3Fw79Nq5EETOjNdziyKllpm5YkmFa/BOmoIahx6XMqZj0to/mHSifCTEGkDzkTv/1DWYUKDPCO73uiE7xhVcZVgzPo9+eR06X6G+IeCqElDQBY6v1LpU1AcQZrVFYSFdagTBDjmxa1rscPOT0GNFqmDT9bM3K4WEUJCjnvbCA9MfXl+H0aCxU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(136003)(39860400002)(376002)(7416002)(2906002)(316002)(31696002)(38100700002)(186003)(4326008)(8676002)(26005)(31686004)(478600001)(66556008)(2616005)(956004)(66476007)(36756003)(86362001)(16576012)(66946007)(8936002)(5660300002)(53546011)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDFPbGxNSzJYOGMyTXVaSHE4bGg5M0RrYTVQcm51ZS92b0xPNDVwaUtyeTNX?=
 =?utf-8?B?ZFFpQ1B6VXdIbmQzbVcxdUdyVGxiV05tRkhYYWl2QjJLdzNFNHptVmdxZWFv?=
 =?utf-8?B?aUNkSms3dWttdmQzd1NXMHBnZW9oeE1zdnlXOXgxM1Bhd2JPc1hWeExrWW5a?=
 =?utf-8?B?TTVPblVpU21Eekh3TS9BZ1ZVcm0rOHlDVSttNmZmQnJQM0E3R1QzRk5IVmc3?=
 =?utf-8?B?bElYOStJbEZTcWRMTG9hN2VrYWJGaXkwQkNoaVg1UDNxNnJmRUZWSi9tMGF1?=
 =?utf-8?B?WldPRkhtd2NhbkxuRlJuVThBSW5ZNmNGQVVsQk9WWWQwZDhQNUErREpvbXpI?=
 =?utf-8?B?Z2ZqYWp1bXJWOUtiYXgvKzFJNlVVYjZ4b2pWQ1F5WFBRUjJrbXRPcFA5eVIr?=
 =?utf-8?B?VnZScmdQbzlDVjZZcFp4M1Q3OTNCTzZER1pFd0MrMjlDWFM4NGI2TjFmU05X?=
 =?utf-8?B?QVFKRzNWemwzcnpPc1I1eVdVUnloWmZzUnc4UU5xUUlPMGNhVlpZQnoySFVH?=
 =?utf-8?B?blovcmxVRjNscm01UXhEcWh0MWNpMlJIdGZ5MlN4bzM2NEE3TG8rSjN6QTFX?=
 =?utf-8?B?bkM5L09tTGpKV1pWRUFNcjM0NUNqUVNpcG8zV3VUK2JycFM3TmZaYWpKRDJQ?=
 =?utf-8?B?bE5BV1Y0eDZtVWowODdkeGtDYXlLNzRJRGRPaTRjY3FiM0xjWUNSeTFCN2Zt?=
 =?utf-8?B?UkVsVjJ6N3BHTnVHZ3hmZkxvRUF6Q2VDUjNVM3RDTTlDZGdBTUU3bHZwd1Vj?=
 =?utf-8?B?MHBaZUxxMjdPc1FYcUtTKzJHZ0lZY20vdUwzOHo3amYvT3k0dHk4ODFYdlR3?=
 =?utf-8?B?TktZeG5zR0RrOXRKMXNzRlgyY0x4T3dWN0JSWG1hTGd5MnFEeG1lcHZEdUx5?=
 =?utf-8?B?SVBDMFc4TVN0UzdxTzAyc0loSHZJSFNqYm5mQ1k0WTNiYWRWSGxTZzBoYnpC?=
 =?utf-8?B?Z05JQWpvc3I2MTk4S3BNOVUrUVVEaVVTNTJxVm1ZNlNOeUhnSDR6Ry80bXVx?=
 =?utf-8?B?M1dmMThkdEpmMk5rVEVKakNrT3lCNDdoekNENWd6eHVIb29xSFFRSVZtR0Y0?=
 =?utf-8?B?U1lsRkl6U2FOaEl6WEF2M3dKQmFzcWRsVXhZSDB6Vmw3NmxJRU44ZU9TNFJV?=
 =?utf-8?B?R2RFRnh4YVYrVW9wb2E1WkZVdHFPWEtsakIxM1g4aGVCY0VjbWpzV3MraENq?=
 =?utf-8?B?SlVGUE5sdmNneHdIMGcwUkdUdm5Ma2lCdHlpYzM1Tk9Jd09ZUE45TjhQd3Ax?=
 =?utf-8?B?bmcySzd5RE5lTENoZVNOM0paaURic3dkQ2VmQWltOTlmelJ4VndJczdvckFz?=
 =?utf-8?B?N3o4ZjlHUHU2NlRxOXhCNzBXbXJmZVdRdFVhUWxDQzVlbmY2aUk2L3JuWHBq?=
 =?utf-8?B?TisxVUFWK1BVdy85Y1Z2WGVRVGlkTXN3NzhlQTJsS241MlVLMEl5SnpGRFdz?=
 =?utf-8?B?cFUybkpIUWw2Y2FFMFAxMUtRbWxuMi9kWFh3MHNxK2d4dVpVZjR2SU9YTFJ2?=
 =?utf-8?B?aTFmRW1XMnBVcU5rdkQ1Smsrd0ZZNkxZRjE2WmlEekZuekJKcU9mZm9HV2Vk?=
 =?utf-8?B?SEdWVnJHVUFaVDEzQVJGVUQ1dy9Hdkpha0ZMUENFMVpLUVMvc1FuUVM3ZmNq?=
 =?utf-8?B?dW5vcFdrRGZncGh4RE4xRlplTW9icElaSzUydTdvZmp5VGNHVG1iS0ZvSjgw?=
 =?utf-8?B?R1RzTGpRbDUvaUtRcnFrWVJKOU9rOGJPNTA4cWgzRjRGSFVLcWlCVlJ2TnF4?=
 =?utf-8?Q?inddcTw+LMG7Cp+aK1oyD7hPwshkFnkHTK2vpEB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d594067b-7c16-464a-2ec7-08d946658467
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:20:07.8254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ac9lhpgTGn+duxVPp2y4Ky2d0lJzhARq9+kJMC0Oss5e3wY1jHJo7MF5MLmLUdfesruXu8zFUBQEHvuhuYD+R/6ArzfLShqxHCCmYQe3eds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4802
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140004
X-Proofpoint-GUID: lAvtSv_ytM_TjKSa0bjY_SF8KHQxZLoy
X-Proofpoint-ORIG-GUID: lAvtSv_ytM_TjKSa0bjY_SF8KHQxZLoy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> 
> Add support for H3C P4408-Ma-8i-2GB device ID
>       VID_9005, DID_028F, SVID_193D and SDID_1108
>       VID_9005, DID_028F, SVID_193D and SDID_1109
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>



Acked-by:  John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index dcc0b9618a64..64ea4650ca10 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -8711,6 +8711,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       0x193d, 0x1107)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x193d, 0x1108)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x193d, 0x1109)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       0x193d, 0x8460)
> 

