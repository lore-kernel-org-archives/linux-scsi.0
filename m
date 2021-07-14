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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB73C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF37261370
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhGNBPd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:15:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6638 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237320AbhGNBPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:15:32 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E0u8WJ005650;
        Wed, 14 Jul 2021 01:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=gmSDj0Fq15neue2UpTLgdXyn+SLvIJc11+aAAeQQo/Y=;
 b=YgYUhzc2XRqWFY6sBBO+e7ChfEGr7N9A8JR3joQK6f/+ZEEo4u3I6qGCUIRm1hkr1cWN
 7aduzQ4h5UzOamnjw7+vQz3hK9viVxqo7+Ju4tVK61gDpk0toGBQgSC8jvPG8/82rgtd
 hszY3yPQejd0aGmVPSZin8078GDJktavplqQ2R/IRF7sPtHRDIrft4Cza6itaCBBjMuN
 GFbUJPvEN7WDqljQ8boe6b8hGHjbDH2DuSUpbPslbcRBzesokxWYJvMzyeWtj45Atg9F
 qr07Qz/GO0kSaOv07RoyhjvyXiUpapGSMe3nqMo8ZiveA9jPhm+4OFLqAEkSiTpVnaOa Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0unsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:12:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E0srEb139112;
        Wed, 14 Jul 2021 01:12:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 39qycxt1jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7AhB0YYwH/EzEg2eP23INGohq21DzDLvntjyJKEnz4rWIgMY6lt+yiNZ+nBtLWGN6nD6t6bA7zHWzURpt/9Ae0v+3Pyhj+TjjHo62exD11HJpeAx0f+tQ8GbNMsFLUMlm2ottZxAnMhcmpyH8+qSDKDt78J0iT/LuNIzguqYLcVUU0n1KcPI01gjmWz8de7Brdt9v0BE1Mo9M1BYlxwpoM9d+mbCnhPWm9NYUGQMtTLwqOEF64bZ614LxZhguOec/7tc9Xg49wWJnwJvLIk/t2Vlzz9XqePFNcpYoQv8Cc3HJyui/pBSii19qI37CM9qc2dH/U3WneM57cW+8NJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmSDj0Fq15neue2UpTLgdXyn+SLvIJc11+aAAeQQo/Y=;
 b=Ddp7E44pAc83CCld4Luq4NMj8lsI3zg3qDntrCVu1E18/BRT2FLNcE0A/c88/ZFVSZS9CTH6tYkwVw0opT9vGOpQagpzvDSlVwhRk0LjJypWALlMVl94Fuw7QIXH0HKTYba66o2K2udazubBqimvuu5/joPwdEjQ7v7bAx1Tl6gECPgk/YOAr/Ip0N5Ee/ps5W3RAJFuLsOcTuL2zdgtsPfyz7Sjz6j4EEILeOm5eOZ5BtAPty7RtfmoSv12lFbUwdQGfw4cTauP6hYWzU29rcC6rK7m7d3XpuxazFFgXyudY9v4phNhz4oGUWYVrG6FXboedsAuUUXunRJhwStRXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmSDj0Fq15neue2UpTLgdXyn+SLvIJc11+aAAeQQo/Y=;
 b=oBEMWQo9nGMk/DBP/PVTVX9qheNMVouqSyjbniTG+unuijq5TY+xYMCVCJabvOevz4kf7YAZVVvOQmE8REtkeg5yC6iCRMQyAbyf1rKwqme4tQavGEdh06g3DPltTejVE55kD8X7Jn171KbAoKtnRUrIr3zErTD+Xmu32f5Q2+k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB1629.namprd10.prod.outlook.com (2603:10b6:301:9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Wed, 14 Jul
 2021 01:12:03 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:12:03 +0000
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
Message-ID: <aafec933-84a0-bb2d-e1e8-0cf89605f62a@oracle.com>
Date:   Tue, 13 Jul 2021 20:11:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-2-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:0:54::22) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM3PR11CA0012.namprd11.prod.outlook.com (2603:10b6:0:54::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 01:12:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d9be5fe-8477-43aa-d3e5-08d9466463a5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1629A5E5B883C92BCCAD690EC7139@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjqBzuzFkaVsI07RfoEvcXqXBiJiPdMHYpsE1sCFeJ7D0dLmBipbB6EibtmpnG/4HzsRjpaXhFg+Bi45c7gbx2zLvhThNrQcoWewPWX29moHiPJ63sEDK7LfDAF4WUqytFecSaIoshUUdnSCCzBbeaeKgWC0k2E3DtJdwPANszIKV2+T9+6II26cuOdaT9WGyGsqs9r6Ycmm+pFgEVe1pYrca4Lq1h9MbHbEPDlrD1e8k/HnOdrtrsMH9PwZDCSlHHgVx8TgYg/DPoPSFfHgHEwPU+591QofZ0HKXq1O0eJyr5w9riQPfAss6aiubXVSDMbzliUEFpgoXpZrIDjl9uzBkB/stwVirlRkd8wIaGucno6b3hzaXfOYLCEQxb7qIeBkaybi0nq7BmrP3q2dbzAPzUF67IzSqXn+VNRrqYmkR8mCR0nk+kqypoh24JASMYEGN19FjRVleRdTZJJXPzk7+BnmrqPXYrjfu+5VNM2mDNgbv4T0FVgDrt1A1+8Mi7e7ue9NYoBlAW92w7ofEn5OyHr6/nYTtjijGt5Pd+G2M7S/zPitGA+U5XTwb1RoXbVuYop/mF5ET5scL1R/LvaMyxLmY5aIp/lunuKdNZ6udWEPhcjPSyZluTrJcMJQxjzNL9dgyAJ5XRmOnoFjiKHK8cc3ocvFXMVYm4noawq1uRbVVoru4C/twGelwlty8kV2gM+yO/EcfNoV+QThRNmfgr10YeJIFVAAffx/uCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(7416002)(4326008)(478600001)(2906002)(6666004)(66946007)(36756003)(16576012)(66476007)(66556008)(2616005)(956004)(86362001)(31696002)(38100700002)(31686004)(316002)(53546011)(26005)(8936002)(186003)(6486002)(8676002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFNQV3ZZWjRrL0hSMWFyakx2T21wTVh5bFZXYURtNHk1eHBZZFd1WXhEOGFr?=
 =?utf-8?B?RUlrMlNTT3hTY3JBamR0Q0NrTldGN3Rwdkd6Zit6S2JnM1B2OUxacGRGSlNm?=
 =?utf-8?B?MW03dWxTUjRZUEszeUk0TTVUNU5MalR5SEpPQ1lvRmtvRUR0aGV0S1RZTzg3?=
 =?utf-8?B?cmVsakZLM0FobjdrUnhwRFRPZWJSdk8rY255anR0TUlSVmJINkxrWml5c2xW?=
 =?utf-8?B?Y3pxaHovamI4M1pod2pzVGpIVDBHbzAyYWFkMjBzTDNTbWFRbnlyengrN2l0?=
 =?utf-8?B?cHR2KytTRUZZUVlDNE1lMWpjK2srUjl3SUFka20wZFRVQnRjalAvaWdVdzJP?=
 =?utf-8?B?enh1YUpQaHRTZFVmRm02QVJENDloUGI1a2trWmhjejJ2MmNKR0RMNVFWUDdP?=
 =?utf-8?B?dnRhcys4cGpndmRUYks5TkFjUmFucHVMbVZRRVRwVVUxOWRaOW14UlZZck1k?=
 =?utf-8?B?b0F1MElLV3NTemp6aWxxV0EzSFRHMGkxdlh0SngyZnBobVRicWh3TXh0WlNF?=
 =?utf-8?B?L2FRZXY1RjdVR1luS2pzVmgvVWRYaXYvV050OC9lM0lQeGNFNVdPYy9YckpC?=
 =?utf-8?B?UkpTNjdJMGJ1alVSVGsxSHdXT0EreUNxaDllOXV6dVZEZ3dFVHo5eVFoam1t?=
 =?utf-8?B?NGZDMEZ3dmZ2M0pCbCtTT2ZWMDBiNW5xRUQxTDgveTZZTWJTTWkwSEdmeGpL?=
 =?utf-8?B?S3NGWXpVd0hUZUZzV2tYUG9sSytIck5kSlBaanVBVlUxR0E3QlJuR0pUWXBq?=
 =?utf-8?B?bXpvR2VwbFB1YWFwdDhmM3VGVDEwVjNrZjdTQ0tNdXRiejZHcnpZSjhUbU5U?=
 =?utf-8?B?dHJwNGxUVWJTQjI2NWVxSVhSb3VFc3pRUFVvYmFsYkh1a0pxK1c1Tkd4QWp6?=
 =?utf-8?B?R1o1U3FERGkwNDdlaE9NczE1UXovQm1JWHhBMCtMajdXWGVNSVFGTFU1cDU1?=
 =?utf-8?B?TWQzb0pER0djcmF5U2hFVGlKQTlrM2gzVnhxRjhTdDlSQVdMSXdORjZwbWdW?=
 =?utf-8?B?YkZPUTZBck1CUitrbDc3WFN6WitnaUIrSUtta0JvNWc1a0N4OEpWRzN3U0ps?=
 =?utf-8?B?R21Cdlo4UnN4WUprZUZwUCtBZmNLVDd0NkFhNDRoTmU3bVJNYklrclVYZ1lP?=
 =?utf-8?B?ckp0KzlQKzlJS0JteU5sdkFnZENWdm9zaXlEbmlWUFRrbllXY3lFcE5rL1Yy?=
 =?utf-8?B?UEMwYXowVTdZY1hSa29wODY5bWJQZ29yNnBrbmhoL3UyT3ZyTzloMm0vQ05U?=
 =?utf-8?B?ZzlIazZQcFUyN3FYYTBQbHFhY1lORFI1Umx2WitheHhpa0tCSkJENElxNHNn?=
 =?utf-8?B?TERMUTlQc0ZjaGRDdnNCOFRLTjEvbDhDaGNuQ0tTL21GSVd6VW5DZThYU0Zz?=
 =?utf-8?B?VEt6Q1oxc3JaYTMzNjBneER0Y0RwNjR0alYyUExrOTlEenhzeFExbDhvdEJ1?=
 =?utf-8?B?b2loeC82emZzMUpwL1lrN0lmVTl0YzBkSStiUVR3Nk04cWczRGgyMU5NdWo3?=
 =?utf-8?B?NmwvUm9PRStDY29RWndyRzhrSDl2YjM3QXRPeHV1UnFzY25OV0dkbFV1L1py?=
 =?utf-8?B?K29BUEFMazNVYUNISCs4ZUtTTWRDaE8va0dvQ3luVzFkT3UrRHVXMU9YZktu?=
 =?utf-8?B?NENUbGNkRnBTcHVkMTRubnJUM29MREVUL2ZKNk94STE0cXpyZE10T0pDL2d4?=
 =?utf-8?B?c0xvbDh3V3Q0L0g4SENUNEk2WVhDRHdrMm5aeXFQV3VUUjFHR0E2NUtWTUVz?=
 =?utf-8?Q?wchYZaD2KB3Qm/Sxz144UhBHawCB6dZMO0NcNGy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9be5fe-8477-43aa-d3e5-08d9466463a5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:12:03.5019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7R4WEuV3dalE+36P3t1I+4924wiAeVmap0mVjx3lCa+Un5Bq9kpYPnUcc6wwbgTX6AqOFY/JboP0FREhChGq2MDdUUm6NgEgjmFx6VtBLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140003
X-Proofpoint-GUID: MUDTYUyotdlMqaR4MJEcDPcuZjUBAYsK
X-Proofpoint-ORIG-GUID: MUDTYUyotdlMqaR4MJEcDPcuZjUBAYsK
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

  John Donnelly <john.p.donnelly@oracle.com>

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

