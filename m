Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1707C4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 15:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FE961002
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 15:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbhHDPI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 11:08:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1708 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236467AbhHDPI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 11:08:27 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174F7ckj032719;
        Wed, 4 Aug 2021 15:08:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1E3bR43e0lfxw+DU7iz45tUaerqjTope1DrifCHcR/E=;
 b=SucYaq8U5jLpzV+1U2w49pP4S1vk7Je3l/M3SbYVwRAm3T6PttjDXJfi7maiUEpmJM7v
 m2+jRa8k2gGOFDgaKWS7t9pR7NWMuEk2sY2R21TCSs7f/KitK1NO8YfvobYCgSwO9rna
 0JaLc5m4dNpA4aDrFgV4t3L5h0tO49Y/Ec7L9Iw2ryHpwRdd3U6i5mQsuAowSG0Kg7rS
 wJVRqdDPme8sliW/T68fFyHHiBwZlcOLJkLzCOu6yM5mQcA0BEcC9wex4oUtphJtECpi
 W2VyBjMxc+r2uIy3XRGpW9CntnIXblosiH38733kjeJav1ETMFhb7FWmnqJUhkkSowXN NQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1E3bR43e0lfxw+DU7iz45tUaerqjTope1DrifCHcR/E=;
 b=kop4t29awlAvt5VMmU+6nQcLtzJLgkbmj7OdUE7w9h/RCXFlswSct2uiHTEaR8StQFvJ
 9THjN3qx5aPmYiU45dkSSvkyd2Egs19tOqU/hUnt13fEvwjtlYriez0iquX77OcC9OC8
 Rnk/cn3Y0Ly0CkoPehi+ahmnbYhYklHrAtG8eqFLUesa1lpnzQei93ku9oAwlf0Eh9MT
 7pqzJkAAvsD6yzmsM+OQLcYvN4qhGIlt/P7lEoPhLoDuq05MTwPaoEw3pmQ3GuYIbZYi
 A7zWqRUCdz8KgAEZGsyAweduXg1FNda5LnAAO88g5i+gxd6kSBZFpp34EOM1OIX0FDC9 jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0a91u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 15:08:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 174F5ROY061269;
        Wed, 4 Aug 2021 15:08:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3a5g9xbb1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 15:08:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyvfteqJnnk66VgnIFhmqZaOhh8iYtWHbRq2t0RTLMwts9zGherc8/hu1m6E1NHBiMazlEH3XeRBDeVqkLgJhRbRyR+KWIzHUdzwb5nwSkLDZaDfCDfj/QqRibRi5/ayPPMg3g8aXIeuPL4hapoLf4CtPZ9DJFiR9v0Fz6aGMTSwKnoGel+QeReKgS+rbpfF/GKLNkatCNjgN44UDEP47BifubH1J3+39rC0jzFjSeu+Xj7wTDlmwIjekMC24FphfiXOJdhvS9RuynRoznMyjMuyx+7OHZUxtXU8TuBa9coUHHA9Ef02cTAy363dx4ict0QthLUKF0iLHxdVTghWpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E3bR43e0lfxw+DU7iz45tUaerqjTope1DrifCHcR/E=;
 b=imtmhqjQJa0ifxBQgg/nPjIw5occ8L05OK6oHf/KvRoFh1i/AWKVn3cPA910IB6aW4OcX6UKYaGZc7uGBQAB3Fyg9AiRraUK7BMEj27syXMopcwe/Uu+Bcp7q66iKrHJxYtUbzY2AKhYNTt5EOmOUgMC5PG7E1hld6FNpt4noWLJqQP6unjLt3hkg+5GPc+oP5n4F1YocZJvjt01sKjuPNOhnd3UxBvEfztlbzidytmg2ZZaVi5OcseEmHnshSOsI27MTKe+ad6l0x5KoHHAS1yWWhUkeu6SgWHihis4q0fnWBR7fv0py7cH7p0rgBC2pB+kTHriy1lmn3TLVqMAKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E3bR43e0lfxw+DU7iz45tUaerqjTope1DrifCHcR/E=;
 b=OBB/KAopWUjPGewplqBu8p/PW5GOwnnBL+QU1/Ax63lLf/ulGS1xqSCwaaUSu8aaY32iNiq93LTRnm+W88rucmUDBLHUJOk4Igy6pAECjpeudksSKZhnOTyuy6FHCYUtu7eZG+/HVw5cmyBpyqTdGY96mQvm0Sjwn9Az2igODbQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN4PR10MB5542.namprd10.prod.outlook.com (2603:10b6:806:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 4 Aug
 2021 15:08:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 15:08:06 +0000
Subject: Re: [PATCH][next[next]] scsi: qla2xxx: Remove redundant
 initialization of variable num_cnt
To:     Colin King <colin.king@canonical.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210804131344.112635-1-colin.king@canonical.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <7ac5f319-fd4c-f2e0-e318-71a4d7661693@oracle.com>
Date:   Wed, 4 Aug 2021 10:08:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210804131344.112635-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0149.namprd05.prod.outlook.com
 (2603:10b6:803:2c::27) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SN4PR0501CA0149.namprd05.prod.outlook.com (2603:10b6:803:2c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Wed, 4 Aug 2021 15:08:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88a4768f-0d3c-4788-d327-08d95759aa11
X-MS-TrafficTypeDiagnostic: SN4PR10MB5542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN4PR10MB5542D7AE56B2B20240C673A1E6F19@SN4PR10MB5542.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UvD/ChHuhFUGt8Cl0qP5lfxwXivn2Hud+JieP4kHZZgDTGwRp0Ck91pMzoYN4C7H2VRt9FbAf5oxm+Fx2KkQZ6lCmxwx2JA5nbpG7g7aGhWmlbqQC0hUUJraPWvXURSDdABIlQGhyVoWQEmWiQNz1ME4YJMdBIBg04LLTGkTSU4m/PVXKc3OqOvV/R+LA33kmDi4cWDSXdNGhoo1kGdqdzKrJMItSwgMWRl9oIH2Zx85j0EBJDmuFqYgXx8Prrvx+8MeWPEDG0rc2YUJ2Ju1NDoh6Au1sg94X8KY18ES/IPvByyexs/b2MITFeikWczoFuP5oT/8Vkazsg4GX6SOxPzvTOWaeZ2yzOcPHI9VanIaNhaYnpWM96XoQbtEVMiPySWA7wKHNkaerr4jbh7yxaHW/4KQPMFB7/4PfxZPAndXcrOUhErCWgUhJSsPfvuJTHM2qDvQ127eJElBHVgpaBSJsRUk8X4BxoVnzgnNQIYONMdO0sRxnERXKZDjQZ6cBOminXy8zWbJ771wuXXDLwwxrXcRY5QrKKQaoyEga2YTaqqtzVwO1zzqwq8o0ty7QSqLhSj7UsdMf5nLU+GgbYNUaAi4bJ+vIEXwvwzBMe2Wpi3jybTr3CgRWHhgcRyp1wqR7fkP6YY4MPR3wz8Yy7vVaHyxJAaTEGeKCuFF9NjNv62kpXm0eCNZVhZ/3b/Rj07j3bjnWdnjZ7It9yCiDkfjltiYf+zTBqxXvsBj/lc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(16576012)(26005)(5660300002)(8676002)(956004)(31696002)(2616005)(86362001)(31686004)(66556008)(66476007)(186003)(6486002)(53546011)(478600001)(316002)(66946007)(4326008)(36756003)(8936002)(83380400001)(2906002)(38100700002)(44832011)(36916002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGpnQWFMUDlJVDdkZ1Fkb3E0aFZBMVNubnZlcnB2QnFYYnh2S1A0Q29DNC9L?=
 =?utf-8?B?VjQxTG90Y2NveitPMDBrT3M1bTFIV2daNGFRTk5HdjZLR3N5K0ZCRzBQNExZ?=
 =?utf-8?B?M3B3WW9GVkxmK3V1ekFvdW9VeTdhQWttc1R1L1FZc20xUE11WnV6aXp0SFpx?=
 =?utf-8?B?V1FwazJVWW9YVlEzOFRHUmlzQWcrL0J5M3FhN1dOSm9YVlFpK0paY1VCZkNS?=
 =?utf-8?B?bDlIYjdMbXZyZThwWklUdW4yZHMxVFIySmsycDhRNDN5dE1XUEsvY2U0QVV1?=
 =?utf-8?B?S0VwbG1sVzVyM1AxSkczSTIxTkdMZDlRUWFHU3piNVFmV3M5ZWJKaXF0aFhE?=
 =?utf-8?B?bTF6czdJTFpIYWtNbnFXN2l6a3o3cERCRzRPTk1FTUg4Qk8xaVFBTWRuSXVt?=
 =?utf-8?B?VmE2L3d4OHQxdmpBNUdPVC9XcldtakF5U1dyUGk0dTNBeWk0dGN0dGI0OUkw?=
 =?utf-8?B?M0hwcGRxeFJxYmFvMm5ra3dPWWo1bi9iRmx1TnFOampnQUdZM1hQNkdhT0N5?=
 =?utf-8?B?MXM0ZUNucHNLT0VEb3ZlYmZzK1pza3NCdXVnTjljaG1IVkhiOFd0VHZXckVF?=
 =?utf-8?B?QTk3YkwrbWRYVm5XN2dnakJISHVyZ3BXK05tSEJFRmFhdlFRQ2d0bWg1M0xp?=
 =?utf-8?B?NGpGam9hcHFTU2NBVUtPdXZPTnBqY2ZQb0REcms4ZC9DN0paV1orVzBJcVdx?=
 =?utf-8?B?cnByU2h3ME9JVXlUOVIwRU5HVjkwSUxwNkFTanlqWWNzUXpNc3hRL1JWQnpy?=
 =?utf-8?B?OGhNd0pTaFMzSXY5dTkwWWVoeUhnSjRLNGExQkE0a0d4VFZCb2ZlNUQ0UzJQ?=
 =?utf-8?B?a253Uk9YZjVjZHh0YmZhOTUzSWJBQ1BJVUZtYVpVZllicHBybHZ2RWRRNVNm?=
 =?utf-8?B?RUFWTGJLWVNJK003T0VuSyt4eUgyVEV3cHhTRkJiVkxyWDE0MndkSi9FODlX?=
 =?utf-8?B?TUl5U3BUTUxxUUJaWnZndU14c0NRcjdzZ2tuU25HK0IzQkZIOGJxZnJIQ09F?=
 =?utf-8?B?TnVhbFRHcGIzblJIdndsSmQxM3owejVxZDlGVmQrNVJ2aWxMKzR1UDB5ck9V?=
 =?utf-8?B?NVA3Mmd6MnpwZVdHZXdLSHU4Z1Q3SUdoWWNNcTN1cFV3R0xPbjJGTUN5Mndq?=
 =?utf-8?B?SlNlY0xzT2pRNDdSUDJKMFRkZGR4YURwTVM1NEN6b3NnTlVLdjByY053dERU?=
 =?utf-8?B?SS9VLy8rWFdham1WVll4OFBaQmVLQUJPMy9acTl6dGRQaTVPSGg0a3Q0ZU5E?=
 =?utf-8?B?akdmWVFwMTdCUXpYcTdrTzJCTTY1NlQ2dm85MGhGZGxZbDhWYmtrTk9LQXY4?=
 =?utf-8?B?WWkwV1F3OHpVdXhDSTdGd2xKNVZhR0RodXhmei9KbGNXZUFjc0tmaFJNSzhW?=
 =?utf-8?B?V3llQzNEdTdORjBFUFBES3I2Vnp0c2lSd0tjQVNSZDgwTElQVWZ6N25tZzdx?=
 =?utf-8?B?K0I5cmNjeDVmUXIwczlFZk15b3g4MlBKTlJYR1UvWjl0OHB6NTZpMlo2a3Ns?=
 =?utf-8?B?NEJ1VzdEZXAvOVRNcXplblVKM2tXRDlhN2c2MHFSZDliN0ljM0lZSFc3bDl1?=
 =?utf-8?B?V2JRcFJuZ0h1UDZSKy8xck9lK2Y2dUdUSWVTU0F6Y2Jid0l3OXNQYWozWk1M?=
 =?utf-8?B?Ly9ZYUt3VWgrY3pVcU9pQnFYMGpESTJjNkZzV0MrVDRLbFp2eFlEUGNuOVQy?=
 =?utf-8?B?cnpadFRENC9JaXV3bW5CRlN2SVZLaUNuZW9VejJka1dja2taaW8veDhIOGx2?=
 =?utf-8?Q?sfuO15NQVJ+D3c6dUUoSrGL19lwi6//nWw180aZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a4768f-0d3c-4788-d327-08d95759aa11
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 15:08:06.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6Q2zt21zAa0b57E1Ao5m6b8QfV3sydBTAJpEd8Zvs68zZm3ZENZY0VQmeTNp8jV0vwUDrCbQirelMP9ZKSp4xLYdyt/xs7QAJvg61mc+nU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5542
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040085
X-Proofpoint-ORIG-GUID: 19BxwP8XN50X5Lqz0RC9iXA0l6WC3AEF
X-Proofpoint-GUID: 19BxwP8XN50X5Lqz0RC9iXA0l6WC3AEF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 8/4/21 8:13 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable num_cnt is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/qla2xxx/qla_edif.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index fde410989c03..2db954a7aaf1 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -875,7 +875,7 @@ static int
>   qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>   {
>   	int32_t			rval = 0;
> -	int32_t			num_cnt = 1;
> +	int32_t			num_cnt;
>   	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
>   	struct app_pinfo_req	app_req;
>   	struct app_pinfo_reply	*app_reply;
> 

Looks Good.

(I am curious if that extra "next" in patch subject was a typo or some 
workflow added that)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
